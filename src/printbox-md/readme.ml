(* This file is free software. See file "license" for more details. *)

module B = PrintBox
module MD = PrintBox_md

let () = print_endline {|# PrintBox-md: a Markdown backend for PrintBox

## Coverage of Markdown and `PrintBox` constructions

### Single-line and multiline text
|}

let () = print_endline MD.(to_string Config.default @@ B.lines [
    "Multiline text is printed using Markdown's syntax for forced line breaks:";
    "  a pair of trailing whitespace.";
    "    Line wrapping is not prevented unless the text is styled as preformatted.";
    "  However, we pay attention to whitespace in the text     --    ";
    "we don't allow HTML to ignore the spaces."
  ])

let () = print_endline MD.(to_string Config.default @@ B.lines_with_style B.Style.preformatted [
    "Preformatted text like this one can be output in two different styles:";
    "  Code_block and Code_quote.";
    "    The style can be changed for both multiline and single-line text."
  ])

let () = print_endline MD.(to_string Config.(multiline_preformatted Code_quote default)
  @@ B.lines_with_style B.Style.preformatted [
    "So it is possible to use [Code_quote] even with multiline text,";
    "  which leads to a contrasting visual effect.";
    "    Since Markdown's code quotes would otherwise     ignore whitespace,";
    "  we use our trick to preserve -->                   these spaces."
  ])

let () = print_endline {|### Horizontal boxes i.e. `PrintBox.hlist`
|}
  
let () = print_endline MD.(to_string Config.default @@ B.(hlist ~bars:false [
    line "The";
    line_with_style Style.preformatted "`Minimal";
    line "style for horizontal boxes simply puts all entries on a line, ";
    line "separated by extra spaces,"
  ]))

let () = print_endline MD.(to_string Config.default @@ B.(hlist ~bars:true [
    line "or if `Bars are set,";
    line " by the"; line "vertical dash."
  ]))

let () = print_endline MD.(to_string Config.(html_tables default) @@ B.(hlist ~bars:true [
    lines ["It only works when"; "all the elements fit"];
    line "logically speaking,"; line_with_style Style.bold "on a single line."
  ]))

let () = print_endline MD.(to_string Config.(html_tables @@ hlists `As_table default)
  @@ B.(hlist ~bars:false [
    line "Otherwise, the fallback behavior is as if";
    line_with_style Style.preformatted "`As_table";
    line "was used to configure horizontal boxes."
  ]))

let () = print_endline {|### Vertical boxes i.e. `PrintBox.vlist`
|}

let () = print_endline MD.(to_string Config.(vlists `List default)
  @@ B.(vlist ~bars:false [
    line "Vertical boxes can be configured in three ways:";
    hlist ~bars:false [
      line_with_style Style.preformatted "`Line_break";
      line "which simply adds an empty line after each entry"];
    hlist ~bars:false [
      line_with_style Style.preformatted "`List";
      line "which lists the entries"];
    hlist ~bars:false [
      line "and the fallback we saw already,";
      line_with_style Style.preformatted "`As_table"];
  ]))

let () = print_endline MD.(to_string Config.(vlists `Line_break default)
  @@ B.(vlist ~bars:true [
    line "Vertical boxes with bars";
    hlist ~bars:false [
      line_with_style Style.preformatted "(vlist ~bars:true)";
      line "use a quoted horizontal ruler"];
    line "to separate the entries (here with style `Line_break)."
  ]))

let () = print_endline {|### Frames
|}

let () = print_endline MD.(to_string Config.(vlists `Line_break default)
  @@ B.(
    frame @@ vlist ~bars:true [
      line "Frames use quotation to make their content prominent";
      hlist ~bars:false [
        line "except when in a non-block position";
        frame @@ line "then they use"; line "square brackets"];
      line "(which also helps with conciseness)."
  ]))

let () = print_endline MD.(to_string Config.(table_frames @@ vlists `Line_break default)
  @@ B.(
    frame @@ vlist ~bars:true [
      line "There is also a fallback";
      hlist ~bars:false [
        line "which generates all";
        frame @@ line "frames, using"; line "the same approach as for tables"]
  ]))

let () = print_endline MD.(to_string Config.(table_frames @@ vlists `List default)
  @@ B.(
    vlist ~bars:false [
      line "This even works OK-ish";
      line "when the frame";
      frame @@ line "is nested";
      line "inside Markdown."
  ]))

let () =
  print_endline MD.(to_string Config.(html_tables @@ table_frames @@ vlists `List default)
  @@ B.(
    vlist ~bars:false [
      line "And suprisingly it works even better";
      vlist ~bars:false [
        line "when tables are configured";
        frame @@ line "to fallback on";
        line "HTML."];
      line "Although it probably won't be perfect."
  ]))

let () = print_endline {|### Trees
|}

let () = print_endline MD.(to_string Config.default
  @@ B.(
    tree (line "Trees are rendered as:") [
      line "The head element";
      frame @@ line "followed by";
      line "a list of the child elements."
  ]))

let () = print_endline MD.(to_string Config.(foldable_trees default)
  @@ B.(
    tree (line "Trees can be made foldable:") [
      line "The head element";
      frame @@ line "is the summary";
      tree (line "and the children...") [line_with_style Style.bold "are the details."]
  ]))

let () = print_endline {|### Tables

There is a special case carved out for Markdown syntax tables.
|}

let () = print_endline MD.(to_string Config.default
  @@ B.(
    let bold = text_with_style Style.bold in
    grid_l [
      [ bold "Header"; bold "cells"; frame @@ bold "must be"; bold "bold." ];
      [ line "Rows"; frame @@ line "must be"; line "single"; line "line." ];
      [ frame @@ line "Only"; line "then"; bold "we get"; line "a Markdown table." ];
    ]))

let () = print_endline MD.(to_string Config.(html_tables default)
  @@ B.(
    let bold = text_with_style Style.bold in
    let code = text_with_style Style.preformatted in
    grid_l [
      [ bold "Tables"; bold "that meet"; frame @@ bold "neither"; bold "of:" ];
      [ frame @@ bold "Markdown's native"; line "restrictions,";
        line "special cases:"; code "hlist\nvlist" ];
      [ line "End up"; line "as either";
        line "of the fallbacks:"; code "printbox-text\nprintbox-html" ];
    ]))
