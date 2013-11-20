/* Sketch to test data logging gui.
   Gui sends '2' to serial communiation initiating program
   LaunchPad sends serial header information followed by "&"
   LaunchPad then sends serial data to be logged.
   At the end of serial data, LaunchPad sends "@" symbol, indicating
     end of run.
  Based on AnalogInOutSerial sketch from 
  Energia Analog examples by Tom Igoe
  Analog input, analog output, serial output
 
  The circuit:
   PWM output on P1_6 to resistor to analog read on P1_0.  
   Capacitor bridges P1_0 to ground, generating analog signal. 
   Analog read result printed to the serial monitor.
 
modified November 16, 2013 
 This code is in the public domain.
 
 */

const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to
const int analogOutPin = PD_0; // Analog output pin that the LED is attached to

int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)
int nLoop =1;
int i;
int j;
unsigned int time;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
}

void loop() {
time = 0;
  readSerial();
  Serial.print("number of loops = ");
  Serial.println(nLoop);
  Serial.print("time");
  Serial.print('\t');
  Serial.println("sensor");    
    Serial.println("&");     // signals end of header, begin writting data 
  for (i=0; i<nLoop; ++i){
    for (j=0; j<25; ++j) {
    analogWrite(analogOutPin, j*10);
    delay (200);
    sensorValue = analogRead(analogInPin);  
    time +=200;
    Serial.print(time);
    Serial.print('\t');
    Serial.println(sensorValue);    
        }
    for (j=25; j>=0; --j) {
    analogWrite(analogOutPin, j*10);
    delay (200);
    sensorValue = analogRead(analogInPin);            
    time +=200;
    Serial.print(time);
    Serial.print('\t');
    Serial.println(sensorValue);    
    }
  }   
   Serial.println("@"); // signal GUI to end run               
}

void   readSerial() {
//  Serial.println("enter number of loops");
  int k = 0;
  while (Serial.available()<= 0) {
  }
  while (Serial.available() > 0){  
 while(k !=2) {             // when GUI writes "2", program is initiated
   k = Serial.read()-48;
  }}

}
