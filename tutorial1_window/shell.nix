{ pkgs ? import <nixpkgs> { } }:
let libPath = with pkgs; lib.makeLibraryPath [ libGL libxkbcommon wayland ];
in pkgs.mkShell rec {
  # Get dependencies from the main package
  inputsFrom = [ (pkgs.callPackage ./default.nix { }) ];

  # Additional tooling
  buildInputs = with pkgs; [ ];

  RUST_LOG = "debug";
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  LD_LIBRARY_PATH = libPath;
}
