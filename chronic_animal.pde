// Example by Tom Igoe

import processing.serial.*;

//CONSTANTS
int serialChoice = 11;
float critV = 13.2;
float lowV = 13.6;
int rpmCutoff = 6000;

int Y_AXIS = 1;
int X_AXIS = 2;
color b1, b2, warning, stop;
PImage logo;
PImage line;
PFont font;
String rHead="RPM ";
String bHead="Battery ";
String tHead="Current ";
String pHead="Power ";
float v = 0.0;
int rpm = 0;
float i = 0.0;
float p = 0.0;
PrintWriter output;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port

void setup() {
  size(1100, 650);
  font = loadFont("PTSans-Regular-48.vlw");
  textFont(font);
  // Define colors
  b1 = color(0);
  b2 = color(100, 102, 119);
  warning = color(240, 145, 72);
  stop = color(162, 25, 25);
  logo = loadImage("logo.png"); // Load the original image
  line = loadImage("line.png"); // Load the original image
  output = createWriter(month()+"-"+day()+" "+hour()+"-"+minute()+"-"+second()+" chronic.txt");
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[serialChoice], 9600);
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

      // Fill variables
      if (vals.length == 6) {
        rpm = vals[1];
        i = vals[2]/1000.0;
        v = vals[3]/1000.0;
        p = vals[4]/1000.0;
        println("RPM = "+rpm+" Current = "+i+" Volts = "+v+" Power = "+p);
        if (v < critV || rpm < rpmCutoff) {
          setGradient(0, 0, width, height, b1, stop, Y_AXIS);
        }
        else if (v < lowV) {
          setGradient(0, 0, width, height, b1, warning, Y_AXIS);
        }

        else {
          setGradient(0, 0, width, height, b1, b2, Y_AXIS);
        }
        image(line, 50, 60);
        image(logo, 120, 30);
        text(rHead, 80, 300);
        text(rpm, 250, 300);
        text("RPM", 450, 300);
        text(tHead, 80, 400);
        text(i, 250, 400);
        text("A", 450, 400);
        text(bHead, 80, 500);
        text(v, 250, 500);
        text("V", 450, 500);
        text(pHead, 80, 600);
        text(p, 250, 600);
        text("W", 450, 600);
        output.println(month()+"/"+day()+","+hour()+":"+minute()+":"+second()+","+rpm+","+i+","+v+","+p);
      }
    }
  }
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void keyPressed() {
  myPort.write(key);
  myPort.write(10);
}

