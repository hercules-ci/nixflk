{ lib, pkgs, ... }:
let
  inherit (lib) fileContents;
  inherit (pkgs) writeText;

  config = fileContents ../../secrets/us-co-06.ovpn;
  vpn = fileContents ../../secrets/vpn;
  pass = writeText "vpn" vpn;
in {
  imports = [ ../../profiles/misc/stubby.nix ];

  services.openvpn.servers = {
    "US-CO_6" = with pkgs; {
      config = ''
        ${config}
        auth-user-pass ${pass}
      '';
      up = ''
        ${e2fsprogs}/bin/chattr -i /etc/resolv.conf
        mv /etc/resolv.conf /etc/resolv.conf.old
        echo nameserver $nameserver > /etc/resolv.conf
        echo options edns0 >> /etc/resolv.conf
        ${e2fsprogs}/bin/chattr +i /etc/resolv.conf
      '';
      down = ''
        ${e2fsprogs}/bin/chattr -i /etc/resolv.conf
        mv /etc/resolv.conf.old /etc/resolv.conf
        ${e2fsprogs}/bin/chattr +i /etc/resolv.conf
      '';
    };
  };

  # needed to prevent dnsleaks on nixos-rebuilds
  system.activationScripts = {
    vpn = {
      text = with pkgs; ''
        if grep 127.0.0.1 /etc/resolv.conf > /dev/null; then
          ${e2fsprogs}/bin/chattr -i /etc/resolv.conf

          ${systemd}/bin/systemctl restart openvpn-US-CO_6.service && \
            ${e2fsprogs}/bin/chattr +i /etc/resolv.conf
        fi
      '';
      deps = [ ];
    };
  };
}
