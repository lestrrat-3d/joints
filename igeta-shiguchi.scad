// 井桁仕口

size=15;
leeway=size*0.03;

function x_leeway(leeway) = [leeway, 0, 0];
function y_leeway(leeway) = [0, leeway, 0];
function z_leeway(leeway) = [0, 0, leeway];
function xy_leeway(leeway) = x_leeway(leeway) + y_leeway(leeway);
function xz_leeway(leeway) = x_leeway(leeway) + z_leeway(leeway);
function yz_leeway(leeway) = y_leeway(leeway) + z_leeway(leeway);
function xyz_leeway(leeway) = x_leeway(leeway) + y_leeway(leeway) + z_leeway(leeway);

module x_bar() {
    cube([size*2, size, size]);
    translate([size*2, 0, 0]) {
        translate([0, size/3, 0]) cube([size, size/3, size/2]);
        translate([0, size/3, size/2]) cube([size/3, size/3, size/2]-x_leeway(leeway));
        translate([size*2/3, size/3, size/2]+x_leeway(leeway)) cube([size/3, size/3, size/2]-x_leeway(leeway));
        translate([size, 0, 0]) cube([size*2, size, size]);
    }
}

module y_bar() {
    // y_bar is identical to x_bar, except it's rotated.
    translate([size, size*5, size]) rotate([0, 180, 90]) x_bar();
}

module z_bar() {
    cube([size, size, size*2]);
    translate([0, 0, size*2])
        for(xloc=[0, size*2/3+leeway]) {
            for(yloc=[0, size*2/3+leeway]) {
                translate([xloc, yloc, 0])
                    cube([size/3, size/3, size]-xy_leeway(leeway));
            }
        }
}

color("Red", 1)   translate([0, size*2, size*2]) x_bar();
color("Green", 1) translate([size*2, 0, size*2]) y_bar();
color("Blue", 1)  translate([size*2, size*2, 0]) z_bar();
