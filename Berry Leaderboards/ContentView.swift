//
//  ContentView.swift
//  BerryLeaderboards
//
//  Created by Lncvrt on 6/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var players: [Player] = []

    var body: some View {
        ZStack {
            #if os(macOS)
            VisualEffectBlur()
                .ignoresSafeArea()
            #endif
            List(players) { player in
                HStack {
                    Text(player.username)
                    Spacer()
                    Text("\(player.score)")
                        .bold()
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
            .background(Color.clear)
            #if os(macOS)
            .scrollContentBackground(.hidden)
            #endif
            .task {
                await loadPlayers()
            }
        }
    }

    func loadPlayers() async {
        do {
            players = try await loadLeaderboard()
        } catch {
            print("Failed to load leaderboard:", error)
        }
    }
}

func loadLeaderboard() async throws -> [Player] {
    let url = URL(string: "https://berrydash.lncvrt.xyz/database/getTopPlayersAPI.php")!
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let raw = String(data: data, encoding: .utf8) else { return [] }
    return parseLeaderboard(raw)
}
