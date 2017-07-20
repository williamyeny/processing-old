//AUTHOR: William Ye
//DESC: Snake, recreated right.
//CONTROLS: Arrow keys to move.
//          "q" and "w" to modify speed
//          "a" and "s" to modify starting number of segments
//          "z" and "x" to modify segments generated per food eaten
//NOTES: A clever way of storing multiple inputs in a single update cycle is used to 
//       "remember" the user's intended actions. 
//       Collision handler is disabled using ignoreCollision variable during a set
//       amount of cycles.
//       Recursive function to make sure the food doesn't appear on a segment.
//       Make sure to read the console; it provides important information.

int sw = 500;
int sh = 500;
ArrayList<Segment> segments;
String direction;
int timer;
boolean pressed;
ArrayList<String> inputQueue;
Food food;
int ignoreCollision;
int highScore = 0;
int score = 0;
boolean paused;

int speed = 6;
int startingNumber = 1;
int segmentsPerFood = 1;

void setup() {
  size(sw, sh);
  noStroke();
  reset();
}

void reset() {
  ignoreCollision = 0;
  segments = new ArrayList<Segment>();
  food = new Food();
  segments.add(new Segment(sw/2, sh/2));
  if (startingNumber > 1) addSegment(startingNumber - 1);
  direction = "DOWN";
  timer = 0;
  inputQueue = new ArrayList<String>();
  highScore = score;
  score = 0;
  paused = false;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == DOWN) {
      inputQueue.add("DOWN");
    } else if (keyCode == UP) {
      inputQueue.add("UP");
    } else if (keyCode == RIGHT) {
      inputQueue.add("RIGHT");
    } else if (keyCode == LEFT) {
      inputQueue.add("LEFT");
    }
  } else {
    if (key == 'p') {
      if (paused) {
        paused = false;
      } else {
        paused = true;
      }
    } else if (key == 'w') {
        if (speed == 1) {
        } else {
          speed--;
          timer = 0;
        }
    } else if (key == 'q') {
      speed++;
      timer = 0;
    } else if (key == 'a') {
      if (startingNumber == 1) {
      } else {
        startingNumber--;
      }
    } else if (key == 's') {
      startingNumber++;
    } else if (key == 'z') {
      if (segmentsPerFood == 1) {
      } else {
        segmentsPerFood--;;
      }
    } else if (key == 'x') {
      segmentsPerFood++;
    }
  }
}

void addSegment(int number) {
  for (int i = 0; i < number; i++) {
    segments.add(new Segment(segments.get(segments.size() - 1).x, segments.get(segments.size() - 1).y));
    ignoreCollision++; //tells the update method to ignore the next check collision cycle since the new segment will be placed right on the last segment
  }
  food.randomize();
}

void draw() {
  background(255, 255, 255);
  if (!paused) timer++;
  if (timer == speed) {
    update();
    timer = 0;
  }

  for (Segment s : segments) {
    s.draw();
  }
  
  food.draw();
  
  textSize(20);
  fill(150, 150, 150);
  text("SCORE: " + score, 10, 20);
  text("HIGHSCORE: " + highScore, 10, 40);
}

void update() {
  handleInput();
  handleMovement();
  handleCollision();
}

void handleCollision() {
  //collision with food
  if (segments.get(0).x == food.x && segments.get(0).y == food.y) {
    addSegment(segmentsPerFood);
    score++;
  }
 
  
  //collision with other body parts
  for (int i = 0; i < segments.size(); i++) {
    for (int j = 0; j < segments.size(); j++) {
      if (segments.get(i).x == segments.get(j).x && segments.get(i).y == segments.get(j).y && i != j && ignoreCollision == 0) {
        reset();
        return; //breaking out of the function so the loop doesn't continue and tries to use non-existent elements and the bottom code doesn't try to use deleted stuff
      }
    }
    
    //out of bounds
    if (segments.get(i).x < 0 || segments.get(i).x >= sw || segments.get(i).y < 0 || segments.get(i).y >= sh) {
      reset();
      break;
    } 
  }
  
  if (ignoreCollision > 0) ignoreCollision--;

}

void handleMovement() {
  for (int i = segments.size() - 1; i >= 1; i--) {
    segments.get(i).x = segments.get(i - 1).x;
    segments.get(i).y = segments.get(i - 1).y;
    
  }
  
  if (direction.equals("UP")) {
    segments.get(0).y -= 10;
  } else if (direction.equals("DOWN")) {
    segments.get(0).y += 10;
  } else if (direction.equals("LEFT")) {
    segments.get(0).x -= 10;
  } else if (direction.equals("RIGHT")) {
    segments.get(0).x += 10;
  }
}

void handleInput() {
    //if there's an input queue
  if (inputQueue.size() > 0) {
   
    
    //takes the first element of the input queue and applies it to the actual direction
    if (inputQueue.get(0).equals("LEFT") && !direction.equals("RIGHT")) {
      direction = "LEFT";
    } else if (inputQueue.get(0).equals("RIGHT") && !direction.equals("LEFT")) {
      direction = "RIGHT";
    } else if (inputQueue.get(0).equals("UP") && !direction.equals("DOWN")) {
      direction = "UP";
    } else if (inputQueue.get(0).equals("DOWN") && !direction.equals("UP")) {
      direction = "DOWN";
    }
    inputQueue.remove(0); //deletes the 1st element, making the 2nd element the 1st one now
  }
}

class Food {
  float x, y, w;
  
  Food() {
    w = 10;
    randomize();
  }
  
  void randomize() {
    x = (int)random(sw/w) * w;
    y = (int)random(sh/w) * w;
    
    for (int i = 0; i < segments.size(); i++) {
      if (segments.get(i).x == x && segments.get(i).y == y) {
        randomize(); //recursive, so it keeps randomizing until it finds a place that isn't on the snake
      }
    }
  }
  
  void draw() {
    fill(255, 0, 0);
    rect(x, y, w, w);
  }
}


class Segment {
  float x, y, w;
  
  Segment(float x, float y) {
    this.x = x;
    this.y = y;
    w = 10;
  }
  
  void update() {
    
  }
  
  void draw() {
    fill(100, 100, 100);
    rect(x, y, w, w);
  }
}
