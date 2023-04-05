{lib, ...}: {
  boot = {
    bootspec.enable = lib.mkDefault true;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
}

