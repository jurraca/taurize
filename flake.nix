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
        RELEASE_DISTRIBUTION = "none";

        postInstall = ''
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
