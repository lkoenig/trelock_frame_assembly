$fn=50;

HAUTEUR = 46;
LONGUEUR = HAUTEUR;
HYPOTHENUSE = sqrt(HAUTEUR*HAUTEUR + LONGUEUR*LONGUEUR);

BRANCHE_EPAISSEUR = 6.5;
BRANCHE_HAUTEUR = 13;
BRANCHE_PETIT_TROU = 5;
BRANCHE_GRAND_TROU = 9;
BRANCHE_SEPARATION = 8;

TETE_HAUTEUR = 13;
TETE_LARGEUR = 40;
TETE_LONGUEUR = 8;
TETE_TUBE = 10;
TETE_ERGOT_TROU = 3;
TETE_ERGOT_SEPARATION = 12;
TETE_ERGOT_GRAND_DIAMETRE = (24-TETE_ERGOT_SEPARATION)/2;
TETE_ERGOT_DEPASSEMENT = 4;

module branche(ecrou)
{
    difference()
    {
        union()
        {
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
              BRANCHE_EPAISSEUR/2-1, BRANCHE_HAUTEUR/2])
          rotate([90, 0, 0])
          cylinder(h=BRANCHE_EPAISSEUR/2, d=BRANCHE_GRAND_TROU, $fn=6);
        } else {
          // grand trou rond
          translate([BRANCHE_GRAND_TROU/2+BRANCHE_PETIT_TROU/2,
            BRANCHE_EPAISSEUR/2-1, BRANCHE_HAUTEUR/2])
          rotate([90, 0, 0])
          cylinder(h=BRANCHE_EPAISSEUR/2, d=BRANCHE_GRAND_TROU);
        }
        
        // petit trou
        translate([BRANCHE_GRAND_TROU/2+BRANCHE_PETIT_TROU/2,
            BRANCHE_EPAISSEUR+1, BRANCHE_HAUTEUR/2])
        rotate([90, 0, 0])
        cylinder(h=BRANCHE_EPAISSEUR+2, d=BRANCHE_PETIT_TROU);
    }
}

module ergot()
{
    difference()
    {
        cylinder(d=TETE_ERGOT_GRAND_DIAMETRE, h=TETE_ERGOT_DEPASSEMENT);
        translate([0, 0, -1])
        cylinder(d=TETE_ERGOT_TROU, h=TETE_ERGOT_DEPASSEMENT+2);
    }
}

module ergots()
{
    translate([HYPOTHENUSE, 0, 0])
    rotate([0, -45, 0])
    union()
    {
        // ERGOTS
        translate([TETE_LONGUEUR,
            TETE_LARGEUR/2-TETE_ERGOT_SEPARATION/2
            -TETE_ERGOT_GRAND_DIAMETRE/2,
            TETE_HAUTEUR/2])
        rotate([0, 90, 0])
        ergot();

        translate([TETE_LONGUEUR,
            TETE_LARGEUR/2+TETE_ERGOT_SEPARATION/2
            +TETE_ERGOT_GRAND_DIAMETRE/2,
            TETE_HAUTEUR/2])
        rotate([0, 90, 0])
        ergot();
    }
}

module tete()
{
    translate([HYPOTHENUSE, 0, 0])
    rotate([0, -45, 0])
        cube([TETE_LONGUEUR, TETE_LARGEUR, TETE_HAUTEUR]);
}

module joint()
{
    translate([HYPOTHENUSE/2,
        TETE_LARGEUR/2-BRANCHE_SEPARATION/2-1, 0])
    cube([HYPOTHENUSE/2, BRANCHE_SEPARATION+2, BRANCHE_HAUTEUR]);
}

difference()
{
    union()
    {
        translate([0, TETE_LARGEUR/2+BRANCHE_SEPARATION/2, 0])
            branche(ecrou=true);
        translate([0,
            TETE_LARGEUR/2-BRANCHE_EPAISSEUR-BRANCHE_SEPARATION/2, 0])
            branche(ecrou=false);
        
        joint();

        tete();
    }
    translate([HYPOTHENUSE, 0, 0])
    rotate([0, -45, 0])
    translate([TETE_LONGUEUR, 0, 0])
    cube([TETE_LONGUEUR, TETE_LARGEUR, TETE_HAUTEUR]);

    // TUBE
    translate([HYPOTHENUSE, 0, 0])
        rotate([0, -45, 0])
        translate([-TETE_LONGUEUR, TETE_LARGEUR/2, 0])
        rotate([0, 90, 0])
        cylinder(d=TETE_TUBE, h=TETE_LONGUEUR*3);
}

ergots();
