# BE7000 Tachyon kernel compatibility investigation (2026-10-28)

Running Beam WRT 1.3.1-QWRT firmware: build 40412735569, kernel 6.18.36, kernel identity `e9cfef63d69f7689bbe64561df80476a`.

Tachyon dependency build #2 (run 40540779248) generated kernel identity `bd6d848e19a5657a833695d0ad460252`; its `kmod-inet-diag` MUST NOT be installed on the running firmware.

Diagnostic run #4 (40590062253) reproduced the mismatch and stopped safely before publishing the module. Artifact `be7000-kernel-diagnostics-4` (ID 12783760739) contains the generated OpenWrt and kernel configurations.

The generated kernel configuration has `CONFIG_INET_DIAG=m`, `CONFIG_INET_TCP_DIAG=m`, `CONFIG_INET_UDP_DIAG=m`. The baseline `config.buildinfo` does not explicitly select `kmod-inet-diag`. Selecting that module may have changed kernel configuration and thus its identity, but causation is NOT proven without comparing the exact baseline kernel configuration.

## Safe next steps

1. Rebuild the baseline configuration *without* `CONFIG_PACKAGE_kmod-inet-diag=y` and verify its kernel identity matches the running firmware.
2. Compare baseline and module-enabled kernel `.config` files to isolate the exact changes.
3. Do not force-install mismatched kernel APKs or flash the firmware without a tested backup, recovery and remote-access plan.
4. If enabling INET_DIAG necessarily changes the kernel ABI identity, use a planned firmware update containing the matching module instead of mixing modules from incompatible builds.

Compatibility guard: `scripts/check-tachyon-kmod.sh`. No live VPN routing changes have been made.
