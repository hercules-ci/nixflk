{ lib, pkgs, ... }:
let
  inherit (lib) fileContents;
  inherit (pkgs) writeText;

  config = fileContents ../../secrets/us-co-06.ovpn;
  vpn = fileContents ../../secrets/vpn;
  pass = writeText "vpn" vpn;
in {
  services.openvpn.servers = {
    "US-CO_6" = {
      config = ''
        ${config}
        auth-user-pass ${pass}
      '';
      up = ''
        mv /etc/resolv.conf /etc/resolv.conf.old
        echo nameserver $nameserver > /etc/resolv.conf
        echo options edns0 >> /etc/resolv.conf
      '';
      down = "mv /etc/resolv.conf.old /etc/resolv.conf";
    };
  };
}
