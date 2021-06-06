$fn = 500;

HAUTEUR = 46;
LONGUEUR = HAUTEUR;
HYPOTHENUSE = sqrt(HAUTEUR*HAUTEUR + LONGUEUR*LONGUEUR);

BRANCHE_EPAISSEUR = 6.5;
BRANCHE_HAUTEUR = 15;
BRANCHE_PETIT_TROU = 5;
BRANCHE_GRAND_TROU = 9;
BRANCHE_SEPARATION = 8;

BOULON_EPAISSEUR = 4;

TETE_EPAISSEUR = 7;
TETE_ANGLE = 45; 
TETE_HAUTEUR = 13;
TETE_LARGEUR = 40;
TETE_LONGUEUR = 8;
TETE_TUBE = 10;
TETE_ERGOT_TROU = 3;
TETE_ERGOT_SEPARATION = 12;
TETE_ERGOT_GRAND_DIAMETRE = (24-TETE_ERGOT_SEPARATION)/2;
TETE_ERGOT_DEPASSEMENT = 4;
  
module branch_side(ecrou)
{
  difference() {
    union() {
      // partie principale
      translate([BRANCHE_HAUTEUR/2, 0, 0])
	cube([HYPOTHENUSE-BRANCHE_HAUTEUR/2, BRANCHE_EPAISSEUR, BRANCHE_HAUTEUR]);
          
      // arrondi de fin
      translate([BRANCHE_HAUTEUR/2,
		 BRANCHE_EPAISSEUR, BRANCHE_HAUTEUR/2])
	rotate([90, 0, 0])
	cylinder(d=BRANCHE_HAUTEUR, h=BRANCHE_EPAISSEUR);
    }
      
    // trous
    if(ecrou) {
      // grand trou hexagonal
      translate([BRANCHE_GRAND_TROU/2+BRANCHE_PETIT_TROU/2,
		 BRANCHE_EPAISSEUR + 1, BRANCHE_HAUTEUR/2])
	rotate([90, 0, 0])
	cylinder(h=BOULON_EPAISSEUR + 1, d=BRANCHE_GRAND_TROU, $fn=6);
    } else {
      // grand trou rond
      translate([
	BRANCHE_GRAND_TROU / 2 + BRANCHE_PETIT_TROU / 2,
	  BRANCHE_EPAISSEUR / 2 + 1 ,
	  BRANCHE_HAUTEUR / 2])
	rotate([90, 0, 0])
	cylinder(h=BOULON_EPAISSEUR + 1, d=BRANCHE_GRAND_TROU);
    }
          
    // petit trou
    translate([BRANCHE_GRAND_TROU/2+BRANCHE_PETIT_TROU/2,
	       BRANCHE_EPAISSEUR+1, BRANCHE_HAUTEUR/2])
      rotate([90, 0, 0])
      cylinder(h=BRANCHE_EPAISSEUR+2, d=BRANCHE_PETIT_TROU);
  }
}

module branch() {
  difference() {
    union() {
      translate([0, BRANCHE_SEPARATION/2, 0])
	branch_side(ecrou=true);
    
      translate([0,
		 -BRANCHE_EPAISSEUR-BRANCHE_SEPARATION/2, 0])
	branch_side(ecrou=false);
          
      translate([HYPOTHENUSE/2,
		 -BRANCHE_SEPARATION/2-1, 0])
	cube([HYPOTHENUSE/2, BRANCHE_SEPARATION+2, BRANCHE_HAUTEUR]);
    }

    translate([0, -BRANCHE_EPAISSEUR-BRANCHE_SEPARATION/2 - 1, -17])
      rotate([0,-9, 0])
      cube([HYPOTHENUSE * 2, 2*BRANCHE_EPAISSEUR + BRANCHE_SEPARATION + 2,BRANCHE_HAUTEUR+2]);
}
}
  
module ergot()
{
  difference() {
    cylinder(d=TETE_ERGOT_GRAND_DIAMETRE, h=TETE_ERGOT_DEPASSEMENT);
    translate([0, 0, -1])
      cylinder(d=TETE_ERGOT_TROU, h=TETE_ERGOT_DEPASSEMENT+2);
  }
}
  
module tete() {
  ERGOT_X = 9;
  ERGOT_Y = 0;
  translate([0, 0, TETE_EPAISSEUR])
    union() {

    translate([0,7.6,-TETE_EPAISSEUR])
      linear_extrude(height=TETE_EPAISSEUR, center=false)
      import("embout.dxf");

    translate([ERGOT_X, ERGOT_Y, 0])
      ergot();
    
    translate([-ERGOT_X, ERGOT_Y, 0])
      ergot();
  }
} 
    
union() {
  branch();
  translate([
	     HYPOTHENUSE - TETE_EPAISSEUR / 2 * sin(TETE_ANGLE),
	     0,
	     BRANCHE_HAUTEUR - TETE_HAUTEUR/4
	     ])
    rotate([90 - TETE_ANGLE,0,90])
    tete();
}
