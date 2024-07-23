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
      inherit (pkgs) callPackage;

      pkgs = import nixpkgs { inherit system; };
      mkPackages = list: nixpkgs.lib.genAttrs list (pname: callPackage ./nix/${pname}.nix {});
    in
      mkPackages [
        "chp"
        "eat"
        "play"
      ]
    );
  };
}
