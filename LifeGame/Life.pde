boolean pc[][];
boolean nc[][];
int w,h,cnt,gen;
int s = 1;
int mode = 0;
int modemax = 4;
String modeName = "GLIDER";
boolean ks;

void setup(){
  size(500,500);
  frameRate(20);
  gen = 0;
  ks = false;
  w = width/s;
  h = height/s;
  pc = new boolean[w][];
  nc = new boolean[w][];
  for(int i=0; i<w; i++){
    pc[i] = new boolean[h];
    nc[i] = new boolean[h];
  }
}

void draw(){
  noStroke();
  fill(#380000);
  rect(0,0,width,height);
  fill(#ffff99);
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      if(pc[i][j]){
        rect(i*s,j*s,s,s);
      }else{
      }
    }
  }
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      cnt=0;
      if((0<i)&&(i<w-1)&&(0<j)&&(j<h-1)){
        cnt+=((pc[i+1][j])? 1:0)+((pc[i+1][j-1])? 1:0)+((pc[i][j-1])? 1:0)+((pc[i-1][j-1])? 1:0)+((pc[i-1][j])? 1:0)+((pc[i-1][j+1])? 1:0)+((pc[i][j+1])? 1:0)+((pc[i+1][j+1])? 1:0);
      }else if((i==0)&&(j==0)){
        cnt+=((pc[i][j+1])? 1:0)+((pc[i+1][j+1])? 1:0)+((pc[i+1][j])? 1:0);
      }else if((i==0)&&(j==h-1)){
        cnt+=((pc[i+1][j])? 1:0)+((pc[i+1][j-1])? 1:0)+((pc[i][j-1])? 1:0);
      }else if((i==w-1)&&(j==h-1)){
        cnt+=((pc[i][j-1])? 1:0)+((pc[i-1][j-1])? 1:0)+((pc[i-1][j])? 1:0);
      }else if((i==w-1)&&(j==0)){
        cnt+=((pc[i][j+1])? 1:0)+((pc[i-1][j+1])? 1:0)+((pc[i-1][j])? 1:0);
      }else if((i==0)&&(j!=0)&&(j!=h-1)){
        cnt+=((pc[i][j+1])? 1:0)+((pc[i+1][j+1])? 1:0)+((pc[i+1][j])? 1:0)+((pc[i+1][j-1])? 1:0)+((pc[i][j-1])? 1:0);
      }else if((j==h-1)&&(i!=0)&&(i!=w-1)){
        cnt+=((pc[i+1][j])? 1:0)+((pc[i+1][j-1])? 1:0)+((pc[i][j-1])? 1:0)+((pc[i-1][j-1])? 1:0)+((pc[i-1][j])? 1:0);
      }else if((i==w-1)&&(j!=0)&&(j!=h-1)){
        cnt+=((pc[i][j-1])? 1:0)+((pc[i-1][j-1])? 1:0)+((pc[i-1][j])? 1:0)+((pc[i-1][j+1])? 1:0)+((pc[i][j+1])? 1:0);
      }else if((j==0)&&(i!=0)&&(i!=w-1)){
        cnt+=((pc[i-1][j])? 1:0)+((pc[i-1][j+1])? 1:0)+((pc[i][j+1])? 1:0)+((pc[i+1][j+1])? 1:0)+((pc[i+1][j])? 1:0);
      }else{
      }
      nc[i][j] = (pc[i][j])? (cnt==2)||(cnt==3):(cnt==3);
    }
  }
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      pc[i][j] = nc[i][j];
    }
  }
  fill(255,200);
  rect(0,h*s-15,140,15);
  rect(w-140,h*s-15,140,15);
  fill(0);
  text("GENERATION:"+gen,2,h*s-2);
  text("MODE:"+modeName,w-138,h*s-2);
  gen++;
}

void keyPressed(){
  if(key=='r'){
    for(int i=0; i<w; i++){
      for(int j=0; j<h; j++){
        pc[i][j] = false;
      }
    }
    gen = 0;
  }else if(key==CODED){
    if(keyCode==UP){
      mode+=(mode<modemax)? 1:0;
    }else if(keyCode==DOWN){
      mode-=(mode>0)? 1:0;
    }else{
    }
    switch(mode){
    case 0:
      modeName = "GLIDER";
      break;
    case 1:
      modeName = "GALAXY";
      break;
    case 2:
      modeName = "DONGURI";
      break;
    case 3:
      modeName = "GLIDER GUN";
      break;
    case 4:
      modeName = "DOT";
      break;
    default:
      break;
    }
  }else{
    if(!ks){
      noLoop();
      ks = true;
    }else{
      loop();
      ks = false;
    }
  }
}

void mousePressed(){
  switch(mode){
    case 0:
      glider(mouseX-2, mouseY-2);
      break;
    case 1:
      galaxy(mouseX-2,mouseY-2);
      break;
    case 2:
      donguri(mouseX-6,mouseY-4);
      break;
    case 3:
      gliderGun(mouseX-36,mouseY-10);
      break;
    case 4:
      dott(mouseX, mouseY);
      break;
    default:
      break;
  }
}

void galaxy(int x, int y){
  if((x>=4)&&(y>=4)&&(x<=w-5)&&(y<=h-5)){
    pc[x-4][y-4] = true;
    pc[x-4][y-3] = true;
    pc[x-4][y-2] = true;
    pc[x-4][y-1] = true;
    pc[x-4][y] = true;
    pc[x-4][y+1] = true;
    pc[x-3][y-4] = true;
    pc[x-3][y-3] = true;
    pc[x-3][y-2] = true;
    pc[x-3][y-1] = true;
    pc[x-3][y] = true;
    pc[x-3][y+1] = true;
    
    pc[x-4][y+4] = true;
    pc[x-3][y+4] = true;
    pc[x-2][y+4] = true;
    pc[x-1][y+4] = true;
    pc[x][y+4] = true;
    pc[x+1][y+4] = true;
    pc[x-4][y+3] = true;
    pc[x-3][y+3] = true;
    pc[x-2][y+3] = true;
    pc[x-1][y+3] = true;
    pc[x][y+3] = true;
    pc[x+1][y+3] = true;
    
    pc[x+4][y+4] = true;
    pc[x+4][y+3] = true;
    pc[x+4][y+2] = true;
    pc[x+4][y+1] = true;
    pc[x+4][y] = true;
    pc[x+4][y-1] = true;
    pc[x+3][y+4] = true;
    pc[x+3][y+3] = true;
    pc[x+3][y+2] = true;
    pc[x+3][y+1] = true;
    pc[x+3][y] = true;
    pc[x+3][y-1] = true;
    
    pc[x+4][y-4] = true;
    pc[x+3][y-4] = true;
    pc[x+2][y-4] = true;
    pc[x+1][y-4] = true;
    pc[x][y-4] = true;
    pc[x-1][y-4] = true;
    pc[x+4][y-3] = true;
    pc[x+3][y-3] = true;
    pc[x+2][y-3] = true;
    pc[x+1][y-3] = true;
    pc[x][y-3] = true;
    pc[x-1][y-3] = true;
  }else{
  }
}

void glider(int x, int y){
  if((x>=0)&&(y>=0)&&(x<=w-3)&&(y<=h-3)){
    pc[x][y] = true;
    pc[x+1][y] = true;
    pc[x+2][y] = true;
    pc[x][y+1] = true;
    pc[x+1][y+2] = true;
  }else{
  }
}

void donguri(int x, int y){
  if((x>=0)&&(y>=0)&&(x<=w-7)&&(y<=h-3)){
    pc[x+1][y]=true;
    pc[x+3][y+1]=true;
    pc[x][y+2]=true;
    pc[x+1][y+2]=true;
    pc[x+4][y+2]=true;
    pc[x+5][y+2]=true;
    pc[x+6][y+2]=true;
  }
}

void gliderGun(int x, int y){
  if((x>=-1)&&(y>=-1)&&(x<=w-37)&&(y<=h-10)){
    pc[x+1][y+5]=true;
    pc[x+1][y+6]=true;
    pc[x+2][y+5]=true;
    pc[x+2][y+6]=true;
    pc[x+11][y+5]=true;
    pc[x+11][y+6]=true;
    pc[x+11][y+7]=true;
    pc[x+12][y+4]=true;
    pc[x+12][y+8]=true;
    pc[x+13][y+3]=true;
    pc[x+13][y+9]=true;
    pc[x+14][y+3]=true;
    pc[x+14][y+9]=true;
    pc[x+15][y+6]=true;
    pc[x+16][y+4]=true;
    pc[x+16][y+8]=true;
    pc[x+17][y+5]=true;
    pc[x+17][y+6]=true;
    pc[x+17][y+7]=true;
    pc[x+18][y+6]=true;
    pc[x+21][y+3]=true;
    pc[x+21][y+4]=true;
    pc[x+21][y+5]=true;
    pc[x+22][y+3]=true;
    pc[x+22][y+4]=true;
    pc[x+22][y+5]=true;
    pc[x+23][y+2]=true;
    pc[x+23][y+6]=true;
    pc[x+25][y+1]=true;
    pc[x+25][y+2]=true;
    pc[x+25][y+6]=true;
    pc[x+25][y+7]=true;
    pc[x+35][y+3]=true;
    pc[x+35][y+4]=true;
    pc[x+36][y+3]=true;
    pc[x+36][y+4]=true;
  }else{
  }
}


void dott(int x, int y){
  if((x>=0)&&(y>=0)&&(x<=w-1)&&(y<=h-1)){
    pc[x][y]=true;
  }else{
  }
}

void rand(){
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      pc[i][j] = (int)random(2)==0;
    }
  }
}
