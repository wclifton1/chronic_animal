/**
 * Many Serial Ports
 * 
 * Read data from the multiple Serial Ports
 */


import processing.serial.*;

Serial myPorts;  // Create a list of objects from Serial class
String dataIn;         // a list to hold data from the serial ports
int lf = 10;
int EOF = 41;
int rpm;
int i;
int v;
int[] vals = new int[5];

void setup() {
  size(400, 300);
  // print a list of the serial ports:
  println(Serial.list());
  // Open whatever ports ares the ones you're using.
  myPorts = new Serial(this, Serial.list()[0], 9600);
  //myPorts[1] = new Serial(this, Serial.list()[1], 9600);
  myPorts.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  dataIn = myPorts.readStringUntil(lf);
  dataIn = null;
}


void draw() {
  // clear the screen:
  background(0);
  // use the latest byte from port 0 for the first circle
  //fill(dataIn[0]);
  ellipse(width/3, height/2, 40, 40);
  // use the latest byte from port 1 for the second circle
  // fill(dataIn[1]);
  ellipse(2*width/3, height/2, 40, 40);
}

/** 
 * When SerialEvent is generated, it'll also give you
 * the port that generated it.  Check that against a list
 * of the ports you know you opened to find out where
 * the data came from
 */
void serialEvent(Serial thisPort) {
  // variable to hold the number of the port:
  int portNumber = -1;

  // iterate over the list of ports opened, and match the 
  // one that generated this event:
  /*
  for (int p = 0; p < myPorts.length; p++) {
   if (thisPort == myPorts[p]) {
   portNumber = p;
   }
   }
   */
  // read from the port:

  while (myPorts.available () > 0) {
    //println("starting to read");
    //thisPort.bufferUntil(lf);

    dataIn = myPorts.readStringUntil(')');  
    if (dataIn != null) {
      println("4");
      println("Got " + dataIn + " from serial port " + portNumber);
      println("44");
      vals = int(splitTokens(dataIn, ",*"));
      println("5");
      rpm=vals[1];
      i=vals[2];
      v=vals[3];
    }
  }
  // put it in the list that holds the latest data from each port:
  // tell us who sent what:
}

//select motor -> torque calc
//define set speed or calculate trend
//display torques
//boxes
//colors, red if RPM = 0, orange if <80% of set speed
//logo


/*
void serialEvent(Serial p) { 
 //read until (, throw it away
 //read until ), or if ( throw it away
 //if EOF reached, crunch data
 //motor number = read byte
 //trash the dash
 //rpm = read to next dash
 //trash the dash
 //v = to next dash
 //i = to next dash
 inString = p.readString(); 
 } 
 */
