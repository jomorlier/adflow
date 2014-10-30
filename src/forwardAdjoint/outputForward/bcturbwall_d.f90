   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
   !
   !  Differentiation of bcturbwall in forward (tangent) mode (with options i4 dr8 r8):
   !   variations   of useful results: *bvtj1 *bvtj2 *bmtk1 *bmtk2
   !                *bvtk1 *bvtk2 *bmti1 *bmti2 *bvti1 *bvti2 *bmtj1
   !                *bmtj2
   !   with respect to varying inputs: *bvtj1 *bvtj2 *bmtk1 *w *bmtk2
   !                *rlv *bvtk1 *bvtk2 *bmti1 *bmti2 *bvti1 *bvti2
   !                *bmtj1 *bmtj2
   !   Plus diff mem management of: bvtj1:in bvtj2:in bmtk1:in w:in
   !                bmtk2:in rlv:in bvtk1:in bvtk2:in bmti1:in bmti2:in
   !                bvti1:in bvti2:in bmtj1:in bmtj2:in bcdata:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          bcTurbWall.F90                                  *
   !      * Author:        Georgi Kalitzin, Edwin van der Weide            *
   !      * Starting date: 06-26-2003                                      *
   !      * Last modified: 06-12-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE BCTURBWALL_D(nn)
   !
   !      ******************************************************************
   !      *                                                                *
   !      * bcTurbWall applies the implicit treatment of the viscous       *
   !      * wall boundary condition for the turbulence model used to the   *
   !      * given subface nn.                                              *
   !      * It is assumed that the pointers in blockPointers are           *
   !      * already set to the correct block.                              *
   !      *                                                                *
   !      ******************************************************************
   !
   USE BLOCKPOINTERS_D
   USE BCTYPES
   USE FLOWVARREFSTATE
   USE INPUTPHYSICS
   USE CONSTANTS
   USE PARAMTURB
   IMPLICIT NONE
   !
   !      Subroutine arguments.
   !
   INTEGER(kind=inttype), INTENT(IN) :: nn
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: i, j, ii, jj, iimax, jjmax
   REAL(kind=realtype) :: tmpd, tmpe, tmpf, nu
   REAL(kind=realtype) :: tmped, tmpfd, nud
   REAL(kind=realtype), DIMENSION(:, :, :, :), POINTER :: bmt
   REAL(kind=realtype), DIMENSION(:, :, :, :), POINTER :: bmtd
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: bvt, ww2
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: bvtd, ww2d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv2, dd2wall
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv2d
   INTRINSIC MIN
   INTRINSIC MAX
   INTRINSIC ABS
   REAL(kind=realtype) :: abs0d
   REAL(kind=realtype) :: abs0
   INTEGER(kind=inttype) :: y4
   INTEGER(kind=inttype) :: y3
   INTEGER(kind=inttype) :: y2
   INTEGER(kind=inttype) :: y1
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Set some variables depending on the block face on which the
   ! subface is located. Needed for a general treatment.
   SELECT CASE  (bcfaceid(nn)) 
   CASE (imin) 
   iimax = jl
   jjmax = kl
   bmtd => bmti1d
   bmt => bmti1
   bvtd => bvti1d
   bvt => bvti1
   ww2d => wd(2, 1:, 1:, :)
   ww2 => w(2, 1:, 1:, :)
   rlv2d => rlvd(2, 1:, 1:)
   rlv2 => rlv(2, 1:, 1:)
   dd2wall => d2wall(2, :, :)
   CASE (imax) 
   iimax = jl
   jjmax = kl
   bmtd => bmti2d
   bmt => bmti2
   bvtd => bvti2d
   bvt => bvti2
   ww2d => wd(il, 1:, 1:, :)
   ww2 => w(il, 1:, 1:, :)
   rlv2d => rlvd(il, 1:, 1:)
   rlv2 => rlv(il, 1:, 1:)
   dd2wall => d2wall(il, :, :)
   CASE (jmin) 
   iimax = il
   jjmax = kl
   bmtd => bmtj1d
   bmt => bmtj1
   bvtd => bvtj1d
   bvt => bvtj1
   ww2d => wd(1:, 2, 1:, :)
   ww2 => w(1:, 2, 1:, :)
   rlv2d => rlvd(1:, 2, 1:)
   rlv2 => rlv(1:, 2, 1:)
   dd2wall => d2wall(:, 2, :)
   CASE (jmax) 
   iimax = il
   jjmax = kl
   bmtd => bmtj2d
   bmt => bmtj2
   bvtd => bvtj2d
   bvt => bvtj2
   ww2d => wd(1:, jl, 1:, :)
   ww2 => w(1:, jl, 1:, :)
   rlv2d => rlvd(1:, jl, 1:)
   rlv2 => rlv(1:, jl, 1:)
   dd2wall => d2wall(:, jl, :)
   CASE (kmin) 
   iimax = il
   jjmax = jl
   bmtd => bmtk1d
   bmt => bmtk1
   bvtd => bvtk1d
   bvt => bvtk1
   ww2d => wd(1:, 1:, 2, :)
   ww2 => w(1:, 1:, 2, :)
   rlv2d => rlvd(1:, 1:, 2)
   rlv2 => rlv(1:, 1:, 2)
   dd2wall => d2wall(:, :, 2)
   CASE (kmax) 
   iimax = il
   jjmax = jl
   bmtd => bmtk2d
   bmt => bmtk2
   bvtd => bvtk2d
   bvt => bvtk2
   ww2d => wd(1:, 1:, kl, :)
   ww2 => w(1:, 1:, kl, :)
   rlv2d => rlvd(1:, 1:, kl)
   rlv2 => rlv(1:, 1:, kl)
   dd2wall => d2wall(:, :, kl)
   END SELECT
   ! Determine the turbulence model used and loop over the faces
   ! of the subface and set the values of bmt and bvt for an
   ! implicit treatment.
   SELECT CASE  (turbmodel) 
   CASE (spalartallmaras, spalartallmarasedwards) 
   ! Spalart-allmaras type of model. Value at the wall is zero,
   ! so simply negate the internal value.
   DO j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
   DO i=bcdata(nn)%icbeg,bcdata(nn)%icend
   bmtd(i, j, itu1, itu1) = 0.0_8
   bmt(i, j, itu1, itu1) = one
   END DO
   END DO
   CASE (komegawilcox, komegamodified, mentersst) 
   !        ================================================================
   ! K-omega type of models. K is zero on the wall and thus the
   ! halo value is the negative of the first internal cell.
   ! For omega the situation is a bit more complicated.
   ! Theoretically omega is infinity, but it is set to a large
   ! value, see menter's paper. The halo value is constructed
   ! such that the wall value is correct. Make sure that i and j
   ! are limited to physical dimensions of the face for the wall
   ! distance. Due to the usage of the dd2Wall pointer and the
   ! fact that the original d2Wall array starts at 2, there is
   ! an offset of -1 present in dd2Wall.
   DO j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
   IF (j .GT. jjmax) THEN
   y1 = jjmax
   ELSE
   y1 = j
   END IF
   IF (2 .LT. y1) THEN
   jj = y1
   ELSE
   jj = 2
   END IF
   DO i=bcdata(nn)%icbeg,bcdata(nn)%icend
   IF (i .GT. iimax) THEN
   y2 = iimax
   ELSE
   y2 = i
   END IF
   IF (2 .LT. y2) THEN
   ii = y2
   ELSE
   ii = 2
   END IF
   nud = (rlv2d(i, j)*ww2(i, j, irho)-rlv2(i, j)*ww2d(i, j, irho))/&
   &         ww2(i, j, irho)**2
   nu = rlv2(i, j)/ww2(i, j, irho)
   tmpd = one/(rkwbeta1*dd2wall(ii-1, jj-1)**2)
   bmtd(i, j, itu1, itu1) = 0.0_8
   bmt(i, j, itu1, itu1) = one
   bmtd(i, j, itu2, itu2) = 0.0_8
   bmt(i, j, itu2, itu2) = one
   bvtd(i, j, itu2) = two*60.0_realType*tmpd*nud
   bvt(i, j, itu2) = two*60.0_realType*nu*tmpd
   END DO
   END DO
   CASE (ktau) 
   !        ================================================================
   ! K-tau model. Both k and tau are zero at the wall, so the
   ! negative value of the internal cell is taken for the halo.
   DO j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
   DO i=bcdata(nn)%icbeg,bcdata(nn)%icend
   bmtd(i, j, itu1, itu1) = 0.0_8
   bmt(i, j, itu1, itu1) = one
   bmtd(i, j, itu2, itu2) = 0.0_8
   bmt(i, j, itu2, itu2) = one
   END DO
   END DO
   CASE (v2f) 
   !        ================================================================
   ! V2f turbulence model. Same story for the wall distance as
   ! for k-omega. For this model there is a coupling between the
   ! equations via the boundary conditions.
   DO j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
   IF (j .GT. jjmax) THEN
   y3 = jjmax
   ELSE
   y3 = j
   END IF
   IF (2 .LT. y3) THEN
   jj = y3
   ELSE
   jj = 2
   END IF
   DO i=bcdata(nn)%icbeg,bcdata(nn)%icend
   IF (i .GT. iimax) THEN
   y4 = iimax
   ELSE
   y4 = i
   END IF
   IF (2 .LT. y4) THEN
   ii = y4
   ELSE
   ii = 2
   END IF
   nud = (rlv2d(i, j)*ww2(i, j, irho)-rlv2(i, j)*ww2d(i, j, irho))/&
   &         ww2(i, j, irho)**2
   nu = rlv2(i, j)/ww2(i, j, irho)
   tmpd = one/dd2wall(ii-1, jj-1)**2
   tmped = two*tmpd*nud
   tmpe = two*nu*tmpd
   IF (tmpe*ww2(i, j, itu1) .GE. 0.) THEN
   abs0d = tmped*ww2(i, j, itu1) + tmpe*ww2d(i, j, itu1)
   abs0 = tmpe*ww2(i, j, itu1)
   ELSE
   abs0d = -(tmped*ww2(i, j, itu1)+tmpe*ww2d(i, j, itu1))
   abs0 = -(tmpe*ww2(i, j, itu1))
   END IF
   tmpfd = -((20.0_realType*2*nu*tmpd**2*nud*abs0-20.0_realType*nu&
   &         **2*tmpd**2*abs0d)/abs0**2)
   tmpf = -(20.0_realType*(nu*tmpd)**2/abs0)
   IF (rvfn .EQ. 6) THEN
   tmpf = zero
   tmpfd = 0.0_8
   END IF
   bmtd(i, j, itu1, itu1) = 0.0_8
   bmt(i, j, itu1, itu1) = one
   bmtd(i, j, itu2, itu2) = 0.0_8
   bmt(i, j, itu2, itu2) = one
   bmtd(i, j, itu3, itu3) = 0.0_8
   bmt(i, j, itu3, itu3) = one
   bmtd(i, j, itu4, itu4) = 0.0_8
   bmt(i, j, itu4, itu4) = one
   bmtd(i, j, itu2, itu1) = -(two*tmped)
   bmt(i, j, itu2, itu1) = -(two*tmpe)
   bmtd(i, j, itu4, itu3) = -(two*tmpfd)
   bmt(i, j, itu4, itu3) = -(two*tmpf)
   END DO
   END DO
   CASE DEFAULT
   CALL TERMINATE('bcTurbWall', &
   &               'Turbulence model not implemented yet')
   END SELECT
   END SUBROUTINE BCTURBWALL_D
