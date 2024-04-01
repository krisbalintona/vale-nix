{
  lib,
  symlinkJoin,
  valeStyles,
  buildValeVocab,
  writeTextFile,
}: let
  inherit (builtins) concatStringsSep removeAttrs mapAttrs;
  inherit (lib.strings) toLower;
  inherit (lib.generators) toINIWithGlobalSection;
  stringList = concatStringsSep ", ";
  makeFormatOption = options: let
    rest = removeAttrs options ["basedOnStyles"];
  in
    {
      BasedOnStyles = stringList options.basedOnStyles or [];
    }
    // rest;
in
  {
    minAlertLevel ? "warning",
    packages ? _: [],
    formatOptions ? {},
    vocab ? {},
  }: let
    pickedPackages = packages valeStyles;
    packageNames = map (package: package.passthru.packageName) pickedPackages;
  in
    writeTextFile {
      name = "vale-config.ini";
      text = toINIWithGlobalSection {} {
        globalSection = {
          StylesPath = symlinkJoin {
            name = "vale-packages";
            paths =
              pickedPackages
              ++ [
                (buildValeVocab vocab)
              ];
          };
          Vocab = "Nix";
          MinAlertLevel = minAlertLevel;
          Packages = stringList packageNames;
        };
        sections = mapAttrs (_: makeFormatOption) formatOptions;
      };
    }
