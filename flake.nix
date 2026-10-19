{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    let
      system = "x64_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;

      colors = import ./colors.nix;

      generatedCss =
        import ./generate_css.nix colors { inherit lib pkgs; };
      personalWebsiteCustomBootstrapFile =
        import ./files/personal_website/scss/custom_bootstrap.nix colors;
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "generate-color-configs";
        version = "0.0.0";
        # needed to copy `colors.nix` to nix config
        src = ./colors.nix;
        dontUnpack = true;

        # this passes the listed strings to the build/install environment as temporary files,
        # whose filenames are environment variables carrying the name of their attr name + "Path"
        passAsFile = [
          generatedCssColors
          generatedCssAutoTheme
          generatedCssLightTheme
          generatedCssDarkTheme
          personalWebsiteCustomBootstrap
        ];
        generatedCssColors             = generatedCssFile.colors;
        generatedCssAutoTheme          = generatedCssFile.autoTheme;
        generatedCssLightTheme         = generatedCssFile.lightTheme;
        generatedCssDarkTheme          = generatedCssFile.darkTheme;
        personalWebsiteCustomBootstrap = personalWebsiteCustomBootstrapFile.output;

        installPhase = ''
          mkdir -p $out/
          mkdir -p $out/nix_config/
          mkdir -p $out/nix_config/css/
          mkdir -p $out/personal_website/
          mkdir -p $out/personal_website/css/
          mkdir -p $out/personal_website/scss/
          mkdir -p $out/git_server/

          cp ./colors.nix $out/nix_config/_colors.nix

          cp $generatedCssColorsPath $out/nix_config/css/colors.css
          cp $generatedCssColorsPath $out/personal_website/css/colors.css
          cp $generatedCssColorsPath $out/git_server/colors.css

          cp $generatedCssAutoThemePath $out/nix_config/css/noctalia_auto_theme.css

          cp $generatedCssLightThemePath $out/nix_config/css/light_theme.css
          cp $generatedCssLightThemePath $out/personal_website/css/light_theme.css
          cp $generatedCssLightThemePath $out/git_server/theme-anonymousrand_light.css

          cp $generatedCssDarkThemePath $out/nix_config/css/dark_theme.css
          cp $generatedCssDarkThemePath $out/personal_website/css/dark_theme.css
          cp $generatedCssDarkThemePath $out/git_server/theme-anonymousrand_dark.css

          cp $personalWebsiteCustomBootstrapPath $out/personal_website/scss/custom_bootstrap.scss
        '';
      };
    };
}
