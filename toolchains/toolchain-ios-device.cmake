set(CMAKE_SYSTEM_NAME Darwin)

find_program(CMAKE_C_COMPILER NAME gcc
  PATHS
  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
  /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
  NO_DEFAULT_PATH)

find_program(CMAKE_CXX_COMPILER NAME g++
  PATHS
  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
  /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
  NO_DEFAULT_PATH)

#set(CMAKE_OSX_ARCHITECTURES "armv7;armv7s;arm64;")
set(CMAKE_OSX_ARCHITECTURES "armv7")

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmessage-length=0 -pipe")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-trigraphs -fpascal-strings")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -Wreturn-type -Wunused-variable")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fexceptions -mmacosx-version-min=10.6")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -gdwarf-2 -fvisibility=hidden")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility-inlines-hidden")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-abi-version=2 -fobjc-legacy-dispatch")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D__IPHONE_OS_VERSION_MIN_REQUIRED=40300")
#set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS}")
set(CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos")

#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework OpenGLES")

# Set the CMAKE_OSX_SYSROOT to the latest SDK found
set(CMAKE_OSX_SYSROOT)
set(possible_sdk_roots
  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs
  /Developer/Platforms/iPhoneOS.platform/Developer/SDKs
  )
foreach(sdk_root ${possible_sdk_roots})
  foreach(sdk iPhoneOS4.3.sdk iPhoneOS5.0.sdk iPhoneOS5.1.sdk iPhoneOS6.0.sdk iPhoneOS6.1.sdk iPhoneOS7.0sdk iPhoneOS7.1sdk iPhoneOS.sdk)
    if (EXISTS ${sdk_root}/${sdk} AND IS_DIRECTORY ${sdk_root}/${sdk})
      set(CMAKE_OSX_SYSROOT ${sdk_root}/${sdk})
    endif()
  endforeach()
endforeach()
if (NOT CMAKE_OSX_SYSROOT)
  message(FATAL_ERROR "Could not find a usable iOS SDK in ${sdk_root}")
endif()
message(STATUS "************************************")
message(STATUS "-- Using iOS SDK: ${CMAKE_OSX_SYSROOT}")

#OpenGL
unset(OPENGL_INCLUDE_DIR CACHE)
if (NOT DEFINED OPENGL_ES_VERSION)
  set(OPENGL_ES_VERSION "2.0" CACHE STRING "opengl es" FORCE)
endif()

if (${OPENGL_ES_VERSION} MATCHES 2.0)
  find_path(OPENGL_INCLUDE_DIR ES2/gl.h
            ${CMAKE_OSX_SYSROOT}/System/Library/Frameworks/OpenGLES.framework/Headers
            ${_OPENGL_INCLUDE_DIR})
elseif (${OPENGL_ES_VERSION} MATCHES 3.0)
  find_path(OPENGL_INCLUDE_DIR ES3/gl.h
            ${CMAKE_OSX_SYSROOT}/System/Library/Frameworks/OpenGLES.framework/Headers
            ${_OPENGL_INCLUDE_DIR})
endif()
find_library(OPENGL_gl_LIBRARY
   NAMES OpenGLES
   PATHS
     ${CMAKE_OSX_SYSROOT}/System/Library/Frameworks
     ${_OPENGL_LIB_PATH}
)
set(OPENGL_gl_LIBRARY ${CMAKE_OSX_SYSROOT} CACHE STRING "opengllib")
#end OpenGL

set(CMAKE_OSX_ARCHITECTURES "${CMAKE_OSX_ARCHITECTURES}" CACHE STRING "osx architectures")
set(CMAKE_XCODE_EFFECTIVE_PLATFORMS "${CMAKE_XCODE_EFFECTIVE_PLATFORMS}" CACHE STRING "xcode platforms")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "c++ flags")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "c flags")
set(CMAKE_OSX_SYSROOT "${CMAKE_OSX_SYSROOT}" CACHE PATH "osx sysroot")
set(MACOSX_BUNDLE_GUI_IDENTIFIER CACHE STRING "com.kitware.\${PRODUCT_NAME:identifier}")

set(CMAKE_FIND_ROOT_PATH ${CMAKE_OSX_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(VTK_IOS_BUILD ON)
set(APPLE_IOS ON)
