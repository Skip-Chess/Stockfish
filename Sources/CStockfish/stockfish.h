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

#ifdef _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT \
    __attribute__((visibility("default"))) __attribute__((used))
#endif

#if __cplusplus

// Initialisation of Stockfish.
#ifndef _ffigen
extern "C"
#endif
    FFI_PLUGIN_EXPORT int
    stockfish_init();

// Stockfish main loop.
#ifndef _ffigen
extern "C"
#endif
    FFI_PLUGIN_EXPORT int
    stockfish_main();

// Stockfish start main loop.
#ifndef _ffigen
extern "C"
#endif
    FFI_PLUGIN_EXPORT void
    stockfish_start_main();

// Stockfish last main loop state.
#ifndef _ffigen
extern "C"
#endif
    FFI_PLUGIN_EXPORT int
    stockfish_last_main_state();

// Writing to Stockfish STDIN.
#ifndef _ffigen
extern "C"
#endif
    FFI_PLUGIN_EXPORT ssize_t
    stockfish_stdin_write(char* data);

// Reading Stockfish STDOUT
#ifndef _ffigen
extern "C"
#endif
    FFI_PLUGIN_EXPORT const char*
    stockfish_stdout_read(int trygetline);

#endif

FFI_PLUGIN_EXPORT int stockfish_init();
FFI_PLUGIN_EXPORT int stockfish_main();
FFI_PLUGIN_EXPORT void stockfish_start_main();
FFI_PLUGIN_EXPORT int stockfish_last_main_state();
FFI_PLUGIN_EXPORT ssize_t stockfish_stdin_write(char* data);
FFI_PLUGIN_EXPORT const char* stockfish_stdout_read(int trygetline);

