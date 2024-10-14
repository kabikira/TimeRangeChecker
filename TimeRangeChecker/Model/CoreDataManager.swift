import CoreData

protocol CoreDataManaging {
    var context: NSManagedObjectContext { get }
    func fetchTimeCheckResults() -> [TimeCheckResult]
    func checkAndSaveTimeRange(startTime: Int?, endTime: Int?, checkTime: Int?) -> String
}

final class CoreDataManager: CoreDataManaging {

    let persistentContainer: NSPersistentContainer

    init(container: NSPersistentContainer = NSPersistentContainer(name: "TimeRangeChecker")) {
        self.persistentContainer = container

        // 既存のストアを削除
        if let store = persistentContainer.persistentStoreCoordinator.persistentStores.first {
            do {
                try persistentContainer.persistentStoreCoordinator.remove(store)
            } catch {
                fatalError("既存のストアの削除に失敗しました: \(error)")
            }
        }

        // 新しいストアをロード
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Dataの初期化エラー: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension CoreDataManaging {

    func fetchTimeCheckResults() -> [TimeCheckResult] {
        let fetchRequest: NSFetchRequest<TimeCheckResult> = TimeCheckResult.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            preconditionFailure("フェッチエラー: \(error)")
        }
    }

    // 入力の検証と範囲判定
    func checkAndSaveTimeRange(startTime: Int?, endTime: Int?, checkTime: Int?) -> String {
        guard let checkTime = checkTime,
              let startTime = startTime,
              let endTime = endTime,
              (0...23).contains(checkTime),
              (0...23).contains(startTime),
              (0...23).contains(endTime)
        else {
            return "無効な入力です。0から23の範囲で入力してください。"
        }

        let isIncluded = isTimeIncluded(checkTime, startTime: startTime, endTime: endTime)
        saveResult(startTime: startTime, endTime: endTime, checkTime: checkTime, isIncluded: isIncluded)
        return isIncluded ? "含まれています" : "含まれていません"
    }

    // 判定ロジック
    private func isTimeIncluded(_ checkTime: Int, startTime: Int, endTime: Int) -> Bool {
        if startTime == endTime {
            return true
        } else if startTime < endTime {
            return (startTime <= checkTime && checkTime < endTime)
        } else {
            return (checkTime >= startTime || checkTime < endTime)
        }
    }

    // 保存ロジック
    private func saveResult(startTime: Int, endTime: Int, checkTime: Int, isIncluded: Bool) {
        let context = self.context
        let newResult = TimeCheckResult(context: context)
        newResult.startTime = Int16(startTime)
        newResult.endTime = Int16(endTime)
        newResult.checkTime = Int16(checkTime)
        newResult.isIncluded = isIncluded
        newResult.createdAt = Date()
        newResult.updatedAt = Date()

        do {
            try context.save()
            NSLog("データが保存されました")
        } catch {
            preconditionFailure("データの保存に失敗しました: \(error)")
        }
    }
}
