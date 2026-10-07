import Foundation
import SwiftSignalKit

public struct MockProfileGiftItem: Codable, Equatable {
    public let id: Int64
    public let title: String
    public let num: Int32
    public let rarity: String
    public let recipientPeerId: Int64
    public let date: Int32

    public init(id: Int64, title: String, num: Int32, rarity: String, recipientPeerId: Int64, date: Int32) {
        self.id = id
        self.title = title
        self.num = num
        self.rarity = rarity
        self.recipientPeerId = recipientPeerId
        self.date = date
    }
}

public final class FakeGiftsManager {
    public static let shared = FakeGiftsManager()

    private let key = "custom_fake_profile_gifts_v1"

    public var gifts: [MockProfileGiftItem] {
        get {
            if let data = UserDefaults.standard.data(forKey: key),
               let list = try? JSONDecoder().decode([MockProfileGiftItem].self, from: data) {
                return list
            }
            return [
                MockProfileGiftItem(id: 777001, title: "Plush Pepe", num: 1337, rarity: "Legendary NFT", recipientPeerId: 0, date: Int32(Date().timeIntervalSince1970)),
                MockProfileGiftItem(id: 777002, title: "Durov's Cap", num: 777, rarity: "Unique #777", recipientPeerId: 0, date: Int32(Date().timeIntervalSince1970))
            ]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }

    public func addGift(title: String, num: Int32, recipientPeerId: Int64) {
        var current = self.gifts
        current.insert(MockProfileGiftItem(
            id: Int64.random(in: 100000...999999),
            title: title,
            num: num,
            rarity: "Unique NFT",
            recipientPeerId: recipientPeerId,
            date: Int32(Date().timeIntervalSince1970)
        ), at: 0)
        self.gifts = current
    }

    public func giftsForPeer(peerId: Int64) -> [MockProfileGiftItem] {
        return self.gifts.filter { $0.recipientPeerId == peerId || (peerId == 0 && $0.recipientPeerId == 0) }
    }
}
