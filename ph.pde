ArrayList noteL;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

ArrayList noteR;
ArrayList melodyPlay;
float horizon;
float intervalL;
float intervalR;
int maxNotes;

float sliderX;
int sequenceR;
int sequenceL;

float speed;

float[] melody = {-100, -60, 40, 80, 100, -60, -100, 80, 40, -60, 100, 80};
int melodySize = melody.length;

void setupNotes() {
  for (int i = 0; i < maxNotes; i++) {
    float positionY = horizon + melody[sequenceL];
    sequenceL = (sequenceL + 1) % melodySize;
    noteL.add(new Note(width / 2 - intervalL * (i + 1) * speed, positionY, 0.0, true, color(0, 255, 0)));
  }
  for (int i = 0; i < maxNotes; i++) {
    float positionY = horizon + melody[sequenceR];
    sequenceR = (sequenceR + 1) % melodySize;
    noteR.add(new Note(width / 2 + intervalL * (i + 1) * speed, positionY, 0.0, false, color(255, 0, 0)));
  }    
}


void setup(){
  size(1200,660,P3D);
  frameRate(80);
  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("127.0.0.1",8000);
  smooth();
  
  horizon = height/2;
  intervalL = 10;
  intervalR = 10;
  sliderX=width/6;
  sequenceR=0;
  sequenceL=0;
  
  maxNotes = 50;
  speed = 1.0;
  
  noteL = new ArrayList <Note>();
  noteR = new ArrayList <Note>();
  melodyPlay = new ArrayList <Melody>();
  
  for(int i=0;i<melodySize;i++){
    melodyPlay.add(new Melody( horizon + i*20 - 100));
  }
  
  setupNotes();
}

void generateNote(float _interval, float _x, ArrayList _note, boolean _direction, color _look){
  
  if(frameCount % _interval == 0){
      if(_direction){
        float positionY = horizon + melody[sequenceL];
        _note.add(new Note(_x,positionY,0.0,_direction,_look));
        sequenceL++;
        if(sequenceL==melodySize){
          sequenceL=0;
        }
      }
      else{
        float positionY = horizon + melody[sequenceR];
        _note.add(new Note(_x,positionY,0.0,_direction,_look));
        sequenceR++;
        if(sequenceR==melodySize){
          sequenceR=0;
        }
      }
  }
}

void update(ArrayList _note){
  Note preNote = null;
  for (int j=0; j<_note.size(); j++){
    Note n = (Note) _note.get(j);
    if(n.position.z > 700){
      _note.remove(j);
    }else{
      n.check();
      n.move();
      n.render();
      if( preNote != null){
        n.lineTo(preNote);
      }
      preNote = n;
    }
  }
}

void draw(){
  background(0,0,0);
  if(!mousePressed){
    camera(mouseX, mouseY, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  }
    
  stroke(50);
  strokeWeight(1);
  line(0, height/2, 0, width, height/2, 0);
  line(width/2, 0, 0, width/2, height, 0);
  line(width/2, height/2, 600, width/2, height/2, 0);
  /*
  noStroke();
  fill(255,255,255,20);
  beginShape();
  vertex(width/2,height/4,0);
  vertex(width/2,height/4,600);
  vertex(width/2,height*3/4,600);
  vertex(width/2,height*3/4,0);
  endShape();
  */
  
  stroke(100);
  line(width/16,height/6,width*3/16,height/6);
  
  pushMatrix(); 
  translate(sliderX, height/6, 0.0);
  lights();
  noStroke();
  fill(255,255,255,150);
  sphereDetail(8);
  sphere(8.0);
  popMatrix();  
  
  generateNote(intervalL, width / 2 - intervalL * maxNotes * speed, noteL, true, color(0,255,0));
  generateNote(intervalR, width / 2 + intervalR * maxNotes * speed, noteR, false, color(255,0,0));
  
  update(noteL);
  update(noteR);
  
  for(int i=0;i<melodySize;i++){   
    Melody m = (Melody)melodyPlay.get(i);
    ArrayList allNotes= new ArrayList<Note>(noteL);
    for(int j=0;j<noteR.size();j++){
      allNotes.add((Note)noteR.get(j));
    }
    m.detect(allNotes);
    m.display();
  }
  
  for(int i=0;i<melodySize;i++){
    Melody m = (Melody)melodyPlay.get(i);
      m.oscDetect(noteL,noteR,intervalL,intervalR,"/left","/right");
      //m.oscDetect(noteR,intervalR,"/right");
  }
}

void fixInterval() { 
  float fixLX = ((intervalL - (frameCount % intervalL)) % intervalL) * speed;
//  println(fixLX);
//  println(frameCount);
//  println(intervalL);
  for (int i = 0, j = 0; i < noteL.size(); i++) {
    Note n = (Note)noteL.get(i);
    if (n.hit) {
      continue;
    }
    n.position.x = width / 2 - fixLX - j * intervalL * speed;
    j++;
  }
}

void mouseDragged(){
  if(mouseX>width/16 && mouseX<width*3/16 && mouseY<height/6+40 && mouseY>height/6-40){
    sliderX=mouseX;
    float originInterval = intervalL;
    intervalL = round(map(mouseX,width/16,width*3/16,60,1));
    println(intervalL);
    println(originInterval); 
    fixInterval();
  }
}

//use <- and -> for test
//void keyPressed(){
//  if(key=='r'|| key=='R'){
//    intervalL=10;
//  }
//  
//  if (key == CODED) {
//    if (keyCode == LEFT) {
//      if (intervalL - 2 < 1) {
//        return;
//      }
//      intervalL -= 2;
//      fixInterval();
//    } else if (keyCode == RIGHT) {
//      if (intervalL + 2 > 60) {
//        return;
//      }
//      intervalL += 2;
//      fixInterval();    
//    }
//  }
//}
