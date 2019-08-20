public static final int width = 500;
public static final int height = 500;
// 1st channel 0-255 -> lerp 23c - 1000c
// 2nd channel 0-255 -> lerp 0k - 1k
// 3rd channel 0-255 -> if > 100 true, else false


//k for BEEF .67  
PImage image;

class Pixel {
  public int x;
  public int y;
  public double temp;
  public boolean canChange;
  public double k;
  public Pixel(int x, int y, double k, double temp) {
    this.x = x;
    this.y = y;
    this.temp = temp;
    this.canChange = true;
    this.k = k;
  }
  public color get_color() {
    float percent = (float)this.temp / 1000.0;
    if (percent < 0.25) {
      return lerpColor(color(0, 0, 0), color(200, 0, 0), percent/0.25);
    } else if (percent < 0.5) {
      return lerpColor(color(200, 0, 0), color(200, 150, 0), (percent - 0.25) / 0.25);
    } else if (percent < 0.75) {
      return lerpColor(color(200, 150, 0), color(200, 200, 0), (percent - 0.5) / 0.25);
    } else {
      return lerpColor(color(200, 200, 0), color(0, 255, 255), (percent - 0.75) / 0.25);
    }
  }
  public String toString() {
    return "(" + this.x + ", " + this.y + ") \ttemp: " + this.temp +" canChange: " + this.canChange +"\tk: " + this.k;
  }
}
 
Pixel[][] nodes = new Pixel[height][width];
Pixel[][] initial = new Pixel[height][width]; 

boolean spaceBarIsPressed = false;

double getChangeTemp(Pixel n1, Pixel n2) {
  return -n1.k * (n1.temp - n2.temp);
}

void updateNodes() {
  Pixel[][] tmp = nodes.clone();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if (!nodes[y][x].canChange) {
        continue;
      }
      double dx = 0;  
      double dy = 0;

      Pixel node = nodes[y][x];
      
      //if not a border pixel, get change temp
      if (y < height - 1)
        dx += getChangeTemp(node, nodes[y+1][x]);
      if (y > 0)
        dx += getChangeTemp(node, nodes[y-1][x]);
      if (x < width - 1)
        dy += getChangeTemp(node, nodes[y][x+1]);
      if (x > 0)
        dy += getChangeTemp(node, nodes[y][x-1]);
  
      double newTemp = (node.temp + dx / 2.0 + dy / 2.0);
      newTemp = (double)max(0, min((int)newTemp, 1000));
      if (y < height - 1 && y > 0 && x > 0 && x < width - 1) {
        int maxTempY = max((int)nodes[y+1][x].temp, (int)nodes[y-1][x].temp);
        int maxTempX = max((int)nodes[y][x+1].temp, (int)nodes[y][x-1].temp);
        int maxTemp = max(maxTempY, maxTempX);
        int minTempY = min((int)nodes[y+1][x].temp, (int)nodes[y-1][x].temp);
        int minTempX = min((int)nodes[y][x+1].temp, (int)nodes[y][x-1].temp);
        int minTemp = min(minTempY, minTempX);
        if (newTemp > maxTemp) {
          newTemp = maxTemp;
          newTemp = (maxTemp - minTemp) / 2.0 * node.k;
        }
        if (newTemp < minTemp) {
          newTemp = minTemp;
          newTemp = (maxTemp - minTemp) / 2.0 * node.k;
        }
      }


      tmp[y][x].temp = newTemp;
    }
  }
  nodes = tmp;
}

void setup() {
  image = loadImage("conduction.png");
  print(image.width);
  print(image.height);
  
  

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      nodes[y][x] = new Pixel(x, y, 0, 0);
    }
  }

  image.loadPixels();
  for (int x = 0; x < height; x++) {
    for (int y = 0; y < width; y++) {
      color c = image.pixels[x * height + y];
      nodes[x][y].temp = lerp(0, 1000.0, (float)red(c) / 255.0);
      nodes[x][y].k = lerp(0.0, 1, (float)green(c) / 255.0);
      boolean canChange = false;
      //print(blue(c) + "\n");
      if (blue(c) > 100) {
        canChange = true;
      }
      nodes[x][y].canChange = canChange;
      //print(red(c) + " " + green(c) + " " + blue(c) + "\n");
    }
  }
  
  //border setup
  for (int r = 0; r < height; r++) {
    nodes[r][0].canChange = false;
    nodes[r][0].temp = 0;
    nodes[r][width-1].canChange = false;
    nodes[r][width-1].temp = 0;
  }
  for (int c = 0; c < height; c++) {
    nodes[0][c].canChange = false;
    nodes[0][c].temp = 0;
    nodes[height-1][c].canChange = false;
    nodes[height-1][c].temp = 0;
  } 
  initial = nodes.clone();
  size(500, 500, OPENGL);
}

void keyPressed() {
  if (key == ' ') {
    nodes = initial.clone();
  }
} 

void mouseClicked() {
  println(nodes[mouseY][mouseX]);
}

void draw() {
  loadPixels();

  for (int i = 0; i < (width*height); i++) {
    color c = nodes[i / height][i % height].get_color();
    pixels[i] = c;
  }
  updatePixels();
  for (int i = 0; i < 1; i++) {
    updateNodes();
  }
}


