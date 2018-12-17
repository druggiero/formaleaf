import gab.opencv.*;

class GrammarGenerator {

  PApplet sketch;
  OpenCV sysLeafCV;
  ImageProcessor iProc = new ImageProcessor();

  GrammarGenerator(PApplet sk) {
    sketch = sk;
  }


  Grammar buildGrammar(String template, float[] paramVals) {
    if (template.equals("Pinnate")) {
      String axiom = "{.S(0)}";
      String [][]productions = {
        {"S(t)", "P(t)"}, 
        {"P(t)", "!(5)G(LP, RP)[+(AN)L(t).][P(t+1)][-(AN)L(t).]"}, 
        {"L(t)", "!(2)G(LL, RL)L(t-1)", "t>=BE"}, 
        {"G(s,r)", "G(s*r, r)"}};
      String [][]paramDefs = {
        {"LP", str(map(paramVals[0], 0, 1, 2, 4.3))}, 
        {"RP", str(map(paramVals[1], 0, 1, 1, 1.25))}, 
        {"LL", str(map(paramVals[2], 0, 1, 1, 1.9))}, 
        {"RL", str(map(paramVals[3], 0, 1, 1.1, 1.38))}, 
        {"BE", str(map(paramVals[4], 0, 1, 0, -1))}, 
        {"AN", str(map(paramVals[5], 0, 1, 40, 80))}};  
      Parameters parameters = new Parameters(paramDefs);
      Grammar constructedGrammar = new Grammar(axiom, productions, parameters, 60, 1); 
      return constructedGrammar;
    } else if (template.equals("Palmate")) {
      String axiom = "{.S(0)}";
      String [][]productions = {
        {"S(t)", "[+(ANN)+(ANN)B(t)].[+(ANN)P(t)].[P(t)].[-(ANN)P(t)].[-(ANN)-(ANN)B(t)]"}, 
        {"P(t)", "!(5)G(LP,RP)[+(AN)L(t).][P(t+1)][-(AN)L(t).]"}, 
        {"B(t)", "P(t)"},
        {"L(t)", "!(2)G(LL,RL)L(t-1)", "t>=BE"}, 
        {"G(s,r)", "G(s*r, r)"}};
      String [][]paramDefs = {
        {"LP", str(map(paramVals[0], 0, 1, 1.2, 3))}, 
        {"RP", str(map(paramVals[1], 0, 1, 1.1, 1.25))}, 
        {"LL", str(map(paramVals[2], 0, 1, 1.1, 2))}, 
        {"RL", str(map(paramVals[3], 0, 1, 1, 1.5))}, 
        {"BE", str(map(paramVals[4], 0, 1, 0, -4))}, 
        {"AN", str(map(paramVals[5], 0, 1, 40, 80))},
        {"ANN", str(map(paramVals[6], 0 , 1, 40, 70))}};  
      Parameters parameters = new Parameters(paramDefs);
      Grammar constructedGrammar = new Grammar(axiom, productions, parameters, 60, 1); 
      return constructedGrammar;
    } else if (template.equals("PinLobed")) {
      String axiom = "{.S(0)}";
      String [][]productions = {
        {"S(t)", "P(t,LO)"}, 
        {"P(t,i)", "!(6)G(LP,RP)[+(AN)A(t)][P(t+1,i-1)][-(AN)A(t)]", "i>=0"}, 
        {"P(t,i)","!(6)G(LP,RP)N(t)" ,"i<0"},  
        {"A(t)", "!(4)G(LL,RL)[+(ANN)L(t-1).][A(t+1)][-(ANN)L(t-1).]", "t>=BE"}, 
        {"L(t)", "!(3)G(LT,RT)L(t-1)", "t>=BE"},
        {"N(t)", "!(4)[A(t+1)]", "t>=BE"},
        {"G(s,r)", "G(s*r, r)"}};

      String [][]paramDefs = {
        {"LP", str(map(paramVals[0], 0, 1, 6, 8))}, 
        {"RP", str(map(paramVals[1], 0, 1, 1.1, 1.26))}, 
        {"LL", str(map(paramVals[2], 0, 1, 1, 1.4))}, 
        {"RL", str(map(paramVals[3], 0, 1, 1.2, 1.45))}, 
        {"LT", str(map(paramVals[4], 0, 1, 1, 1.4))}, 
        {"RT", str(map(paramVals[5], 0, 1, 1.1, 1.2))}, 
        {"BE", str(map(paramVals[6], 0, 1, -1, -3))}, 
        {"AN", str(map(paramVals[7], 0, 1, 35, 60))}, 
        {"ANN", str(map(paramVals[8], 0, 1, 30, 85))}, 
        {"LO", str(map(paramVals[9], 0, 1, 1, 4))}}; 

      Parameters parameters = new Parameters(paramDefs);
      Grammar constructedGrammar = new Grammar(axiom, productions, parameters, 60, 1); 
      return constructedGrammar;
    } else if (template.equals("Tulip")) {
      /*must be tweaked with sliders to resemble tulip tree
      not included in search */
      String axiom = "{.S(0)}";
      String [][]productions = {
        {"S(t)", "Z(t,LO)"}, 
        {"Z(t,i)", "!(6)[-(AN)A(t)][P(t+1,i-1)][+(AN)A(t)]", "i>=0"}, 
        {"P(t,i)", "!(6)G(LP,RP)[-(AN)A(t)][P(t+1,i-1)][+(AN)A(t)]", "i>=0"}, 
        {"A(t)", "!(4)G(LL,RL)[-(ANN)L(t-1).][A(t+1)][+(ANN)L(t-1).]", "t>=BE"}, 
        {"L(t)", "!(3)G(LT,RT)L(t-1)", "t>=BE"}, 
        {"G(s,r)", "G(s*r, r)"}};

      String [][]paramDefs = {
        {"LP", str(map(paramVals[0], 0, 1, 6, 8))}, 
        {"RP", str(map(paramVals[1], 0, 1, 1.1, 1.26))}, 
        {"LL", str(map(paramVals[2], 0, 1, 1, 4))}, 
        {"RL", str(map(paramVals[3], 0, 1, 1, 1.5))}, 
        {"LT", str(map(paramVals[4], 0, 1, 1, 1.6))}, 
        {"RT", str(map(paramVals[5], 0, 1, 1.1, 1.5))}, 
        {"BE", str(map(paramVals[6], 0, 1, -1, -3))}, 
        {"AN", str(map(paramVals[7], 0, 1, 35, 60))}, 
        {"ANN", str(map(paramVals[8], 0, 1, 30, 85))}, 
        {"LO", str(map(paramVals[9], 0, 1, 1, 4))}}; 
      Parameters parameters = new Parameters(paramDefs);
      Grammar constructedGrammar = new Grammar(axiom, productions, parameters, 60, 1); 
      return constructedGrammar;
    } else if (template.equals("ComPalm")) {
      //compound palmate leaf, not in search
      String axiom = "{.S(0)}";
      String [][]productions = {
        {"S(t)", "[+(ANN)+(ANN)P(t)].[+(ANN)P(t)].[P(t)].[-(ANN)P(t)].[-(ANN)-(ANN)P(t)]"}, 
        {"P(t)", "!(5)G(LP,RP)[-(AN)L(t).][P(t+1)][+(AN)L(t).]"}, 
        {"L(t)", "!(2)G(LL,RL)L(t-1)", "t>=BE"}, 
        {"G(s,r)", "G(s*r, r)"}};
      String [][]paramDefs = {
        {"LP", str(map(paramVals[0], 0, 1, 1.2, 3))}, 
        {"RP", str(map(paramVals[1], 0, 1, 1.1, 1.25))}, 
        {"LL", str(map(paramVals[2], 0, 1, 1.1, 2))}, 
        {"RL", str(map(paramVals[3], 0, 1, 1, 1.5))}, 
        {"BE", str(map(paramVals[4], 0, 1, 2, -4))}, 
        {"AN", str(map(paramVals[5], 0, 1, 40, 80))},
        {"ANN", str(map(paramVals[6], 0 , 1, 40, 70))}};
      Parameters parameters = new Parameters(paramDefs);
      Grammar constructedGrammar = new Grammar(axiom, productions, parameters, 60, 1); 
      return constructedGrammar;

    }
    
  
    else {
      //Don't think this ever gets run, here just in case
      //old version of palmate temp, dunno what it looks like
      String axiom = "{[++A(0)].[+(AN)A(0)].[A(0)].[-(AN)A(0)].[--A(0)]}";
      String [][]productions = {{"A(t)", "G(LA,RA)[-L(t).][A(t+1)][+L(t).]"}, 
        {"L(t)", "G(LL,RL)L(t-1)", "t>=-8"}, 
        {"G(s,r)", "G(s*r, r)"}};
      String [][]paramDefs = {
        {"LA", str(map(paramVals[0], 0, 1, 2, 5))}, 
        {"RA", str(map(paramVals[1], 0, 1, 1, 1.25))}, 
        {"LL", str(map(paramVals[2], 0, 1, 1, 1.9))}, 
        {"RL", str(map(paramVals[3], 0, 1, 1.1, 1.35))}, 
        {"AN", str(map(paramVals[4], 0, 1, 40, 80))}};  
      Parameters parameters = new Parameters(paramDefs);
      Grammar constructedGrammar = new Grammar(axiom, productions, parameters, 60, 1); 
      return constructedGrammar;
    }
  }


  SysLeaf search(Leaf realLeaf, SysLeaf fakeLeaf, int poolSize, int generations) {

    List<SysLeaf> candList = makeCandidates(realLeaf, fakeLeaf, poolSize);  

    //candList is sorted by fitness, so return best individual.
    return candList.get(0);
  }




  List<SysLeaf> makeCandidates(Leaf realLeaf, SysLeaf fakeLeaf, int poolSz) {
    Grammar[] candidateGrams = new Grammar[poolSz];
    List<SysLeaf> candidateLeavesAll = new ArrayList<SysLeaf>();


    float fitness;
    String template = "Pinnate";

    for (int i=0; i<candidateGrams.length; i++) {
      //for serach, hill climbing/sim anneal? Depends on generation?
      //modify template probabilities??
      //mutate top half of candidates
      PGraphics candiCanvas = null;

      //keep generating candidate until valid, in-bounds one arrives
      while (null == candiCanvas) {  
        float[] paramVals = {random(1), random(1), random(1), random(1), random(1), random(1), random(1), random(1), random(1), random(1)};
        //need to store venation/template type in sysLeaf...
        float dice = random(1);
        int itMax = 14;
        if (dice<=0.33333) {
          template = "Pinnate";
          candidateGrams[i] = buildGrammar(template, paramVals);
          itMax = 14;
        } else if (dice>0.333333 && dice<0.666666) {
          template = "Palmate";
          candidateGrams[i] = buildGrammar(template, paramVals);
          itMax = 11;
        } else if (dice>=0.666666) {
          template = "PinLobed";
          candidateGrams[i] = buildGrammar(template, paramVals);
          itMax = 12;
        } else {
          itMax = 14;
          template = "Pinnate";
          candidateGrams[i] = buildGrammar(template, paramVals);
        }

        Turtle turty = new Turtle(candidateGrams[i], itMax, 4, width/2, (float)realLeaf.base.y, -PI/2);
        candiCanvas = turty.drawGrammar(realLeaf.col);
      }



      PImage sysLeafImg = candiCanvas.get();
      image(sysLeafImg, 0, 0);
      OpenCV sysLeafCV = new OpenCV(sketch, sysLeafImg);
      SysLeaf fakeLeafCan = new SysLeaf(realLeaf.getNum(), candidateGrams[i], template);
      PImage sysLeafProcessed = iProc.processImage(sysLeafCV, fakeLeafCan); 

      fitness = realLeaf.evaluateSimilarity(fakeLeafCan); 
      fakeLeafCan.setFitness(fitness);
      println(i);
      //saving cadidates! filename is fitness.
      candiCanvas.save("candidates/" +fitness+ ".jpg");
      candidateLeavesAll.add(fakeLeafCan);
    }


    println(candidateLeavesAll.size());
    Collections.sort(candidateLeavesAll);
    return candidateLeavesAll;
  }
}