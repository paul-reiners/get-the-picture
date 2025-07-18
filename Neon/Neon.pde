PImage img;
PImage neonImg;

void setup() {
  size(800, 600);
  
  // Load image 
  img = loadImage("IMG_1497.jpg");
  
  // Resize image to fit canvas if needed
  img.resize(width, height);
  
  // Create neon version
  neonImg = createNeonEffect(img);
}

void draw() {
  background(0); // Black background enhances neon effect
  
  // Display the neon image
  image(neonImg, 0, 0);
}

PImage createNeonEffect(PImage source) {
  PImage result = createImage(source.width, source.height, RGB);
  source.loadPixels();
  result.loadPixels();
  
  // First pass: enhance edges and boost colors
  for (int y = 1; y < source.height - 1; y++) {
    for (int x = 1; x < source.width - 1; x++) {
      int index = x + y * source.width;
      
      // Get current pixel
      color c = source.pixels[index];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      // Edge detection using Sobel operator
      float edgeX = 0, edgeY = 0;
      
      // Sobel X kernel
      edgeX += brightness(source.pixels[(x-1) + (y-1) * source.width]) * -1;
      edgeX += brightness(source.pixels[(x+1) + (y-1) * source.width]) * 1;
      edgeX += brightness(source.pixels[(x-1) + y * source.width]) * -2;
      edgeX += brightness(source.pixels[(x+1) + y * source.width]) * 2;
      edgeX += brightness(source.pixels[(x-1) + (y+1) * source.width]) * -1;
      edgeX += brightness(source.pixels[(x+1) + (y+1) * source.width]) * 1;
      
      // Sobel Y kernel
      edgeY += brightness(source.pixels[(x-1) + (y-1) * source.width]) * -1;
      edgeY += brightness(source.pixels[x + (y-1) * source.width]) * -2;
      edgeY += brightness(source.pixels[(x+1) + (y-1) * source.width]) * -1;
      edgeY += brightness(source.pixels[(x-1) + (y+1) * source.width]) * 1;
      edgeY += brightness(source.pixels[x + (y+1) * source.width]) * 2;
      edgeY += brightness(source.pixels[(x+1) + (y+1) * source.width]) * 1;
      
      float edge = sqrt(edgeX * edgeX + edgeY * edgeY);
      
      // Boost colors and add neon glow
      float intensity = (r + g + b) / 3.0;
      float neonBoost = 1.5 + (edge * 0.01);
      
      // Create neon color palette
      r = constrain(r * neonBoost + edge * 0.5, 0, 255);
      g = constrain(g * neonBoost + edge * 0.3, 0, 255);
      b = constrain(b * neonBoost + edge * 0.8, 0, 255);
      
      // Add some color shifting for more neon-like appearance
      if (intensity > 100) {
        r = constrain(r * 1.2, 0, 255);
        b = constrain(b * 1.3, 0, 255);
      }
      
      result.pixels[index] = color(r, g, b);
    }
  }
  
  result.updatePixels();
  return applyGlow(result);
}

PImage applyGlow(PImage source) {
  PImage glowed = createImage(source.width, source.height, RGB);
  source.loadPixels();
  glowed.loadPixels();
  
  int radius = 3;
  
  for (int y = 0; y < source.height; y++) {
    for (int x = 0; x < source.width; x++) {
      float totalR = 0, totalG = 0, totalB = 0;
      int count = 0;
      
      // Sample surrounding pixels for glow effect
      for (int dy = -radius; dy <= radius; dy++) {
        for (int dx = -radius; dx <= radius; dx++) {
          int nx = x + dx;
          int ny = y + dy;
          
          if (nx >= 0 && nx < source.width && ny >= 0 && ny < source.height) {
            int index = nx + ny * source.width;
            color c = source.pixels[index];
            
            // Weight based on distance for glow falloff
            float distance = sqrt(dx*dx + dy*dy);
            float weight = 1.0 / (1.0 + distance * 0.5);
            
            totalR += red(c) * weight;
            totalG += green(c) * weight;
            totalB += blue(c) * weight;
            count++;
          }
        }
      }
      
      // Combine original with glow
      int originalIndex = x + y * source.width;
      color original = source.pixels[originalIndex];
      
      float glowR = totalR / count;
      float glowG = totalG / count;
      float glowB = totalB / count;
      
      float finalR = constrain(red(original) + glowR * 0.3, 0, 255);
      float finalG = constrain(green(original) + glowG * 0.3, 0, 255);
      float finalB = constrain(blue(original) + glowB * 0.3, 0, 255);
      
      glowed.pixels[originalIndex] = color(finalR, finalG, finalB);
    }
  }
  
  glowed.updatePixels();
  return glowed;
}

// Press 's' to save the neon image
void keyPressed() {
  if (key == 's' || key == 'S') {
    neonImg.save("neon_effect.png");
    println("Neon image saved!");
  }
}
