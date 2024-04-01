{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      overlays = [
        (import ./overlay.nix)
      ];
      pkgs = (import nixpkgs) {
        inherit system overlays;
      };
    in rec {
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [];
      };

      packages = rec {
        styles = pkgs.valeStyles;
      };
    })
    // {
      overlays.default = import ./overlay.nix;
    };
}
