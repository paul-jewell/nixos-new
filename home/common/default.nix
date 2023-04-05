{
  lib,
  config,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./sway
  ];

  home.packages = with pkgs; [
    neovim
  ];

  xsession.preferStatusNotifierItems = true; # needed for network-manager-applet
  services.network-manager-applet.enable =
    lib.mkDefault nixosConfig.networking.networkmanager.enable;
}
