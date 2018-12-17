import java.util.Stack; 

/*Turtles need at least three arguments: 
 (1)The Grammar to be drawn.
 (2)Number of iterations. 
 Setting iterations too high for certain L-Systems
 may cause Processing to crash.
 (3)Unit Length in pixels.
 
 Second constructor has other inputs too.
 */

class Turtle { 
  float len;
  Grammar grammar;
  float x;
  float y;
  float heading;
  TurtleState state;
  Stack<TurtleState> turtleStack;

  PGraphics canvas;

  Turtle(Grammar gram, int iterations, int size) {

    canvas = createGraphics((width/12)*5, height);
    len = float(size);
    grammar = gram;
    x = canvas.width/2;
    y = canvas.height-200;
    heading = -PI/2;



    state = new TurtleState(x, y, heading);
    turtleStack = new Stack<TurtleState>();
    turtleStack.push(state);

    for (int i = 0; i<iterations; i++) {
      len = len * grammar.getScaleFactor();
    } 


    for (int i = 0; i<iterations; i++) {
      Grammar newGram = grammar.reWrite();
      grammar = newGram;
    }
  }  


  //Second constructor with specified location, rotation (radians):
  Turtle(Grammar gram, int iterations, int size, float xin, float yin, float rotation) {

    canvas = createGraphics((width/12)*5, height);
    len = float(size);
    grammar = gram;
    x = canvas.width/2;
    y = yin;
    heading = rotation;


    state = new TurtleState(x, y, heading);
    turtleStack = new Stack<TurtleState>();
    turtleStack.push(state);

    for (int i = 0; i<iterations; i++) {
      len = len * grammar.getScaleFactor();
    } 


    for (int i = 0; i<iterations; i++) {
      Grammar newGram = grammar.reWrite();
      grammar = newGram;
    }
  } 

  PGraphics drawGrammar(color col) {

    int thickness = 2;
    PShape shape = null;

    canvas.beginDraw();
    canvas.background(255);
    canvas.strokeWeight(thickness);


    String str = grammar.getStr();
    //useful for debugging:
    //println(str + " " );

    //Turtle Interpretation of Symbols: 
    /*The way parameters are read here is kinda clunky + repetitive
     and I've just copied and pasted it for every parameterized symbol lol*/
    for (int j = 0; j<str.length(); j++) {

      if (str.charAt(j)=='F') {
        if (str.charAt(j+1)=='(') {  
          String parameters = "";
          int k = 2;
          while (str.charAt(j+k)!=')') {
            parameters = parameters + str.charAt(j+k);
            k = k+1;
          }
          float[] parameterList = parseParam(parameters);

          forward(parameterList[0]);
        } else
          forward(1);
      }

      if (str.charAt(j)=='G') {
        if (str.charAt(j+1)=='(') {
          String parameters = "";
          int k = 2;
          while (str.charAt(j+k)!=')') {
            parameters = parameters + str.charAt(j+k);
            k = k+1;
          }
          float[] parameterList = parseParam(parameters);
          forward(parameterList[0]);
        } else
          forward(1);
      }

      if (str.charAt(j) =='!') {
        if (str.charAt(j+1)=='(') {
          String parameters = "";
          int k = 2;
          while (str.charAt(j+k)!=')') {
            parameters = parameters + str.charAt(j+k);
            k = k+1;
          }
          float[] parameterList = parseParam(parameters);
          //println(parameterList[0]);
          canvas.strokeWeight(parameterList[0]);
        } else
          canvas.strokeWeight(thickness-1);
      }

      if (str.charAt(j)=='[') {
        //push
        turtleStack.push(state);
      }

      if (str.charAt(j)==']') {
        //pop
        state = turtleStack.pop();
      }


      if (str.charAt(j)=='{') {
        shape = createShape();      
        shape.beginShape();
        shape.fill(red(col), green(col), blue(col), 190);
      }


      if (str.charAt(j)=='}') {
        shape.noStroke();
        shape.endShape(CLOSE);
        canvas.noStroke();
        canvas.shape(shape, 0, 0);
      }

      if (str.charAt(j)=='.' && !Character.isDigit(str.charAt(j+1))) { 
        if (state.getX()>=canvas.width||state.getX()<=0||state.getY()>=canvas.height-1||state.getY()<=0) {
          //println("Throw this leaf away."); 
          turtleStack.pop();
          canvas.endDraw();
          return null;
        } else {
          shape.vertex(state.getX(), state.getY());
        }
        //uncomment to mark vertex with ellipse:
        //ellipse(state.getX(),state.getY(),3,3);
      }

      if (str.charAt(j)=='+') {
        //turn left
        float angle;

        if (str.charAt(j+1)=='(') {
          String parameters = "";
          int k = 2;
          while (str.charAt(j+k)!=')') {
            parameters = parameters + str.charAt(j+k);
            k = k+1;
          }
          float[] parameterList = parseParam(parameters);
          angle = parameterList[0];
        } else {
          //println(" state get heading: "+ state.getHeading());        
          angle = grammar.getAng();
        }

        heading = state.getHeading() - radians(angle);
        //print(" radians of gramm ang: " + radians(grammar.getAng()));
        //print(" new heading: " + heading);
        x = state.getX();
        y = state.getY();
        state = new TurtleState(x, y, heading);
      }

      if (str.charAt(j)=='-') {
        //turn right 
        float angle;
        if (str.charAt(j+1)=='(') {
          String parameters = "";
          int k = 2;
          while (str.charAt(j+k)!=')') {
            parameters = parameters + str.charAt(j+k);
            k = k+1;
          }
          float[] parameterList = parseParam(parameters);

          angle = parameterList[0];
        } else {

          angle = grammar.getAng();
        }

        heading = state.getHeading() + radians(angle);
        x = state.getX();
        y = state.getY();
        state = new TurtleState(x, y, heading);
      }
    }

    turtleStack.pop();
    canvas.endDraw();
    return canvas;
  }

  void forward(float sc) {
    float scale = sc;
    canvas.stroke(0, 0, 0);

    //computing turtle movement using heading angle.
    float nx = state.getX() + (scale*len)*cos(state.getHeading());
    float ny = state.getY() + (scale*len)*sin(state.getHeading());
    canvas.line(state.getX(), state.getY(), nx, ny);
    heading = state.getHeading();
    x = nx;
    y = ny;
    state = new TurtleState(x, y, heading);
  }

  float[] parseParam(String parString) {
    //Uses QScript to parse expression strings
    String[] split = parString.split(",");
    float[] paramFloats = new float[split.length];
    for (int i = 0; i<paramFloats.length; i++) {
      Result parsed = Solver.evaluate(split[i]+ " + 0");
      paramFloats[i] = parsed.answer.toFloat();
    }
    return paramFloats;
  }
}