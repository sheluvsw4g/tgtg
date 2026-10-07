import Foundation
import SwiftSignalKit

public final class StarsMockManager {
    public static let shared = StarsMockManager()
    
    private let queue = DispatchQueue(label: "org.telegram.StarsMockManager")
    public var onBalanceChanged: (() -> Void)?
    
    private init() {}
    
    public var fakeBonusStars: Int64 {
        get {
            if let val = UserDefaults.standard.object(forKey: "custom_fake_bonus_stars") as? Int64 {
                return val
            }
            return 5000
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "custom_fake_bonus_stars")
            self.notifyUpdate()
        }
    }
    
    public var spentFakeStars: Int64 {
        get {
            return (UserDefaults.standard.object(forKey: "custom_spent_fake_stars") as? Int64) ?? 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "custom_spent_fake_stars")
            self.notifyUpdate()
        }
    }
    
    public var mockNftPurchasesEnabled: Bool {
        get {
            if let val = UserDefaults.standard.object(forKey: "custom_mock_nft_purchases") as? Bool {
                return val
            }
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "custom_mock_nft_purchases")
        }
    }
    
    public func effectiveBonus() -> Int64 {
        return max(0, self.fakeBonusStars - self.spentFakeStars)
    }
    
    public func spendFakeStars(amount: Int64) {
        self.spentFakeStars += amount
    }
    
    public func resetSpentStars() {
        self.spentFakeStars = 0
    }
    
    private func notifyUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.onBalanceChanged?()
        }
    }
}
