# - Try to find PnetCDF
#
# This can be controlled by setting the PnetCDF_DIR (or, equivalently, the 
# PNETCDF environment variable), or PnetCDF_<lang>_DIR CMake variables, where
# <lang> is the COMPONENT language one needs.
#
# Once done, this will define:
#
#   PnetCDF_<lang>_FOUND        (BOOL) - system has PnetCDF
#   PnetCDF_<lang>_IS_SHARED    (BOOL) - whether library is shared/dynamic
#   PnetCDF_<lang>_INCLUDE_DIR  (PATH) - Location of the C header file
#   PnetCDF_<lang>_INCLUDE_DIRS (LIST) - the PnetCDF include directories
#   PnetCDF_<lang>_LIBRARY      (FILE) - Path to the C library file
#   PnetCDF_<lang>_LIBRARIES    (LIST) - link these to use PnetCDF
#   PnetCDF_<lang>_DEFINITIONS  (LIST) - preprocessor macros to use with PnetCDF
#   PnetCDF_<lang>_OPTIONS      (LIST) - compiler options to use PnetCDF
#
# The available COMPONENTS are: C, Fortran
# If no components are specified, it assumes only C
include (LibFindLibraryMacros)

set (PnetCDF_VALID_COMPONENTS C Fortran)

if (NOT PnetCDF_FIND_COMPONENTS)
    set (PnetCDF_FIND_COMPONENTS C)
endif ()

set (PnetCDF_FIND_VALID_COMPONENTS)
foreach (comp IN LISTS PnetCDF_FIND_COMPONENTS)
    if (";${PnetCDF_VALID_COMPONENTS};" MATCHES ";${comp};")
        list (APPEND PnetCDF_FIND_VALID_COMPONENTS ${comp})
    endif ()
endforeach ()

set (PnetCDF_C_INCLUDE_NAMES pnetcdf.h)
set (PnetCDF_Fortran_INCLUDE_NAMES pnetcdf.mod pnetcdf.inc)

set (PnetCDF_C_LIBRARY_NAMES pnetcdf)
set (PnetCDF_Fortran_LIBRARY_NAMES pnetcdf)

foreach (comp IN LISTS PnetCDF_FIND_VALID_COMPONENTS)

    if (NOT PnetCDF_${comp}_FOUND)

        if (MPI_${comp}_FOUND)
            set (PnetCDF_${comp}_INCLUDE_HINTS ${MPI_${comp}_INCLUDE_PATH})
            set (PnetCDF_${comp}_LIBRARY_HINTS)
            foreach (lib IN LISTS ${MPI_${comp}_LIBRARIES})
                get_filename_component (libdir ${lib} PATH)
                list (APPEND PnetCDF_${comp}_LIBRARY_HINTS ${libdir})
                unset (libdir)
            endforeach ()
        endif ()
        
        find_package_component(PnetCDF COMPONENT ${comp}
                               INCLUDE_NAMES ${PnetCDF_${comp}_INCLUDE_NAMES}
                               INCLUDE_HINTS ${PnetCDF_${comp}_INCLUDE_HINTS}
                               LIBRARY_NAMES ${PnetCDF_${comp}_LIBRARY_NAMES}
                               LIBRARY_HINTS ${PnetCDF_${comp}_LIBRARY_HINTS})
    
    endif ()
    
endforeach ()
