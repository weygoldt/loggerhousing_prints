include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

// ---------- print / preview quality ----------
$fn = 128; // facet count for all curved surfaces

// ---------- primary body ----------
main_d = 50; // Ø of the main cylinder (mm)
main_h = 30; // height of the main cylinder (mm)

// ---------- port holes ----------
port_large_d = 25;
port_small_d = 17;
port_large_y = 18;
port_small_x = 14;
port_small_y = -13;

// ---------- rounding / fillet ----------
edge_r = 1; // set 0 → disable Minkowski rounding

include <main_vars.scad> // include the main variables

// Through-ports for connectors ----------------------------------
module port_holes() {
  // Large port
  translate([0, port_large_y, -1])
    cylinder(h=main_h + 3, d=port_large_d);

  // Small ports
  for (sx = [-1, 1])
    translate([sx * port_small_x, port_small_y, -1])
      cylinder(h=main_h + 3, d=port_small_d);

  // Dip in center to route wires
  translate([0, 0, main_h * 0.8 + edge_r]) {
    cylinder(h=main_h / 2, d=port_large_d);
    sphere(d=port_large_d);
  }
}

// Main outer shell (no holes)
module main_body()
  difference() {
    translate([0, 0, edge_r])
      cylinder(h=main_h - edge_r, d=main_d);
  }

// Rounded or plain exterior -------------------------------------
module rounded_shell() {
  union() {
    minkowski() {
      main_body();
      sphere(r=edge_r);
    }
    // Rounded edges on top but plain bottom
    cylinder(h=main_h / 4, d=main_d + 2 * edge_r);
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
    port_holes();
    screw_holes(x=0, y=-main_d / 2 + 6);
    screw_holes(x=18, y=4);
    screw_holes(x=-18, y=4);
  }
