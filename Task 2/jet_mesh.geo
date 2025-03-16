// Axisymmetric jet geometry
SetFactory("OpenCASCADE");

// Define nozzle dimensions
nozzle_radius = 0.0005;  // Radius of the jet nozzle (0.5 mm)
domain_length = 0.14;    // Length of the domain (140 mm)
domain_height = 0.055;   // Height of the domain (55 mm)

// Create nozzle
Point(1) = {0, 0, 0, 1.0};
Point(2) = {0, nozzle_radius, 0, 1.0};
Line(1) = {1, 2};

// Create domain
Point(3) = {domain_length, 0, 0, 1.0};
Point(4) = {domain_length, domain_height, 0, 1.0};
Line(2) = {2, 4};
Line(3) = {1, 3};
Line(4) = {3, 4};

// Define surfaces
Curve Loop(1) = {1, 2, -4, -3};
Plane Surface(1) = {1};

// Define Physical Groups for boundaries
Physical Curve("inlet", 1) = {1};  // Inlet boundary
Physical Curve("outlet", 2) = {2}; // Outlet boundary
Physical Curve("wall", 3) = {3, 4}; // Wall boundaries
Physical Surface("fluid", 4) = {1}; // Fluid domain

// Mesh refinement near the nozzle
Field[1] = Distance;
Field[1].EdgesList = {1};
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = 0.0001; // Minimum element size near the nozzle
Field[2].LcMax = 0.001;  // Maximum element size
Field[2].DistMin = 0.0;
Field[2].DistMax = 0.01;
Background Field = 2;

// Generate 2D mesh
Mesh.Algorithm = 6;  // Frontal-Delaunay for quads
Mesh 2;
Save "jet_mesh.msh";