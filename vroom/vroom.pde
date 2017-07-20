//AUTHOR: WILLIAM YE
//TITLE: VROOM VROOM

ArrayList<Rect> cars;
int hmove;
int vmove;
int sw, sh;

void setup() {
  strokeWeight(0);
  sw = 600;
  sh = 600;
  size(sw, sh);
  cars = new ArrayList<Rect>();
  cars.add(new Rect(200, 200, 0));
}

void draw() {
  background(255);
  

  for (int i = cars.size() - 1; i >= 0; i--) {
    /* complicated teleportation code below. viable but too much effort
    //is it reaching the border? MAKE A COPY TO DO COOL TELEPORTATION THING
    if (cars.get(i).getX() < 50) {
      if (underTwo()) { //maximum two copies of the car
        addCar(sw + 50, cars.get(i).getY(), cars.get(i).getRotation());
      }
    }
    if (cars.get(i).getX() > sw - 50) {
      if (underTwo()) {
        addCar(-50, cars.get(i).getY(), cars.get(i).getRotation());
      }
    }
   
    if (cars.get(i).getY() < 50) {
      if (underTwo()) { //maximum two copies of the car
        addCar(cars.get(i).getX(), sh + 50, cars.get(i).getRotation());
      }
    }
    if (cars.get(i).getY() > sh - 50) {
      if (underTwo()) {
        addCar(cars.get(i).getX(), -50, cars.get(i).getRotation());
      }
    }
    //car way outta bounds? DELETE DAT
    */
    
    cars.get(i).update();
    cars.get(i).draw();
  }
}

boolean underTwo() {
  if (cars.size() <= 2) {
    return true;
  } else {
    return false;
  }
}

void addCar(float x, float y, float rotation) {
  cars.add(new Rect(x, y, rotation));
}

void keyReleased() {
  if (key == 'a' && hmove == 1) {
    hmove = 0;
  }
  if (key == 'd' && hmove == 2) {
    hmove = 0;
  }
  if (key == 'w' && vmove == 1) {
    vmove = 0;
  }
  if (key == 's' && vmove == 2) {
    vmove = 0;
  }
  if (key == ' ') {
    cars.add(new Rect(random(100, 300), random(100, 300), random(PI)));
  }
}

void keyPressed() {
  if (key == 'a') {
    hmove = 1;
  } 
  else if (key == 'd') {
    hmove = 2;
  }
  if (key == 'w') {
    vmove = 1;
  } 
  else if (key == 's') {
    vmove = 2;
  }
}

class Rect {
  float x, y, w, h;
  float curspeed, maxspeed, rotation;
  color c;

  Rect(float x, float y, float rotation) {
    this.x = x;
    this.y = y;
    w = 50;
    h = 20;
    maxspeed = 4;
    curspeed = 0;
    this.rotation = rotation;
    c = color(random(255), random(255), random(255));
  }
  
  float getRotation() {
    return rotation;
  }
  
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  void setX(float x) {
    this.x = x;
  }
  void setY(float y) {
    this.y = y;
  }
  
  void update() {
    if (hmove == 1) {
      rotation -= 0.03;
    }
    if (hmove == 2) {
      rotation += 0.03;
    }
    if (vmove == 1) {
      if ((hmove == 1 || hmove == 2)) {
          curspeed *= 0.98;
      } else {
        if (curspeed < maxspeed) {
          curspeed += 0.05;
        }
      }
    }
    if (vmove == 2) {
      if ((hmove == 1 || hmove == 2)) {
          curspeed *= 0.98;
      } else {
        if (curspeed > -maxspeed) {
          curspeed -= 0.05;
        }
      }
    }
    
    if (vmove == 0) {
      curspeed *= 0.95;
    }
    
    x += Math.cos(rotation)*curspeed;
    y += Math.sin(rotation)*curspeed;
  }
  
  void draw() {
    fill(c);
    stroke(c);
    pushMatrix();
    translate(x + w/2, y + h/2);
    rotate(rotation);
    rect(-w/2, -h/2, w, h);
    popMatrix();
  }
}
