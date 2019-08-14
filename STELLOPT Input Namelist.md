\<span style=\"font-size: 13px; line-height: 1.5;\"\>The STELLOPT
OPTIMUM namelist controls the execution of the STELLOPT code. Not all
values need be specified in a file. This input namelist should be
appended the input file containing the
[VMEC input namelist](VMEC input namelist). The OPTIMUM namelist is
arranged below into sections for clarity. The first section deals with
how the optimizer runs and which equilibrium code to utilize.\</span\>

------------------------------------------------------------------------

Runtime Control
---------------

The following parameters control how the code runs. Depending on the
type of optimization the parameters may change functionality. For a
characterization of some optimization choices please see the page
[STELLOPT Optimizer Comparison](STELLOPT Optimizer Comparison).

    &OPTIMUM
    !------------------------------------------------------------------------
    !       Optimizer Run Control Parameters
    !------------------------------------------------------------------------
      NFUNC_MAX    = 5000                       ! Maximum number of function evaluations
      EQUIL_TYPE   = 'VMEC2000'                 ! Equilibrium Code VMEC2000
      OPT_TYPE     = 'LMDIF'                    ! Optimization Type (LMDIF),GADE,MAP,PSO
      FTOL         = 1.0E-4                     ! Absolute Tolerance
      XTOL         = 1.0E-4                     ! Relative Tolerance
      GTOL         = 1.0E-30                    ! Orthogonality Tolerance
      EPSFCN       = 1.0E-4                     ! Finite Difference Stepsize
      FACTOR       = 100.0                      ! Initial step scaling
      MODE         = 0                          ! Mode Parameter
      CR_STRATEGY  = 0
      NPOPULATION  = 8                          ! Number of optimizer threads
      LKEEP_MINS   = T                          ! Logical to keep minimum states
      LREFIT       = F                          ! Logical for profile refitting (reconstruction only)

### LMDIF

Levenberg-Marquardt algorithm with finite difference derivative
evaluation. Note that the user should not set the NPOPULATION parameter
unless they\'re running parallel codes. \|\| FTOL \|\| Desired relative
error in sum of squares. Termination occurs when both the actual and
predicted relative \<span style=\"line-height: 1.5;\"\>reductions in the
sum of squares are at most FTOL. T\</span\>herefore, FTOL measures the
relative error desired \<span style=\"line-height: 1.5;\"\>in the sum of
squares.\</span\> \|\| \|\| XTOL \|\| Desired relative error in
approximate solution. Termination occurs when the relative error between
two consecutive iterates is at most XTOL. Therefore, XTOL measures the
relative error desired in the approximate solution. \|\| \|\| GTOL \|\|
Measures the orthogonality between the function vector and columns of
the Jacobian. Termination occurs when the cosine of the angle between
FVEC and any column of the Jacobian is at most GTOL in absolute value.
therefore, GTOL measures the orthogonality desired between the function
vector and the columns of the jacobian. \|\| \|\| EPSFCN \|\| Jacobian
forward differencing step size (1% \~ 0.0001) \|\| \|\| FACTOR \|\|
Determines initial step step bound (100.0 suggested) \|\| \|\| MODE \|\|
Determines variable scaling (1: auto, 2: Use DVAR scaling values) \|\|
\|\| NPOPULATION \|\| Number of optimizer threads (for parallel codes:
GENE, COILOPT++, BEAMS3D, default: NPROCS) \|\| A bounded LMDIF routine
is also accessible by setting the OPT\_TYPE=\'LMDIF\_BOUNDED\'.

### GADE

Genetic algorithm with differential evolution mode where the input
vector defining the optimized quantities are treated as \'GENES.\' It
should be noted that the user must also supply MIN and MAX values
through the appropriate auxiliary arrays for each variable which is
varied. Stereotypical advice is to set MIN = 0.5\*VAL and MAX=2.0\*VAL
where VAL is the initial value of the variable being varied by the code
(some sorting may be necessary). This was how the values were
traditionally set in addition to: FACTOR = 0.5, EPSFCN = 0.3, MODE = 2,
CR\_STRATEGY = 0. \|\| FACTOR \|\| Mutation scaling factor (F). \|\|
\|\| EPSFCN \|\| Crossover factor. \|\| \|\| MODE \|\| The strategy of
the mutation operations used. \|\| \|\| CR\_STRATEGY \|\| Cross-over
strategy (0: exponential, 1: binomial) \|\| The algorithm begin by
evaluating NPOPULATION equilibria, where the first member of the
population is the input equilibria. All other equilibria are randomly
generated from the MIN and MAX values in the OPTIMUM name list. The
CR\_STRATEGY parameter controls how \'GENES\' are mutated. Setting it to
1 tells the code to randomly permute GENES where approximately EPSFCN
(in percentage) \'GENES\' are permuted. Setting it to zero gives a more
random behavior. However, if the user sets EPSFCN to 1, all \'GENES\'
will be mutated either way. Setting EPSFCN to 0 and CR\_STRATEGY to 1
would tell the code to permute one \'GENE.\' Setting EPSFCN to 0 and
CR\_STRATEGY to 0 would permute all \'GENES.\' The mutation of the
\'GENES\' is controlled by FACTOR and MODE. In each case, member of the
population are randomly chosen to \'mate.\' The FACTOR parameter
controls how much \'mutation\' is preformed. The following table
outlines the effects of the MODE parameter \|\| MODE \|\| Mutation
Equation \|\| \|\| 1 \|\| X\_NEW=X\_BEST+FACTOR\*(X\_1-X\_2) \|\| \|\| 2
\|\| X\_NEW=X\_3+FACTOR\*(X\_1-X\_2) \|\| \|\| 3 \|\|
X\_NEW=X\_OLD+FACTOR\*(X\_BEST-X\_OLD+X\_3-X\_4) \|\| \|\| 4 \|\|
X\_NEW=X\_BEST+FACTOR\*(X\_1-X\_2+X\_3-X\_4) \|\| \|\| 5 \|\|
X\_NEW=X\_5+FACTOR\*(X\_1-X\_2+X\_3-X\_4) \|\| Here X\_BEST is the GENE
from the \'BEST\' previous equilibrium (lowest chi-squared),
X\_(1,2,3,4,5) are randomly chosen members of the population, and X\_OLD
is the original GENE. Remember that only specific \'GENES\' are being
mutated. Notes from code on choice of MODE.

    !=======Choice of strategy=================================================
    !  We have tried to come up with a sensible naming-convention: DE/x/y/z
    !    DE :  stands for Differential Evolution
    !    x  :  a string which denotes the vector to be perturbed
    !    y  :  number of difference vectors taken for perturbation of x
    !    z  :  crossover method (exp = exponential, bin = binomial)
    !
    !  There are some simple rules which are worth following:
    !  1)  F is usually between 0.5 and 1 (in rare cases > 1)
    !  2)  CR is between 0 and 1 with 0., 0.3, 0.7 and 1. being worth to be tried first
    !  3)  To start off NP = 10*D is a reasonable choice. Increase NP IF
    !      misconvergence happens.
    !  4)  If you increase NP, F usually has to be decreased
    !  5)  When the DE/best... schemes fail DE/rand... usually works and vice versa
    !
    !
    ! Here are Storn''s comments on the different strategies:
    !
    ! (1) DE/best/1/'z'
    !     Our oldest strategy but still not bad. However, we have found several
    !     optimization problems WHERE misconvergence occurs.
    !
    ! (2) DE/rand/1/'z'
    !     This is one of my favourite strategies. It works especially well when the
    !     "bestit[]"-schemes EXPerience misconvergence. Try e.g. F=0.7 and CR=0.5
    !     as a first guess.
    !
    ! (3) DE/rand-to-best/1/'z'
    !     This strategy seems to be one of the best strategies. Try F=0.85 and CR=1.
    !     If you get misconvergence try to increase NP. If this does not help you
    !     should play around with all three control variables.
    !
    ! (4) DE/best/2/'z' is another powerful strategy worth trying
    !
    ! (5) DE/rand/2/'z' seems to be a robust optimizer for many functions
    !
    !===========================================================================

To preform a restart from a previous run first setup a new directory,
with the input file and any auxiliary files you may need. Then copy in
the gade\_restart.ext file from your previous run. Then when you execute
STELLOPT, include the -restart flag on the command line to tell the
system that this is a restart.

### PSO

Particle Swarm evolution. \|\| FTOL \|\| Desired relative error in sum
of squares. \|\| \|\| XTOL \|\| Desired relative error in approximate
solution. \|\| \|\| EPSFCN \|\| Ratio of global attractor to local
(local = 1.0) \|\| \|\| FACTOR \|\| Scaling factor for maximum velocity
\|\|

### Mapping (gridded)

The STELLOPT code can perform a gridded mapping of the n-dimensional
space. \|\| MODE \|\| Number of gridpoints along a given dimension \|\|
\|\| NPOPULATION \|\| Number of workers to evaluate map (default:
NPROCS) \|\|

### Mapping (hyperplane)

The STELLOPT code can perform a gridded mapping using a 2D hyperspace
plane as defined by two points in space. In this case, the plane is
defined by the initial equilibrium and the equilibriums defined by
XXX\_MIN and XXX\_MAX (where XXX are the desired variables). \|\| MODE
\|\| Number of gridpoints along a given dimension \|\| \|\| NPOPULATION
\|\| Number of workers to evaluate map (default: NPROCS) \|\|

Variables
---------

The quantities we wish to optimize (variables) are specified on an
individual basis. There is a one to one correspondance between a
parameter below and the value varied in the equilibrium input namelist.
All values are defaulted to false. It should be noted that a min and max
value are available for each variable along with a scaling value (D).
The MIN and MAX values are used to bound the optimization (necessary for
the global searches: PSO,GADE; but optional for the Levenberg) . The
scaling values are only utilized for the Levenber-Marquardt algorithm
with MODE set to 2.

    !------------------------------------------------------------------------
    !       Optimized Quantities
    !------------------------------------------------------------------------
      LPHIEDGE_OPT  = T
        PHIEDGE_MIN = 0.01
        PHIEDGE_MAX = 1.00
        DPHIEDGE    = 1.0
      LCURTOR_OPT   = T
      LPSCALE_OPT   = T
      LBCRIT_OPT    = T
      LEXTCUR_OPT   = T T T T
      LAPHI_OPT     = T T T T
      LAM_OPT       = T T T T
      LAC_OPT       = F T F T
      LAI_OPT       = T F T F
      LAH_OPT       = T T T T
      LAT_OPT       = T T T T
      LNE_OPT       = T T T T
      LZEFF_OPT     = T T T T
      LTE_OPT       = T T T T
      LTI_OPT       = T T T T
      LAM_F_OPT     = T T T T
      LAC_F_OPT     = T T T T
      LAI_F_OPT     = T T T T
      LNE_F_OPT     = T T T T
      LZEFF_F_OPT   = T T T T
      LTE_F_OPT     = T F T T
      LTI_F_OPT     = F F T T
      LBEAMJ_F_OPT  = T T T T
      LBOOTJ_F_OPT  = T T T T
      LBOUND_OPT(1,0) = T      ! Optimize RBC,ZBS Arrays
      LRHO_OPT(1,0) = T        ! Optimize RHOMN (Hirshman/Breslau representation)
      LDELTAMN_OPT(1,0) = T    ! Optimize DELTAMN (Garabedian representation)

Care should be taken not to enable conflicting profiles (ex. NE and AM).
Note when optimizing boundary harmonics that LRHO\_OPT and LDELTAMN\_OPT
will first recalculate the rhomn or deltamn represenation based on the
RBC and ZBS arrays, then vary these coefficients.
Hirshman-Breslau\<ref\>S. P. Hirshman and J. Breslau,
[Phys. Plasmas 5, 2664 (1998)](http://link.aip.org/link/doi/10.1063/1.872954).\</ref\>
and Garabedian representations only support stellarator symmetry
(up-down) at this time.

Profile Functions
-----------------

As seen in the above section, various non-equilibrium profiles have been
introduced. These profiles include electron density (NE), effective ion
charge (ZEFF), electron temperature (TE), ion temperature (TI),
electrostatic potential (PHI), driven current (BEAMJ), and bootstrap
current (BOOTJ). These profiles are utilized to calculate pressure and
current profiles which are then used to calculate the equilibrium. Two
profile variables exist for most profiles these are parameterized
XX\_OPT and spline XX\_AUX\_S, XX\_AUX\_F. The available profile types
for NE, TE, TI, and ZEFF are: GAUSS\_TRUNC, TWO\_LORENTZ, TWO\_POWER,
POWER\_SERIES, PEDESTAL, and SPLINE. The BEAMJ and BOOTJ profiles are
summed together to provide the AC\_AUX\_F array (where it is assumed we
are providing I-prime not I). The BEAMJ profile has the types:
TWO\_POWER and SPLINE. The BOOTJ profile has the types: BUMP,
TWO\_POWER, SPLINE. Note that the BEAMJ and BOOTJ profiles do not have
XX\_OPT type profile specification but rather use the spline array
values when parameterized. Note that NE is normalized to 1.0E+18.

    !------------------------------------------------------------------------
    !       Profile Functions
    !------------------------------------------------------------------------
      NE_TYPE    = 'SPLINE'
      NE_OPT     = 1.0  2.0  3.0
      NE_AUX_S   = 0.0  0.1  0.5  0.9  1.0   ! Radial Location of Spline knots
      NE_AUX_F   = 1.0  1.0  1.0  1.2  0.0   ! Spline knot values
      ZEFF_TYPE    = 'SPLINE'
      ZEFF_OPT     = 1.0  2.0  3.0
      ZEFF_AUX_S   = 0.0  0.1  0.5  0.9  1.0
      ZEFF_AUX_F   = 1.0  1.0  1.0  1.2  0.0
      TE_TYPE    = 'SPLINE'
      TE_OPT     = 1.0  2.0  3.0
      TE_AUX_S   = 0.0  0.1  0.5  0.9  1.0
      TE_AUX_F   = 1.0  1.0  1.0  1.2  0.0
      TI_TYPE    = 'SPLINE'
      TI_OPT     = 1.0  2.0  3.0
      TI_AUX_S   = 0.0  0.1  0.5  0.9  1.0
      TI_AUX_F   = 1.0  1.0  1.0  1.2  0.0
      BEAMJ_TYPE = 'TWO_POWER'
      BEAMJ_AUX_S   = 0.0  0.1  0.5  0.9  1.0
      BEAMJ_AUX_F   = 1.0  1.0  1.0  1.2  0.0
      BOOTJ_TYPE = 'BUMP'
      BOOTJ_AUX_S   = 0.0  0.1  0.5  0.9  1.0
      BOOTJ_AUX_F   = 1.0  1.0  1.0  1.2  0.0

\|\|\~ Profile Type (XX\_TYPE) \|\|\~ Functional form \|\|\~ Description
\|\| \|\|\< AKIMA\_SPLINE \|\|\< See desciption \|\|\< 3rd order Akima
spline. Minimum of five knots required. Use XX\_AUX\_S and XX\_AUX\_F to
control the knot locations and values. \|\| \|\|\< POWER\_SERIES \|\| c0
+ c1\*s + s\^2 \<span style=\"line-height: 1.5;\"\>+ c2\*s\^3 + . . .
\</span\> \|\|\< Polynomial power series in s. It is recommended to fix
the odd coefficients to zero in order to have a better behaved even
polynomial. Use XX\_OPT to control the coefficient values. \|\| \|\|\<
TWO\_POWER \|\|\< \<span style=\"background-color: \#ffffff; color:
\#222222; font-family: arial,sans-serif;\"\>c0\*(1 - s\^c1)\^c2\</span\>
\|\|\< Simple 3 coefficient representation. \|\| \|\| GAUSS\_TRUNC \|\|
(c0/(1.0 - exp(-(1.0/c1)\^2)))\*(exp(-(s./c1).\^2)-exp(-(1.0/c1)\^2))
\|\| Two coefficient truncated gaussian. \|\| \|\| TWO\_LORENTZ \|\|
\|\| \<span style=\"line-height: 1.5;\"\>two Lorentz-type functions,
mapped to \[0:1\]\</span\> \|\| \|\| PEDESTAL \|\| \<span
style=\"line-height: 1.5;\"\>C20 \* C17 \* ( TANH( 2\*(C18-SQRT(s))/C19
) -TANH( 2\*(C18-1.0) /C19 ) )\</span\> \|\| 10th order polynomial plus
hyperbolic tangent like edge profile. Note C20 auto-calculated to be C20
= 1.0/(TANH(2\*c18/c19)-TANH(2\*(c18-1)/c19)) \|\|

Boozer Spectrum Parameters
--------------------------

General values are placed in the next section which may effect the
various chi-squared calculations not defined in another namelist

    !------------------------------------------------------------------------
    !       Boozer Coordinate Transformation
    !------------------------------------------------------------------------
      MBOZ = 65
      NBOZ = 24

Targets
-------

There are various chi-squared functionals and each is a unique set of
parameters. In general for each target value there is a sigma associated
with it. Here they are broken down by specialty

    !------------------------------------------------------------------------
    !       Equilibrium / Geometry Optimization Targets
    !------------------------------------------------------------------------
      TARGET_PHIEDGE = 2.5    SIGMA_PHIEDGE = 0.025   ! Enclosed Toroidal Flux [Wb]
      TARGET_CURTOR  = 1.0E6  SIGMA_CURTOR  = 1.0E3   ! Total Toroidal Current [A]
      TARGET_CURVATURE = 1.0E-3  SIGMA_CURVATURE = 1.0 ! Flux surface curvature
      TARGET_RBTOR   = 7.2    SIGMA_RBTOR   = 0.01    ! R*Btor [T-m]
      TARGET_R0      = 3.6    SIGMA_R0      = 0.01    ! Magnetic Axis R (phi=0) [m]
      TARGET_Z0      = 0.5    SIGMA_Z0      = 0.01    ! Magnetic Axis Z (phi=0) [m]
      TARGET_VOLUME  = 1.0E2  SIGMA_VOLUME  = 1.0     ! Plasma Volume [m^-3]
      TARGET_BETA    = 0.02   SIGMA_BETA    = 0.0001  ! Average Plasma Beta
      TARGET_WP      = 1.0E3  SIGMA_WP      = 1.0     ! Stored Energy [J]
      TARGET_ASPECT  = 5.0    SIGMA_ASPECT  = 0.5     ! Aspect Ratio (R/a)
    !------------------------------------------------------------------------
    !       Equilibrium Elongation Targets
    !          KAPPA:  Elongation defined by plasma minor radius.
    !          KAPPA_BOX:  Elongation defined by box.
    !          KAPPA_AVG:  Toroidal average of KAPPA.
    !          Note:  KAPPA and KAPPA_BOX require a toroidal angle to be
    !                     specified (defaults to 0.0).
    !------------------------------------------------------------------------
      TARGET_KAPPA = 2.0  SIGMA_KAPPA = 1.0  PHI_KAPPA = 0.0
      TARGET_KAPPA_BOX = 2.0  SIGMA_KAPPA_BOX = 1.0  PHI_KAPPA_BOX = 0.0
      TARGET_KAPPA_AVG = 2.0  SIGMA_KAPPA_AVG = 1.0
    !------------------------------------------------------------------------
    !       Boozer Coordinate Helicity
    !         Note that helicity targeting is by surface.  Axis (01) is ignored.
    !         (X,0): Quasi-Axisymetry
    !         (0,X): Quasi-Poloidal Symmetry
    !         (L,K): Quasi-Helical Symmetry (m *K + n*L)
    !------------------------------------------------------------------------
      HELICITY = (1,0)
      TARGET_HELICITY(02) = 0.0  SIGMA_HELICITY(02) = 0.01
      TARGET_HELICITY(03) = 0.0  SIGMA_HELICITY(03) = 0.01
      TARGET_HELICITY(25) = 0.0  SIGMA_HELICITY(25) = 0.01
    !------------------------------------------------------------------------
    !       Ballooning Stability (as calculated by COBRA_VMEC)
    !         Note that ballooning stability is by surface.  Axis (01) is ignored.
    !         THETA, ZETA: Ballooning angle perturbations
    !------------------------------------------------------------------------
      BALLOON_THETA = 0.0  3.14  5.50
      BALLOON_ZETA    = 0.0 3.14  5.50
      TARGET_BALLOON(02) = 0.0  SIGMA_BALLOON(02) = 0.2
      TARGET_BALLOON(10) = 0.0  SIGMA_BALLOON(10) = 0.2
      TARGET_BALLOON(45) = 0.0  SIGMA_BALLOON(45) = 0.2
      TARGET_BALLOON(55) = 0.0  SIGMA_BALLOON(55) = 0.2
      TARGET_BALLOON(99) = 0.0  SIGMA_BALLOON(99) = 0.2
    !------------------------------------------------------------------------
    !       Kink Stability (as calculated by TERPSICHORE)
    !         Requires STELLOPT to be linked to TERPSICHORE
    !         Requires the terpsichore_input_XX files to be in the directory.
    !         Positive values of kink are considered stable.
    !------------------------------------------------------------------------
      MLMNB_KINK = 264 IVAC_KINK = 24
      TARGET_KINK(01) = 0.01  SIGMA_KINK(01) = 1.0
        NJ_KINK(01) = 256 NK_KINK(01) = 256
        MLMNS_KINK(01) = 76 LSSD_KINK(01) = 4096 LSSL_KINK(01) = 4096   ! terpsichore_input_00
      TARGET_KINK(02) = 0.01  SIGMA_KINK(02) = 1.0
        NJ_KINK(02) = 128 NK_KINK(02) = 128
        MLMNS_KINK(02) = 96 LSSD_KINK(02) = 4096 LSSL_KINK(02) = 4096! terpsichore_input_01
    !------------------------------------------------------------------------
    !       Neoclassical Transport Calculation (as calculated by NEO)
    !         Note that neoclassical transport is by surface. Axis (01) is ignored.
    !------------------------------------------------------------------------
      TARGET_NEO(02) = 0.0  SIGMA_NEO(02) = 0.01
      TARGET_NEO(10) = 0.0  SIGMA_NEO(10) = 0.01
      TARGET_NEO(45) = 0.0  SIGMA_NEO(45) = 0.01
      TARGET_NEO(55) = 0.0  SIGMA_NEO(55) = 0.01
      TARGET_NEO(98) = 0.0  SIGMA_NEO(98) = 0.01
    !------------------------------------------------------------------------
    !       Bootstrap Calculation (as calculated by BOOTSJ)
    !         Note that the bootstrap current is by surface. Axis (01) is ignored.
    !         If BEAMJ AND BOOTJ profiles are being utilized, the comparrision will be made
    !           against the BOOTJ portion of the profile only.  Otherwise, the comparrision is
    !           made against the equilibrium total JDOTB.  Also note that the BOOTSJ input
    !           namelist should be included in this file.
    !         The TE and NE profiles must be specified to use this option.  If TI is specified
    !            it is used, otherwise the teti ratio in the BOOTSJ namelist is used.  Same is
    !            true for ZEFF and ZEFF1.
    !------------------------------------------------------------------------
      TARGET_BOOTSTRAP(02) = 0.0  SIGMA_BOOTSTRAP(02) = 0.01
      TARGET_BOOTSTRAP(10) = 0.0  SIGMA_BOOTSTRAP(10) = 0.01
      TARGET_BOOTSTRAP(45) = 0.0  SIGMA_BOOTSTRAP(45) = 0.01
      TARGET_BOOTSTRAP(55) = 0.0  SIGMA_BOOTSTRAP(55) = 0.01
      TARGET_BOOTSTRAP(98) = 0.0  SIGMA_BOOTSTRAP(98) = 0.01
    !------------------------------------------------------------------------
    !       External Currents - Vacuum field coil currents [A]
    !------------------------------------------------------------------------
      TARGET_EXTCUR(01) =  1.0E5  SIGMA_EXTCUR(01) = 1.0
      TARGET_EXTCUR(02) =  2.0E5  SIGMA_EXTCUR(02) = 1.0
      TARGET_EXTCUR(03) =  3.0E5  SIGMA_EXTCUR(03) = 1.0
      TARGET_EXTCUR(04) = -1.0E5  SIGMA_EXTCUR(04) = 1.0
      TARGET_EXTCUR(05) =  3.0E5  SIGMA_EXTCUR(05) = 1.0
    !------------------------------------------------------------------------
    !       Pressure Profile Target (256 targets max)
    !          Array of pressure targets in R,PHI,Z space
    !                        or
    !          Array of pressure targets in S space S_PRESS(XX) = XX
    !            if s is specified R,PHI,Z are ignored
    !------------------------------------------------------------------------
      TARGET_PRESS(01) =  1.0E4  SIGMA_PRESS(01) = 1.0  R_PRESS(01) =  3.0  PHI_PRESS(01) =  0.0  Z_PRESS(01) = 0.00
      TARGET_PRESS(02) =  1.0E4  SIGMA_PRESS(02) = 1.0  R_PRESS(02) =  3.1  PHI_PRESS(02) =  0.0  Z_PRESS(02) = 0.00
      TARGET_PRESS(03) =  1.0E4  SIGMA_PRESS(03) = 1.0  R_PRESS(03) =  3.2  PHI_PRESS(03) =  0.0  Z_PRESS(03) = 0.00
      TARGET_PRESS(04) =  1.0E4  SIGMA_PRESS(04) = 1.0  R_PRESS(04) =  3.3  PHI_PRESS(04) =  0.0  Z_PRESS(04) = 0.00
      TARGET_PRESS(05) =  1.0E4  SIGMA_PRESS(05) = 1.0  R_PRESS(05) =  3.4  PHI_PRESS(05) =  0.0  Z_PRESS(05) = 0.00
    !------------------------------------------------------------------------
    !       Electron Density profile [m^-3]
    !         See Pressure above (not normalized)
    !------------------------------------------------------------------------
      TARGET_NE(01) =  1.0E4  SIGMA_NE(01) = 1.0  R_NE(01) =  3.0  PHI_NE(01) =  0.0  Z_NE(01) = 0.00
      TARGET_NE(02) =  1.0E4  SIGMA_NE(02) = 1.0  R_NE(02) =  3.0  PHI_NE(02) =  0.0  Z_NE(02) = 0.00
      TARGET_NE(03) =  1.0E4  SIGMA_NE(03) = 1.0  R_NE(03) =  3.0  PHI_NE(03) =  0.0  Z_NE(03) = 0.00
    !------------------------------------------------------------------------
    !       Electron Temperature profile
    !         See Pressure above
    !------------------------------------------------------------------------
      TARGET_TE(01) =  1.0E4  SIGMA_TE(01) = 1.0  R_TE(01) =  3.0  PHI_TE(01) =  0.0  Z_TE(01) = 0.00
      TARGET_TE(02) =  1.0E4  SIGMA_TE(02) = 1.0  R_TE(02) =  3.0  PHI_TE(02) =  0.0  Z_TE(02) = 0.00
      TARGET_TE(03) =  1.0E4  SIGMA_TE(03) = 1.0  R_TE(03) =  3.0  PHI_TE(03) =  0.0  Z_TE(03) = 0.00
    !------------------------------------------------------------------------
    !       Ion Temperature profile
    !         See Pressure above
    !------------------------------------------------------------------------
      TARGET_TI(01) =  1.0E4  SIGMA_TI(01) = 1.0  R_TI(01) =  3.0  PHI_TI(01) =  0.0  Z_TI(01) = 0.00
      TARGET_TI(02) =  1.0E4  SIGMA_TI(02) = 1.0  R_TI(02) =  3.0  PHI_TI(02) =  0.0  Z_TI(02) = 0.00
      TARGET_TI(03) =  1.0E4  SIGMA_TI(03) = 1.0  R_TI(03) =  3.0  PHI_TI(03) =  0.0  Z_TI(03) = 0.00
    !------------------------------------------------------------------------
    !       Line Integrated Electron Density (256 chords possible)
    !         Line defined from (R0,PHI0,Z0) to (R1,PHI1,Z1)
    !         Simpsons Integral over 256 points across equilibrium
    !------------------------------------------------------------------------
      TARGET_NE_LINE(01) = 1.0E19  SIGMA_NE_LINE(01) = 1.0E18
        R0_NE_LINE(01) = 1.0  PHI0_NE_LINE(01) = 3.14  Z0_NE_LINE(01) = 0.0
        R1_NE_LINE(01) = 5.0  PHI1_NE_LINE(01) = 3.14  Z1_NE_LINE(01) = 0.0
      TARGET_NE_LINE(02) = 2.0E19  SIGMA_NE_LINE(02) = 1.0E18
        R0_NE_LINE(02) = 2.5  PHI0_NE_LINE(02) = 3.14  Z0_NE_LINE(02) = -1.0
        R1_NE_LINE(02) = 2.5  PHI1_NE_LINE(02) = 3.14  Z1_NE_LINE(02) = 1.0
    !------------------------------------------------------------------------
    !       Faraday Rotation (256 chords possible)
    !         Line integral of ne B dot dl
    !         See Line Integrated Electron Density above
    !------------------------------------------------------------------------
      TARGET_FARADAY(01) = 1.0E19  SIGMA_FARADAY(01) = 1.0E18
        R0_FARADAY(01) = 1.0  PHI0_NE_LINE(01) = 3.14  Z0_FARADAY(01) = 0.0
        R1_FARADAY(01) = 5.0  PHI1_NE_LINE(01) = 3.14  Z1_FARADAY(01) = 0.0
      TARGET_FARADAY(02) = 2.0E19  SIGMA_FARADAY(02) = 1.0E18
        R0_FARADAY(02) = 2.5  PHI0_FARADAY(02) = 3.14  Z0_FARADAY(02) = -1.0
        R1_FARADAY(02) = 2.5  PHI1_FARADAY(02) = 3.14  Z1_FARADAY(02) = 1.0
    !------------------------------------------------------------------------
    !       Motional Stark Effect Diagnostic (256 points possible)
    !         Calculates the motional stark effect diagnostic response at a
    !            point in R,PHI,Z
    !         AX_MSE are the coefficients used in the calculation
    !         VAC_MSE is a vacuum signal which is added to the target
    !            (plasma only) signal.  If any LEXTCUR is set to true,
    !            MAGDIAG_COIL (see below) is utilized to recalculate the
    !            VAC_MSE signal.
    !------------------------------------------------------------------------
      TARGET_MSE(01) = 1.0E-2  SIGMA_MSE(01) = 1.0E-4  VAC_MSE(01) = -1.0E-3
        R_MSE(01) = 2.5  PHI_MSE(01) = 1.04  Z_MSE(01) = 1.0
        A1_MSE(01) = 1.0E-4  A2_MSE(01) = 2.0E-3  A3_MSE(01) = -1.0E-4
        A4_MSE(01) = 5.0E-4  A5_MSE(01) = 3.0E-3  A6_MSE(01) = 8.0E-4
        A7_MSE(01) = 3.0E-4
    !------------------------------------------------------------------------
    !       Magnetic Diagnostics
    !         MAGDIAG_COIL is used to provide a vacuum signal to the diagnostics.  It must
    !            be included if any LEXTCUR is set to true.  If not supplied only plasma
    !            response will be calculated.
    !         TARGET_BPROBES  B-Probe Targeting
    !         TARGET_FLUXLOOP Fluxloop Targeting
    !         TARGET_ROGOWSKI Rogowski Coil Targeting
    !         Note that the DIGANO_IN namelist must either appear in this file or
    !         in a diagno.control file in the same directory.  See the DIAGNO code for
    !         descriptions of how to specify the diagnostics.
    !------------------------------------------------------------------------
      MAGDIAG_COIL = '/u/me/coil_dir/coils.mymachine'
      TARGET_BPROBE(01) = 1.0  SIGMA_BPROBE(01) = 0.01
      TARGET_BPROBE(02) = 1.1  SIGMA_BPROBE(02) = 0.01
      TARGET_BPROBE(03) = 1.3  SIGMA_BPROBE(03) = 0.01
      TARGET_BPROBE(04) = 0.5  SIGMA_BPROBE(04) = 0.01
      TARGET_FLUXLOOP(01) = 1.0E-2  SIGMA_FLUXLOOP(01) = 1.0E-4
      TARGET_FLUXLOOP(02) = 0.5E-2  SIGMA_FLUXLOOP(02) = 1.0E-4
      TARGET_FLUXLOOP(03) = 3.5E-2  SIGMA_FLUXLOOP(03) = 1.0E-4
      TARGET_ROGOWSKI(01) = 5.0E-1  SIGMA_ROGOWSKI(01) = 2.2E-3
    !------------------------------------------------------------------------
    !       Separatrix Targeting (256x256 grid possible)
    !         A 256x256 grid of points in R, PHI, Z space which the code will attempt to
    !        match with the equilibrium.  In general TARGET should be set to zero.
    !------------------------------------------------------------------------
      TARGET_SEPARATRIX(01,01) = 0.0  SIGMA_SEPARATRIX(01,01) = 1.0E-3
        R_SEPARATRIX(01,01) = 2.5  PHI_SEPARATRIX(01,01) = 0.0  Z_SEPARATRIX(01,01) = 0.0
      TARGET_SEPARATRIX(02,01) = 0.0  SIGMA_SEPARATRIX(02,01) = 1.0E-3
        R_SEPARATRIX(02,01) = 5.0  PHI_SEPARATRIX(02,01) = 0.0  Z_SEPARATRIX(02,01) = 0.0
    /