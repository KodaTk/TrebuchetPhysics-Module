
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    python313
    python313Packages.matplotlib
    python313Packages.pillow
    stdenv.cc.cc.lib
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ]}:$LD_LIBRARY_PATH"

    echo "Python plotting environment ready."
  '';
}

