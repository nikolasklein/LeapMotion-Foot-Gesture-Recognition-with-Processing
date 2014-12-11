import de.voidplus.leapmotion.*;

LeapMotion leap;

float leap_hand_bottom = 0;
Hand leap_hand;
boolean leap_handset = false;
float handX, handY, handZ, centerX, centerY;
// center noch genutzt? wird doch gar nicht mehr gebraucht, da nur bottom + bottomtop interessant ist — 11.12.14 19:33  

float bottom = 0;
float bottomTop = 0;
float bottomHeight = 50;

float lowest = 0;

boolean exitBottom = false;
boolean exitBottomXSet = false;
float exitBottomX = 0;



float distance = 0;
float distanceX = 0;
float distanceY = 0;

float prevDistance = 0;
float prevDistanceX = 0;
float prevDistanceY = 0;

int time = 0;
int prevTime = 0;


// using an array of speeds to calculate averagespeed
FloatList speedArray;

// avgSpeed is the overall avgSpeed — the latest is used for the most recent avgSpeed to get the latest changes
float avgSpeed = 0;
float avgSpeedLatest = 0;

float exitSpeed = 0;
boolean saveSpeed = false;



void setup() {
  size(600 , 700);
  background(255);
  
  leap = new LeapMotion(this);
  rectMode(CENTER);
  
  speedArray = new FloatList();

}

void draw() {
  // int fps = leap.getFrameRate();
  time = millis();
  noStroke();
  background(255, 255, 255);
  
  setHands();

  // anzeigen der werte
  if (leap_handset) {
    
    //ummappen der werte aufgrund der umgekehrten leap motion 
    handX = round(map(leap_hand.getPosition().x, 500, 0, 0, width));
    handY = round(map(leap_hand.getPosition().y, 200, 600, height, 0));
    handZ = round(leap_hand.getPosition().z);
    
    if(lowest < handY){
      lowest = handY;
    }
    
    text(" x // "  + handX, 20, 40);
    text(" y // "  + handY, 20, 60);
    text(" z // "  + handZ, 20, 80);
    
    text(" centerX // "  + centerX, 20, 110);
    text(" centerY // "  + centerY, 20, 130);
    
    //bottom is actually the highest value, because the leap motion is turned around
    text(" lowest // "  + lowest, 20, 160);
    
    
    //setting control values
    if(handY < bottomTop && !exitBottom){
      exitBottom = true;
      saveSpeed  = true;
    }else if(handY >= bottomTop && exitBottom){
      exitBottom = false;
      exitBottomXSet = false;
      saveSpeed = true;
    }
    
    if(exitBottom && !exitBottomXSet){
      exitBottomXSet = true;
      exitBottomX = handX;
    }
    
    if(exitBottomXSet){
      distance = dist(exitBottomX, bottomTop, handX, handY);
      distanceX = exitBottomX - handX;
      distanceY = bottomTop - handY;
    }

    //calculating the speeds
    
    float diffTime = time - prevTime;
    
    float diffDistance = abs(distance - prevDistance);
    float diffDistanceX = abs(distanceX - prevDistanceX);
    float diffDistanceY = abs(distanceY - prevDistanceY);
    
    float speed = round((diffDistance / diffTime)*1000);
    speedArray.append(speed);
    
    float avgHelper = 0;    
    if(speedArray.size() > 10){
      for(int i = 1; i < 10; i++){
        avgHelper += speedArray.get(speedArray.size() - i);
      }
    }
    avgSpeed = avgHelper / 10;
    
    avgHelper = 0;
    if(speedArray.size() > 2){
      for(int i = 1; i < 2; i++){
        avgHelper += speedArray.get(speedArray.size() - i);
      }
    }
    avgSpeedLatest = avgHelper / 2;
    
    if(saveSpeed){
      saveSpeed = false;
      exitSpeed = avgSpeedLatest;
    }
    

    // creating help-lines
    fill(255, 0, 0);
    ellipse(handX, handY, 10, 10);
    
    
    
    //creating lines
    if(bottom != 0){
      stroke(0, 0, 0, 30);
      line(0, bottomTop, width, bottomTop);
      stroke(0, 0, 0, 70);
      line(0, bottom, width, bottom);
      
      stroke(0, 0, 0, 20);
      line(0, lowest, width, lowest);
      
    }
    
    if(exitBottomXSet){
      fill(0, 0, 0, 90);
      ellipse(exitBottomX, bottomTop, 3, 3);
      
      fill(255, 0, 0);
      text(" distance // "  + distance, 20, 190);
      text(" distanceX // "  + distanceX, 20, 210);
      text(" distanceY // "  + distanceY, 20, 230);
      
      text(" speed // "  + speed, 20, 260);
      text(" avgSpeed // "  + avgSpeed, 20, 280);
      text(" avgSpeedLatest // "  + avgSpeedLatest, 20, 300);
      text(" breakSpeed // "  + exitSpeed, 20, 320);      
      //need the enter and exit points

      
    }
    
        
  }
  
  prevTime = time;
  prevDistance = distance;
  prevDistanceX = distanceX;
  prevDistanceY = distanceY;
  
}

void keyPressed() {
  if (key == ' ') {
    if(leap_handset){
      centerX = handX;
      centerY = handY;
      bottom = centerY;
      bottomTop = bottom-bottomHeight;
    }
  }
}


void setHands(){
 // hand info reset
  leap_hand_bottom = 0;
  leap_hand = null;
  leap_handset = false;
  int number = 0;
  
  
  
  //setHand Start
  for (Hand hand : leap.getHands()) {
    
    //proof draw for wrong positions and wrong stuff
    number++;
    fill(#FF0000);
    
    leap_hand = hand;
    leap_handset = true;
    
    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();

    
  }
}




void leapOnInit() {
  println("Leap Motion Init");
}
void leapOnConnect() {
  println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

