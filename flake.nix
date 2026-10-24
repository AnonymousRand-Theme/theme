{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;

      colors = import ./sources/colors.nix;

      generatedCommonCss =
        import ./sources/css/generate_common_css.nix colors { inherit lib; };

      persWebCustBootstrap =
        import ./configs/personal_website/scss/custom_bootstrap.nix colors;
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "generate-configs";
        version = "0.0.0";
        src = ./sources;
        dontUnpack = true;

        nativeBuildInputs = [
          pkgs.rsync
        ];

        # this passes the listed strings to the build/install environment as temporary files,
        # whose filenames are environment variables carrying the name of their attr name + "Path"
        passAsFile = [
          "generatedCommonCssColors"
          "generatedCommonCssAutoTheme"
          "generatedCommonCssLightTheme"
          "generatedCommonCssDarkTheme"

          "persWebCustBootstrap"
        ];
        generatedCommonCssColors     = generatedCommonCss.colors;
        generatedCommonCssAutoTheme  = generatedCommonCss.autoTheme;
        generatedCommonCssLightTheme = generatedCommonCss.lightTheme;
        generatedCommonCssDarkTheme  = generatedCommonCss.darkTheme;

        persWebCustBootstrap = persWebCustBootstrap.output;

        installPhase = ''
          set -euo pipefail
          set -x

          ######################################################################
          # create output directories

          mkdir -p "$out/"

          mkdir -p "$out/nix_config/"
          mkdir -p "$out/nix_config/css/"
          mkdir -p "$out/nix_config/scss/"

          mkdir -p "$out/personal_website/"
          mkdir -p "$out/personal_website/fonts/"
          mkdir -p "$out/personal_website/css/"
          mkdir -p "$out/personal_website/scss/"

          mkdir -p "$out/git_server/"
          mkdir -p "$out/git_server/fonts/"
          mkdir -p "$out/git_server/css/"

          ######################################################################
          # copy to output directories

          # `rsync` instead of `cp` allows us to recurse *and* not have to manually create subdirs
          rsync -r --exclude='*.sfd' \
            "$src/fonts/" "$out/personal_website/fonts/"
          rsync -r --exclude='*.sfd' --exclude='hachi_maru_pop.ttf' \
            "$src/fonts/" "$out/git_server/fonts/"

          cp "$src/colors.nix" "$out/nix_config/_colors.nix"

          cp -r "$src"/scss/* "$out/nix_config/scss/"
          cp -r "$src"/scss/* "$out/personal_website/scss/"

          cp "$generatedCommonCssColorsPath" "$out/nix_config/css/colors.css"
          cp "$generatedCommonCssColorsPath" "$out/personal_website/css/colors.css"
          cp "$generatedCommonCssColorsPath" "$out/git_server/css/colors.css"

          cp "$generatedCommonCssAutoThemePath" "$out/nix_config/css/noctalia_auto_theme.css"

          cp "$generatedCommonCssLightThemePath" "$out/nix_config/css/light_theme.css"
          cp "$generatedCommonCssLightThemePath" "$out/personal_website/css/light_theme.css"
          cp "$generatedCommonCssLightThemePath" "$out/git_server/css/theme-anonymousrand_light.css"

          cp "$generatedCommonCssDarkThemePath" "$out/nix_config/css/dark_theme.css"
          cp "$generatedCommonCssDarkThemePath" "$out/personal_website/css/dark_theme.css"
          cp "$generatedCommonCssDarkThemePath" "$out/git_server/css/theme-anonymousrand_dark.css"

          cp "$persWebCustBootstrapPath"   "$out/personal_website/scss/custom_bootstrap.scss"
        '';
      };
    };
}
