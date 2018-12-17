/*

FormaLeaf 

version 1.0

Diana Ruggiero

05/06/16

*/

import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.*;
import java.lang.*;
import java.util.List;
import java.util.Collections;
import org.qscript.*;


OpenCV opencv;
PImage img, thresh;

Leaf realLeaf;
SysLeaf fakeLeaf;

Turtle turt;

ImageProcessor iProc;
PImage realLeafProcessed;

Slider slide0;
Slider slide1;
Slider slide2;
Slider slide3;
Slider slide4;
Slider slide5;
Slider slide6;
Slider slide7;
Slider slide8;
Slider slide9;

Slider iterSlider;

GrammarGenerator gGen;
Grammar startGram;

PApplet sketchPApplet;
float[] sliderVals = {0.5, 0.5, 0.5, 0.5, 0.5, 0.5,0.5,0.5,0.5};

Boolean searchMode; 
Boolean visionMode;

Boolean LSinfo;

String  displayTemplate;
String[] templateList = new String[3];
int t;
int leafNum;

PGraphics can;
int c = 0;

void setup() {  

  size(1280, 800); 
  sketchPApplet=this; 
  iProc = new ImageProcessor();

  realLeaf = new Leaf(1); 
  img = loadImage("01_r.jpg");

  img.resize((width/12)*5, 0);

  println(img.width);
  //used for thresholding, converting from Mat to PImage:
  opencv = new OpenCV(this, img);
  
  realLeafProcessed =  iProc.processImage(opencv, realLeaf); 
  realLeafProcessed.resize(0, height);


  slide0 = new Slider(0, height-300, width/6, 10, 1, false);
  slide1 = new Slider(0, height-280, width/6, 10, 1, false);
  slide2 = new Slider(0, height-260, width/6, 10, 1, false);
  slide3 = new Slider(0, height-240, width/6, 10, 1, false);
  slide4 = new Slider(0, height-220, width/6, 10, 1, false);
  slide5 = new Slider(0, height-200, width/6, 10, 1, false);
  slide6 = new Slider(0, height-180, width/6, 10, 1, false);
  slide7 = new Slider(0, height-160, width/6, 10, 1, false);
  slide8 = new Slider(0, height-140, width/6, 10, 1, false);
  slide9 = new Slider(0, height-120, width/6, 10, 1, false);

  iterSlider = new Slider(0, height-30, width/6, 10, 1, true);

  searchMode = false;
  visionMode = false;


  LSinfo = false;

  templateList[0] = "Pinnate";
  templateList[1] = "PinLobed";
  templateList[2] = "Palmate";
  t = 0;
  displayTemplate = templateList[t];

  leafNum = 1;

  gGen = new GrammarGenerator(sketchPApplet);
  startGram = gGen.buildGrammar(displayTemplate, sliderVals);

  fakeLeaf = new SysLeaf(realLeaf.getNum(), startGram, displayTemplate);
}



void draw() {  
  background(255);
  Slider[] sliderList = {slide0, slide1, slide2, slide3, slide4, slide5, slide6, slide7, slide8, slide9, iterSlider};

  image(img, width/6, height/2-(img.height/2));
  realLeaf.col = img.get(img.width/2-15, img.height/2);


  strokeWeight(2);
  stroke(0);
  line(width/6, 0, width/6, height);


  fill(0);
  textSize(23);
  textLeading(18);
  text("Morphometric" + "\n" + "Information:", 5, 20);
  line(0, 43, width/6, 43);
  textSize(16);
  text("Input Leaf:",  5, 62);
  line(0, 69, width/6, 69);
  textSize(12);
  text(realLeaf.getInfo(), 5, 84);


  float[] sliderVals = {
    map(sliderList[0].getPos(), 0, width/6, 0, 1), 
    map(sliderList[1].getPos(), 0, width/6, 0, 1), 
    map(sliderList[2].getPos(), 0, width/6, 0, 1), 
    map(sliderList[3].getPos(), 0, width/6, 0, 1), 
    map(sliderList[4].getPos(), 0, width/6, 0, 1), 
    map(sliderList[5].getPos(), 0, width/6, 0, 1), 
    map(sliderList[6].getPos(), 0, width/6, 0, 1), 
    map(sliderList[7].getPos(), 0, width/6, 0, 1), 
    map(sliderList[8].getPos(), 0, width/6, 0, 1), 
    map(sliderList[9].getPos(), 0, width/6, 0, 1)};

  
  textSize(10);
  
  if (!searchMode) {
    text("Slider Mode (Press Z to search)", 10, height-5);
    Grammar slideGram =  gGen.buildGrammar(displayTemplate, sliderVals);  
    fakeLeaf = new SysLeaf(realLeaf.getNum(), slideGram, displayTemplate);
    updateSliders(sliderList);
  }

  if (searchMode) {
    text("Search Mode (Press X for Sliders)", 10, height-5);
  }
  
  if(visionMode){
   fill(0);
   text("Vision Mode is ON (Press C)", 10,height-15); 
  }
  
  else if(!visionMode){
   fill(0);
   text("Vision Mode is OFF (Press C)", 10,height-15); 
  }

  iterSlider.display();
  iterSlider.update();
  
  //the turtle takes the iterations, where it's drawn, the unit length, the initial angle
  

  turt = new Turtle(fakeLeaf.gram, int(map(iterSlider.getPos(), 0, width/6, 4, fakeLeaf.maxIt)), 4, width/2, (float)realLeaf.base.y, -PI/2);

  PGraphics canvas = turt.drawGrammar(realLeaf.col); 
  can = canvas;
  if (canvas!= null) {

    image(canvas, width-((width/12)*5), 0); 
    PImage fakeLeafImg = canvas.get();

    OpenCV sysLeafCV = new OpenCV(this, fakeLeafImg);
    PImage fakeLeafProcessed = iProc.processImage(sysLeafCV, fakeLeaf); 

    if (visionMode) {
      fakeLeafProcessed.resize((width/12)*5, 0);
      image(fakeLeafProcessed, width-(width/12)*5, 0);
      image(realLeafProcessed, width/6, height/2-(img.height/2));
    }

    stroke(0);
    fill(0);

    textSize(12);
    text(fakeLeaf.getInfo(), 5, 310);
    text("Similarity: " + realLeaf.evaluateSimilarity(fakeLeaf), 5, 480);
  

   
  } else {

    fill(255, 0, 0);
    textSize(40);
    text("GENERATED LEAF" + "\n" + "OUT OF BOUNDS", width/2+200, height/2-50);
    textSize(15);
    text("Lower parameters/iterations" + "\n" + "or switch template/input leaf.", width/2+250, height/2 +50);
  }

  stroke(0);
  fill(0);
  textSize(16);
  line(0, 238, width/6, 238);
  text("Generated Leaf:" + "\n", 5, 260);
  line(0, 270, width/6, 270);
  textSize(14);
  text("Template: "+ fakeLeaf.getTemplate(), 5, 290);
  strokeWeight(3);
  line(width-(width/12)*5, 0, width-(width/12)*5, height);
  
  if(LSinfo==true){
  drawLSInfo(fakeLeaf.gram);}
}


void keyPressed() {
  if (key=='z') {
    searchMode = true;
    SysLeaf bestfakeLeaf = gGen.search(realLeaf, fakeLeaf, 15, 5);
    fakeLeaf = bestfakeLeaf;
  }

  if (key=='x') {
    //turn search lock off,visionMode off, see leaf, allows sliders
    searchMode = false;
    visionMode = false;
  }

  if (key=='c') {
    //visionmode still allows slider use
    visionMode = !visionMode;
  }
  
  //take screenshot
  if (key=='m'){
    saveFrame("frames/#####.jpg");
    
  }


  if (key==CODED) {
    if (keyCode == UP) {
      t = t + 1;
    } else if (keyCode == DOWN) {
      t = t - 1;
    }
    t = constrain(t, 0, templateList.length-1);
    println(t);
    displayTemplate = templateList[t];
  }
  
  if (key==CODED){
   if (keyCode == RIGHT){
    leafNum = leafNum + 1; 
   }
    
    else if(keyCode == LEFT){
     leafNum = leafNum - 1; 
    }
    
   
  }

  //pick samples leaves with numkeys and left and right arrows
  if (key=='1') {  
    leafNum = 1;
  } else if (key=='2') {
    leafNum = 2;
  } else if (key=='3') {
    leafNum = 3;
  } else if (key=='4') {
    leafNum = 4;
  } else if (key=='5') {
    leafNum = 10;
  } else if (key=='6') {
    leafNum = 20;
  } else if (key=='7') {
    leafNum = 30;
  } else if (key=='8') {
    leafNum = 40;
  } else if (key=='9') {
    leafNum = 50;
  } else if (key=='0') {
    leafNum = 60;
  } 
  
  //displays Lsystem info
  if(key=='p'){
    LSinfo = !LSinfo;
  }

 leafNum = constrain(leafNum, 1, 70);
    String n = str(leafNum);
    if(leafNum < 10){
      n = "0" + n;
    }
    img = loadImage( n+"_r.jpg");
    realLeaf = new Leaf(leafNum);
    
    

  PImage imgCopy = img.get();
  imgCopy.resize((width/12)*5, 0);

  if (imgCopy.height>height) {  
    img.resize(0, height);
    opencv = new OpenCV(this, img);  
    realLeafProcessed =  iProc.processImage(opencv, realLeaf); 
    realLeafProcessed.resize(0, (height));
  } else {

    img.resize((width/12)*5, 0);
    opencv = new OpenCV(this, img);  
    realLeafProcessed =  iProc.processImage(opencv, realLeaf); 
    realLeafProcessed.resize((width/12)*5, 0);
  }

}


void drawLSInfo(Grammar gram) {
  //Writes lsys to display screen.
  fill(255);
  rect(width/2-15, 80, width/2-50,100);
  fill(0);
  textSize(10);
  text("Axiom:        " + gram.axiom, width/2, 100);
  for (int j=0; j<gram.productions.length; j++) {
    String prod = gram.productions[j][0]+" ->" + gram.productions[j][1];
    if (gram.productions[j].length==3) {
      prod = prod+"        iff: "+gram.productions[j][2];
    }
    text(prod, width/2, 100+((1+j)*10));
  }
}

void updateSliders(Slider[] slList) {
  for (int i=0; i<slList.length; i++) {
    slList[i].update();
    slList[i].display();
  }
}