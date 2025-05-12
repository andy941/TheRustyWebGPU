{ pkgs ? import <nixpkgs> { } }:
let
  buildInputs = with pkgs; [
    libGL
    libxkbcommon
    wayland
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];
  libPath = with pkgs; lib.makeLibraryPath buildInputs;
in pkgs.mkShell rec {
  inherit buildInputs;
  # Get dependencies from the main package
  inputsFrom = [ (pkgs.callPackage ./default.nix { }) ];

  # Additional tooling

  # Environment variables
  RUST_LOG = "debug";
  RUST_SRC_PATH =
    "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}:${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  LD_LIBRARY_PATH = libPath;
}
