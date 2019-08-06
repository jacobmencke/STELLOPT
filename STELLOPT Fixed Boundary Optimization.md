Tutorial: Understanding STELLOPT Fixed Boundary Optimization
============================================================

This tutorial explains how to preform a fixed boundary optimization
where boundary coefficients are varied to achieve target parameters.
There are currently three ways of preforming such an optimization: VMEC
boundary coefficients, Hirshman-Breslau coefficients, and Garabedian
coefficients. In the first representation the RBC\'s and ZBS\'s are each
independently varied by STELLOPT. In the Hirshman-Breslau and Garabedian
representations the VMEC coefficients in the INDATA namelist are
converted to a new representation and these coefficients are optimized.

------------------------------------------------------------------------

VMEC Coefficients
-----------------

The LBOUND\_OPT(N,M) logical array controls the ability to directly vary
the VMEC RBC/ZBS arrays. If LASYM=F is set in the VMEC INDATA namelist,
an RBC and ZBS coefficient for the given mode pair in LBOUND\_OPT(N,M)
is loaded into the parameters to be varied. Thus if LBOUND\_OPT(-1,1) =
T is set in OPTIMUM the RBC(-1,1) and ZBS(-1,1) parameters are varied.
If LASYM=T in the VMEC INDATA namelist, the RBS and ZBC coefficients are
included as well for that set of mode numbers. It is important to note
that such a representation is not unique so the other representations
are suggested instead.

------------------------------------------------------------------------

Hirshman-Breslau Coefficients
-----------------------------

The LRHO\_OPT(N,M) logical array controls the ability to utilize the
Hirshman-Breslau representation of the VMEC boundary. This
representation utilizes a rho coordinate to define the boundary. Thus
for every LRHO\_OPT set to true, only one variable is loaded if LASYM=F
in the VMEC INDATA namelist. In order to transform to this
representation the code must first take the VMEC boundary definition and
convert is to Hirshman-Breslau. This is done by the code if any
LRHO\_OPT is set. STELLOPT will output a conversion accuracy message to
the screen when this is done. The resulting spectrum in RHO will have
one less poloidal mode than VMEC. Once the RHO(N,M) array is calculated,
the modes are loaded into the optimization vector. The major radius is
stored in the RHO(0,0) array element so if one wishes this variable to
be varied LRHO\_OPT(0,0)=T should be set. This representation does not
treat the m=0 modes so if the user wishes STELLOPT to vary the m=0 modes
the LBOUND\_OPT(N,0) modes should be set to true (ignoring the N=0
mode). Setting any of these modes to false is equivalent to setting
LFIX\_NTOR(N) in the older version of STELLOPT to true. A DRHO\_OPT(N,M)
may also be set to control the associated auxiliary variable (see LMDIF
options).

In the following example an MPOL=5, NTOR = 2 equilibrium is loaded into
STELLOPT using the Hirshman-Breslau representation

    &INDATA
      .....
      MPOL = 5
      NTOR = 2
      RBC( 0, 0) = 1.00  ZBS( 0, 0) = 0.00
      RBC( 1, 0) = 0.01  ZBS( 1, 0) = 0.01
      RBC( 2, 0) = 0.01  ZBS( 2, 0) = 0.01
      RBC(-2, 1) = 0.01  ZBS(-2, 1) = 0.01
      RBC(-1, 1) = 0.01  ZBS(-1, 1) = 0.01
      RBC( 0, 1) = 0.50  ZBS( 0, 1) = 0.50
      RBC( 1, 1) = 0.01  ZBS( 1, 1) = 0.01
      RBC( 2, 1) = 0.01  ZBS( 2, 1) = 0.01
      RBC(-2, 2) = 0.01  ZBS(-2, 2) = 0.01
      RBC(-1, 2) = 0.01  ZBS(-1, 2) = 0.01
      RBC( 0, 2) = 0.05  ZBS( 0, 2) = 0.05
      RBC( 1, 2) = 0.01  ZBS( 1, 2) = 0.01
      RBC( 2, 2) = 0.01  ZBS( 2, 2) = 0.01
      RBC(-2, 3) = 0.01  ZBS(-2, 3) = 0.01
      RBC(-1, 3) = 0.01  ZBS(-1, 3) = 0.01
      RBC( 0, 3) = 0.02  ZBS( 0, 3) = 0.02
      RBC( 1, 3) = 0.01  ZBS( 1, 3) = 0.01
      RBC( 2, 3) = 0.01  ZBS( 2, 3) = 0.01
      RBC(-2, 4) = 0.01  ZBS(-2, 4) = 0.01
      RBC(-1, 4) = 0.01  ZBS(-1, 4) = 0.01
      RBC( 0, 4) = 0.02  ZBS( 0, 4) = 0.02
      RBC( 1, 4) = 0.01  ZBS( 1, 4) = 0.01
      RBC( 2, 4) = 0.01  ZBS( 2, 4) = 0.01
    /
    &OPTIMUM
      ...
      LRHO_OPT( 0:2, 0) = 3*T
      LRHO_OPT(-2:2, 1) = 5*T
      LRHO_OPT(-2:2, 2) = 5*T
      LRHO_OPT(-2:2, 3) = 5*T
      LBOUND_OPT(1:2, 0) = 2*T
      ...
    /
    &END

For optimizer choices requiring minimum and maximum bounds on each
variable, the BOUND\_MIN(N,M) and BOUND\_MAX(N,M) arrays will control
extent lower and upper bounds for each variable. The default behavior in
the old version of STELLOPT was to set BOUND\_MIN(N,M) = RHO(N,M)\*0.3
and BOUND\_MAX(N,M) = 2.0\*RHO(N,M) with a check to make sure that
BOUND\_MAX(M,N) \> BOUND\_MIN(N,M) (if not true, the value were
flipped).

------------------------------------------------------------------------

Garabedian representation
-------------------------

The LDELTAMN\_OPT(N,M) logical array controls the ability to utilize the
Garabedian representation of the VMEC boundary. This representation
utilizes a rho coordinate to define the boundary. Thus for every
LDELTAMN\_OPT set to true, only one variable is loaded if LASYM=F in the
VMEC INDATA namelist. In order to transform to this representation the
code must first take the VMEC boundary definition and convert it to that
of Garabedian. This is done by the code if any LDELTAMN\_OPT is set.
STELLOPT will output a conversion accuracy message to the screen when
this is done. The resulting spectrum in RHO will have one less poloidal
mode than VMEC. Once the RHO(N,M) array is calculated, the modes are
loaded into the optimization vector. The major radius is stored in the
RHO(0,0) array element so if one wishes this variable to be varied
LDELTAMN\_OPT(0,0)=T should be set. A DDELTAMN\_OPT(N,M) may also be set
to control the associated auxiliary variable (see LMDIF options).

In the following example a MPOL=4, NTOR = 2 equilibrium is loaded into
STELLOPT using the Garabedian representation

    &INDATA
      .....
      MPOL = 4
      NTOR = 2
      RBC( 0, 0) = 1.00  ZBS( 0, 0) = 0.00
      RBC( 1, 0) = 0.01  ZBS( 1, 0) = 0.01
      RBC( 2, 0) = 0.01  ZBS( 2, 0) = 0.01
      RBC(-2, 1) = 0.01  ZBS(-2, 1) = 0.01
      RBC(-1, 1) = 0.01  ZBS(-1, 1) = 0.01
      RBC( 0, 1) = 0.50  ZBS( 0, 1) = 0.50
      RBC( 1, 1) = 0.01  ZBS( 1, 1) = 0.01
      RBC( 2, 1) = 0.01  ZBS( 2, 1) = 0.01
      RBC(-2, 2) = 0.01  ZBS(-2, 2) = 0.01
      RBC(-1, 2) = 0.01  ZBS(-1, 2) = 0.01
      RBC( 0, 2) = 0.05  ZBS( 0, 2) = 0.05
      RBC( 1, 2) = 0.01  ZBS( 1, 2) = 0.01
      RBC( 2, 2) = 0.01  ZBS( 2, 2) = 0.01
      RBC(-2, 3) = 0.01  ZBS(-2, 3) = 0.01
      RBC(-1, 3) = 0.01  ZBS(-1, 3) = 0.01
      RBC( 0, 3) = 0.02  ZBS( 0, 3) = 0.02
      RBC( 1, 3) = 0.01  ZBS( 1, 3) = 0.01
      RBC( 2, 3) = 0.01  ZBS( 2, 3) = 0.01
    /
    &OPTIMUM
      ...
      LDELTAMN_OPT(-2:2, -4) = 5*T
      LDELTAMN_OPT(-2:2, -3) = 5*T
      LDELTAMN_OPT(-2:2, -2) = 5*T
      LDELTAMN_OPT(-2:2, -1) = 5*T
      LDELTAMN_OPT(-2:2, 0) = 5*T
      LDELTAMN_OPT(-2:2, 1) = 5*T
      LDELTAMN_OPT(-2:2, 2) = 5*T
      LDELTAMN_OPT(-2:2, 3) = 5*T
      LDELTAMN_OPT(-2:2, 4) = 5*T
      ...
    /
    &END