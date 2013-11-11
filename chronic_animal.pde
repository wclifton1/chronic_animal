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
String rHead="Speed ";
String vHead="Battery ";
String iHead="Current ";
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
  //output.println("Start");
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
  //output.println(mouseX);  // Write the coordinate to the file
  while (myPort.available () > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      // println(myString);
      // The data is split into an array of Strings with a comma or asterisk as a delimiter and converted into an array of integers.
      int[] vals = int(splitTokens(myString, ",*")); 

      // Fill variables
      //println(myString);
      if (vals.length == 6) {
        rpm = vals[1];
        i = vals[2]/1000.0;
        v = vals[3]/1000.0;
        p = vals[4]/1000.0;
        textSize(48);
        textAlign(LEFT);
        println(nf(month(),2)+"/"+nf(day(),2)+" "+hour()+":"+nf(minute(),2)+":"+nf(second(),2)+" RPM = "+rpm+" Current = "+i+" Volts = "+v+" Power = "+p);
        if (v < critV) {
          setGradient(0, 0, width, height, b1, stop, Y_AXIS);
          text("Change Battery Now", 575, 500);
        }
        else if (v < lowV) {
          setGradient(0, 0, width, height, b1, warning, Y_AXIS);
          text("Low Battery", 575, 500);
        }
        else {
          setGradient(0, 0, width, height, b1, b2, Y_AXIS);
        }
        if (rpm < rpmCutoff) {
          setGradient(0, 0, width, height, b1, stop, Y_AXIS);
          text("Pump Fail", 575, 300);
        }
        image(line, 50, 60);
        image(logo, 120, 30);
        textSize(48);
        textAlign(LEFT);
        text(rHead, 80, 300);
        text("RPM", 450, 300);
        text(iHead, 80, 400);
        text("A", 450, 400);
        text(vHead, 80, 500);
        text("V", 450, 500);
        text(pHead, 80, 600);
        text("W", 450, 600);
        textAlign(RIGHT);
        text(nfc(int(rpm/1000)*1000), 425, 300);
        text(String.format("%.2f", i),425, 400);
        text(String.format("%.2f", v), 425, 500);
        text(String.format("%.2f", p), 425, 600);
        textSize(26);
        text("Last Update: "+nf(month(),2)+"/"+nf(day(),2)+"/"+nf(year(),2)+" "+hour()+":"+nf(minute(),2)+":"+nf(second(),2), 1075, 625);
        output.println(nf(month(),2)+"/"+nf(day(),2)+","+hour()+":"+nf(minute(),2)+":"+nf(second(),2)+","+rpm+","+i+","+v+","+p);
    output.flush();  
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

