color c1 = color(0, 100, 100);  
color c2 = color(180, 100, 100);

void setup() {
  size(640, 360); 
  noStroke();
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  fill(c1);
  rect(0, 0, width / 2, height);
  fill(c2);
  rect(width / 2, 0, width / 2, height);
}


void mouseMoved() {
  float h1 = (mouseX / 320.0) * 360;
  c1 = color(h1, 100, 100);
  float h2 = (h1 + 180.0) % 360;
  c2 = color(h2, 100, 100);
}
