boolean gameStart = false;

PFont font;

float x = 400;    //ball position left / right
float y = 250;    //ball position up / down
float speedX = 4;
float speedY = 3;
int diam;


int z = 210;  //paddle position up/down left paddle
int r = 210;  //paddle position up/down right paddle
int f = 10;   //paddle position left/right left paddle
int g = 775;  //paddle position left/right right paddle

int rectwidth = 15;
int rectheight = 80;

int leftwin = 0;
int rightwin = 0;

void setup() {
  size(800, 500);        //setup only and sphere mode
  smooth();
}
void draw() {
  background(150);
  fill(100);
  rect(395, 0, 10, 500);        //draw rectangle backgrounds
  rect(0, 0, width, 10);
  rect(0, 490, width, 10);

  stroke(0);
  fill(25, 240, 50);
  font = loadFont("Bauhaus93-48.vlw");
  textFont(font, 72);
  text("Pong", 320, 100);



  if (leftwin > 0) {
    fill(255);
    rect(20, 15, 5, 45);
  }
  if (leftwin > 1) {
    fill(255);
    rect(35, 15, 5, 45);
  }
  if (leftwin > 2) {
    fill(255);
    rect(50, 15, 5, 45);
  }
  if (leftwin > 3) {
    fill(255);
    rect(65, 15, 5, 45);
  }
  if (leftwin > 4) {
    font = loadFont("Bauhaus93-48.vlw");
    textFont( font, 32);
    text("Winner!", 150, 50);
    text("Loser!", 450, 50);
    if (mousePressed == true) {
      leftwin= 0;
      rightwin= 0;
      gameStart = false;
    }
  }


  if (rightwin > 0) {
    fill(255);
    rect((width - 20), 15, 5, 45);
  }
  if (rightwin > 1) {
    fill(255);
    rect((width - 35), 15, 5, 45);
  }
  if (rightwin > 2) {
    fill(255);
    rect((width - 50), 15, 5, 45);
  }
  if (rightwin > 3) {
    fill(255);
    rect((width - 65), 15, 5, 45);
  }
  if (rightwin > 4) {
    font = loadFont("Bauhaus93-48.vlw");
    textFont( font, 32);
    text("Winner!", 450, 50);
    text("loser!", 150, 50);
    if (mousePressed == true) {
      leftwin= 0;
      rightwin= 0;
      gameStart = false;
    }
  }

  stroke(0);
  fill(60, 240, 20);      
  diam = 15;                //draw ellipse (ball)
  ellipse(x, y, diam, diam);

  fill(25, 240, 50);        //paddle colors
  stroke(255);

  rect(f, z, rectwidth, rectheight);           //left paddle

  rect(g, r, rectwidth, rectheight);           //right paddle


  if (gameStart) {

    stroke(0);
    line(f+15, z, f+15, z+80);
    line(g, r, g, r+80);

    y = y + speedY;
    x = x + speedX;

    if (y < 17.5 || y > 482.5) {
      speedY = speedY *-1;
      y=y +speedY;
    }
    if (x <= f+16 && x >= f+14 && y <= z+80 && y>= z) {
      speedX = speedX * -1;
      x = x +speedX;
    }
    if (x <= g+1 && x >= g-1 &&  y<= r+80 && y>= r) {
      speedX = speedX * -1;
      x = x +speedX;
    }
    if (x < 0) {
      (gameStart) = false;
      x = 400;
      y = 250;
      rightwin = (rightwin + 1);
    }
    if (x > 800) {
      (gameStart) = false;
      x = 400;
      y = 250;
      leftwin = (leftwin + 1);
    }
  }
}
void keyPressed() {
  loop(); 
  //right paddle (player 1) movements\\
  if (z >= 20) {

    if (key == 'w') {
      z-= 20;  //move up
    }
  }
  if (z <= 400) {
    if (key == 's') {
      z+= 20;              //move down
    }
  }
  if (f >= 10) {
    if (key == 'a') {      //move left
      f= f-20;
    }
  }
  if (f <=340) {

    if (key == 'd') {
      f = f+ 20;              //move right
    }
  }

  //left paddle (player 2) movements\\
  if (r >= 20) {
    if (key == 'o') {
      r-= 20;              //move up
    }
  }
  if (r <= 400) {
    if (key == 'l') {
      r+= 20;              //move down
    }
  }
  if (g>= 450) {
    if (key == 'k') {
      g-= 20;              //move left
    }
  }
  if (g <= 790) {
    if (key == ';') {
      g+= 20;              //move right
    }
  }
  if (key =='v') {
    speedX = abs(speedX)-1;
  }
  if (key == 'b') {
    speedX = abs(speedX)+1;
  }
}
void mousePressed() {
  gameStart = !gameStart;
}

