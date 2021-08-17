# Little Logger

[![Build and test](https://github.com/mooreryan/little_logger/actions/workflows/build_and_test.yml/badge.svg)](https://github.com/mooreryan/little_logger/actions/workflows/build_and_test.yml) [![Coverage Status](https://coveralls.io/repos/github/mooreryan/little_logger/badge.svg?branch=main)](https://coveralls.io/github/mooreryan/little_logger?branch=main)

`Little_logger` is a tiny, little logger for OCaml 💖, inspired by the [Ruby Std-lib Logger](https://ruby-doc.org/stdlib-3.0.2/libdoc/logger/rdoc/Logger.html).

## Quick start

Print an error message to `stderr`.

```ocaml
open Little_logger
let () = Logger.error (fun () -> sprintf "something %s happened" "bad")
(* E, [2021-08-17 17:23:32 #102259] ERROR -- something bad happened *)
```

## Documentation

The api docs and examples are available on [online](https://mooreryan.github.io/little_logger/).

It's quite simple though (< 100 LOC), so check out the source to see exactly how things work 🍨

## Benchmarks

For some snazzy fun, head on over to the [benchmark directory](https://github.com/mooreryan/little_logger/bench) 🌶

## License

[![license MIT or Apache
2.0](https://img.shields.io/badge/license-MIT%20or%20Apache%202.0-blue)](https://github.com/mooreryan/little_logger)

Licensed under the Apache License, Version 2.0 or the MIT license, at
your option. This program may not be copied, modified, or distributed
except according to those terms.
