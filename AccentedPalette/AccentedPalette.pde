color cerulean = color(0, 64, 255);  
color complement = color(255, 191, 0);

int videoScale = 8;

int cols, rows;
color[][] cellColors;

void setup() {
  size(640, 480);

  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;

  cellColors = new color[cols][rows];
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (random(1.0) < 0.75) {
        cellColors[i][j] = cerulean;
      } else {
        cellColors[i][j] = complement;
      }
    }
  }
}

void draw() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i*videoScale;
      int y = j*videoScale;
      fill(cellColors[i][j]);
      noStroke(); 
      rect(x, y, videoScale, videoScale);
    }
  }
}
