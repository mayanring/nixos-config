{
  description = "system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let

    system = "x86_64-linux";
    username = "ryan";

    overlays = [];

    pkgs = import nixpkgs {
      inherit system;
      overlays = overlays;
      config.allowUnfree = true;
    };

    mkHost = { hostname, stateVersion }: (nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      specialArgs = {inherit inputs stateVersion hostname username system;};

      modules = [
        ./system.nix

        (./. + "/hosts/${hostname}/hardware-configuration.nix")
        (./. + "/hosts/${hostname}/configuration.nix")

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = {inherit inputs stateVersion hostname username system;};
            users.${username} = import ./home.nix;
          };
        }
      ];
    });
  in {
    nixosConfigurations = {
      chillymoon = mkHost {
        hostname = "chillymoon";
        stateVersion = "25.05";
      };
    };
  };
}
