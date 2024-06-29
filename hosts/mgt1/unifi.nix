{ pkgs, myvars, ... }:
{
  services.unifi.enable = true;
  services.unifi.unifiPackage = pkgs.unifi;

  services.nginx.virtualHosts."unifi.${myvars.domain}" = {
    forceSSL = true;
    useACMEHost = "unifi.${myvars.domain}";
    locations."/".proxyPass = "http://localhost:8443";
	  extraConfig = ''
		  proxy_set_header Host $host;
	  '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 
                        8080  # Port for UAP to inform controller.
                        #8880 # Port for HTTP portal redirect, if guest portal is enabled.
                        8843  # Port for HTTPS portal redirect, ditto.
                        #6789 # Port for UniFi mobile speed test.
                      ];
    allowedUDPPorts = [
                        3478  # UDP port used for STUN.
                        10001 # UDP port used for device discovery.
                      ];
  };
}