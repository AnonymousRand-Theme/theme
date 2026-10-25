colors:
{ lib }:
let
  cssVarName = name: (import ../../utils/get_css_var_name.nix name).output;

  generateCssStr = lines: ''
    :root {
      ${lib.concatStringsSep "\n  " lines}
    }
  '';

  colorsLines = lib.mapAttrsToList (name: value:
    # yes, we do want an extra hyphen here
    "----${cssVarName name}: ${colors.vars.${name}};"
  ) colors.vars;

  autoThemeLines = lib.mapAttrsToList (name: value:
    # currently in format for noctalia templates, as this is currently how we are doing auto theme
    "---${cssVarName name}: {{colors.${name}_source.default.hex}};"
  ) colors.themed;

  lightThemeLines = (
    lib.mapAttrsToList (name: value:
      "---${cssVarName name}: ${colors.themed.${name}.color_light};"
    ) colors.themed
  ) ++ [ "color-scheme: light;" ];

  darkThemeLines = (
    lib.mapAttrsToList (name: value:
      "---${cssVarName name}: ${colors.themed.${name}.color_dark};"
    ) colors.themed
  ) ++ [ "color-scheme: dark;" ];
in
{
  colors     = generateCssStr colorsLines;
  autoTheme  = generateCssStr autoThemeLines;
  lightTheme = generateCssStr lightThemeLines;
  darkTheme  = generateCssStr darkThemeLines;
}
