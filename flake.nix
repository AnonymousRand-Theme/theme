{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;

      colors = import ./colors.nix;

      generatedCommonCss =
        import ./files/generate_common_css.nix colors { inherit lib; };

      persWebDarkreaderFixes =
        import ./files/personal_website/css/generate_darkreader_fixes.nix colors { inherit lib; };
      persWebCustBootstrap =
        import ./files/personal_website/scss/custom_bootstrap.nix colors;
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "generate-color-configs";
        version = "0.0.0";
        # to avoid breakage as there is no `src`
        dontUnpack = true;

        # this passes the listed strings to the build/install environment as temporary files,
        # whose filenames are environment variables carrying the name of their attr name + "Path"
        passAsFile = [
          "generatedCommonCssColors"
          "generatedCommonCssAutoTheme"
          "generatedCommonCssLightTheme"
          "generatedCommonCssDarkTheme"

          "persWebDarkreaderFixes"
          "persWebCustBootstrap"
        ];
        generatedCommonCssColors     = generatedCommonCss.colors;
        generatedCommonCssAutoTheme  = generatedCommonCss.autoTheme;
        generatedCommonCssLightTheme = generatedCommonCss.lightTheme;
        generatedCommonCssDarkTheme  = generatedCommonCss.darkTheme;

        persWebDarkreaderFixes  = persWebDarkreaderFixes.output;
        persWebCustBootstrap    = persWebCustBootstrap.output;

        mainColorsFile = ./colors.nix;

        installPhase = ''
          set -euo pipefail
          set -x

          mkdir -p $out/
          mkdir -p $out/nix_config/
          mkdir -p $out/nix_config/css/
          mkdir -p $out/personal_website/
          mkdir -p $out/personal_website/css/
          mkdir -p $out/personal_website/scss/
          mkdir -p $out/git_server/

          cp "$mainColorsFile" "$out/nix_config/_colors.nix"

          cp "$generatedCommonCssColorsPath" "$out/nix_config/css/colors.css"
          cp "$generatedCommonCssColorsPath" "$out/personal_website/css/colors.css"
          cp "$generatedCommonCssColorsPath" "$out/git_server/colors.css"

          cp "$generatedCommonCssAutoThemePath" "$out/nix_config/css/noctalia_auto_theme.css"

          cp "$generatedCommonCssLightThemePath" "$out/nix_config/css/light_theme.css"
          cp "$generatedCommonCssLightThemePath" "$out/personal_website/css/light_theme.css"
          cp "$generatedCommonCssLightThemePath" "$out/git_server/theme-anonymousrand_light.css"

          cp "$generatedCommonCssDarkThemePath" "$out/nix_config/css/dark_theme.css"
          # commented out since currently personal website does not use this
          # cp "$generatedCommonCssDarkThemePath" "$out/personal_website/css/dark_theme.css"
          cp "$generatedCommonCssDarkThemePath" "$out/git_server/theme-anonymousrand_dark.css"

          cp "$persWebDarkreaderFixesPath" "$out/personal_website/css/darkreader_fixes.css"
          cp "$persWebCustBootstrapPath"   "$out/personal_website/scss/custom_bootstrap.scss"
        '';
      };
    };
}
