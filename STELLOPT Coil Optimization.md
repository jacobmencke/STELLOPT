Tutorial: STELLOPT with COILOPT++ coil optimization
===================================================

It is possible to run STELLOPT where the residual normal field after
running COILOPT++ is calculated. This tutorial will guide the user
through such an optimization.

------------------------------------------------------------------------

Cluster requirements
--------------------

As both STELLOPT and COILOPT++ are parallel codes, the number of
processors for a given run of STELLOPT will be much larger than usual.
The total number of processors for a give run will be divided (evenly)
by the NPOPULATION parameter (located in the OPTIMUM namelist). The
NPOPULATION parameter defines the number of \'master\' processes which
will preform the optimization. Each \'master\' process will get an even
number of \'worker\' processes which (along with the associated master)
will run the COILOPT++ code. For example, say you had a 40 dimensional
optimization problem and you\'d like to run each instance of the
COILOPT++ code with 10 processors. This would then require 400 threads
to be launched and NPOPULATION set to 40.

------------------------------------------------------------------------

Compiling with COILOPT++
------------------------

After a copy of COILOPT++ has been obtained and compiled the user must
specify an environment variable called COILOPT\_PATH. This variable must
point to the directory in which COILOPT++ resides. For example:
[code format=\"bash\"](code format="bash") \>\>setenv COILOPT\_PATH
/u/user/src/COILOPT++/ [code](code) Once this variable has been set
STELLOPT can be compiled using the setup script. If the path is
correctly detected a message should appear on the screen during the
question and answer session, such as:
[code format=\"bash\"](code format="bash")
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
COILOPT++ libraries where located in /u/user/src/COILOPT++/ Build with
COILOPT++ support? (default: y)
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
y / n : y Compiling with COILOPT++ support! [code](code) This indicates
that the COILOPT++ source files were correctly found and STELLOPT can
compile with COILOPT++ support.

------------------------------------------------------------------------

Input files setup
-----------------

To execute STELLOPT with COILOPT++ support you will need a COILOPT++
input file (named coilopt\_params) in the same directory as the STELLOPT
run. This file is read once at the beginning of the run to determine how
to run COILOPT++. You will also need a coil winding surface file and
initial spline file in the run directory (the names must match those in
the coilopt\_params file). At this time the code does not generate a new
coil winding surface with each equilibria. However, the coil spline
representation from the last \'good\' equilibrium will be used as the
initial coil spline for subsequent COILOPT++ runs during STELLOPT
optimization.

The STELLOPT input file should include the new TARGET\_COIL\_BNORM,
SIGMA\_COIL\_BNORM, NU\_BNORM, and NV\_BNORM variables, along with the
NPOPULATION parameter as mentioned above. [code](code) &OPTIMUM
!\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
! Optimizer Run Control Parameters
!\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
NFUNC\_MAX = 100 EQUIL\_TYPE = \'vmec2000\' OPT\_TYPE = \'lmdif\' FTOL =
1.000000000000E-006 XTOL = 1.000000000000E-030 GTOL =
1.000000000000E-030 EPSFCN = 1.000000000000E-005 FACTOR =
1.000000000000E+002 MODE = 1 NPOPULATION = 10
!\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
! OPTIMIZED QUANTITIES
!\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
LRHO\_OPT(-5:5,0) = 11\*T LRHO\_OPT(-5:5,1) = 11\*T LRHO\_OPT(-5:5,2) =
11\*T LRHO\_OPT(-5:5,3) = 11\*T LRHO\_OPT(-5:5,4) = 11\*T
LRHO\_OPT(-5:5,5) = 11\*T LRHO\_OPT(-5:5,6) = 11\*T LRHO\_OPT(-5:5,7) =
11\*T LBOUND\_OPT(1:4,0) = 4\*T RHO\_EXP = 4
!\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
! COIL OPTIMIZATION
!\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--
NU\_BNORM = 256 NV\_BNORM = 64 TARGET\_COIL\_BNORM = 0.000000000000E+000
SIGMA\_COIL\_BNORM = 1.000000000000E+000 / &END [code](code) Note that
every point on the boundary is treated as a separate contribution to
chi-squared so that for this run there are 256x64=16384 targets. Also
note that this is a fixed boundary run.

------------------------------------------------------------------------

Code execution
--------------

Execution of the STELLOPT code is as usual, however now the normal
fields (as calculated by the BNORM code) and optimization of the coils
will occur. For example: [code](code) dawson094:2498 mpirun \$NOIB -np
64 /bin/xstelloptv2 input.COILOPTPP STELLOPT Version 2.44 Equilibrium
calculation provided by:
=================================================================================
========= Variational Moments Equilibrium Code (v 8.51) =========
========= (S. Hirshman, J. Whitson) ========= =========
<http://vmecwiki.pppl.wikispaces.net/VMEC> =========
=================================================================================

Stellarator Coil Optimization provided by:
=================================================================================
========= COILOPT++ ========= ========= (J. Breslau, S. Lazerson)
========= ========= jbreslau\@pppl.gov =========
=================================================================================

\-\-\-\-- Optimization \-\-\-\-- =======VARS======= PHIEDGE: Total
Enclosed Toroidal Flux CURTOR: Total Toroidal Current

###### TARGETS

Total Enclosed Toroidal Flux Net Toroidal Current R\*Btor R0 (phi=0)
Plasma Volume Plasma Beta Plasma Stored Energy Aspect Ratio COILOPT++
Normal Field ================== Number of Processors: 64 Number of
Parameters: 2 Number of Targets: 16392 !!!! EQUILIBRIUM RESTARTING NOT
UTILIZED !!!! Number of Optimizer Threads: 2 OPTIMIZER:
Levenberg-Mardquardt NFUNC\_MAX: 100 FTOL: 1.0000E-06 XTOL: 1.0000E-30
GTOL: 1.0000E-30 EPSFCN: 1.0000E-05 MODE: 1 FACTOR: 100.0000000000000
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- EQUILIBRIUM
CALCULATION \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

NS = 9 NO. FOURIER MODES = 94 FTOLV = 1.000E-06 NITER = 1000 INITIAL
JACOBIAN CHANGED SIGN! TRYING TO IMPROVE INITIAL MAGNETIC AXIS GUESS

ITER FSQR FSQZ FSQL RAX(v=0) DELT WMHD

1 8.14E-01 7.88E-02 1.71E-01 1.604E+00 9.00E-01 3.7586E+00 131 9.48E-07
2.23E-07 2.43E-07 1.581E+00 6.37E-01 3.6370E+00

NS = 29 NO. FOURIER MODES = 94 FTOLV = 1.000E-08 NITER = 2000

ITER FSQR FSQZ FSQL RAX(v=0) DELT WMHD

1 4.30E-02 2.05E-02 3.49E-04 1.581E+00 9.00E-01 3.6368E+00 200 3.05E-08
7.50E-09 1.11E-08 1.580E+00 6.56E-01 3.6365E+00 246 9.98E-09 1.50E-09
5.44E-09 1.580E+00 6.56E-01 3.6365E+00

EXECUTION TERMINATED NORMALLY

FILE : reset\_file NUMBER OF JACOBIAN RESETS = 3

TOTAL COMPUTATIONAL TIME 4.03 SECONDS TIME TO READ IN DATA 0.00 SECONDS
TIME TO WRITE DATA TO WOUT 0.03 SECONDS TIME IN EQFORCE 0.04 SECONDS
TIME IN FOURIER TRANSFORM 1.23 SECONDS TIME IN INVERSE FOURIER XFORM
0.98 SECONDS TIME IN FORCES 0.58 SECONDS TIME IN BCOVAR 0.64 SECONDS
TIME IN RESIDUE 0.10 SECONDS TIME (REMAINDER) IN FUNCT3D 0.39 SECONDS
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- VMEC CALCULATION
DONE \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- ASPECT RATIO:
4.365 BETA: 0.042 (total) 0.584 (poloidal) 0.046 (toroidal) TORIDAL
CURRENT: -0.174994731631E+06 TORIDAL FLUX: 0.514 VOLUME: 2.979 MAJOR
RADIUS: 1.422 MINOR\_RADIUS: 0.326 STORED ENERGY: 0.192555039942E+06
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- COILOPT++
OPTIMIZATION \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- -
Calculating B-Normal File Max. B-Normal: 8.330206410532E-003 MIN.
B-Normal: -3.526951461018E-003 Coefficients output to: bnorm.reset\_file
- Initializing COILOPT++ 3 field periods in plasma surface. n\_max = 5;
m\_max = 8 Mean aspect ratio = 3.886. 525 modes in Bnormal on plasma
surface. n\_max = 10; m\_max = 24 Area elements range from 1.140e-05 to
1.276e-04. Estimated plasma surface area = 23.900 sq m. 16384 matching
points on plasma surface. rms B\_normal = 5.094345e-02 154 modes in coil
winding surface cws. Minimum plasma - winding surface 0 separation =
0.328619 m. at 0,0 on surface 0, R,z = 2.052443e+00, 0.000000e+00 at
.5,.5, x,y,z = -7.290831e-01, 8.928693e-17, 2.307990e-17 4 unique coils
in splined coilset fd.spline; 8 total. Coil 0 is modular with 24
coefficients. Coil 1 is modular with 24 coefficients. Coil 2 is modular
with 24 coefficients. Coil 3 is modular with 24 coefficients. 3 field
periods in coilset 0. Input net poloidal coil current = 9.726e-06 +
0.000e+00 (TF) MA. Autoscaling net non-TF current x 1.189e+06 to 11.565
MA. Constraining net poloidal current on surface 0 to 11.565 MA. Zero
I\_pol deviation penalty; cannot normalize weight. Zero straight section
exclusion penalty; cannot normalize weight. Zero saddle-bounding rect
exclusion penalty; cannot normalize weight. - Executing COILOPT++
Surface 0: current varying. coil 0: I=5.029654e+05; geometry varying.
coil 1: I=4.506475e+05; geometry varying. coil 2: I=4.839407e+05;
geometry varying. coil 3: I=4.898859e+05; geometry varying. Field error
normalization ON.

159 free variables in coilset. 16488 components in cost vector. rms dB/B
= 1.270626e-01 max dB/B = 3.460288e-01 Relative I\_pol deviation =
0.000000 %. length\[0\]\[0\] = 5.510796e+00 (target = 4.941536e+00)
length\[0\]\[1\] = 5.353218e+00 (target = 4.813557e+00) length\[0\]\[2\]
= 6.176846e+00 (target = 5.586199e+00) length\[0\]\[3\] = 5.393320e+00
(target = 4.849204e+00) torsion\[0\]\[0\] = 7.291275e+03.
torsion\[0\]\[1\] = 2.298752e+04. torsion\[0\]\[2\] = 3.955409e+04.
torsion\[0\]\[3\] = 1.839651e+04. toroidal std dev\[0\]\[0\] =
8.526636e+00 degrees. toroidal std dev\[0\]\[1\] = 6.974845e+00 degrees.
toroidal std dev\[0\]\[2\] = 8.255636e+00 degrees. toroidal std
dev\[0\]\[3\] = 6.297704e+00 degrees. Surface 0 coil 0 - coil 22 sep.
penalty = 7.784229e-03 Surface 0 coil 0 - coil 23 sep. penalty =
5.539243e-01 Surface 0 coil 0 - coil 1 sep. penalty = 5.473705e-02
Surface 0 coil 0 - coil 2 sep. penalty = 1.152388e-02 Surface 0 coil 1 -
coil 23 sep. penalty = 7.784229e-03 Surface 0 coil 1 - coil 2 sep.
penalty = 4.504615e+00 Surface 0 coil 1 - coil 3 sep. penalty =
6.830634e-03 Surface 0 coil 2 - coil 3 sep. penalty = 2.919920e-02
Surface 0 coil 2 - coil 4 sep. penalty = 5.753916e-03 Surface 0 coil 3 -
coil 4 sep. penalty = 4.295088e-02 Surface 0 coil 3 - coil 5 sep.
penalty = 5.753916e-03 Total self-intersections\[0\]: 0 Initial rms
error = 1.725800e+00. Beginning 2 iterations of Levenberg-Marquardt.
initial stepbound = 1.000000e+00. Function dimension m\_dat = 16488 iter
0 nfev = 1 fnorm = 1.7257995640e+00 iter 1 nfev = 164 fnorm =
1.4954587242e+00 Final LM status = 5: timeout (number of calls to fcn
has reached maxcall\*(n+1)). function norm = 1.217613e+00 324 function
evaluations. 385.62 seconds. rms dB/B = 1.049056e-01 max dB/B =
3.055870e-01 Relative I\_pol deviation = 0.000000 %. length\[0\]\[0\] =
5.402857e+00 (target = 4.941536e+00) length\[0\]\[1\] = 5.262139e+00
(target = 4.813557e+00) length\[0\]\[2\] = 6.006173e+00 (target =
5.586199e+00) length\[0\]\[3\] = 5.219465e+00 (target = 4.849204e+00)
torsion\[0\]\[0\] = 6.363533e+03. torsion\[0\]\[1\] = 1.440956e+04.
torsion\[0\]\[2\] = 3.999101e+04. torsion\[0\]\[3\] = 1.944595e+04.
toroidal std dev\[0\]\[0\] = 7.887216e+00 degrees. toroidal std
dev\[0\]\[1\] = 6.725000e+00 degrees. toroidal std dev\[0\]\[2\] =
7.979800e+00 degrees. toroidal std dev\[0\]\[3\] = 7.079227e+00 degrees.
Surface 0 coil 0 - coil 22 sep. penalty = 1.034768e-02 Surface 0 coil 0
- coil 23 sep. penalty = 4.676905e-01 Surface 0 coil 0 - coil 1 sep.
penalty = 8.657821e-02 Surface 0 coil 0 - coil 2 sep. penalty =
1.265983e-02 Surface 0 coil 1 - coil 23 sep. penalty = 1.034768e-02
Surface 0 coil 1 - coil 2 sep. penalty = 3.072756e+00 Surface 0 coil 1 -
coil 3 sep. penalty = 9.689476e-03 Surface 0 coil 2 - coil 3 sep.
penalty = 4.890191e-02 Surface 0 coil 2 - coil 4 sep. penalty =
5.135596e-03 Surface 0 coil 3 - coil 4 sep. penalty = 4.099989e-02
Surface 0 coil 3 - coil 5 sep. penalty = 5.135596e-03 Total
self-intersections\[0\]: 0 cost = 1.217613e+00 Final net poloidal
current = 11.565 MA.
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- COILOPT++ DONE
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Beginning Levenberg-Marquardt Iterations Number of Processors: 2

======================================================================
Iteration Processor Chi-Sq LM Parameter Delta Tol
====================================================================== 0
0 1.2393E+03 1 1 1.1660E+03 - 2 1 1.1031E+03 - 3 1 1.1352E+03 0.0000E+00
1.0760E+04 4 2 1.0926E+03\* 0.0000E+00 2.1016E+04

new minimum = 1.093E+03 lm-par = 0.000E+00 delta-tol = 1.808E+01

[code](code) Note that in this run only 2 free parameters were turned
on, 2 optimizers, and 32 processors per COILOPT++ run utilized.