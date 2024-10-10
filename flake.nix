{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:/nix-systems/default";
  };

  outputs = inputs: with inputs;
  let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    packages = eachSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      mkScript = name: deps:
        pkgs.stdenvNoCC.mkDerivation {
          name = name;
          nobuild = true;
          src = ./bash;
          nativeBuildInputs = deps;
          installPhase = ''
            mkdir -p $out/bin
            cp $src/${name} $out/bin/${name}
          '';
        };
    in
    {
      chp = mkScript "chp" [];
      eat = mkScript "eat" [];
      grime = with pkgs; mkScript "grime" [ libnotify grim slurp ];
      play = mkScript "play" [ pkgs.mpv pkgs.fzf ];
    });
  };
}
