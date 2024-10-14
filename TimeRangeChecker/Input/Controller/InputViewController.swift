import UIKit

final class InputViewController: UIViewController {

    private let dataManager: CoreDataManaging
    private let alert: AlertDisplaying
    private let maxTextLength = 2

    @IBOutlet private weak var checkTimeLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!

    @IBOutlet private weak var checkTimeTextField: UITextField! {
        didSet {
            checkTimeTextField.delegate = self
            checkTimeTextField.keyboardType = .numberPad
        }
    }

    @IBOutlet private weak var startTimeTextField: UITextField! {
        didSet {
            startTimeTextField.delegate = self
            startTimeTextField.keyboardType = .numberPad
        }
    }

    @IBOutlet private weak var endTimeTextField: UITextField! {
        didSet {
            endTimeTextField.delegate = self
            endTimeTextField.keyboardType = .numberPad
        }
    }

    @IBOutlet private weak var checkButton: UIButton! {
        didSet {
            checkButton.addTarget(self, action: #selector(tappedcheckButton), for: .touchUpInside)
        }
    }

    init?(coder: NSCoder, dataManager: CoreDataManaging = CoreDataManager(), alert: AlertDisplaying = Alert()) {
        self.dataManager = dataManager
        self.alert = alert
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UITextFieldDelegate
extension InputViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        // 入力されたときの文字制限をチェック
        let currentText = textField.text ?? ""
        let updatedTextLength = currentText.count + (string.count - range.length)
        return updatedTextLength <= maxTextLength
    }
}

extension InputViewController {

    @MainActor
    @objc func tappedcheckButton() {
        let checkTime = Int(checkTimeTextField.text ?? "")
        let startTime = Int(startTimeTextField.text ?? "")
        let endTime = Int(endTimeTextField.text ?? "")

        let resultMessage = dataManager.checkAndSaveTimeRange(
            startTime: startTime,
            endTime: endTime,
            checkTime: checkTime
        )
        alert.okAlert(viewController: self, title: "結果", message: resultMessage, handler: nil)
    }
}
