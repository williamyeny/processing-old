//Author: William Ye
//Project: Bombs + ball = profit

Ball ball;
float bgcolor;
ArrayList<Bomb> bombs;
ArrayList<Explosion> explosions;
ArrayList<Particle> particles;
int tutorialCounter;

void setup() {
  size(600, 600);
  ball = new Ball(width/2, height/2);
  bgcolor = 100;
  bombs = new ArrayList<Bomb>();
  explosions = new ArrayList<Explosion>();
  particles = new ArrayList<Particle>();
  noStroke();
  tutorialCounter = 0;
}
void draw() {
  background(bgcolor, bgcolor, bgcolor);
  updateBackground();
  ball.update();
  ball.draw();
  for (int i = bombs.size()-1; i>=0; i--) {
    //finds exploded bombs
    if (bombs.get(i).exploded) {
      bombs.remove(i);
    } else {
      bombs.get(i).update();
      bombs.get(i).draw();    
    }
  }
  for (int i = explosions.size()-1; i>=0; i--) {
    //finds exploded explosions
    if (explosions.get(i).exploded) {
      explosions.remove(i);
    } else {
      explosions.get(i).update();
      explosions.get(i).draw();    
    }
  }
  for (int i = particles.size()-1; i>=0; i--) {
    //finds stopped particles
    if (particles.get(i).stopped) {
      particles.remove(i);
    } else {
      particles.get(i).update();
      particles.get(i).draw();    
    }
  }
  tutorial();
}
void keyPressed() {
  if (key == ' ') {
    tutorialCounter++;
  }
}
void tutorial() {
  fill(255, 255, 255);
  textSize(20);
  if (tutorialCounter == 0) { //wanted to do a switch case statement... too lazy....
    text("Hey! Try clicking somewhere to place a bomb!", 20, 30);
  } else if (tutorialCounter == 1) {
    text("Cool! Now try placing it near the green ball to make it move!", 20, 30);
  } else if (tutorialCounter == 2) {
    text("Nice! Bounce the ball off the wall to see some cool stuff!", 20, 30);
  } else if (tutorialCounter == 3) {
    text("Pretty cool, huh? Next, I'll explain a few features.", 20, 30);
  } else if (tutorialCounter == 4) {
    text("The closer the bomb to the ball, the faster it goes.", 20, 30);
  } else if (tutorialCounter == 5) {
    text("If you place the bomb far enough, it won't affect the ball at all.", 20, 30);
  } else if (tutorialCounter == 6) {
    text("The harder the ball collides, the faster the particles move.", 20, 30);
  } else if (tutorialCounter == 7) {
    text("Amount of particles don't increase with ball speed... yet. ", 20, 30);
  } else if (tutorialCounter == 8) {
    text("You can place more than one bomb at once! Click rapidly.",20 , 30);
  } else if (tutorialCounter == 9) {
    text("Perfect collision. The ball doesn't bounce past or before a wall.", 20, 30);
  } else if (tutorialCounter == 10) {
    text("Finally, to spawn particles, hold down any key and click anywhere!", 20, 30);
  } else if (tutorialCounter == 11) {
    text("That's all for now, have fun!", 20, 30);
  }
  textSize(12);
  if (tutorialCounter<=11) text("Press the spacebar to continue", 40, 50);
}
void addParticles(float x, float y, boolean ballAffect, int numberOfParticles) {
  for (int i = 0; i < numberOfParticles; i++) {
    float angle = random(-PI, PI);
    if (ballAffect) {
      float ballpower = (abs(ball.sx) + abs(ball.sy))/2;
      float power = random(ballpower/2);
      particles.add(new Particle(x, y, angle, power));
    } else {
      particles.add(new Particle(x, y, angle, random(20)));
    } 
  }
}

class Particle {
  float x, y, r, sx, sy, o;
  boolean stopped;
  
  Particle(float x, float y, float angle, float power) {
    this.x = x;
    this.y = y;
    r = 3; //change this for particle size
    sx = cos(angle)*power;
    sy = sin(angle)*power;
    o = 255;
  }
  void update() {
    x += sx;
    y += sy;
    sy *= 0.9;
    sx *= 0.9;
    if (abs(sy) < 0.01) {//if it stops moving
      stopped = true;
    }
    o -= 5;
  }
  void draw() {
    fill(255, 255, 255, o);
    ellipse(x, y, r, r);
  }
}
void updateBackground() {
  if (bgcolor > 100) {
    bgcolor -= 5; //brings it back to gray
  }
}

void mousePressed() {
  if (keyPressed) {
    addParticles(mouseX, mouseY, false, 100);
  } else {
    bombs.add(new Bomb(mouseX-3.25, mouseY-3.25));
  }
}

class Bomb {
  float x, y, r, time;
  boolean exploded;
  
  Bomb(float x, float y) {
    this.x = x;
    this.y = y;
    r = 15;
    time = 100;
  }
  void draw() {
    if (time % 5 == 0) {
      fill(255, 0, 0); 
    } else {
      fill(255, 255, 255);
    }
    ellipse(x, y, r, r);
  }
  void update() {
    time--;
    if (time == 0) {
      explode();
    }
  }
  void explode() {
    //checks if it's in the explosion radius
    if (dist(x, y, ball.x, ball.y) < 200) {
      float angle = atan2(y - ball.y, x - ball.x);
      float power = 1500/dist(x, y, ball.x, ball.y);
      ball.sx = -cos(angle)*power;
      ball.sy = -sin(angle)*power;
    }
    bgcolor = 150;//flash screen
    exploded = true;
    addExplosion(x, y);
  }
}

void addExplosion(float x, float y) {
  explosions.add(new Explosion(x, y));
}

class Explosion {
  float x, y, r, o; //o stands for opacity
  boolean exploded;
  
  Explosion(float x, float y) {
    this.x = x;
    this.y = y;
    r = 0;
    o = 255;
  }
  void update() {
    r += 20; //make it bigger and more transparent
    o -= 20;
    if (o <= 0) {
      exploded = true;
    }
  }
  void draw() {
    fill(255, 136, 100, o);
    ellipse(x, y, r, r);
  }
}

class Ball {
  float x, y, r, sx, sy;
  
  Ball(float x, float y) {
    this.x = x;
    this.y = y;
    r = 30;
  }
  void draw() {
    fill(0, 255, 100);
    ellipse(x, y, r, r);
  }
  void update() {

    sx*=0.9;
    sy*=0.9;
    x += sx;
    y += sy;
    
    if (x + r/2 + sx > width) { // bounce off walls
      x = width - r/2;
      sx *= -0.95;
      addParticles(width, y, true, 40);
    } else if (x - r/2 + sx < 0) {
      x = r/2;
      sx *= -0.95;
      addParticles(0, y, true, 40);
    } else if (y + r/2 + sy > height) {
      y = height - r/2;
      sy *= -0.95;
      addParticles(x, height, true, 40);
    } else if (y - r/2 + sy < 0) {
      y = r/2;
      sy *= -0.95; 
      addParticles(x, 0, true, 40);
    }
  }
}
