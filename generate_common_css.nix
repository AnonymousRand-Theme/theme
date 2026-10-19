colors:
{ lib, pkgs }:
let
  generateCssStr = lines: ''
    :root {
      ${lib.concatStringsSep "\n  " lines}
    }
  '';

  colorsLines = lib.mapAttrsToList (name: value:
    builtins.replaceStrings cssVarNameSubstsFrom cssVarNameSubstsTo (
      # yes, we do want an extra hyphen here
      "----${builtins.replaceStrings [ "_" ] [ "-" ] name}: "
      + "{{colors.${name}_source.default.hex}};"
    )
  ) colors.vars;

  autoThemeLines = lib.mapAttrsToList (name: value:
    builtins.replaceStrings cssVarNameSubstsFrom cssVarNameSubstsTo (
      "---${builtins.replaceStrings [ "_" ] [ "-" ] name}: "
      + "{{colors.${name}_source.default.hex}};"
    )
  ) colors.themed;

  lightThemeLines = lib.mapAttrsToList (name: value:
    builtins.replaceStrings cssVarNameSubstsFrom cssVarNameSubstsTo (
      "---${builtins.replaceStrings [ "_" ] [ "-" ] name}: "
      + "{{colors.${name}_source.light.hex}};"
    )
  ) colors.themed;

  darkThemeLines = lib.mapAttrsToList (name: value:
    builtins.replaceStrings cssVarNameSubstsFrom cssVarNameSubstsTo (
      "---${builtins.replaceStrings [ "_" ] [ "-" ] name}: "
      + "{{colors.${name}_source.dark.hex}};"
    )
  ) colors.themed;

  # substitutions to make css vars more clear if needed; keep updated!
  cssVarNameSubstsFrom = [
    "-border-1:"
    "-border-2:"
    "-border-3:"
    "-border-4:"
    "-border-5:"
    "-border-default:"
    "-error:"
    "-warning:"
    "-success:"
    "-link:"
    "-link-hover:"
    "-link-disabled:"
    "-link-visited:"
    "-code-class:"
    "-code-comment:"
    "-code-constant:"
    "-code-function:"
    "-code-keyword:"
    "-code-variable:"
    "-md-bold:"
    "-md-itialic:"
    "-md-title:"
    "-md-code:"
    "-border:"
    "-border-vrnt-1:"
    "-border-vrnt-2:"
    "-border-slct:"
  ];

  cssVarNameSubstsTo = [
    "-border-1-color:"
    "-border-2-color:"
    "-border-3-color:"
    "-border-4-color:"
    "-border-5-color:"
    "-border-default-color:"
    "-error-color:"
    "-warning-color:"
    "-success-color:"
    "-link-fg:"
    "-link-hover-fg:"
    "-link-disabled-fg:"
    "-link-visited-fg:"
    "-code-class-fg:"
    "-code-comment-fg:"
    "-code-constant-fg:"
    "-code-function-fg:"
    "-code-keyword-fg:"
    "-code-variable-fg:"
    "-md-bold-fg:"
    "-md-itialic-fg:"
    "-md-title-fg:"
    "-md-code-fg:"
    "-border-color:"
    "-border-vrnt-1-color:"
    "-border-vrnt-2-color:"
    "-border-slct-color:"
  ];
in
{
  colors     = generateCssStr colorsLines;
  autoTheme  = generateCssStr autoThemeLines;
  lightTheme = generateCssStr lightThemeLines;
  darkTheme  = generateCssStr darkThemeLines;
}
