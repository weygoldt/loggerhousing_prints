include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

metric_bolt(size=4, l=15, pitch=0);

translate([0, 0, 20])
  metric_nut(size=4, hole=false);
