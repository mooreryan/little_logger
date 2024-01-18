open! Core
open! Little_logger

let date_re = Re2.create_exn "[0-9]{4}-[0-9]{2}-[0-9]{2}"
let time_re = Re2.create_exn "[0-9]{2}:[0-9]{2}:[0-9]{2}"
let pid_re = Re2.create_exn "#[0-9]+"

let redact out =
  Re2.replace_exn ~f:(fun _m -> "DATE") date_re
  @@ Re2.replace_exn ~f:(fun _m -> "TIME") time_re
  @@ Re2.replace_exn ~f:(fun _m -> "PID") pid_re out

let log_all () =
  Logger.trace (fun () -> sprintf "hi ryan (%s)" "trace");
  Logger.debug (fun () -> sprintf "hi ryan (%s)" "debug");
  Logger.info (fun () -> sprintf "hi ryan (%s)" "info");
  Logger.warning (fun () -> sprintf "hi ryan (%s)" "warning");
  Logger.error (fun () -> sprintf "hi ryan (%s)" "error");
  Logger.fatal (fun () -> sprintf "hi ryan (%s)" "fatal");
  Logger.unknown (fun () -> sprintf "hi ryan (%s)" "unknown")

let log_all_string () =
  Logger.strace "hi ryan (trace)";
  Logger.sdebug "hi ryan (debug)";
  Logger.sinfo "hi ryan (info)";
  Logger.swarning "hi ryan (warning)";
  Logger.serror "hi ryan (error)";
  Logger.sfatal "hi ryan (fatal)";
  Logger.sunknown "hi ryan (unknown)"

(* Level of string *)

let%expect_test "level_of_string" =
  let f s =
    print_endline @@ Logger.Level.to_string
    @@ Option.value_exn (Logger.Level.of_string s)
  in
  f "tRaCe";
  [%expect {| TRACE |}];
  f "dEbUg";
  [%expect {| DEBUG |}];
  f "iNfO";
  [%expect {| INFO |}];
  f "wArNiNg";
  [%expect {| WARN |}];
  f "eRrOr";
  [%expect {| ERROR |}];
  f "fAtAl";
  [%expect {| FATAL |}];
  f "uNkNoWn";
  [%expect {| UNKNOWN |}];
  f "sIlEnT";
  [%expect {| SILENT |}];
  let () =
    match Logger.Level.of_string "bad thing" with
    | Some _ -> assert false
    | None -> print_endline "Got None"
  in
  [%expect {| Got None |}]

(* Check that the getter/setters work. *)

let%expect_test "getting/setting the log level" =
  let open Logger in
  let set_and_print_log_level level =
    Logger.set_log_level level;
    print_endline @@ Level.to_string @@ get_log_level ()
  in
  (* Default *)
  print_endline @@ Level.to_string @@ get_log_level ();
  [%expect {| WARN |}];
  set_and_print_log_level Logger.Level.Trace;
  [%expect {| TRACE |}];
  set_and_print_log_level Logger.Level.Debug;
  [%expect {| DEBUG |}];
  set_and_print_log_level Logger.Level.Info;
  [%expect {| INFO |}];
  set_and_print_log_level Logger.Level.Warning;
  [%expect {| WARN |}];
  set_and_print_log_level Logger.Level.Error;
  [%expect {| ERROR |}];
  set_and_print_log_level Logger.Level.Fatal;
  [%expect {| FATAL |}];
  set_and_print_log_level Logger.Level.Unknown;
  [%expect {| UNKNOWN |}];
  set_and_print_log_level Logger.Level.Silent;
  [%expect {| SILENT |}]

(* Check that the levels work as expected. *)

let%expect_test _ =
  Logger.set_log_level Logger.Level.Trace;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    T, [DATE TIME PID] TRACE -- hi ryan (trace)
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Debug;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Info;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Warning;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Error;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Fatal;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Unknown;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect {|
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Silent;
  Logger.set_printer print_endline;
  log_all ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect {| |}]

(* String versions. *)

let%expect_test _ =
  Logger.set_log_level Logger.Level.Trace;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    T, [DATE TIME PID] TRACE -- hi ryan (trace)
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Debug;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Info;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Warning;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Error;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Fatal;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Unknown;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect {|
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  Logger.set_log_level Logger.Level.Silent;
  Logger.set_printer print_endline;
  log_all_string ();
  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect {| |}]

(* Custom printer to file *)
let%expect_test _ =
  let fname = "silly_file.txt" in
  let printer msg =
    Out_channel.with_file fname ~append:true ~f:(fun chan ->
        Out_channel.output_string chan msg;
        Out_channel.newline chan)
  in
  Logger.set_log_level Logger.Level.Trace;
  Logger.set_printer printer;
  log_all_string ();
  print_endline @@ redact @@ In_channel.read_all fname;
  [%expect
    {|
    T, [DATE TIME PID] TRACE -- hi ryan (trace)
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]

let%expect_test _ =
  let f1 = "hi.txt" in
  let f2 = "apple.txt" in
  let oc1 = Out_channel.create f1 in
  let oc2 = Out_channel.create f2 in
  let printer msg =
    print_endline msg;
    let msg = msg ^ "\n" in
    Out_channel.output_string oc1 msg;
    Out_channel.flush oc1;
    Out_channel.output_string oc2 msg;
    Out_channel.flush oc2
  in
  Logger.set_log_level Logger.Level.Trace;
  Logger.set_printer printer;
  log_all_string ();

  let out = [%expect.output] in
  print_endline @@ redact out;
  [%expect
    {|
    T, [DATE TIME PID] TRACE -- hi ryan (trace)
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}];

  print_endline @@ redact @@ In_channel.read_all f1;
  [%expect
    {|
    T, [DATE TIME PID] TRACE -- hi ryan (trace)
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}];

  print_endline @@ redact @@ In_channel.read_all f2;
  [%expect
    {|
    T, [DATE TIME PID] TRACE -- hi ryan (trace)
    D, [DATE TIME PID] DEBUG -- hi ryan (debug)
    I, [DATE TIME PID] INFO -- hi ryan (info)
    W, [DATE TIME PID] WARN -- hi ryan (warning)
    E, [DATE TIME PID] ERROR -- hi ryan (error)
    F, [DATE TIME PID] FATAL -- hi ryan (fatal)
    U, [DATE TIME PID] UNKNOWN -- hi ryan (unknown) |}]
