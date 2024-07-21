{ mpv, fzf, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "play";
  version = "1.0";
  nobuild = true;
  src = ../.;
  nativeBuildInputs = [ mpv fzf ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/play $out/bin/play
  '';
}
