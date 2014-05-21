/**
* Controls music by sending individual MIDI messages.
* Drag around the sketch window to control pitch bend and volume.
*
* A SoundCipher library example by Andrew R. Brown
* http://explodingart.com/soundcipher/index.html
* Liquiano project by Jisoon Lim, Minshik Sohn
*/

//Required Libraries!!!
import arb.soundcipher.*;

//Required Global Variables!!!
int dimX = 640;
int dimY = 200;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
  
SoundCipher sc = new SoundCipher(this);

void setup() {
  size(dimX, dimY);
  video = new Capture(this, 320, 240);
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
  fill(255);
  text("Vel", 600, 100);
  text("- <-Pitch-> +", 280, 190);
  getVision();  //Call vision processing module @vision.pde
  //set(240,40, video); //Show video source
  image(video, 240, 40, 160, 120); // Draw the webcam video onto the screen
  // Draw a large, yellow circle at the brightest pixel
  noStroke();
  fill(255, 204, 0, 128);
  rect(brightestX, 0, 50, 480);
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
  float velocity = mouseY * 0.635;
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
