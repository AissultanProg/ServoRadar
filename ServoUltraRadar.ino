#include <Servo.h>

#define SERVO_PIN 9
#define TRIG_PIN 7
#define ECHO_PIN 6

Servo radarServo;

int angle = 0;
int direction = 1;

long getDistance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);

  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH, 30000);

  if (duration == 0) {
    return 400; // no object detected
  }

  long distance = duration * 0.0343 / 2;

  if (distance > 400) {
    distance = 400;
  }

  return distance;
}

void setup() {
  Serial.begin(115200);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  radarServo.attach(SERVO_PIN);

  radarServo.write(0);
  delay(500);
}

void loop() {

  radarServo.write(angle);

  delay(15); // allow servo to move

  long distance = getDistance();

  // Send angle,distance to PC
  Serial.print(angle);
  Serial.print(",");
  Serial.println(distance);

  angle += direction;

  if (angle >= 180) {
    angle = 180;
    direction = -1;
  }

  if (angle <= 0) {
    angle = 0;
    direction = 1;
  }
}