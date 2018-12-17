/*The TurtleState class was written because the polygon
 drawing in Processing doesn't allow using translate(), rotate(),
 etc. within "beginShape". All coordinate plane transformations
 had to be kept track of manually instead. 
 This class replaces the use of pushMatrix, popMatrix
 for branching purposes.*/

class TurtleState {

  float x;
  float y;
  float heading;

  TurtleState(float xin, float yin, float headin) {
    x = xin;
    y = yin;
    heading = headin;
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getHeading() {
    return heading;
  }

  String toString() {
    return x +" "+ y + " " + heading;
  }
}