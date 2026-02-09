
import UIKit

class SettingsViewController: UIViewController {

    private let textField = UITextField()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupdismissKeyboardGesture()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "设置"
        
        // TextField
        textField.borderStyle = .roundedRect
        textField.placeholder = "请输入敲击文字 (例如: 功德+1)"
        textField.text = UserDefaults.standard.string(forKey: "knockText")
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        // Save Button (optional, can just save on disappear or return)
        // Actually, let's just save when text changes or view disappears. 
        // But a button is explicit.
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = textField.text, !text.isEmpty {
            UserDefaults.standard.set(text, forKey: "knockText")
        } else {
             UserDefaults.standard.removeObject(forKey: "knockText")
        }
    }
    
    private func setupdismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
