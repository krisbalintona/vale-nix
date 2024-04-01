prev: final: {
  valeStyles = final.callPackage ./styles {};
  buildValeVocab = final.callPackage ./config/vocab.nix {};
  buildValeConfig = final.callPackage ./config/builder.nix {};
  valeWithConfig = final.callPackage ./config/with.nix {};
}
