import Foundation
import UIKit
import Display
import TelegramUIPreferences
import SwiftSignalKit
import AccountContext

public final class DynamicIslandOverlayWindow: UIWindow {
    public static let shared = DynamicIslandOverlayWindow()
    
    private let containerView = UIView()
    private let pillView = UIView()
    private let avatarImageView = UIImageView()
    private let titleLabel = UILabel()
    private let batteryIndicatorView = UIView()
    private let statusLabel = UILabel()
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        self.windowLevel = UIWindow.Level.statusBar + 100
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        pillView.backgroundColor = UIColor(white: 0.95, alpha: 0.95)
        pillView.layer.cornerRadius = 18.0
        pillView.layer.masksToBounds = true
        pillView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pillView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .black)
        titleLabel.textColor = UIColor(red: 0.85, green: 0.30, blue: 0.85, alpha: 1.0)
        titleLabel.text = "rosegram"
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pillView.addSubview(titleLabel)
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 14.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = .clear
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        pillView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60.0),
            
            pillView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 11.0),
            pillView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            pillView.widthAnchor.constraint(equalToConstant: 130.0),
            pillView.heightAnchor.constraint(equalToConstant: 36.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: pillView.leadingAnchor, constant: 14.0),
            titleLabel.centerYAnchor.constraint(equalTo: pillView.centerYAnchor),
            
            avatarImageView.trailingAnchor.constraint(equalTo: pillView.trailingAnchor, constant: -4.0),
            avatarImageView.centerYAnchor.constraint(equalTo: pillView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28.0)
        ])
    }
    
    public func update(settings: ExtendedAppSettings) {
        if settings.dynamicIslandEnabled {
            self.titleLabel.text = settings.dynamicIslandText
            self.isHidden = false
            self.alpha = 1.0
        } else {
            self.isHidden = true
            self.alpha = 0.0
        }
    }
}
