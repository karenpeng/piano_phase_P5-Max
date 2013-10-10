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
float sliderX;
int sequenceR;
int sequenceL;

float[] melody = {-100, -60, 40, 80, 100, -60, -100, 80, 40, -60, 100, 80};
int melodySize = melody.length;

void setup(){
  size(1200,660,P3D);
  //frameRate(40);
  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("127.0.0.1",8000);
  smooth();
  
  horizon = height/2;
  intervalL = 10;
  intervalR = 10;
  sliderX=width/6;
  sequenceR=0;
  sequenceL=0;
  
  noteL = new ArrayList <Note>();
  noteR = new ArrayList <Note>();
  melodyPlay = new ArrayList <Melody>();
  
  for(int i=0;i<melodySize;i++){
    melodyPlay.add(new Melody( horizon + i*20 - 100));
  }
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
  
  generateNote(intervalL,0.0,noteL,true,color(0,255,0));
  generateNote(intervalR,width,noteR,false,color(255,0,0));
  
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

void mouseDragged(){
  if(mouseX>width/16 && mouseX<width*3/16 && mouseY<height/6+40 && mouseY>height/6-40){
    sliderX=mouseX;
    intervalL = round(map(mouseX,width/16,width*3/16,60,1)); 
    println(intervalL);
  }
}

void keyPressed(){
  if(key=='r'|| key=='R'){
    intervalL=10;
  }
}
