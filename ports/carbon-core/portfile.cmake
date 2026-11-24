vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/carbonengine/core.git
  REF 6d15b4aed16d82469635c2287f26edfa497170b8
  HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
      telemetry   WITH_TELEMETRY
      docs        BUILD_DOCUMENTATION
)

set(CORE_OPTIONS ${FEATURE_OPTIONS}
  -DBUILD_TESTING=OFF
  -DVCPKG_USE_HOST_TOOLS=ON
  "-DVCPKG_HOST_TRIPLET=${HOST_TRIPLET}"
)
# The v145 triplet sets CARBON_BUILD_TYPE. The host triplet does not, and an
# empty -DCMAKE_BUILD_TYPE= overrides vcpkg's Debug/Release selection.
if(DEFINED CARBON_BUILD_TYPE AND NOT CARBON_BUILD_TYPE STREQUAL "")
  list(APPEND CORE_OPTIONS "-DCMAKE_BUILD_TYPE=${CARBON_BUILD_TYPE}")
endif()

vcpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
    ${CORE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()
vcpkg_copy_pdbs()
ccp_externalize_apple_debuginfo()
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
