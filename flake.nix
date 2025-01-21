# Read about Flakes here:
# https://wiki.nixos.org/wiki/Flakes
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
    #packages.opendeck = pkgs.callPackage ./default.nix { inherit pkgs system; };
  
    #legacyPackages = packages;

    #defaultPackage = packages.opendeck;

    devShell = pkgs.mkShell rec {
      # These are things available at build-time
      nativeBuildInputs = with pkgs; [
        pkg-config
        scons
      ];

      # These are things available at runtime
      buildInputs = with pkgs; [
      ];

      env = {
        LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
      };
    };
  });
}