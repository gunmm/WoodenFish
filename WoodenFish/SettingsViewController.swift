
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let inputLabel = UILabel()
    private let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupdismissKeyboardGesture()
    }

    private func setupUI() {
        // Title Label
        titleLabel.text = "设置"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Close Button (X icon) - Moved to Top Right
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(dismissSettings), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        // Input Label
        inputLabel.text = "敲击文案"
        inputLabel.textColor = .lightGray
        inputLabel.font = UIFont.systemFont(ofSize: 14)
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputLabel)
        
        // TextField
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        
        let placeholderText = "请输入敲击文字 (例如: 功德+1)"
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        textField.text = UserDefaults.standard.string(forKey: "knockText")
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            // Title: Top Center
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            // Close Button: Top Right
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Input Label: Above TextField
            inputLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            inputLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -8),
            
            // TextField: Below Input Label
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func dismissSettings() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
