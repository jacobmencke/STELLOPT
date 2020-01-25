Tutorial: VMEC2PIES NCSX Example
================================

This tutorial will walk the user through running VMEC2PIES from a free
boundary VMEC calculation. For this example the National Compact
Stellarator Experiment (NCSX) configuration will be used. This machine
is stellarator symmetric with a periodicity of three. If not already
done, please see the
[VMEC Free Boundary NCSX tutorial](VMEC Free Boundary Run) to generate
the necessary input files.

------------------------------------------------------------------------

\> 1. **\_\_Setup files.\_\_** \> We will be generating a fixed boundary
and free boundary PIES .in file from the free boundary VMEC tutorial.
Begin by creating a PIES\_NCSX\_fixed and a PIES\_NCSX\_free directory.
Copy the wout and input files from VMEC to each directory.

\> 2. **\_\_Create a fixed boundary PIES .in file\_\_** \> In the
PIES\_NCSX\_fixed directory we should now have a
wout\_ncsx\_c09r00\_free.nc and input.ncsx\_c09r00\_free files. We now
generate the PIES input file by envoking VMEC2PIES with the wout file
and fixed attributes. The PIES run will have the same radial and Fourier
resolution as that of the VMEC run. This should generate an
ncsx\_c09r00\_free.in file (which you should rename
ncsx\_c09r00\_fixed.in to avoid confusion,
[examples/ncsx\_c09r00\_fixed.in](examples/ncsx_c09r00_fixed.in)).

     ~/bin_847/xvmec2pies wout_ncsx_c09r00_free.nc -fixed
     -----PIES File Parameters-----
       extsurfs:  0
       Fixed Boundary Enforced!
     -----VMEC File Parameters-----
        file: ncsx_c09r00_free_847
           m:  10   nu:  41
           n:   6   nv:  25
       mnmax:  143  nuv: 1025   nuvp:  3075
         nfp:   3
          ns:  99
      lfreeb:   T
        iota: [ 0.208, 0.933]
    torflux_edge:  0.497
    Total Current: -178.653 [kA]
     -----PIES File Parameters-----
        file: ncsx_c09r00_free_847.in
           k:  99 lpinch:  99
           m:  20    mda:  20
           n:  12    nda:  12
         nfp:   3
       freeb:   0
        rmaj:   0.757
       betai: 0.13223628597144E-01
        iote: -.35730636631292E-01
    mustochf:   0

\> 3. **\_\_Create a free bondary PIES .in file\_\_** \> In the
PIES\_NCSX\_free directory we should now have a
wout\_ncsx\_c09r00\_free.nc and input.ncsx\_c09r00\_free files. We will
also need a coils file, so create a symbolic link (ln -s) to the
coils.c09r00 file. We run VMEC2PIES as before but with the -fixed
attribute omitted and a coils file. Additionally we wish to add 10
external surfaces so we ask for 10 surfaces.

    >~/bin/xvmec2pies wout_ncsx_c09r00_free.nc -c coils.c09r00 -extsurf 10

\> This should generate a coil\_data file and a
pies.ncsx\_c09r00\_free.in file.