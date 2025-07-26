let
  pkgs = import <nixpkgs> {config.allowUnfree = true;};
in pkgs.mkShell {
  packages = [
    pkgs.ansible
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.jmespath
      python-pkgs.pip
      python-pkgs.proxmoxer
      python-pkgs.pynetbox
      python-pkgs.pytz
    ]))
    pkgs.bws
    pkgs.sshpass
  ];

  shellHook = ''
    export $(cat .env | xargs)
  '';
  
}