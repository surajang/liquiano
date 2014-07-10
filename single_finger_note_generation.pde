import arb.soundcipher.*;
import processing.video.*;
Capture video;

SoundCipher sc = new SoundCipher(this);

int tempNoteOn = 0;

int sizeX = 640;
int sizeY = 480;

int maximumFingerWidth = 100;
int minimumFingerWidth = 1;
int depthScanSpacing;
int fingerColorThreshold = 60;
int maximumNumberOfNotes = 10;
int maximumInterFingerDisplacement;
int maxNumberOfFinger = 10;

int waterSurfaceLocation;

int scanWidthFrom = 0;
int scanWidthTo = 640;
int scanDepthFrom = 0;
int scanDepthTo = 480;

class Finger
{
  int xLocation;
  int xLocationPrevious;
  int yDepth;
  int yDepthPrevious;
  int pitch;
  int volume;
  int noteOn;
  
  void setFingerInfo(int xLocationParam, int yDepthParam, int noteOnParam)
  {
    xLocation = xLocationParam;
    yDepth = yDepthParam;
    noteOn = noteOnParam;
  }
}

void setup() 
{
  size(sizeX, sizeY);
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();  
  noStroke();
  smooth();
  
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
}

void draw() 
{
  int fingerRecognitionCounter = 0;
  int tempFingerCenterLocationX = 0;
  int tempFingerCenterLocationFrom, tempFingerCenterLocationTo;
  int tempFingerCenterLocationY;
  int fingerIndex = 0;
  
  Finger[] fingers = new Finger[maxNumberOfFinger];
  
  if (video.available()) 
  {
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
     
    tempFingerCenterLocationX = 0;
    tempFingerCenterLocationFrom = 0;
    tempFingerCenterLocationTo = 0;
    tempFingerCenterLocationY = 0;
    
    for (int y = 0; y < sizeY; y++) 
    {
      fingerRecognitionCounter = 0;
      fingerIndex = 0;
      
      for (int x = 0; x < sizeX; x++) 
      {
        if ( y >= scanDepthFrom && y <= scanDepthTo && x >= scanWidthFrom && x <= scanWidthTo )
        {
          int pixelValue = video.pixels[index];
          float pixelBrightness = brightness(pixelValue);
          
          if (pixelBrightness < fingerColorThreshold) // Scan for darker region for finger recognition
          {
            if ( fingerRecognitionCounter == 0 )
            {
              tempFingerCenterLocationFrom = x;
            }
            fingerRecognitionCounter++;
          }
          else // Process the finger region
          {
            if ( fingerRecognitionCounter >= minimumFingerWidth )
            {
              tempFingerCenterLocationTo = x;
              tempFingerCenterLocationX = (tempFingerCenterLocationFrom + tempFingerCenterLocationTo) / 2;
              tempFingerCenterLocationY = y;
              
              // Add new finger(note)
              if ( fingerIndex < 10 )
              {
                //fingers[fingerIndex].setFingerInfo(tempFingerCenterLocationX, y, 1);
                fingerIndex++;
              }
            }
            
            fingerRecognitionCounter = 0;
          }
        }
        
        index++;
      }
    }
    // Draw a large, yellow circle at the brightest pixel
    fill(255, 204, 0, 128);
    ellipse(tempFingerCenterLocationX, tempFingerCenterLocationY, 100, 100);
    
    sc.sendMidi(sc.PITCH_BEND, 1, 64, tempFingerCenterLocationX / 8);
  }
  
  //int m = millis();
  println(tempFingerCenterLocationX);
}
