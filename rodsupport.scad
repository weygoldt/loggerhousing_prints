include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <main_vars.scad> // include the main variables


// Helper for port holes
module rounded_cutout(diam, height, rot, pos) {
    translate(pos) {
  rotate(rot) {
      union() {
        cylinder(h=height, d=diam, center=true);
        translate([diam/2, 0, 0]) {
          cube([diam, diam, height], center=true);
        }
      }
    }
  }
}

// Through-ports for connectors ----------------------------------
module port_holes() {
  // Large port
  //translate([0, port_large_y, -1])
    //cylinder(h=main_h + 3, d=port_large_d);
  rounded_cutout(port_large_d, main_h*1.3, [0, 0, 90], [0, port_large_y, main_h / 2]);

  // Small ports
  for (sx = [-1, 1])
      if (sx < 0) { 
        rot = 225;
        rounded_cutout(port_small_d, main_h*1.3, [0, 0, rot], [sx*port_small_x, port_small_y, main_h / 2]);
      }
      else {
        rot = -45;
        rounded_cutout(port_small_d, main_h*1.3, [0, 0, rot], [sx*port_small_x, port_small_y, main_h / 2]);
      }

  // Dip in center to route wires
  translate([0, -2, main_h*2/3]) {
    cylinder(h=main_h /2, d=port_large_d, center=false);
  //  sphere(d=port_large_d);
  //cube([port_large_d*0.8, port_large_d, main_h / 2], center=true);
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
  //union() {
    //minkowski() {
    difference() {
      main_body();
      port_holes();
      }
    //sphere(r=edge_r);
    //}

    // Rounded edges on top but plain bottom
    //difference() {
    // cylinder(h=main_h / 4, d=main_d + 2 * edge_r);
    // port_holes();
    // }
  //}
}

// Screw holes for M4 screws ------------------------
module screw_holes(x, y) {
  translate([x, y, main_h / 2 + 5]) {
    threaded_rod(d=4, l=main_h - 5, pitch=0.7, internal=true);
  }
}

color("lightblue",1)
difference() {
  rounded_shell();
  screw_holes(x=20, y=0);
  screw_holes(x=-20, y=0);
  screw_holes(x=0, y=-20);
}


