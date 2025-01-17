#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#

{ lib, inputs, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, nur, nixvim, doom-emacs, hyprland, plasma-manager, vars, ... }:

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  beelink = lib.nixosSystem {                               # Desktop Profile
    inherit system;
    specialArgs = {                                         # Pass Flake Variable
      inherit inputs system unstable hyprland vars;
      host = {
        hostName = "beelink";
        mainMonitor = "HDMI-A-2";
        secondMonitor = "HDMI-A-1";
      };
    };
    modules = [                                             # Modules Used
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./beelink
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager Module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  work = lib.nixosSystem {                                  # Work Profile
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland vars;
      host = {
        hostName = "work";
        mainMonitor = "eDP-1";
        secondMonitor = "HDMI-A-2";
        thirdMonitor = "DP-1";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./work
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  xps = lib.nixosSystem {                                  # Work Profile
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland vars;
      host = {
        hostName = "xps";
        mainMonitor = "eDP-1";
        secondMonitor = "DP-4";
      };
    };
    modules = [
      nixos-hardware.nixosModules.dell-xps-15-9500-nvidia
      nixvim.nixosModules.nixvim
      ./xps
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM Profile
    inherit system;
    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
        secondMonitor = "";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  h310m = lib.nixosSystem {                               # DEPRECATED Desktop Profile
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland vars;
      host = {
        hostName = "h310m";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "HDMI-A-2";
      };
    };
    modules = [
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./h310m
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${vars.user}.imports = [
          nixvim.homeManagerModules.nixvim
        ];
      }
    ];
  };

  probook = lib.nixosSystem {                               # DEPRECATED HP Probook Laptop Profile
    inherit system;
    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "probook";
        mainMonitor = "eDP-1";
        secondMonitor = "";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./probook
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
