
//Import video to extract lyre notes
//adjust sensor variable and fit sensor to lyre button

//use ytb.rip etc to download video.


import processing.video.*;

//CHANGE THESE
String movieName = "TeyvatChapter.mp4";

int sensorLeft = 132;//132  sensor position in video
int sensorTop = 221;////221 sensor button press in video
int sensorBottom = 39;//39


//----------------------------

int guide = 12;//22   frame/segment
int guideCd = 100000;





int fc = 0;//instead of fc

boolean pause = false;

int noteTop=0;//note diplay position
int noteBottom=200;

char[] noteTable = {'Z', 'X', 'C', 'V', 'B', 'N', 'M', 
                    'A', 'S', 'D', 'F', 'G', 'H', 'J', 
                    'Q', 'W', 'E', 'R', 'T', 'Y', 'U'};


Movie movie;
ArrayList<Note> notes = new ArrayList<Note>();
ArrayList<Guide> guides = new ArrayList<Guide>();
int[] cd = new int[3*7];

void setup(){
  size(640, 360);
  movie = new Movie(this, movieName);
  
  //movie.loop();
  movie.play();
  movie.speed(1.75);//1.75
  //movie.jump(200);
}

//void movieEvent(Movie m) {
//  m.read();
//}

void keyPressed(){
  if(key == ' ')pause = !pause;
  if(key == 's')saveNotes();
}

void saveNotes(){
  ArrayList<String> strs = new ArrayList<String>();
  for(Note note : notes){
    strs.add(note.time+" "+note.pitch);
  }
  println(strs.size());
  saveStrings("notes.txt", strs.toArray(new String[strs.size()]));
}

void draw(){
  
  if(pause){movie.pause(); return;}
  else{movie.play();};
  
  fc++;

  if (movie.available()) {
    movie.read();
  }
  image(movie, 0, 0, width, height);
  
  
  
  
  
  
  
  for(int i=0; i<7; i++){
    for(int j=0; j<3; j++){
      int x = (int)map(i, 0, 6, sensorLeft, width-sensorLeft);
      int y = (int)map(j, 0, 2, height-sensorBottom, sensorTop);
      
      color c1 = get(x, y);
      color c2 = get(x, y+26);
      color c3 = get(x+13, y+13);
      color c4 = get(x-13, y+13);
      color c = lerpColor(lerpColor(c1, c2, 0.5), lerpColor(c3, c4, 0.5), 0.5);
      //fill(c);
      fill(255);
      if(red(c) < 200 && green(c) > 200 && blue(c) > 200){
        fill(255, 0, 0);
        if(cd[i+j*7] <= 0){cd[i+j*7] = 5;notes.add(new Note(fc, i+j*7));}
      }
      
      
      ellipse(x, y+13, 40, 40);
      ellipse(x, y, 5, 5);//sensor point
      ellipse(x, y+26, 5, 5);//sensor point
      ellipse(x+13, y+13, 5, 5);//sensor point
      ellipse(x-13, y+13, 5, 5);//sensor point
      
    }
  }
  
  fill(255);
  rect(0, 0, width, noteBottom);
  
  for(int i=0; i<cd.length; i++)cd[i]--;
  
  stroke(0, 50);
  if(guideCd <= 0){
    guideCd = guide;
    guides.add(new Guide(fc));
  }
  guideCd--;
  //for(int i=0; i<width; i+=guide){
  //  int x = i+(fc)%guide;
  //  line(x, noteBottom, x, noteTop);
  //}
  
  
  fill(0);
  for(Note note : notes){
    note.show();
  }
  
  for(Guide guide : guides){
    guide.show();
  }
  
  
  
  
  for(int i=0; i<3*7; i++){
    int y = (int)map(i, 0, 3*7-1, noteBottom, noteTop);
    line(0, y, width, y);
  }
  stroke(0);
}

class Guide{
  int time;
  
  Guide(int time){
    this.time = time;
  }
  
  void show(){
    if(fc-time < 0 || fc-time > width)return;
    int x = width-(fc-time);
    line(x, noteBottom, x, noteTop);
  }
}

class Note{
  int time;
  int pitch;
  
  Note(int time, int pitch){
    this.time = time;
    this.pitch = pitch;
    guideCd = 0;
  }
  
  void show(){
    if(fc-time < 0 || fc-time > width)return;
    //line(fc-time, noteTop, fc-time, noteBottom);
    int x = width-(fc-time);
    float y = map(pitch, 0, 3*7-1, noteBottom, noteTop);
    ellipse(x, y, 10, 10);
    text(noteTable[pitch], x+5, y);
  }
}
