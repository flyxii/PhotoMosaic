class Tile{
  PImage img;
  float avgR;
  float avgG;
  float avgB;
  
  Tile(PImage img, int size){
    this.img = img;
    img.resize(size, size);
    calcAvg();
  }
  
  void calcAvg(){
    img.loadPixels();
    float r=0, g=0, b=0;
    
    for(int i=0; i<img.pixels.length; i++){
      color c = img.pixels[i];
      r += red(c);
      g += green(c);
      b += blue(c);
    }
    
    avgR = r/img.pixels.length;
    avgG = g/img.pixels.length;
    avgB = b/img.pixels.length;
  }
}

Tile[] tiles;
int size = 10;

void setup(){
  PImage img = loadImage("lion.jpg");
  size(1200, 600);
  background(255);
  loadTiles();
  img.loadPixels();
  for(int x=0; x<img.width; x+=size){
    for(int y=0; y<img.height; y+=size){
      color c = avgRGB(img, x, y, size);
      if(red(c) + green(c) + blue(c) < 700){
        int i = findTile(c);
        image(tiles[i].img, x, y);
      }
    }
  }
}

color avgRGB(PImage img, int x, int y, int s){
  float r=0, g=0, b=0;
  for(int i=x; i<x+s; i++){
    for(int j=y; j<y+s; j++){
      color c = img.pixels[y*img.width+x];
      r += red(c);
      g += green(c);
      b += blue(c);
    }
  }
  r /= s*s;
  g /= s*s;
  b /= s*s;
  return color(r, g, b);
}

void loadTiles() {
  File[] files = listFiles(sketchPath("photos"));
  tiles = new Tile[files.length];
  for (int i = 0; i < files.length; i++) {
    String path = files[i].getAbsolutePath();
    tiles[i] = new Tile(loadImage(path), size);
  }
}

int findTile(color c){
  float minDist = 255*3+1;
  int minIdx = -1;
  for(int i=0; i<tiles.length; i++){
    float d = dist(red(c), green(c), blue(c), tiles[i].avgR, tiles[i].avgG, tiles[i].avgB);
    if(d<minDist){
      minDist = d;
      minIdx = i;
    }
  }
  return minIdx;
}
