class ImageProcessor {
  Core cvCore;
  Imgproc process;

  Mat thresholdMat;
  Mat holderMat;

  ArrayList<MatOfPoint> contourList;
  Mat hier;
  int contourIndex;
  Mat drawnContoursMat;

  ImageProcessor() {
    process = new Imgproc();
    cvCore = new Core();
  }

  PImage processImage(OpenCV opencv, Leaf leafy) {

    opencv.threshold(220); 
    thresh = opencv.getSnapshot();

    contourList = new ArrayList();
    thresholdMat = opencv.getGray();
    drawnContoursMat = opencv.getColor();
    hier =  new Mat();
    holderMat = opencv.imitate(drawnContoursMat);

    process.findContours(thresholdMat, contourList, hier, Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
    

    //seeking 2nd largest contour (largest contour is outline of picture)
    float[] areas = new float[contourList.size()];
    for (int i=0; i<contourList.size(); i++) {
      //println(process.contourArea(contourList.get(i)));
      areas[i] = (float)process.contourArea(contourList.get(i));
    }  

    areas = sort(areas);
    double targetArea;
    try {
      targetArea = (double)areas[areas.length-2];
    } 
    catch(IndexOutOfBoundsException e) {
      return null;
    }

    contourIndex = 0;

    for (int j=0; j<contourList.size(); j++) {
      if (targetArea == process.contourArea(contourList.get(j))) {
        contourIndex = j;
      }
    }

    cvCore.bitwise_not(holderMat, drawnContoursMat);  //inverts contour image so background is white

    MatOfPoint leafContour = contourList.get(contourIndex);

    leafy.setContour(leafContour);

    //draw leafContour
    process.drawContours(drawnContoursMat, contourList, contourIndex, new Scalar(0, 200, 100), 15);

    //Calculate bounding box, draw it, save lamina length to leaf.
    Rect boundBox = process.boundingRect(leafContour);
    //cvCore.rectangle(drawnContoursMat, boundBox.tl(), boundBox.br(), new Scalar(0, 0, 255), 8);
    leafy.setLamLength(boundBox.size().height);
    leafy.setLamWidth(boundBox.size().width);

    //Midline of bounding box.
    Point apex = new Point((boundBox.tl().x+boundBox.br().x)/2, boundBox.tl().y);
    Point base = new Point((boundBox.tl().x+boundBox.br().x)/2, boundBox.br().y);

    //cvCore.circle(drawnContoursMat, apex, 6, new Scalar(170, 0, 255), 4);
    //cvCore.circle(drawnContoursMat, base, 6, new Scalar(255, 255, 40), 4);
    //cvCore.line(drawnContoursMat, apex, base, new Scalar(255, 0, 0), 8);

    leafy.setApex(apex);
    leafy.setBase(base);



    findShapeClass(boundBox, leafy);


    
    /*Convex hull on full contour 
     //help from here:
     //http://stackoverflow.com/questions/18143077/computer-vision-filtering-convex-hulls-and-convexity-defects-with-opencv
     MatOfInt hullIndices1 = new MatOfInt();
     ArrayList<Point> hullPointList1 = new ArrayList();
     process.convexHull(leafContour, hullIndices1);
     for (int j=0; j < hullIndices1.toList().size(); j++) {
     hullPointList1.add(leafContour.toList().get(hullIndices1.toList().get(j)));
     }
     MatOfPoint hullMatPoint1 = new MatOfPoint();
     hullMatPoint1.fromList(hullPointList1);
     ArrayList<MatOfPoint> hullMatPointList1 = new ArrayList();
     hullMatPointList1.add(hullMatPoint1);
     process.drawContours(drawnContoursMat, hullMatPointList1, 0, new Scalar(50, 50, 50), 10);
     
     

    //convexity defects on full contour:
     MatOfInt4 defectMat = new MatOfInt4();
     process.convexityDefects(leafContour, hullIndices1, defectMat);
     List<Integer> defectList = defectMat.toList();
     
     for (int i=2; i<defectList.size(); i=i+4) {
     int cIndex = defectList.get(i);
     Point[] cPoints = leafContour.toArray();
     cvCore.circle(drawnContoursMat, cPoints[cIndex], 24, new Scalar(255, 255, 40), 4);
     //convexity defect points:
     //println(cPoints[cIndex]); 
     }
     */
     


    //polygon approximation for better lobe estimate.
    MatOfPoint2f contourFloat = new MatOfPoint2f(leafy.contour.toArray());
    MatOfPoint2f polygonApprox = new MatOfPoint2f();

    
    process.approxPolyDP(contourFloat, polygonApprox, 4, true);




    MatOfPoint approxContour = new MatOfPoint(); 
    polygonApprox.convertTo(approxContour, CvType.CV_32S);

    ArrayList<MatOfPoint> approxContourList = new ArrayList();
    approxContourList.add(approxContour);

    process.drawContours(drawnContoursMat, approxContourList, 0, new Scalar(0, 50, 160), 10);


    //Convex hull on polyapprox contour 
    MatOfInt hullIndices = new MatOfInt();
    ArrayList<Point> hullPointList = new ArrayList();
    process.convexHull(approxContour, hullIndices);
    for (int j=0; j < hullIndices.toList().size(); j++) {
      hullPointList.add(leafContour.toList().get(hullIndices.toList().get(j)));
    }
    MatOfPoint hullMatPoint = new MatOfPoint();
    hullMatPoint.fromList(hullPointList);
    ArrayList<MatOfPoint> hullMatPointList = new ArrayList();
    hullMatPointList.add(hullMatPoint);
    //draw convex hull--but it doesn't really show when using polyapprox
    //process.drawContours(drawnContoursMat, hullMatPointList, 0, new Scalar(255, 50, 50), 10);


    //convexity defects
    MatOfInt4 defectMat = new MatOfInt4();
    //approxpoly freaks out at low iterations why!!!!



    int lobeCount = 0;


    if (hullIndices.rows() >=3) {
      process.convexityDefects(approxContour, hullIndices, defectMat);


      List<Integer> defectList = defectMat.toList();

      for (int i=2; i<defectList.size(); i=i+4) {
        int cIndex = defectList.get(i);
        Point[] cPoints = approxContour.toArray();
        cvCore.circle(drawnContoursMat, cPoints[cIndex], 17, new Scalar(255, 255, 40), 4);
        lobeCount ++;
        //convexity defect points:
        //println(cPoints[cIndex]);
      }
    }


    //get area
    float area = (float)process.contourArea(leafContour);

    //get perimeter
    MatOfPoint2f conFloat = new MatOfPoint2f(leafy.contour.toArray());
    float perimeter = (float)process.arcLength(conFloat, true);

    leafy.setApproxPolyContour(approxContour);
    leafy.setLobeNum(lobeCount);
    leafy.setArea(area);
    leafy.setPerimeter(perimeter);

    /*minEnclosing circle on polygonApprox
     Point circCent = new Point();
     float[] radius = new float[1];
     process.minEnclosingCircle(polygonApprox, circCent, radius);
     cvCore.circle(drawnContoursMat, circCent, (int)radius[0], new Scalar(0, 0, 255), 4);
     */


    //make final image, turn into PImage
    PImage drawnContoursPImage = createImage(drawnContoursMat.width(), drawnContoursMat.height(), RGB);
    opencv.toPImage(drawnContoursMat, drawnContoursPImage);
    return drawnContoursPImage;
  }



  void findShapeClass(Rect boundBox, Leaf leafy) {


    ArrayList<Point> leftMostList = new ArrayList();
    Point leftMost = new Point();
    MatOfPoint2f contourFloat = new MatOfPoint2f(leafy.contour.toArray());
    //find widest points on left
    for (double y = boundBox.tl().y; y<boundBox.br().y; y++) {
      Point leftMostCan = new Point(boundBox.tl().x, y);
      if (process.pointPolygonTest(contourFloat, leftMostCan, true)==0) {
        leftMost = leftMostCan;
        leftMostList.add(leftMost);
      }
    }

    ArrayList<Point> rightMostList = new ArrayList();
    Point rightMost = new Point();
    //find widest points on right
    for (double y2 = boundBox.br().y; y2>boundBox.tl().y; y2=y2-1) {
      Point rightMostCan = new Point(boundBox.br().x, y2);
      if (process.pointPolygonTest(contourFloat, rightMostCan, true)+1==0) {
        rightMost = rightMostCan;
        rightMostList.add(rightMost);
      }
    }

    ArrayList<Point> acrossFromLList = new ArrayList();
    Point acrossFromL = new Point();
    //find points across from extreme Left points
    for (int i = 0; i<leftMostList.size(); i++) {
      for (double x = boundBox.br().x; x>leftMostList.get(i).x; x=x-1) {
        Point acrossFromLCan = new Point(x, leftMostList.get(i).y);
        if (process.pointPolygonTest(contourFloat, acrossFromLCan, true)==0) {
          acrossFromL = acrossFromLCan;
          acrossFromLList.add(acrossFromL);
          break;
        }
      }
    }

    ArrayList<Point> acrossFromRList = new ArrayList();
    Point acrossFromR = new Point();
    //find points across from extreme Right points
    for (int i = 0; i<rightMostList.size(); i++) {
      for (double x = boundBox.tl().x; x<rightMostList.get(i).x-1; x=x+1) {
        Point acrossFromRCan = new Point(x, rightMostList.get(i).y);
        if (process.pointPolygonTest(contourFloat, acrossFromRCan, true)==0) {
          acrossFromR = acrossFromRCan;  
          acrossFromRList.add(acrossFromR);
          break;
        }
      }
    }

    float[] distListL = new float[leftMostList.size()];
    for (int i = 0; i<leftMostList.size(); i++) {
      try {
        distListL[i] = ((float)euclideanDist(leftMostList.get(i), acrossFromLList.get(i)));
      }
      catch(IndexOutOfBoundsException e) {
        distListL[i] = 0;
      }
    }
    float maxLeftDist =0;
    if(distListL.length>0){
    maxLeftDist = max(distListL);}


    float[] distListR = new float[rightMostList.size()];
    for (int i = 0; i<rightMostList.size(); i++) {
      try{
      distListR[i] = ((float)euclideanDist(rightMostList.get(i), acrossFromRList.get(i)));
      }
      catch(IndexOutOfBoundsException e){
       distListR[i] = 0; 
      }
  }
    float maxRightDist= 0;
    if(distListR.length>0){
    maxRightDist = max(distListR);}


    Point widest = new Point();
    if (maxLeftDist > maxRightDist) {
      int ind = 0;
      for (int i = 0; i<distListL.length; i++) {
        if (distListL[i] == maxLeftDist) {
          ind = i;
        }
      }  
      widest = leftMostList.get(ind);   
      //cvCore.line(drawnContoursMat, leftMostList.get(ind), acrossFromLList.get(ind), new Scalar(0, 0, 0), 14);
      //cvCore.circle(drawnContoursMat, acrossFromLList.get(ind), 12, new Scalar(200, 40, 40), 4);
      //cvCore.circle(drawnContoursMat, leftMostList.get(ind), 12, new Scalar(40, 40, 40), 4);
    } else {

      int ind = 0;
      for (int i = 0; i<distListR.length; i++) {
        if (distListR[i] == maxRightDist) {
          ind = i;
        }
      }  
      widest = rightMostList.get(ind);
      //cvCore.line(drawnContoursMat, rightMostList.get(ind), acrossFromRList.get(ind), new Scalar(0, 0, 0), 14);
      //cvCore.circle(drawnContoursMat, rightMostList.get(ind), 12, new Scalar(200, 40, 40), 4);
      //cvCore.circle(drawnContoursMat, acrossFromRList.get(ind), 12, new Scalar(40, 40, 40), 4);
    }


    //Divide into 5ths 
    for (int i = 0; i<6; i++) {
      Point left = new Point(boundBox.tl().x, boundBox.tl().y + (leafy.laminaLength/5.0)*i); 
      Point right = new Point(boundBox.br().x, boundBox.tl().y + (leafy.laminaLength/5.0)*i);
      //draw 5th lines:
      //cvCore.line(drawnContoursMat, left, right, new Scalar(255, 0, 255), 9);
      if (widest.y<boundBox.tl().y+(leafy.laminaLength/5.0)*i && leafy.wideFifth==0) {
        leafy.setWideFifth(i);
      }
    }
  }



  double euclideanDist(Point a, Point b) {
    Point euc = new Point(a.x - b.x, a.y - b.y);
    double toSq = euc.x*euc.x + euc.y*euc.y;
    return Math.sqrt(toSq);
  }

  int distance_2(Point[] a, Point[] b ) {
    /*hausdorff distance helper 
    I DID NOT WRITE THIS
    http://stackoverflow.com/questions/21482534/how-to-use-shape-distance-and-common-interfaces-to-find-hausdorff-distance-in-op
    */
    int maxDistAB = 0;
    for (int i=0; i<a.length; i++)
    {
      int minB = 1000000;
      for (int j=0; j<b.length; j++)
      {
        int dx = (int)(a[i].x - b[j].x);     
        int dy = (int)(a[i].y - b[j].y);     
        int tmpDist = dx*dx + dy*dy;

        if (tmpDist < minB)
        {
          minB = tmpDist;
        }
        if ( tmpDist == 0 )
        {
          break; // can't get better than equal.
        }
      }
      maxDistAB += minB;
    }
    return maxDistAB;
  }

  double distance_hausdorff(Point[] a, Point[] b ) {
     /*hausdorff distance function
    I DID NOT WRITE THIS
    http://stackoverflow.com/questions/21482534/how-to-use-shape-distance-and-common-interfaces-to-find-hausdorff-distance-in-op
    */
    int maxDistAB = distance_2( a, b );
    int maxDistBA = distance_2( b, a );   
    int maxDist = max(maxDistAB, maxDistBA);

    return Math.sqrt((double)maxDist);
  }
}