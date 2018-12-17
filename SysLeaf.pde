class SysLeaf extends Leaf implements Comparable<SysLeaf>{
  
  Grammar gram;
  float fitness = 0;
  String template;
  int maxIt;
    
  SysLeaf(int num, Grammar g, String temp){
   super(num); 
   gram = g;
   template = temp;
   if(template=="Pinnate"){
    maxIt = 14; 
   }
   if(template=="Palmate"){
    maxIt = 11; 
   }
   if(template=="PinLobed"){
    maxIt = 12; 
   }
  } 
    
  String getLSInfo(){
    return "um";   
  }
  
  void setFitness(float f){
   fitness = f;
  }
  
  float getFitness(){
   return fitness; 
  }
  
  String getTemplate(){
   return template;    
  }
  
  
  //comparator function in order to sort candidate leaves by fitness
  int compareTo(SysLeaf o){
    float otherFit = ((SysLeaf)o).getFitness();
    if(this.fitness - otherFit > 0){
     return -1; 
    }
    else if(this.fitness - otherFit <0){
     return 1; 
    }
    else{
     return 0; 
    }
    
  }
}