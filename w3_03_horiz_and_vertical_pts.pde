/*
 * Creative Coding
 * Week 3, 03 - using sin(), cos(), dist() to make a dynamic pattern 
 * by Indae Hwang and Jon McCormack
 * Updated 2016
 * Copyright (c) 2014-2016 Monash University
 *
 * Modified by GrandeMago AUG 2016
 * 
 * the "drawing point are moving both horizontally and vertically
 * go to the 'update' function and uncomment the code to display the points and get the feeling
 * of what this sketch is doing
 *
 * Use presentation mode( sketch menu > Present or press the shift-comand-r keys together)
 * Press "esc" key to stop running the sktech
 * 
 */

int     num;     // the number of items in the array
float[] x;       // x-position of point
float[] y;       // y-position of point
float[] speed;   // speed 
float[] phase;   // phase

float distanceMargin;
float rowHeight;

// colour control
float h;
float s;
float b;
float a;
float startHue;
float hueIncrem;

void setup() {

  //Fullscreen: to make fullscreen run this sketch with presentation mode ( sketch menu > Present )
  //size(displayWidth, displayHeight);
  size(540, 540, P3D);  //P3D is used to speed up the drawing
  pixelDensity(2);  // use this for high density displays (retina type)
  frameRate(600);  // to force maximum drawing speed
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 100, 0, 100);

  
  // change each value below for different visual
  num = 12;  //there are num/2 point running horizontally and num/2 point running vertically
  rowHeight = height/(num/2-1); // height of each row
  distanceMargin = rowHeight*.03;


  // allocate size of arrays
  x = new float[num];
  y = new float[num];
  speed = new float[num];
  phase = new float[num]; 
  
  startHue = 220;
  h = startHue;
  hueIncrem = 6;
  s = 100;
  b = 80;
  a = 20;


  //setup an initial value for each item in the array
  for (int i=0; i<num; i++) {
    // even index points run horizontally
    if(i%2 ==0) {
      x[i] = random(width); 
      y[i] = rowHeight * i/2;
      speed[i] = random(1); // returns a random float bewteen 0 and 1
      phase[i] = random(TWO_PI);
    } else {
      // odd index points run vertically
      x[i] = rowHeight * (i-1)/2; 
      y[i] = random(height);
      speed[i] = random(1); // returns a random float bewteen 0 and 1
      phase[i] = random(TWO_PI);
    }      
  }
}


void draw() {
  // don't clear the screen each frame by calling background()
  println(frameRate+"  "+frameCount);  //  used to monitor drawing speed and computer performance
  
  fill(255);
  update();  //   a function that updates (and displays) the points position
  //similar();  //  a function that draws lines when horiz points get close enough with the next line horiz point (same for vertical)
  dissimilar();  //  a function that draws lines when horiz and vertical points get close enough
 
  if (mousePressed) {  //  not used
  }
    
}


void update() {
  for (int i=0; i<num; i++) {

    if (i%2 == 1) { // odd index points run vertically
      y[i] = y[i]+ 10*speed[i];//height/2 + sin(r + phase[i])* width/2;
      if(y[i] > height || y[i] < 0) {
        speed[i] *= -1;
      }
    }
    else { // even index points run horizontally
      x[i] = x[i] + 10*speed[i];  //width/2 + cos(r + phase[i])* width/2;
      if(x[i] > width || x[i] < 0) {
        speed[i] *= -1;
      }
    }
    
    if(frameCount%5000 ==0) {
      speed[i] = random(1);
    }
    
    // uncomment if you want to display the moving points
    //fill(128);
    //stroke(255);
    //ellipse(x[i], y[i], 10, 10);
    //fill(255);
  }  
}

void similar() {
  for (int i=0; i<num; i++) {
    if (i < num-2 && i%2 == 1) {
      float distance = dist(x[i], y[i], x[i+2], y[i+2]);
      if (distance > rowHeight && distance < rowHeight + distanceMargin) {

        stroke(h, s, b, a);
        line(x[i], y[i], x[i+2], y[i+2]);

        // stroke(255);
        point(x[i], y[2]);
        point(x[i+1], y[i+2]);
      }      
    }
    
    if (i < num-3 && i%2 == 0) {
      float distance = dist(x[i], y[i], x[i+2], y[i+2]);
      if (distance > rowHeight && distance < rowHeight + distanceMargin) {

        stroke(h, s, b, a);
        line(x[i], y[i], x[i+2], y[i+2]);

        // stroke(255);
        point(x[i], y[2]);
        point(x[i+1], y[i+2]);
      }      
    }        
  }  
}

void dissimilar() {
  for(int i=0; i< num; i+=2) {
    h = startHue;
   for(int j = 1; j<num; j+=2) {
     float distance = dist(x[i], y[i], x[j], y[j]);
     if (distance > rowHeight && distance < rowHeight + distanceMargin*1.2) {

       h = h + hueIncrem * (i+1.5*j); 
       if(h>360) {
         h-= 360;
       }
       
       stroke(h, s, b, a);
        line(x[i], y[i], x[j], y[j]);

        point(x[i], y[i]);
        point(x[j], y[j]);
      } 
   }
  } 
}
// press 'p' to save the screen to a .png file
void keyPressed() {
  if(key == 'p') {
    saveFrame("frame-###.png");
  }
}
