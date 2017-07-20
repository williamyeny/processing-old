//author: william ye
//title: ball physics
//desc: messing around, exploring some cool mechanics and physics

Ball ball;
int sw, sh;
float startX, startY, endX, endY;

void setup() {
  sw = 600;
  sh = 600;
  size(sw, sh);
  ball = new Ball(200, 200, 10, -10);
}

void draw() {
  if (!keyPressed) {
    background(255, 255, 255);
  }
  if (!mousePressed) { //don't let gravity/physics affect ball if "aiming"
    ball.update();
  }
  ball.draw();
  mouseControl();
  drawInstructions();
}

void drawInstructions() {
  fill(0, 0, 0);
  text("Instructions:", 0, 10);
  text("Click and drag mouse to determine speed and angle of the ball", 0, 20);
  text("Hold down any key to see motion",0 , 30);
}

void mouseControl() {
  if (mousePressed) {
    //draws "guiding line"
    stroke(255, 0, 0);//red for visibility
    line(startX, startY, mouseX, mouseY);
    stroke(0, 0, 0);
    //teleports ball to starting position
    ball.x = startX;
    ball.y = startY;
  }
}

void mousePressed() {
  //get starting position
  startX = mouseX;
  startY = mouseY;
}

void mouseReleased() {
  //get ending position
  endX = mouseX;
  endY = mouseY;
  
  //calculate angle between starting point and ending point
  float angle = (float)Math.atan2(endY - startY, endX - startX);
  //calculate power based on how long the line is
  float power = dist(startX, startY, endX, endY)/10; //10 is a limiting constant
  //change speed values accordingly
  ball.speedx = (float)Math.cos(angle)*power;
  ball.speedy = (float)Math.sin(angle)*power;
}

class Ball {
  float x, y, r, speedx, speedy;
  
  Ball(float x, float y, float speedx, float speedy) {
    this.x = x;
    this.y = y;
    this.speedx = speedx;
    this.speedy = speedy;
    r = 10;
  }
  
  void draw() {
    fill(255, 255, 255);
    ellipse(x, y, r*2, r*2);
  }
  
  void update() {
    //makes the ball bounce off walls and floor
    if (y + r + speedy > sh) {
      y = sh - r;
      speedy *=-0.8;
      speedx *= 0.9;
    }
    if (x + r + speedx > sw) {
      x = sw - r;
      speedx *= -0.9;
    }
    if (x - r + speedx < 0) {
      x = r;
      speedx *= -0.9;
    }
    //the reason i didn't create a ceiling was not because i'm lazy,
    //it's because a ceiling really restricts the movement of the ball
    //and basically sets a limit for how high you can send the ball

    
    //accelerate the speed with gravity constant
    speedy += 0.3;
        
    x += speedx;
    y += speedy;
  }
}
