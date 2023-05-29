// This creates a 三方仕口 (san-pou shi-kuchi) joint, which
// allows one to join three cuboids without any sort of
// screws or nail like tools
//
// x_bar, y_bar, and z_bar are each named simply after the
// axis in which each module have the longest dimension
//
// The model has no leeway in the joint sections, therefore
// you may have to file down the surface a bit to create
// enough space for the models to smoothly move.

module x_bar(side=15, wing=17.5) {
        cube([wing, side, side]);
        translate([wing+side/2, side/2, side/2])
            cube([side/2, side/2, side/2]);
        difference() {
            translate([wing, 0, 0]) cube([side, side, side/2]);
            union() {
                translate([wing+side*3/4, side/4, 0]) cylinder(h=side/2, r=side/4, $fn=100);
                translate([wing+side/2, 0, 0]) cube([side/2, side/4, side/2]);
            }
        }
        translate([wing+side, 0, 0]) cube([wing, side, side]);
        

}

module y_bar(side=15, wing=17.5) {
    cube([side, wing, side]);
    
    translate([0, wing, side/2])
        cube([side/2, side, side/2]);
    
    translate([0, wing+side, 0])
        cube([side, wing, side]);
}

module z_bar(side=15, wing=17.5) {
    // move to "locked" rotation/location, because that makes
    // it easier to visually check if the design is correct
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

let (side=15, height=50, wing=(height-side)/2) {
    color("Blue", 1) translate([0, wing, wing]) x_bar(side=side, wing=wing);
    color("Red", 1) translate([wing, wing, 0]) z_bar(side=side);
    color("Green", 1) translate([wing, 0, wing]) y_bar(side=side, wing=wing);
}
