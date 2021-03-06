module kvs_TornadoVolumeData_m
  use iso_c_binding
  use kvs_Vec3_m
  use kvs_StructuredVolumeObject_m
  implicit none

  private
  include "kvs_TornadoVolumeData_c.f90"

  ! Class definition
  public :: kvs_TornadoVolumeData
  type kvs_TornadoVolumeData
    private
    type( C_ptr ) :: ptr = C_NULL_ptr
  contains
    final :: kvs_TornadoVolumeData_finalize ! Destructor
     procedure :: delete => kvs_TornadoVolumeData_delete
     procedure :: setTime => kvs_TornadoVolumeData_setTime
     procedure :: exec => kvs_TornadoVolumeData_exec
  end type kvs_TornadoVolumeData

  interface kvs_TornadoVolumeData
    procedure kvs_TornadoVolumeData_new
  end interface kvs_TornadoVolumeData

  contains

  function kvs_TornadoVolumeData_new ( resolution, other )
    implicit none
    type( kvs_TornadoVolumeData ) :: kvs_TornadoVolumeData_new
    type( kvs_Vec3i ), intent( in ) :: resolution
    type( C_ptr ), optional :: other
    if ( present( other ) ) then
       kvs_TornadoVolumeData_new % ptr = C_kvs_TornadoVolumeData_copy( other )
    else
       kvs_TornadoVolumeData_new % ptr = C_kvs_TornadoVolumeData_new( resolution%x, resolution%y, resolution%z )
    end if
  end function kvs_TornadoVolumeData_new

  subroutine kvs_TornadoVolumeData_delete ( this )
    implicit none
    class (kvs_TornadoVolumeData) ::this
    call C_kvs_TornadoVolumeData_delete( this%ptr )
    this%ptr = C_NULL_ptr
  end subroutine kvs_TornadoVolumeData_delete

  subroutine kvs_TornadoVolumeData_setTime ( this, time )
    implicit none
    class (kvs_TornadoVolumeData) ::this
    integer, intent( in ) :: time
    call C_kvs_TornadoVolumeData_setTime( this % ptr, time )
  end subroutine kvs_TornadoVolumeData_setTime

  subroutine kvs_TornadoVolumeData_finalize( this )
    implicit none
    type( kvs_TornadoVolumeData ) :: this
    if ( c_associated( this % ptr ) ) then
       call C_kvs_TornadoVolumeData_delete( this % ptr )
       this % ptr = C_NULL_ptr
    end if
  end subroutine kvs_TornadoVolumeData_finalize

  function kvs_TornadoVolumeData_exec( this )
    implicit none
    class( kvs_TornadoVolumeData ), intent( in ) :: this
    type( kvs_StructuredVolumeObject ) :: kvs_TornadoVolumeData_exec
    kvs_TornadoVolumeData_exec = kvs_StructuredVolumeObject( C_kvs_TornadoVolumeData_exec( this % ptr ) )
  end function kvs_TornadoVolumeData_exec

end module kvs_TornadoVolumeData_m
