import XCTest
@testable import swift_serve_postgres

class swift_serve_postgresTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_serve_postgres().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
