module z_bar(side=15, wing=17.5) {
    // move to "locked" state
    translate([side, 0, 0])
        rotate([0, 0, 90]) {
            //bottom
            cube([side, side, wing]);
            // middle
            translate([side/4, side/4, wing])
                cylinder(h=side, r=side/4, $fn=100);
            // top
            translate([0, 0, wing+side])
                cube([side, side, wing]);
        }
}

module y_bar(side=15, wing=17.5) {
    cube([side, wing, side]);
    
    translate([0, wing, side/2])
        cube([side/2, side, side/2]);
    
    translate([0, wing+side, 0])
        cube([side, wing, side]);
}

module x_bar(side=15, wing=17.5) {
        cube([wing, side, side]);
        difference() {
            translate([wing, 0, 0]) cube([side, side, side/2]);
            union() {
                translate([wing+side*3/4, side/4, 0]) cylinder(h=side/2, r=side/4, $fn=100);
                translate([wing+side/2, 0, 0]) cube([side/2, side/4, side/2]);
            }
        }
        translate([wing+side, 0, 0]) cube([wing, side, side]);
        

}

side=15;
height=50;
wing=(height-side)/2;


color("Red", 1) translate([wing, wing, 0]) z_bar(side=side);
color("Green", 1) translate([wing, 0, wing]) y_bar(side=side, wing=wing);
color("Blue", 1) translate([0, wing, wing]) x_bar(side=side, wing=wing);