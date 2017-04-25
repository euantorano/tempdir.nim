import tempdir, unittest, os

suite "tempdir tests":
  test "createTempDirectory creates directory":
    var tmp = createTempDirectory("test")

    check dirExists(tmp) == true

  test "createTempDirectory in relative path creates absolute path":
    var tmp = createTempDirectory("test", "./tmp")
    
    check dirExists(tmp) == true
    check dirExists("./tmp") == true
    check isAbsolute(tmp) == true

  test "test withTempDir removes temporary directory":
    var createdDir: string

    withTempDirectory(dir, "tempdir_tests"):
      check dirExists(dir) == true
      createdDir = dir

    check dirExists(createdDir) == false
