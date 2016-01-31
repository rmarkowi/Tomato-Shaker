import processing.video.*;

Capture camera;
String[] camsToUse = {"name=Logitech HD Webcam C615,size=1920x1080,fps=30", "name=FaceTime HD Camera,size=1920x1080x,fps=30", "name=FaceTime HD Camera,size=1280x720,fps=30"};
String colorValFile = "data/colorvalues.txt";
int screenW = 1920;
int screenH = 1080;

int camToTry = 0;
int[] targetVals = {0, 0, 0, 0, 0, 0}; //Target Red, Target Green, Target Blue, Target Red, Target Green, Target Blue

void setup(){
  size(1920, 1080);
  loadCamera();
  loadTargetVals();
}

void draw(){
  if(camera.available()){
    camera.read();
  }
  image(camera, 0, 0);
  loadPixels();
}

void loadCamera(){
  println("Getting Camera List");
  String[] camList = Capture.list();
  int camListItem = 0;
  while(camera == null){
    if(camToTry >= camsToUse.length){
      println("No cameras match any requested ones.");
      exit();
    }
    else if(camListItem >= camList.length){
      println("Couldn't find camera: " + camsToUse[camToTry]);
      println("Trying to use camera: " + camsToUse[camToTry + 1]);
      camListItem = 0;
      camToTry += 1;
      loadCamera();
    }
    else if(camList[camListItem].equals(camsToUse[camToTry])){
      println("Checking " + camList[camListItem]);
      camera = new Capture(this, camList[camListItem]);
      println("Found camera " + camsToUse[camToTry] + ", Starting it now.");
      camera.start();
    }
    else{
      camListItem += 1;
    }
  }
}

void loadTargetVals(){
  println("Loading Target Color Vaules, looking for " + colorValFile);
  String[] loadedTargetVals = loadStrings(colorValFile);
  String stringValueToLoad = "";
  int valueToLoad = 0;
  for(int val = 0; val <= loadedTargetVals[0].length(); val++){
    if((val == loadedTargetVals[0].length()) || (loadedTargetVals[0].charAt(val) == ',')){
      targetVals[valueToLoad] = Integer.parseInt(stringValueToLoad);
      valueToLoad += 1;
      stringValueToLoad = "";
    }
    else if(loadedTargetVals[0].charAt(val) != ' '){
      stringValueToLoad += str(loadedTargetVals[0].charAt(val));
    }
  }
  println("Loaded Target Values of: ");
  for(int i = 0; i < targetVals.length; i++){
    if(i == (targetVals.length - 1)){
      print(str(targetVals[i]) + "\n");
    }
    else{
      print(str(targetVals[i]) + ", ");
    }
  }
}