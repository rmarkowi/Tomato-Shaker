import processing.video.*;

Capture camera;
String camToUse = "name=Logitech HD Webcam C615,size=1920x1080,fps=30";
String colorValFile = "data/colorvalues.txt";
int screenW = 1920;
int screenH = 1080;

int[] targetVals = {0, 0, 0, 30}; //Target Red, Target Green, Target Blue, Target Certainty

void setup(){
  size(1920, 1080);
  println("Getting Camera List");
  String[] camList = Capture.list();
  int camListItem = 0;
  while(camera == null){
    println("Checking " + camList[camListItem]);
    if(camList[camListItem].equals(camToUse)){
      camera = new Capture(this, camList[camListItem]);
      println("Found camera " + camToUse + ", Starting it now.");
      camera.start();
    }
    else{
      camListItem += 1;
    }
  }
  loadTargetVals();
}

void draw(){
  if(camera.available()){
    camera.read();
  }
  image(camera, 0, 0);
  loadPixels();
}

void loadTargetVals(){
  println("Loading Target Color Vaules, looking for " + colorValFile);
  String[] loadedTargetVals = loadStrings(colorValFile);
  String stringValueToLoad = "";
  int valueToLoad = 0;
  for(int val = 0; val < loadedTargetVals[0].length(); val++){
    if(loadedTargetVals[0].charAt(val) == ','){
      targetVals[valueToLoad] = Integer.parseInt(stringValueToLoad);
      valueToLoad += 1;
      stringValueToLoad = "";
    }
    else if(loadedTargetVals[0].charAt(val) != ' '){
      stringValueToLoad += str(loadedTargetVals[0].charAt(val));
    }
  }
  println("Loaded Target Values of: " + str(targetVals[0]) + ", " + str(targetVals[1]) + ", " + 
          str(targetVals[2]) + ", " + str(targetVals[3]));
}