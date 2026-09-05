// Model for a 竿車知継ぎ (sa-oh sha-chi tsu-gee).
//
// Two bars are joined end to end. The male bar carries a long, thin tenon
// (竿, sao) that drops into an open-top mortise in the female bar. Two thin
// keys (車知, shachi) are then dropped in from the top. Each key sits in a
// slanted slot that straddles one wall of the mortise and bites into one
// edge of the tenon, so the tenon can no longer pull back out. Two small
// tongues (目違い, mechigai) on the female bar sit in matching notches on
// the end face of the male bar to stop the joint from twisting.
//
// The y axis runs along the bars:
//
//   y=0        body_len            body_len+tenon_len    body_len+female_len
//   |  male body  |  tenon inside the mortise  |  female only  |
//
// Clearances are controlled by `leeway`. The male bar and the keys are cut
// at nominal size; the mortise, the key slots and the tongues give up
// `leeway` on every mating face.

size = 20;            // cross-section of both bars
body_len = size;      // length of the solid part of the male bar
tenon_len = size*2;   // length of the tenon
female_len = size*3;  // length of the female bar (must exceed tenon_len)
leeway = size*0.025;  // clearance on mating faces (0.5 at size=20)
key_t = size/10;      // key thickness (the previous model used 1 at size=20, i.e. size/20)
key_w = size/5;       // key width

view = "assembled";   // ["assembled", "exploded", "print"]
part = "all";         // ["all", "male", "female", "key"]
explode = tenon_len + size/2; // how far the parts move apart in the exploded view

eps = 0.01;           // overlap so coplanar faces do not fight in preview

// Derived dimensions. Nothing below should need editing.
tenon_w = size/5;
tenon_x = size*2/5;   // x of the tenon's left face
tenon_z = size/3;     // z of the tenon's bottom (= floor of the mortise)
tenon_h = size*2/3;

tongue_w = size/5;
tongue_d = size/10;   // how far the tongues reach into the male bar
tongue_xs = [size/5, size*3/5];

// The key stands proud of the bar so it can be tapped, and so the pull ring
// clears the top face instead of biting into it.
key_stickout = size/5;
key_h = tenon_h + key_stickout;
key_angle = atan(key_t/key_w);        // tilt that puts the key's diagonal along y
slot_pitch = key_w + key_t + leeway*2; // y distance between the two slots

ring_r = size*2/5;    // outer radius of the pull ring on each key
ring_hole_r = size/5;
ring_overlap = size/10; // how far the ring overlaps the key plate

// Centre (x, y) of key slot i, measured from the joint face. Each slot sits
// halfway between a tenon face and the mortise wall next to it, and the two
// slots are staggered along y so the tenon is never bitten on both sides at
// the same spot.
function slot_center(i) = [
    i == 0 ? tenon_x - leeway/2 : tenon_x + tenon_w + leeway/2,
    tenon_len/2 + i*slot_pitch
];

// Slot for key i, from z0 up through the top face. `grow` widens the slot on
// every side; pass leeway when cutting, 0 gives the key's own footprint.
module key_slot(i, z0, grow=0) {
    c = slot_center(i);
    translate([c[0], c[1], z0])
        rotate([0, 0, key_angle])
            translate([-(key_t/2 + grow), -(key_w/2 + grow), 0])
                cube([key_t + 2*grow, key_w + 2*grow, size - z0 + eps]);
}

module male_bar() {
    difference() {
        union() {
            cube([size, body_len, size]);
            translate([tenon_x, body_len - eps, tenon_z])
                cube([tenon_w, tenon_len + eps, tenon_h]);
        }
        // notches for the female bar's tongues
        for (xloc = tongue_xs)
            translate([xloc, body_len - tongue_d, tenon_z])
                cube([tongue_w, tongue_d + eps, tenon_h + eps]);
        translate([0, body_len, 0])
            for (i = [0, 1]) key_slot(i, tenon_z - eps, leeway);
    }
}

module female_bar() {
    translate([0, body_len, 0]) {
        difference() {
            cube([size, female_len, size]);
            // mortise, open at the joint face and at the top
            translate([tenon_x - leeway, -eps, tenon_z])
                cube([tenon_w + 2*leeway, tenon_len + leeway + eps, tenon_h + eps]);
            for (i = [0, 1]) key_slot(i, tenon_z, leeway);
        }
        // tongues that reach into the male bar's notches
        for (xloc = tongue_xs)
            translate([xloc + leeway, -(tongue_d - leeway), tenon_z])
                cube([tongue_w - 2*leeway, tongue_d - leeway + eps, tenon_h]);
    }
}

// One key, standing as it is inserted: plate in the yz plane, bottom at z=0,
// pull ring above the top of the bar. Not yet tilted by key_angle.
module key() {
    translate([-key_t/2, -key_w/2, 0])
        cube([key_t, key_w, key_h]);
    translate([0, 0, key_h + ring_r - ring_overlap])
        rotate([0, 90, 0])
            difference() {
                cylinder(r=ring_r, h=key_t, center=true, $fn=100);
                cylinder(r=ring_hole_r, h=key_t + 2*eps, center=true, $fn=100);
            }
}

module key_in_place(i, lift=0) {
    c = slot_center(i);
    translate([c[0], body_len + c[1], tenon_z + lift])
        rotate([0, 0, key_angle])
            key();
}

// The key lying flat on the bed, plate along +y, ring at the far end.
module key_flat() {
    translate([0, 0, key_t/2])
        rotate([0, 0, 90])
            rotate([0, 90, 0])
                key();
}

function show(name) = part == "all" || part == name;

if (view == "print") {
    if (show("male")) color("Red", 1) male_bar();
    if (show("female")) color("Green", 1) translate([size*1.5, -body_len, 0]) female_bar();
    if (show("key")) color("Blue", 1)
        for (i = [0, 1]) translate([size*(3.5 + i), 0, 0]) key_flat();
} else {
    ex = view == "exploded" ? explode : 0;
    if (show("male")) color("Red", 1) translate([0, -ex, 0]) male_bar();
    if (show("female")) color("Green", 1) female_bar();
    if (show("key")) color("Blue", 1)
        for (i = [0, 1]) key_in_place(i, lift=ex/2);
}
