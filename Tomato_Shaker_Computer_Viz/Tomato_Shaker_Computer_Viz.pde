import processing.video.*;

Capture camera;
String[] camsToUse = {"name=Logitech HD Webcam C615,size=1920x1080,fps=30", 
                      "name=Logitech Camera,size=1920x1080,fps=30",
                      "name=FaceTime HD Camera,size=1920x1080x,fps=30", 
                      "name=FaceTime HD Camera,size=1280x720,fps=30"};
String colorValFile = "data/colorvalues.txt";
int screenW = 1920;
int screenH = 1080;

int camToTry = 0;
int[] targetVals = {0, 0, 0, 0, 0, 0}; //Target Red, Target Green, Target Blue, Target Red, Target Green, Target Blue

boolean showFlowerPoints = false;
boolean showFlowerGuesses = false;

ArrayList<int[]> possibleFlowerPoints = new ArrayList<int[]>();
ArrayList<ArrayList> possibleFlowers = new ArrayList<ArrayList>();

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
  if(showFlowerPoints){
    showFlowerPoints();
  }
  if(showFlowerGuesses){
    showFlowerGuesses();
  }
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
    if((val == loadedTargetVals[0].length()) || 
       (loadedTargetVals[0].charAt(val) == ',')){
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

void findFlowers(){
  possibleFlowerPoints = new ArrayList<int[]>();
  possibleFlowers = new ArrayList<ArrayList>();
  println("Looking for all the flower points");
  for(int yPix = 0; yPix < screenH; yPix++){
    for(int xPix = 0; xPix < screenW; xPix ++){
      color currentPixColor = get(xPix, yPix);
      if((((currentPixColor >> 16) & 0xFF) >= (targetVals[0] - targetVals[3])) &&   //Checks that the color is more than red-certainty
          (((currentPixColor >> 16) & 0xFF) <= (targetVals[0] + targetVals[3]))){   //Checks that the color is less than red+certainty
        if((((currentPixColor >> 8) & 0xFF) >= (targetVals[1] - targetVals[4])) &&  //Checks that the color is more than green-certainty
            (((currentPixColor >> 8) & 0xFF) <= (targetVals[1] + targetVals[4]))){  //Checks that the color is less than green+certainty
          if(((currentPixColor & 0xFF) >= (targetVals[2] - targetVals[5])) &&       //Checks that the color is more than blue-certainty
              ((currentPixColor & 0xFF) <= (targetVals[2] + targetVals[5]))){       //Checks that the color is less than blue+certainty
            int[] possibleFlowerPoint = {xPix, yPix};
            possibleFlowerPoints.add(possibleFlowerPoint);                          //If the point is the right color, add it to a list of possible flower points
          }
        }
      }
    }
  }
  
  println("Trying to match all the flowers");
  ArrayList<int[]> startingFlower = new ArrayList<int[]>();
  startingFlower.add(possibleFlowerPoints.get(0));
  possibleFlowers.add(startingFlower);
  for(int currentFlowerPoint = 1; currentFlowerPoint < possibleFlowerPoints.size(); currentFlowerPoint++){   //For every possible flower point
    println("Checking Flower Point: " + currentFlowerPoint);
    ArrayList<ArrayList> possibleFlowersForIterating = new ArrayList<ArrayList>();
    possibleFlowersForIterating = copyArrayLists(possibleFlowers);
    int[] possibleFlowerCoordToCheck = possibleFlowerPoints.get(currentFlowerPoint);                         //The possible coordinate to Check
    for(int possibleFlower = 0; possibleFlower < possibleFlowersForIterating.size(); possibleFlower++){                  //For every possible flower already identified
      println("Checking with flower " + possibleFlower);
      ArrayList<int[]> tempPossibleFlower = possibleFlowersForIterating.get(possibleFlower);
      for(int coordInPossibleFlower = 0; coordInPossibleFlower < tempPossibleFlower.size(); coordInPossibleFlower++){    //For every coordinate describing the possible flower
        int[] coord = tempPossibleFlower.get(coordInPossibleFlower);
        if((possibleFlowerCoordToCheck[0] >= coord[0] - 1)||                                                 //If the possible coord is to the left of the existing coord
           (possibleFlowerCoordToCheck[0] <= coord[0] + 1)||                                                 //Or the possible coord is to the right of the existing coord
           (possibleFlowerCoordToCheck[1] >= coord[1] - 1)||                                                 //Or the possible coord is above the existing coord
           (possibleFlowerCoordToCheck[1] <= coord[1] + 1)){                                                 //Or the possible coord is below the existing coord
          tempPossibleFlower.add(possibleFlowerCoordToCheck);
          possibleFlowers.add(tempPossibleFlower);
          possibleFlowers.remove(currentFlowerPoint);
          println("Added point to flower " + possibleFlower);
        }
        else{
          ArrayList<int[]> newFlower = new ArrayList<int[]>();
          newFlower.add(possibleFlowerCoordToCheck);
          possibleFlowers.add(newFlower);
          println("Added new flower");
        }
      }
    }
  }
}

void showFlowerPoints(){
  for(int[] flowerPoint : possibleFlowerPoints){
    color red = color(255, 0, 0);
    set(flowerPoint[0], flowerPoint[1], red);
  }
}

void showFlowerGuesses(){
  for(int flowerNum = 0; flowerNum < possibleFlowers.size(); flowerNum++){
    color red = color(255, 0, 0);
    color green = color(0, 255, 0);
    color blue = color(0, 0, 255);
    ArrayList<int[]> possibleFlower = possibleFlowers.get(flowerNum);
    for(int[] flowerPoints : possibleFlower){
      if(flowerNum % 3 == 0){
        set(flowerPoints[0], flowerPoints[1], red);
      }
      if(flowerNum % 3 == 1){
        set(flowerPoints[0], flowerPoints[1], green);
      }
      if(flowerNum % 3 == 2){
        set(flowerPoints[0], flowerPoints[1], blue);
      }
    }
  }
}

ArrayList copyArrayLists(ArrayList in){
  ArrayList out = new ArrayList();
  for(int i = 0; i < in.size(); i++){
    out.add(in.get(i));
  } 
  return out;
}