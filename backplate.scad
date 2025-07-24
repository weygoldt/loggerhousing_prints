
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <main_vars.scad>

// Main outer shell (no holes)
module main_body()
  difference() {
    translate([0, 0, edge_r])
      cylinder(h=plate_thick - edge_r, d=main_d);
    union() {
      translate([-(main_d * 1.2) / 2, 10, -edge_r])
        cube([main_d * 1.2, main_d / 2, plate_thick + 3 * edge_r], center=false);

      translate([-6 - main_d / 2, -27, -edge_r])
        cube([main_d / 2, main_d / 2, plate_thick + 3 * edge_r], center=false);

      translate([+6, -27, -edge_r])
        cube([main_d / 2, main_d / 2, plate_thick + 3 * edge_r], center=false);
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

// Screw holes for M4 screws ------------------------
module screw_holes(x, y, rot) {
  translate([x, y, 0]) {
    cylinder(r=2.1, h=main_h - 5, center=true);
    rotate([0, 0, rot])
      nut_trap_inline(4, "M4");
  }
}

color("lightblue", 1)
  difference() {
    rounded_shell();
    screw_holes(x=0, y=-main_d / 2 + 4, rot=0);
    screw_holes(x=20, y=4, rot=100);
    screw_holes(x=-20, y=4, rot=-100);
  }
