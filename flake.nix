# This is a Nix flake. It allows a declarative way to define environments and share them.
# You can use this flake to build the project, run tests, and more.
#
# Here's a few things you can do with this flake:
# - Open a development shell with all the dependencies available:
#   nix develop
# - With only the runtime dependencies:
#   nix develop --no-native-build-inputs
# 
# You can learn more about Flakes and Nix in general at:
# https://wiki.nixos.org/wiki/Flakes
# https://nixos.org/
{
  description = "Godot Engine";

  inputs = {
    # This refers to 24.11-beta's tagged release.
    nixpkgs.url = "github:nixos/nixpkgs/8b27c1239e5c421a2bbc2c65d52e4a6fbf2ff296";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = { url = "github:hercules-ci/gitignore.nix"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    gitignoreSrc = pkgs.callPackage inputs.gitignore { };
  in rec {
    devShell = pkgs.mkShell rec {
      # Things available at build-time
      nativeBuildInputs = with pkgs; [
        pkg-config
        scons
        gcc
      ];

      # Things available at runtime
      buildInputs = with pkgs; [
        # General Godot dependencies
        alsa-lib
        libGL
        vulkan-loader

        # C++ dependencies
        # This is needed for using GDExtension at runtime
        stdenv.cc.cc.lib

        # X11/Xorg dependencies
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXinerama
        libxkbcommon
        xorg.libXrandr
        xorg.libXrender

        # Wayland dependencies
        libdecor
        wayland

        # DBus dependencies
        dbus
        dbus.lib

        # Fontconfig dependencies
        fontconfig
        fontconfig.lib

        # PulseAudio dependencies
        libpulseaudio

        # SpeechD dependencies
        speechd-minimal

        # udev dependencies
        udev
      ];

      env = {
        LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
      };
    };
  });
}