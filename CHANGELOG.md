## Unreleased

## 0.3.0 (2024-01-18)

* Drop unnecessary test dependencies.
* Remove benchmarks from repository.
* Use `>= v0.16` for Jane Street packages in the test library.
  * Note: if you want to run the tests, this will impose a minimum OCaml version of `4.14`.

## 0.2.0 (2021-10-30)

* Use `ptime` for time rather than `Core`
* `Level.of_string` returns `t option` now rather than `t Or_error.t`
* Drop `ppx_compare`

## 0.1.1 (2021-08-18)

Fixed some dependency problems in the `opam` file.

## 0.1.0 (2021-08-17)

Initial release!
