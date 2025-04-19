{ pkgs ? import <nixpkgs> { } }:
let
  libPath = with pkgs;
    lib.makeLibraryPath [ vulkan-tools libGL libxkbcommon wayland ];
  manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
in pkgs.rustPlatform.buildRustPackage rec {
  pname = manifest.name;
  version = manifest.version;
  cargoLock.lockFile = ./Cargo.lock;
  src = pkgs.lib.cleanSource ./.;

  # Additional tooling
  buildInputs = with pkgs; [ vulkan-headers vulkan-loader vulkan-tools ];

  # Environment variables
  RUST_LOG = "debug";
  RUST_SRC_PATH =
    "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}:${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  LD_LIBRARY_PATH = libPath;
}
