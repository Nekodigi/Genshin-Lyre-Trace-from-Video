import processing.video.*;

String movieName = "movie.mp4";

float tempoOffset = 10;
float tempo = 21;//frame/segment




boolean pause = false;


int noteTop=0;//note diplay position
int noteBottom=200;

int sensorLeft = 132;//sensor position in video
int sensorTop = 221;////sensor button press in video
int sensorBottom = 39;
int fc = 0;//instead of fc


Movie movie;
ArrayList<Note> notes = new ArrayList<Note>();
int[] cd = new int[3*7];

void setup(){
  size(640, 360);
  movie = new Movie(this, movieName);
  movie.loop();
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed(){
  if(key == ' ')pause = !pause;
}

void draw(){
  
  if(pause)return;
  
  fc++;

  image(movie, 0, 0, width, height);
  
  fill(255);
  rect(0, 0, width, noteBottom);
  
  
  
  
  
  for(int i=0; i<7; i++){
    for(int j=0; j<3; j++){
      int x = (int)map(i, 0, 6, sensorLeft, width-sensorLeft);
      int y = (int)map(j, 0, 2, height-sensorBottom, sensorTop);
      //ellipse(x, y, 5, 5);//sensor point
      color c = get(x, y);
      //fill(c);
      fill(255);
      if(red(c) < 170 && green(c) > 200 && blue(c) > 200){
        fill(255, 0, 0);
        if(cd[i+j*7] <= 0){cd[i+j*7] = 5;notes.add(new Note(fc, i+j*7));}
      }
      ellipse(x, y+13, 40, 40);
    }
  }
  
  for(int i=0; i<cd.length; i++)cd[i]--;
  
  fill(0);
  for(Note note : notes){
    note.show();
  }
  
  stroke(0, 50);
  for(int i=0; i<width; i+=tempo){
    float x = i+(fc+tempoOffset)%tempo;
    line(x, noteBottom, x, noteTop);
  }
  
  for(int i=0; i<3*7; i++){
    int y = (int)map(i, 0, 3*7-1, noteBottom, noteTop);
    line(0, y, width, y);
  }
  stroke(0);
}



class Note{
  int time;
  int pitch;
  
  Note(int time, int pitch){
    this.time = time;
    this.pitch = pitch;
  }
  
  void show(){
    //line(fc-time, noteTop, fc-time, noteBottom);
    ellipse(fc-time, map(pitch, 0, 3*7-1, noteBottom, noteTop), 10, 10);
  }
}
