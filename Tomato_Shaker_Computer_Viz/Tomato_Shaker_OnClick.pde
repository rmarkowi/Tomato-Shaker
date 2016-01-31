void mouseClicked(){
  
}

void keyPressed(){
  if(key == 27){
    println("Escaping!");
    camera.stop();
    exit();
  }
}