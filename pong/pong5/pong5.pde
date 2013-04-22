//create paddle
//create ball
//update screen every with new position of the ball
//start in 1D
//build up to 2D

void setup(){
  size(700,500);
  background(100,200,100);
  smooth();
  frameRate(200); //repeat draw() 200 times per second
}

float ballX = 50; // float is decimal number. this variable is declared
float ballY = 250/2;
float ballSpeedX = 1; // how much distance to add to the ball each frame update
float ballSpeedY = 0;
int paddleWidth = 80;

void draw(){
  background(100,200,100);
  rect(width-20, mouseY, 10, paddleWidth); // rect(x,y,width,height);
  //decide which way the ball should move
  // does it hit the paddle?
  if(ballX>(width-20) && ballY>mouseY && ballY<(mouseY+paddleWidth)){ 
    //float angle = random(-60,60); //spits out an angle in degrees
    ballSpeedX = -1;
    //ballSpeedY = 1*sin(angle);
  }
  
  if(ballX < 0){ //does it hit the left side of the screen?
    ballSpeedX = -ballSpeedX;
  }
  
  //if ball hits top edge
  if(ballY < 0){
    ballSpeedY = -ballSpeedX;
  }
  
  // if ball hits top edge
  if(ballY>height){
    ballSpeedY = -ballSpeedX;
  }
  
  //kills program if we loose
  if(ballX>width){
    exit();
  }
  ballX += ballSpeedX; //add ballSpeedX to ballX each repetition
  ballY += ballSpeedY;
  print("ballY: "+ str(ballY)+". ballSpeedY: "+str(ballSpeedY)+"\n");
  fill(255,0,0);
  ellipse(ballX,ballY,20,20);
}
