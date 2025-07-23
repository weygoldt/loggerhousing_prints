include <main_vars.scad>

module cutout() {
  translate([-5, 20, -1])
    cube([10, 10, plate_thick + 3]);
}

// Main outer shell (no holes)
module main_body() {
  difference() {
    translate([0, 0, edge_r])
      cylinder(h=batt_plate_thick - edge_r, d=main_d);
    cutout();
  }
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

// Holes for magnets
module magnet_holes(x, y) {
  translate([x, y, -edge_r]) {
    union() {
      cylinder(h=batt_plate_thick + edge_r, d=3.5);
      cylinder(h=batt_plate_thick + edge_r * 3, d=2.5);
    }
  }
}

color("lightblue", 1)
  difference() {
    //main_body();
    rounded_shell();
    magnet_holes(16, -13);
    magnet_holes(-16, -13);
    magnet_holes(0, 5);
  }
