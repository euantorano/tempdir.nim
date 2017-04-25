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

from os import getTempDir, isAbsolute, getCurrentDir, joinPath, existsDir, createDir, removeDir
from random import random

const
  MaxNumAttempts = 1 shl 31
    ## The number of attempts to create a unique random name for a tmeporary directory.
  TempDirectoryNameLength = 12
    ## The length of the random string used to create a temporary directory.
  RandomDirNameCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    ## The character set to use when creating random directory names.

type
  TempDirectoryCreationError* = object of IOError
    ## Error raised when a temp directory fails to be created.

proc getRandomDirName(): string {.inline.} =
  result = newStringOfCap(TempDirectoryNameLength)
  for i in 0..TempDirectoryNameLength - 1:
    result.add(random(RandomDirNameCharSet))

proc createTempDirectory*(prefix: string = "", basePath: string = ""): string =
  ## Get a temporary directry path with the given prefix within the given base path.
  ## The base path defaults to the system's `tmp` directory.
  var base = if len(basePath) < 1: os.getTempDir() else: basePath

  if not isAbsolute(base):
    base = joinPath(getCurrentDir(), base)

  var
    suffix: string
    directoryPath: string
  for i in 0..MaxNumAttempts:
    suffix = getRandomDirName()
    directoryPath = joinPath(base, if len(prefix) > 0: prefix & "_" & suffix else: suffix)
    
    if not existsDir(directoryPath):
      createDir(directoryPath)
      return directoryPath

  raise newException(TempDirectoryCreationError, "Failed to create unique temporary directory name after " & $MaxNumAttempts & " attempts")

template withTempDirectory*(dir: untyped, prefix: string, body: untyped): typed =
  ## Create and use a temporary directory with the given prefix, deleting it and its contents upon completion.
  var dir: string = createTempDirectory(prefix)
  try:
    body
  finally:
    removeDir(dir)

when isMainModule:
  # Create a new temporary directory in the system's temporary directory path, with directories having the prefix `test_`.
  withTempDirectory(tmp, "test"):
    echo "Created temporary directory with path: ", tmp
    # At the end of this block, the temporary directory and all of its files will be deleted

  # You can also create a temporary directory in a path of your choosing using the `createTempDirectory` procedure
  let tmp2 = createTempDirectory("test", "./tmp")
  echo "Created temporary directory with path: ", tmp2
