# Tutorial: Optimization of iota using Levenberg-Marquardt

This tutorial walks the user through using STELLOPT to optimize a simple configuration throught fixed boundary shaping.

----

## Edit the input namelist text file.
The input namelist (input.STELLOPT_IOTA_LMDIF) contains the VMEC INDATA name list for a simple rotating ellipse equilibrium. And the STELLOPT OPTIMUM name which optimizes this equilibrium (varying the boundary harmonics and targeting the rotational transform).

```
&INDATA
!----- Runtime Parameters -----
  DELT =    0.9000000000000E+000
  NSTEP = 200
  TCON0 =    1.000000000000E+000
  NS_ARRAY =                16            25            36            
  FTOL_ARRAY =    1.000000E-06  1.000000E-09  1.000000E-13
  NITER_ARRAY =           1000          1000         10000
  PRECON_TYPE = 'none'
  PREC2D_THRESHOLD =   1.000000E-19
!----- Grid Parameters -----
  LASYM = F
  NFP = 0001
  MPOL = 005
  NTOR = 001
  PHIEDGE =   1.0
!----- Free Boundary Parameters -----
  LFREEB = F
!----- Pressure Parameters -----
  GAMMA =    0.000000000000E+000
  BLOAT =    1.000000000000E+000
  SPRES_PED =    1.000000000000E+000
  PRES_SCALE =    0.000000000000E+000
  PMASS_TYPE = 'power_series'  
  AM =   0.00000000000000E+00
!----- Current/Iota Parameters -----
  CURTOR =  0.0
  NCURR = 1
  PCURR_TYPE = 'power_series'
  AC =  0.0
!----- Axis Parameters -----
  RAXIS =   1.0
  ZAXIS =   0.0
!----- Boundary Parameters -----
  RBC( 00,00) = 1.00  ZBS( 00,00) = 0.00
  RBC( 00,01) = 0.10  ZBS( 00,01) = 0.10
  RBC( 01,01) = 0.01  ZBS( 01,01) =-0.01
  RBC( 01,03) = 0.01  ZBS( 01,03) = 0.01
/
&OPTIMUM
!-----------------------------------------------------------------------
!          OPTIMIZER RUN CONTROL PARAMETERS
!-----------------------------------------------------------------------
  NFUNC_MAX  =  1000
  EQUIL_TYPE = 'VMEC2000'
  OPT_TYPE   = 'LMDIF'
  FTOL       =   1.00E-06
  XTOL       =   1.00E-06
  GTOL       =   1.00E-30
  FACTOR     =   10.0
  EPSFCN     =   1.00E-06
  MODE       = 1
  LKEEP_MINS = T
!-----------------------------------------------------------------------
!          OPTIMIZED QUANTITIES
!-----------------------------------------------------------------------
   LBOUND_OPT(001,001) = T
   LBOUND_OPT(001,003) = T
!------------------------------------------------------------------------
!       IOTA PROFILE TARGETS
!------------------------------------------------------------------------
  TARGET_IOTA(001) =   0.1000  SIGMA_IOTA(001) =   0.0100  S_IOTA(001) =   0.0000
  TARGET_IOTA(002) =   0.1000  SIGMA_IOTA(002) =   0.0100  S_IOTA(002) =   0.25
  TARGET_IOTA(003) =   0.1000  SIGMA_IOTA(003) =   0.0100  S_IOTA(003) =   0.50
  TARGET_IOTA(004) =   0.1000  SIGMA_IOTA(004) =   0.0100  S_IOTA(004) =   1.0
/
```

## Execute the code.
The STELLOPT code is executed by passing the input file as an argument to the STELLOPT code. Note that since STELLOPT is a parallel code, it should be executed using a wrapper (such as mpirun, mpiexec, srun, etc.)

```
>mpirun -np 8 ~/bin/xstelloptv2 input.STELLOPT_IOTA_LMDIF
STELLOPT Version  2.49
  Equilibrium calculation provided by: 
  =================================================================================
  =========       Variational Moments Equilibrium Code (v 8.52)           =========
  =========                (S. Hirshman, J. Whitson)                      =========
  =========         http://vmecwiki.pppl.wikispaces.net/VMEC              =========
  =================================================================================
     
 -----  Optimization  -----
    =======VARS=======
     RBC( 001, 001):  Radial Boundary Specification (COS)
     ZBS( 001, 001):  Vertical Boundary Specification (SIN)
     RBC( 001, 003):  Radial Boundary Specification (COS)
     ZBS( 001, 003):  Vertical Boundary Specification (SIN)
    ======TARGETS=====
     Rotational Transform
    ==================
    Number of Processors:            8
    Number of Parameters:            4
    Number of Targets:               4
    !!!! EQUILIBRIUM RESTARTING NOT UTILIZED !!!!
    ========Parallel Code Execution Info=======
    Number of Processors:                       8
    Number of Optimization Threads:            -1
    Workers per optimizer thread:                -8
    Number of Optimizer Threads:               8
     OPTIMIZER: Levenberg-Mardquardt
     NFUNC_MAX:         1000
         FTOL:     1.0000E-06
         XTOL:     1.0000E-06
         GTOL:     1.0000E-30
       EPSFCN:     1.0000E-06
          MODE:            1
        FACTOR:    10.000000000000000     
 Warning: more processors have been requested than the maximum (nvar) required =            4
 ---------------------------  EQUILIBRIUM CALCULATION  ------------------------
  NS =   16 NO. FOURIER MODES =   14 FTOLV =  1.000E-06 NITER =   1000
  ITER    FSQR      FSQZ      FSQL    RAX(v=0)    DELT       WMHD
    1  7.45E-01  5.05E-01  2.30E-01  1.000E+00  9.00E-01  1.0432E+02
  118  4.48E-07  2.85E-07  3.90E-08  9.970E-01  7.08E-01  9.7789E+01
  NS =   25 NO. FOURIER MODES =   14 FTOLV =  1.000E-09 NITER =   1000
  ITER    FSQR      FSQZ      FSQL    RAX(v=0)    DELT       WMHD
    1  4.11E-04  2.18E-04  9.80E-07  9.970E-01  9.00E-01  9.7789E+01
  200  4.61E-09  1.42E-09  1.09E-09  9.972E-01  6.37E-01  9.7789E+01
  289  9.75E-10  1.73E-10  1.74E-10  9.976E-01  6.37E-01  9.7789E+01
  NS =   36 NO. FOURIER MODES =   14 FTOLV =  1.000E-13 NITER =  10000
  ITER    FSQR      FSQZ      FSQL    RAX(v=0)    DELT       WMHD
    1  1.82E-04  1.18E-04  2.26E-07  9.976E-01  9.00E-01  9.7789E+01
  200  1.51E-08  6.31E-09  4.71E-09  9.971E-01  6.18E-01  9.7789E+01
  400  8.50E-10  2.78E-10  1.41E-10  9.983E-01  6.18E-01  9.7789E+01
  600  1.82E-10  5.17E-11  3.50E-11  1.000E+00  6.18E-01  9.7789E+01
  800  4.25E-11  1.19E-11  6.84E-12  1.002E+00  6.18E-01  9.7789E+01
 1000  1.82E-11  2.92E-12  1.87E-12  1.003E+00  6.18E-01  9.7789E+01
 1200  5.39E-12  7.38E-13  6.01E-13  1.004E+00  6.18E-01  9.7789E+01
 1400  1.04E-12  3.08E-13  1.45E-13  1.004E+00  6.18E-01  9.7789E+01
 1600  2.17E-13  1.01E-13  2.43E-14  1.004E+00  6.18E-01  9.7789E+01
 1660  9.57E-14  2.98E-14  1.54E-14  1.004E+00  6.18E-01  9.7789E+01
 EXECUTION TERMINATED NORMALLY
 FILE : reset_file
 NUMBER OF JACOBIAN RESETS =    3
    TOTAL COMPUTATIONAL TIME               4.09 SECONDS
    TIME TO READ IN DATA                   0.00 SECONDS
    TIME TO WRITE DATA TO WOUT             0.01 SECONDS
    TIME IN EQFORCE                        0.14 SECONDS
    TIME IN FOURIER TRANSFORM              1.04 SECONDS
    TIME IN INVERSE FOURIER XFORM          0.78 SECONDS
    TIME IN FORCES + SYMFORCES             0.85 SECONDS
    TIME IN BCOVAR                         0.76 SECONDS
    TIME IN RESIDUE                        0.09 SECONDS
    TIME (REMAINDER) IN FUNCT3D            0.35 SECONDS
 ---------------------------  VMEC CALCULATION DONE  -------------------------
     ASPECT RATIO:    9.901
             BETA:    0.000  (total)
                      0.000  (poloidal)
                      0.000  (toroidal)
  TORIDAL CURRENT:    0.803664860355E-10
     TORIDAL FLUX:    1.000
           VOLUME:    0.201
     MAJOR RADIUS:    1.000
     MINOR_RADIUS:    0.101
    STORED ENERGY:    0.000000000000E+00
 Beginning Levenberg-Marquardt Iterations
 Number of Processors:    8
======================================================================
  Iteration   Processor       Chi-Sq       LM Parameter      Delta Tol
======================================================================
       0          0         1.7927E+02
       1          1         1.7917E+02  -
       3          3         1.7920E+02  -
       4          4         1.7921E+02  -
       2          2         1.7937E+02  +
       5          1         1.0000E+12      1.8158E-05      6.9004E+01
       6          2         7.5974E+00*     9.5200E-01      5.4202E+00
       7          3         1.5923E+02      5.2374E+01      4.2575E-01
       8          4         1.7770E+02      7.0796E+02      3.3442E-02
       9          5         1.7914E+02      9.0542E+03      2.6269E-03
      10          6         1.7926E+02      1.1208E+05      2.0634E-04
      11          7         1.7927E+02      1.4678E+06      1.6208E-05
      12          8         1.7927E+02      1.8690E+07      1.2731E-06
  
  new minimum =  7.597E+00  lm-par =  4.760E-01  delta-tol =  1.138E+01
  .
  .
  .                                                                  
```

The screen output begins with basic information about the input parameters and how STELLOPT will be run. Then for the first iteration, the full VMEC screen output is shown along with information about the equilibrium. If secondary codes had been run, their output would be printed to the screen as well. Once the code enters the full optimization loop, only the values relevant to optimization are printed. For the OPT_TYPE="LMDIF" there are two phases for each minima. First three numbers are output: iteration number, processor number and chi-squared. These are the forward finite difference of the parameter space jacobian. The sign after each evaluation indicates if the resulting finite difference is uphill (+) or downhill (-). After which each processor evaluates a point along the descent direction, varying the Levenberg-Marquardt parameter. The minimum value is denoted by an asterisk. A message regarding the discovery of the new minima is then printed (if found) and the process repeats. It is possible that this step will fail to find a minima with smaller chi-squared than found during the parameter space jacobian step. If this occurs, a routine which searches finite difference combinations of the jacobian evaluation is executed.

## Examine the output.
The code outputs various 'temporary' files which can be removed at the end of a run. These files can easily be removed by the command 'rm *_opt*'. What remains are files for each minimum found by the VMEC (input, mercier, jxbout, and wout). In addition, STELLOPT outputs the fevals, jacobian, stellopt, var_labels, and xvec files. The STELLOPT file contains an ordered output of the various minima found.

```
VERSION  2.49
ITER 00000
IOTA   004  007
R  PHI  Z  S  TARGET  SIGMA  IOTA
   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   1.000000000000E-001   1.000000000000E-002   2.43581915148
5E-002
   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   2.500000000000E-001   1.000000000000E-001   1.000000000000E-002   3.00248805029
0E-002
   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   5.000000000000E-001   1.000000000000E-001   1.000000000000E-002   3.47181147281
2E-002
   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   1.000000000000E+000   1.000000000000E-001   1.000000000000E-002   4.48006532328
9E-002
TARGETS          1         4
TARGETS
   1.000000000000E-001
   1.000000000000E-001
   1.000000000000E-001
   1.000000000000E-001
SIGMAS          1         4
SIGMAS
   1.000000000000E-002
   1.000000000000E-002
   1.000000000000E-002
   1.000000000000E-002
VALS          1         4
VALUES
   2.435819151485E-002
   3.002488050290E-002
   3.471811472812E-002
   4.480065323289E-002
```

Every iteration is stored in this file.  Each chi-squared module outputs detailed information into the file and the full components of the chi-squared vector are output as well.