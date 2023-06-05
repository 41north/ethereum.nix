{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  lz4,
  rocksdb,
  snappy,
  stdenv,
  zstd,
}:
buildDotnetModule rec {
  pname = "nethermind";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "NethermindEth";
    repo = pname;
    rev = version;
    hash = "sha256-fT1vmIOp41Gbtrtg2mJQv7ZsdzjzJKajfcUIZZ5LhFk=";
    fetchSubmodules = true;
  };

  buildInputs = [
    lz4
    snappy
    stdenv.cc.cc.lib
    zstd
  ];

  runtimeDeps = [
    rocksdb
    snappy
  ];

  patches = [
    ./001-Remove-Commit-Fallback.patch
  ];

  projectFile = "src/Nethermind/Nethermind.sln";
  nugetDeps = ./nuget-deps.nix;

  executables = [
    "Nethermind.Cli"
    "Nethermind.Runner"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;

  meta = {
    description = "Our flagship Ethereum client for Linux, Windows, and macOS—full and actively developed";
    homepage = "https://nethermind.io/nethermind-client";
    license = lib.licenses.gpl3;
    mainProgram = "Nethermind.Runner";
    platforms = ["x86_64-linux"];
  };
}
