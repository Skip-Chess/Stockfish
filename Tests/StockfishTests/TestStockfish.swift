import Testing
import Stockfish


@Test func testStockfish() async throws {
    let stream = StockfishEngine.start()
    var iterator = stream.makeAsyncIterator()
    await #expect(iterator.next() == "Stockfish 16 by the Stockfish developers (see AUTHORS file)")

    StockfishEngine.send("uci")
    await #expect(iterator.next() == "id name ")
    await #expect(iterator.next() == """
    Stockfish 16
    id author the Stockfish developers (see AUTHORS file)
    """)

    await #expect(iterator.next() == """

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
option name Use NNUE type check default true
option name EvalFile type string default nn-5af11540bbfe.nnue
""")

    await #expect(iterator.next() == "\nuciok")

    StockfishEngine.send("ucinewgame")

    StockfishEngine.send("d") // print the board

    await #expect(iterator.next() == """

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

    StockfishEngine.send("position fen r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 10")


    StockfishEngine.send("d") // print the board

    await #expect(iterator.next() == """

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

    StockfishEngine.send("quit")
    await #expect(iterator.next() == "quitok\n")

    StockfishEngine.stop()
}
