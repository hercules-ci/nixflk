{ unstablePkgs, ... }: {

  environment.systemPackages = with unstablePkgs; [ protonvpn-cli-ng ];

  systemd.services.protonvpn = with unstablePkgs; {
    enable = true;
    after = [ "network-online.target" ];
    description = "Auto-Connect to Fastest ProtonVPN Server";
    wantedBy = [ "multi-user.target" ];

    path = [ which iproute procps ];

    environment = {
      PVPN_WAIT = "300";
      PVPN_DEBUG = "1";
    };

    serviceConfig = {
      Type = "forking";
      ExecStart = "${protonvpn-cli-ng}/bin/protonvpn c -f";
      ExecStop = "${protonvpn-cli-ng}/bin/protonvpn d";
    };
  };
}
