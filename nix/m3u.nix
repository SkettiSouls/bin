{ fzf, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "create-playlist";
  version = "1.0";
  nobuild = true;
  src = ../.;
  nativeBuildInputs = [ fzf ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/m3u $out/bin/m3u
  '';
}
