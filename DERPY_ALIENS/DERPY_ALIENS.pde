
  int alienx;
  int alieny;
  int alienxv;
  int alienyv;
  
  void setup()
  {
    size (400, 240); // Make screen 400 pixels wide and 
    frameRate (30); // Number of "draws" per second
    alienx=50; // Starting horizontal postion
    alieny=50; // Starting vertical position
    alienxv=5; // Side-to-side velocity (speed)
    alienyv=1; // Up-and-down velocity (speed)
    fill(255); // Set the color of shapes to white.
    stroke(0); // Set the border of shapes to black.
  }
  void draw() 
  {
    background(0); // Put down a black background.
    rect(alienx,alieny,10,10); // Make a rectangle
    move(); // Change the position of the rectangle
  }
  void move ()
  {
    alienx+=alienxv; // Add horizontal change to x.
    if (alienx>width) alienxv=-alienxv; //If it goes too far right, bounce.
    if (alienx<0) alienxv=-alienxv; // If it goes too far left, bounce.
    
    alieny+=alienyv; // Add vertical change to x (again).
    if (alieny>height) alienyv=-alienyv; // If it goes too far right, bounce.
    if (alieny<0) alienyv=- alienyv; // If it goes too far left, bounce.
  }
