username: {
  lib,
  config,
  pkgs,
  ...
}: {
  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups =
      ["wheel" "input" "audio" "video"];
  };

  nix.settings.trusted-users = [username];

  home-manager.users."${username}" = {
    imports = [
      ./common
      ./${config.networking.hostName}
    ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.stateVersion = config.system.stateVersion;
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
}
