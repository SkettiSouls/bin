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
      inherit (nixpkgs.lib) mkIf escapeShellArgs;
      pkgs = import nixpkgs { inherit system; };

      mkScript = name: deps:
        pkgs.stdenvNoCC.mkDerivation {
          name = name;
          nobuild = true;
          src = ./bash;
          nativeBuildInputs = if deps != [] then [ pkgs.makeWrapper ] else [];
          installPhase = let
            depPaths = map (p: ["--prefix" "PATH" ":" "${p}/bin"]) deps;
          in ''
            mkdir -p $out/bin
            cp $src/${name} $out/bin/${name}
          '' + (if deps != [] then ''
            for file in $out/bin/*; do
              wrapProgram \
                $file \
                ${escapeShellArgs (nixpkgs.lib.flatten depPaths)}
            done
          '' else "");
        };
    in
    {
      chp = mkScript "chp" [ pkgs.bluez ];
      eat = mkScript "eat" [];
      grime = with pkgs; mkScript "grime" [ libnotify grim slurp ];
      play = mkScript "play" [ pkgs.mpv pkgs.fzf ];
    });
  };
}
