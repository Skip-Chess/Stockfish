#include <cstdio>
#include <iostream>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#ifdef _WIN64
#define ssize_t __int64
#else
#define ssize_t long
#endif
#else
#include <unistd.h>
#endif

#include "fixes.h"
#include "stockfish.h"
#include <thread>


#define BUFFER_SIZE 1024

const char *QUITOK = "quit\n";

int smain(int, char **);

char buffer[BUFFER_SIZE + 1];
char errBuffer[BUFFER_SIZE + 1];

FFI_PLUGIN_EXPORT int stockfish_main() {
  fakeout.reopen();
  fakein.reopen();

  int argc = 1;
  char *argv[] = {(char *)""};
  int exitCode = smain(argc, argv);

#if _WIN32
  Sleep(100);
#else
  usleep(100);
#endif

  fakeout.close();
  fakein.close();

  return exitCode;
}

FFI_PLUGIN_EXPORT ssize_t stockfish_stdin_write(char *data) {
  std::string val(data);
  fakein << val << fakeendl;
  return val.length();
}

FFI_PLUGIN_EXPORT char* stockfish_stdout_read() {
  std::string outputLine;
  if (fakeout.try_get_line(outputLine)) {
    size_t len = outputLine.length();
    size_t i;
    for (i = 0; i < len && i < BUFFER_SIZE; i++) {
      buffer[i] = outputLine[i];
    }
    buffer[i] = 0;
    return buffer;
  }
  return nullptr; // No data available
}

FFI_PLUGIN_EXPORT char* stockfish_stderr_read() {
  std::string errorLine;
  if (fakeerr.try_get_line(errorLine)) {
    size_t len = errorLine.length();
    size_t i;
    for (i = 0; i < len && i < BUFFER_SIZE; i++) {
      errBuffer[i] = errorLine[i];
    }
    errBuffer[i] = 0;
    return errBuffer;
  }
  return nullptr; // No data available
}

