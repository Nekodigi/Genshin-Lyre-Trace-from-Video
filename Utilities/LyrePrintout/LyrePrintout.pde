//300 dpi -> 150dpi because too big
//A4
//2480px X 3508

int baseTimeOffset = 100;
float timeScale = 2;
int printSpacingY = 10;
int printSpacingX = 50;
int sheetWide = 408;//69.5mm x dpi
int sheetSpacing = 38;//6.5mm

int pages = 5;

int xmin;
int xmax;
int ymin;
int ymax;
int timeOffset = 0;

void setup(){
  size(1754, 1240);
  
  
  xmin = printSpacingX;
  xmax = width-printSpacingX;
  ymin = printSpacingY;
  ymax = height-printSpacingY;
  
  String[] strs = loadStrings("notes.txt");
  
  for(int page = 0; page < pages; page++){
    timeOffset = baseTimeOffset+(width-printSpacingX*2)*3*page;
    
    background(255);
    noStroke();
    fill(0);
    
    
    for(String note : strs){
      String[] noteData = note.split(" ");
      int time = int(int(noteData[0])*timeScale-timeOffset);
      int pitch = int(noteData[1]);
      int x = xmin+time%(width-printSpacingX*2);
      int yi = time/(width-printSpacingX*2);
      int y = (int)map(pitch, 0, 19, ymin+sheetWide-sheetSpacing, ymin+sheetSpacing)+sheetWide*(yi);
      ellipse(x, y, 15, 15);
      println(time,pitch);
    }
    
    stroke(0);
    
    
    for(int j=0; j<3; j++){
      for(int i=0; i<20; i++){
        int y = (int)map(i, 0, 19, ymin+sheetWide-sheetSpacing, ymin+sheetSpacing)+sheetWide*j;
        line(xmin, y, xmax, y);
      }
      
      int y = ymin;
      line(xmin, y, xmax, y);
      y = ymin+sheetWide+sheetWide*j;
      line(xmin, y, xmax, y);
    }
    
    save("notes"+page+".png");
  }
}
