!-----------------------------------------------------------------------
!     Subroutine:    chisq_ptsm3d
!     Authors:       B. Faber (bfaber@wisc.edu)
!     Date:          02/07/2018
!     Description:   Chisq routine for PTSM3D
!                    general all chisq routines should take a target
!                    variable, a sigma variable, and and error flag. On
!                    entry, if iter is less than 1 the
!                    code should simply increment the mtargets value by
!                    the number of sigmas less than bigno.  On entry, if
!                    iflag is set to a positive number the code should
!                    output to screen.  On entry, if iflag is set to
!                    zero the code should operate with no screen output.
!                    On exit, negative iflag terminates execution,
!                    positive iflag, indicates error but continues, and
!                    zero indicates the code has functioned properly.
!-----------------------------------------------------------------------
      SUBROUTINE chisq_ptsm3d(target,sigma,niter,iflag)
!-----------------------------------------------------------------------
!     Libraries
!-----------------------------------------------------------------------
      USE stellopt_runtime
      USE stellopt_targets
      USE stellopt_input_mod

      USE ptsm3d_setup
      USE ptsm3d_targets
      
!-----------------------------------------------------------------------
!     Input/Output Variables
!
!-----------------------------------------------------------------------
      IMPLICIT NONE
      REAL(rprec), INTENT(in)    ::  target
      REAL(rprec), INTENT(in)    ::  sigma
      INTEGER,     INTENT(in)    ::  niter
      INTEGER,     INTENT(inout) ::  iflag
      INTEGER :: iunit
      
!-----------------------------------------------------------------------
!     Local Variables
!
!-----------------------------------------------------------------------

!----------------------------------------------------------------------
!     BEGIN SUBROUTINE
!----------------------------------------------------------------------
      IF (iflag < 0) RETURN
      IF (iflag == 1) WRITE(iunit_out,'(A,2(2X,I3.3))') 'PTSM3D ',1,4
      IF (iflag == 1) WRITE(iunit_out,'(A)') 'TARGET  SIGMA  DUMMY  CHI'
      IF (niter >= 0) THEN
         ! A note on how to calculate temp_val.
         ! If target value is designed to be a limiter type target
         ! (wall in parameter space) please define temp_val via a
         ! hyperbolic tangent with width equal to 4-5 times EPSFCN.
         ! This will allow the code to properly handle the optimization
         ! process, define a gradient in search space.
         mtargets = mtargets + 1
         targets(mtargets) = target
         sigmas(mtargets)  = sigma
! Need to add case if ptsm3d_target is zero
         vals(mtargets)    = 1.0/ptsm3d_target
         !vals(mtargets)    = 1.0
         IF (iflag == 1) WRITE(iunit_out,'(3ES22.12E3)') target,sigma,0.0,vals(mtargets)
         IF (iflag == 1) WRITE(iunit_out,'(A,ES22.12E3)') &
            & "PTSM3D_TARGET = ", ptsm3d_target
      ELSE
         IF (sigma < bigno) THEN
            mtargets = mtargets + 1
            IF (niter == -2) target_dex(mtargets)=jtarget_ptsm3d
            CALL safe_open(iunit, iflag, &
              & TRIM('input.'//TRIM(id_string)),'old','formatted')
            CALL PTSM3D_read_stellopt_input(iunit, iflag)
            close(iunit)
         END IF
      END IF
      RETURN
!----------------------------------------------------------------------
!     END SUBROUTINE
!----------------------------------------------------------------------
      END SUBROUTINE chisq_ptsm3d