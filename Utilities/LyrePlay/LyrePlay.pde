import themidibus.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import javax.sound.midi.*;



SineWave [] sines = new SineWave [20];//SineWave, SquareWave, TriangleWave, SawWave, PulseWave 
int[] duration = new int[20];
int[] notemap = {3,5,7,8,10,12,14,15};
ArrayList<Note> notes = new ArrayList<Note>();

int noteTop=0;//note diplay position
int noteBottom=500;

Minim minim;
AudioOutput out;

MidiBus myBus; // The MidiBus

void setup(){
  size(2000, 500);
  
  MidiBus.list();
  myBus = new MidiBus(this, 0, 3);
  
  minim = new Minim(this);
  out = minim.getLineOut(Minim.MONO);
  for(int i=0; i<sines.length; i++){
    sines[i] = new SineWave (110*pow(pow(2, 1./12), notemap[i%7]+i/7*12), 0.2, out.sampleRate());
    sines[i].setAmp(0);
    sines[i].portamento(1);
    out.addSignal(sines[i]);
  }
  
  String[] strs = loadStrings("notes.txt");
  
  for(String note : strs){
      String[] noteData = note.split(" ");
      int time = int(noteData[0]);
      int pitch = int(noteData[1]);
      if(pitch < 20)notes.add(new Note(time, pitch));
    }
    
    //change instrument
    ShortMessage sm = new ShortMessage();
      try{
      sm.setMessage(ShortMessage.PROGRAM_CHANGE, 0, 0, 0); //channel, instrument,    0 ==> is the channel 1.
      }catch(Exception e){}

      myBus.sendMessage(sm);
}

void draw(){
  
  background(255);
  fill(0);
  for(Note note : notes){
    if(note.time == frameCount){
      //sines[note.pitch].setAmp(0.1);
      myBus.sendNoteOn(0, 36+notemap[note.pitch%7]+note.pitch/7*12, 128); 
      
      duration[note.pitch] = 60;
    }
  }
  
  for(int i=0; i<sines.length; i++){
    if(duration[i] < 0){
      sines[i].setAmp(0);
      myBus.sendNoteOff(0, 36+notemap[i%7]+i/7*12, 0);
    }
    duration[i]--;
  }
  
  for(Note note : notes){
    note.show();
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
    if(frameCount-time < 0 || frameCount-time > width)return;
    //line(fc-time, noteTop, fc-time, noteBottom);
    int x = width-(frameCount-time);
    float y = map(pitch, 0, 3*7-1, noteBottom, noteTop);
    ellipse(x, y,20, 20);
  }
}
