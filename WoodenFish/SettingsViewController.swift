
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let inputLabel = UILabel()
    private let textField = UITextField()
    private let audioLabel = UILabel()
    private var audioButtons: [UIButton] = []

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
        
        // Audio Label
        audioLabel.text = "选择音频"
        audioLabel.textColor = .lightGray
        audioLabel.font = UIFont.systemFont(ofSize: 14)
        audioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(audioLabel)
        
        // Audio Buttons & Stack
        let row1Stack = UIStackView()
        row1Stack.axis = .horizontal
        row1Stack.distribution = .fillEqually
        row1Stack.spacing = 10
        
        let row2Stack = UIStackView()
        row2Stack.axis = .horizontal
        row2Stack.distribution = .fillEqually
        row2Stack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [row1Stack, row2Stack])
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        let soundCount = AudioManager.shared.getSoundCount()
        for i in 0..<soundCount {
            let btn = UIButton(type: .system)
            btn.setTitle(AudioManager.shared.getSoundName(at: i), for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .darkGray
            btn.layer.cornerRadius = 8
            btn.tag = i
            btn.addTarget(self, action: #selector(audioSelected(_:)), for: .touchUpInside)
            audioButtons.append(btn)
            
            if i < 3 {
                row1Stack.addArrangedSubview(btn)
            } else {
                row2Stack.addArrangedSubview(btn)
            }
        }
        
        updateAudioSelectionUI()
        
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
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            // Audio Label
            audioLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            audioLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            
            // Audio Buttons Stack
            mainStack.topAnchor.constraint(equalTo: audioLabel.bottomAnchor, constant: 10),
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.widthAnchor.constraint(equalTo: textField.widthAnchor),
            mainStack.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func audioSelected(_ sender: UIButton) {
        let index = sender.tag
        AudioManager.shared.currentSoundIndex = index
        AudioManager.shared.playSound(at: index)
        updateAudioSelectionUI()
    }
    
    private func updateAudioSelectionUI() {
        let currentIndex = AudioManager.shared.currentSoundIndex
        for (index, btn) in audioButtons.enumerated() {
            if index == currentIndex {
                btn.backgroundColor = .systemBlue
                btn.layer.borderWidth = 2
                btn.layer.borderColor = UIColor.white.cgColor
            } else {
                btn.backgroundColor = .darkGray
                btn.layer.borderWidth = 0
            }
        }
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
