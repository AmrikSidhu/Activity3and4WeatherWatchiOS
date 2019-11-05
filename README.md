## Weather WatchiOS : Activity 3 and 4
## Platform : Android.

Student Name  | Student ID
------------- | -------------
Amrik Singh Sidhu  | C0742318

## Particle code

// This #include statement was automatically added by the Particle IDE.
#include <InternetButton.h>
InternetButton button = InternetButton();
// creating string varaibles to get data from mobile/Watch
String temp = "";
String tempTom = "";
String precip = "";
String currentHour = "";
String currentMinute = "";

void setup() {
    button.begin();
    // expose functions
    Particle.function("setTemp", setTemp);
    Particle.function("setTempTom", setTempTom);
    Particle.function("setPrecip", setPrecip);
    Particle.function("setHour", setHour);
    Particle.function("setMinute", setMinute);
    // particle variables varables
    Particle.variable("temp", temp);
    Particle.variable("tempTomorrow", tempTom);
    Particle.variable("precipitation", precip);
    Particle.variable("currentHour", currentHour);
    Particle.variable("currentMinute", currentMinute);

}

void loop() {
    
    if (button.buttonOn(1)){
        
        // making loop of light if hours number is less than 11
        int hourNumber = currentHour.toInt();
        if (hourNumber <= 11){
             
             
              for(int i=0;i<=hourNumber;i++)
    {
    button.ledOn(i,0,100,0);
    delay(100);
    }
             
             
             
             delay(5000);
             button.allLedsOff();
        }
        // seprating digit by digit if more than 12
        else {
            int firstDigit = hourNumber/10;
            int secondDigit = hourNumber%10;
            
             button.ledOn(firstDigit,0,100,0);
             delay(800);
             button.allLedsOff();
             button.ledOn(secondDigit,0,100,0);
             delay(3000);
             button.allLedsOff();
        }
        
        if (currentMinute.toInt() <= 11){
             button.ledOn(currentMinute.toInt(),100,0,0);
             delay(3000);
             button.allLedsOff();
        }
        else{
            int firstDigit = currentMinute.toInt()/10;
            int secondDigit = currentMinute.toInt()%10;
            if (secondDigit == 0){
                secondDigit = 1;
            }
            
             button.ledOn(firstDigit,100,0,0);
             delay(800);
             button.allLedsOff();
             button.ledOn(secondDigit,100,0,0);
             delay(3000);
             button.allLedsOff();
            
        }
        
        Particle.publish("selectedOption",currentHour,60,PUBLIC);
    }
    if (button.buttonOn(2)){
        
        // diplaying present temprature : Loop Logic if less than 12
        
         if (temp.toInt() <= 11){
             
    for(int i=0;i<=temp.toInt() ;i++)
    {
    button.ledOn(i,0,0,100);
    delay(100);
    }
             
             
             
             delay(5000);
             button.allLedsOff();
        }
        else{
            int firstDigit = temp.toInt()/10;
            int secondDigit = temp.toInt()%10;
            if (secondDigit == 0){
                secondDigit = 1;
            }
            
             button.ledOn(firstDigit,0,0,100);
             delay(800);
             button.allLedsOff();
             button.ledOn(secondDigit,0,0,100);
             delay(3000);
             button.allLedsOff();
        }
        
    }
    if (button.buttonOn(3)){
        
        // diplaying present precipitation : Loop Logic if less than 12
        
        if (precip.toInt() <= 11){
            
            for(int i=0;i<=precip.toInt() ;i++)
    {
    button.ledOn(i,0,100,0);
    delay(100);
    }
             
             delay(5000);
             button.allLedsOff();
        }
        else{
            int firstDigit = precip.toInt()/10;
            int secondDigit = precip.toInt()%10;
            if (secondDigit == 0){
                secondDigit = 1;
            }
            
             button.ledOn(firstDigit,0,100,0);
             delay(800);
             button.allLedsOff();
             delay(800);
             button.ledOn(secondDigit,0,100,0);
             delay(3000);
             button.allLedsOff();
        }
    }
    if (button.buttonOn(4)){
        
        
        // diplaying future temprature : Loop Logic if less than 12
        
         if (tempTom.toInt() <= 11){
             
              for(int i=0;i<=tempTom.toInt() ;i++)
    {
    button.ledOn(i,0,0,100);
    delay(100);
    }
             
             
             
             delay(5000);
             button.allLedsOff();
        }
        else{
            int firstDigit = tempTom.toInt()/10;
            int secondDigit = tempTom.toInt()%10;
            
            if (secondDigit == 0){
                secondDigit = 1;
            }
            
             button.ledOn(firstDigit,0,0,100);
             delay(800);
             button.allLedsOff();
             button.ledOn(secondDigit,0,0,100);
             delay(3000);
             button.allLedsOff();
        }
    }

}
// functions to expose out 
int setTemp(String cmd){
    temp = cmd;
    return 1;
}


int setTempTom(String cmd){
    tempTom = cmd;
    return 1;
}

int setPrecip(String cmd){
    precip = cmd;
    return 1;
}

int setHour(String cmd){
    currentHour = cmd;
    return 1;
}
int setMinute(String cmd){
    currentMinute = cmd;
    return 1;
}
