name:
{ lib }:
let
  # substitutions to make css vars more clear if needed; keep updated!
  suffixReplacements = {
    "border-1"       = "border-1-color";
    "border-2"       = "border-2-color";
    "border-3"       = "border-3-color";
    "border-4"       = "border-4-color";
    "border-5"       = "border-5-color";
    "border-default" = "border-default-color";
    "error"          = "error-color";
    "warning"        = "warning-color";
    "success"        = "success-color";
    "link"           = "link-fg";
    "link-hover"     = "link-hover-fg";
    "link-disabled"  = "link-disabled-fg";
    "link-visited"   = "link-visited-fg";
    "code-class"     = "code-class-fg";
    "code-comment"   = "code-comment-fg";
    "code-constant"  = "code-constant-fg";
    "code-function"  = "code-function-fg";
    "code-keyword"   = "code-keyword-fg";
    "code-variable"  = "code-variable-fg";
    "md-bold"        = "md-bold-fg";
    "md-itialic"     = "md-itialic-fg";
    "md-title"       = "md-title-fg";
    "md-code"        = "md-code-fg";
    "border"         = "border-color";
    "border-vrnt-1"  = "border-vrnt-1-color";
    "border-vrnt-2"  = "border-vrnt-2-color";
    "border-slct"    = "border-slct-color";
  };

  replaceSuffix = str:
    let
      matchingSuffixes = lib.filter (suffix: lib.hasSuffix suffix str)
        (builtins.attrNames suffixReplacements);
    in
    (
      if matchingSuffixes == [] then
        str
      else
        let
          # IMPORTANT: this assumes only one of the suffixes can be matched by any given string!
          matchedSuffix = builtins.head matchingSuffixes;
        in
        (lib.removeSuffix matchedSuffix str) + suffixReplacements.${matchedSuffix}
    );

  replaceUndscoreWithHyphen = str:
    builtins.replaceStrings [ "_" ] [ "-" ] str;
in
{
  output = replaceSuffix (replaceUndscoreWithHyphen name);
}
