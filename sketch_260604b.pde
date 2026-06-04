import processing.serial.*;

Serial myPort;

float angle = 0;
float distance = 400;

void setup() {

  size(1200, 700);

  println(Serial.list());

  // CHANGE THE NUMBER IF NEEDED
  myPort = new Serial(this, Serial.list()[2], 115200);

  myPort.bufferUntil('\n');
}

void draw() {

  background(0);

  translate(width/2, height-50);

  drawRadar();
  drawSweep();
  drawTarget();
  drawTextInfo();
}

void drawRadar() {

  stroke(0,255,0);
  strokeWeight(2);
  noFill();

  arc(0,0,1000,1000,PI,TWO_PI);
  arc(0,0,800,800,PI,TWO_PI);
  arc(0,0,600,600,PI,TWO_PI);
  arc(0,0,400,400,PI,TWO_PI);
  arc(0,0,200,200,PI,TWO_PI);

  for(int i=0;i<=180;i+=30){

    float x = cos(radians(i+180))*500;
    float y = sin(radians(i+180))*500;

    line(0,0,x,y);
  }
}

void drawSweep() {

  float x = cos(radians(angle+180))*500;
  float y = sin(radians(angle+180))*500;

  stroke(0,255,0);
  strokeWeight(4);

  line(0,0,x,y);
}

void drawTarget() {

  if(distance < 200){

    float radius = map(distance,0,200,0,500);

    float x = cos(radians(angle+180))*radius;
    float y = sin(radians(angle+180))*radius;

    noStroke();
    fill(255,0,0);

    ellipse(x,y,20,20);
  }
}

void drawTextInfo() {

  fill(0,255,0);

  textSize(24);

  text("Angle: " + nf(angle,0,0), -550,-600);
  text("Distance: " + nf(distance,0,0) + " cm", -550,-560);
}

void serialEvent(Serial p) {

  String data = p.readStringUntil('\n');

  if(data == null) return;

  data = trim(data);

  String[] values = split(data, ',');

  if(values.length == 2){

    angle = float(values[0]);
    distance = float(values[1]);
  }
}
