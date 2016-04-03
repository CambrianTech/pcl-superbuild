# PCL Superbuild

cmake build scripts for cross compiling PCL and its dependencies for Android and iOS.

##  iOS

### Requirements
- Homebrew - http://brew.sh
- Xcode (latest)
- cmake - `brew install cmake`

### Building

```sh
git clone git@github.com:CambrianTech/pcl-superbuild.git
mkdir build
cd build
ccmake ../pcl-superbuild/
```

- press `c` to configure
- Ensure that only `BUILD_IOS_DEVICE` and `BUILD_IOS_SIMULATOR` are configured to `ON` or `OFF` based on your requirements.
- press `c` to finish configuration
- press `g` to generate

```sh
make -j`sysctl -n hw.ncpu`
```

## Android

## Requirements

- Android NDK, Revision 8d
- Android SDK (unsure about specific version)

### Building

```sh
mkdir build && cd build
cmake -DBUILD_IOS_DEVICE:BOOL="OFF" ../
export ANDROID_NDK=${PATH_TO_ANDROID_NDK_R8}
make
```
