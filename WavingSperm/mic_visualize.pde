import ddf.minim.*;  //minimライブラリのインポート

Minim minim;  //Minim型変数であるminimの宣言
int waveH = 100;  //波形の高さ

File selection;
AudioPlayer in;  //サウンドデータ格納用の変数
boolean loaded = false;

float[] cursor;
int cursor_buff = 3;
int cursor_refs = 10;

void setup()
{
  size(1200, 200);
  frameRate(30);

  cursor = new float[cursor_buff];
  selectInput("Select a file to process:", "fileSelected");
}

void re_setup() {
  selectInput("Select a file to process:", "fileSelected");
}

void draw()
{
  background(0);
  stroke(50);
  line(88, 100, 1108, 100);
  stroke(255);
  //波形を描く
  //left.get()とright.get()が返す値は-1から+1なので、見やすくするために、
  //waveH（初期値は100）を掛けている。
  if (loaded) {
    for (int i = 0; i <in.bufferSize()-1; i++)
    {
      float x = i+88;
      float y = 100 + in.mix.get(i)*waveH;
      float h = 3*i/(float)(in.bufferSize()-1);
      line(x, y-h, x, y+h);  //音声の波形を画面上に描く
    }
    float cursor_y = 0;
    cursor[0]=0;
    for(int i=0; i<cursor_refs; i++){
     cursor[0] += in.mix.get(in.bufferSize()-2-i);
    }
    cursor[0]/=cursor_refs;
    for (int i = 0; i <cursor_buff-1; i++) {
      cursor_y+=cursor[i];
    }
    for (int i = cursor_buff-2; i>-1; i--) {
      cursor[i+1]=cursor[i];
    }
    ellipse(1150, cursor_y/cursor_buff*waveH+100, 58, 40);
    ellipse(1138, cursor_y/cursor_buff*waveH+100, 50, 35);
  }
}

void stop()
{
  in.close();
  minim.stop();

  super.stop();
}



void fileSelected(File selection) {
  this.selection = selection;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    surface.setTitle(selection.getName());

    minim = new Minim(this);

    in = minim.loadFile(selection.getAbsolutePath(), 1024);
    in.loop();

    println("sampling rate is " +in.sampleRate());
    loaded=true;
  }
}

void keyPressed() {
  if (key == 'o') {
    if (in!=null) {
      in.close();
    }
    re_setup();
  }
}
