vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/carbonengine/blueexposure.git
  REF fc29511269ba22a916cd74f68a88e122eb386d32
  HEAD_REF main
)

vcpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
  -DBUILD_TESTING=OFF
  -DVCPKG_USE_HOST_TOOLS=ON
  -DVCPKG_HOST_TRIPLET=${HOST_TRIPLET}
  -DCMAKE_BUILD_TYPE=${CARBON_BUILD_TYPE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()
vcpkg_copy_pdbs()