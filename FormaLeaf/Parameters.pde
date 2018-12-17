import java.util.Map;

class Parameters {

  HashMap<String, String> paramHash = new HashMap<String, String>(); 
  String[][] paramList;

  Parameters(String[][] pList) {
    paramList = pList;   

    if (paramList[0].length!=0) {
      for (int i=0; i<paramList.length; i++) {
        addParam(paramList[i]);
      }
    }
  }

  void addParam(String[] pairToAdd) {
    paramHash.put(pairToAdd[0], pairToAdd[1]);
  }

  String getVal(String keyy) {
    String val = paramHash.get(keyy);
    return val;
  }
}