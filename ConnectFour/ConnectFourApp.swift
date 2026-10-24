import SwiftUI

@main
struct ConnectFourApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

enum Disc { case red, yellow
    var color: Color { self == .red ? .red : .yellow }
    var name: String { self == .red ? "Red" : "Yellow" }
}

struct ContentView: View {
    static let cols = 7, rows = 6
    @State private var board: [[Disc?]] = Array(repeating: Array(repeating: nil, count: cols), count: rows)
    @State private var current: Disc = .red
    @State private var message: String? = nil

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 10) {
                if message == nil {
                    Circle().fill(current.color).frame(width: 24, height: 24)
                }
                Text(message ?? "\(current.name)'s turn")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
            }

            VStack(spacing: 6) {
                ForEach(0..<Self.rows, id: \.self) { r in
                    HStack(spacing: 6) {
                        ForEach(0..<Self.cols, id: \.self) { c in
                            Circle()
                                .fill(board[r][c]?.color ?? Color(.systemBackground))
                                .aspectRatio(1, contentMode: .fit)
                                .contentShape(Rectangle())
                                .onTapGesture { drop(in: c) }
                        }
                    }
                }
            }
            .padding(8)
            .background(Color.blue.opacity(0.85))
            .cornerRadius(14)
            .padding(.horizontal, 12)
            .allowsHitTesting(message == nil)

            Button("Reset", action: reset)
                .font(.title3.weight(.semibold))
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func drop(in c: Int) {
        guard message == nil else { return }
        guard let r = (0..<Self.rows).reversed().first(where: { board[$0][c] == nil }) else { return }
        board[r][c] = current
        if wins(r, c) {
            message = "\(current.name) wins"
        } else if board[0].allSatisfy({ $0 != nil }) {
            message = "Draw"
        } else {
            current = current == .red ? .yellow : .red
        }
    }

    private func wins(_ r: Int, _ c: Int) -> Bool {
        for (dr, dc) in [(0,1),(1,0),(1,1),(1,-1)] {
            var count = 1
            for s in [1, -1] {
                var rr = r + dr*s, cc = c + dc*s
                while rr >= 0, rr < Self.rows, cc >= 0, cc < Self.cols, board[rr][cc] == current {
                    count += 1; rr += dr*s; cc += dc*s
                }
            }
            if count >= 4 { return true }
        }
        return false
    }

    private func reset() {
        board = Array(repeating: Array(repeating: nil, count: Self.cols), count: Self.rows)
        current = .red
        message = nil
    }
}
