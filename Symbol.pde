public class Symbol {
  private char c;
  private PFont font;
  private int maxWidth; 
  private PGraphics pg;  
  private ArrayList<Circle> circles = new ArrayList<Circle>(); 
  private ArrayList<Circle> growingCircles = new ArrayList<Circle>();
  private ArrayList<PVector> allowedPoints = new ArrayList<PVector>();
  private int targetCircles = 0;

  public Symbol(PFont font) {
    this.font = font;
    maxWidth = (int)max(font.width('W'), font.width('M')) * font.getSize();
    pg = createGraphics(maxWidth, maxWidth);
  }
  
  public void setText(char c) {
    if(this.c != c) {
      circles.clear();
      growingCircles.clear();
      pg.beginDraw();
      pg.background(0);
      pg.textFont(font);
      pg.stroke(255);
      pg.text(c, 0, pg.height - pg.textDescent());
      pg.endDraw();
      allowedPoints.clear();
      for(int x = 0 ; x < pg.width ; x++) {
        for(int y = 0 ; y < pg.height ; y++) {
          if(brightness(pg.pixels[x + y * pg.width]) != 0) {
            allowedPoints.add(new PVector(x, y));
          }
        }
      }
      targetCircles = (int)(allowedPoints.size() * CIRCLE_DENSITY);
    }
    this.c = c;
  }
  
  public float getWidth() {
    return font.width(c) * font.getSize();
  }
  
  public void draw() {
    for(Circle c : circles) {
      c.draw();
    }
  }
  
  public void update() {
    if(circles.size() < targetCircles) {
      for(int i = 0 ; i < CIRCLES_PER_FRAME ; i ++) {
        addNewCircles();
      }
    }
    growCircles();
  }
  
  public void addNewCircles() {
    while(!allowedPoints.isEmpty()) {
      PVector p = allowedPoints.remove((int)random(allowedPoints.size()));
      boolean found = false;
      for(Circle c : circles) {
        if(c.containsPoint(p.x, p.y)) {
          found = true;
          break;
        }
      }
      if(found) {
        continue;
      }
      Circle c = new Circle(p.x, p.y);
      circles.add(c);
      growingCircles.add(c);
      return;
    }
  }

  public void growCircles() {
    for(int i = 0 ; i < growingCircles.size() ; i ++) {
      Circle c = growingCircles.get(i);
      boolean found = false;
      for(Circle other : circles) {
        if(c == other) {
          continue;
        }
        if(c.touchesCircle(other)) {
          found = true;
          break;
        }
      }
      if(
        found || 
        c.touchesEdge()
        || (STRICT_MODE && c.touchesShape(pg.pixels, pg.width))
      ) {
        growingCircles.remove(i);
        i--;
        continue;
      }
      c.grow();
    }
  }

}