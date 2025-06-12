//
//  Player.swift
//  BerryLeaderboards
//
//  Created by Lncvrt on 6/9/25.
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    let username: String
    let score: Int
}

func parseLeaderboard(_ raw: String) -> [Player] {
    raw.split(separator: ";").compactMap { entry in
        let parts = entry.split(separator: ":")
        guard parts.count == 2,
              let nameData = Data(base64Encoded: String(parts[0])),
              let username = String(data: nameData, encoding: .utf8),
              let score = Int(parts[1]) else { return nil }
        return Player(username: username, score: score)
    }
}
