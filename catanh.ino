int StartButton = 47;
int PauseButton = 45;
int GoTimeButton = 43;
int RollButton = 41;
int P1EndButton = 39;
int P1Light = 49;

int P2EndButton = 2;
int P2Light = 4;

int P3EndButton = 8;
int P3Light = 10;

int GoLight = 53;
int StopLight = 51;

void setup() {
  // put your setup code here, to run once:
  pinMode(53, OUTPUT);
  pinMode(51, OUTPUT);
  pinMode(49, OUTPUT);
  
  pinMode(47, INPUT);
  pinMode(45, INPUT);
  pinMode(43, INPUT);
  pinMode(41, INPUT);
  pinMode(39, INPUT);

  pinMode(3, OUTPUT);
  digitalWrite(3, LOW);
  pinMode(9, OUTPUT);  
  digitalWrite(9, LOW);  

  digitalWrite(47, HIGH);
  digitalWrite(45, HIGH);
  digitalWrite(43, HIGH);
  digitalWrite(41, HIGH);
  digitalWrite(39, HIGH);

  pinMode(2, INPUT);
  pinMode(8, INPUT);  
  digitalWrite(2, HIGH);
  digitalWrite(8, HIGH);

  pinMode(4, OUTPUT);
  pinMode(10, OUTPUT);
  digitalWrite(4, HIGH);
  digitalWrite(10, HIGH);

  Serial.begin(9600);

}

void debounce(int pin){
    while (digitalRead(pin)==LOW){}
    delay(150);
}

boolean buttonPressed(int button){
   if (digitalRead(button) == LOW){
      debounce(button);
       return true;
   }
   else{
       return false;
   }
}

void loop() {
  if (buttonPressed(StartButton)){
     Serial.print("S");
  }
  if (buttonPressed(PauseButton)){
     Serial.print("P");
  }
  if (buttonPressed(GoTimeButton)){
     Serial.print("G");
  }
  if (buttonPressed(RollButton)){
     Serial.print("R");
  }
  
  if (buttonPressed(P1EndButton)){
     Serial.print("1");
  }
  if (buttonPressed(P2EndButton)){
     Serial.print("2");
  }
  if (buttonPressed(P3EndButton)){
     Serial.print("3");
  }
  
  if (Serial.available()){
      char s = Serial.read();
      if (s=='0'){
         //turn off player lights
         digitalWrite(P1Light, LOW);
         digitalWrite(P2Light, LOW);
         digitalWrite(P3Light, LOW);
      }
      if (s=='1'){
         //turn on player light 1
         digitalWrite(P1Light, HIGH);
      }
      if (s=='2'){
         //turn on player light 2
         digitalWrite(P2Light, HIGH);
      }
      if (s=='3'){
         //turn on player light 3
         digitalWrite(P3Light, HIGH);
      }      
      if (s=='G'){
         //turn on go light
         digitalWrite(GoLight, HIGH);
         digitalWrite(StopLight, LOW);
      }
      if (s=='S'){
         //turn on stop light
         digitalWrite(StopLight, HIGH);
         digitalWrite(GoLight, LOW);         
      }
  }
}
