(lang dune 2.8)

(generate_opam_files true)

(name little_logger)

(package
 (name little_logger)
 (version 0.2.0)
 (license "MIT")
 (maintainers "Ryan Moore")
 (authors "Ryan Moore")
 (homepage "https://github.com/mooreryan/little_logger")
 (source
  (github mooreryan/little_logger))
 (documentation "https://mooreryan.github.io/little_logger/")
 (bug_reports "https://github.com/mooreryan/little_logger/issues")
 (synopsis "A tiny, little logger <3")
 (depends
  ;; Runtime deps
  (ocaml
   (>= "4.08.0"))
  ptime
  ;; Test deps
  (async
   (and
    (>= "v0.16")
    :with-test))
  (bisect_ppx :with-test)
  (core
   (and
    (>= "v0.16")
    :with-test))
  (ppx_inline_test
   (and
    (>= "v0.16")
    :with-test))
  (ppx_expect
   (and
    (>= "v0.16")
    :with-test))
  (re2
   (and
    (>= "v0.16")
    :with-test))))
