# Vale-Nix

Configure [Vale](https://vale.sh) with Nix

## Usage

1. Add this flake to your flake inputs:

```nix
{
  inputs = {
    vale-nix.url = "github:icewind1991/vale-nix";
  };
}
```

2. Add `vale-nix.overlays.default` to the `nixpkgs` overlays in your flake.

```nix
  ...
  overlays = [
    vale-nix.overlays.default
  ];
  pkgs = (import nixpkgs) {
    inherit system overlays;
  };
  ...
```

3. Add `valeWithConfig ...` to your devShell

```nix
...
devShells.default = pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    ...
    (valeWithConfig {
      packages = styles: with styles; [microsoft readability];
      vocab = {
        accept = ["seccomp"];
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
...
```

4. Run `vale` as normal.