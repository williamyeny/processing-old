ArrayList<Point> points;
int numberOfPoints = 50;
ArrayList<Connector> connectors;
ArrayList<Orb> orbs;

void mousePressed() {
  reload();
}

void reload() {
  points = new ArrayList<Point>();
  for (int i = 0; i < numberOfPoints; i++) {
    points.add(new Point(random(width), random(height)));
  }
  connectors = new ArrayList<Connector>();
  for (Point p : points) {
    for (Point o : points) {
      if (dist(p.x, p.y, o.x, o.y) < 100) {
        connectors.add(new Connector(p.x, p.y, o.x, o.y));
      }
    }
  }
  orbs = new ArrayList<Orb>();
  for (Connector c : connectors) {
    float position = random(1); //percentage up the line (like 0.5 up, or 0.3 up)
    float xLength = c.x1 - c.x2; //total length
    float yLength = c.y1 - c.y2;
    float x = xLength * position; //position up the line
    float y = yLength * position;

    orbs.add(new Orb(x + c.x2, y + c.y2));
  }
}

void setup() {
  size(600, 600);
  reload();
}

void draw() {
  background(0, 60, 60);
  for (Connector c : connectors) {
    c.update();
    c.draw();
  }
  for (int i = 0; i < orbs.size(); i++) {
    Orb o = orbs.get(i);
    Connector c = connectors.get(i);
    
    //add boundary code 
  }
  for (Point p : points) {
    p.update();
    p.draw();
  }
}

class Point {
  float x, y, diameter, oDiameter, oDiaSpeed;
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
    diameter = 20;
    oDiameter = random(diameter, diameter * 2);
    oDiaSpeed = 1;
  }
  
  void update() {
    oDiameter += oDiaSpeed;
    if (oDiameter > diameter * 2 || oDiameter < diameter) {
      oDiaSpeed *= -1;
    }
  }
  
  void draw() {
    stroke(0, 111, 117);
    strokeWeight(2);
    noFill();
    ellipse(x, y, oDiameter, oDiameter);
    
    noStroke();
    fill(120, 240, 250);
    ellipse(x, y, diameter, diameter);
  }
}

class Connector {
  float x1, y1, x2, y2, thickness, thicknessSpeed;
  
  Connector(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.x2 = x2;
    this.y1 = y1;
    this.y2 = y2;
    thickness = random(0.5, 1.5);
    thicknessSpeed = 0.05;
  }
  
  void update() {
    thickness += thicknessSpeed;
    if (thickness > 1.5 || thickness < 0.5) {
      thicknessSpeed *= -1;
    }
  }
  
  void draw() {
    stroke(255, 255, 255);
    strokeWeight(thickness);
    line(x1, y1, x2, y2);
  }
}

class Orb {
  float x, y, diameter, diameterSpeed;
  
  Orb(float x, float y) { //add additional parameter for speed
    this.x = x;
    this.y = y;
    diameter = random(5, 10);
    diameterSpeed = 0.2;
  }
  
  void update() {
    diameter += diameterSpeed;
    if (diameter > 10 || diameter < 5) {
      diameterSpeed *= -1;
    }
    
    //add move code
  }
  
  void draw() {
    noStroke();
    fill(120, 240, 250);
    ellipse(x, y, diameter, diameter);
  }
}
    
 
