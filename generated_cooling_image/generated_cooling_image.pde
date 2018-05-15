// Andrew Craigie
// generated_cooling_image.pde

// Create an algorithm to generate an array of integer values between 0-255
// to act as a cooling 'image' 

// 'scrolling' and array //System.arraycopy(ar, 0, result, 1, ar.length - 1);

int [] cooling_array;
PImage cooling_image;

PImage test_image;

int rowIndex;
boolean up;


void setup () {
  size(1600, 1200);

  cooling_array =  generate_cooling_array(800, 1200);
  cooling_image = image_from_array(cooling_array, 800, 1200);

  test_image = createImage(800, 600, RGB);

  up = true;
}

int[] generate_cooling_array(int w, int h) {

  //float noiseBrightness = 40.0;
  float noiseBrightness = 255.0;
  float yStart = 0.0;

  int [] cool_array = new int[(w * h)];

  float xoff = 0.0; // Start xoff at 0
  float increment = 0.06;

  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < w; x++) {

    xoff += increment;   // Increment xoff 
    float yoff = yStart;   // For every xoff, start yoff at 0

    for (int y = 0; y < h; y++) {

      yoff += increment; // Increment yoff
      int index = x + y * w;

      // Calculate noise and scale by noiseBrightness;
      float bright = noise(xoff, yoff) * noiseBrightness; // number seems to affect 'length' of flames

      cool_array[index] = int(bright);
    }
  }

  return cool_array;
}

PImage image_from_array(int[] arr, int w, int h) {

  PImage array_image = createImage(w, h, RGB);
  array_image.loadPixels();

  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int index = x + y * w;
      array_image.pixels[index] = color(arr[index]);
    }
  }

  array_image.updatePixels();
  return array_image;
}



void draw() {
  background(255);


  if (rowIndex > 599) {
    up = false;
  }
  if (rowIndex < 1) {
    up = true;
  }



  test_image.loadPixels();



  if (up == true) {

    for (int x = 0; x < 800; x++) {
      for (int y = 0; y < 600; y++) {
        int index = x +  y  * 800;

        int sourceIndex;


        sourceIndex = x + (y + rowIndex) * 800;


        test_image.pixels[index] = color(cooling_array[sourceIndex]);
      }
    }
  } else {
    for (int x = 0; x < 800; x++) {
      for (int y = 599; y > 0; y--) {
        int index = x +  y  * 800;

        int sourceIndex;


        sourceIndex = x + (y + rowIndex) * 800;


        test_image.pixels[index] = color(cooling_array[sourceIndex]);
      }
    }
  }

  rowIndex++;
  if (rowIndex > 599) {
    rowIndex = 0;
  }



  test_image.updatePixels();

  image(cooling_image, 0, 0);
  image(test_image, 800, 0);
}
