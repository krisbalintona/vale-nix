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
      testConfig = {
        packages = styles: with styles; [microsoft readability];
        vocab = {
          accept = ["seccomp"];
        };
        formatOptions = {
          "*" = {
            basedOnStyles = ["Vale" "Microsoft"];
            "Microsoft.Passive" = true;
          };
        };
      };
    in rec {
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [vale];
      };

      packages = rec {
        styles = pkgs.valeStyles;
        testConfigFile = pkgs.buildValeConfig testConfig;
        testVale = pkgs.valeWithConfig testConfig;
      };
    })
    // {
      overlays.default = import ./overlay.nix;
    };
}
