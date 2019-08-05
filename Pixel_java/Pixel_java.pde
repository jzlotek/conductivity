public static final int width = 1000;
public static final int height = 1000;

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
    return color((int)this.temp / 3, (int)this.temp / 3, (int)this.temp / 3);
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
      nodes[x][y] = new Pixel(x, y, 0.4, 0);
    }
  }
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
  size(1000, 1000, OPENGL);
}

void draw() {
  loadPixels();

  for (int i = 0; i < (width*height); i++) {
    //print(i / height + " " + i % width + "\n");
    color c = nodes[i / height][i % height].get_color();
    pixels[i] = c;
  }
  pixels[0] = color(255, 0, 0);
  pixels[width-1] = color(255, 0, 0);
  updatePixels();
  for (int i = 0; i < 100; i++) {
    updateNodes();
  }
  print(frameRate + "\n");
}
