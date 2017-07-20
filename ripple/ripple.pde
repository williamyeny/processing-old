ArrayList<Ripple> ripples;

void setup() {
  size(600, 600);
  ripples = new ArrayList<Ripple>();
  ripples.add(new Ripple(width/2, height/2));
  rectMode(CENTER);
  
}

void draw() {
  
  background(10, 10, 10);
  for (int i = ripples.size() - 1; i >= 0; i--) {
    Ripple r = ripples.get(i);
    
    r.update();
    r.display();
    
  
    if (ripples.get(i).o <= 0.5) {
      ripples.remove(i);
    }
   
  }
}


void mousePressed() {
  ripples.add(new Ripple(mouseX, mouseY));
}

class Ripple {
  float x, y;
  float w;
  float dia;
  float o;
  boolean u, d, l, r; //checks if child ripple is already made
  
  Ripple(float x, float y) {
    this.x = x;
    this.y = y;
    o = 255;
    w = 0;
    
  }
  
  Ripple(float x, float y, float dia, float o, float w) {
    this.x = x;
    this.y = y;
    this.dia = dia;
    this.o = o;
    this.w = w;
    
    if (y < 0) {
      u = true;
    } 
    if (y > height) {
      d = true;
    }
    if (x < 0) {
      l = true;
    }
    if (x > width) {
      r = true;
    }
  }
  
  void update() {
    dia += 4;
    o -= 1;
    w += 0.2;
    
    if (true) {
    
    if (y - dia/2 - w/2 <= 0 && !u) { //up
      u = true;
      ripples.add(new Ripple(x, -y, dia, o, w));
    } 
    if (y + dia/2 + w/2 >= height && !d) { //down
      d = true;
      ripples.add(new Ripple(x, height + height - y, dia, o, w));
    } 
    if (x - dia/2 - w/2 <= 0 && !l) { //left
      l = true;
      ripples.add(new Ripple(-x, y, dia, o, w));
    }
    
    if (x + dia/2 + w/2 >= width && !r) {//right
      r = true;
      ripples.add(new Ripple(width + width - x, y, dia, o, w));
    }
    
    }
    
  }
  
  void display() {
    strokeWeight(w);
    stroke(255, 255, 255, o);
    fill(255, 255, 255, 0);
    ellipse(x, y, dia, dia);
  }
}
  
  
