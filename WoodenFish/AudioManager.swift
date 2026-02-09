import UIKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    private let soundFiles = [
        "01片段1",
        "02片段2",
        "03片段3",
        "04片段4",
        "05片段5",
        "06片段6"
    ]
    
    // Key for UserDefaults
    private let selectedSoundKey = "selectedSoundIndex"
    
    // Public property to get/set the current sound index (0-5)
    var currentSoundIndex: Int {
        get {
            // Default to 0 (the first sound) if not set
            return UserDefaults.standard.integer(forKey: selectedSoundKey)
        }
        set {
            if newValue >= 0 && newValue < soundFiles.count {
                UserDefaults.standard.set(newValue, forKey: selectedSoundKey)
            }
        }
    }
    
    private init() {
        // Prepare the session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playCurrentSound() {
        playSound(at: currentSoundIndex)
    }
    
    func playSound(at index: Int) {
        guard index >= 0 && index < soundFiles.count else { return }
        
        let fileName = soundFiles[index]
        
        // Use Bundle.main to locate the file. 
        // We search in the "sound" subdirectory if possible, or just the main bundle.
        // Since the user said "sound folder", let's try to look for it.
        // If the folder is added as a group, it's in the root of the bundle.
        // If it's a folder ref, it is in a subdirectory. We try both.
        
        var url = Bundle.main.url(forResource: fileName, withExtension: "m4a")
        
        if url == nil {
            // Try looking in "sound" directory
            url = Bundle.main.url(forResource: fileName, withExtension: "m4a", subdirectory: "sound")
        }
        
        guard let soundURL = url else {
            print("Could not find sound file: \(fileName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func getSoundCount() -> Int {
        return soundFiles.count
    }
    
    func getSoundName(at index: Int) -> String {
        // Return a simple display name like "01", "02", etc.
        return String(format: "%02d", index + 1)
    }
}
