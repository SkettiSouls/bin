{ bluez, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "chp";
  version = "1.0";
  nobuild = true;
  src = ../.;
  nativeBuildInputs = [ bluez ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/chp $out/bin/connect-headphones
  '';
}
