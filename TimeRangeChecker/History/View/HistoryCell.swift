import UIKit

final class HistoryCell: UITableViewCell {

    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var checkTimeLabel: UILabel!
    @IBOutlet private weak var inIncludedLabel: UILabel!

    static var className: String { String(describing: HistoryCell.self)}

    override func prepareForReuse() {
        super.prepareForReuse()
        startTimeLabel.text = nil
        endTimeLabel.text = nil
        checkTimeLabel.text = nil
        inIncludedLabel.text = nil
    }

    func configure(timeCheckResult: TimeCheckResult) {
        startTimeLabel.text = timeCheckResult.startTime.description
        endTimeLabel.text = timeCheckResult.endTime.description
        checkTimeLabel.text = timeCheckResult.checkTime.description
        inIncludedLabel.text = timeCheckResult.isIncluded ? "含まれる" : "含まれない"
    }
}
