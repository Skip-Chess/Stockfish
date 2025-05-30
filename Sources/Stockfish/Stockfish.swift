import CStockfish

@available(iOS 13.0, macOS 14.0, *)
public struct StockfishEngine {
    public static func run() {
        
    }
    
    public static var engineInfo: String {
        Stockfish.engine_info().description
    }

    public static func stop() {

    }

    public static func start() -> AsyncStream<String> {
        stockfish_init()
        Task {
            stockfish_main()
        }

        var continuation: AsyncStream<String>.Continuation?
        let stream = AsyncStream<String> { subscriber in
            //subscriber.yield("")
            continuation = subscriber
        }

        Task {
            while Task.isCancelled == false {
                if let line = stockfish_stdout_read(1) {
                    if let str = String(validatingCString: line) {
                        if str != "" && str != "\n" {
                            continuation?.yield(str)
                        }
                    }
                }
                //try await Task.sleep(nanoseconds: 10_000_000)
            }
        }

        return stream
    }

    @discardableResult public static func send(_ line: String) -> Int {
        line.withCString { ptr in
            stockfish_stdin_write(UnsafeMutablePointer(mutating: ptr))
        }
    }
}
