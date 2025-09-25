//
//  AppStandUITests.swift
//  AppStandUITests
//
//  Created by admin on 25/09/2025.
//

import XCTest

@MainActor
final class AppStandUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSplashTransitionsToHome() throws {
        app.launch()

        let splashLogo = app.images["SplashLogo"]
        // Be tolerant to simulator slowness
        XCTAssertTrue(splashLogo.waitForExistence(timeout: 5), "Splash logo should appear promptly")

        let homeTitle = app.staticTexts["HomeScreenTitle"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 6), "Home content should appear after splash fades")
    }

    func testHeroRailLoopsAndUpdatesContent() throws {
        app.launch()

        // `TabView` exposes as a scrollView in accessibility tree
        let heroRail = app.scrollViews["HeroRail"]
        XCTAssertTrue(heroRail.waitForExistence(timeout: 6), "Hero rail should be visible on home")

        let arenaCard = heroRail.otherElements["HeroCard_Arena"]
        XCTAssertTrue(arenaCard.exists, "Arena card should be present")

        // Swipe left through all items to trigger wrap-around back to Arena
        heroRail.swipeLeft()
        heroRail.swipeLeft()
        heroRail.swipeLeft()

        let arenaDot = app.otherElements["HeroIndicator_0"]
        XCTAssertTrue(arenaDot.exists)
        XCTAssertEqual(arenaDot.value as? String, "active")
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
