import Foundation
import TelegramCore
import SwiftSignalKit

public struct ExtendedAppSettings: Codable, Equatable {
    // 1. Ghost Mode & Privacy
    public var ghostModeEnabled: Bool
    public var hideTypingStatus: Bool
    public var markStoriesReadLocallyOnly: Bool
    public var sendDelaySeconds: Double
    public var sendSilentByDefault: Bool

    // 2. Anti-Delete & Logging
    public var antiDeleteEnabled: Bool
    public var antiEditEnabled: Bool
    public var logSeenTimestamps: Bool
    public var maxMediaCacheLimitGB: Int

    // 3. Mock Data & Visual Identity
    public var fakePhoneEnabled: Bool
    public var fakePhoneNumber: String
    public var fakePremiumBadge: Bool
    public var fakeProfileBannerGifPath: String?
    public var fakeBalanceTON: String?
    public var fakeLevelRating: Int
    public var fakeGiftsEnabled: Bool
    public var showDeletedGifts: Bool
    public var dynamicIslandEnabled: Bool
    public var dynamicIslandText: String
    public var dynamicIslandCustomIconPath: String?

    // 4. Media & Protection Bypass
    public var bypassContentProtection: Bool
    public var voiceChangerEnabled: Bool
    public var voicePitchShift: Float
    public var audioEqualizerBassBoost: Float

    // 5. UI/UX Customization
    public var liquidGlassEffects: Bool
    public var fallingSnowEffect: Bool
    public var maxAccountsCount: Int
    public var blockChannelSponsoredAds: Bool
    public var stickyAvatarScroll: Bool

    // 6. System & Options
    public var showSecondsInTime: Bool
    public var exactViewsCount: Bool
    public var stripZalgoCharacters: Bool
    public var translationProvider: String
    public var targetTranslationLang: String

    public static var defaultSettings: ExtendedAppSettings {
        return ExtendedAppSettings(
            ghostModeEnabled: false,
            hideTypingStatus: false,
            markStoriesReadLocallyOnly: false,
            sendDelaySeconds: 0.0,
            sendSilentByDefault: false,
            antiDeleteEnabled: true,
            antiEditEnabled: true,
            logSeenTimestamps: false,
            maxMediaCacheLimitGB: 10,
            fakePhoneEnabled: true,
            fakePhoneNumber: "+0",
            fakePremiumBadge: true,
            fakeProfileBannerGifPath: nil,
            fakeBalanceTON: "1,337.00 TON",
            fakeLevelRating: 100,
            fakeGiftsEnabled: true,
            showDeletedGifts: true,
            dynamicIslandEnabled: true,
            dynamicIslandText: "rosegram",
            dynamicIslandCustomIconPath: nil,
            bypassContentProtection: true,
            voiceChangerEnabled: false,
            voicePitchShift: 0.0,
            audioEqualizerBassBoost: 0.0,
            liquidGlassEffects: true,
            fallingSnowEffect: false,
            maxAccountsCount: 15,
            blockChannelSponsoredAds: true,
            stickyAvatarScroll: true,
            showSecondsInTime: false,
            exactViewsCount: true,
            stripZalgoCharacters: true,
            translationProvider: "DeepL",
            targetTranslationLang: "ru"
        )
    }

    public init(
        ghostModeEnabled: Bool,
        hideTypingStatus: Bool,
        markStoriesReadLocallyOnly: Bool,
        sendDelaySeconds: Double,
        sendSilentByDefault: Bool,
        antiDeleteEnabled: Bool,
        antiEditEnabled: Bool,
        logSeenTimestamps: Bool,
        maxMediaCacheLimitGB: Int,
        fakePhoneEnabled: Bool,
        fakePhoneNumber: String,
        fakePremiumBadge: Bool,
        fakeProfileBannerGifPath: String?,
        fakeBalanceTON: String?,
        fakeLevelRating: Int,
        fakeGiftsEnabled: Bool,
        showDeletedGifts: Bool,
        dynamicIslandEnabled: Bool,
        dynamicIslandText: String,
        dynamicIslandCustomIconPath: String?,
        bypassContentProtection: Bool,
        voiceChangerEnabled: Bool,
        voicePitchShift: Float,
        audioEqualizerBassBoost: Float,
        liquidGlassEffects: Bool,
        fallingSnowEffect: Bool,
        maxAccountsCount: Int,
        blockChannelSponsoredAds: Bool,
        stickyAvatarScroll: Bool,
        showSecondsInTime: Bool,
        exactViewsCount: Bool,
        stripZalgoCharacters: Bool,
        translationProvider: String,
        targetTranslationLang: String
    ) {
        self.ghostModeEnabled = ghostModeEnabled
        self.hideTypingStatus = hideTypingStatus
        self.markStoriesReadLocallyOnly = markStoriesReadLocallyOnly
        self.sendDelaySeconds = sendDelaySeconds
        self.sendSilentByDefault = sendSilentByDefault
        self.antiDeleteEnabled = antiDeleteEnabled
        self.antiEditEnabled = antiEditEnabled
        self.logSeenTimestamps = logSeenTimestamps
        self.maxMediaCacheLimitGB = maxMediaCacheLimitGB
        self.fakePhoneEnabled = fakePhoneEnabled
        self.fakePhoneNumber = fakePhoneNumber
        self.fakePremiumBadge = fakePremiumBadge
        self.fakeProfileBannerGifPath = fakeProfileBannerGifPath
        self.fakeBalanceTON = fakeBalanceTON
        self.fakeLevelRating = fakeLevelRating
        self.fakeGiftsEnabled = fakeGiftsEnabled
        self.showDeletedGifts = showDeletedGifts
        self.dynamicIslandEnabled = dynamicIslandEnabled
        self.dynamicIslandText = dynamicIslandText
        self.dynamicIslandCustomIconPath = dynamicIslandCustomIconPath
        self.bypassContentProtection = bypassContentProtection
        self.voiceChangerEnabled = voiceChangerEnabled
        self.voicePitchShift = voicePitchShift
        self.audioEqualizerBassBoost = audioEqualizerBassBoost
        self.liquidGlassEffects = liquidGlassEffects
        self.fallingSnowEffect = fallingSnowEffect
        self.maxAccountsCount = maxAccountsCount
        self.blockChannelSponsoredAds = blockChannelSponsoredAds
        self.stickyAvatarScroll = stickyAvatarScroll
        self.showSecondsInTime = showSecondsInTime
        self.exactViewsCount = exactViewsCount
        self.stripZalgoCharacters = stripZalgoCharacters
        self.translationProvider = translationProvider
        self.targetTranslationLang = targetTranslationLang
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.ghostModeEnabled = try container.decodeIfPresent(Bool.self, forKey: "ghostModeEnabled") ?? false
        self.hideTypingStatus = try container.decodeIfPresent(Bool.self, forKey: "hideTypingStatus") ?? false
        self.markStoriesReadLocallyOnly = try container.decodeIfPresent(Bool.self, forKey: "markStoriesReadLocallyOnly") ?? false
        self.sendDelaySeconds = try container.decodeIfPresent(Double.self, forKey: "sendDelaySeconds") ?? 0.0
        self.sendSilentByDefault = try container.decodeIfPresent(Bool.self, forKey: "sendSilentByDefault") ?? false

        self.antiDeleteEnabled = try container.decodeIfPresent(Bool.self, forKey: "antiDeleteEnabled") ?? true
        self.antiEditEnabled = try container.decodeIfPresent(Bool.self, forKey: "antiEditEnabled") ?? true
        self.logSeenTimestamps = try container.decodeIfPresent(Bool.self, forKey: "logSeenTimestamps") ?? false
        self.maxMediaCacheLimitGB = try container.decodeIfPresent(Int.self, forKey: "maxMediaCacheLimitGB") ?? 10

        self.fakePhoneEnabled = try container.decodeIfPresent(Bool.self, forKey: "fakePhoneEnabled") ?? true
        self.fakePhoneNumber = try container.decodeIfPresent(String.self, forKey: "fakePhoneNumber") ?? "+0"
        self.fakePremiumBadge = try container.decodeIfPresent(Bool.self, forKey: "fakePremiumBadge") ?? true
        self.fakeProfileBannerGifPath = try container.decodeIfPresent(String.self, forKey: "fakeProfileBannerGifPath")
        self.fakeBalanceTON = try container.decodeIfPresent(String.self, forKey: "fakeBalanceTON") ?? "1,337.00 TON"
        self.fakeLevelRating = try container.decodeIfPresent(Int.self, forKey: "fakeLevelRating") ?? 100
        self.fakeGiftsEnabled = try container.decodeIfPresent(Bool.self, forKey: "fakeGiftsEnabled") ?? true
        self.showDeletedGifts = try container.decodeIfPresent(Bool.self, forKey: "showDeletedGifts") ?? true
        self.dynamicIslandEnabled = try container.decodeIfPresent(Bool.self, forKey: "dynamicIslandEnabled") ?? true
        self.dynamicIslandText = try container.decodeIfPresent(String.self, forKey: "dynamicIslandText") ?? "rosegram"
        self.dynamicIslandCustomIconPath = try container.decodeIfPresent(String.self, forKey: "dynamicIslandCustomIconPath")

        self.bypassContentProtection = try container.decodeIfPresent(Bool.self, forKey: "bypassContentProtection") ?? true
        self.voiceChangerEnabled = try container.decodeIfPresent(Bool.self, forKey: "voiceChangerEnabled") ?? false
        self.voicePitchShift = try container.decodeIfPresent(Float.self, forKey: "voicePitchShift") ?? 0.0
        self.audioEqualizerBassBoost = try container.decodeIfPresent(Float.self, forKey: "audioEqualizerBassBoost") ?? 0.0

        self.liquidGlassEffects = try container.decodeIfPresent(Bool.self, forKey: "liquidGlassEffects") ?? true
        self.fallingSnowEffect = try container.decodeIfPresent(Bool.self, forKey: "fallingSnowEffect") ?? false
        self.maxAccountsCount = try container.decodeIfPresent(Int.self, forKey: "maxAccountsCount") ?? 15
        self.blockChannelSponsoredAds = try container.decodeIfPresent(Bool.self, forKey: "blockChannelSponsoredAds") ?? true
        self.stickyAvatarScroll = try container.decodeIfPresent(Bool.self, forKey: "stickyAvatarScroll") ?? true

        self.showSecondsInTime = try container.decodeIfPresent(Bool.self, forKey: "showSecondsInTime") ?? false
        self.exactViewsCount = try container.decodeIfPresent(Bool.self, forKey: "exactViewsCount") ?? true
        self.stripZalgoCharacters = try container.decodeIfPresent(Bool.self, forKey: "stripZalgoCharacters") ?? true
        self.translationProvider = try container.decodeIfPresent(String.self, forKey: "translationProvider") ?? "DeepL"
        self.targetTranslationLang = try container.decodeIfPresent(String.self, forKey: "targetTranslationLang") ?? "ru"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(self.ghostModeEnabled, forKey: "ghostModeEnabled")
        try container.encode(self.hideTypingStatus, forKey: "hideTypingStatus")
        try container.encode(self.markStoriesReadLocallyOnly, forKey: "markStoriesReadLocallyOnly")
        try container.encode(self.sendDelaySeconds, forKey: "sendDelaySeconds")
        try container.encode(self.sendSilentByDefault, forKey: "sendSilentByDefault")

        try container.encode(self.antiDeleteEnabled, forKey: "antiDeleteEnabled")
        try container.encode(self.antiEditEnabled, forKey: "antiEditEnabled")
        try container.encode(self.logSeenTimestamps, forKey: "logSeenTimestamps")
        try container.encode(self.maxMediaCacheLimitGB, forKey: "maxMediaCacheLimitGB")

        try container.encode(self.fakePhoneEnabled, forKey: "fakePhoneEnabled")
        try container.encode(self.fakePhoneNumber, forKey: "fakePhoneNumber")
        try container.encode(self.fakePremiumBadge, forKey: "fakePremiumBadge")
        try container.encodeIfPresent(self.fakeProfileBannerGifPath, forKey: "fakeProfileBannerGifPath")
        try container.encodeIfPresent(self.fakeBalanceTON, forKey: "fakeBalanceTON")
        try container.encode(self.fakeLevelRating, forKey: "fakeLevelRating")
        try container.encode(self.fakeGiftsEnabled, forKey: "fakeGiftsEnabled")
        try container.encode(self.showDeletedGifts, forKey: "showDeletedGifts")
        try container.encode(self.dynamicIslandEnabled, forKey: "dynamicIslandEnabled")
        try container.encode(self.dynamicIslandText, forKey: "dynamicIslandText")
        try container.encodeIfPresent(self.dynamicIslandCustomIconPath, forKey: "dynamicIslandCustomIconPath")

        try container.encode(self.bypassContentProtection, forKey: "bypassContentProtection")
        try container.encode(self.voiceChangerEnabled, forKey: "voiceChangerEnabled")
        try container.encode(self.voicePitchShift, forKey: "voicePitchShift")
        try container.encode(self.audioEqualizerBassBoost, forKey: "audioEqualizerBassBoost")

        try container.encode(self.liquidGlassEffects, forKey: "liquidGlassEffects")
        try container.encode(self.fallingSnowEffect, forKey: "fallingSnowEffect")
        try container.encode(self.maxAccountsCount, forKey: "maxAccountsCount")
        try container.encode(self.blockChannelSponsoredAds, forKey: "blockChannelSponsoredAds")
        try container.encode(self.stickyAvatarScroll, forKey: "stickyAvatarScroll")

        try container.encode(self.showSecondsInTime, forKey: "showSecondsInTime")
        try container.encode(self.exactViewsCount, forKey: "exactViewsCount")
        try container.encode(self.stripZalgoCharacters, forKey: "stripZalgoCharacters")
        try container.encode(self.translationProvider, forKey: "translationProvider")
        try container.encode(self.targetTranslationLang, forKey: "targetTranslationLang")
    }
}

private let currentExtendedSettingsAtomic = Atomic<ExtendedAppSettings>(value: .defaultSettings)

public extension ExtendedAppSettings {
    static var current: ExtendedAppSettings {
        get {
            return currentExtendedSettingsAtomic.with { $0 }
        }
        set {
            currentExtendedSettingsAtomic.with { $0 = newValue }
        }
    }
}

public func updateExtendedAppSettingsInteractively(accountManager: AccountManager<TelegramAccountManagerTypes>, _ f: @escaping (ExtendedAppSettings) -> ExtendedAppSettings) -> Signal<Void, NoError> {
    return accountManager.transaction { transaction -> Void in
        transaction.updateSharedData(ApplicationSpecificSharedDataKeys.extendedAppSettings, { entry in
            let currentSettings: ExtendedAppSettings
            if let entry = entry?.get(ExtendedAppSettings.self) {
                currentSettings = entry
            } else {
                currentSettings = ExtendedAppSettings.defaultSettings
            }
            let updated = f(currentSettings)
            ExtendedAppSettings.current = updated
            return SharedPreferencesEntry(updated)
        })
    }
}
