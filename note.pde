class Note{
   PVector position;  
   float radius;
   int speed;
   float center;
   boolean hit;
   boolean direction;
   color look;
  
  Note(float _x, float _y, float _z, boolean _direction, color _look){
    position = new PVector( _x, _y, _z);
    radius = 5.0;
    center = width / 2;
    hit=false;
    direction=_direction;
    look = _look;
  }
  
   void check(){   
    if (direction && position.x >= center) {
      hit = true;
    } else if(!direction && position.x<=center){
      hit = true;
    }   
  }

  void move() {
    if(!hit){
      speed = position.x > center ? -2 : 2;
      position.x+=speed;
    }else{  
      speed=2;   
      position.z += speed;
    }
  }
  
  void render() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    if(hit){
      fill(look,140);
    }else{
      fill(look,60);
    }
    lights();
    sphereDetail(8);  
    sphere(radius);
    popMatrix();   
  }
  
  void lineTo(Note anotherNote) {
    if(hit){
      stroke(look,140);
    }else{
      stroke(look,60);
    }
    strokeWeight(1);
    line(position.x, position.y, position.z, anotherNote.position.x, anotherNote.position.y, anotherNote.position.z);
  }

}
