!--------------------------------------------------------------------------
!   Copyright 2012-2016 Lasse Lambrecht (Ruhr-Universitaet Bochum, Germany)
!   Copyright 2015-2017 Andre Lamert (Ruhr-Universitaet Bochum, Germany)
!
!   This file is part of NEXD 3D.
!
!   NEXD 3D is free software: you can redistribute it and/or modify it
!   under the terms of the GNU General Public License as published by the
!   Free Software Foundation, either version 3 of the License, or (at your
!   option) any later version.
!
!   NEXD 3D is distributed in the hope that it will be useful, but WITHOUT
!   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!   FITNESS FOR A PARTICULAR PURPOSE.
!   See the GNU General Public License for more details.
!
!   You should have received a copy of the GNU General Public License v3.0
!   along with NEXD 3D. If not, see <http://www.gnu.org/licenses/>.
!--------------------------------------------------------------------------
module tetraNeighborMod
!
! Module to find the neighbors of a tet mesh
! It is a part of the program tet_mesh_tet_neighbors.f90 from John Burkardt published under the GLP license
! Its from http://people.sc.fsu.edu/~jburkardt/f_src/tet_mesh_tet_neighbors/tet_mesh_tet_neighbors.html
!
contains
!
subroutine i4col_compare ( m, n, a, i, j, isgn )

!*****************************************************************************80
!
!! I4COL_COMPARE compares columns I and J of an I4COL.
!
!  Example:
!
!    Input:
!
!      M = 3, N = 4, I = 2, J = 4
!
!      A = (
!        1  2  3  4
!        5  6  7  8
!        9 10 11 12 )
!
!    Output:
!
!      ISGN = -1
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    12 June 2005
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) M, N, the number of rows and columns.
!
!    Input, integer ( kind = 4 ) A(M,N), an array of N columns of vectors of length M.
!
!    Input, integer ( kind = 4 ) I, J, the columns to be compared.
!    I and J must be between 1 and N.
!
!    Output, integer ( kind = 4 ) ISGN, the results of the comparison:
!    -1, column I < column J,
!     0, column I = column J,
!    +1, column J < column I.
!
  implicit none

  integer ( kind = 4 ) m
  integer ( kind = 4 ) n

  integer ( kind = 4 ) a(m,n)
  integer ( kind = 4 ) i
  integer ( kind = 4 ) isgn
  integer ( kind = 4 ) j
  integer ( kind = 4 ) k
!
!  Check.
!
  if ( i < 1 ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'I4COL_COMPARE - Fatal error!'
    write ( *, '(a,i8,a)' ) '  Column index I = ', i, ' is less than 1.'
    stop
  end if

  if ( n < i ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'I4COL_COMPARE - Fatal error!'
    write ( *, '(a,i8,a)' ) '  N = ', n, ' is less than column index I = ', i
    stop
  end if

  if ( j < 1 ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'I4COL_COMPARE - Fatal error!'
    write ( *, '(a,i8,a)' ) '  Column index J = ', j, ' is less than 1.'
    stop
  end if

  if ( n < j ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'I4COL_COMPARE - Fatal error!'
    write ( *, '(a,i8,a)' ) '  N = ', n, ' is less than column index J = ', j
    stop
  end if

  isgn = 0

  if ( i == j ) then
    return
  end if

  k = 1

  do while ( k <= m )

    if ( a(k,i) < a(k,j) ) then
      isgn = -1
      return
    else if ( a(k,j) < a(k,i) ) then
      isgn = +1
      return
    end if

    k = k + 1

  end do

  return
end subroutine i4col_compare
subroutine i4col_sort_a ( m, n, a )

!*****************************************************************************80
!
!! I4COL_SORT_A ascending sorts an I4COL of columns.
!
!  Discussion:
!
!    In lexicographic order, the statement "X < Y", applied to two real
!    vectors X and Y of length M, means that there is some index I, with
!    1 <= I <= M, with the property that
!
!      X(J) = Y(J) for J < I,
!    and
!      X(I) < Y(I).
!
!    In other words, the first time they differ, X is smaller.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    25 September 2001
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) M, the number of rows of A, and the length of
!    a vector of data.
!
!    Input, integer ( kind = 4 ) N, the number of columns of A.
!
!    Input/output, integer ( kind = 4 ) A(M,N).
!    On input, the array of N columns of M-vectors.
!    On output, the columns of A have been sorted in ascending
!    lexicographic order.
!
  implicit none

  integer ( kind = 4 ) m
  integer ( kind = 4 ) n

  integer ( kind = 4 ) a(m,n)
  integer ( kind = 4 ) i
  integer ( kind = 4 ) indx
  integer ( kind = 4 ) isgn
  integer ( kind = 4 ) j

  if ( m <= 0 ) then
    return
  end if

  if ( n <= 1 ) then
    return
  end if
!
!  Initialize.
!
  i = 0
  indx = 0
  isgn = 0
  j = 0
!
!  Call the external heap sorter.
!
  do

    call sort_heap_external ( n, indx, i, j, isgn )
!
!  Interchange the I and J objects.
!
    if ( 0 < indx ) then

      call i4col_swap ( m, n, a, i, j )
!
!  Compare the I and J objects.
!
    else if ( indx < 0 ) then

      call i4col_compare ( m, n, a, i, j, isgn )

    else if ( indx == 0 ) then

      exit

    end if

  end do

  return
end subroutine i4col_sort_a
subroutine i4col_swap ( m, n, a, j1, j2 )

!*****************************************************************************80
!
!! I4COL_SWAP swaps columns J1 and J2 of a integer array of column data.
!
!  Example:
!
!    Input:
!
!      M = 3, N = 4, J1 = 2, J2 = 4
!
!      A = (
!        1  2  3  4
!        5  6  7  8
!        9 10 11 12 )
!
!    Output:
!
!      A = (
!        1  4  3  2
!        5  8  7  6
!        9 12 11 10 )
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    04 April 2001
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) M, N, the number of rows and columns in the array.
!
!    Input/output, integer ( kind = 4 ) A(M,N), an array of N columns of length M.
!
!    Input, integer ( kind = 4 ) J1, J2, the columns to be swapped.
!
  implicit none

  integer ( kind = 4 ) m
  integer ( kind = 4 ) n

  integer ( kind = 4 ) a(m,n)
  integer ( kind = 4 ) col(m)
  integer ( kind = 4 ) j1
  integer ( kind = 4 ) j2

  if ( j1 < 1 .or. n < j1 .or. j2 < 1 .or. n < j2 ) then

    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'I4COL_SWAP - Fatal error!'
    write ( *, '(a)' ) '  J1 or J2 is out of bounds.'
    write ( *, '(a,i8)' ) '  J1 =    ', j1
    write ( *, '(a,i8)' ) '  J2 =    ', j2
    write ( *, '(a,i8)' ) '  N =     ', n
    stop

  end if

  if ( j1 == j2 ) then
    return
  end if

  col(1:m)  = a(1:m,j1)
  a(1:m,j1) = a(1:m,j2)
  a(1:m,j2) = col(1:m)

  return
end subroutine i4col_swap
subroutine i4i4i4_sort_a ( i1, i2, i3, j1, j2, j3 )

!*****************************************************************************80
!
!! I4I4I4_SORT_A ascending sorts a triple of I4's.
!
!  Discussion:
!
!    The program allows the reasonable call:
!
!      call i4i4i4_sort_a ( i1, i2, i3, i1, i2, i3 )
!
!    and this will return the reasonable result.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    13 October 2005
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) I1, I2, I3, the values to sort.
!
!    Output, integer ( kind = 4 ) J1, J2, J3, the sorted values.
!
  implicit none

  integer ( kind = 4 ) i1
  integer ( kind = 4 ) i2
  integer ( kind = 4 ) i3
  integer ( kind = 4 ) j1
  integer ( kind = 4 ) j2
  integer ( kind = 4 ) j3
  integer ( kind = 4 ) k1
  integer ( kind = 4 ) k2
  integer ( kind = 4 ) k3
!
!  Copy arguments, so that the user can make "reasonable" calls like:
!
!    call i4i4i4_sort_a ( i1, i2, i3, i1, i2, i3 )
!
  k1 = i1
  k2 = i2
  k3 = i3

  j1 = min ( min ( k1, k2 ), min ( k2, k3 ) )
  j2 = min ( max ( k1, k2 ), &
       min ( max ( k2, k3 ), max ( k3, k1 ) ) )
  j3 = max ( max ( k1, k2 ), max ( k2, k3 ) )

  return
end subroutine i4i4i4_sort_a

subroutine sort_heap_external ( n, indx, i, j, isgn )

!*****************************************************************************80
!
!! SORT_HEAP_EXTERNAL externally sorts a list of items into ascending order.
!
!  Discussion:
!
!    The actual list of data is not passed to the routine.  Hence this
!    routine may be used to sort integers, reals, numbers, names,
!    dates, shoe sizes, and so on.  After each call, the routine asks
!    the user to compare or interchange two items, until a special
!    return value signals that the sorting is completed.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    05 February 2004
!
!  Author:
!
!    Original FORTRAN77 version by Albert Nijenhuis, Herbert Wilf.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    A Nijenhuis and H Wilf,
!    Combinatorial Algorithms,
!    Academic Press, 1978, second edition,
!    ISBN 0-12-519260-6.
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) N, the number of items to be sorted.
!
!    Input/output, integer ( kind = 4 ) INDX, the main communication signal.
!
!    The user must set INDX to 0 before the first call.
!    Thereafter, the user should not change the value of INDX until
!    the sorting is done.
!
!    On return, if INDX is
!
!      greater than 0,
!      * interchange items I and J;
!      * call again.
!
!      less than 0,
!      * compare items I and J;
!      * set ISGN = -1 if I < J, ISGN = +1 if J < I;
!      * call again.
!
!      equal to 0, the sorting is done.
!
!    Output, integer ( kind = 4 ) I, J, the indices of two items.
!    On return with INDX positive, elements I and J should be interchanged.
!    On return with INDX negative, elements I and J should be compared, and
!    the result reported in ISGN on the next call.
!
!    Input, integer ( kind = 4 ) ISGN, results of comparison of elements I and J.
!    (Used only when the previous call returned INDX less than 0).
!    ISGN <= 0 means I is less than or equal to J;
!    0 <= ISGN means I is greater than or equal to J.
!
  implicit none

  integer ( kind = 4 ) i
  integer ( kind = 4 ), save :: i_save = 0
  integer ( kind = 4 ) indx
  integer ( kind = 4 ) isgn
  integer ( kind = 4 ) j
  integer ( kind = 4 ), save :: j_save = 0
  integer ( kind = 4 ), save :: k = 0
  integer ( kind = 4 ), save :: k1 = 0
  integer ( kind = 4 ) n
  integer ( kind = 4 ), save :: n1 = 0
!
!  INDX = 0: This is the first call.
!
  if ( indx == 0 ) then

    i_save = 0
    j_save = 0
    k = n / 2
    k1 = k
    n1 = n
!
!  INDX < 0: The user is returning the results of a comparison.
!
  else if ( indx < 0 ) then

    if ( indx == -2 ) then

      if ( isgn < 0 ) then
        i_save = i_save + 1
      end if

      j_save = k1
      k1 = i_save
      indx = -1
      i = i_save
      j = j_save
      return

    end if

    if ( 0 < isgn ) then
      indx = 2
      i = i_save
      j = j_save
      return
    end if

    if ( k <= 1 ) then

      if ( n1 == 1 ) then
        i_save = 0
        j_save = 0
        indx = 0
      else
        i_save = n1
        n1 = n1 - 1
        j_save = 1
        indx = 1
      end if

      i = i_save
      j = j_save
      return

    end if

    k = k - 1
    k1 = k
!
!  0 < INDX, the user was asked to make an interchange.
!
  else if ( indx == 1 ) then

    k1 = k

  end if

  do

    i_save = 2 * k1

    if ( i_save == n1 ) then
      j_save = k1
      k1 = i_save
      indx = -1
      i = i_save
      j = j_save
      return
    else if ( i_save <= n1 ) then
      j_save = i_save + 1
      indx = -2
      i = i_save
      j = j_save
      return
    end if

    if ( k <= 1 ) then
      exit
    end if

    k = k - 1
    k1 = k

  end do

  if ( n1 == 1 ) then
    i_save = 0
    j_save = 0
    indx = 0
    i = i_save
    j = j_save
  else
    i_save = n1
    n1 = n1 - 1
    j_save = 1
    indx = 1
    i = i_save
    j = j_save
  end if

  return
end subroutine sort_heap_external
subroutine tet_mesh_neighbor_tets ( tetra_order, tetra_num, tetra_node, &
  tetra_neighbor )

!*****************************************************************************80
!
!! TET_MESH_NEIGHBOR_TETS determines tetrahedron neighbors.
!
!  Discussion:
!
!    A tet mesh of a set of nodes can be completely described by
!    the coordinates of the nodes, and the list of nodes that make up
!    each tetrahedron.  In the most common case, four nodes are used.
!    There is also a 10 node case, where nodes are also placed on
!    the midsides of the tetrahedral edges.
!
!    This routine can handle 4 or 10-node tetrahedral meshes.  The
!    10-node case is handled simply by ignoring the six midside nodes,
!    which are presumed to be listed after the vertices.
!
!    The tetrahedron adjacency information records which tetrahedron
!    is adjacent to a given tetrahedron on a particular face.
!
!    This routine creates a data structure recording this information.
!
!    The primary amount of work occurs in sorting a list of 4 * TETRA_NUM
!    data items.
!
!    The neighbor tetrahedrons are indexed by the face they share with
!    the tetrahedron.
!
!    Each face of the tetrahedron is indexed by the node which is NOT
!    part of the face.  That is:
!
!    * Neighbor 1 shares face 1 defined by nodes 2, 3, 4.
!    * Neighbor 2 shares face 2 defined by nodes 1, 3, 4;
!    * Neighbor 3 shares face 3 defined by nodes 1, 2, 4;
!    * Neighbor 4 shares face 4 defined by nodes 1, 2, 3.
!
!    For instance, if the (transposed) TETRA_NODE array was:
!
!    Row       1      2      3      4
!    Col
!
!      1       4      3      5      1
!      2       4      2      5      1
!      3       4      7      3      5
!      4       4      7      8      5
!      5       4      6      2      5
!      6       4      6      8      5
!
!    then the (transposed) TETRA_NEIGHBOR array should be:
!
!    Row       1      2      3      4
!    Col
!
!      1      -1      2     -1      3
!      2      -1      1     -1      5
!      3      -1      1      4     -1
!      4      -1      6      3     -1
!      5      -1      2      6     -1
!      6      -1      4      5     -1
!
!    09 February 2006: Jeff Borggaard reported that the code
!    was failing when TETRA_NUM hit 10,000, but not at 9,999.
!    This sounded like the effect of some odd internal compiler limit.
!    He changed the internal FACES array from being implicitly
!    allocated to being explicitly allocated, and the problem 
!    went away.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    09 February 2006
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) TETRA_ORDER, the order of the tetrahedrons.
!
!    Input, integer ( kind = 4 ) TETRA_NUM, the number of tetrahedrons.
!
!    Input, integer ( kind = 4 ) TETRA_NODE(TETRA_ORDER,TETRA_NUM), the nodes that make up
!    each tetrahedron.
!
!    Output, integer ( kind = 4 ) TETRA_NEIGHBOR(4,TETRA_NUM), the four tetrahedrons that
!    are direct neighbors of a given tetrahedron.  If there is no neighbor
!    sharing a given face, the index is set to -1.
!
  implicit none

  integer ( kind = 4 ) tetra_num
  integer ( kind = 4 ) tetra_order

  integer ( kind = 4 ) a
  integer ( kind = 4 ) b
  integer ( kind = 4 ) c
  integer ( kind = 4 ) face
  integer ( kind = 4 ) face1
  integer ( kind = 4 ) face2
  integer ( kind = 4 ), allocatable, dimension ( :, : ) :: faces
  integer ( kind = 4 ) i
  integer ( kind = 4 ) j
  integer ( kind = 4 ) k
  integer ( kind = 4 ) l
  integer ( kind = 4 ) tetra
  integer ( kind = 4 ) tetra_neighbor(4,tetra_num)
  integer ( kind = 4 ) tetra1
  integer ( kind = 4 ) tetra2
  integer ( kind = 4 ) tetra_node(tetra_order,tetra_num)

  allocate ( faces(1:5,1:4*tetra_num) )
!
!  Step 1.
!  From the list of nodes for tetrahedron T, of the form: (I,J,K,L)
!  construct the four face relations:
!
!    (J,K,L,1,T)
!    (I,K,L,2,T)
!    (I,J,L,3,T)
!    (I,J,K,4,T)
!
!  In order to make matching easier, we reorder each triple of nodes
!  into ascending order.
!
  do tetra = 1, tetra_num

    i = tetra_node(1,tetra)
    j = tetra_node(2,tetra)
    k = tetra_node(3,tetra)
    l = tetra_node(4,tetra)

    call i4i4i4_sort_a ( j, k, l, a, b, c )
!    call i4i4i4_sort_a ( i, j, k, a, b, c )

    faces(1:5,4*(tetra-1)+1) = (/ a, b, c, 1, tetra /)

    call i4i4i4_sort_a ( i, k, l, a, b, c )
!   call i4i4i4_sort_a ( i, j, l, a, b, c )

    faces(1:5,4*(tetra-1)+2) = (/ a, b, c, 2, tetra /)

    call i4i4i4_sort_a ( i, j, l, a, b, c )
!   call i4i4i4_sort_a ( j, k, l, a, b, c )

    faces(1:5,4*(tetra-1)+3) = (/ a, b, c, 3, tetra /)

    call i4i4i4_sort_a ( i, j, k, a, b, c )
!   call i4i4i4_sort_a ( i, k, l, a, b, c )

    faces(1:5,4*(tetra-1)+4) = (/ a, b, c, 4, tetra /)

  end do
!
!  Step 2. Perform an ascending dictionary sort on the neighbor relations.
!  We only intend to sort on rows 1:3; the routine we call here
!  sorts on rows 1 through 5 but that won't hurt us.
!
!  What we need is to find cases where two tetrahedrons share a face.
!  By sorting the columns of the FACES array, we will put shared faces
!  next to each other.
!
  call i4col_sort_a ( 5, 4*tetra_num, faces )
!
!  Step 3. Neighboring tetrahedrons show up as consecutive columns with
!  identical first three entries.  Whenever you spot this happening,
!  make the appropriate entries in TETRA_NEIGHBOR.
!
  tetra_neighbor(1:4,1:tetra_num) = -1

  face = 1

  do

    if ( 4 * tetra_num <= face ) then
      exit
    end if

    if ( all ( faces(1:3,face) == faces(1:3,face+1) ) ) then
      face1 = faces(4,face)
      tetra1 = faces(5,face)
      face2 = faces(4,face+1)
      tetra2 = faces(5,face+1)
      tetra_neighbor(face1,tetra1) = tetra2
      tetra_neighbor(face2,tetra2) = tetra1
      face = face + 2
    else
      face = face + 1
    end if

  end do

  deallocate ( faces )

  return
end subroutine tet_mesh_neighbor_tets
end module tetraNeighborMod
