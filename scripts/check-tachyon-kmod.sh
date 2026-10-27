#!/bin/sh
# Read-only guard for BE7000 Tachyon kernel module installation
set -eu
dir="${1:-/tmp/tachyon-audit}"
expected="$(sed -n 's/^KERNEL=//p' /etc/be7000-release | head -n 1)"
if [ -r "$dir/kernel-vermagic.txt" ]; then
  actual="$(tr -d '\r\n' < "$dir/kernel-vermagic.txt")"
else
  actual="$(unzip -p "$dir/deps.zip" kernel-vermagic.txt | tr -d '\r\n')"
fi
printf 'router=%s\nartifact=%s\n' "$expected" "$actual"
[ -n "$expected" ] && [ "$expected" = "$actual" ] || { echo 'BLOCKED: incompatible kernel'; exit 1; }
echo 'Kernel identity matches; verify package signature and ABI before installation'
