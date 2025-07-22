// Slimy, Scary, Wet Rock Texture Generator
// Uses multiple layers of noise to create organic, wet-looking surfaces

float time = 0;
int textureSize = 400;
PGraphics texture;

void setup() {
  size(800, 600);
  texture = createGraphics(textureSize, textureSize);
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(0);
  
  generateSlimyRockTexture();
  
  // Display the texture multiple times for effect
  image(texture, 50, 50);
  image(texture, 450, 50);
  image(texture, 250, 250);
  
  time += 0.02;
}

void generateSlimyRockTexture() {
  texture.beginDraw();
  texture.loadPixels();
  
  float timeOffset = time * 0.5;
  
  for (int x = 0; x < textureSize; x++) {
    for (int y = 0; y < textureSize; y++) {
      
      // Base rock structure - low frequency noise
      float rockBase = noise(x * 0.008, y * 0.008, timeOffset * 0.3) * 2 - 1;
      
      // Medium frequency detail for rock crevices
      float rockDetail = noise(x * 0.02, y * 0.02, timeOffset * 0.5) * 2 - 1;
      
      // High frequency surface texture
      float surface = noise(x * 0.05, y * 0.05, timeOffset) * 2 - 1;
      
      // Slime layer - animated and flowing
      float slimeFlow = noise(x * 0.015 + sin(timeOffset) * 2, 
                             y * 0.015 + cos(timeOffset * 1.3) * 2, 
                             timeOffset * 2) * 2 - 1;
      
      // Wet spots - higher frequency, animated
      float wetSpots = noise(x * 0.03 + timeOffset * 3, 
                            y * 0.03 + timeOffset * 2, 
                            timeOffset * 4) * 2 - 1;
      
      // Combine layers
      float combined = rockBase * 0.4 + rockDetail * 0.3 + surface * 0.2 + slimeFlow * 0.1;
      
      // Determine if this pixel should be slimy/wet
      boolean isWet = (slimeFlow > 0.2 && wetSpots > 0.1) || 
                      (combined < -0.3 && slimeFlow > -0.2);
      
      color pixelColor;
      
      if (isWet) {
        // Slimy, wet areas
        float slimeIntensity = map(slimeFlow, -1, 1, 0.3, 1.0);
        float hue = map(combined, -1, 1, 80, 140); // Sickly green-yellow
        hue += sin(timeOffset * 3 + x * 0.1 + y * 0.1) * 20; // Color variation
        
        float sat = 60 + slimeIntensity * 30;
        float bright = 25 + slimeIntensity * 40;
        
        // Add glossy highlights
        if (wetSpots > 0.6) {
          bright += 30;
          sat -= 20;
        }
        
        pixelColor = color(hue, sat, bright);
        
      } else {
        // Dry rock areas
        float rockIntensity = map(combined, -1, 1, 0, 1);
        float hue = map(rockDetail, -1, 1, 20, 60); // Brown to dark orange
        
        float sat = 40 + rockIntensity * 30;
        float bright = 10 + rockIntensity * 25;
        
        // Add some variation
        if (surface > 0.5) {
          bright -= 8;
          sat += 10;
        }
        
        pixelColor = color(hue, sat, bright);
      }
      
      // Add some creepy dark crevices
      if (combined < -0.6) {
        pixelColor = color(0, 0, 5); // Almost black
      }
      
      // Pulsing effect for extra creepiness
      float pulse = sin(timeOffset * 8 + x * 0.05 + y * 0.05) * 0.1 + 1;
      float currentBright = brightness(pixelColor) * pulse;
      pixelColor = color(hue(pixelColor), saturation(pixelColor), currentBright);
      
      int index = x + y * textureSize;
      texture.pixels[index] = pixelColor;
    }
  }
  
  texture.updatePixels();
  
  // Add some post-processing effects
  addSlimeGloss();
  addDrippingEffect();
  
  texture.endDraw();
}

void addSlimeGloss() {
  // Add glossy highlights that move around
  texture.fill(120, 30, 80, 100); // Translucent sickly highlight
  texture.noStroke();
  
  for (int i = 0; i < 15; i++) {
    float x = noise(i * 10, time) * textureSize;
    float y = noise(i * 10 + 100, time * 1.2) * textureSize;
    float size = noise(i * 10 + 200, time * 0.8) * 30 + 10;
    
    texture.ellipse(x, y, size, size * 0.6);
  }
}

void addDrippingEffect() {
  // Add vertical dripping streaks
  texture.stroke(100, 80, 40, 80); // Semi-transparent slimy color
  texture.strokeWeight(2);
  
  for (int i = 0; i < 20; i++) {
    float x = noise(i * 15, time * 0.3) * textureSize;
    float startY = noise(i * 15 + 300, time * 0.2) * textureSize * 0.3;
    float length = noise(i * 15 + 600, time * 0.4) * 100 + 50;
    
    // Wavy drip line
    texture.noFill();
    texture.beginShape();
    for (float y = startY; y < startY + length && y < textureSize; y += 5) {
      float waveX = x + sin(y * 0.1 + time * 5 + i) * 3;
      texture.vertex(waveX, y);
    }
    texture.endShape();
  }
}

void keyPressed() {
  if (key == 's') {
    texture.save("slimy_rock_texture.png");
    println("Texture saved!");
  }
}
