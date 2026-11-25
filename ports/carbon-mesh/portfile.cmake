vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/rediai-carbon/carbon-mesh.git
  REF eab4b4b29ea6e115f57610a5337f50d4d605ee87
  HEAD_REF main
)

vcpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
  -DBUILD_TESTING=OFF
  -DBUILD_TOOLS=OFF
  -DWITH_SIMPLYGON=OFF
  -DVCPKG_USE_HOST_TOOLS=ON
  -DVCPKG_HOST_TRIPLET=${HOST_TRIPLET}
  -DCMAKE_BUILD_TYPE=${CARBON_BUILD_TYPE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME CarbonMesh)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
vcpkg_copy_pdbs()
ccp_externalize_apple_debuginfo()