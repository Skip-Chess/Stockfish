import Testing
import Stockfish

@available(macOS 14, iOS 15, *)
@Test func testStockfish() async throws {
    let stream = StockfishEngine.start()
    var iterator = stream.makeAsyncIterator()

    func send(_ line: String) {
        print("Sending line: \(line)")
        StockfishEngine.send(line)
    }

    func readLine() async -> String {
        var line = ""
        for await tok in stream {
            if tok == "\n" {
                return line
            }
            line += tok
        }
        return line
    }

    await #expect(iterator.next() == "Stockfish 16 by the Stockfish developers (see AUTHORS file)")
    await #expect(readLine() == "")

    send("uci")

    await #expect(readLine() == """
    id name Stockfish 16
    id author the Stockfish developers (see AUTHORS file)
    """)

    await #expect(readLine() == """

option name Debug Log File type string default 
option name Threads type spin default 1 min 1 max 1024
option name Hash type spin default 16 min 1 max 2048
option name Clear Hash type button
option name Ponder type check default false
option name MultiPV type spin default 1 min 1 max 500
option name Skill Level type spin default 20 min 0 max 20
option name Move Overhead type spin default 10 min 0 max 5000
option name Slow Mover type spin default 100 min 10 max 1000
option name nodestime type spin default 0 min 0 max 10000
option name UCI_Chess960 type check default false
option name UCI_AnalyseMode type check default false
option name UCI_LimitStrength type check default false
option name UCI_Elo type spin default 1320 min 1320 max 3190
option name UCI_ShowWDL type check default false
option name SyzygyPath type string default <empty>
option name SyzygyProbeDepth type spin default 1 min 1 max 100
option name Syzygy50MoveRule type check default true
option name SyzygyProbeLimit type spin default 7 min 0 max 7
uciok
""")

    send("ucinewgame")

    send("d") // print the board

    await #expect(readLine() == """

 +---+---+---+---+---+---+---+---+
 | r | n | b | q | k | b | n | r | 8
 +---+---+---+---+---+---+---+---+
 | p | p | p | p | p | p | p | p | 7
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   | 6
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   | 5
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   | 4
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   | 3
 +---+---+---+---+---+---+---+---+
 | P | P | P | P | P | P | P | P | 2
 +---+---+---+---+---+---+---+---+
 | R | N | B | Q | K | B | N | R | 1
 +---+---+---+---+---+---+---+---+
   a   b   c   d   e   f   g   h

Fen: rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
Key: 8F8F01D4562F59FB
Checkers: 
""")

    for _ in 1...10 {
        send("position fen r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 10")

        send("d") // print the board

        await #expect(readLine() == """

 +---+---+---+---+---+---+---+---+
 | r |   |   |   | k |   |   | r | 8
 +---+---+---+---+---+---+---+---+
 | p |   | p | p | q | p | b |   | 7
 +---+---+---+---+---+---+---+---+
 | b | n |   |   | p | n | p |   | 6
 +---+---+---+---+---+---+---+---+
 |   |   |   | P | N |   |   |   | 5
 +---+---+---+---+---+---+---+---+
 |   | p |   |   | P |   |   |   | 4
 +---+---+---+---+---+---+---+---+
 |   |   | N |   |   | Q |   | p | 3
 +---+---+---+---+---+---+---+---+
 | P | P | P | B | B | P | P | P | 2
 +---+---+---+---+---+---+---+---+
 | R |   |   |   | K |   |   | R | 1
 +---+---+---+---+---+---+---+---+
   a   b   c   d   e   f   g   h

Fen: r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 10
Key: BA0586148EFA180B
Checkers: 
""")
    }

    let italianGameFen = "r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4"

    send("position fen \(italianGameFen)")

    send("go perft 1")

    while true {
        let line = await readLine()
        print("go perft 1> " + line)
        if line.hasPrefix("\nNodes searched:") { break }
    }

//    send("go movetime 100")
//    for await x in stream {
//        print("### response: \(x)")
//    }

    send("quit")
//    await #expect(readLine() == "quitok\n")

    StockfishEngine.stop()
}
