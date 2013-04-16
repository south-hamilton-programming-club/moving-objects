
Flock flock;
int zDepth = -500;
Raptor falcon = new Raptor();

void setup() {
  size(1000, 800, P3D);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(new PVector(random(3*width/5,4*width/5),random(3*height/5,4*height/5), random(zDepth/3,2*zDepth/3)), 3.0, 0.05));
  }
  smooth();
}

void draw() {
  stroke(150,255,150);
  background(0);
  line(0,0,zDepth,width,0,zDepth);
  line(0,0,zDepth,0,height,zDepth);
  line(width,height,zDepth,0,height,zDepth);
  line(width,height,zDepth,width,0,zDepth);
  line(0,0,0,0,0,zDepth);
  line(width,height,0,width,height,zDepth);
  line(0,height,0,0,height,zDepth);
  line(width,0,0,width,0,zDepth);
  flock.run();
  falcon.run(flock.boids);
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(new PVector(mouseX,mouseY,random(0,zDepth)),2.0f,0.05f));
}










// The Flock (a list of Boid objects)

class Flock {
  ArrayList boids; // An arraylist for all the boids

  Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }

  void run() {
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);  
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}










// The Boid class

class Boid {

  public PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Boid(PVector l, float ms, float mf) {
    acc = new PVector(0,0,0);
    vel = new PVector(random(-1,1),random(-1,1),random(-1,1));
    loc = l.get();
    r = 4.0;
    maxspeed = ms;
    maxforce = mf;
  }

  void run(ArrayList boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    PVector flee = flee(falcon);       // Flee
    // Arbitrarily weight these forces
    sep.mult(1.5); //1.5
    ali.mult(1.0);
    coh.mult(1.7); //1.8
    flee.mult(2.0);
    // Add the force vectors to acceleration
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
    acc.add(flee);
  }

  // Method to update location
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  void seek(PVector target) {
    acc.add(steer(target,false));
  }

  void arrive(PVector target) {
    acc.add(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = target.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0)) desired.mult(maxspeed*(d/100.0)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new PVector(0,0,0);
    }
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + PI/2;
    fill(200,100);
    int a = round(255-(200*(loc.z/zDepth)));
    stroke(255, 100, 50, a);
    fill(255, a);
    pushMatrix();
    translate(loc.x,loc.y,loc.z);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.z < zDepth) loc.z = zDepth;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
    if (loc.z > 0) loc.z = 0;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList boids) {
    float desiredseparation = 8.0;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList boids) {
    float neighbordist = 25.0;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList boids) {
    float neighbordist = 18.0;
    PVector sum = new PVector(0,0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.dist(other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
  
  
  
  // Falcon Flee
  // Method checks for nearby falcons and steers away
  PVector flee(Raptor f) {
    float desiredseparation = 50.0;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    
    
    //Check to see if the falcon is too close
    float d = PVector.dist(loc,f.loc);
    
    // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
    if ((d > 0) && (d < desiredseparation)) {
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(loc,f.loc);
      diff.normalize();
      diff.div(d);        // Weight by distance
      steer.add(diff);
      count++;            // Keep track of how many
    }
    
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  //return location
  PVector getLoc(){
    return loc;
  }
}














class Raptor{
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  Raptor() {
    acc = new PVector(0,0,0);
    vel = new PVector(random(-1,1),random(-1,1),random(-1,1));
    loc = new PVector(10,10,0);
  }
  
  void run(ArrayList boids){
    
    //find closest bat
    float testBat;
    int targetBat = 0;
    float targetBatDist = 2000.0;
    
    for(int i=0; i<boids.size(); i++){
       Boid b = (Boid) boids.get(i);
       testBat = loc.dist(b.getLoc());
       if(testBat<targetBatDist){
         targetBat = i;
       }
       if(testBat<10.0){
         boids.remove(i);
         targetBat = 0;
       }
    }
    
    //kinematics
    Boid b = (Boid) boids.get(targetBat);
    PVector kill = loc.sub(b.getLoc(), loc);
    kill.normalize();
    acc.mult(0);
    acc.add(kill);
    vel.add(acc);
    vel.limit(3.0);
    loc.add(vel);
    
    //render falcon
    lights();
    int a = round(255-(200*(loc.z/zDepth)));
    stroke(0,250,250,a);
    fill(0,250,250,a);
    translate(loc.x,loc.y,loc.z);
    sphereDetail(10);
    sphere(10);
  }
}

void keyPressed(){
  if(keyCode == UP){
    noLoop();
  }
  if(keyCode == DOWN){
    loop();
    frameRate(60);
  }
  if(keyCode == RIGHT){
    frameRate(4);
  }
}

