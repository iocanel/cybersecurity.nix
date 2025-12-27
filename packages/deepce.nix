{ pkgs, lib }:

pkgs.stdenv.mkDerivation rec {
  pname = "deepce";
  version = "2024-12-18";
  
  src = pkgs.fetchFromGitHub {
    owner = "stealthcopter";
    repo = "deepce";
    rev = "420b1d1ddb636f6bd277a105f580cd09b03517cc";
    sha256 = "sha256-bLwLuC8FqWQvgqqM+TF252eJ9jo1MV0Y68kXk67izFM=";
  };
  
  installPhase = ''
    mkdir -p $out/bin
    cp $src/deepce.sh $out/bin/deepce
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