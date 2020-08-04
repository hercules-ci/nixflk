{
  services.xserver.displayManager = {

    defaultSession = "none+xmonad";

    sddm. autoLogin = {
      enable = true;
      user = "nrd";
    };
  };
}
