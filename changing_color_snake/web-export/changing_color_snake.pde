void setup() {
  size(500,500); //size(width,height);
  // This is a comment.
  background(255,100,15); //colors run from 0 -255
  noStroke();
}
// GOAL: Make color vary with speed

float xPos; // horizontal position of circle
float xPosOld = 0; // previous horizontal position of circle
float yPos; // vertical position of circle
float yPosOld = 0; // previous vertical position of circle

float changeInPosition;
float changeInX;
float changeInY;

int multiplier = 10; //smaller numbers mean harder to reach maximum color value

int span = 120; // number of frames to include in the running average
float[] recChanges = new float[span];
float changeSum;
float avgChange;

void draw() {  
 // circle
 
  xPos = mouseX;
  yPos = mouseY;
  changeInX = xPos - xPosOld;
  changeInY = yPos - yPosOld;
  changeInPosition = sqrt(pow(changeInX,2) + pow(changeInY,2));
  
  //recChanges.append(changeInPosition);
  //recChanges.remove(0);
  for (int i = 0; i <= span-2; i++) {
    recChanges[i] = recChanges[i+1];
  }
  recChanges[span-1] = changeInPosition;
  
  changeSum = 0;
  for (int i = 0; i < span ; i++){
    changeSum += recChanges[i];
  }
  avgChange = changeSum / span;
  
  fill(avgChange*multiplier);
  
  ellipse(xPos, yPos, 55, 55); //ellipse (x,y,width,height)
  
  xPosOld = xPos;
  yPosOld = yPos;
}
  

