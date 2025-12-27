{ pkgs, lib }:

pkgs.stdenv.mkDerivation rec {
  pname = "deepce";
  version = "2024-12-18";
  
  src = pkgs.fetchurl {
    url = "https://github.com/stealthcopter/deepce/raw/main/deepce.sh";
    sha256 = "1q449pj2nfrbw78p4hwvv3bj69243z2lxjji53xip8lki87ra978";
  };
  
  dontUnpack = true;
  dontBuild = true;
  
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/deepce
    chmod +x $out/bin/deepce
  '';
  
  meta = with lib; {
    description = "Docker Enumeration, Escalation of Privileges and Container Escapes";
    homepage = "https://github.com/stealthcopter/deepce";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}