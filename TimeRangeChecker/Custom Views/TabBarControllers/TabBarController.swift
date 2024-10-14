import UIKit

final class TabBarController: UITabBarController {

    private let dataManager: CoreDataManaging
    private let alert: AlertDisplaying

    init(dataManager: CoreDataManaging = CoreDataManager(), alert: AlertDisplaying = Alert()) {
        self.dataManager = dataManager
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemBlue
        viewControllers = [createInputNavigationController(), createHistoryNavigationController()]
    }

    private func createInputNavigationController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Input", bundle: nil)

        let inputViewController = storyboard.instantiateViewController(identifier: "InputViewController") { coder in
            InputViewController(coder: coder, dataManager: self.dataManager, alert: self.alert)
        }
        inputViewController.title = "入力"
        inputViewController.tabBarItem = UITabBarItem(
            title: "Input",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )

        return UINavigationController(rootViewController: inputViewController)
    }

    private func createHistoryNavigationController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "History", bundle: nil)

        let historyViewController = storyboard.instantiateViewController(identifier: "HistoryViewController") { coder in
            HistoryViewController(coder: coder, dataManager: self.dataManager)
        }

        historyViewController.title = "履歴"
        historyViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)

        return UINavigationController(rootViewController: historyViewController)
    }
}
