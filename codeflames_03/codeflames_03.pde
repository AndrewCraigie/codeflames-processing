// Andrew Craigie
// Coding Flames inspired by Daniel Shiffman

//https://web.archive.org/web/20160418004150/http://freespace.virgin.net/hugo.elias/models/m_fire.htm
//http://lodev.org/cgtutor/fire.html

// Task: to create a 'static' cooling image only once
// and use some technique to scroll this 'static' image
// e.g. generate the cooling image in setup only once - scroll this image



int cols;
int rows;

PGraphics buffer1;
PGraphics buffer2;
PImage cooling;

PImage fore;

PFont f;

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
  noiseBrightness = 40;

  f = createFont("Arial Black", 250, true); // Arial, 16 point, anti-aliasing on

  buffer1 = createGraphics(w, h);
  buffer2 = createGraphics(w, h);
  cooling = createImage(w, h, RGB);
  fore = createImage(w, h, RGB);
}

void makeFore() {
  fore.loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int index = x + y * width;
      fore.pixels[index] = color(255, 0, 0);
    }
  }

  fore.updatePixels();
}

void cool() {
  cooling.loadPixels();

  float xoff = 0.0; // Start xoff at 0
  //float detail = map(mouseX, 0, width, 0.1, 0.6);
  //noiseDetail(8, detail);

  float increment = 0.06;

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
  buffer1.textFont(f, 250);
  buffer1.fill(255, 0, 0);
  buffer1.text("HOT", 80, 580);

  buffer1.endDraw();
}

void mouseDragged() {
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
  makeFore();

  buffer2.beginDraw();

  buffer1.loadPixels();
  buffer2.loadPixels();

  fore.loadPixels();
  
  float BRand = 255;
  float GRand = 0;
  float RRand = 200;

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

      BRand = 255;
      GRand = 0;
      RRand = 200;

      if (newC > 240) {
        GRand = random(150, 200);
      }

      if (newC > 100) {
        BRand = random(0, 100);
      }

      if (newC > 250) {
        //RRand = random(200, 255);
        RRand = 255;
        GRand = 255;
      }

      fore.pixels[index] = color(RRand, GRand, BRand, newC);
    }
  }

  buffer2.updatePixels();
  buffer2.endDraw();

  fore.updatePixels();

  // Swap
  PGraphics temp = buffer1;
  buffer1 = buffer2;
  buffer2 = temp;

  //image(buffer2, 0, 0);

  image(fore, 0, 0);
  //image(cooling, 0, 0);

  textFont(f, 250);
  fill(255, GRand, BRand);
  stroke(255, 255, 255);
  text("HOT", 80, 580);
}
