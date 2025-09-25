//
//  Item.swift
//  AppStand
//
//  Created by admin on 11/09/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }

    /// Convenience accessor to expose a formatted timestamp string.
    /// Useful for unit tests to ensure Date formatting remains stable.
    func formattedTimestamp(using formatter: DateFormatter) -> String {
        formatter.string(from: timestamp)
    }
}
