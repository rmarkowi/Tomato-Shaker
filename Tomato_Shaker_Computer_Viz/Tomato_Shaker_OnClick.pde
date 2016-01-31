void mouseClicked(){
  println("Reading New Values");
  int mouseClickedX = mouseX;
  int mouseClickedY = mouseY;
  color colorAtClick = get(mouseClickedX, mouseClickedY);
  println(colorAtClick);
  int redAtClick = int(red(colorAtClick));
  int greenAtClick = int(green(colorAtClick));
  int blueAtClick = int(blue(colorAtClick));
  println("New Target Values: " + redAtClick + ", " + greenAtClick + ", " + blueAtClick);
  targetVals[0] = redAtClick;
  targetVals[1] = greenAtClick;
  targetVals[2] = blueAtClick;
  String redToSave = str(redAtClick) + ", ";
  String greenToSave = str(greenAtClick) + ", ";
  String blueToSave = str(blueAtClick) + ", ";
  String redCertToSave = str(targetVals[3]) + ", ";
  String greenCertToSave = str(targetVals[4]) + ", ";
  String blueCertToSave = str(targetVals[5]);
  String[] saveTargetVals = {redToSave + greenToSave + blueToSave + 
                             redCertToSave + greenCertToSave + blueCertToSave};
  println("Saving New Target Values...");
  saveStrings("data/colorvalues.txt", saveTargetVals);
  loadTargetVals();
}

void keyPressed(){
  if(key == 27){
    println("Escaping!");
    camera.stop();
    exit();
  }
  else if(key == ' '){
    findFlowers();
  }
  else if(key == '1'){
    showFlowerPoints = !showFlowerPoints;
  }
  else if(key == '2'){
    showFlowerGuesses = !showFlowerGuesses;
  }
}