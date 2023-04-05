{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ./boot.nix ./nix.nix];

  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.gnupg = {
      enable = true;
      noAutostart = true;
      storeOnly = true;
    };
    gtklock.gnupg = config.security.pam.services.login.gnupg;
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      PowerKeyIgnoreInhibited=yes
      LidSwitchIgnoreInhibited=no
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
  '';

  environment.systemPackages = with pkgs; [neovim];

  system.stateVersion = "22.11";
}
