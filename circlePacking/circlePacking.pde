final boolean STRICT_MODE = false;
final int CIRCLES_PER_FRAME = 6;
final color CIRCLE_COLOR = color(255, 180);
final float CIRCLE_THICKNESS = .75;
final int CIRCLE_SPAWN_MIN_DISTANCE = 4;
final float CIRCLE_DENSITY = 0.022;

String currentString = "";

ArrayList<Symbol> digits = new ArrayList<Symbol>();

public void setup() {
  size(1024, 256);
  smooth();
  frameRate(60);
  PFont f = createFont("Verdana-Bold", 200, true);
  for(int i = 0; i < 8 ; i ++) {
    digits.add(new Symbol(f));
  }
}

public void draw() {
  calculateShape();
  background(0, 50, 75);
  for(Symbol digit : digits) {
    digit.update();
    digit.draw();
    translate(digit.getWidth(), 0);
    clip(0, 0, width, height);
  }
}


public void calculateShape() {
  String newString = nf(hour(), 2) + ":" + nf(minute(), 2) + "." + nf(second(), 2);
  if(newString.equals(currentString)) {
    return;
  }
  currentString = newString;
  for(int i = 0 ; i < currentString.length(); i++) {
    digits.get(i).setText(currentString.charAt(i));
  }
}