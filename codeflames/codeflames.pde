// Andrew Craigie
// Coding Flames inspired by Daniel Shiffman

//https://web.archive.org/web/20160418004150/http://freespace.virgin.net/hugo.elias/models/m_fire.htm
//http://lodev.org/cgtutor/fire.html

int cols;
int rows;

PGraphics buffer1;
PGraphics buffer2;
PImage cooling;

int w;
int h;

int startRows;

float yStart;
float noiseBrightness;


void setup() {
  size(800, 600);
  w = width;
  h = height;

  startRows = 5;
  yStart = 0.0;
  noiseBrightness = 20;

  buffer1 = createGraphics(w, h);
  buffer2 = createGraphics(w, h);
  cooling = createImage(w, h, RGB);
}

void cool() {
  cooling.loadPixels();

  float xoff = 0.0; // Start xoff at 0
  //float detail = map(mouseX, 0, width, 0.1, 0.6);
  //noiseDetail(8, detail);

  float increment = 0.04;

  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 

    float yoff = yStart;   // For every xoff, start yoff at 0

    for (int y = 0; y < height; y++) {
      yoff += increment; // Increment yoff

      // Calculate noise and scale by 255
      //float bright = noise(xoff, yoff) * 255;
      float bright = noise(xoff, yoff) * noiseBrightness; // number seems to affect 'length' of flames

      // Try using this line instead
      //float bright = random(0,255);

      // Set each pixel onscreen to a grayscale value
      cooling.pixels[x+y*width] = color(bright);
    }
  }


  cooling.updatePixels(); 
  yStart += increment;
}

void fire(int rows) {
  // Sets initial pixels to 'burn'
  // Can be a user-interactive shape or loaded image??
  buffer1.beginDraw();
  buffer1.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int j = 0; j < rows; j++) {
      int y = height - (j + 1);
      int index = x + y * width;
      buffer1.pixels[index] = color(255);
    }
  }
  buffer1.updatePixels();
  buffer1.endDraw();
}

void mouseDragged(){
   buffer1.beginDraw();
   
   // Create a region of white pixels in the buffer
   buffer1.fill(255);
   buffer1.noStroke();
   
   buffer1.ellipse(mouseX, mouseY, 100, 100);
   
   buffer1.endDraw();
}

void draw() {
  background(0);

  fire(startRows);
  cool();

  buffer2.beginDraw();

  buffer1.loadPixels();
  buffer2.loadPixels();

  for (int x = 1; x < w-1; x++) {
    for (int y = 1; y < h-1; y++) {

      int index = x + y * w;

      int index1 = (x+1) + (y) * width;
      int index2 = (x-1) + (y) * width;
      int index3 = (x) + (y+1) * width;
      int index4 = (x) + (y-1) * width;
      color c1 = buffer1.pixels[index1];
      color c2 = buffer1.pixels[index2];
      color c3 = buffer1.pixels[index3];
      color c4 = buffer1.pixels[index4];

      color c5 = cooling.pixels[index];
      float newC = brightness(c1) + brightness(c2) + brightness(c3) + brightness(c4);
      newC = newC - brightness(c5);

      buffer2.pixels[index4] = color(newC * 0.25);
    }
  }

  buffer2.updatePixels();
  buffer2.endDraw();

  // Swap
  PGraphics temp = buffer1;
  buffer1 = buffer2;
  buffer2 = temp;

  image(buffer2, 0, 0);
  //image(cooling, 0, 0);
}
