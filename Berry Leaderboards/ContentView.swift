//
//  ContentView.swift
//  BerryLeaderboards
//
//  Created by Lncvrt on 6/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var players: [Player] = []
    @State private var loading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            #if os(macOS)
            VisualEffectBlur()
                .ignoresSafeArea()
            #elseif os(iOS)
            Color(red: 24/255, green: 24/255, blue: 24/255)
                .ignoresSafeArea()
            #endif

            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Button("Refresh") {
                        Task { await loadPlayers() }
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 12)
                }

                if loading {
                    Text("Loading...").padding()
                } else if let errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }

                List(players) { player in
                    HStack {
                        Text(player.username)
                        Spacer()
                        Text("\(player.score)").bold()
                    }
                    .padding(.vertical, 4)
                    #if os(macOS)
                    .listRowBackground(Color.clear)
                    #elseif os(iOS)
                    .listRowBackground(Color(red: 48/255, green: 48/255, blue: 48/255))
                    #endif
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .task {
                    await loadPlayers()
                }
            }
        }
    }

    func loadPlayers() async {
        loading = true
        errorMessage = nil
        do {
            players = []
            players = try await loadLeaderboard()
        } catch {
            errorMessage = error.localizedDescription
        }
        loading = false
    }
}

func loadLeaderboard() async throws -> [Player] {
    let url = URL(string: "https://berrydash.lncvrt.xyz/database/getTopPlayersAPI.php")!
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let raw = String(data: data, encoding: .utf8) else { return [] }
    return parseLeaderboard(raw)
}
