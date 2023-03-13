{
  buildDotnetModule,
  dotnet-sdk_7,
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
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "NethermindEth";
    repo = pname;
    rev = version;
    sha256 = "sha256-op/38huLtGeFJFG2Ly4bqws6MLnR86s6U+Mo5WUOAE4=";
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
  dotnet-test-sdk = dotnet-sdk_7;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;

  meta = with lib; {
    description = "Our flagship Ethereum client for Linux, Windows, and macOS—full and actively developed";
    homepage = "https://nethermind.io/nethermind-client";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
