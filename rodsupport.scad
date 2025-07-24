include <BOSL2/std.scad>
include <BOSL2/threading.scad>
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
  translate([x, y, main_h / 2 + 5]) {
    threaded_rod(d=4, l=main_h - 5, pitch=0.7, internal=true);
    //cylinder(r=2, h=main_h - 5, center=true);
  }
}

color("lightblue", 0.5)
  difference() {
    rounded_shell();
    port_holes();
    screw_holes(x=0, y=-main_d / 2 + 4);
    screw_holes(x=20, y=4);
    screw_holes(x=-20, y=4);
  }
