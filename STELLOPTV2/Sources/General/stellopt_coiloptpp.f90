!-----------------------------------------------------------------------
!     Subroutine:    stellopt_coiloptpp
!     Authors:       S. Lazerson (lazerson@pppl.gov)
!     Date:          01/19/15
!     Description:   This subroutine is called to invoke the
!                    coilopt++ code.
!-----------------------------------------------------------------------
      SUBROUTINE stellopt_coiloptpp(file_str,lscreen)
!-----------------------------------------------------------------------
!     Libraries
!-----------------------------------------------------------------------
      USE stellopt_runtime
      USE stellopt_input_mod
      USE stellopt_vars
      USE iso_c_binding
      USE neswrite, ONLY: coil_separation
      USE mpi_params     
      
!-----------------------------------------------------------------------
!     Subroutine Parameters
!----------------------------------------------------------------------
      IMPLICIT NONE
      CHARACTER(256), INTENT(inout)    :: file_str
      LOGICAL, INTENT(inout)        :: lscreen
!DEC$ IF DEFINED (COILOPTPP)
      INCLUDE 'coilopt_f.h'
!DEC$ ENDIF
!-----------------------------------------------------------------------
!     Local Variables
!        iverb         Coilopt++ screen control
!        istat         Error status
!        iunit         File unit number
!        bnfou/_c      B-Normal Fourier coefficients
!----------------------------------------------------------------------
      LOGICAL :: lexists
      INTEGER :: iverb, istat, nu, nv, mf, nf, md, nd, iunit, m, n, &
                 ivmec, ispline_file
      REAL(rprec), ALLOCATABLE, DIMENSION(:,:) :: bnfou, bnfou_c
      CHARACTER(8)   :: temp_str
      CHARACTER(256) :: copt_fext

!----------------------------------------------------------------------
!     BEGIN SUBROUTINE
!----------------------------------------------------------------------
!DEC$ IF DEFINED(COILOPTPP)
      ! reset the params file
      copt_fext = 'coilopt_params'//CHAR(0)
      CALL init_settings(MPI_COMM_MYWORLD,copt_fext)
      ! initialize
      iverb = 0
      ivmec = 0
      ispline_file = 0
      copt_fext = 'coilopt_params.'//TRIM(file_str)
      ! Have master run bnorm
      nu = nu_bnorm
      nv = nv_bnorm
      mf=24; nf=10; md=24; nd=20; coil_separation = 0.33;
      IF (myworkid == master) THEN
         IF (lscreen) WRITE(6,'(a)') ' ---------------------------  COILOPT++ OPTIMIZATION  -------------------------'
         ! Run BNORM code
         ALLOCATE(bnfou(0:mf,-nf:nf),bnfou_c(0:mf,-nf:nf),STAT=istat)
         IF (lscreen) WRITE(6,"(A)") '   - Calculating B-Normal File'
         CALL bnormal(nu,nv,mf,nf,md,nd,bnfou,bnfou_c,TRIM(file_str)//'.nc')
         IF (lscreen) WRITE(6,"(A,ES22.12E3)") '      Max. B-Normal: ',MAXVAL(MAXVAL(bnfou,DIM=2),DIM=1)
         IF (lscreen) WRITE(6,"(A,ES22.12E3)") '      MIN. B-Normal: ',MINVAL(MINVAL(bnfou,DIM=2),DIM=1)
         ! WRITE BNORMAL
         CALL safe_open(iunit, istat, 'bnorm.' // TRIM(file_str), 'replace','formatted')
         DO m = 0, mf
            DO n = -nf, nf
               WRITE(iunit,"(1x,2i5,ES22.12E3)") m,n,bnfou(m,n)
            END DO
         END DO
         CLOSE(iunit)
         DEALLOCATE(bnfou,bnfou_c)
         IF (lscreen) WRITE(6,"(A)") '      Coefficients output to:   '//'bnorm.' // TRIM(file_str)
         ! Turn on screen output
         IF (lscreen) iverb = 1
      END IF
      CALL MPI_BCAST(iverb,1,MPI_INTEGER, master, MPI_COMM_MYWORLD,ierr_mpi)
      IF (ierr_mpi /= MPI_SUCCESS) CALL handle_err(MPI_ERR,'stellopt_coiloptpp1',ierr_mpi)
      ! Update file names
      INQUIRE(FILE='wout_'//TRIM(file_str)//'.nc',EXIST=lexists)
      IF (lexists) ivmec = 1
      DO m = 0, numws-1
          ispline_file = 0
          WRITE(temp_str,'(I3.3)') m
          INQUIRE(FILE='coil_spline'//TRIM(temp_str)//'_reset_file.out',EXIST=lexists)
          IF (lexists) ispline_file = 1
      END DO
      CALL coilopt_update_parameters(nu,nv,ivmec,ispline_file,iverb,TRIM(file_str))
      CALL MPI_BARRIER(MPI_COMM_MYWORLD,ierr_mpi)
      IF (ierr_mpi /= MPI_SUCCESS) CALL handle_err(MPI_ERR,'stellopt_coiloptpp2',ierr_mpi)
      ! Output the file
      CALL coilopt_writeparams(MPI_COMM_MYWORLD,TRIM(copt_fext))
      ! Run init
      CALL MPI_BARRIER(MPI_COMM_MYWORLD,ierr_mpi)
      IF (ierr_mpi /= MPI_SUCCESS) CALL handle_err(MPI_ERR,'stellopt_coiloptpp3',ierr_mpi)
      IF (lscreen) WRITE(6,"(A)") '   - Initializing COILOPT++ '
      CALL coilopt_init(MPI_COMM_MYWORLD,TRIM(copt_fext))
      ! Run Coilopt++
      IF (lscreen) WRITE(6,"(A)") '   - Executing COILOPT++ '
      CALL coilopt_run(MPI_COMM_MYWORLD,iverb,TRIM(file_str))
      ! Write Output
      CALL coilopt_writeoutput(MPI_COMM_MYWORLD,TRIM(file_str))
      CALL MPI_BARRIER(MPI_COMM_MYWORLD,ierr_mpi)
      IF (lscreen) WRITE(6,'(a)') ' ---------------------------      COILOPT++ DONE      -------------------------'
!DEC$ ENDIF
      RETURN
!----------------------------------------------------------------------
!     END SUBROUTINE
!----------------------------------------------------------------------
      END SUBROUTINE stellopt_coiloptpp