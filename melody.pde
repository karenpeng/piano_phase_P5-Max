class Melody{
  PVector location;
  boolean on;
  
  Melody(float _y){
    location = new PVector(width/2, _y, 0.0);
    on = false;
  }
  
  void detect(ArrayList notes){
    on = false;
    for(int i=0; i<notes.size();i++){
      Note n = (Note)notes.get(i);
      if(n.position.y==location.y && !n.hit && n.position.x<width/2+4 && n.position.x>width/2-4){
        on = true;
        break;
      }
    }
  }
  
  void oscDetect(ArrayList notes1, ArrayList notes2, float gap1, float gap2, String string1, String string2){
     OscBundle myBundle = new OscBundle();
     OscMessage myMessage = new OscMessage("/test");
   
    for(int i=0; i<notes1.size();i++){
      Note n1 = (Note)notes1.get(i);
      if(n1.position.y==location.y && !n1.hit && n1.position.x<width/2+4 && n1.position.x>width/2-4){
        int maxNote1=round(map(location.y,230,430,76,86));
        myMessage.setAddrPattern(string1);
        myMessage.add(maxNote1);
        myMessage.add(gap1);
        myBundle.add(myMessage);
        myMessage.clear();
        break;
      }
    }
    
    for(int i=0; i<notes2.size();i++){
      Note n2 = (Note)notes2.get(i);
      if(n2.position.y==location.y && !n2.hit && n2.position.x<width/2+4 && n2.position.x>width/2-4){
        int maxNote2=round(map(location.y,230,430,76,86));
        myMessage.setAddrPattern(string2);
        myMessage.add(maxNote2);
        myMessage.add(gap2);
        myBundle.add(myMessage);
        myMessage.clear();
        break;
      }
    }
        myBundle.setTimetag(myBundle.now()+10000);
        oscP5.send(myBundle,myRemoteLocation); 
  }
  
  void display(){
    pushMatrix();
    translate(location.x, location.y, location.z);
    noStroke();
    lights();
    if(on){
      fill(255,255,255); 
      sphereDetail(8);  
      sphere(12.0);
    }else{
      fill(255,255,255,100);
      sphereDetail(8);  
      sphere(5.0);
    }
    popMatrix();
  }

}
