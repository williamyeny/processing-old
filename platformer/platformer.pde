//AUTHOR: William Ye
Player player;
int[][][] map;
ArrayList<Block> blocks;
Camera camera;
String direction;
float playerSpeed;
float mapLength;
float respawnTimer;
boolean dead;
int currentMap;
String[] subText;
float flashCol;
boolean errorNoMapsLeft;

void setup() {
  size(600,600);
  noStroke();
  textAlign(CENTER);
  player = new Player(100, 200);
  camera = new Camera(0, 0);
  direction = "IDLE";
  playerSpeed = 3;
  flashCol = 255;
  
  map = new int[][][] {
    {
      {0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0},
      {0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0},
      {1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1},
    },
    {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1},
      {0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    },
    {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0},
      {0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
      {1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    },
    {
      {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    },
    {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
    },
    {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
      {1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0,},
      {1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,},
      {1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0,},
      {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0,},
      {1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0,},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
      {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,},
    }
  
  };
  subText = new String[] {
    "ARROW KEYS TO NAVIGATE. GET TO THE END.",
    "WATCH YOUR STEP.",
    "THIS MAP IS KINDA BROKEN HAHA.",
    "TAKE A BREAK.",
    "IT'S OK TO LEAP BLINDLY",
    "THAT'S IT FOR NOW. \nTHIS FILE IS NAMED ADVANCED_PLATFORMER IN MY FOLDER. \nALSO CHECK OUT AVOID_2 (IT'S PRETTY BOSS).",
  };
  currentMap = 0;
  initializeMap(currentMap);
}

void reset() {
  player = new Player(100, 200);
  camera.x = 0;
  camera.y = 0;
  dead = false;
}

void initializeMap(int index) {
  flashCol = 255;//flash
  
  blocks = new ArrayList<Block>();
  for (int i = 0; i < map[index].length; i++) {
    for (int j = 0; j < map[index][i].length; j++) {
      if (map[index][i][j] == 1) {
        float whiteColor = random(150, 200);
        blocks.add(new Block(j * 50, i * 50 + (width - map[index].length * 50), color(whiteColor, whiteColor, whiteColor)));
      }
    }
  }
  mapLength = map[index][0].length * 50;
}

void draw() {
  background(50, 50, 50);
  
  //text stuff
  textSize(40);
  fill(255, 255, 255);
  text("MAP " + (currentMap + 1), width/2 - camera.x, 100);
  
  textSize(20);
  text(subText[currentMap], width/2 - camera.x, 145);
  
  update();
  player.draw();
  for (Block b : blocks) {
    b.draw();
  }
  
  //creates the screen flash effect
  fill(255, 255, 255, flashCol);
  rect(0, 0, width, height);
  
  if (errorNoMapsLeft) {
    fill(255, 0, 0);
    textSize(50);
    text("ERROR: NO MAPS LEFT", width/2, height/2);
  }
}

void update() {
  
  if (!dead && flashCol <= 0) {
    player.update();
    updateCamera();
  }
  
  if (player.y > height) { //player dies
    dead = true;
  }
  
  if (player.x > camera.x + width - player.w && !dead) { //next level
    if (currentMap < map.length - 1) {
      currentMap++;
      initializeMap(currentMap);
      reset();
    } else {
      errorNoMapsLeft = true;
    }
  }
    
  flashCol-= 3; //makes screen more transparent
  
  if (dead) {
    camera.x += -camera.x/10;
    camera.y += -camera.y/10;
    if (dist(camera.x, camera.y, 0, 0) < 0.3) {
      reset();
    }
  }
  for (int i = 0; i < blocks.size(); i++) {
    Block b = blocks.get(i);
    /*
    TODO: 
    -reposition player.update() behind this
    -rewrite the bottom to accomdate for state changes
    */
    
    //collision code
    if (player.y + player.h >= b.y && player.y + player.h - player.sy <= b.y && player.x + player.w > b.x && player.x < b.x + b.w) {
      player.y = b.y - player.h;
      player.touching = true;
      player.sy = 0;
    }
    
    if (player.x < b.x + b.w && player.x + playerSpeed >= b.x && player.y + player.h > b.y + abs(player.sy) && player.y < b.y - abs(player.sy) + b.h) {
      player.x = b.x + b.w;
    }
    if (player.x + player.w > b.x && player.x + player.w - playerSpeed <= b.x && player.y + player.h > b.y + abs(player.sy) && player.y < b.y + b.h - abs(player.sy)) {
      player.x = b.x - player.w;
    }
    
    if (player.y < b.y + b.h && player.y + player.sy > b.y && player.x + player.w > b.x && player.x < b.x + b.w) {
      player.y = b.y + b.h;
      player.sy = 0;
    }
  }
  
}

void updateCamera() {
  if (player.x - camera.x >= width - 200 && player.sx != 0) { 
    camera.x += playerSpeed;
  }
  if (camera.x > mapLength - width && camera.x - playerSpeed <= mapLength - width) {
    camera.x = mapLength - width;
  }
  
  
  if (player.x - camera.x <= 200 && player.sx != 0) { 
    camera.x -= playerSpeed;
  }
  if (camera.x < 0 && camera.x + playerSpeed >= 0) {
    camera.x = 0;
  }
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      direction = "LEFT";
    }
    if (keyCode == RIGHT ) {
      direction = "RIGHT";
    }
    if (keyCode == UP && player.touching) {
      player.sy = -10;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT && direction.equals("LEFT")) {
      direction = "IDLE";
    }
    if (keyCode == RIGHT && direction.equals("RIGHT")) {
      direction = "IDLE";
    }
  }
}

class Camera {
  float x, y;
  Camera(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Player {
  float x, y, w, h, sx, sy;
  color col;
  boolean touching;
  Player(float x, float y) {
    this.x = x;
    this.y = y;
    w = 25;
    h = 45;
    col = color(255, 0, 0);
  }
  
  void update() {
    y += sy;
    x += sx;
    
    sy += 0.3;
    
    if (direction.equals("LEFT")) {
      sx = -playerSpeed;
    } else if (direction.equals("RIGHT")) {
      sx = playerSpeed;
    } else {
      sx = 0;
    }
    
    touching = false;
  }
  void draw() {
    fill(col);
    rect(x - camera.x, y - camera.y, w, h);
  }
}

class Block {
  float x, y, w, h;
  color col;
  
  Block(float x, float y, color col) {
    this.x = x;
    this.y = y;
    w = 50;
    h = 50;
    this.col = col;
  }
  
  void update() {}
  
  void draw() {
    fill(col);
    rect(x - camera.x, y - camera.y, w, h);
  }
  
}
