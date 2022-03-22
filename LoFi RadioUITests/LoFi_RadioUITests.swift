//
//  LoFi_RadioUITests.swift
//  LoFi RadioUITests
//
//  Created by Matthew Lock on 22/03/2022.
//

import XCTest

class LoFi_RadioUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testViewController_UponLoading_DisplaysHeader() {
        let lofiRadioStaticText = app.staticTexts["Lofi Radio"]
        XCTAssertNotNil(lofiRadioStaticText)
        XCTAssertEqual(lofiRadioStaticText.label, "Lofi Radio")
    }
    
    func testViewController_UponLoading_DisplaysVideo() {
        let video = XCUIApplication().windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        XCTAssertNotNil(video)
    }
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
