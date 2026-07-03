{
  description = "Modern Node.js/TypeScript monorepo with Nix flakes and direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        baseTools = with pkgs; [ pnpm esbuild fnm ];

        mkDevShell =
          { packages ? [ ], shellName ? "default", tools ? "pnpm, esbuild, fnm" }:
          pkgs.mkShell {
            name = "demo-nix-shell-${shellName}";
            buildInputs = baseTools ++ packages;
            shellHook = ''
              export PATH="$PWD/node_modules/.bin:$PATH"
              eval "$(fnm env --use-on-cd)"
              echo -e "\033[32m Nix shell: ${shellName}\033[0m"
              echo -e "\033[36m Tools: ${tools}\033[0m"
            '';
          };

      in
      {
        devShells = {
          default = mkDevShell { };

          database = mkDevShell {
            shellName = "database";
            packages = with pkgs; [ redis ];
            tools = "pnpm, esbuild, fnm, redis";
          };

          testing = mkDevShell {
            shellName = "testing";
            packages = with pkgs; [ k6 httpie jq ];
            tools = "pnpm, esbuild, fnm, k6, httpie, jq";
          };

          devops = mkDevShell {
            shellName = "devops";
            packages = with pkgs; [ docker kubernetes-helm kubectl redis ];
            tools = "pnpm, esbuild, fnm, docker, kubernetes, helm, redis";
          };
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
