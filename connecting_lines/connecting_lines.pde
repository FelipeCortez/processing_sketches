ArrayList<PointCirc> PointGroups;
float dt, last;
boolean saving = false;

SineModulator sin1, sin2, sin3, sin4;

float map2(float x, float start1, float stop1, float start2, float stop2) {
  if (x < start1) x = start1;
  if (x > stop1) x = stop1;
  return map(x, start1, stop1, start2, stop2);
}

class SineModulator {
  float phase;
  float freq;
  float initphase;

  SineModulator(float freq) {
    this.freq = freq;
    this.phase = 0;
    this.initphase = phase;
  }

  SineModulator(float freq, float phase) {
    this.freq = freq;
    this.phase = phase;
    this.initphase = phase;
  }

  void update(float dt) {
    phase += freq * 30 * TWO_PI;
    if (phase >= TWO_PI) phase = TWO_PI - phase;
  }

  float getValue() {
    return sin(phase);
  }
}

class Point {
  float x;
  float y;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class PointCirc {
  Point[] points;
  int points_qty;
  float radius;

  void updateRadius(float radius) {
    this.radius = radius;

    // sin for x so sin(0) stays at 0
    // all about that vertical symmetry
    for (int i = 0; i < points_qty; i++) {
      points[i].x = (width / 2) + radius * sin(i * TWO_PI / points_qty);
      points[i].y = (height / 2) + radius * cos(i * TWO_PI / points_qty);
    }
  }

  PointCirc(int points_qty, float radius) {
    points = new Point[points_qty];
    this.points_qty = points_qty;

    for (int i = 0; i < points_qty; i++) {
      points[i] = new Point(0, 0);
    }

    updateRadius(radius);
  }
}

void setup() {
  size(640, 400);

  sin1 = new SineModulator(1/2000.);
  sin2 = new SineModulator(1/3000.);
  sin3 = new SineModulator(1/13000., TWO_PI / 3);
  sin4 = new SineModulator(1/20000., 0);

  PointGroups = new ArrayList<PointCirc>();
  PointGroups.add(new PointCirc(5, 50));
  PointGroups.add(new PointCirc(10, 75));
  //PointGroups.add(new PointCirc(8, 150));
  //PointGroups.add(new PointCirc(16, 170));

  last = millis();
}

void draw() {
  sin1.update(dt);
  sin2.update(dt);
  sin3.update(dt);
  sin4.update(dt);

  background(255);
  fill(0);

  dt = millis() - last;
  last = millis();

  PointGroups.get(0).updateRadius(120 + sin1.getValue() * 10);
  PointGroups.get(1).updateRadius(100 + sin2.getValue() * 30);
  //PointGroups.get(2).updateRadius(90 + sin3.getValue() * 45);
  //PointGroups.get(3).updateRadius(180 + sin4.getValue() * 20);

  for (int i = 0; i < PointGroups.size(); i++) {
    PointCirc group = PointGroups.get(i);
    for (Point point : group.points) {
      //ellipse(point.x, point.y, 2, 2);

      for (int j = i; j < PointGroups.size(); j++) {
        PointCirc group2 = PointGroups.get(j);
        if (group != group2) {
          for (Point point2 : group2.points) {
            float pdist = dist(point.x, point.y, point2.x, point2.y);
            stroke(0, 0, 0, map2(pdist, 0, 200, 200, 0));
            line(point.x, point.y, point2.x, point2.y);
          }
        }
      }
    }
  }

  println(abs(sin2.phase - sin2.initphase) + ", " + abs(sin1.phase - sin1.initphase));
  if (!(abs(sin2.phase - sin2.initphase) < 0.3 &&
    abs(sin1.phase - sin1.initphase) < 0.3 && 
    frameCount > 10) &&
    saving) {
    saveFrame(frameCount + ".png");
  } else {
    if (saving) { 
      println("end");
    }
    saving = false;
  }
}