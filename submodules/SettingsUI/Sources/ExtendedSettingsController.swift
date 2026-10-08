import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import TelegramUIPreferences
import ItemListUI
import PresentationDataUtils
import AccountContext
import UndoUI

private final class ExtendedSettingsArguments {
    let context: AccountContext
    let updateSettings: (@escaping (ExtendedAppSettings) -> ExtendedAppSettings) -> Void
    let editFakeNumber: () -> Void
    let editDynamicIslandText: () -> Void
    let editFakeStars: () -> Void
    let updateMockNftPurchases: (Bool) -> Void
    let resetSpentStars: () -> Void
    let openFakeGifts: () -> Void
    let restartApp: () -> Void

    init(
        context: AccountContext,
        updateSettings: @escaping (@escaping (ExtendedAppSettings) -> ExtendedAppSettings) -> Void,
        editFakeNumber: @escaping () -> Void,
        editDynamicIslandText: @escaping () -> Void,
        editFakeStars: @escaping () -> Void,
        updateMockNftPurchases: @escaping (Bool) -> Void,
        resetSpentStars: @escaping () -> Void,
        openFakeGifts: @escaping () -> Void,
        restartApp: @escaping () -> Void
    ) {
        self.context = context
        self.updateSettings = updateSettings
        self.editFakeNumber = editFakeNumber
        self.editDynamicIslandText = editDynamicIslandText
        self.editFakeStars = editFakeStars
        self.updateMockNftPurchases = updateMockNftPurchases
        self.resetSpentStars = resetSpentStars
        self.openFakeGifts = openFakeGifts
        self.restartApp = restartApp
    }
}

private enum ExtendedSettingsSection: Int32 {
    case ghostMode
    case fakeNumber
    case fakeGiftsAndStars
    case dynamicIsland
    case mockProfile
    case mediaBypass
    case visualFX
    case systemOptions
}

private enum ExtendedSettingsEntry: ItemListNodeEntry {
    // 1. Ghost Mode
    case ghostHeader
    case ghostMode(Bool)
    case hideTyping(Bool)
    case storiesLocalRead(Bool)
    case silentMessages(Bool)
    case ghostFooter

    // 2. Fake Number (image_0)
    case fakeNumberHeader
    case fakeNumberToggle(Bool)
    case fakeNumberValue(String)
    case fakeNumberFooter

    // 3. Fake Gifts & Stars (image_1, image_2, image_3)
    case fakeGiftsHeader
    case fakeGiftsMenu
    case showDeletedGiftsToggle(Bool)
    case fakeBonusStarsValue(Int64)
    case mockNftPurchasesToggle(Bool)
    case resetSpentStarsAction
    case fakeGiftsFooter

    // 4. Dynamic Island (image_0, image_1, image_2)
    case dynamicIslandHeader
    case dynamicIslandToggle(Bool)
    case dynamicIslandTextValue(String)
    case dynamicIslandFooter

    // 5. Mock Profile Data
    case mockProfileHeader
    case fakePremiumToggle(Bool)
    case fakeBalanceValue(String)
    case mockProfileFooter

    // 6. Media & Content Protection
    case mediaBypassHeader
    case bypassContentProtectionToggle(Bool)
    case antiDeleteToggle(Bool)
    case antiEditToggle(Bool)
    case voiceChangerToggle(Bool)
    case mediaBypassFooter

    // 7. Visual FX & Customization
    case visualFXHeader
    case liquidGlassToggle(Bool)
    case snowEffectToggle(Bool)
    case blockAdsToggle(Bool)
    case stickyAvatarToggle(Bool)
    case visualFXFooter

    // 8. System Options
    case systemHeader
    case exactViewsToggle(Bool)
    case secondsInTimeToggle(Bool)
    case stripZalgoToggle(Bool)
    case restartAppAction
    case systemFooter

    var section: ItemListSectionId {
        switch self {
        case .ghostHeader, .ghostMode, .hideTyping, .storiesLocalRead, .silentMessages, .ghostFooter:
            return ExtendedSettingsSection.ghostMode.rawValue
        case .fakeNumberHeader, .fakeNumberToggle, .fakeNumberValue, .fakeNumberFooter:
            return ExtendedSettingsSection.fakeNumber.rawValue
        case .fakeGiftsHeader, .fakeGiftsMenu, .showDeletedGiftsToggle, .fakeBonusStarsValue, .mockNftPurchasesToggle, .resetSpentStarsAction, .fakeGiftsFooter:
            return ExtendedSettingsSection.fakeGiftsAndStars.rawValue
        case .dynamicIslandHeader, .dynamicIslandToggle, .dynamicIslandTextValue, .dynamicIslandFooter:
            return ExtendedSettingsSection.dynamicIsland.rawValue
        case .mockProfileHeader, .fakePremiumToggle, .fakeBalanceValue, .mockProfileFooter:
            return ExtendedSettingsSection.mockProfile.rawValue
        case .mediaBypassHeader, .bypassContentProtectionToggle, .antiDeleteToggle, .antiEditToggle, .voiceChangerToggle, .mediaBypassFooter:
            return ExtendedSettingsSection.mediaBypass.rawValue
        case .visualFXHeader, .liquidGlassToggle, .snowEffectToggle, .blockAdsToggle, .stickyAvatarToggle, .visualFXFooter:
            return ExtendedSettingsSection.visualFX.rawValue
        case .systemHeader, .exactViewsToggle, .secondsInTimeToggle, .stripZalgoToggle, .restartAppAction, .systemFooter:
            return ExtendedSettingsSection.systemOptions.rawValue
        }
    }

    var stableId: Int32 {
        switch self {
        case .ghostHeader: return 0
        case .ghostMode: return 1
        case .hideTyping: return 2
        case .storiesLocalRead: return 3
        case .silentMessages: return 4
        case .ghostFooter: return 5

        case .fakeNumberHeader: return 6
        case .fakeNumberToggle: return 7
        case .fakeNumberValue: return 8
        case .fakeNumberFooter: return 9

        case .fakeGiftsHeader: return 10
        case .fakeGiftsMenu: return 11
        case .showDeletedGiftsToggle: return 12
        case .fakeBonusStarsValue: return 13
        case .mockNftPurchasesToggle: return 14
        case .resetSpentStarsAction: return 15
        case .fakeGiftsFooter: return 16

        case .dynamicIslandHeader: return 17
        case .dynamicIslandToggle: return 18
        case .dynamicIslandTextValue: return 19
        case .dynamicIslandFooter: return 20

        case .mockProfileHeader: return 21
        case .fakePremiumToggle: return 22
        case .fakeBalanceValue: return 23
        case .mockProfileFooter: return 24

        case .mediaBypassHeader: return 25
        case .bypassContentProtectionToggle: return 26
        case .antiDeleteToggle: return 27
        case .antiEditToggle: return 28
        case .voiceChangerToggle: return 29
        case .mediaBypassFooter: return 30

        case .visualFXHeader: return 31
        case .liquidGlassToggle: return 32
        case .snowEffectToggle: return 33
        case .blockAdsToggle: return 34
        case .stickyAvatarToggle: return 35
        case .visualFXFooter: return 36

        case .systemHeader: return 37
        case .exactViewsToggle: return 38
        case .secondsInTimeToggle: return 39
        case .stripZalgoToggle: return 40
        case .restartAppAction: return 41
        case .systemFooter: return 42
        }
    }

    static func <(lhs: ExtendedSettingsEntry, rhs: ExtendedSettingsEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let args = arguments as! ExtendedSettingsArguments
        switch self {
        // Ghost Mode
        case .ghostHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "РЕЖИМ ПРИЗРАКА", sectionId: self.section)
        case let .ghostMode(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Не читать входящие", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.ghostModeEnabled = updated
                    return current
                }
            }
        case let .hideTyping(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрывать «Печатает...»", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.hideTypingStatus = updated
                    return current
                }
            }
        case let .storiesLocalRead(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Скрытый просмотр историй", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.markStoriesReadLocallyOnly = updated
                    return current
                }
            }
        case let .silentMessages(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Тихие сообщения по умолчанию", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.sendSilentByDefault = updated
                    return current
                }
            }
        case .ghostFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Собеседники не увидят ваш статус прочтения, активность в сети и просмотр историй."), sectionId: self.section)

        // Fake Number
        case .fakeNumberHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ФЕЙКОВЫЙ НОМЕР", sectionId: self.section)
        case let .fakeNumberToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Фейковый номер", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.fakePhoneEnabled = updated
                    return current
                }
            }
        case let .fakeNumberValue(value):
            return ItemListActionItem(presentationData: presentationData, systemStyle: .glass, title: "Номер \(value)", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks) {
                args.editFakeNumber()
            }
        case .fakeNumberFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Номер подменяется в шапке профиля и деталях аккаунта для демонстрационных целей."), sectionId: self.section)

        // Fake Gifts & Stars
        case .fakeGiftsHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ПОДАРКИ, ЗВЁЗДЫ & NFT", sectionId: self.section)
        case .fakeGiftsMenu:
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: "Фейковые подарки", label: "", sectionId: self.section, style: .blocks, disclosureStyle: .arrow) {
                args.openFakeGifts()
            }
        case let .showDeletedGiftsToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Отображать удалённые подарки", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.showDeletedGifts = updated
                    return current
                }
            }
        case let .fakeBonusStarsValue(value):
            return ItemListActionItem(presentationData: presentationData, systemStyle: .glass, title: "Фейковый бонус звёзд: +\(value) ⭐", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks) {
                args.editFakeStars()
            }
        case let .mockNftPurchasesToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Локальные покупки NFT / Подарков", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateMockNftPurchases(updated)
            }
        case .resetSpentStarsAction:
            return ItemListActionItem(presentationData: presentationData, systemStyle: .glass, title: "Восстановить потраченные звёзды", kind: .destructive, alignment: .natural, sectionId: self.section, style: .blocks) {
                args.resetSpentStars()
            }
        case .fakeGiftsFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Баланс звёзд отображает сумму: оригинальные + фейковые. Обычные подарки списывают реальные звёзды с сервера. Коллекционные NFT списывают только фейковые звёзды локально с симуляцией покупки."), sectionId: self.section)

        // Dynamic Island
        case .dynamicIslandHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ОФОРМЛЕНИЕ ВЫРЕЗА (DYNAMIC ISLAND / NOTCH)", sectionId: self.section)
        case let .dynamicIslandToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Оверлей Dynamic Island", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.dynamicIslandEnabled = updated
                    return current
                }
            }
        case let .dynamicIslandTextValue(value):
            return ItemListActionItem(presentationData: presentationData, systemStyle: .glass, title: "Текст островка: \(value)", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks) {
                args.editDynamicIslandText()
            }
        case .dynamicIslandFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Отображает стилизованную капсулу со стикером и кастомным названием поверх статус-бара."), sectionId: self.section)

        // Mock Profile
        case .mockProfileHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ВИЗУАЛЬНЫЕ ДАННЫЕ ПРОФИЛЯ", sectionId: self.section)
        case let .fakePremiumToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Локальный Premium статус", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.fakePremiumBadge = updated
                    return current
                }
            }
        case let .fakeBalanceValue(value):
            return ItemListActionItem(presentationData: presentationData, systemStyle: .glass, title: "Баланс кошелька: \(value)", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks) {}
        case .mockProfileFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Включает звёздочку премиума, GIF-баннеры в шапке и демонстрационный баланс кошелька."), sectionId: self.section)

        // Media & Protection Bypass
        case .mediaBypassHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "МЕДИА И ЗАЩИТА", sectionId: self.section)
        case let .bypassContentProtectionToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Обход защиты контента", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.bypassContentProtection = updated
                    return current
                }
            }
        case let .antiDeleteToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Анти-удаление сообщений", value: value, sectionId: self.section, style: .blocks) { updated in
                UserDefaults.standard.set(updated, forKey: "custom_anti_delete_enabled")
                args.updateSettings { current in
                    var current = current
                    current.antiDeleteEnabled = updated
                    return current
                }
            }
        case let .antiEditToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "История правок сообщений", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.antiEditEnabled = updated
                    return current
                }
            }
        case let .voiceChangerToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Модулятор голоса (Pitch Shift)", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.voiceChangerEnabled = updated
                    return current
                }
            }
        case .mediaBypassFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Удалённые собеседником сообщения остаются в чате. Снимается запрет на скриншоты и скачивание."), sectionId: self.section)

        // Visual FX
        case .visualFXHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ИНТЕРФЕЙС И ЭФФЕКТЫ", sectionId: self.section)
        case let .liquidGlassToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Liquid Glass (Размытие)", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.liquidGlassEffects = updated
                    return current
                }
            }
        case let .snowEffectToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Падающий снег", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.fallingSnowEffect = updated
                    return current
                }
            }
        case let .blockAdsToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Блокировка Telegram Ads", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.blockChannelSponsoredAds = updated
                    return current
                }
            }
        case let .stickyAvatarToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Липкая анимация аватарки", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.stickyAvatarScroll = updated
                    return current
                }
            }
        case .visualFXFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Кастомизация визуального стиля, полупрозрачности панелей и отключение рекламы."), sectionId: self.section)

        // System Options
        case .systemHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "СИСТЕМНЫЕ ОПЦИИ", sectionId: self.section)
        case let .exactViewsToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Точные просмотры постов", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.exactViewsCount = updated
                    return current
                }
            }
        case let .secondsInTimeToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Показывать секунды во времени", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.showSecondsInTime = updated
                    return current
                }
            }
        case let .stripZalgoToggle(value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: "Фильтр Zalgo символов", value: value, sectionId: self.section, style: .blocks) { updated in
                args.updateSettings { current in
                    var current = current
                    current.stripZalgoCharacters = updated
                    return current
                }
            }
        case .restartAppAction:
            return ItemListActionItem(presentationData: presentationData, systemStyle: .glass, title: "Быстрый перезапуск приложения", kind: .destructive, alignment: .natural, sectionId: self.section, style: .blocks) {
                args.restartApp()
            }
        case .systemFooter:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Перезапуск мгновенно применяет изменения темы, эффектов и кешей."), sectionId: self.section)
        }
    }
}

private func extendedSettingsEntries(settings: ExtendedAppSettings) -> [ExtendedSettingsEntry] {
    var entries: [ExtendedSettingsEntry] = []

    // 1. Ghost
    entries.append(.ghostHeader)
    entries.append(.ghostMode(settings.ghostModeEnabled))
    entries.append(.hideTyping(settings.hideTypingStatus))
    entries.append(.storiesLocalRead(settings.markStoriesReadLocallyOnly))
    entries.append(.silentMessages(settings.sendSilentByDefault))
    entries.append(.ghostFooter)

    // 2. Fake Number
    entries.append(.fakeNumberHeader)
    entries.append(.fakeNumberToggle(settings.fakePhoneEnabled))
    entries.append(.fakeNumberValue(settings.fakePhoneNumber))
    entries.append(.fakeNumberFooter)

    // 3. Fake Gifts & Stars
    entries.append(.fakeGiftsHeader)
    entries.append(.fakeGiftsMenu)
    entries.append(.showDeletedGiftsToggle(settings.showDeletedGifts))
    entries.append(.fakeBonusStarsValue(StarsMockManager.shared.fakeBonusStars))
    entries.append(.mockNftPurchasesToggle(StarsMockManager.shared.mockNftPurchasesEnabled))
    entries.append(.resetSpentStarsAction)
    entries.append(.fakeGiftsFooter)

    // 4. Dynamic Island
    entries.append(.dynamicIslandHeader)
    entries.append(.dynamicIslandToggle(settings.dynamicIslandEnabled))
    entries.append(.dynamicIslandTextValue(settings.dynamicIslandText))
    entries.append(.dynamicIslandFooter)

    // 5. Mock Profile
    entries.append(.mockProfileHeader)
    entries.append(.fakePremiumToggle(settings.fakePremiumBadge))
    entries.append(.fakeBalanceValue(settings.fakeBalanceTON ?? "1,337.00 TON"))
    entries.append(.mockProfileFooter)

    // 6. Media Bypass
    entries.append(.mediaBypassHeader)
    entries.append(.bypassContentProtectionToggle(settings.bypassContentProtection))
    entries.append(.antiDeleteToggle(settings.antiDeleteEnabled))
    entries.append(.antiEditToggle(settings.antiEditEnabled))
    entries.append(.voiceChangerToggle(settings.voiceChangerEnabled))
    entries.append(.mediaBypassFooter)

    // 7. Visual FX
    entries.append(.visualFXHeader)
    entries.append(.liquidGlassToggle(settings.liquidGlassEffects))
    entries.append(.snowEffectToggle(settings.fallingSnowEffect))
    entries.append(.blockAdsToggle(settings.blockChannelSponsoredAds))
    entries.append(.stickyAvatarToggle(settings.stickyAvatarScroll))
    entries.append(.visualFXFooter)

    // 8. System Options
    entries.append(.systemHeader)
    entries.append(.exactViewsToggle(settings.exactViewsCount))
    entries.append(.secondsInTimeToggle(settings.showSecondsInTime))
    entries.append(.stripZalgoToggle(settings.stripZalgoCharacters))
    entries.append(.restartAppAction)
    entries.append(.systemFooter)

    return entries
}

public func makeExtendedSettingsController(context: AccountContext) -> ViewController {
    let settingsPromise = Promise<ExtendedAppSettings>()
    let _ = (context.sharedContext.accountManager.sharedData(keys: [ApplicationSpecificSharedDataKeys.extendedAppSettings])
    |> deliverOnMainQueue).startStandalone(next: { sharedData in
        if let current = sharedData.entries[ApplicationSpecificSharedDataKeys.extendedAppSettings]?.get(ExtendedAppSettings.self) {
            settingsPromise.set(.single(current))
        } else {
            settingsPromise.set(.single(.defaultSettings))
        }
    })

    var updateStateImpl: (() -> Void)?

    let arguments = ExtendedSettingsArguments(
        context: context,
        updateSettings: { (update: @escaping (ExtendedAppSettings) -> ExtendedAppSettings) in
            let _ = updateExtendedAppSettingsInteractively(accountManager: context.sharedContext.accountManager, update).startStandalone()
        },
        editFakeNumber: {
            let alert = UIAlertController(title: "Фейковый номер", message: "Введите номер для отображения в профиле", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "+0 или +888 888 3922"
                textField.text = "+0"
            }
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                let newPhone = alert?.textFields?.first?.text ?? "+0"
                let _ = updateExtendedAppSettingsInteractively(accountManager: context.sharedContext.accountManager, { current in
                    var updated = current
                    updated.fakePhoneNumber = newPhone
                    return updated
                }).startStandalone()
            }))
            context.sharedContext.mainWindow?.presentNative(alert)
        },
        editDynamicIslandText: {
            let alert = UIAlertController(title: "Dynamic Island", message: "Введите надпись для островка", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "rosegram"
                textField.text = "rosegram"
            }
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                let newText = alert?.textFields?.first?.text ?? "rosegram"
                let _ = updateExtendedAppSettingsInteractively(accountManager: context.sharedContext.accountManager, { current in
                    var updated = current
                    updated.dynamicIslandText = newText
                    return updated
                }).startStandalone()
            }))
            context.sharedContext.mainWindow?.presentNative(alert)
        },
        editFakeStars: {
            let alert = UIAlertController(title: "Фейковые звёзды", message: "Укажите количество бонусных звёзд (будут прибавлены к вашему реальному балансу)", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.keyboardType = .numberPad
                textField.text = "\(StarsMockManager.shared.fakeBonusStars)"
            }
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                if let text = alert?.textFields?.first?.text, let count = Int64(text) {
                    StarsMockManager.shared.fakeBonusStars = count
                    updateStateImpl?()
                }
            }))
            context.sharedContext.mainWindow?.presentNative(alert)
        },
        updateMockNftPurchases: { enabled in
            StarsMockManager.shared.mockNftPurchasesEnabled = enabled
        },
        resetSpentStars: {
            StarsMockManager.shared.resetSpentStars()
            let alert = UIAlertController(title: "Баланс восстановлен", message: "Потраченные фейковые звёзды сброшены.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            context.sharedContext.mainWindow?.presentNative(alert)
            updateStateImpl?()
        },
        openFakeGifts: {
            let sheet = UIAlertController(title: "Выдать себе NFT подарок", message: "Выберите коллекционный подарок для добавления на витрину профиля:", preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "🐸 Plush Pepe (#1337)", style: .default, handler: { _ in
                FakeGiftsManager.shared.addGift(title: "Plush Pepe", num: 1337, recipientPeerId: 0)
                let confirm = UIAlertController(title: "Успешно!", message: "Plush Pepe #1337 добавлен в ваш профиль.", preferredStyle: .alert)
                confirm.addAction(UIAlertAction(title: "Отлично", style: .default))
                context.sharedContext.mainWindow?.presentNative(confirm)
            }))
            sheet.addAction(UIAlertAction(title: "🧢 Durov's Cap (#777)", style: .default, handler: { _ in
                FakeGiftsManager.shared.addGift(title: "Durov's Cap", num: 777, recipientPeerId: 0)
                let confirm = UIAlertController(title: "Успешно!", message: "Durov's Cap #777 добавлен в ваш профиль.", preferredStyle: .alert)
                confirm.addAction(UIAlertAction(title: "Отлично", style: .default))
                context.sharedContext.mainWindow?.presentNative(confirm)
            }))
            sheet.addAction(UIAlertAction(title: "💎 Heart of Gold (#1)", style: .default, handler: { _ in
                FakeGiftsManager.shared.addGift(title: "Heart of Gold", num: 1, recipientPeerId: 0)
                let confirm = UIAlertController(title: "Успешно!", message: "Heart of Gold #1 добавлен в ваш профиль.", preferredStyle: .alert)
                confirm.addAction(UIAlertAction(title: "Отлично", style: .default))
                context.sharedContext.mainWindow?.presentNative(confirm)
            }))
            sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            context.sharedContext.mainWindow?.presentNative(sheet)
        },
        restartApp: {
            exit(0)
        }
    )

    let updatePromise = ValuePromise<Bool>(true, ignoreRepeated: false)
    updateStateImpl = {
        updatePromise.set(true)
    }

    let signal: Signal<(ItemListControllerState, (ItemListNodeState, Any)), NoError> = combineLatest(queue: .mainQueue(),
        context.sharedContext.presentationData,
        settingsPromise.get(),
        updatePromise.get()
    )
    |> map { presentationData, settings, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let entries = extendedSettingsEntries(settings: settings)
        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Прочее"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back),
            animateChanges: true
        )
        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: entries,
            style: .blocks,
            animateChanges: true
        )
        return (controllerState, (listState, arguments))
    }

    let controller = ItemListController(context: context, state: signal)
    return controller
}
