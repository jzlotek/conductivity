public static final int width = 500;
public static final int height = 500;

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
}

Pixel[][] nodes = new Pixel[height][width];

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
      if (y < height - 1)
        dx += getChangeTemp(node, nodes[y+1][x]);
      if (y > 0)
        dx += getChangeTemp(node, nodes[y-1][x]);
      if (x < height - 1)
        dy += getChangeTemp(node, nodes[y][x+1]);
      if (x > 0)
        dy += getChangeTemp(node, nodes[y][x-1]);

      tmp[y][x].temp = (node.temp + dx + dy);
    }
  }
  nodes = tmp;
}

void setup() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      nodes[y][x] = new Pixel(x, y, 0.25, 0);
    }
  }
  nodes[height/2][width/2].temp = 1000;
  nodes[height/2][width/2].canChange= false;
  for (int x = 0; x < width; x++) {
    nodes[x][0].temp = 600;
    nodes[x][width-1].temp = 600;
  }
  for (int y = 0; y < height; y++) {
    nodes[0][y].temp = 600;
    nodes[height-1][y].temp = 600;
  }
  for (int y = 1; y < height/2; y++) {
    for (int x = 1; x < width; x++) {
      nodes[y][x].temp = 600;
    }
  }
  size(500, 500, OPENGL);
}

void draw() {
  loadPixels();

  for (int i = 0; i < (width*height); i++) {
    color c = nodes[i / height][i % height].get_color();
    pixels[i] = c;
  }
  updatePixels();
  for (int i = 0; i < 10; i++) {
    updateNodes();
  }
  print(frameRate + "\n");
}
