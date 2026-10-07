import Foundation
import Postbox

public final class AntiDeleteManager {
    public static var isAntiDeleteEnabled: () -> Bool = {
        return UserDefaults.standard.object(forKey: "custom_anti_delete_enabled") as? Bool ?? true
    }

    private static let lock = NSLock()
    private static var deletedIds: Set<String> = {
        let array = UserDefaults.standard.stringArray(forKey: "custom_deleted_message_keys") ?? []
        return Set(array)
    }()

    public static func markDeleted(id: MessageId) {
        let key = "\(id.peerId.toInt64())_\(id.namespace)_\(id.id)"
        lock.lock()
        deletedIds.insert(key)
        let list = Array(deletedIds.suffix(10000))
        lock.unlock()

        DispatchQueue.global(qos: .utility).async {
            UserDefaults.standard.set(list, forKey: "custom_deleted_message_keys")
        }
    }

    public static func markDeleted(globalId: Int32) {
        let key = "global_\(globalId)"
        lock.lock()
        deletedIds.insert(key)
        let list = Array(deletedIds.suffix(10000))
        lock.unlock()

        DispatchQueue.global(qos: .utility).async {
            UserDefaults.standard.set(list, forKey: "custom_deleted_message_keys")
        }
    }

    public static func isDeleted(id: MessageId) -> Bool {
        guard isAntiDeleteEnabled() else { return false }
        let key = "\(id.peerId.toInt64())_\(id.namespace)_\(id.id)"
        let globalKey = "global_\(id.id)"
        lock.lock()
        let result = deletedIds.contains(key) || deletedIds.contains(globalKey)
        lock.unlock()
        return result
    }
}
