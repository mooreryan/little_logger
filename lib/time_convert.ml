(* These functions are adapted from ptime.ml. Original copyright follows. *)

(*---------------------------------------------------------------------------
  Copyright (c) 2015 The ptime programmers Permission to use, copy, modify,
  and/or distribute this software for any purpose with or without fee is hereby
  granted, provided that the above copyright notice and this permission notice
  appear in all copies. THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR
  DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE
  LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
  DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)

let rfc3339_adjust_tz_offset tz_offset_s =
  (* The RFC 3339 time zone offset field is limited in expression to the bounds
     below with minute precision. If the requested time zone offset exceeds
     these bounds or is not an *integral* number of minutes we simply use UTC.
     An alternative would be to compensate the offset *and* the timestamp but
     it's more complicated to explain and maybe more surprising to the user. *)
  let min = -86340 (* -23h59 in secs *) in
  let max = 86340 (* +23h59 in secs *) in
  if min <= tz_offset_s && tz_offset_s <= max && tz_offset_s mod 60 = 0 then
    (tz_offset_s, false)
  else (0 (* UTC *), true)

let to_string_hum tz_offset_s ptime =
  let tz_offset_s, _tz_unknown =
    match tz_offset_s with
    | Some tz -> rfc3339_adjust_tz_offset tz
    | None -> (0, true)
  in
  let (y, m, d), ((hh, ss, mm), _tz_offset_s) =
    Ptime.to_date_time ~tz_offset_s ptime
  in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d" y m d hh ss mm
