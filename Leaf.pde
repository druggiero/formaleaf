class Leaf {

  int number;
  float laminaLength= 0;
  float laminaWidth = 0;
  float lwRatio;
  float lamArea = 0;
  float lamPerimeter = 0;
  int wideFifth = 0;
  int lobeNum = 0;
  MatOfPoint contour;
  MatOfPoint approxPolyContour;


  Point apex;
  Point base;

  Imgproc pro;
  ImageProcessor myPro;


  color col;

  String shapeClass;

  Leaf(int num) {
    number = num;
    col = color(34, 200, 40, 180);

    pro = new Imgproc();
    myPro = new ImageProcessor();
  }

  int getNum() {
    return number;
  }

  void setLamLength(double len) {
    laminaLength = (float)len;
    if (laminaWidth != 0) {
      lwRatio = laminaLength/laminaWidth;
    }
  }


  void setLamWidth(double wid) {
    laminaWidth = (float)wid; 
    if (laminaLength != 0) {
      lwRatio = laminaLength/laminaWidth;
    }
  }

  void setWideFifth(int fif) {
    wideFifth = fif;
    if (wideFifth==1 || wideFifth==2) {
      shapeClass = "Obovate";
    } else if (wideFifth==3) {
      shapeClass = "Elliptic";
    } else if (wideFifth==4 || wideFifth==5) {
      shapeClass = "Ovate";
    } else {
      shapeClass = "Special?";
    }
  }

  void setContour(MatOfPoint con) {
    contour = con;
  }

  void setApproxPolyContour(MatOfPoint apc){
    approxPolyContour = apc;
  }

  void setShapeClass(String sc) {
    shapeClass = sc;
  }
  
  void setLobeNum(int ln){
   lobeNum = ln; 
  }
  
  void setApex(Point a){
   apex = a; 
  }
  
  void setBase(Point b){
   base = b; 
  }
  
  void setArea(float a){
   lamArea = a; 
  }
  
  void setPerimeter(float p){
   lamPerimeter = p; 
  }
  
  

  String getInfo() {
    String info = "";
    info = info + 
      "Leaf Number: " + number + "\n" +
      "Length: " + laminaLength + "\n" +
      "Width: " + laminaWidth + "\n" +
      "L:W Ratio: "+ lwRatio + "\n" + 
      "Area: " + lamArea + "\n" +
      "Perimeter: " + lamPerimeter + "\n" +
      //won't bother displaying until lobes is more accurate 
      //"Number of Lobes: " + lobeNum + "\n" +  
      "Shape Class: " + shapeClass+ "\n";
    return info;
  }



  float evaluateSimilarity(Leaf other) {
    //this is the fitness function!

    Point[] cPoints = contour.toArray();
    Point[] oPoints;
    try{
    oPoints = other.contour.toArray();}//buggy
    catch(NullPointerException e){
    oPoints = null;
    }
    
    
    float lwR = 1-map(abs(lwRatio - other.lwRatio),0,3,0,1);  
    float len = 1-map(abs(laminaLength-other.laminaLength), 0, 300, 0, 1);
    float wid = 1-map(abs(laminaWidth-other.laminaWidth), 0, 300, 0, 1);
    float area = map(abs(lamArea - other.lamArea),lamArea, 0, 0,1);
    
    float lobe = map(abs(lobeNum-other.lobeNum), 0, 6, 1, 0); 
          
    float sc;  
    if(shapeClass.equals(other.shapeClass)){
      sc = 1;
    }
    else{
     sc = 0; 
    }
      
    float fitness = lwR*25 + len*10 +wid*10 + area*15 + lobe*15 +sc*25;    

   
    /*hausdorff distance, fool with this another time
    float hausdorff;
    if(null!=oPoints){
    hausdorff = 1000/(float)myPro.distance_hausdorff(cPoints, oPoints);
    }
    else
    hausdorff = 0;  */

    return fitness;
  }
}