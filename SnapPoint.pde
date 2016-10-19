class SnapPoint {
  int x;
  int y;
  int snapNumber;
  boolean occupied;
  int pictureNumber;

  SnapPoint(int xPos, int yPos, int _snapNumber) {
    x = xPos;
    y = yPos;
    snapNumber = _snapNumber;
    occupied = false;
    pictureNumber = -1;
  }
}