# FE-3 carbon-core Linux supports trial

Status: not verified. Do not adopt this branch.

Base: `7b2c2b56dc4d5e0f1f4886539f570e2d94b2b46c`

Port tree: `0fd4d37935b7db31e880c3ec9dbaaff9c7e422f0` (`carbon-core` 3.1.0 port-version 1)

Candidate commit: `8e1ff1bc5af395af9036e3e3f65917cce5d90d83`

The port `supports` expression now includes `(linux & x64)`. The producer ref is still `e49c14a0b4a30d656768fa1e0ff559b3c16a9817`. No other port changed.

## What was checked

- `7b2c2b56` rejects `carbon-core` on `x64-linux-release` because supports is `(windows & x64) | osx`.
- This candidate's version database resolves `carbon-core` 3.1.0#1 when the registry checkout is this commit. A fetch of the fork's default branch does not, because this commit is not on that branch.
- `tracy` 0.13.1#1 and `ccp-debug-info` 1.0.2 install on `x64-linux-release`.
- The committed `toolchains/x64-linux-triplet.cmake` uses `include(x64-linux-carbon.cmake)`. CMake does not resolve that bare include. The macOS triplet passes an explicit path. With the committed file, `carbon-core` does not configure.
- A diagnostic copy of that toolchain, not committed here, used `include(${CMAKE_CURRENT_LIST_DIR}/x64-linux-carbon.cmake)`. Configuration then reached the producer. The build failed in `include/CcpLog.h`: `uint32_t` is used without `<cstdint>` (GCC 15.2.0).

The producer ref was not changed and no source patch was added. This candidate is not a Linux port.
