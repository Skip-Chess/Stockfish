private import CStockfish

@available(iOS 13.0, macOS 14.0, *)
public struct StockfishEngine {
    public static func run() {
        
    }
    
    public static func stop() {

    }

    public static func start() -> AsyncStream<String> {
        var readTask: Task<(), any Error>? = nil
        Task {
            stockfish_main()
            readTask?.cancel()
        }

        var continuation: AsyncStream<String>.Continuation?
        let stream = AsyncStream<String> { subscriber in
            //subscriber.yield("")
            continuation = subscriber
        }

        readTask = Task {
            while Task.isCancelled == false {
                if let line = stockfish_stdout_read() {
                    if let str = String(validatingCString: line) {
                        continuation?.yield(str)
                    }
                }
                try await Task.sleep(nanoseconds: 10_000)
            }
            continuation?.finish()
        }

        return stream
    }

    @discardableResult public static func send(_ line: String) -> Int {
        line.withCString { ptr in
            stockfish_stdin_write(UnsafeMutablePointer(mutating: ptr))
        }
    }
}
