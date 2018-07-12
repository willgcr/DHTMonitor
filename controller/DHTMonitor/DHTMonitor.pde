/* 

DHTMonitor - v0.1, Copyright © 2018
Willian Gabriel Cerqueira da Rocha

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
 
import processing.serial.*;

public class button {
  private int width, height, x, y;
  private float xfactor, yfactor;
  private String label;
  private String function = label = "";
  private PFont zeroFont;
  public button (String label, int x, int y, int width, int height, String function, float xfactor, float yfactor) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.function = function;
    this.xfactor = xfactor;
    this.yfactor = yfactor;
  }
  public boolean over () {
    if (mouseX >= this.x && mouseX <= this.x + this.width && mouseY >= this.y && mouseY <= this.y + this.height) {
      return true;
    } else {
      return false;
    }
  }
  public void update () {
    if (this.over ()) {
      this.highlight ();
    } else {
      this.restore ();
    } 
    if (mousePressed == true) {
      if (this.over ()) {
        method (function);
        delay (150);
      }
    }
  }
  public void highlight () {
    stroke (127);
    fill (51);
    rect (this.x, this.y, this.width, this.height);
    zeroFont = createFont ("Arial", 18);
    textFont (zeroFont);
    fill (255);
    text (this.label, this.x + (this.width * this.xfactor), this.y + (this.height * this.yfactor));
    return;
  }
  public void restore () {
    stroke (127);
    fill (255);
    rect (this.x, this.y, this.width, this.height);
    zeroFont = createFont ("Arial", 18);
    textFont (zeroFont);
    fill (0);
    text (this.label, this.x + (this.width * this.xfactor), this.y + (this.height * this.yfactor));
    return;
  }
}

Serial serialPort;
boolean portError;
button buttonCOM, buttonHumid, buttonTemp;
String comPort = "Serial port";
String recvBuffer;
String humidity;
String temperature = humidity = recvBuffer = "N/N";

void setup () {
  size (450, 250);
  buttonCOM = new button ("Change", 340, 40, 100, 30, "setupCOMPort", 0.5, 0.7);
  buttonTemp = new button ("Update", 65, 160, 100, 30, "updateTemperature", 0.5, 0.7);
  buttonHumid = new button ("Update", 280, 160, 100, 30, "updateHumidity", 0.5, 0.7);
}

void draw () {
  drawUI ();
  buttonCOM.update ();
  buttonTemp.update ();
  buttonHumid.update ();
}

void drawUI () {
  stroke (127);
  fill (255);
  //TITLE CONTAINER
  rect (5, 5, 440, 70);
  //BODY CONTAINER
  rect (5, 80, 440, 115);
  //COPYRIGHT CONTAINER
  rect (5, 200, 440, 45);
  //SERIAL PORT
  rect (340, 10, 100, 30);
  //TEMPERATURE
  rect (10, 85, (width * 0.5 - 15), 105);
  //HUMIDITY
  rect ((width * 0.5), 85, (width * 0.5 - 10), 105);

  fill (0);
  PFont font;
  font = createFont ("Century Gothic", 40);
  textFont (font);
  text ("DHTMonitor", 180, 55);

  font = createFont ("Calibri", 40);
  textFont (font);
  text (temperature, 115, 150);
  text (humidity, 335, 150);

  font = createFont ("Century Gothic", 12);
  textFont (font);
  if (portError) {
    fill(200, 0, 0);
    text (comPort, 390, 31);
    fill(0);
  } else {
    text (comPort, 390, 31);
  }
  text ("TEMPERATURE:", 120, 105);
  text ("HUMIDITY:", 335, 105);

  font = createFont ("Century Gothic", 12);
  textAlign(CENTER);
  textFont (font);
  text ("Copyright © 2018 by Willian G. Cerqueira da Rocha\nAll rights reserved. - GNU GPL v3.0", width * 0.5, 217);

  return;
}

void setupCOMPort () {
  int comCount = Serial.list().length;
  portError = false;
  if (comPort.equals("Serial port")) {
    if (comCount > 0) {
      try {
        serialPort = new Serial (this, Serial.list()[0], 9600);
      } catch (Exception e) {
        portError = true;
      }
      comPort = Serial.list()[0];
      return;
    }
  }
  for (int i = 0; i < comCount; i++) {
    if (comPort.equals (Serial.list()[i])) {
      if (i + 1 < comCount) {
        if (serialPort != null) serialPort.stop();
        try {
          serialPort = new Serial (this, Serial.list()[i+1], 9600);
        } catch (Exception e) {
          portError = true;
        }
        comPort = Serial.list()[i+1];
        return;
      } else if (i + 1 == comCount) {
        if (serialPort != null) serialPort.stop();
        try {
          serialPort = new Serial (this, Serial.list()[0], 9600);
        } catch (Exception e) {
          portError = true;
        }
        comPort = Serial.list()[0];
        return;
      }
    }
  }
  return;
}

void updateTemperature () {
  if (comPort != "Serial port" && portError == false) {
    serialPort.write ("temperature\n");
    delay (500);
    if (serialPort.available () > 0) {
      recvBuffer = serialPort.readStringUntil ('\n');
      temperature = recvBuffer;
      temperature = temperature.substring (0, 2).concat ("ºC");
    }
  }
  recvBuffer = "";
  return;
}

void updateHumidity () {
  if (comPort != "Serial port"  && portError == false) {
    serialPort.write ("humidity\n");
    delay (500);
    if (serialPort.available () > 0) {
      recvBuffer = serialPort.readStringUntil ('\n');
      humidity = recvBuffer;
      humidity = humidity.substring (0,2).concat ("%");
    }
  }
  recvBuffer = "";
  return;
}
