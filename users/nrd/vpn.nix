{ unstablePkgs, ... }: {

  environment.systemPackages = with unstablePkgs; [ protonvpn-cli-ng ];

  # needed to prevent dnsleaks on nixos-rebuilds
  system.activationScripts.vpn = with unstablePkgs; ''
    PATH=${which}/bin:${iproute}/bin:${procps}/bin:$PATH
    ${protonvpn-cli-ng}/bin/protonvpn c -f
  '';
}
