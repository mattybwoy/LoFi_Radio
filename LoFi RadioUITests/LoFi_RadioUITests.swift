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
    
    func testViewController_UponLoading_DisplaysPlayButton() {
        let playButton = app.staticTexts["Play"]
        
        XCTAssertNotNil(playButton)
        XCTAssertEqual(playButton.label, "Play")
    }
    
    func testViewController_UponLoading_AfterTappingPlayDisplaysPauseButton() {
        app.staticTexts["Play"].tap()
        let pauseButton = app.staticTexts["Pause"]
        
        XCTAssertNotNil(pauseButton)
        XCTAssertEqual(pauseButton.label, "Pause")
    }
    
    func testViewController_UponLoading_DisplaysVolumeSlider() {
        let slider = app.sliders["50%"]
        
        XCTAssertNotNil(slider)
        XCTAssertEqual(slider.value as! String, "50%")
    }
    
    func testViewController_UponLoading_DisplaysToggle() {
        let darkModeSwitch: Void = app.switches["1"].children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()

        XCTAssertNotNil(darkModeSwitch)
    }
    
    func testViewController_UponLoading_DisplaysAboutButton() {
        let aboutButton = app/*@START_MENU_TOKEN@*/.staticTexts["About"]/*[[".buttons[\"About\"].staticTexts[\"About\"]",".staticTexts[\"About\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertEqual(aboutButton.label, "About")
    }
    
    func testViewController_UponLoadingAboutScreen_DisplaysAboutInformation() {
        app/*@START_MENU_TOKEN@*/.staticTexts["About"]/*[[".buttons[\"About\"].staticTexts[\"About\"]",".staticTexts[\"About\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let aboutScreenText = app.staticTexts["All images and music courtesy of Lofi Girl & Lofi Records"]

        XCTAssertEqual(aboutScreenText.label, "All images and music courtesy of Lofi Girl & Lofi Records")
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
