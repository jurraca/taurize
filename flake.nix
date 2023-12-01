{
  description = "Seer, a desktop Nostr Client.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
    # taurize.url = "github:jurraca/taurize";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: rec {
      pkgs = nixpkgs.legacyPackages.${system};

      beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlangR25;
      lib = nixpkgs.lib;
      testproject = beamPackages.mixRelease {
        pname = "testproject";
        src = ./.;
        mixNixDeps = import ./deps.nix {inherit lib beamPackages;};
        version = "0.0.2";
        mixEnv = "dev";
        buildInputs = [ pkgs.tailwindcss pkgs.esbuild ];

        preConfigure = ''
          substituteInPlace config/config.exs \
            --replace "config :tailwind," "config :tailwind, path: \"${pkgs.tailwindcss}/bin/tailwindcss\","\
            --replace "config :esbuild," "config :esbuild, path: \"${pkgs.esbuild}/bin/esbuild\", "

       '';

        # Deploy assets before creating release
        preInstall = ''
         # https://github.com/phoenixframework/phoenix/issues/2690
          mix do deps.loadpaths --no-deps-check, assets.deploy
        '';

        postInstall = ''
          # Tauri will look for app names + their system, so we must rename the output bin accordingly
          mv $out/bin/testproject $out/bin/testproject-x86_64-unknown-linux-gnu
        '';
      };

      desktop = import ./taurize.nix {
        inherit pkgs system;
        stdenv = pkgs.stdenv;
        app_name = testproject.pname ;
        binaryPath = testproject.out + "/bin/" + testproject.pname;
        host = "localhost";
        port = "4000";
      };

      defaultPackage = desktop;
      devShell = self.devShells.${system}.dev;
      devShells = {
        dev = import ./shell.nix {inherit pkgs;};
      };
      #apps.seer = utils.lib.mkApp { drv = packages.seer; };
      #hydraJobs = { inherit (legacyPackages) seer; };
      #checks = { inherit (legacyPackages) seer; };
    });
}
