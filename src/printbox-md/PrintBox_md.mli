(* This file is free software. See file "license" for more details. *)

(** {1 Output Markdown} *)

(** {2 Markdown configuration} *)
module Config : sig
  type preformatted = Code_block | Code_quote | Stylized
  (** The output option for preformatted-style text, and for outputting tables as text.
      - [Code_block]: use Markdown's backquoted-block style: [```], equivalent to HTML's [<pre>].
        Downside: Markdown's style classes make it extra prominent.
      - [Code_quote]: use Markdown's inline code style: single quote [`].
        Downside: does not respect whitespace. We convert leading spaces to "nbsp" for indentation.
      - [Stylized]: use [font-family: monospace] and convert spaces to "nbsp".
        Upside: lightweight -- no frame around and lighter font. Downside: unreadable MD source. *)

  type t

  val default : t
  (** The configuration that leads to more readable Markdown source code. *)

  val uniform : t
  (** The configuration that leads to more lightweight and uniform rendering. *)

  val html_tables : t -> t
  (** Output tables via {!PrintBox_html}. Already the case for the {!uniform} config. *)
  
  val text_tables : t -> t
  (** Output tables via {!PrintBox_text}. Already the case for the {!default} config. *)

  val non_preformatted : [`Minimal | `Stylized] -> t -> t
  
  val vlists : [`Line_break | `List | `As_table] -> t -> t
  (** How to output {!PrintBox.vlist} boxes, i.e. single-column grids.
      - [`Line_break] is set in the {!uniform} config; when the {!PrintBox.vlist} has bars,
        it puts a bottom border div around a row.
      - [`List] is set in the {!default} config; when the {!PrintBox.vlist} has bars,
        it puts a quoted horizontal rule ["> ---"] at the bottom of a row.
      - [`As_table] falls back to the general table printing mechanism. *)

  val hlists : [`Minimal | `Stylized | `As_table] -> t -> t
  (** How to output {!PrintBox.hlist} boxes, i.e. single-row grids, curently only if they fit
      in one line.
      - [`Minimal] uses spaces and a horizontal bar ["|"] to separate columns.
        If {!Config.non_preformatted} is [`Stylized], it also uses the ["white-space: pre"] style
        to prevent line breaks. It is set in the {!default} config.
      - [`Stylized] uses ["white-space: pre"] style to prevent line breaks, and instead of ["|"]
        it uses the border style to provide grid bars. It is set in the {!uniform} config.
      - [`As_table] falls back to the general table printing mechanism. *)
  
  val foldable_trees : t -> t
  (** Output trees so every node with children is foldable.
      Already the case for the {!uniform} config. *)

  val unfolded_trees : t -> t
  (** Output trees so every node is just the header followed by a list of children.
      Already the case for the {!default} config. *)

  val multiline_preformatted : preformatted -> t -> t
  (* How to output multiline preformatted text, including tables when output as text. *)
  
  val one_line_preformatted : preformatted -> t -> t
  (* How to output single-line preformatted text. *)
  
  val tab_width : int -> t -> t
  (* One tab is this many spaces, when outputting preformatted text via [Stylized],
     and via [Code_quote] (only for indentation). *)
  
  val quotation_frames :  t -> t
  (** Output frames using Markdown's quotation syntax [> ].
      Already the case for the {!default} config. *)

  val stylized_frames :  t -> t
  (** Output frames using a border style. It's intended to be similar to what {!PrintBox_html} does.
      Already the case for the {!uniform} config. *)
end

val pp : Config.t -> Format.formatter -> PrintBox.t -> unit
(** Pretty-print the Markdown source code into this formatter. *)

val to_string : Config.t -> PrintBox.t -> string
(** A string with the Markdown source code. *)
