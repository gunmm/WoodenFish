import UIKit
import AudioToolbox

class ViewController: UIViewController {

    private let fishImageView = UIImageView()
    private let settingsButton = UIButton(type: .system)
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = .black
        
        // Wooden Fish Image
        // Using a system symbol or placeholder since generation failed.
        // A simple white oval shape or circle to represent the fish.
        if let image = UIImage(named: "wooden_fish") {
             fishImageView.image = image
        } else {
            // Fallback: detailed symbol or just a circle
            fishImageView.image = UIImage(systemName: "oval.portrait.fill") ?? UIImage(systemName: "circle.fill")
            fishImageView.tintColor = .white
        }
        
        fishImageView.contentMode = .scaleAspectFit
        fishImageView.isUserInteractionEnabled = true
        fishImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fishImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        fishImageView.addGestureRecognizer(tapGesture)
        
        // Settings Button
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            fishImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fishImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fishImageView.widthAnchor.constraint(equalToConstant: 200),
            fishImageView.heightAnchor.constraint(equalToConstant: 200),
            
            settingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            settingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func handleTap() {
        // Animation
        UIView.animate(withDuration: 0.1, animations: {
            self.fishImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.fishImageView.transform = .identity
            }
        }
        
        // Haptics
        feedbackGenerator.impactOccurred()
        
        // Sound (System sound for "Tock" or similar)
        // 1519 is a rigid feedback sound, 1104 is Tock
        AudioServicesPlaySystemSound(1519) 
        
        // Floating Text
        showFloatingText()
    }
    
    private func showFloatingText() {
        let text = UserDefaults.standard.string(forKey: "knockText") ?? "功德+1"
        guard !text.isEmpty else { return }
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.alpha = 1.0
        
        // Position: Top right of the fish, but higher
        let fishFrame = fishImageView.frame
        let startX = fishFrame.maxX - 40
        // Move higher up. Original was minY + 50. Let's try minY - 20 to start above the fish or near top edge.
        let startY = fishFrame.minY - 20 
        
        label.frame = CGRect(x: startX, y: startY, width: 200, height: 30)
        view.addSubview(label)
        
        // Animation
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
            label.frame.origin.y -= 50
            label.alpha = 0.0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
    @objc private func openSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overFullScreen
        settingsVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.present(settingsVC, animated: true, completion: nil)
    }
}

