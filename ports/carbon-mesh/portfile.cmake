vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/rediai-carbon/carbon-mesh.git
  REF 71a36fcbe6f169f6224b7cb3ac5de6bebd91a784
  HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools                         CARBON_MESH_REQUEST_TOOLS
        simplygon                     CARBON_MESH_REQUEST_SIMPLYGON
)
if(CARBON_MESH_REQUEST_TOOLS)
    message(FATAL_ERROR
        "Feature 'tools' is not supported on this port revision. "
        "Public registry builds are library-only (BUILD_TOOLS=OFF).")
endif()
if(CARBON_MESH_REQUEST_SIMPLYGON)
    message(FATAL_ERROR
        "Feature 'simplygon' is not supported. Simplygon remains disabled for rights-cleared public consumers.")
endif()

vcpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
  -DBUILD_TESTING=OFF
  -DBUILD_TOOLS=OFF
  -DWITH_SIMPLYGON=OFF
  ${FEATURE_OPTIONS}
  -DVCPKG_USE_HOST_TOOLS=ON
  -DVCPKG_HOST_TRIPLET=${HOST_TRIPLET}
  -DCMAKE_BUILD_TYPE=${CARBON_BUILD_TYPE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME CarbonMesh)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
vcpkg_copy_pdbs()
ccp_externalize_apple_debuginfo()