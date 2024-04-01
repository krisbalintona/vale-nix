# Vale-Nix

Configure [Vale](https://vale.sh) with Nix

## Usage

See ./example/flake.nix for an example of how to use this in a flake's devshell 

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

3. Add `valeWithConfig ...` to your devshell

```nix
...
devShells.default = pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    ...
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
...
```

4. Run `vale` as normal.