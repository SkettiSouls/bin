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

      scripts = with builtins; mapAttrs (script: _: pkgs.stdenvNoCC.mkDerivation {
        name = script;
        nobuild = true;
        src = ./bash;
        installPhase = ''
          mkdir -p $out/bin
          cp $src/${script} $out/bin/${script}
        '';
      }) (readDir ./bash);

      mkScript = name: deps:
        pkgs.writeShellApplication {
          name = name;
          runtimeInputs = deps;
          text = ''
            ${scripts.${name}}/bin/${name} "$@"
          '';
        };
    in {
      chp = mkScript "chp" [ pkgs.bluez ];
      eat = mkScript "eat" [];
      grime = with pkgs; mkScript "grime" [ libnotify grim slurp ];
      play = mkScript "play" [ pkgs.mpv pkgs.fzf ];
    });
  };
}
