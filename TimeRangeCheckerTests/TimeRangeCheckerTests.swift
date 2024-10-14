import XCTest
import CoreData
@testable import TimeRangeChecker

final class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        // テスト用セットアップ
        mockPersistentContainer = NSPersistentContainer(name: "TimeRangeChecker")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockPersistentContainer.persistentStoreDescriptions = [description]

        mockPersistentContainer.loadPersistentStores { (description, error) in
            XCTAssertNil(error, "インメモリーストアのセットアップに失敗しました: \(String(describing: error))")
        }

        coreDataManager = CoreDataManager(container: mockPersistentContainer)
    }

    override func tearDown() {
        if let store = mockPersistentContainer.persistentStoreCoordinator.persistentStores.first {
            do {
                try mockPersistentContainer.persistentStoreCoordinator.remove(store)
            } catch {
                NSLog("Error removing persistent store: \(error)")
            }
        }
        super.tearDown()
    }

    func testCheckAndSaveTimeRange_ValidInput() {
        // 範囲内の時刻を指定
        let message = coreDataManager.checkAndSaveTimeRange(startTime: 8, endTime: 17, checkTime: 12)
        XCTAssertEqual(message, "含まれています", "正しい範囲で時間が含まれている場合、含まれていますというメッセージが返されるべきです")

        let results = coreDataManager.fetchTimeCheckResults()
        XCTAssertEqual(results.count, 1, "保存された結果の数は1つのはずです")
        XCTAssertEqual(results.first?.startTime, 8)
        XCTAssertEqual(results.first?.endTime, 17)
        XCTAssertEqual(results.first?.checkTime, 12)
        XCTAssertEqual(results.first?.isIncluded, true, "範囲内なので isIncluded は true であるべきです")
    }

    func testCheckAndSaveTimeRange_NotIncluded() {
        // 範囲外の時刻を指定
        let message = coreDataManager.checkAndSaveTimeRange(startTime: 8, endTime: 17, checkTime: 18)
        XCTAssertEqual(message, "含まれていません", "範囲で時間が含まれていない場合、含まれていませんというメッセージが返されるべきです")

        let results = coreDataManager.fetchTimeCheckResults()
        XCTAssertEqual(results.count, 1, "保存された結果の数は1つのはずです")
        XCTAssertEqual(results.first?.startTime, 8)
        XCTAssertEqual(results.first?.endTime, 17)
        XCTAssertEqual(results.first?.checkTime, 18)
        XCTAssertEqual(results.first?.isIncluded, false, "範囲外なので isIncluded は false であるべきです")
    }

    func testCheckAndSaveTimeRange_InvalidInput() {
        let message = coreDataManager.checkAndSaveTimeRange(startTime: 24, endTime: 5, checkTime: 2)
        XCTAssertEqual(message, "無効な入力です。0から23の範囲で入力してください。", "不正な時間入力に対してはエラーメッセージが返されるべきです")

        let results = coreDataManager.fetchTimeCheckResults()
        XCTAssertEqual(results.count, 0, "不正な入力に対しては保存されるデータはないはずです")
    }
}
