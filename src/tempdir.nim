## A Nim library to create and manage temporary directories.
##
## Example
## --------
##
## .. code-block::nim
##    import tempdir
##
##    withTempDirectory(tmp, "test"):
##      echo "Created temporary directory with path: ", tmp
##      # At the end of this block, the tmp directory will be deleted
##
##    # You can also create a temporary directory in a path of your choosing
##    let tmp2 = createTempDirectory("test", "./tmp")
##    echo "Created temporary directory with path: ", tmp2

from os import dirExists, createDir, isAbsolute, joinPath, getCurrentDir, removeDir
from random import sample

const
  MaxNumAttempts = high(int)
    ## The number of attempts to create a unique random name for a tmeporary directory.
  TempDirectoryNameLength = 12
    ## The length of the random string used to create a temporary directory.
  RandomDirNameCharSet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9'}
    ## The character set to use when creating random directory names.

type
  TempDirectoryCreationError* = object of IOError
    ## Error raised when a temp directory fails to be created.

proc getRandomDirName(buffer: var string, offset: int = 0) {.inline.} =
  for i in 0..<TempDirectoryNameLength:
    buffer[offset+i] = sample(RandomDirNameCharSet)

proc createTempDirectory*(prefix: string = "", basePath: string = ""): string =
  ## Get a temporary directory path with the given `prefix` within the given base path `basePath`.
  ## The base path defaults to the system's `tmp` directory.
  var base = if len(basePath) < 1: os.getTempDir() else: basePath

  if not isAbsolute(base):
    base = joinPath(getCurrentDir(), base)

  var
    directoryPath: string
    directoryName: string = newString(len(prefix) + TempDirectoryNameLength)

  directoryName[0..len(prefix)-1] = prefix

  for i in 0..MaxNumAttempts:
    getRandomDirName(directoryName, len(prefix))
    directoryPath = joinPath(base, directoryName)

    if not dirExists(directoryPath):
      createDir(directoryPath)
      return directoryPath

  raise newException(TempDirectoryCreationError, "Failed to create unique temporary directory name after " & $MaxNumAttempts & " attempts")

template withTempDirectory*(dir: untyped, prefix: string, body: untyped): void =
  ## Create and use a temporary directory with the given `prefix`, deleting it and its contents upon completion.
  var dir: string = createTempDirectory(prefix)
  try:
    body
  finally:
    removeDir(dir)

when isMainModule:
  # Create a new temporary directory in the system's temporary directory path, with directories having the prefix `test`.
  withTempDirectory(tmp, "test_"):
    echo "Created temporary directory with path: ", tmp
    # At the end of this block, the temporary directory and all of its files will be deleted

  # You can also create a temporary directory in a path of your choosing using the `createTempDirectory` procedure
  let tmp2 = createTempDirectory("test_", "./tmp")
  echo "Created temporary directory with path: ", tmp2
