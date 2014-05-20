/**
* Controls music by sending individual MIDI messages.
* Drag around the sketch window to control pitch bend and volume.
*
* A SoundCipher library example by Andrew R. Brown
* http://explodingart.com/soundcipher/index.html
* Liquiano project by Jisoon Lim, Minshik Sohn
*/

import arb.soundcipher.*;
int dimX = 640;
int dimY = 200;
float pitchBend = mouseX * 0.25;
float velocity = mouseY * 2.55;
  
SoundCipher sc = new SoundCipher(this);

void setup() {
  size(dimX, dimY);
  video = new Capture(this, 160, 120);
  video.start();  
  noStroke();
  smooth();
}

void draw() {
  background(180);
  stroke(255,0,0);
  line(0, dimY-5, dimX, dimY-5);
  stroke(0);
  //rect(mouseX-5, mouseY-5, 10, 10); 
  
  text("Vel", 600, 100);
  text("- <-Pitch-> +", 320, 200);
  getVision();  //Call vision processing module
  set(0,0, video); //Show cheat video
}

void mousePressed() {
  int controlModeChange = 176;
  int channel = 1;
  sc.sendMidi(controlModeChange, channel, 100, 0);
  sc.sendMidi(controlModeChange, channel, 101, 0);
  sc.sendMidi(controlModeChange, channel, 6, 8);
  sc.sendMidi(controlModeChange, channel, 100, 127);
  sc.sendMidi(controlModeChange, channel, 101, 127);
  sc.sendMidi(sc.PROGRAM_CHANGE, 1, sc.CHIFFER_LEAD, 0);
  sc.sendMidi(sc.NOTE_ON, 1, 60, 100);
  sc.sendMidi(sc.PROGRAM_CHANGE, 2, sc.CHIFFER_LEAD, 0);
  //sc.sendMidi(sc.NOTE_ON, 1, 60, 100);
}

void mouseDragged() {
  float pitchBend = mouseX * 0.25;
  float velocity = mouseY * 2.55;
  sc.sendMidi(sc.PITCH_BEND, 1, 64, pitchBend);
  //sc.sendMidi(160, 0, 60, pitchBend);
  sc.sendMidi(sc.CONTROL_CHANGE, 1, 7, velocity);
  
  //for debug
  println("Pitch: ", pitchBend, " Velocity: ", velocity);
}

void mouseReleased() {
  sc.sendMidi(sc.NOTE_OFF, 1, 60, 0);
  sc.sendMidi(sc.NOTE_OFF, 2, 60, 0);
}
