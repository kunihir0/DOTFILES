{ config, pkgs, ... }:

let
  myOverlay = self: super: {
    discord = super.discord.override { withOpenASAR = true; withVencord = true; };
  };
in
{
  imports = [
    ./home-services.nix
    ./home-packages.nix
  ];

  home = {
    username = "kunihir0";
    homeDirectory = "/home/kunihir0";
    stateVersion = "23.05";
    file = {
      # ...
    };

    sessionVariables = {
      EDITOR = "nano";
      PATH = "$PATH:/home/kunihir0/.pnpm-global-bin";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ myOverlay ];

  programs.home-manager.enable = true;

}
