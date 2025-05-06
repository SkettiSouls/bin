{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ { flake-parts, ... }:
  flake-parts.lib.mkFlake { inherit inputs; }
  {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    perSystem = { pkgs, ... }: {
      packages = let
        scripts = with builtins; mapAttrs
          (script: _: pkgs.stdenvNoCC.mkDerivation {
            name = script;
            nobuild = true;
            src = ./bash;
            installPhase = ''
              mkdir -p $out/bin
              cp $src/${script} $out/bin/${script}
            '';
          })
        (readDir ./bash);

        mkScript = name: runtimeInputs:
          pkgs.writeShellApplication {
            inherit name runtimeInputs;
            text = ''
              ${scripts.${name}}/bin/${name} "$@"
            '';
          };
      in {
        chp = mkScript "chp" [ pkgs.bluez pkgs.expect ];
        eat = mkScript "eat" [];
        grime = with pkgs; mkScript "grime" [ libnotify grim slurp ];
        play = mkScript "play" [ pkgs.mpv pkgs.fzf ];
      };
    };
  };
}
