# tempdir

A Nim library to create and manage temporary directories. Inspired by [the Rust library of the same name](https://github.com/rust-lang-nursery/tempdir).

## Installation

```
nimble install tempdir
```

## [API Documentation](https://htmlpreview.github.io/?https://github.com/euantorano/tempdir.nim/blob/master/docs/tempdir.html)

## Usage

```nim
import tempdir

# Create a new temporary directory in the system's temporary directory path, with directories having the prefix `test_`.
withTempDirectory(tmp, "test"):
  echo "Created temporary directory with path: ", tmp
  # At the end of this block, the temporary directory and all of its files will be deleted

# You can also create a temporary directory in a path of your choosing using the `createTempDirectory` procedure
let tmp2 = createTempDirectory("test", "./tmp")
echo "Created temporary directory with path: ", tmp2
```
