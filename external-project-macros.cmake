
#
# force build macro
#
macro(force_build proj)
  ExternalProject_Add_Step(${proj} forcebuild
    COMMAND ${CMAKE_COMMAND} -E remove ${base}/Stamp/${proj}/${proj}-build
    DEPENDEES configure
    DEPENDERS build
    ALWAYS 1
  )
endmacro()

macro(get_toolchain_file tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(toolchain_file ${toolchain_${tag_with_underscore}})
endmacro()

macro(get_try_run_results_file tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(try_run_results_file ${try_run_results_${tag_with_underscore}})
endmacro()

#
# Eigen fetch and install
#
macro(install_eigen)
  set(eigen_url http://bitbucket.org/eigen/eigen/get/3.2.8.tar.bz2)
  ExternalProject_Add(
    eigen
    SOURCE_DIR ${source_prefix}/eigen
    URL ${eigen_url}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory "${source_prefix}/eigen/Eigen" "${install_prefix}/eigen/Eigen" && ${CMAKE_COMMAND} -E copy_directory "${source_prefix}/eigen/unsupported" "${install_prefix}/eigen/unsupported"
  )
endmacro()

#
# VTK fetch
#
macro(fetch_vtk)
  ExternalProject_Add(
    vtk-fetch
    SOURCE_DIR ${source_prefix}/vtk
    GIT_REPOSITORY git://github.com/Kitware/VTK.git
    GIT_TAG v6.3.0
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# VTK compile tools for host OS (aka your MAC)
#
macro(compile_vtk)
  set(proj vtk-host)
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/vtk
    DOWNLOAD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS vtk-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DVTK_ANDROID_BUILD:BOOL=ON
      -DANDROID_ARCH_NAME:STRING=armeabi-v7a
      -DANDROID_NATIVE_API_LEVEL:STRING=21
      -DOPENGL_ES_VERSION:STRING=2.0
      -DVTK_EXTRA_COMPILER_WARNINGS:BOOL=OFF
      -DVTK_Group_Imaging:BOOL=OFF
      -DVTK_Group_MPI:BOOL=OFF
      -DVTK_Group_Qt:BOOL=OFF
      -DVTK_Group_Rendering:BOOL=OFF
      -DVTK_Group_StandAlone:BOOL=ON
      -DVTK_Group_Tk:BOOL=OFF
      -DVTK_Group_Views:BOOL=OFF
      -DVTK_Group_Web:BOOL=OFF
      -DVTK_IOS_BUILD:BOOL=OFF
      -DVTK_PYTHON_VERSION:STRING=2
      -DVTK_RENDERING_BACKEND:STRING=OpenGL
      -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=Sequential
      -DVTK_USE_LARGE_DATA:BOOL=OFF
      -DVTK_WRAP_JAVA:BOOL=OFF
      -DVTK_WRAP_PYTHON:BOOL=OFF
      -DVTK_WRAP_TCL:BOOL=OFF
      ${vtk_module_defaults}
  )
endmacro()

#
# VTK crosscompile
#
macro(crosscompile_vtk tag)
  set(proj vtk-${tag})
  get_toolchain_file(${tag})
  get_try_run_results_file(${proj})
  if(${tag} STREQUAL "android")
    set(is_Android ON)
    set(is_iOSDevice OFF)
    set(is_iOSSimulator ON)
  elseif(${tag} STREQUAL  "ios_device")
    set(is_Android OFF)
    set(is_iOSDevice ON)
    set(is_iOSSimulator ON)
  elseif(${tag} STREQUAL  "ios_simulator")
    set(is_Android OFF)
    set(is_iOSDevice ON)
    set(is_iOSSimulator ON)
  endif ()

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/vtk
    DOWNLOAD_COMMAND ""
    DEPENDS vtk-host
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
      -DVTKCompileTools_DIR:PATH=${build_prefix}/vtk-host
      -DVTK_ANDROID_BUILD:BOOL=${is_Android}
      -DVTK_IOS_BUILD:BOOL=${is_iOSDevice}
      -DANDROID_ARCH_NAME:STRING=armeabi-v7a
      -DANDROID_NATIVE_API_LEVEL:STRING=21
      -DOPENGL_ES_VERSION:STRING=2.0
      -DVTK_EXTRA_COMPILER_WARNINGS:BOOL=OFF
      -DVTK_Group_Imaging:BOOL=OFF
      -DVTK_Group_MPI:BOOL=OFF
      -DVTK_Group_Qt:BOOL=OFF
      -DVTK_Group_Rendering:BOOL=OFF
      -DVTK_Group_StandAlone:BOOL=ON
      -DVTK_Group_Tk:BOOL=OFF
      -DVTK_Group_Views:BOOL=OFF
      -DVTK_Group_Web:BOOL=OFF
      -DVTK_PYTHON_VERSION:STRING=2
      -DVTK_RENDERING_BACKEND:STRING=OpenGL
      -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=Sequential
      -DVTK_USE_LARGE_DATA:BOOL=OFF
      -DVTK_WRAP_JAVA:BOOL=OFF
      -DVTK_WRAP_PYTHON:BOOL=OFF
      -DVTK_WRAP_TCL:BOOL=OFF
      ${vtk_module_defaults}
      -C ${try_run_results_file}
  )
endmacro()

#
# FLANN fetch
#
macro(fetch_flann)
  ExternalProject_Add(
    flann-fetch
    SOURCE_DIR ${source_prefix}/flann
    GIT_REPOSITORY git://github.com/mariusmuja/flann
    GIT_TAG 1.8.4
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# FLANN crosscompile
#
macro(crosscompile_flann tag)
  set(proj flann-${tag})
  get_toolchain_file(${tag})
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/flann
    DOWNLOAD_COMMAND ""
    DEPENDS flann-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
     # -DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_EXAMPLES:BOOL=OFF
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF
      -DBUILD_MATLAB_BINDINGS:BOOL=OFF
  )

  force_build(${proj})
endmacro()


#
# Boost fetch
#
macro(fetch_boost)
  ExternalProject_Add(
    boost-fetch
    SOURCE_DIR ${source_prefix}/boost
    GIT_REPOSITORY git://github.com/joeblau/boost-build
    GIT_TAG origin/master
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# Boost crosscompile
#
macro(crosscompile_boost tag)


  set(proj boost-${tag})
  get_toolchain_file(${tag})
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/boost
    DOWNLOAD_COMMAND ""
    DEPENDS boost-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
      -DBUILD_SHARED_LIBS:BOOL=OFF
  )

  force_build(${proj})
endmacro()


#
# PCL fetch
#
macro(fetch_pcl)
  ExternalProject_Add(
    pcl-fetch
    SOURCE_DIR ${source_prefix}/pcl
    # GIT_REPOSITORY git://github.com/patmarion/PCL.git
    # GIT_REPOSITORY git://github.com/PointCloudLibrary/pcl.git
    GIT_REPOSITORY git://github.com/Sirokujira/pcl.git
    # GIT_TAG origin/android-tag
    # GIT_TAG origin/master
    # GIT_TAG pcl-1.8.0
    GIT_TAG Branch_pcl-1.7.2
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# PCL crosscompile
#
macro(crosscompile_pcl tag)
  set(proj pcl-${tag})
  get_toolchain_file(${tag})
  get_try_run_results_file(${proj})

  # copy the toolchain file and append the boost install dir to CMAKE_FIND_ROOT_PATH
  set(original_toolchain_file ${toolchain_file})
  get_filename_component(toolchain_file ${original_toolchain_file} NAME)
  set(toolchain_file ${build_prefix}/${proj}/${toolchain_file})
  configure_file(${original_toolchain_file} ${toolchain_file} COPYONLY)
  file(APPEND ${toolchain_file}
    "\nlist(APPEND CMAKE_FIND_ROOT_PATH ${install_prefix}/boost-${tag})\n")

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/pcl
    DOWNLOAD_COMMAND ""
    DEPENDS pcl-fetch boost-${tag} flann-${tag} vtk-${tag} eigen
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DPCL_SHARED_LIBS:BOOL=OFF
      -DBUILD_visualization:BOOL=OFF
      -DBUILD_examples:BOOL=OFF
      -DEIGEN_INCLUDE_DIR=${install_prefix}/eigen
      -DFLANN_INCLUDE_DIR=${install_prefix}/flann-${tag}/include
      -DFLANN_LIBRARY=${install_prefix}/flann-${tag}/lib/libflann_cpp_s.a
      -DBOOST_ROOT=${install_prefix}/boost-${tag}
      -DVTK_DIR=${build_prefix}/vtk-${tag}/CMakeExternals/Build/vtk-ios-device-armv7
      -DWITH_PCAP:BOOL=OFF
      -DPCL_ENABLE_SSE=OFF
      -C ${try_run_results_file}
  )

  force_build(${proj})
endmacro()


macro(create_pcl_universal_framework)
    add_custom_target(pclFrameworkUniversal ALL
      COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh pcl
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS pcl-ios-device pcl-ios-simulator
      COMMENT "Creating universal pcl.framework")
endmacro()

macro(create_pcl_ios_framework)
    add_custom_target(pclFrameworkIOS ALL
      COMMAND ${CMAKE_SOURCE_DIR}/makeiOSFramework.sh pcl
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS pcl-ios-device
      COMMENT "Creating ios only pcl.framework")
endmacro()

macro(create_pcl_simulator_framework)
    add_custom_target(pclFrameworkSimulator ALL
      COMMAND ${CMAKE_SOURCE_DIR}/makeSimulatorFramework.sh pcl
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS pcl-ios-simulator
      COMMENT "Creating simulator only pcl.framework")
endmacro()
