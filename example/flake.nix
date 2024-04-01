{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-23.11";
    vale-nix.url = "github:icewind1991/vale-nix";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    vale-nix,
  }:
    utils.lib.eachDefaultSystem (system: let
      overlays = [
        vale-nix.overlays.default
      ];
      pkgs = (import nixpkgs) {
        inherit system overlays;
      };
    in rec {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          (valeWithConfig {
            packages = styles: with styles; [microsoft readability];
            vocab = {
              accept = ["devshell"];
            };
            formatOptions = {
              "*" = {
                basedOnStyles = ["Vale" "Microsoft" "Readability"];
                "Microsoft.Passive" = true;
              };
            };
          })
        ];
      };
    });
}
