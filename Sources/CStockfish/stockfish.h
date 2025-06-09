//#define _ffigen
#ifdef _WIN32
#include <BaseTsd.h>
#else
#include <stdint.h>
#endif

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

#ifndef _ffigen
#if __cplusplus
extern "C" {
#endif
#endif

#if defined(_WIN32)
    #define API_EXPORT
#else
    #define API_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

// Stockfish main loop.
API_EXPORT FFI_PLUGIN_EXPORT int stockfish_main();

// Writing to Stockfish STDIN.
API_EXPORT FFI_PLUGIN_EXPORT ssize_t stockfish_stdin_write(char *data);

// Reading Stockfish STDOUT.
API_EXPORT FFI_PLUGIN_EXPORT char * stockfish_stdout_read();

// Reading Stockfish STDERR.
API_EXPORT FFI_PLUGIN_EXPORT char * stockfish_stderr_read();

#ifndef _ffigen
#if __cplusplus
}
#endif
#endif

