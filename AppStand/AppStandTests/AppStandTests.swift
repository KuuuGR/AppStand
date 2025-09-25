//
//  AppStandTests.swift
//  AppStandTests
//
//  Created by admin on 25/09/2025.
//

import XCTest
@testable import AppStand

final class AppStandTests: XCTestCase {

    func testWrappedHeroItemsAddsSentinelsAndMapsIndices() {
        let source: [HeroItem] = [
            .init(title: "One", systemIcon: "circle", tagline: "", detail: ""),
            .init(title: "Two", systemIcon: "square", tagline: "", detail: ""),
            .init(title: "Three", systemIcon: "triangle", tagline: "", detail: "")
        ]

        let wrapped = DemoRootView.buildWrappedHeroItems(from: source)

        XCTAssertEqual(wrapped.count, source.count + 2, "Carousel should add sentinel items at both ends")
        XCTAssertEqual(wrapped.first?.content, source.last, "First sentinel should duplicate last hero")
        XCTAssertEqual(wrapped.last?.content, source.first, "Last sentinel should duplicate first hero")

        let mappedIndices = wrapped.map(\.originalIndex)
        XCTAssertEqual(mappedIndices, [2, 0, 1, 2, 0], "Original indices should reflect wrapping order")
    }

    func testNormalizeHeroPageIndexWrapsAndUpdatesSelection() {
        let rootView = DemoRootView(logoImageName: "logo")
        XCTAssertEqual(rootView.heroItems.count, 4)

        // Use pure helper to guarantee deterministic results
        let realCount = rootView.heroItems.count

        var result = DemoRootView.normalizedIndices(for: rootView.wrappedHeroItems.count - 1, realItemCount: realCount)
        XCTAssertEqual(result.pageIndex, 1)
        XCTAssertEqual(result.selectedHeroIndex, 0)

        result = DemoRootView.normalizedIndices(for: 0, realItemCount: realCount)
        XCTAssertEqual(result.pageIndex, rootView.wrappedHeroItems.count - 2)
        XCTAssertEqual(result.selectedHeroIndex, rootView.heroItems.count - 1)

        result = DemoRootView.normalizedIndices(for: 2, realItemCount: realCount)
        XCTAssertEqual(result.pageIndex, 2)
        XCTAssertEqual(result.selectedHeroIndex, 1)
    }

    func testItemFormattedTimestampUsesFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let components = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2025, month: 9, day: 25, hour: 13, minute: 37)
        let date = components.date ?? Date()
        let item = Item(timestamp: date)

        XCTAssertEqual(item.formattedTimestamp(using: formatter), "2025-09-25 13:37")
    }
}
