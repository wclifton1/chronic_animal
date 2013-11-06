// Example by Tom Igoe

import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port

int rpm;
float i, v;    // Used to color background

void setup() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
}

void draw() {
  while (myPort.available () > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
     // println(myString);
      // The data is split into an array of Strings with a comma or asterisk as a delimiter and converted into an array of integers.
      int[] vals = int(splitTokens(myString, ",*")); 

      // Fill r,g,b variables
      if (vals.length == 5) {
        rpm = vals[1];
        i = vals[2]/1000.0;
        v = vals[3]/100.0;
        println("RPM = "+rpm+" Current = "+i+" Volts = "+v);
      }
    }
  }
}

