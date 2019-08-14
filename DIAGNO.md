DIAGNO
======

The DIAGNO code simulates magnetic diagnostic measurements for a given
run of [VMEC](VMEC), PIES or SPEC codes
([S A Lazerson //et al// 2013 //Plasma Phys. Control. Fusion// \*\*55\*\* 025014](http://dx.doi.org/10.1088/0741-3335/55/2/025014)).
It is useful for making comparisons between a given calculated
equilibrium and experimental measurements of the magnetic field. DIAGNO
is an essential part of the STELLOPT magnetic reconstruction capability.

------------------------------------------------------------------------

### Theory

The DIAGNO code simulates various magnetic measurements given a
simulated equilibrium. The field at a point in space, a fixed
orientation magnetic probe, flux loops, and Rogowski coils can be
simulated by the DIAGNO code. The code has been interfaced to
equilibrium from the VMEC and PIES codes. The code can simulate the
vacuum, plasma, or total diagnostic responses.

The plasma magnetic fields (magnetic induction and vector potential) are
calculated utilizing one of two methods. The first method allows the
code to preform a volume integral over the plasma currents. The second
method utilizes the virtual casing principle to calculate a
representative surface current on the equilibrium boundary
([S A Lazerson 2012 //Plasma Phys. Control. Fusion// \*\*54\*\* 122002](http://dx.doi.org/10.1088/0741-3335/54/12/122002)).
Both methods construct spline representations of the integrated
quantities and then use adaptive integration techniques to achieve a
desired relative and absolute tolerance in the field evaluated at a
point in space. An accurate calculation of the fields utilizing a
virtual casing principle requires that only the plasma field be used to
construct the surface current. At this time, this limits the virtual
casing principle to free boundary equilibria.

The calculation of the magnetic field due to the coils utilizes a
compact expression for the Biot-Savart fields of a filament
([Hanson, J. D. & Hirshman S. P., //Compact expressions for the Biot-Savart fields of a filamentary segment// Phys. of Plas. \*\*9\*\*, 4410-4412 (2002).](http://link.aip.org/link/PHPAEN/v9/i10/p4410/s1))
. Here the vector potential can be represented by

[math](math) \\vec{A}\\left(\\vec{x}\\right) = \\frac{\\mu\_0
I}{4\\pi}\\hat{e}\\ln\\left\[\\frac{R\_i+R\_f+L}{R\_i+R+f-L}\\right\]
[math](math) where the figure on the right indicates the geometry. The
value L is taken as the difference between Ri and Rf dotted with the
vector along the current element. The magnetic field may then be
specified as [math](math) \\vec{B}\\left(\\vec{x}\\right)=\\frac{\\mu\_0
I}{4\\pi}\\vec{R}\_i\\times\\vec{R}\_f\\frac{R\_i+R\_f}{R\_iR\_f\\left(R\_iR\_f+\\vec{R}\_i\\cdot\\vec{R}\_f\\right)}
[math](math) where similar definitions apply as those for the vector
potential.

Simulation of the diagnostic response of the flux loops and Rogowski
coil require integration along the diagnostic. Line integrals are
preformed along the flux loop (vector potential) and along the Rogowski
coil. The integration methods available include midpoint, Bode, and
[Simpson\'s methods](@http://en.wikipedia.org/wiki/Simpson%27s_rule).
The flux loops may be multiplied by a turn factor or have the edge
toroidal flux subtracted from them. The Rogowski coil is multiplied by
an effective area constant.

------------------------------------------------------------------------

### Compilation

DIAGNO is a component of the STELLOPT suite of codes. Compilation of the
STELLOPT suite is discussed on the
[STELLOPT Compilation Page](STELLOPT Compilation).

------------------------------------------------------------------------

### Input Data Format

The DIAGNO code is controlled in part by command line options and an
additional fortran input namelist \'DIAGNO\_IN\' in the equilibrium
input file. If the total or vacuum response is desired then a MAKEGRID
style coils file must also be supplied. The input namelist has the
following format:

    &DIAGNO_IN
       NU = 360                             ! Number of poloidal spline knots
       NV = 360                             ! Number of toroidal spline knots (per period)
       LVC_FIELD = .true.                   ! Set to use virtual casing
       VC_ADAPT_TOL = 1.0E-4                ! Absolute tolerance of integration over plasma
       VC_ADAPT_REL = 1.0E-2                ! Relative tolerance of integration over plasma
       UNITS = 1.0                          ! Unit scaling factor (assume [m])
       BFIELD_POINTS_FILE = 'btest.diagno'  ! Path to B-Field test points file
       BPROBES_FILE = 'bprobe.diagno'       ! Path to B Probe definition file
       SEG_ROG_FILE = 'segrob.diagno'       ! Path to Rogowski definition file
       FLUX_DIAG_FILE = 'fluxloop.diagno'   ! Path to fluxloop definition file
       FLUX_TURNS     = 1.0 1.0 1.0 1.0     ! Array of fluxloop multipliers
       INT_TYPE = 'simpson'                 ! Integration method
       INT_STEP = 2                         ! Integration substep
       LRPHIZ   = .false.                   ! Use cylindrical coordinates (default: cartesian)
    /

The call to the DIAGNO code requires the user pass an equilibrium input
file at all times. The following options are available:

    Usage: xdiagno <options>
         <options>
          -vmec ext:    VMEC input/wout extension
          -pies ext:    PIES input extension
          -coil file:   Coils File
          -vac:         Vacuum Field Only
          -noverb:      Supress all screen output
          -help:        Output help message

A note should be made that when calculating the vacuum response the VMEC
\'INDATA\' namelist must be supplied in the input file but need only
contain the EXTCUR array the user wishes to energize the vacuum coil
with. It should also be noted that if the virtual casing is utilized
with VMEC, the MAKEGRID mgrid file used for the calculation will be used
to subtract off the vacuum field at the plasma boundary. In PIES this is
handled differently.

![](image/probe_example.jpg)

There are four types of magnetic diagnostics which DIAGNO can calculate:

1.  B-Field Test Points (\'BFIELD\_POINTS\_FILE\')
2.  Magnetic Field Probes (\'BPROBES\_FILE\')
3.  Segmented Rogowski Coils (\'SEG\_ROG\_FILE\')
4.  Flux Loops (\'FLUX\_DIAG\_FILE\') The format for each of these files
    is indicated below. Please note that all values are positions are
    measured in \[mm\] for this example and all angles in degrees.
    DIAGNO prefers values be entered in \[m\] in general.

#### Coils File

The DIAGNO code utilizes the MAKEGRID style of coils file. The EXTCUR
array present in the INDATA namelist is utilized to energize the coils
for the vacuum response.

#### B-Field Test Points File

Of the five diagnostic types the B-Field Test Points are the simplest.
If this file is specified in the \'DIAGNO\_IN\' namelist, the values of
the magnetic field at specific points in space are calculated and
displayed on the screen. The format of this file is very simple. The
first line specifies the number of points in the file and the next lines
specify the x,y, and z coordinates of each point. Here is an example for
5 points

    5
    1000.0  0.0  0.0
    0.0  1000.0  0.0
    -1000.0  0.0  0.0
    0.0  -1000.0  0.0
    0.0  0.0  1000.0

This file has five points, the last point lying on the z coordinate axis
at z=1.0. No output file is created as a result of specifying this file.

#### Magnetic Field Probes

The Magnetic Field Probes diagnostic is used to simulate measurements of
the magnetic field at a point in space (often referred to as \'B-dot
probes\'). If this file is specified in the \'DIAGNO.CONTROL\' file then
magnetic measurements are simulated (where the measuring probe effective
area, and orientation are taken into account). The format is similar to
that of the B-Field Test Points file with more orientation information
specified. The first line of the file indicates the number of probes in
the file. Then for each line the x,y,z coordinate information is
specified, along with the poloidal and toroidal orientation (spherical
coordinates), and finally the effective area. Here is an example for
five probes

    5
    3500.0  0.0  0.0  0.0  0.0  0.25
    3000.0  0.0  500.0  90.0  0.0  0.25
    2500.0  0.0  0.0  180.0  0.0  0.25
    3000.0  0.0  -500.0  270.0  0.0  0.25
    0000.0  3500.0  0.0  0.0  90.0  0.25

The first 4 points of this file are located on a circle of radius 0.5
centered at 3.0 in the X-Z plane. They all point in the direction
perpendicular to the circle. The last point is located at y=3.5 and is
pointed in the Y direction. All probes have an effective area of 0.25.
Simulated values for the points are stored in the file \'diagno\_bth.\'
file.

#### Flux Loops

The flux loop diagnostic allows the simulation of various types of flux
loops. If this file is specified in the \'DIAGNO\_IN\' namelist then
simulated flux loop values will be calculated. This file has a similar
format to that of the coils file. Here each loops is specified by a
number of points where the first and last points are considered closed
if a closed loop is specified. The first line of the file indicates the
total number of flux loops in the file. Then for each loop a header
followed by a number of points (x,y,z) are specified. The header is
composed of the number of points defining the loop, a flag to indicate
if the loop is closed (0) or open (1), a flag to control total flux
contribution to the measurement, and a label for the loop. The x, y, and
z coordinates for each point in the loop are then specified. Here is an
example specification of a single saddle coil:

    1
       16     0     1 TEST_COIL
    -580.000000 -2880.000000 -380.000000
    -690.000000 -2920.000000 -520.000000
    -810.000000 -2970.000000 -630.000000
    -940.000000 -3050.000000 -630.000000
    -1110.000000 -3110.000000 -475.000000
    -1320.000000 -3020.000000 -280.000000
    -1480.000000 -2800.000000 -170.000000
    -1520.000000 -2550.000000 -160.000000
    -1470.000000 -2470.000000 -100.000000
    -1390.000000 -2510.000000 40.000000
    -1330.000000 -2560.000000 170.000000
    -1290.000000 -2690.000000 230.000000
    -1210.000000 -2910.000000 140.000000
    -1020.000000 -3070.000000 -30.000000
    -770.000000 -3070.000000 -180.000000
    -580.000000 -2940.000000 -280.000000

In this file one coil is specified. That coil is composed of 16 points,
is a closed loop, should have the toroidal flux subtracted from the
measurement, and has the name TEST\_COIL. The user should also specify
\'flux\_turns\' in the \'DIAGNO\_IN\' namelist. This specifies the
number of turns in each flux loop and can be used to control polarity. A
note should be made about \'open\' vs. \'closed\' loops. The \'open\'
option should only be specified if the loop is periodic in shape with
respect to a plasma period. This option is provided to speed up
computation. Otherwise toroidal loops should be fully specified if they
contain a complex shape.

#### Segmented Rogowski Coils

The Segmented Rogowski Coils diagnostic is used to simulate the output
from Rogowski coils in which have been cut into segments for current
profile measurments (also known as cos2theta coils). If this file is
specified in the \'DIAGNO\_IN\' namelist then magnetic measurements are
simulated. These diagnostics are specified in the same manner as the
flux loops.

------------------------------------------------------------------------

### Execution

The DIAGNO code is executed by calling XDIAGNO from the command line in
a directory containing the previously mentioned files. DIAGNO requires
that the run suffix (provided by the VMEC file) be passed to it via the
command line call. Additionally, the \'-noverb\' flag may be passed
after the suffix to suppress screen output. Here is an example call to
DIAGNO:

    > ~/bin/xdiagno -vmec test >& log.diagno &

Here it has been assumed that a \'DIAGNO\_IN\' namelist is present in
the \'input.test\' file. As no coils file was provided, only the plasma
field will be calculated. To calculate a vacuum field then use the
following:

    > ~/bin/xdiagno -vmec test -coil coils.test_machine -vac >& log.diagno &

------------------------------------------------------------------------

### Output Data Format

The DIAGNO code outputs data to files for each type of magnetic
diagnostic it simulates. Output is switched on for a given diagnostic
through specification of said diagnostic in the \'diagno.control\' input
namelist. The B-Field Test Points diagnostic produces no file output and
only displays the magnetic field at points in space to the screen. The
Magnetic Field Probes diagnostic outputs data to a file called
\'diagno\_bth.\' The Segmented Rogowski Coils diagnostic outputs data to
a file called \'diagno\_seg.\' The Flux Loops diagnostic outputs data to
the \'diagno\_flux.\' file. Examples of these files can be found in the
tutorials below.

------------------------------------------------------------------------

### Visualization

The data output by DIAGNO is simulated magnetic measurements. DIAGNO is
in essence a utility for the STELLOPT codes to aid in magnetic
reconstruction. At this time no DIAGNO visualization routines exist. All
output from DIAGNO is in the form of tables stored in text files.

------------------------------------------------------------------------

### Tutorials

[DIAGNO NCSX Tutorial](DIAGNO v2.0 Tutorial)