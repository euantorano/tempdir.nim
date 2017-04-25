# Package

version       = "1.0.0"
author        = "Euan T"
description   = "A Nim library to create and manage temporary directories."
license       = "BSD3"

srcDir = "src"

# Dependencies

requires "nim >= 0.16.0"

task docs, "Build documentation":
  exec "nim doc --index:on -o:docs/tempdir.html src/tempdir.nim"
