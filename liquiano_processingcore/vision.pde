/**
 * Based on:
 * Brightness Tracking 
 * by Golan Levin. 
 *
 * Tracks the brightest pixel in a live video signal. 
 */

import processing.video.*;

Capture video;

void getVision() {
  
  if (video.available()) {
    video.read();
    //image(video, 0, 0, 160, 120); // Draw the webcam video onto the screen
    
    float brightestValue = 0; // Brightness of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x * 2;
        }
        index++;
      }
    }
  println("brightestX: ", brightestX);
    

  }
}

/*void captureEvent(Capture c) {
  c.read();
} */
