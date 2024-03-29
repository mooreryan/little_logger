module Level = struct
  (* Lowest to highest severity. Silent isn't really a level, but a nice way to
     print absolutely no messages. *)
  type t = Trace | Debug | Info | Warning | Error | Fatal | Unknown | Silent

  let of_string s =
    match String.lowercase_ascii s with
    | "silent" ->
        Some Silent
    | "unknown" ->
        Some Unknown
    | "fatal" ->
        Some Fatal
    | "error" ->
        Some Error
    | "warning" ->
        Some Warning
    | "info" ->
        Some Info
    | "debug" ->
        Some Debug
    | "trace" ->
        Some Trace
    | _ ->
        None

  let to_string = function
    | Silent ->
        "SILENT"
    | Unknown ->
        "UNKNOWN"
    | Fatal ->
        "FATAL"
    | Error ->
        "ERROR"
    | Warning ->
        "WARN"
    | Info ->
        "INFO"
    | Debug ->
        "DEBUG"
    | Trace ->
        "TRACE"

  let to_char = function
    | Silent ->
        'S'
    | Unknown ->
        'U'
    | Fatal ->
        'F'
    | Error ->
        'E'
    | Warning ->
        'W'
    | Info ->
        'I'
    | Debug ->
        'D'
    | Trace ->
        'T'
end

let log_level = ref Level.Warning
let printer = ref prerr_endline

let set_log_level level = log_level := level
let get_log_level () = !log_level

let set_printer new_printer = printer := new_printer

type printer = string -> unit
type message = unit -> string

let make_log_message msg_level msg =
  let now =
    let ptime = Ptime_clock.now () in
    let tz_offset_s = Ptime_clock.current_tz_offset_s () in
    Time_convert.to_string_hum tz_offset_s ptime
  in
  let pid = string_of_int @@ Unix.getpid () in
  let code = Level.to_char msg_level in
  Printf.sprintf "%c, [%s #%s] %s -- %s" code now pid
    (Level.to_string msg_level)
    msg

let should_log msg_level logger_threshold = msg_level >= logger_threshold

let log_message msg_level msg =
  if should_log msg_level !log_level then
    !printer @@ make_log_message msg_level @@ msg ()

let log_message_string msg_level msg =
  if should_log msg_level !log_level then
    !printer @@ make_log_message msg_level msg

let unknown msg = log_message Unknown msg
let fatal msg = log_message Fatal msg
let error msg = log_message Error msg
let warning msg = log_message Warning msg
let info msg = log_message Info msg
let debug msg = log_message Debug msg
let trace msg = log_message Trace msg

let sunknown msg = log_message_string Unknown msg
let sfatal msg = log_message_string Fatal msg
let serror msg = log_message_string Error msg
let swarning msg = log_message_string Warning msg
let sinfo msg = log_message_string Info msg
let sdebug msg = log_message_string Debug msg
let strace msg = log_message_string Trace msg
