// Created for VirtuozDemo on 2024
        
import VirtuozSDK
import UIKit

class MainViewController: UIViewController, UITextViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var debugView: UITextView! {
        didSet { debugView.delegate = self }
    }
    
    @IBOutlet private weak var connectedView: UIView! {
        didSet {
            connectedView.layer.cornerRadius = 6.0
            connectedView.backgroundColor = .red
        }
    }
    
    @IBOutlet private weak var actionButton: UIButton! {
        didSet { actionButton.layer.cornerRadius = 6.0 }
    }
    
    @IBOutlet private weak var updateAvailableButton: UIButton! {
        didSet {
            updateAvailableButton.isHidden = true
            updateAvailableButton.addTarget(self, action: #selector(handleUpdateAvailable), for: .touchUpInside)
        }
    }
    
    // MARK: - Properties
    
    private let virtuozManager = VirtuozManager.shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVirtuozManager()
        setupDebugView()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        autoscrollDebugView()
    }

    // MARK: - Actions
    
    @objc private func handleConnect() {
        virtuozManager.connect(onSuccess: { [weak self] in
            self?.debugView.text = nil
            self?.setupDebugView()
        }, onError: { [weak self] in
            self?.debugView.insertText("\n\n--- There was an error while linkind Virtuoz to the demo app 😢")
        })
    }
    
    @objc private func handleTrigger() {
        virtuozManager.triggerVibration()
    }
    
    @objc private func handleUpdateAvailable() {
        virtuozManager.redirectToVirtuoz()
        updateAvailableButton.isHidden = true
    }
    
    // MARK: - Private
    
    private func setupVirtuozManager() {
        let configuration = VirtuozSDK.Configuration(urlScheme: "virtuozdemo://", enableLogs: true, killAppOnLongPress: false)
        virtuozManager.setup(with: configuration)
        virtuozManager.delegate = self
    }
    
    private func setupDebugView() {
        debugView.insertText("-- Welcome to the Virtuoz Demo 🎉")
        
        actionButton.removeTarget(nil, action: nil, for: .allEvents)
        if let virtuozName = virtuozManager.linkedVirtuozName {
            debugView.insertText("\n\n--- You already have linked the app with a Virtuoz named \(virtuozName).")
            actionButton.backgroundColor = .darkGray
            actionButton.setTitle("Trigger vibration", for: .normal)
            actionButton.addTarget(self, action: #selector(handleTrigger), for: .touchUpInside)
        } else {
            debugView.insertText("\n\n--- You need to link your remote control to your app using the connect button below.")
            actionButton.setTitle("Connect", for: .normal)
            actionButton.addTarget(self, action: #selector(handleConnect), for: .touchUpInside)
        }
    }
    
    private func autoscrollDebugView() {
        let range = NSRange(location: debugView.text.count - 1, length: 0)
        debugView.scrollRangeToVisible(range)
    }
    
}

extension MainViewController: VirtuozManagerDelegate {
    func virtuozHasBeenUnpaired() {
        setupDebugView()
    }
    
    func virtuozBatteryLevelUpdated(value: Int, image: UIImage?) {
        debugView.insertText("\n-- Virtuoz battery level has changed: \(value)%")
    }
    
    func virtuozStateUpdated(state: VirtuozSDK.PeripheralState) {
        debugView.insertText("\n-- Virtuoz state has changed: \(state)")
        connectedView.backgroundColor = state == .connected ? .green : .red
        actionButton.backgroundColor = state == .connected ? .systemTeal : .darkGray
    }
    
    func virtuozHasAnUpdateAvailable() {
        debugView.insertText("\n-- Virtuoz has an update available")
        updateAvailableButton.isHidden = false
    }
    
    func virtuozDidPress() {
        debugView.insertText("\n-- Virtuoz Press triggered")
    }
    
    func virtuozDidLongPress() {
        debugView.insertText("\n-- Virtuoz Long Press triggered")
    }
    
}
