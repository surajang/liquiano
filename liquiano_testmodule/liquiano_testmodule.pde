/**
* Controls music by sending individual MIDI messages.
* Drag around the sketch window to control pitch bend and volume.
*
* A SoundCipher library example by Andrew R. Brown
*/

import arb.soundcipher.*;

SoundCipher sc = new SoundCipher(this);
SoundCipher sc2 = new SoundCipher(this);

void draw() {
  background(180);
  ellipse(mouseX, mouseY, 10, 10); 
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
  int pitchBend = 100 - mouseY + 14;
  //println(sc.PITCH_BEND);
  
  sc.sendMidi(sc.PITCH_BEND, 1, 64, pitchBend);
  //sc.sendMidi(160, 0, 60, pitchBend);
  sc.sendMidi(sc.CONTROL_CHANGE, 1, 7, mouseX);
}

void mouseReleased() {
  sc.sendMidi(sc.NOTE_OFF, 1, 60, 0);
  sc.sendMidi(sc.NOTE_OFF, 2, 60, 0);
}
