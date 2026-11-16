#!/usr/bin/env bash
# Abrigo Vivo: installs what the website and the 3D animation need, then (optionally) starts them.
#
#   ./install.sh          install / check everything
#   ./install.sh --run    install, then start the local server
#   PORT=8200 ./install.sh --run    use another port
set -euo pipefail

cd "$(dirname "$0")"
PORT="${PORT:-8123}"
THREE_VERSION="0.160.0"
THREE_CDN="https://cdn.jsdelivr.net/npm/three@${THREE_VERSION}"
LIB_DIR="3d/lib"

say()  { printf '\033[1;35m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m ok\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m !!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mERR\033[0m %s\n' "$*" >&2; exit 1; }

SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then SUDO="sudo"; fi

install_packages() {
  # $@ = packages to install with the system package manager
  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update -qq && $SUDO apt-get install -y "$@"
  elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y "$@"
  elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -Sy --noconfirm "$@"
  elif command -v zypper >/dev/null 2>&1; then
    $SUDO zypper install -y "$@"
  elif command -v brew >/dev/null 2>&1; then
    brew install "$@"
  else
    return 1
  fi
}

# 1. Python 3 (runs the local web server) and curl (downloads Three.js)
say "Checking Python 3 and curl"
missing=()
command -v python3 >/dev/null 2>&1 || missing+=(python3)
command -v curl    >/dev/null 2>&1 || missing+=(curl)
if [ "${#missing[@]}" -gt 0 ]; then
  say "Installing: ${missing[*]}"
  install_packages "${missing[@]}" || die "Could not install ${missing[*]} automatically. Install them by hand (Python: https://www.python.org/downloads/) and run this script again."
fi
ok "$(python3 --version)"
ok "curl $(curl --version | head -n1 | cut -d' ' -f2)"

# 2. Three.js files used by the 3D animation (kept locally so it works offline)
say "Checking Three.js ${THREE_VERSION} in ${LIB_DIR}/"
mkdir -p "$LIB_DIR"
for f in build/three.module.js examples/jsm/controls/OrbitControls.js examples/jsm/renderers/CSS2DRenderer.js; do
  name="$(basename "$f")"
  if [ -s "$LIB_DIR/$name" ]; then
    ok "$name"
  else
    curl -fsSL --retry 3 -o "$LIB_DIR/$name.tmp" "$THREE_CDN/$f" || die "Download failed: $THREE_CDN/$f"
    mv "$LIB_DIR/$name.tmp" "$LIB_DIR/$name"
    ok "$name (downloaded)"
  fi
done

# 3. Sanity check: the pages exist
for page in index.html site/abrigo-vivo.html 3d/index.html; do
  [ -f "$page" ] || die "Missing $page. Run this script from the project folder."
done
ok "Pages found"

echo
say "All set."
if [ "${1:-}" = "--run" ]; then
  say "Starting the server: open http://localhost:${PORT} (Ctrl+C to stop)"
  exec python3 -m http.server "$PORT"
else
  echo "    Start it with:   ./install.sh --run"
  echo "    or by hand:      python3 -m http.server ${PORT}"
  echo "    then open:       http://localhost:${PORT}"
fi
