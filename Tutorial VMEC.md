Tutorial: VMEC Walkthrough
==========================

This tutorial will walk the user through running VMEC in fixed boundary,
running MAKEGRID, running VMEC in free boundary, and utilizing the
various other codes based upon a VMEC equilibria. The tutorial is
centered around an NCSX-like machine. This device is a
quasi-axisymmetric stellarator with a field periodicity of
three.[toc](toc)

------------------------------------------------------------------------

VMEC: FIXED BOUNDARY
--------------------

First let\'s run VMEC in fixed boundary mode. In fixed boundary, the
user must specify the Fourier coefficients on the boundary and the
toroidal (n) Fouier coefficients which specify the initial guess for the
magnetic axis. The code then begins to solve the interior problem of
minimizing the MHD functional under the assumption of good nested flux
surfaces. Our fixed boundary input file (<file:input.ncsx_fixed>)
contains a FORTRAN name list which looks like:
[code format=\"fortran\"](code format="fortran") &INDATA LFREEB = F DELT
= 9.00E-01 NFP = 3 NCURR = 1 MPOL = 11 NTOR = 6 NS\_ARRAY = 9 28 49
NITER = 2500 NSTEP = 200 GAMMA = 0.000000E+00 FTOL\_ARRAY = 1.000000E-06
1.000000E-08 1.000000E-11 PHIEDGE = 4.97070205837336E-01 CURTOR =
-1.78606250000000E+05 AM = 6.85517649352426E+04 -5.12027745123057E+03
-3.61510451745464E+04 -4.74263014113066E+05 1.78878195473870E+06
-3.21513828868170E+06 2.69041023837233E+06 -8.17049854168367E+05
0.00000000000000E+00 0.00000000000000E+00 0.00000000000000E+00 AI =
0.00000000000000E+00 0.00000000000000E+00 0.00000000000000E+00
0.00000000000000E+00 0.00000000000000E+00 0.00000000000000E+00
0.00000000000000E+00 0.00000000000000E+00 0.00000000000000E+00
0.00000000000000E+00 0.00000000000000E+00 AC = 8.18395699999999E+03
1.43603560000000E+06 -1.07407140000000E+07 7.44389200000000E+07
-3.22215650000000E+08 8.81050800000000E+08 -1.49389660000000E+09
1.52746800000000E+09 -8.67901590000000E+08 2.10351200000000E+08
0.00000000000000E+00 RAXIS = 1.49569454253276E+00 1.05806400912320E-01
7.21255454715878E-03 -3.87402652289249E-04 -2.02425864534069E-04
-1.62602353744308E-04 -8.89569831063077E-06 ZAXIS = 0.00000000000000E+00
-5.19492027001782E-02 -3.18814224021375E-03 2.26199929262002E-04
1.28803681387330E-04 1.11266150452637E-06 1.13732703961869E-05 RBC(0,0)
= 1.40941668895656E+00 ZBS(0,0) = 0.00000000000000E+00 RBC(1,0) =
2.79226697269945E-02 ZBS(1,0) = -1.92433268059631E-02 RBC(2,0) =
-1.54739398509667E-03 ZBS(2,0) = 1.11459511078088E-02 RBC(3,0) =
2.90733840104882E-03 ZBS(3,0) = -3.97869471888770E-03 RBC(4,0) =
-8.91322016448873E-04 ZBS(4,0) = 1.34394804673514E-03 RBC(5,0) =
-7.81997770407839E-05 ZBS(5,0) = -1.57143910159387E-04 RBC(6,0) =
1.06129711928351E-04 ZBS(6,0) = 9.58024291307491E-05 . . . /
[code](code) The INDATA name list is read by VMEC and controls it\'s
execution. This file has been truncated to show the relevant
information. The table below explains each parameter: \|\| Parameter
\|\| Value \|\| Description \|\| \|\| LFREEB \|\| F \|\| Determines if
the code should be run in free or fixed boundary mode. \|\| \|\| DELT
\|\| 0.9 \|\| Solver stepsize. \|\| \|\| NFP \|\| 3 \|\| Number of field
periods. \|\| \|\| NCURR \|\| 1 \|\| Determines if the net toroidal
current (1) or rotational transform (0) should be used. \|\| \|\| MPOL
\|\| 11 \|\| Number of poloidal modes. \|\| \|\| NTOR \|\| 6 \|\| Number
of toroidal modes. \|\| \|\| NS\_ARRAY \|\| 9,28,49 \|\| Number of
surfaces at each adaptive grid refinement. \|\| \|\| NITER \|\| 2500
\|\| Maximum number of iterations per grid. \|\| \|\| NSTEP \|\| 200
\|\| Iterations between outputs to the screen. \|\| \|\| GAMMA \|\| 0.0
\|\| Adiabatic index. Setting to zero indicates that the AM array is
defining pressure in Pascals. \|\| \|\| FTOL\_ARRAY \|\| 1E-6,1E-8,1E-11
\|\| Convergence criterion for each adaptive grid refinement. \|\| \|\|
PHIEDGE \|\| 0.497 \|\| Total enclosed toroidal flux in Webers. \|\|
\|\| CURTOR \|\| -1.78 \|\| Net toroidal current in Amperes. \|\| \|\|
AM \|\| 11 values \|\| Pressure profile specification. Here each value
is a coefficient in a power series over the flux surfaces (s). \|\| \|\|
AI \|\| 11 values \|\| Rotational transform specification. Here each
value is a coefficient in a power series over the flux surfaces (s).
\|\| \|\| AC \|\| 11 values \|\| Toroidal current profile specification.
Here each value is a coefficient in a power series over the flux
surfaces(s). \|\| \|\| RAXIS \|\| 7 values \|\| Fourier harmonics
specifying the radial position of the magnetic axis guess. \|\| \|\|
ZAXIS \|\| 7 values \|\| Fourier harmonics specifying the vertical
position of the magnetic axis guess. \|\| \|\| RBC \|\| Many values \|\|
Fourier harmonics specifying the radial position of the plasma boundary.
\|\| \|\| ZBS \|\| Many values \|\| Fourier harmonics specifying the
vertical position of the plasma boundary. \|\| To run VMEC with this
file we simply pass it\'s suffix to vmec on the command line like so:
[code format=\"bash\"](code format="bash") \> /bin/xvmec2000 ncsx\_fixed
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - SEQ =
1 TIME SLICE 0.0000E+00 PROCESSING INPUT.ncsx\_fixed THIS IS VMEC2000, A
3D EQUILIBRIUM CODE, VERSION 6.90 Lambda: Full Radial Mesh. L-Force:
hybrid full/half. Forces Are Conservative

COMPUTER: LINUX SYSTEM. DATE = Apr 26,2011 TIME = 08:49:29

NS = 9 NO. FOURIER MODES = 137 FTOLV = 1.000E-06

ITER FSQR FSQZ FSQL fsqr fsqz RAX(v=0) WMHD

1 6.12E+01 9.26E+00 1.65E-01 4.49E-04 8.46E-04 1.608E+00 3.7788E+00 200
5.33E-02 4.02E-02 2.55E-04 3.76E-06 9.47E-06 1.610E+00 3.5203E+00 313
8.36E-07 4.52E-07 3.62E-07 2.42E-10 4.41E-10 1.610E+00 3.5200E+00

NS = 28 NO. FOURIER MODES = 137 FTOLV = 1.000E-08

ITER FSQR FSQZ FSQL fsqr fsqz RAX(v=0) WMHD

1 1.28E-01 3.58E-02 4.20E-04 7.65E-08 8.83E-08 1.610E+00 3.5200E+00 200
6.34E-06 4.24E-06 1.93E-07 6.03E-10 1.12E-09 1.611E+00 3.5196E+00 400
2.56E-08 8.68E-09 5.75E-09 3.50E-12 2.66E-12 1.610E+00 3.5196E+00 495
9.89E-09 2.37E-09 1.38E-09 9.76E-13 1.06E-12 1.609E+00 3.5196E+00

NS = 49 NO. FOURIER MODES = 137 FTOLV = 1.000E-11

ITER FSQR FSQZ FSQL fsqr fsqz RAX(v=0) WMHD

1 1.62E-02 9.53E-03 2.90E-06 5.44E-10 1.04E-09 1.609E+00 3.5196E+00 200
2.77E-07 1.45E-07 1.70E-09 1.12E-12 1.28E-12 1.609E+00 3.5195E+00 400
1.48E-08 6.47E-09 3.76E-10 1.48E-13 1.36E-13 1.608E+00 3.5195E+00 600
2.19E-09 7.85E-10 9.10E-11 2.76E-14 2.43E-14 1.608E+00 3.5195E+00 800
5.36E-10 1.47E-10 1.91E-11 4.18E-15 4.77E-15 1.608E+00 3.5195E+00 1000
2.14E-10 4.94E-11 5.34E-12 9.62E-16 9.66E-16 1.608E+00 3.5195E+00 1200
8.15E-11 1.79E-11 1.17E-12 1.44E-16 1.46E-16 1.608E+00 3.5195E+00 1400
2.68E-11 5.34E-12 2.25E-13 2.09E-17 1.72E-17 1.608E+00 3.5195E+00 1557
9.98E-12 2.04E-12 7.08E-14 6.70E-18 3.72E-18 1.608E+00 3.5195E+00

NUMBER OF JACOBIAN RESETS = 2

TOTAL COMPUTATIONAL TIME : 140.26 SECONDS TIME TO READ IN DATA: 0.01
SECONDS TIME TO WRITE DATA TO WOUT: 0.32 SECONDS TIME IN EQFORCE 5.00
SECONDS TIME (REMAINDER) IN FUNCT3D: 134.47 SECONDS EXECUTION TERMINATED
NORMALLY FILE : ncsx\_fixed [code](code) This produces four files wout,
jxbout, mercier, and threed1. The wout file is the VMEC data file
containing the converged equilibria. The jxbout file contains various
quantities relating to the currents, magnetic field, and force balance
on each surface. The mercier file contains a table of various stability
related parameters. The threed1 file is a text file containing
information regarding the execution of the code and the final state of
the code. Please note that in the latest versions of VMEC the wout and
jxbout files are [netCDF](https://www.unidata.ucar.edu/software/netcdf/)
files.

------------------------------------------------------------------------

MAKEGRID: Generating the mgrid file
-----------------------------------

In order to run VMEC in free boundary mode, the vacuum magnetic field
must be specified on a series of toroidal cut planes for one field
period of a device. The MAKEGRID routine reads a coil definition file
and calculates the field due to a unit current on a series of cut
planes. In order to calculate the field due to a coil, the code performs
a Biot-Savart calculation over a series of line segments representing
the coil. For our purposes here, we will use a modified NCSX-like coil
(). The coil file has a form: [code](code) periods 3 begin filament
mirror NIL 2.37349213525007E+00 5.08707161031493E-01
0.00000000000000E+00 6.52271941985300E+05 2.37704663022902E+00
5.03698827972622E-01 -1.71575001036786E-02 6.52271941985300E+05
2.38064289313714E+00 4.97900976817829E-01 -3.40560223451057E-02
6.52271941985300E+05 2.38424000556975E+00 4.91393514121422E-01
-5.06942718548110E-02 6.52271941985300E+05 2.38779889031241E+00
4.84253387220152E-01 -6.70795899666555E-02 6.52271941985300E+05
2.39128424757806E+00 4.76549775938554E-01 -8.32238770997344E-02
6.52271941985300E+05 2.39467097784607E+00 4.68333577488981E-01
-9.91348590512156E-02 6.52271941985300E+05 . . . 2.37349213525007E+00
5.08707161031493E-01 0.00000000000000E+00 0.00000000000000E+00 1 ModA .
. . end

[code](code) The coils file consists of a header specifying the
periodicity of the system, the file type (in this case filament), and
the mirror symmetry of the system. The coils are then specified by a
series of data points (x,y,z,current). Each point connects to the next
in the system. The last element of each coil has zero current and a
current group specifier along with a name for a current group. This
groups the coils by power supply (current). Running the code in
interactive mode we find: [code format=\"bash\"](code format="bash") \>
/bin/makegrid Enter extension of \"coils\" file : c09r00 Scale (S)
bfield to unit current/turn OR use raw (R) currents from coils file: S
Assume stellarator symmetry (Y/N)? : Y Enter rmin (min radial grid
dimension) : 0.5 Enter rmax (max radial grid dimension) : 2.5 Enter zmin
(min vertical grid dimension): -1.0 Enter zmax (max vertical grid
dimension): 1.0 Enter number of toroidal planes/period : 24 Enter number
of r (radial) mesh points : 201 Enter number of z mesh points : 201
Stellarator symmetry IS assumed rmin = 0.5 rmax = 2.5 zmin = -1. zmax =
1. kp = 24 ir = 201 jz = 201

Input file: coils.c09r00 Mgrid file: mgrid\_c09r00 Extcur file:
extcur.c09r00

COIL GROUP : ModA TOTAL COILS IN GROUP: 6 TOTAL FILAMENTS: 2400 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : ModB TOTAL COILS IN GROUP: 6 TOTAL FILAMENTS: 2400 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : ModC TOTAL COILS IN GROUP: 6 TOTAL FILAMENTS: 2400 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : PF1 TOTAL COILS IN GROUP: 8 TOTAL FILAMENTS: 1536 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : PF2 TOTAL COILS IN GROUP: 8 TOTAL FILAMENTS: 1536 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : PF3 TOTAL COILS IN GROUP: 8 TOTAL FILAMENTS: 1536 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : PF4 TOTAL COILS IN GROUP: 12 TOTAL FILAMENTS: 2304 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : PF5 TOTAL COILS IN GROUP: 4 TOTAL FILAMENTS: 1536 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

COIL GROUP : PF6 TOTAL COILS IN GROUP: 2 TOTAL FILAMENTS: 768 K = 1 (OUT
OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K = 11 K =
12 K = 13

COIL GROUP : TF TOTAL COILS IN GROUP: 18 TOTAL FILAMENTS: 2196 K = 1
(OUT OF 24) K = 2 K = 3 K = 4 K = 5 K = 6 K = 7 K = 8 K = 9 K = 10 K =
11 K = 12 K = 13

TIME IN PARSER = 0.318 SECONDS TIME IN BFIELD = 392.994 SECONDS

THE BFIELDS HAVE BEEN STORED IN THE MGRID FILE IN SCALED MODE. THE
EXTERNAL CURRENTS CORRESPONDING TO THOSE IN THE COILS-DOT FILE ARE GIVEN
IN THE EXTCUR ARRAY IN THE FILE extcur.c09r00 [code](code) This creates
an mgrid file which VMEC will read to determine the vacuum field in free
boundary mode.

------------------------------------------------------------------------

\<span style=\"font-size: 17px; line-height: 25px;\"\>**VMEC: Free
Boundary Mode**\</span\>

------------------------------------------------------------------------

BOOZ\_XFORM: The Boozer Transformation
--------------------------------------

------------------------------------------------------------------------

BOOTSJ: Bootstrap Current Calculation
-------------------------------------

------------------------------------------------------------------------

DIAGNO: Magnetic Diagnostic Calculation
---------------------------------------

------------------------------------------------------------------------