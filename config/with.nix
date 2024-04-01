{
  writeShellScriptBin,
  buildValeConfig,
  vale,
}: config:
writeShellScriptBin "vale" ''
  ${vale}/bin/vale --config ${buildValeConfig config} $@
''
