{
  lib,
  vale,
  writeTextFile,
  symlinkJoin,
}: let
  inherit (builtins) concatStringsSep;
in
  {
    accept ? [],
    reject ? [],
  }: let
    acceptFile = writeTextFile {
      name = "vale-vocab-accept";
      destination = "/Vocab/Nix/accept.txt";
      text = concatStringsSep "\n" accept;
    };
    rejectFile = writeTextFile {
      name = "vale-vocab-reject";
      destination = "/Vocab/Nix/reject.txt";
      text = concatStringsSep "\n" reject;
    };
  in
    symlinkJoin {
      name = "vale-vocab";
      paths = [acceptFile rejectFile];
    }
