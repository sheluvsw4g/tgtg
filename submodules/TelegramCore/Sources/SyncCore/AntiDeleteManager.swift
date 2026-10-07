import Foundation

public final class AntiDeleteManager {
    public static var isAntiDeleteEnabled: () -> Bool = {
        return UserDefaults.standard.object(forKey: "custom_anti_delete_enabled") as? Bool ?? true
    }
}
