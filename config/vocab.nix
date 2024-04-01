{
  lib,
  vale,
  writeTextFile,
  symlinkJoin,
}: let
  inherit (builtins) concatStringsSep compareVersions;
  useOldVocabPath = compareVersions vale.version "3.0.0" < 0;
  vocabPath =
    if useOldVocabPath
    then "Vocab"
    else "config/vocabularies";
in
  {
    accept ? [],
    reject ? [],
  }: let
    acceptFile = writeTextFile {
      name = "vale-vocab-accept";
      destination = "/${vocabPath}/Nix/accept.txt";
      text = concatStringsSep "\n" accept;
    };
    rejectFile = writeTextFile {
      name = "vale-vocab-reject";
      destination = "/${vocabPath}/Nix/reject.txt";
      text = concatStringsSep "\n" reject;
    };
  in
    symlinkJoin {
      name = "vale-vocab";
      paths = [acceptFile rejectFile];
    }
