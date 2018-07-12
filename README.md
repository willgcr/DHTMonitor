# DHTMonitor

## Project description

Thermostat with arduino and dht11.

It includes a controller application that communicates on the serial port with the arduino:

![controller](https://image.ibb.co/fQ3CGo/dht_img.png)

## How it works

The arduino receives the commands from serial port to measure the temperature or humidity then returns the results. The controller application was made using Processing (https://processing.org), it reads the results from serial port and shows to the user.

The arduino sketch uses two libraries from Adafruit (also included as zip files):

Adafruit_sensor -> https://github.com/adafruit/Adafruit_Sensor

DHT-sensor-library -> https://github.com/adafruit/DHT-sensor-library
