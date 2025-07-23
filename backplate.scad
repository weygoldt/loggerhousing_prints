include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/shapes.scad>

include <main_vars.scad> // include the main variables

// Main outer shell (no holes)
module main_body()
  difference() {
    translate([0, 0, edge_r])
      cylinder(h=plate_thick - edge_r, d=main_d);
  }

// Rounded or plain exterior -------------------------------------
module rounded_shell() {
  union() {
    minkowski() {
      main_body();
      sphere(r=edge_r);
    }
  }
}

// Screw holes for M4 screws ------------------------
module screw_holes(x, y) {
  union() {
    translate([x, y, main_h * 1.5]) {
      metric_bolt(size=4, l=main_h * 2, pitch=0);
    }
    translate([x, y, 1]) {
      metric_nut(size=4, hole=false);
    }
    translate([x, y, -1]) {
      metric_nut(size=4, hole=false);
    }
  }
}

color("lightblue", 1)
  difference() {
    rounded_shell();
    screw_holes(x=0, y=-main_d / 2 + 6);
    screw_holes(x=18, y=4);
    screw_holes(x=-18, y=4);
    union() {
      translate([-(main_d * 1.2) / 2, 10, -edge_r])
        cube([main_d * 1.2, main_d / 2, plate_thick + 3 * edge_r], center=false);

      translate([-6 - main_d / 2, -27, -edge_r])
        cube([main_d / 2, main_d / 2, plate_thick + 3 * edge_r], center=false);

      translate([+6, -27, -edge_r])
        cube([main_d / 2, main_d / 2, plate_thick + 3 * edge_r], center=false);
    }
  }
