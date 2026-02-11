import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;
int fftsize;

float V1, V2, V3;

float gain;
int mode;

int flashcol;
int detect_max_V;
int colour, colour_past;
boolean rainbow_pushed;

/* mode 0 */
float[] maxdelayV, maxV;

/* mode 1 */
int rectcol;

/* mode 2 */
int ranges;
float defleng, lengV;
float[] sumV;  //integration of the spectrum
float[] lengthV;
float[] omega_V;
float[] theta_V;

/* mode 3 */
int bn;
float[] sumsumV;
float[] msumsumV;
float[] somega_V;
float[] stheta_V;

void setup()
{
  size(600, 600);
  stroke(0);
  frameRate(20);
  background(0);
  surface.setTitle("Acoustic FFT");

  gain = 10;
  mode = 0;

  flashcol = 0;
  detect_max_V = 0;
  colour = 4;
  colour_past = colour;
  rainbow_pushed = false;
  rectcol = 0;
  
  ranges = 32;
  sumV = new float[ranges];
  lengthV = new float[ranges];
  omega_V = new float[ranges];
  theta_V = new float[ranges];
  defleng = 0.2;
  lengV = defleng;
  
  bn = 8;
  sumsumV = new float[ranges/bn];
  msumsumV = new float[ranges/bn];
  somega_V = new float[ranges/bn];
  stheta_V = new float[ranges/bn];
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO);

  fft = new FFT(in.bufferSize(), in.sampleRate());
  println("sampling rate is " +in.sampleRate());
  println("spec size is " +fft.specSize());
  println("bandwidth is: " +fft.getBandWidth());    //最小単位の帯域

  fftsize = fft.specSize();
  maxV = new float[fft.specSize()+1];
  maxdelayV = new float[fft.specSize()+1];
}

void draw()
{
  if (fft != null) {

    fill(0, (mode==0)? 128:255);
    noStroke();
    rect(0, 0, width, height);

    try {
      fft.forward(in.mix);
    }
    catch(Exception e) {
      System.exit(0);
    }
    
    for (int j=0; j <ranges; j++) {
      sumV[j]=0;
    }
    
    for (int i = 0; i < fftsize/2; i++)
    {
      V1 = fft.getBand(i)*gain;
      V2 = fft.getBand(i+1)*gain;
      V3 = fft.getBand(i+2)*gain;
      
      for (int j=0; j <ranges; j++) {
        if (((fftsize/2)/ranges)*j<=i && ((fftsize/2)/(float)ranges)*(j+1)>i) {
          sumV[j]+=V1;
        }
      }
      
      if (maxV[i] < V1) {
        maxV[i] = V1;
        detect_max_V = 1;
      } else {
        detect_max_V = 0;
      }
      if (maxdelayV[i] < V1) {
        maxdelayV[i] = V1;
      }

      colour+=(rainbow_pushed&&i==0&&frameCount%2==0)? ((colour < 6)? 1:-5):0;

      if (mode==0) {
        strokeColor(colour, 50);
        line(width/2 + maxV[i] +2, height-i*2-40, width/2 + maxV[i+1]+2, height-(i+1)*2-40);
        line(width/2 - maxV[i] -1, height-i*2-40, width/2 - maxV[i+1] -2+((i < fft.specSize ()-1)? 1:0), height-(i+1)*2-40);
        
        strokeColor(detect_max_V*6+colour, 255);
        line(width/2 + V1, height-i*2-40, width/2 - V1+((V1 > 0)? 1:0), height-i*2-40);
        point(width/2 + maxdelayV[i]+2, height-i*2-40);
        point(width/2 - maxdelayV[i]-2+((maxdelayV[i] > 0)? 1:0), height-i*2-40);
        
        if ((V2-V1>20)&&(V2-V3>20)) {
          noStroke();
          switch(flashcol) {
          case 1:
            fill(#FF0000);
            break;
          case 2:
            fill(#00FF00);
            break;
          case 3:
            fill(#0000FF);
            break;
          case 4:
            fill(#00FFFF);
            break;
          case 5:
            fill(#FF00FF);
            break;
          case 6:
            fill(#FFFF00);
            break;
          default:
            fill(#000000);
          }
          flashcol++;
          if (flashcol==6) {
            flashcol=0;
          }

          rect(width/2-7, height-i*2-43, 15, 3);
          rect(width/2-107, height-i*2-43, 15, 3);
          rect(width/2+93, height-i*2-43, 15, 3);
          
        }
        if (maxdelayV[i] > 0) {
          maxdelayV[i]-=3;
        } else {
          maxdelayV[i]=0;
        }
      } else if (mode==1) {
        noFill();
        rectcol = (V1*5<255)? (int)V1*5:255;
        strokeColor(detect_max_V*6+colour, rectcol);
        rect(width/2-(i-2), height/2-(i-2), (i-2)*2, (i-2)*2);
      } else {
      }
    }

    if (mode==2) {
      noFill();
      for (int j=0; j <ranges; j++) {
        omega_V[j]+=sumV[j]/1000;
        theta_V[j]+=omega_V[j];
        lengV=defleng*(j+1)*sumV[j];
        /*        strokeWeight(4);
         stroke(0);
         line(width/2-lengV*cos(theta_V[j]), height/2+lengV*sin(theta_V[j]), width/2+lengV*cos(theta_V[j]), height/2-lengV*sin(theta_V[j]));
         */
        strokeWeight(2);
        strokeColor(j%12+1, 255);
        line(width/2-lengV*cos(theta_V[j]), height/2+lengV*sin(theta_V[j]), width/2+lengV*cos(theta_V[j]), height/2-lengV*sin(theta_V[j]));
        omega_V[j]*=(omega_V[j]>0.1)? 0.1:1;
        strokeWeight(1);
      }
    }

    if (mode==3) {
      noFill();

      for (int j=0; j <ranges; j++) {
        for (int k=0; k<ranges; k++) {
          if (k>j*bn && k < (j+1)*bn) {
            sumsumV[j/bn]+=sumV[k];
          }
        }
        msumsumV[j/bn]+=sumsumV[j/bn];
        somega_V[j/bn]+=sumsumV[j/bn]*sumsumV[j/bn]/1000000;
        stheta_V[j/bn]+=somega_V[j/bn];
        strokeWeight(2);
        strokeColor(j%12+1, 255);
        ellipse(width/2, height/2, msumsumV[j/bn]/2, msumsumV[j/bn]/2);
        line(width/2, height/2, width/2+msumsumV[j/bn]*cos(stheta_V[j/bn])/4, height/2-msumsumV[j/bn]*sin(stheta_V[j/bn])/4);
        strokeWeight(1);
        msumsumV[j/bn]*=(msumsumV[j/bn]>1)? 0.1:1;
        sumsumV[j/bn]=0;
        somega_V[j/bn]*=(msumsumV[j/bn]>25)? 0.01:1;
      }
    }
    fill(#FFFFFF);
    text(String.format("Gain:%.0f", gain), width-75, height-10);
  }
}

void stop()
{
  in.close();
  minim.stop();
  super.stop();
}

void keyPressed() {
  try {
    if (keyCode == UP) {
      gain+=5;
    } else if (keyCode == DOWN) {
      gain-= 5;
      if (gain < 0) {
        gain = 0;
      }
    } else if (keyCode == RIGHT) {
      colour+=(colour < 6)? 1:-5;
    } else if (keyCode == LEFT) {
      colour-=(colour > 1)? 1:-5;
    } else if (key == 'c') {
      if (!rainbow_pushed) {
        colour_past = colour;
      } else {
        colour = colour_past;
      }
      rainbow_pushed=!rainbow_pushed;
    } else if (key == 'm') {
      mode++;
      if (mode>3) {
        mode=0;
      }
    } else if (key == 'o') {
      if (in!=null) {
        in.close();
      }
      setup();
    } else {
      for (int i = 0; i <fftsize; i++) {
        maxV[i] = 0;
        maxdelayV[i] = 0;
      }
    }
  }
  catch(Exception e) {
    System.exit(0);
  }
  
}

void strokeColor(int state, int val) {
  switch(state) {
  case 1:
    stroke(val, 0, 0);
    break;
  case 2:
    stroke(0, val, 0);
    break;
  case 3:
    stroke(0, 0, val);
    break;
  case 4:
    stroke(0, val, val);
    break;
  case 5:
    stroke(val, 0, val);
    break;
  case 6:
    stroke(val, val, 0);
    break;
  case 7:
    stroke(0, val, val);
    break;
  case 8:
    stroke(val, 0, val);
    break;
  case 9:
    stroke(val, val, 0);
    break;
  case 10:
    stroke(val, 0, 0);
    break;
  case 11:
    stroke(0, val, 0);
    break;
  case 12:
    stroke(0, 0, val);
    break;
  default:
    stroke(0, 0, 0);
  }
}
