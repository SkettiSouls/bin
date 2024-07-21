{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "music-formatter";
  version = "1.0";
  nobuild = true;
  src = ../.;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/mus $out/bin/mfs
  '';
}
