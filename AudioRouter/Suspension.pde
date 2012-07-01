class Suspension extends Neuron {
  
  private PVector origin;
  private float distance;
  private Vertex[] verts;

  private float theta;
  private float deviation;
  private int radius;
  private int slave = 0;
    
  private int amount = 16;
  
  Suspension(int d) {
    duration = d / (float) 1000;
    origin = new PVector(width / 2, height / 2);
    theta = random(TWO_PI);
    deviation = HALF_PI;
    distance = width / 2;
    radius = 25;
    initialize();
  }
  
  /**
   * Getters
   */
  
  public float getX() {
    return origin.x;
  }
  
  public float getY() {
    return origin.y;
  }
  
  public float getTheta() {
    return theta;
  }
  
  public float getDeviation() {
    return deviation * 2;
  }
  
  public float getDistance() {
    return distance;
  }
  
  public int getAmount() {
    return amount;
  }
  
  public int getRadius() {
    return radius;
  }
  
  /**
   * Setters
   */
  
  public void setDistance(float d) {
    distance = d;
    // Should reinitialize
  }
  
  public void setTheta(float t) {
    theta = t;
    // Should reinitialize
  }
  
  public void setDeviation(float d) {
    deviation = d / (float) 2;
    // Should reinitialize
  }

  public void setOrigin(float x, float y) {
    origin.x = x;
    origin.y = y;
    // Should reinitialize
  }
  
  public void setAmount(int a) {
    amount = a;
    // Should reinitialize
  }
  
  public void setRadius(int r) {
    radius = r;
    // Should reinitialize
  }
  
  public void initialize() {
    
    verts = new Vertex[amount];
    for (int i = 0; i < amount; i++) {
      
      verts[i] = new Vertex(origin.x, origin.y);
      
      float t = theta + random(-deviation, deviation);
      float a = random(distance);
      float d = random(duration);
      float r = random(radius / 2, radius);
      float x = a * cos(t) + origin.x;
      float y = a * sin(t) + origin.y;
      
      verts[i].destination.set(x, y, 0);
      verts[i].radius = r;
    }
  }
  
  public void play() {
    if (playing) {
      return;
    }
    animate_in();
  }
  
  public void animate_in() {
    playing = true;
    AniSequence s = new AniSequence(app);
    s.beginSequence();
    s.beginStep();
    for (int i = 0; i < amount; i++) {
      Vertex v = verts[i];
      s.add(Ani.to(v, duration, delay, "x", v.destination.x, easing));
      s.add(Ani.to(v, duration, delay, "y", v.destination.y, easing));
    }
    s.add(Ani.to(this, duration, delay, "slave", 0, easing, "onEnd:animate_end"));
    s.endStep();
    s.endSequence();
    s.start();
  }
  
  public void animate_end() {
    playing = false;
    for (int i = 0; i < amount; i++) {
      verts[i].x = origin.x;
      verts[i].y = origin.y;
    }
  }
  
  public void render() {
    if (!playing) {
      return;
    }
    noStroke();
    fill(pigment);
    for (int i = 0; i < amount; i++) {
      Vertex v = verts[i];
      ellipse(v.x, v.y, v.radius, v.radius);
    }
  }
  
}

class Vertex extends PVector {

  public PVector destination = new PVector();
  public float radius;
  
  Vertex(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
}
