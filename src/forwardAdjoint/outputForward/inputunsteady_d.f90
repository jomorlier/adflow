   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
   !
   !      ==================================================================
   MODULE INPUTUNSTEADY_D
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Input parameters for unsteady problems.                        *
   !      *                                                                *
   !      ******************************************************************
   !
   USE ACCURACY
   IMPLICIT NONE
   SAVE 
   ! Definition of the parameters for the time integration scheme.
   INTEGER(kind=inttype), PARAMETER :: bdf=1, explicitrk=2, implicitrk=3&
   & , md=4
   ! timeIntegrationScheme: Time integration scheme to be used for
   !                        unsteady problems. Possibilities are
   !                        Backward difference schemes, explicit
   !                        RungeKutta schemes and implicit
   !                        RungeKutta schemes.
   INTEGER(kind=inttype) :: timeintegrationscheme
   ! timeAccuracy:     Accuracy of the time integrator for unsteady
   !                   problems. Possibilities are 1st, 2nd and 3rd
   !                   order accurate schemes.
   ! nTimeStepsCoarse: Number of time steps on the coarse mesh;
   !                   only relevant for periodic problems for
   !                   which a full mg can be used.
   ! nTimeStepsFine:   Number of time steps on the fine mesh.
   ! deltaT:           Physical time step in seconds.
   INTEGER(kind=inttype) :: timeaccuracy
   INTEGER(kind=inttype) :: ntimestepscoarse, ntimestepsfine
   REAL(kind=realtype) :: deltat
   ! nRKStagesUnsteady:   Number of stages used in the Runge-Kutta
   !                      schemes for a time accurate computation.
   ! betaRKUnsteady(:,:): Matrix with the Runge-Kutta coefficients
   !                      for the residuals.
   ! gammaRKUnsteady(:):  Vector with the time portion of the
   !                      Runge-Kutta stages.
   INTEGER(kind=inttype) :: nrkstagesunsteady
   REAL(kind=realtype), DIMENSION(:, :), ALLOCATABLE :: betarkunsteady
   REAL(kind=realtype), DIMENSION(:), ALLOCATABLE :: gammarkunsteady
   ! nOldGridRead: Number of old grid levels read from the grid
   !               files. Needed only for a consistent restart
   !               on the deforming meshes.
   INTEGER(kind=inttype) :: noldgridread
   ! updateWallDistanceUnsteady: Whether or not to update the wall
   !                             distance in unsteady mode. For a
   !                             RANS simulation on a changing grid
   !                             this should be done if the
   !                             turbulence model requires the wall
   !                             distance. However, the user may
   !                             overrule this if he thinks it is
   !                             not necessary.
   LOGICAL :: updatewalldistanceunsteady
   END MODULE INPUTUNSTEADY_D
