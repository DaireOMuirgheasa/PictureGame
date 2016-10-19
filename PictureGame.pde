ArrayList<PictureBlock> pictures = new ArrayList<PictureBlock>();
GameBoard game;

boolean mouseIsPressed = false;
boolean mouseIsTouching = false;
PImage bird;
int boardSize;

void setup() {
  size(600, 600);

  if ( width <= height) {
    boardSize = width;
  } else {
    boardSize = height;
  }

  bird = loadImage("birdImage.jpg");
  bird.resize(boardSize, boardSize);

  game = new GameBoard(width/2, height/2, 3*boardSize/4, 3*boardSize/4, 3, 3);
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      pictures.add(new PictureBlock(bird.get(j*boardSize/3, i*boardSize/3, boardSize/3, boardSize/3), j + i*3 ) );
    }
  }
}

void draw() {
  background(0);
  game.run();
  //  for (int i = 0; i < pictures.size(); i++) {
  for (int i = pictures.size()-1; i >= 0; i--) {
    pictures.get(i).run();
  }
  for (int i = 0; i < pictures.size(); i++) {
    if (mouseIsPressed) {
      if (pictures.get(i).selected == true) {
        pictures.get(i).xPos = (int)lerp( pictures.get(i).xPos, mouseX, 0.5);
        pictures.get(i).yPos = (int)lerp( pictures.get(i).yPos, mouseY, 0.5);
        PictureBlock temp = pictures.get(i);
        pictures.remove(i);
        pictures.add(0, temp);
        break;
      }
    }
  }

  if ( winGame() ) {
    textSize(30);
    fill(255, 150, 0);
    text("Congratulations You Win", boardSize/4, boardSize/2);
  }
}

void mousePressed() {
  boolean pictureSelected = false;
  mouseIsPressed = true;
  for (int i = 0; i < pictures.size(); i++) {
    pictures.get(i).isTouchingCircle(mouseX, mouseY, 0);
    if (pictureSelected == true) {
      pictures.get(i).selected = false;
    }
    //println(i + " is selected " + pictures.get(i).selected);
    if (pictures.get(i).selected == true) {
      pictureSelected = true;
    }
  }
  pictureSelected = false;

  //for (int i = 0; i < pictures.size(); i++) {
  //  println(i + " is selected " + pictures.get(i).selected);
  //}

  for (int i = 0; i < game.snapPoints.size(); i++) {
    for (int j = 0; j < pictures.size(); j++) {
      if (pictures.get(j).selected == true && pictures.get(j).pictureNumber == game.snapPoints.get(i).pictureNumber) {
        if (dist(pictures.get(j).xPos, pictures.get(j).yPos, game.snapPoints.get(i).x, game.snapPoints.get(i).y) < 50) {
          game.snapPoints.get(i).occupied = false;
          game.snapPoints.get(i).pictureNumber = -1;
        }
      }
    }
  }
}

void mouseReleased() {
  mouseIsPressed = false;
  for (int i = 0; i < game.snapPoints.size(); i++) {
    //println("Snap point " + i + " is occupied " + game.snapPoints.get(i).occupied + " by " + game.snapPoints.get(i).pictureNumber);
    for (int j = 0; j < pictures.size(); j++) {
      if (game.snapPoints.get(i).occupied == false) {
        //println("Game snap point [" + i + "] should be false and is: " + game.snapPoints.get(i).occupied);
        if (dist(pictures.get(j).xPos, pictures.get(j).yPos, game.snapPoints.get(i).x, game.snapPoints.get(i).y) < 30 && pictures.get(j).selected == true) {
          pictures.get(j).xPos = (int) game.snapPoints.get(i).x;
          pictures.get(j).yPos = (int) game.snapPoints.get(i).y;
          game.snapPoints.get(i).occupied = true;
          game.snapPoints.get(i).pictureNumber = pictures.get(j).pictureNumber;
          PictureBlock temp = pictures.get(j);
          pictures.remove(j);
          pictures.add(pictures.size(), temp);
          //println("[" + i + "]" + " is occupied: " + game.snapPoints.get(i).occupied);
          //println("[" + pictures.get(j).pictureNumber + "] is occupying [" + i +"]");
        }
      }
    }
    //println("Snap point " + i + " is occupied " + game.snapPoints.get(i).occupied + " by " + game.snapPoints.get(i).pictureNumber);
  }
  //println("End");
}

boolean winGame() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if ( !(game.snapPoints.get(j+i*3).pictureNumber == game.snapPoints.get(j+i*3).snapNumber) ) {
        //println("Missing point: " + (j+i*3));
        return false;
      }
    }
  }
  return true;
}