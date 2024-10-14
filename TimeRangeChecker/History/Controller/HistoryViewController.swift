import UIKit

final class HistoryViewController: UIViewController {

    private let dataManager: CoreDataManaging

    private var timeCheckResults: [TimeCheckResult] = []

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: HistoryCell.className, bundle: nil),
                               forCellReuseIdentifier: HistoryCell.className)
            tableView.dataSource = self
        }
    }

    init?(coder: NSCoder, dataManager: CoreDataManaging = CoreDataManager()) {
        self.dataManager = dataManager
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTimeCheckResults()
    }

    // MARK: - データ取得
    @MainActor
    private func fetchTimeCheckResults() {
        timeCheckResults = dataManager.fetchTimeCheckResults()
        tableView.reloadData()
    }
}

// MARK: - TableView
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCheckResults.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.className) as? HistoryCell
                        else { fatalError("Failed to dequeue HistoryCell") }
        let results = timeCheckResults[indexPath.row]
        cell.configure(timeCheckResult: results)
        return cell
    }
}
