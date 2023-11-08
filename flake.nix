{
  description = "Seer, a desktop Nostr Client.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=master";
    utils.url = "github:numtide/flake-utils";
    # taurize.url = "github:jurraca/taurize";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }: let
  in
    utils.lib.eachDefaultSystem (system: rec {
      pkgs = nixpkgs.legacyPackages.${system};

      beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlangR25;
      lib = nixpkgs.lib;
      testproject = beamPackages.mixRelease {
        pname = "testproject";
        src = ./.;
        mixNixDeps = import ./deps.nix {inherit lib beamPackages;};
        version = "0.0.0";
        RELEASE_DISTRIBUTION = "none";
      };

      desktop = import ./taurize.nix {
        inherit pkgs system;
        stdenv = pkgs.stdenv;
        binaryPath = testproject.out + "/bin/desktop";
        app_name = testproject.pname;
        host = "";
        port = "";
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
