/* 

This file is part of DHTMonitor - v0.1
Copyright © 2018 Willian Gabriel Cerqueira da Rocha

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.


All rights reserved.

Willian Gabriel Cerqueira da Rocha
willianrocha[at]riseup[dot]net
http://willianrocha.tk
    
*/

#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

#define DHTPIN 2
#define DHTMODEL DHT11

DHT dht11 (DHTPIN, DHTMODEL);

String recvBuffer = "";
float humidity;
float temperature;

void setup () {
  Serial.begin (9600);
  dht11.begin ();
}

void loop () {
  if (Serial.available () > 0){
    recvBuffer = Serial.readStringUntil ('\n');
  }
  if (recvBuffer == "temperature"){
    readTemp ();
    Serial.println (temperature);
    recvBuffer = "";
  } 
  else if (recvBuffer == "humidity") {
    readUmid ();
    Serial.println (humidity);
    recvBuffer = "";
  } 
}

void readTemp (){
  temperature = dht11.readTemperature ();
}

void readUmid (){
  humidity = dht11.readHumidity ();
}
