// Model for a 竿車知継ぎ (sa-oh sha-chi tsu-gee).

module male_bar(size=15, height=60, leeway=0.1) {
    angle=atan((1+leeway)/(size/5+leeway));

    difference() {
        cube([size, height/4, size]);
        for (xloc=[size/5, size*3/5]) {
            translate([xloc, size-size/10, size/3])
                cube([size/5, size/10, size*2/3]);
        }
    }

    
    difference() {
        translate([size*2/5, size, size/3])
            cube([size/5, height/2, size*2/3]);
        translate([0, height/4, 0]) {
        // stopper holes. they need to be ever so slightly bigger
        for(loc=[[size*2/5-leeway, height/4], [size*3/5, height/4+cos(angle)*size/5+leeway]]) { 
            translate([loc[0], loc[1], size/3-leeway])
                rotate([0, 0, angle])
                    cube([1+leeway, size/5+leeway, size*2/3+leeway]);
        }
    }
    }
}

module female_bar(size=15, height=60, leeway=0.1) {
    angle=atan((1+leeway)/(size/5+leeway));

    translate([0, height/4, 0]) {
        difference() {
            cube([size, height*3/4, size]);
            translate([size*2/5-leeway, 0, size/3])
                cube([size/5+leeway, height/2+leeway, size*2/3]); 
      
            // stopper holes. they need to be ever so slightly bigger
            for(loc=[[size*2/5-leeway, height/4], [size*3/5, height/4+cos(angle)*size/5+leeway]]) { 
                translate([loc[0], loc[1], size/3])
                    rotate([0, 0, angle])
                        cube([1+leeway, size/5+leeway, size*2/3+leeway]);
            }
        }
    }
    for(xloc=[size/5, size*3/5]) {
        translate([xloc, size*9/10+leeway, size/3])
            cube([size/5-leeway, size/10-leeway, size*2/3]);
    }
}

let(size=20, height=80, stopper_h=1, leeway=0.5) {
    color("Red", 1) male_bar(size=size, height=height, leeway=leeway);
    color("Green", 1) female_bar(size=size, height=height, leeway=leeway);
    color("Blue", 1) {
        for(xloc=[size*2, size*3]) {
            translate([xloc, 0, 0]) {
                translate([size/10, size*2/3+size*2/5-size/10, 0])
                    difference() {
                        cylinder(r=size*2/5, h=1, $fn=100);
                        cylinder(r=size/5, h=1, $fn=100);
                    }
                cube([size/5, size*2/3, 1]);
            }
        }
    }
}