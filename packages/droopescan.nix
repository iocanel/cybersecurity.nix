{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "droopescan";
  version = "1.45.1";

  src = fetchFromGitHub {
    owner = "SamJoan";
    repo = "droopescan";
    rev = version;
    sha256 = "sha256-2Z29tWf1WlYa4Brxi2sSm2xkVrfajY2z0ku0a7GL5bY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    cement
    requests
    pystache
  ];

  # Tests require network access and specific CMS installations
  doCheck = false;

  meta = with lib; {
    description = "A plugin-based scanner that aids security researchers identify issues with several CMS";
    longDescription = ''
      droopescan is a plugin-based scanner that aids security researchers in
      identifying issues with several CMSs, mainly Drupal & Wordpress.
    '';
    homepage = "https://github.com/droope/droopescan";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "droopescan";
  };
}