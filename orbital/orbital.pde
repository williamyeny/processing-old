//AUTHOR: William Ye
//TITLE: Orbital
//DESC: Don't let the balls out

int sw = 600;
int sh = 600; 
Hub hub;
Paddle player;
Color bCol; //background color
ArrayList<Ball> balls;
ArrayList<Particle> particles;
float spawnTimer; 
float spawnDelay; //spawns balls
int quality;
float particleDelay;
Camera camera;
String screen;
ArrayList<Button> menuButtons;
ArrayList<Button> qualityButtons;
float mouseAngle;
Button backButton;
ArrayList<Button> gameOverButtons;
ArrayList<FloatingText> floatingText;
float health;
HealthBar healthBar;
int score;
float accelTimer; //increases speed
float ballConstant;
String version = "v1.4";

void setup() { 
  size(600, 600);
  reset();
  particleDelay = 2; //3 is low, 2 is medium, 1 is high
  screen = "menu";
  
  noStroke();
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  
  particles = new ArrayList<Particle>();
  floatingText = new ArrayList<FloatingText>();
  
  menuButtons = new ArrayList<Button>();
  //createButtons(menuButtons, 5); //uncomment for desktop
  createButtons(menuButtons, 4); //comment for desktop
  
  menuButtons.get(0).t = "Play";
  menuButtons.get(1).t = "Help";
  menuButtons.get(2).t = "Quality";
  menuButtons.get(3).t = "About";
  //menuButtons.get(4).t = "Quit"; //uncomment for desktop
  
  qualityButtons = new ArrayList<Button>();
  createButtons(qualityButtons, 3);
  qualityButtons.get(0).t = "Low";
  qualityButtons.get(1).t = "Medium";
  qualityButtons.get(2).t = "High";
  
  gameOverButtons = new ArrayList<Button>();
  gameOverButtons.add(new Button(PI/2 - PI/4, PI/2));
  gameOverButtons.get(0).t = "Again?";
  gameOverButtons.add(new Button(PI/2, PI/2 + PI/4));
  gameOverButtons.get(1).t = "Menu";
  
  healthBar = new HealthBar(sw/2, sh/2);
  player = new Paddle(sw/2, sh/2);
  
  camera = new Camera();
  
  bCol = new Color(0, 0, 0);
  
  backButton = new Button(PI/2 - PI/6, PI/2 + PI/6); //PI/6 is just a random measurement, it could be PI/10 or 2 or 92.345 
  backButton.t = "Back";
  
  ballConstant = 0.05;
  
}
//              which arraylist to add to?     how many buttons do i want?
void createButtons(ArrayList<Button> buttons, float numberOfButtons) {
  float sliceAngle = TWO_PI/numberOfButtons;
  for (int i = 0; i < numberOfButtons; i++) {
    buttons.add(new Button(-PI + i*sliceAngle, -PI + i*sliceAngle + sliceAngle)); //draws slices
  }
}

void addButton(float start, float stop) {
  menuButtons.add(new Button(start, stop));
}

void reset() { //stuff that resets on each game
  hub = new Hub(sw/2, sh/2);
  balls = new ArrayList<Ball>();
  spawnDelay = 100;
  spawnTimer = spawnDelay;  
  health = 1.0;
  score = 0;
  accelTimer = 300;
}

void normalizeBackground() {
  bCol.r += (30 - bCol.r)/20;
  bCol.g += (30 - bCol.g)/20;
  bCol.b += (30 - bCol.b)/20;
}

class Camera {
  float x, y, timer;
  Camera() {
    x = 0;
    y = 0;
  }
  void update() {
    if (timer >= 0) {
      timer--;
      camera.x = random(-10, 10);
      camera.y = random(-10, 10);
    } else {
      camera.x = 0;
      camera.y = 0;
    }
  }
  void shake() {
    timer = 30;
  }
}


void draw() {
  normalizeBackground(); 
  
  background(bCol.r, bCol.g, bCol.b);
  
  camera.update();
  
  mouseAngle = atan2(mouseY - sh/2, mouseX - sw/2);
    
  //update and draw all the stuffs
  player.update(mouseAngle);
  player.draw(bCol.r, bCol.g, bCol.b);
  
  
  for (int i = balls.size() - 1; i >= 0; i--) {
    Ball b = balls.get(i);
    b.update();
    b.draw();

    if (b.x > sw + b.radius/2 || b.x < -b.radius/2 || b.y > sh + b.radius/2 || b.y < -b.radius/2) { //OH NO YOU DUN GOOFED
      balls.remove(i);
      loseHealth();
    }
    
    if (checkCollision(b)) {
      if (screen.equals("play")) {
        balls.remove(i);
        addExplosion(b.x, b.y);
        addFloatingText(b.x, b.y, 30, "+100", 0, 255, 0);
        score += 100;
      }
    }

  }

  for (int i = particles.size() - 1; i >= 0; i--) { //draw particles
    Particle p = particles.get(i);
    p.update();
    p.draw();
    
    if (p.col.o <= 0) {
      particles.remove(i);
    }
  }
  
  
  if (screen.equals("play")) hub.update();
  hub.draw();  
  healthBar.update();
  healthBar.draw();
  
  if (screen.equals("play")) {
    spawnBalls();
  }
  
  for (int i = floatingText.size()-1; i >= 0; i--) {
    FloatingText f = floatingText.get(i);
    f.update();
    f.draw();
    if (f.col.o <= 0) {
      floatingText.remove(i);
    }
  }
  
  drawScreens();  
}

void spawnBalls() {
  spawnTimer--;
  if (spawnTimer <= 0) {
    spawnTimer = spawnDelay;
    addBall();
  }
  accelTimer--;
  if (accelTimer <= 0) {
    accelTimer = 300;
    spawnDelay -= spawnDelay/10; //makes the spawning of the ball faster
  }
}

boolean checkCollision(Ball b) {
  if (dist(b.x, b.y, sw/2, sh/2) >= player.distance/2 - b.radius/2 && dist(b.x, b.y, sw/2, sh/2) <= player.distance/2 + 10) { 
    //this detects the majority of ball directions
    if ((b.direction > player.location - player.size/2 - ballConstant && b.direction < player.location + player.size/2 + ballConstant)) {
      return true;
    }    
    //however, some errors occur when the paddle is hovering over the part where -PI switches to PI and vice versa
    if (player.location < -PI + player.size/2) {
                          //absolute value because it's in the very negative spectrum
      if (b.direction > PI - (abs(player.location -  player.size/2) + PI)) {
        return true;
      }
    }
    if (player.location > PI - player.size/2) {
      if (b.direction < -PI + (player.location + player.size/2 - PI)) {
        return true;
      }
    }
  }
  return false;
}

void loseHealth() {
  health -= 0.34;
  if (health > 0) {
    bCol.r = 200;
    bCol.g = 10;
    bCol.b = 10;
    camera.shake();
    healthBar.col.r = 100;
    healthBar.col.g = 0;
    healthBar.col.b = 0;
    if (health < 0.5 && health > 0) {
      addFloatingText(sw/2, sh/2, 40, "Warning! Low health!", 255, 0, 0);
    } else {
      addFloatingText(sw/2, sh/2, 40, "Don't let the balls out!", 255, 0, 0);
    }
  } else {
    if (screen.equals("play")) {
      camera.shake();
      addFloatingText(sw/2, sh/2, 40, "All health lost!", 255, 0, 0);
      gameOver();
    }
    
  }
}

void gameOver() {
  screen = "gameover";
  //bigass explosion
  for (int i = 0; i < 50; i++) {
    float x = random(sw);
    float y = random(sh);
    addBigExplosion(x, y);
  }
}

void drawScreens() {
  if (screen.equals("menu")) {
    titleText("Orbital");
    for (Button b : menuButtons) {
      b.update();
      b.draw();
    }
  } else if (screen.equals("quality")) {
    titleText("Quality");
    for (Button b : qualityButtons) {
       b.update();
       b.draw();
    }
  } else if (screen.equals("help")) {
    titleText("Help");
    backButton.update();
    backButton.draw();
    subText("Use your mouse to stop the balls");
  } else if (screen.equals("about")) {
    titleText("About");
    backButton.update();
    backButton.draw();
    subText("Developed by William Ye, 10/19 - 10/22/14 \n " + version);
  } else if (screen.equals("gameover")) {
    fill(0, 0, 0, 150);
    rect(sw/2, sh/2, sw, sh);
    titleText("Game Over");
    subText("Score: " + str(score));
    for (Button b : gameOverButtons) {
      b.update();
      b.draw();
    }
  }
}

void subText(String title) {
  fill(255, 255, 255);
  textSize(17); //text sizes, position, and color are hardcoded, tweaked until they look nice
  text(title, sw/2, sh/2 - 100);
}

void titleText(String title) {
 fill(85, 255, 206);
 textSize(25);
 text(title, sw/2, 70);
}

void addFloatingText(float x, float y, float size, String t, float r, float g, float b) {
  floatingText.add(new FloatingText(x, y, size, t, r, g, b));
}

class FloatingText {
  float x, y, size;
  String t;
  Color col;
  
  FloatingText(float x, float y, float size, String t, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.t = t;
    col = new Color(r, g, b);
  }
  
  void update() {
    col.o -= 3;
    y -= 1.5;
  }
  
  void draw() {
    fill(col.r, col.g, col.b, col.o);
    textSize(size);
    text(t, x, y);
  }
}

class Button {
  float x, y;
  Color col;
  float start, stop;
  float distance;
  String t;
  float angle;
  
  Button(float start, float stop) {
    x = sw/2;
    y = sh/2;
    col = new Color(60, 60, 60, 100);
    this.start = start;
    this.stop = stop;
    angle = (start+stop)/2;
    distance = 400;
  }
  
  void draw() {
    fill(col.r, col.g, col.b, col.o);
    arc(x, y, distance, distance, start, stop);
    
    //draw text
    fill(255, 255, 255);
    textSize(15);
    text(t, x + cos(angle)*distance/3, y + sin(angle)*distance/3);
  }
  
  void update() {
    
    if (selected()) {
      col.o = 200;
    }
    col.o += (100 - col.o)/5; //reverts back to 100
  }
  
  boolean selected() {
    if (mouseAngle > start && mouseAngle < stop && dist(x, y, mouseX, mouseY) < distance/2) { //if the mouse angle is within the button angle
      return true;
    } else {
      return false;
    }
  }
  
}

void addExplosion(float x, float y) {
  for (int i = 0; i < (3-particleDelay) * 20 + 20; i++) {
    addParticle(x, y, random(10), random(1.5), 255, 50, 50);
  }
  for (int i = 0; i < (3-particleDelay) * 20 + 20; i++) {
    addParticle(x, y, random(10), random(1.5), 255, 255, 0);
  }
  for (int i = 0; i < (3-particleDelay) * 20 + 20; i++) {
    addParticle(x, y, random(10), random(1.5), 255, 100, 0);
  }
  bCol.r = 60;
  bCol.g = 60;
  bCol.b = 60;
}

void addBigExplosion(float x, float y) {
  for (int i = 0; i < (3-particleDelay) * 20 + 20; i++) {
    addParticle(x, y, random(50), random(10), 255, 50, 50);
  }
  for (int i = 0; i < (3-particleDelay) * 20 + 20; i++) {
    addParticle(x, y, random(50), random(10), 255, 255, 0);
  }
  for (int i = 0; i < (3-particleDelay) * 20 + 20; i++) {
    addParticle(x, y, random(50), random(10), 255, 100, 0);
  }
  bCol.r = 60;
  bCol.g = 60;
  bCol.b = 60;
}

void addBall() {
  balls.add(new Ball(sw/2, sh/2));
  hub.radius = 80;
}

class Ball {
  float x, y, radius;
  float sx, sy;
  float direction;
  float particleTimer; //spawns particles
  
  Ball(float x, float y) {
    this.x = x;
    this.y = y;
    radius = 20;
    direction = random(-PI, PI);
    sx = cos(direction) * 2;
    sy = sin(direction) * 2;
    particleTimer = 20;
  }
  
  void update() {
    particleTimer--;
    if (particleTimer <= 0) {
      particleTimer = particleDelay;
      addParticle(random(x-5, x+5), random(y-5, y+5), 10, random(0.5), 255, 255, 255);
    }
    
    x += sx;
    y += sy;
  }
  
  void draw() {
    fill(255, 255, 255);
    ellipse(x + camera.x, y + camera.y, radius, radius);
  }
}

void addParticle(float x, float y, float w, float speed, float r, float g, float b) {
  particles.add(new Particle(x, y, w, speed, r, g, b));
}

void addParticle(float x, float y, float w, float speed, float direction, float r, float g, float b) {
  particles.add(new Particle(x, y, w, speed, direction, r, g, b));
}

class Particle {
  float x, y, w;
  float speed;
  float sx, sy;
  Color col;
  float angle;
  
  Particle(float x, float y, float w, float speed, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.speed = speed;
    angle = random(0, TWO_PI);
    sx = cos(angle)*speed;
    sy = sin(angle)*speed;
    col = new Color(r, g, b);
  }
  
  Particle(float x, float y, float w, float speed, float direction, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.speed = speed;
    angle = direction;
    sx = cos(angle)*speed;
    sy = sin(angle)*speed;
    col = new Color(r, g, b);
  }
  
  void update() {
    x += sx; //move around
    y += sy;
    col.o -= 5; //fade away
  }
  
  void draw() {
    fill(col.r, col.g, col.b, col.o);
    rect(x + camera.x, y + camera.y, w, w);
  }
}

void mouseReleased() { //mainly used for clicking menu buttons
  if (screen.equals("menu")) {
    for (Button b : menuButtons) {
      if (b.selected()) { //if it is selected and the mouse is clicked
        if (b.t.equals("Play")) {
          screen = "play";
          reset();
          blackFlash();
        } else if (b.t.equals("Quality")) {
          screen = "quality";
          blackFlash();
        } else if (b.t.equals("Quit")) {
          exit();
        } else if (b.t.equals("About")) {
          screen = "about";
          blackFlash();
        } else if (b.t.equals("Help")) {
          screen = "help";
          blackFlash();
        }
      }
    }
  } else if (screen.equals("quality")) {
    for (Button b : qualityButtons) {
      if (b.selected()) {
        if (b.t.equals("Low")) {
          particleDelay = 3; //less particles
        }
        if (b.t.equals("Medium")) {
          particleDelay = 2; //normal particles
        }
        if (b.t.equals("High")) {
          particleDelay = 1; //more particles
        }
        screen = "menu"; //goes back to menu
        blackFlash();
      }
    }
  } else if (screen.equals("help") || screen.equals("about")) {
    if (backButton.selected()) {
      screen = "menu";
      blackFlash();
    }
  } else if (screen.equals("gameover")) {
    for (Button b : gameOverButtons) {
      if (b.selected()) {
        if (b.t.equals("Again?")) {
          screen = "play";
          reset();
          blackFlash();
        }
        if (b.t.equals("Menu")) {
          screen = "menu";
          blackFlash();
        }
      }
    }
  }

}

void blackFlash() {
  bCol.r = 0;
  bCol.g = 0;
  bCol.b = 0;
}  

class Color {
  float r, g, b, o;
  
  Color(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.o = 255;
  }
  
  Color(float r, float g, float b, float o) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.o = o;
  }
}


class Paddle {
  float x, y, size, distance, thickness, location;
  Color col;
  float particleTimer;
  
  Paddle(float x, float y) {
    this.x = x;
    this.y = y;
    size = 0.4;
    col = new Color(75, 230, 200);
    distance = 500;
    thickness = 30;
    particleTimer = 0;
  }
  
  void update(float angle) {
    location = angle;
    particleTimer--;
    if (particleTimer <= 0) {
      addParticle(x + cos(location + random(-0.2, 0.2))*distance/2, y + sin(location + random(-0.2, 0.2))*distance/2, random(3), random(1), 75, 230, 200);
      particleTimer = particleDelay;
    }
  }
  void draw(float br, float bg, float bb) { //background red, background green, background blue
    fill(col.r, col.g, col.b, col.o);
    arc(x + camera.x, y + camera.y, distance + thickness, distance + thickness, location - size/2, size/2 + location);
    fill(br, bg, bb);//cuts middle section away for ring
    arc(x + camera.x, y + camera.y, distance, distance, location - size/2 - 1, size/2 + location + 1);
  }
}

class HealthBar {
  float x, y;
  Color col;
  float start, stop;
  float offsetStartA, offsetStopA; //a stands for actual
  float offsetStartV, offsetStopV; //v stands for visual
  float offsetTimer;
  
  HealthBar(float x, float y) {
    this.x = x;
    this.y = y;
    col = new Color(30, 185, 155);
  }
  
  void update() {
    col.r += (30 - col.r)/20;
    col.g += (185 - col.g)/20;
    col.b += (155 - col.b)/20;
    
    //finds the start and stop value based on health
    // offsetStartV and offsetStopV values gives the shifty effect
    start = -PI * health + PI/2 + offsetStartV; 
    stop = PI * health + PI/2 + offsetStopV; 
    
    offsetTimer--;
    if (offsetTimer <= 0) { //every 30 ticks, shift
      offsetTimer = 30;
      offsetStartA = random(-0.2, 0.2);
      offsetStopA = random(-0.2, 0.2);
    }
    
    offsetStartV += (offsetStartA - offsetStartV)/20; //this makes it look smooth. The visual offset is gradually moved towards the actual offset
    offsetStopV += (offsetStopA - offsetStopV)/20;
  }
  
  void draw() {
    fill(col.r, col.g, col.b, col.o);                                
    arc(x + camera.x, y + camera.y, hub.radius - 10, hub.radius-10, start, stop); // changes width with health, adds a shift (PI/2) to rotate right, randomly shifts around a bit to give a weird look
  }
}

class Hub {
  float x, y, radius;
  Color col;
  float particleTimer;
  float fireSize;
  
  Hub(float x, float y) {
    this.x = x;
    this.y = y;
    radius = 60;
    col = new Color(75, 230, 200);
    particleTimer = 2;
    fireSize = 0;
  }
  
  void update() {
    
    //makes fire bigger
    fireSize += (30 - fireSize)/1500;
    
    //add fire
    particleTimer--;
    if (particleTimer <= 0) {
      particleTimer = particleDelay;
      addParticle(random(x-radius/2, x+radius/2), random(y-radius/2, y+radius/2), random(fireSize), 5, -PI/2, random(50, 100), random(205, 255), random(175, 225));
    }
    //makes the radius return to 60
    radius += (60 - radius)/10;
  }
  
  void draw() {
    fill(col.r, col.g, col.b, col.o);
    ellipse(x + camera.x, y + camera.y, radius, radius);
  }
}
