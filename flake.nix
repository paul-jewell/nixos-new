{
  description = "Home manager configuration for my systems";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }:
    let     
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };
      username = "paul";

      mkHost = {
        hostName,
          system,
          pkgs,
          modules,
      }: {
        ${hostName} = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            
            ./host/common
            ./host/${hostName}
            ({lib, ...}: {networking.hostName = lib.mkDefault hostName;})
            
            (import ./home username)
          ]
          ++ modules;
        };
      };
    in {
      nixosConfigurations =
        (mkHost {
          inherit system;
          inherit pkgs;
          
          hostName = "isolde";
          
          modules = [nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3];
        });
    };
}
