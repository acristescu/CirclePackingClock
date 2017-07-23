
public class Circle {
  float x, y, r;
  color col;
  
  public Circle(float x, float y) {
    this.x = x;
    this.y = y;
    r = 0;
    col = color(255, 120);
  }
  
  public void draw() {
    noFill();
    stroke(CIRCLE_COLOR);
    strokeWeight(computeThickness());
    ellipse(x, y, 2*r, 2*r);
  }
  
  private float computeThickness() {
    return map(r, 0, 15, 0.3, 1.8);
  }
  
  public boolean touchesEdge() {
    final float thick = computeThickness();
    return 
      x - r <= thick ||
      x + r >= width - thick ||
      y - r <= thick ||
      y + r >= height - thick
    ;
  }
  
  public boolean touchesCircle(Circle c) {
    return Math.pow(x - c.x, 2) + Math.pow(y - c.y, 2) <= Math.pow(r + c.r + 1, 2);
  }
  
  public boolean containsPoint(float x, float y) {
    return Math.pow(x - this.x, 2) + Math.pow(y - this.y, 2) <= Math.pow(r, 2) + CIRCLE_SPAWN_MIN_DISTANCE;
  }
  
  public boolean touchesShape(int[] shape, int shapeW) {
    int top =    shape[floor(x - r) + floor(y)     * shapeW];
    int bottom = shape[floor(x + r) + floor(y)     * shapeW];
    int left =   shape[floor(x)     + floor(y - r) * shapeW];
    int right =  shape[floor(x)     + floor(y + r) * shapeW];
    
    return 
      brightness(left) < 30 ||
      brightness(right) < 30 ||
      brightness(top) < 30 ||
      brightness(bottom) < 30;
  }
  
  public void grow() {
    r++;
  }
}