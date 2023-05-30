// 蟻ほぞ差し仕口 / 蟻二枚枘差し仕口
//


size=15;
// size dictates the overall dimensions. By default the combined structure
// will have a shape that resembles the following (when viewed from the z axis):
//
//      _
//     |_|
//  _ _|_|_ _
// |_|_|_|_|_|
// 
// where each cube has the dimensions [size, size, size]

leeway=size*0.02;

function x_leeway(leeway) = [leeway, 0, 0];
function y_leeway(leeway) = [0, leeway, 0];
function z_leeway(leeway) = [0, 0, leeway];
function xy_leeway(leeway) = x_leeway(leeway) + y_leeway(leeway);
function xz_leeway(leeway) = x_leeway(leeway) + z_leeway(leeway);
function yz_leeway(leeway) = y_leeway(leeway) + z_leeway(leeway);
function xyz_leeway(leeway) = x_leeway(leeway) + y_leeway(leeway) + z_leeway(leeway);

cube_faces=[
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3] // left
];
    
module top_ari(leeway=size*0.02) {
    width=size; // width of the bar
    height=size; // height of the ari
    ari_depth=size/3;
    ari_top_width=11; // width of the base of ari, on the top size
    ari_top_slant=7; // angle from base of ari, on the top side
    ari_bottom_vertical_slant=10; // vertical angle from bottom of side ari
    ari_bottom_horizontal_slant=0; // horizontal angle
    
    // pre-calculate some re-used stuff for ease of use

    // amount that is shifted horizontally from the baseline
    // when given the slant angle in the bottom side
    ari_bottom_horizontal_delta=tan(ari_bottom_horizontal_slant)*height;
    
    // amount that is shifted vertically from the baseline
    // when given the slant angle in the bottom side
    ari_bottom_vertical_delta=tan(ari_bottom_vertical_slant)*height;
    
    
    ari_top_horizontal_delta=tan(ari_top_slant)*height;
    ari_top_baseline=(width-ari_top_width)/2;
    

    

    polyhedron(
        points=[
            [0, 0, 0]+yz_leeway(leeway),
            [height, ari_bottom_horizontal_delta, ari_bottom_vertical_delta]+yz_leeway(leeway),
            [height, width-ari_bottom_horizontal_delta, ari_bottom_vertical_delta]-y_leeway(leeway) + z_leeway(leeway),
            [0, width, 0]-y_leeway(leeway)+xz_leeway(leeway),
            
            [0, ari_top_baseline+ari_top_horizontal_delta, ari_depth] + y_leeway(leeway),
            [height, ari_top_baseline, ari_depth]+y_leeway(leeway),
            [height, width-ari_top_baseline, ari_depth]-y_leeway(leeway),
            [0, width-(ari_top_baseline+ari_top_horizontal_delta), ari_depth]-y_leeway(leeway)
        ],
        faces=cube_faces
    );
}

module bottom_ari(leeway=size*0.02) {
    height=size;
    ari_depth=size/5;
    vertical_slant=10;
    
    ari_vertical_delta=tan(vertical_slant)*height;
    polyhedron(
        points=[
            [0, 0, 0]+yz_leeway(leeway),
            [size, 0, ari_vertical_delta]+yz_leeway(leeway),
            [size, size,ari_vertical_delta]-y_leeway(leeway)+z_leeway(leeway),
            [0, size, 0]-y_leeway(leeway)+z_leeway(leeway),
            [0, 0, ari_depth]+y_leeway(leeway)-z_leeway(leeway),
            [size, 0, ari_depth+ari_vertical_delta]+y_leeway(leeway)-z_leeway(leeway),
            [size, size, ari_depth+ari_vertical_delta]-yz_leeway(leeway),
            [0, size, ari_depth]-y_leeway(leeway)-z_leeway(leeway),
        ],
        faces=cube_faces
    );
}

module male() {
    cube([size*2, size, size]);
    translate([size*2, 0, 0]) {
        translate([0, 0, size*2/3]) top_ari();
        translate([0, 0, size/3]) bottom_ari();
    }
}

module female() {
    render()
        difference() {
            cube([size, size*5, size]);
            translate([0, size*2, size*2/3]) top_ari(leeway=0);
            translate([0, size*2, size/3]) bottom_ari(leeway=0);
        }
   
}

color("Red", 1) translate([0, size*2, 0]) male();
color("Green", 1) translate([size*2, 0, 0]) female();