class Grammar {
  String axiom;
  String[][] productions;
  Parameters parameters;
  float delta;
  float scaleFactor;


  /*Grammars need at least four arguments: 
   (1)The definition of the axiom. The starting String.
   (2)The definition of the productions.
   It is an array made up of arrays which each contain 1 production.
   The first element of each array is the Left-Hand Side (LHS) of the contained production.
   The second element of each array is the Right-Hand Side (RHS) of the contained production.
   (3)Delta, the angle value. Give in degrees. 
   (4)Scaling Factor. Give 1 to not scale. 
   Can give in either decimal (0.5) or fraction with float denom (1/2.0).
   
   They also take parameter definitions, see second constuctor
   */



  Grammar(String ax, String[][] pro, float delt, float scFa) {
    axiom =  ax;
    productions = pro;  
    delta = delt;
    scaleFactor = scFa;

    String[][] emp = {{}};
    parameters = new Parameters(emp);
  }


  Grammar(String ax, String[][] pro, Parameters par, float delt, float scFa) {
    axiom =  ax;
    productions = pro; 
    parameters = par;
    delta = delt;
    scaleFactor = scFa;

    for (int i =0; i<productions.length; i++) {
      String parString = new String(productions[i][1]);
      for (Map.Entry ent : parameters.paramHash.entrySet()) {
        String parString2 = parString.replaceAll((String)ent.getKey(), (String)ent.getValue());
        parString = parString2;
      }
      productions[i][1] = parString;
    }


    for (int i =0; i<productions.length; i++) {
      if (productions[i].length==3) {
        String condString = new String(productions[i][2]);
        for (Map.Entry ent : parameters.paramHash.entrySet()) {
          String condString2 = condString.replaceAll((String)ent.getKey(), (String)ent.getValue());
          condString = condString2;
        }
        productions[i][2] = condString;
      }
    }
  }


  Grammar reWrite() {
    StringBuilder stringBuilder = new StringBuilder();
    for (int j = 0; j<axiom.length(); j++) { 
      Boolean param = false;
      Boolean ruleApplied = false;
      String word ="";
      //println("value of character:" + " " + String.valueOf(axiom.charAt(j)));


      if (j+1 > axiom.length()-1 || axiom.charAt(j+1)!='(') {
        word = word + axiom.charAt(j);
      } else {
        param = true;
        int k = 0;
        while (axiom.charAt(j+k)!=')') {
          word = word + axiom.charAt(j+k);
          k = k + 1;
        }
        word = word + ')';
      }




      for (int i = 0; i<productions.length; i++) {

        //When symbol is not parametric, simply match symbol to production.
        if (param == false && word.equals(productions[i][0])) {  
          stringBuilder.append(productions[i][1]);
          ruleApplied = true;
          break;
        } 



        //When symbol *is* parametric, check conditions, and pass variable
        else if (param == true && word.charAt(0)==productions[i][0].charAt(0)) {
          String[] wordSym = match(word, "\\((.+?)\\)");
          String[] inputParams = wordSym[1].split(",");



          String[] prodVar = match(productions[i][0], "\\((.+?)\\)");
          String[] productionVariables = prodVar[1].split(",");

 

          //Check if number of # of parameters match
          if (inputParams.length != productionVariables.length) {
            break;
          }

          Boolean condition = true;
          if (productions[i].length==3) { 
            String condExp = new String(productions[i][2]);   

            for (int k = 0; k<inputParams.length; k++) {
              String condExp2 = condExp.replaceAll(productionVariables[k], inputParams[k]);
              condExp = condExp2;
            }

            //construct condition with actual input num

            Result cond = Solver.evaluate(condExp);
            condition = cond.answer.toBoolean();
          }

          String passedPro = new String(productions[i][1]); 
          for (int k = 0; k<inputParams.length; k++) {
            String repp = passedPro.replaceAll(productionVariables[k], inputParams[k]);
            passedPro = repp;
          }

 
          if (condition==true) {
            stringBuilder.append(passedPro);
            ruleApplied = true;
            break;
          }
        }
      }


      if (ruleApplied == false) {
        /*BUG ALERT !!! 
        lsystem has loads of extra (0)s at the end, 
         but this doesn't affect functionality */
        stringBuilder.append(word);
      }
    }
    String finalString = stringBuilder.toString(); 
    //println(finalString);
    return new Grammar(finalString, productions, delta, scaleFactor);
  }

  String getStr() {
    return axiom;
  }

  float getAng() {
    return delta;
  }

  float getScaleFactor() {
    return scaleFactor;
  }
}