import UIKit

protocol AlertDisplaying {
    func okAlert(viewController: UIViewController,
                 title: String,
                 message: String,
                 handler: ((UIAlertAction) -> Void)?)
}

final class Alert: AlertDisplaying {
    // OKのみアラート
    func okAlert(viewController: UIViewController,
                 title: String,
                 message: String,
                 handler: ((UIAlertAction) -> Void)? = nil) {
        let okAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        okAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        viewController.present(okAlertVC, animated: true, completion: nil)
    }
}
