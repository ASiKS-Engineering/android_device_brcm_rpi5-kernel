# android_device_brcm_rpi5-kernel

Prebuilt Raspberry Pi 5 kernel artifacts (device trees, overlays, modules) for the AOSP build.

The kernel `Image` is **not stored in git**. It is published as a GitHub release asset and
pinned in `IMAGE_RELEASE` (tag and SHA-256). `device.mk` and `mkbootimg.mk` expect it at
`device/brcm/rpi5-kernel/Image`, so fetch it before building:

```
device/brcm/rpi5-kernel/fetch_image.sh
```

## Publishing a new kernel

1. Build the kernel (`tools/bazel build --config=fast --config=stamp //common:rpi5`) and take
   `bazel-bin/common/rpi5/Image`.
2. Create a release, for example
   `gh release create kernel-<version>-g<sha> Image --title "Kernel <version> (<sha>)"`.
3. Update `TAG` and `SHA256` in `IMAGE_RELEASE` (`sha256sum Image`) and commit.
