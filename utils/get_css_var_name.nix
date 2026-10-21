name:
let
  replaceUndscoreWithHyphen = str:
    builtins.replaceStrings [ "_" ] [ "-" ] str;
in
{
  output = "color-${(replaceUndscoreWithHyphen name)}";
}
