#Requires AutoHotkey v1.1.33+
#NoEnv
#SingleInstance Force
#InstallKeybdHook
#UseHook
#MenuMaskKey vkE8
SetCapsLockState, AlwaysOff
SendMode Event
SetWorkingDir %A_ScriptDir%

SetLockStateKeysOff() {
    SetCapsLockState, AlwaysOff
}

SetTrayIconPaused(paused) {
    global gTrayIconNormalPath, gTrayIconPausePath
    iconPath := paused ? gTrayIconPausePath : gTrayIconNormalPath
    if FileExist(iconPath)
        Menu, Tray, Icon, %iconPath%,, 1
}

SetTrayPauseMenuChecked(paused) {
    if (paused)
        Menu, Tray, Check, Pause Script
    else
        Menu, Tray, Uncheck, Pause Script
}

SetTraySuspendMenuChecked(suspended) {
    if (suspended)
        Menu, Tray, Check, Suspend Hotkeys
    else
        Menu, Tray, Uncheck, Suspend Hotkeys
}

global gProfile := "os-jis_keyboard-jis_kana-macro"
global gLayerProfile := "os-jis_keyboard-jis"
global gKeyboardProfile := "keyboard-jis"
global gOsLayout := "os-jis"
global gAppName := "TucknHotkey"
global gUseMockImeState := false
global gMockImeState := "off" ; debug helper 用の mock state
global gMockJapaneseInputMode := "none"
global gTrayIconNormalPath := A_ScriptDir . "\TucknHotkey.ico"
global gTrayIconPausePath := A_ScriptDir . "\TucknHotkey_Pause.ico"
SetTrayIconPaused(false)
Menu, Tray, Tip, %A_ScriptName%
Menu, Tray, NoStandard
Menu, Tray, Add, Open, TucknTrayOpen
Menu, Tray, Default, Open
Menu, Tray, Add, Help, TucknTrayHelp
Menu, Tray, Add
Menu, Tray, Add, Window Spy, TucknTrayWindowSpy
Menu, Tray, Add, Reload This Script, TucknTrayReload
Menu, Tray, Add, Edit This Script, TucknTrayEdit
Menu, Tray, Add
Menu, Tray, Add, Suspend Hotkeys, TucknTrayToggleSuspend
Menu, Tray, Add, Pause Script, TucknTrayTogglePause
Menu, Tray, Add, Exit, TucknTrayExit

global gCodeToHotkey := {}
gCodeToHotkey["CapsLock"] := "sc03A"
gCodeToHotkey["Backquote"] := "sc029"
gCodeToHotkey["Backspace"] := "Backspace"
gCodeToHotkey["Tab"] := "Tab"
gCodeToHotkey["Digit1"] := "1"
gCodeToHotkey["Digit2"] := "2"
gCodeToHotkey["Digit3"] := "3"
gCodeToHotkey["Digit4"] := "4"
gCodeToHotkey["Digit5"] := "5"
gCodeToHotkey["Digit6"] := "6"
gCodeToHotkey["Digit7"] := "7"
gCodeToHotkey["Digit8"] := "8"
gCodeToHotkey["Digit9"] := "9"
gCodeToHotkey["Digit0"] := "0"
gCodeToHotkey["Minus"] := "-"
gCodeToHotkey["Equal"] := "sc00D"
gCodeToHotkey["IntlYen"] := "sc07D"
gCodeToHotkey["KeyQ"] := "q"
gCodeToHotkey["KeyW"] := "w"
gCodeToHotkey["KeyE"] := "e"
gCodeToHotkey["KeyR"] := "r"
gCodeToHotkey["KeyT"] := "t"
gCodeToHotkey["KeyY"] := "y"
gCodeToHotkey["KeyU"] := "u"
gCodeToHotkey["KeyI"] := "i"
gCodeToHotkey["KeyO"] := "o"
gCodeToHotkey["KeyP"] := "p"
gCodeToHotkey["BracketLeft"] := "sc01A"
gCodeToHotkey["BracketRight"] := "sc01B"
gCodeToHotkey["KeyA"] := "a"
gCodeToHotkey["KeyS"] := "s"
gCodeToHotkey["KeyD"] := "d"
gCodeToHotkey["KeyF"] := "f"
gCodeToHotkey["KeyG"] := "g"
gCodeToHotkey["KeyH"] := "h"
gCodeToHotkey["KeyJ"] := "j"
gCodeToHotkey["KeyK"] := "k"
gCodeToHotkey["KeyL"] := "l"
gCodeToHotkey["Semicolon"] := ";"
gCodeToHotkey["Quote"] := "sc028"
gCodeToHotkey["Backslash"] := "sc02B"
gCodeToHotkey["Enter"] := "Enter"
gCodeToHotkey["KeyZ"] := "z"
gCodeToHotkey["KeyX"] := "x"
gCodeToHotkey["KeyC"] := "c"
gCodeToHotkey["KeyV"] := "v"
gCodeToHotkey["KeyB"] := "b"
gCodeToHotkey["KeyN"] := "n"
gCodeToHotkey["KeyM"] := "m"
gCodeToHotkey["Comma"] := ","
gCodeToHotkey["Period"] := "."
gCodeToHotkey["Slash"] := "/"
gCodeToHotkey["ShiftLeft"] := "LShift"
gCodeToHotkey["ShiftRight"] := "RShift"
gCodeToHotkey["ControlRight"] := "RCtrl"
gCodeToHotkey["MetaLeft"] := "LWin"
gCodeToHotkey["MetaRight"] := "RWin"
gCodeToHotkey["AltLeft"] := "LAlt"
gCodeToHotkey["AltRight"] := "RAlt"
gCodeToHotkey["IntlRo"] := "sc073"
gCodeToHotkey["NonConvert"] := "sc07B"
gCodeToHotkey["Convert"] := "sc079"
gCodeToHotkey["Space"] := "Space"

global gSendKeys := {}
gSendKeys["CapsLock"] := "{CapsLock}"
gSendKeys["Escape"] := "{Esc}"
gSendKeys["ZenkakuHankaku"] := "{sc029}"
gSendKeys["Home"] := "{Home}"
gSendKeys["PageUp"] := "{PgUp}"
gSendKeys["PageDown"] := "{PgDn}"
gSendKeys["End"] := "{End}"
gSendKeys["ArrowLeft"] := "{Left}"
gSendKeys["ArrowDown"] := "{Down}"
gSendKeys["ArrowUp"] := "{Up}"
gSendKeys["ArrowRight"] := "{Right}"
gSendKeys["Enter"] := "{Enter}"
gSendKeys["Backspace"] := "{BS}"
gSendKeys["Delete"] := "{Del}"
gSendKeys["Tab"] := "{Tab}"
gSendKeys["ContextMenu"] := "{AppsKey}"
gSendKeys["Space"] := "{Space}"
gSendKeys["F1"] := "{F1}"
gSendKeys["F2"] := "{F2}"
gSendKeys["F3"] := "{F3}"
gSendKeys["F4"] := "{F4}"
gSendKeys["F5"] := "{F5}"
gSendKeys["F6"] := "{F6}"
gSendKeys["F7"] := "{F7}"
gSendKeys["F8"] := "{F8}"
gSendKeys["F9"] := "{F9}"
gSendKeys["F10"] := "{F10}"
gSendKeys["F11"] := "{F11}"
gSendKeys["F12"] := "{F12}"

global gSendCodes := {}
gSendCodes["Backquote"] := "{sc029}"
gSendCodes["Backspace"] := "{sc00E}"
gSendCodes["Tab"] := "{sc00F}"
gSendCodes["Digit1"] := "{sc002}"
gSendCodes["Digit2"] := "{sc003}"
gSendCodes["Digit3"] := "{sc004}"
gSendCodes["Digit4"] := "{sc005}"
gSendCodes["Digit5"] := "{sc006}"
gSendCodes["Digit6"] := "{sc007}"
gSendCodes["Digit7"] := "{sc008}"
gSendCodes["Digit8"] := "{sc009}"
gSendCodes["Digit9"] := "{sc00A}"
gSendCodes["Digit0"] := "{sc00B}"
gSendCodes["Minus"] := "{sc00C}"
gSendCodes["Equal"] := "{sc00D}"
gSendCodes["KeyQ"] := "{sc010}"
gSendCodes["KeyW"] := "{sc011}"
gSendCodes["KeyE"] := "{sc012}"
gSendCodes["KeyR"] := "{sc013}"
gSendCodes["KeyT"] := "{sc014}"
gSendCodes["KeyY"] := "{sc015}"
gSendCodes["KeyU"] := "{sc016}"
gSendCodes["KeyI"] := "{sc017}"
gSendCodes["KeyO"] := "{sc018}"
gSendCodes["KeyP"] := "{sc019}"
gSendCodes["BracketLeft"] := "{sc01A}"
gSendCodes["BracketRight"] := "{sc01B}"
gSendCodes["KeyA"] := "{sc01E}"
gSendCodes["KeyS"] := "{sc01F}"
gSendCodes["KeyD"] := "{sc020}"
gSendCodes["KeyF"] := "{sc021}"
gSendCodes["KeyG"] := "{sc022}"
gSendCodes["KeyH"] := "{sc023}"
gSendCodes["KeyJ"] := "{sc024}"
gSendCodes["KeyK"] := "{sc025}"
gSendCodes["KeyL"] := "{sc026}"
gSendCodes["Semicolon"] := "{sc027}"
gSendCodes["Backslash"] := "{sc02B}"
gSendCodes["Enter"] := "{sc01C}"
gSendCodes["CapsLock"] := "{sc03A}"
gSendCodes["IntlYen"] := "{sc07D}"
gSendCodes["IntlRo"] := "{sc073}"
gSendCodes["Quote"] := "{sc028}"
gSendCodes["ShiftLeft"] := "{sc02A}"
gSendCodes["KeyZ"] := "{sc02C}"
gSendCodes["KeyX"] := "{sc02D}"
gSendCodes["KeyC"] := "{sc02E}"
gSendCodes["KeyV"] := "{sc02F}"
gSendCodes["KeyB"] := "{sc030}"
gSendCodes["KeyN"] := "{sc031}"
gSendCodes["KeyM"] := "{sc032}"
gSendCodes["Comma"] := "{sc033}"
gSendCodes["Period"] := "{sc034}"
gSendCodes["Slash"] := "{sc035}"
gSendCodes["ShiftRight"] := "{sc036}"
gSendCodes["Space"] := "{sc039}"
gSendCodes["KanaMode"] := "{sc070}"

global gModPrefix := {}
gModPrefix["Shift"] := "+"
gModPrefix["Control"] := "^"
gModPrefix["Alt"] := "!"
gModPrefix["Win"] := "#"

global gSelectTriggerCode := "NonConvert"
global gNavTriggerCode := "Convert"
global gSelectTriggerHotkey := gCodeToHotkey[gSelectTriggerCode]
global gNavTriggerHotkey := gCodeToHotkey[gNavTriggerCode]
global gLayerTriggerPhysicalHotkeys := {}
global gLayerTriggerSuppressUpSequence := ""
global gActions := {}
gActions["SendEsc"] := {kind: "key", key: "Escape", description: ""}
gActions["SendF1"] := {kind: "key", key: "F1", description: ""}
gActions["SendF2"] := {kind: "key", key: "F2", description: ""}
gActions["SendF3"] := {kind: "key", key: "F3", description: ""}
gActions["SendF4"] := {kind: "key", key: "F4", description: ""}
gActions["SendF5"] := {kind: "key", key: "F5", description: ""}
gActions["SendF6"] := {kind: "key", key: "F6", description: ""}
gActions["SendF7"] := {kind: "key", key: "F7", description: ""}
gActions["SendF8"] := {kind: "key", key: "F8", description: ""}
gActions["SendF9"] := {kind: "key", key: "F9", description: ""}
gActions["SendF10"] := {kind: "key", key: "F10", description: ""}
gActions["SendF11"] := {kind: "key", key: "F11", description: ""}
gActions["SendF12"] := {kind: "key", key: "F12", description: ""}
gActions["SendHalfWidthFullWidth"] := {kind: "key", key: "ZenkakuHankaku", description: "半角/全角キー相当のキーイベントを送信"}
gActions["SendDigit1Code"] := {kind: "code", code: "Digit1", description: ""}
gActions["SendDigit2Code"] := {kind: "code", code: "Digit2", description: ""}
gActions["SendDigit3Code"] := {kind: "code", code: "Digit3", description: ""}
gActions["SendDigit4Code"] := {kind: "code", code: "Digit4", description: ""}
gActions["SendDigit5Code"] := {kind: "code", code: "Digit5", description: ""}
gActions["SendDigit6Code"] := {kind: "code", code: "Digit6", description: ""}
gActions["SendDigit7Code"] := {kind: "code", code: "Digit7", description: ""}
gActions["SendDigit8Code"] := {kind: "code", code: "Digit8", description: ""}
gActions["SendDigit9Code"] := {kind: "code", code: "Digit9", description: ""}
gActions["SendDigit0Code"] := {kind: "code", code: "Digit0", description: ""}
gActions["SendMinusCode"] := {kind: "code", code: "Minus", description: ""}
gActions["SendEqualCode"] := {kind: "code", code: "Equal", description: "ANSI = JIS ^ へ"}
gActions["SendIntlYenCode"] := {kind: "code", code: "IntlYen", description: "JIS配列右上「￥」（Scancode sc07D）のKeycodeを送信。直接入力時は「\ (Backslash)」、かな入力は「ー」が出力される。ANSI配列には存在しないキー"}
gActions["SendBackspace"] := {kind: "key", key: "Backspace", description: ""}
gActions["SendTab"] := {kind: "key", key: "Tab", description: ""}
gActions["SendBracketLeftCode"] := {kind: "code", code: "BracketLeft", description: ""}
gActions["SendBracketRightCode"] := {kind: "code", code: "BracketRight", description: "ANSIなら ] JISなら [ かな入力時は ゜（半濁点）"}
gActions["SendBackslashCode"] := {kind: "code", code: "Backslash", description: "Backslash（Scancode sc02B）。ANSIなら \ JISなら ] かな入力時は む"}
gActions["SendQuoteCode"] := {kind: "code", code: "Quote", description: "ANSIなら ' JISなら : かな入力時は け"}
gActions["SendEnter"] := {kind: "key", key: "Enter", description: ""}
gActions["SendIntlRoCode"] := {kind: "code", code: "IntlRo", description: "JIS配列右下「ろ」（Scancode sc073）のKeycodeを送信。直接入力時は「\ (Backslash)」、かな入力時は「ろ」が出力される。ANSI配列には存在しないキー"}
gActions["SendAppsKey"] := {kind: "key", key: "ContextMenu", description: "コンテキストメニューキーを送信"}
gActions["SendDelete"] := {kind: "key", key: "Delete", description: ""}
gActions["JumpHome"] := {kind: "key", key: "Home", description: ""}
gActions["JumpEnd"] := {kind: "key", key: "End", description: ""}
gActions["PageUpAction"] := {kind: "key", key: "PageUp", description: ""}
gActions["PageDownAction"] := {kind: "key", key: "PageDown", description: ""}
gActions["MoveLeft"] := {kind: "key", key: "ArrowLeft", description: ""}
gActions["MoveDown"] := {kind: "key", key: "ArrowDown", description: ""}
gActions["MoveUp"] := {kind: "key", key: "ArrowUp", description: ""}
gActions["MoveRight"] := {kind: "key", key: "ArrowRight", description: ""}
gActions["SendShiftEsc"] := {kind: "shortcut", mods: ["Shift"], key: "Escape", description: ""}
gActions["SendShiftF1"] := {kind: "shortcut", mods: ["Shift"], key: "F1", description: ""}
gActions["SendShiftF2"] := {kind: "shortcut", mods: ["Shift"], key: "F2", description: ""}
gActions["SendShiftF3"] := {kind: "shortcut", mods: ["Shift"], key: "F3", description: ""}
gActions["SendShiftF4"] := {kind: "shortcut", mods: ["Shift"], key: "F4", description: ""}
gActions["SendShiftF5"] := {kind: "shortcut", mods: ["Shift"], key: "F5", description: ""}
gActions["SendShiftF6"] := {kind: "shortcut", mods: ["Shift"], key: "F6", description: ""}
gActions["SendShiftF7"] := {kind: "shortcut", mods: ["Shift"], key: "F7", description: ""}
gActions["SendShiftF8"] := {kind: "shortcut", mods: ["Shift"], key: "F8", description: ""}
gActions["SendShiftF9"] := {kind: "shortcut", mods: ["Shift"], key: "F9", description: ""}
gActions["SendShiftF10"] := {kind: "shortcut", mods: ["Shift"], key: "F10", description: ""}
gActions["SendShiftF11"] := {kind: "shortcut", mods: ["Shift"], key: "F11", description: ""}
gActions["SendShiftF12"] := {kind: "shortcut", mods: ["Shift"], key: "F12", description: ""}
gActions["SendShiftDigit1Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit1", description: ""}
gActions["SendShiftDigit2Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit2", description: "ANSI @ JIS "" "}
gActions["SendShiftDigit3Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit3", description: "ANSI # JIS # ぁ"}
gActions["SendShiftDigit4Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit4", description: "ANSI $ JIS $ ぅ"}
gActions["SendShiftDigit5Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit5", description: "ANSI % JIS % ぇ"}
gActions["SendShiftDigit6Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit6", description: "ANSI ^ JIS & ぉ"}
gActions["SendShiftDigit7Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit7", description: "ANSI & JIS ' ゃ"}
gActions["SendShiftDigit8Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit8", description: "ANSI * JIS ( ゅ"}
gActions["SendShiftDigit9Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit9", description: "ANSI ( JIS ) ょ"}
gActions["SendShiftDigit0Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit0", description: "ANSI ) JIS を"}
gActions["SendShiftMinusCode"] := {kind: "shortcut", mods: ["Shift"], code: "Minus", description: "ANSI _ JIS ="}
gActions["SendShiftEqualCode"] := {kind: "shortcut", mods: ["Shift"], code: "Equal", description: "ANSI + JIS ~"}
gActions["SendShiftIntlYenCode"] := {kind: "shortcut", mods: ["Shift"], code: "IntlYen", description: "ANSI なし JIS |"}
gActions["SendShiftBackspace"] := {kind: "shortcut", mods: ["Shift"], key: "Backspace", description: ""}
gActions["SendShiftTab"] := {kind: "shortcut", mods: ["Shift"], key: "Tab", description: ""}
gActions["SendShiftKeyQCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyQ", description: ""}
gActions["SendShiftKeyWCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyW", description: ""}
gActions["SendShiftKeyECode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyE", description: ""}
gActions["SendShiftKeyRCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyR", description: ""}
gActions["SendShiftKeyTCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyT", description: ""}
gActions["SendShiftKeyYCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyY", description: ""}
gActions["SendShiftKeyUCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyU", description: ""}
gActions["SendShiftKeyICode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyI", description: ""}
gActions["SendShiftKeyOCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyO", description: ""}
gActions["SendShiftKeyPCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyP", description: ""}
gActions["SendShiftBracketLeftCode"] := {kind: "shortcut", mods: ["Shift"], code: "BracketLeft", description: "ANSI { JIS ` (Backquote) かな入力時は無し"}
gActions["SendShiftBracketRightCode"] := {kind: "shortcut", mods: ["Shift"], code: "BracketRight", description: "ANSI } JIS { 「"}
gActions["SendShiftBackslashCode"] := {kind: "shortcut", mods: ["Shift"], code: "Backslash", description: "ANSI | JIS } 」。JIS配列だと一段下に配置されている。"}
gActions["SendShiftKeyACode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyA", description: ""}
gActions["SendShiftKeySCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyS", description: ""}
gActions["SendShiftKeyDCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyD", description: ""}
gActions["SendShiftKeyFCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyF", description: ""}
gActions["SendShiftKeyGCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyG", description: ""}
gActions["SendShiftKeyHCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyH", description: ""}
gActions["SendShiftKeyJCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyJ", description: ""}
gActions["SendShiftKeyKCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyK", description: ""}
gActions["SendShiftKeyLCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyL", description: ""}
gActions["SendShiftSemicolonCode"] := {kind: "shortcut", mods: ["Shift"], code: "Semicolon", description: "ANSIなら : JISなら + かな入力時は無し"}
gActions["SendShiftQuoteCode"] := {kind: "shortcut", mods: ["Shift"], code: "Quote", description: "ANSIなら "" JISなら * かな入力時は無し"}
gActions["SendShiftEnter"] := {kind: "shortcut", mods: ["Shift"], key: "Enter", description: ""}
gActions["SendShiftKeyZCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyZ", description: ""}
gActions["SendShiftKeyXCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyX", description: ""}
gActions["SendShiftKeyCCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyC", description: ""}
gActions["SendShiftKeyVCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyV", description: ""}
gActions["SendShiftKeyBCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyB", description: ""}
gActions["SendShiftKeyNCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyN", description: ""}
gActions["SendShiftKeyMCode"] := {kind: "shortcut", mods: ["Shift"], code: "KeyM", description: ""}
gActions["SendShiftKeyCommaCode"] := {kind: "shortcut", mods: ["Shift"], code: "Comma", description: ""}
gActions["SendShiftKeyPeriodCode"] := {kind: "shortcut", mods: ["Shift"], code: "Period", description: ""}
gActions["SendShiftKeySlashCode"] := {kind: "shortcut", mods: ["Shift"], code: "Slash", description: ""}
gActions["SendShiftIntlRoCode"] := {kind: "shortcut", mods: ["Shift"], code: "IntlRo", description: "JIS配列右下「ろ」（Scancode sc073）。ANSI配列には存在しないキー。_ を出力。かな入力は無し"}
gActions["SendShiftSpace"] := {kind: "shortcut", mods: ["Shift"], key: "Space", description: ""}
gActions["SendShiftDel"] := {kind: "shortcut", mods: ["Shift"], key: "Delete", description: ""}
gActions["ExtendHome"] := {kind: "shortcut", mods: ["Shift"], key: "Home", description: ""}
gActions["ExtendEnd"] := {kind: "shortcut", mods: ["Shift"], key: "End", description: ""}
gActions["ExtendPageUp"] := {kind: "shortcut", mods: ["Shift"], key: "PageUp", description: ""}
gActions["ExtendPageDown"] := {kind: "shortcut", mods: ["Shift"], key: "PageDown", description: ""}
gActions["ExtendLeft"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowLeft", description: ""}
gActions["ExtendDown"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowDown", description: ""}
gActions["ExtendUp"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowUp", description: ""}
gActions["ExtendRight"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowRight", description: ""}
gActions["SendRomaKana"] := {kind: "shortcut", mods: ["Alt"], code: "KanaMode", description: "Alt+かなキーでローマ字/かな切り替えを送信"}
gActions["SendWinTab"] := {kind: "shortcut", mods: ["Win"], code: "Tab", description: "Windows タスクビューを開く"}
gActions["SendEscAfterImeOff"] := {kind: "special", description: "IME をオフにして Esc を送信する"}
gActions["ReleaseAllModifiers"] := {kind: "special", description: "Ctrl / Shift / Alt / Win をすべて解放"}
gActions["SendLeaderKey"] := {kind: "shortcut", mods: ["Control"], code: "Semicolon", description: "自分専用のLeader keyであるCtrl+;"}
gActions["PasteCurrentDateIso8601ExtendedLocal"] := {kind: "special", description: "ホストOSの現在日付を ISO 8601 拡張形式で貼り付ける"}
gActions["PasteCurrentDateIso8601BasicLocal"] := {kind: "special", description: "ホストOSの現在日付を ISO 8601 基本形式で貼り付ける"}
gActions["PasteCurrentDateTimeIso8601ExtendedLocal"] := {kind: "special", description: "ホストOSの現在時刻を ISO 8601 拡張形式で貼り付ける"}
gActions["PasteCurrentDateTimeIso8601BasicLocal"] := {kind: "special", description: "ホストOSの現在時刻を ISO 8601 基本形式で貼り付ける"}
gActions["PasteClipboardAsPlainText"] := {kind: "special", description: "クリップボードの内容をプレーンテキストとして貼り付ける"}
gActions["RunClipboardTool"] := {kind: "special", description: "ローカル設定で指定したクリップボードツールを起動する"}
gActions["ShowPreviousView"] := {kind: "special", description: "対象アプリごとに前の表示対象へ切り替える"}
gActions["ShowNextView"] := {kind: "special", description: "対象アプリごとに次の表示対象へ切り替える"}
gActions["NoOp"] := {kind: "special", description: "継承を止めるための明示的な no-op"}
gActions["InsertEllipsis"] := {kind: "text", text: "…", description: ""}
gActions["InsertFullWidthTilde"] := {kind: "text", text: "～", description: ""}
gActions["InsertFullWidthExclamation"] := {kind: "text", text: "！", description: ""}
gActions["InsertFullWidthPlus"] := {kind: "text", text: "＋", description: ""}
gActions["InsertFullWidthQuestionMark"] := {kind: "text", text: "？", description: ""}

global gRuleMap := {}
gRuleMap["Base|CapsLock"] := {id: "base.capslock", layer: "Base", code: "CapsLock", action: "SendEsc", note: "CapsLockをEscに置き換える。Capsはロック機能があるが、修飾キーとしてて使わなければ影響なし"}
gRuleMap["Base|Quote"] := {id: "base.jis_colon", layer: "Base", code: "Quote", action: "SendShiftDigit7Code", note: "ANSI配列を再現するため、: を ' に変える"}
gRuleMap["Select|Digit1"] := {id: "select.digit1", layer: "Select", code: "Digit1", action: "SendShiftDigit1Code", note: ""}
gRuleMap["Select|Digit2"] := {id: "select.digit2", layer: "Select", code: "Digit2", action: "SendShiftDigit2Code", note: ""}
gRuleMap["Select|Digit3"] := {id: "select.digit3", layer: "Select", code: "Digit3", action: "SendShiftDigit3Code", note: ""}
gRuleMap["Select|Digit4"] := {id: "select.digit4", layer: "Select", code: "Digit4", action: "SendShiftDigit4Code", note: ""}
gRuleMap["Select|Digit5"] := {id: "select.digit5", layer: "Select", code: "Digit5", action: "SendShiftDigit5Code", note: ""}
gRuleMap["Select|Digit6"] := {id: "select.digit6", layer: "Select", code: "Digit6", action: "SendShiftDigit6Code", note: ""}
gRuleMap["Select|Digit7"] := {id: "select.digit7", layer: "Select", code: "Digit7", action: "SendShiftDigit7Code", note: ""}
gRuleMap["Select|Digit8"] := {id: "select.digit8", layer: "Select", code: "Digit8", action: "SendShiftDigit8Code", note: ""}
gRuleMap["Select|Digit9"] := {id: "select.digit9", layer: "Select", code: "Digit9", action: "SendShiftDigit9Code", note: ""}
gRuleMap["Select|Digit0"] := {id: "select.digit0", layer: "Select", code: "Digit0", action: "SendShiftDigit0Code", note: ""}
gRuleMap["Select|Minus"] := {id: "select.minus", layer: "Select", code: "Minus", action: "SendShiftMinusCode", note: ""}
gRuleMap["Select|Equal"] := {id: "select.jis_caret", layer: "Select", code: "Equal", action: "SendShiftEqualCode", note: ""}
gRuleMap["Select|IntlYen"] := {id: "select.jis_yen_top", layer: "Select", code: "IntlYen", action: "SendShiftIntlYenCode", note: ""}
gRuleMap["Select|Backspace"] := {id: "select.backspace", layer: "Select", code: "Backspace", action: "SendShiftBackspace", note: ""}
gRuleMap["Select|Tab"] := {id: "select.tab", layer: "Select", code: "Tab", action: "SendShiftTab", note: ""}
gRuleMap["Select|KeyQ"] := {id: "select.keyq", layer: "Select", code: "KeyQ", action: "SendShiftKeyQCode", note: ""}
gRuleMap["Select|KeyW"] := {id: "select.keyw", layer: "Select", code: "KeyW", action: "SendShiftKeyWCode", note: ""}
gRuleMap["Select|KeyE"] := {id: "select.keye", layer: "Select", code: "KeyE", action: "SendShiftKeyECode", note: ""}
gRuleMap["Select|KeyR"] := {id: "select.keyr", layer: "Select", code: "KeyR", action: "SendShiftKeyRCode", note: ""}
gRuleMap["Select|KeyT"] := {id: "select.keyt", layer: "Select", code: "KeyT", action: "SendShiftKeyTCode", note: ""}
gRuleMap["Select|KeyY"] := {id: "select.keyy", layer: "Select", code: "KeyY", action: "SendShiftKeyYCode", note: ""}
gRuleMap["Select|KeyU"] := {id: "select.keyu", layer: "Select", code: "KeyU", action: "SendShiftKeyUCode", note: ""}
gRuleMap["Select|KeyI"] := {id: "select.keyi", layer: "Select", code: "KeyI", action: "SendShiftKeyICode", note: ""}
gRuleMap["Select|KeyO"] := {id: "select.keyo", layer: "Select", code: "KeyO", action: "SendShiftKeyOCode", note: ""}
gRuleMap["Select|KeyP"] := {id: "select.keyp", layer: "Select", code: "KeyP", action: "SendShiftKeyPCode", note: ""}
gRuleMap["Select|BracketLeft"] := {id: "select.jis_at", layer: "Select", code: "BracketLeft", action: "SendShiftBracketLeftCode", note: ""}
gRuleMap["Select|BracketRight"] := {id: "select.jis_lbracket", layer: "Select", code: "BracketRight", action: "SendShiftBracketRightCode", note: "Row Bに配置するのでこの配置では使わない想定"}
gRuleMap["Select|CapsLock"] := {id: "select.capslock", layer: "Select", code: "CapsLock", action: "SendShiftEsc", note: ""}
gRuleMap["Select|KeyA"] := {id: "select.keya", layer: "Select", code: "KeyA", action: "SendShiftKeyACode", note: ""}
gRuleMap["Select|KeyS"] := {id: "select.keys", layer: "Select", code: "KeyS", action: "SendShiftKeySCode", note: ""}
gRuleMap["Select|KeyD"] := {id: "select.keyd", layer: "Select", code: "KeyD", action: "SendShiftKeyDCode", note: ""}
gRuleMap["Select|KeyF"] := {id: "select.keyf", layer: "Select", code: "KeyF", action: "SendShiftKeyFCode", note: ""}
gRuleMap["Select|KeyG"] := {id: "select.keyg", layer: "Select", code: "KeyG", action: "SendShiftKeyGCode", note: ""}
gRuleMap["Select|KeyH"] := {id: "select.keyh", layer: "Select", code: "KeyH", action: "SendShiftKeyHCode", note: ""}
gRuleMap["Select|KeyJ"] := {id: "select.keyj", layer: "Select", code: "KeyJ", action: "SendShiftKeyJCode", note: ""}
gRuleMap["Select|KeyK"] := {id: "select.keyk", layer: "Select", code: "KeyK", action: "SendShiftKeyKCode", note: ""}
gRuleMap["Select|KeyL"] := {id: "select.keyl", layer: "Select", code: "KeyL", action: "SendShiftKeyLCode", note: ""}
gRuleMap["Select|Semicolon"] := {id: "select.semicolon", layer: "Select", code: "Semicolon", action: "SendQuoteCode", note: ""}
gRuleMap["Select|Quote"] := {id: "select.jis_colon", layer: "Select", code: "Quote", action: "SendShiftDigit2Code", note: """ を出力するために、Shift+2を割り当てる"}
gRuleMap["Select|Backslash"] := {id: "select.jis_rbracket", layer: "Select", code: "Backslash", action: "SendShiftBackslashCode", note: "Row Bに配置するのでこの配置では使わない想定"}
gRuleMap["Select|Enter"] := {id: "select.enter", layer: "Select", code: "Enter", action: "SendShiftEnter", note: ""}
gRuleMap["Select|KeyZ"] := {id: "select.keyz", layer: "Select", code: "KeyZ", action: "SendShiftKeyZCode", note: ""}
gRuleMap["Select|KeyX"] := {id: "select.keyx", layer: "Select", code: "KeyX", action: "SendShiftKeyXCode", note: ""}
gRuleMap["Select|KeyC"] := {id: "select.keyc", layer: "Select", code: "KeyC", action: "SendShiftKeyCCode", note: ""}
gRuleMap["Select|KeyV"] := {id: "select.keyv", layer: "Select", code: "KeyV", action: "SendShiftKeyVCode", note: ""}
gRuleMap["Select|KeyB"] := {id: "select.keyb", layer: "Select", code: "KeyB", action: "SendShiftKeyBCode", note: ""}
gRuleMap["Select|KeyN"] := {id: "select.keyn", layer: "Select", code: "KeyN", action: "SendShiftKeyNCode", note: ""}
gRuleMap["Select|KeyM"] := {id: "select.keym", layer: "Select", code: "KeyM", action: "SendShiftKeyMCode", note: ""}
gRuleMap["Select|Comma"] := {id: "select.comma", layer: "Select", code: "Comma", action: "SendShiftKeyCommaCode", note: ""}
gRuleMap["Select|Period"] := {id: "select.period", layer: "Select", code: "Period", action: "SendShiftKeyPeriodCode", note: ""}
gRuleMap["Select|Slash"] := {id: "select.slash", layer: "Select", code: "Slash", action: "SendShiftKeySlashCode", note: ""}
gRuleMap["Select|IntlRo"] := {id: "select.jis_yen_bottom", layer: "Select", code: "IntlRo", action: "SendShiftIntlRoCode", note: ""}
gRuleMap["Select|Space"] := {id: "select.space", layer: "Select", code: "Space", action: "SendShiftSpace", note: ""}
gRuleMap["Nav|Digit1"] := {id: "nav.digit1", layer: "Nav", code: "Digit1", action: "SendF1", note: ""}
gRuleMap["Nav|Digit2"] := {id: "nav.digit2", layer: "Nav", code: "Digit2", action: "SendF2", note: ""}
gRuleMap["Nav|Digit3"] := {id: "nav.digit3", layer: "Nav", code: "Digit3", action: "SendF3", note: ""}
gRuleMap["Nav|Digit4"] := {id: "nav.digit4", layer: "Nav", code: "Digit4", action: "SendF4", note: ""}
gRuleMap["Nav|Digit5"] := {id: "nav.digit5", layer: "Nav", code: "Digit5", action: "SendF5", note: ""}
gRuleMap["Nav|Digit6"] := {id: "nav.digit6", layer: "Nav", code: "Digit6", action: "SendF6", note: ""}
gRuleMap["Nav|Digit7"] := {id: "nav.digit7", layer: "Nav", code: "Digit7", action: "SendF7", note: ""}
gRuleMap["Nav|Digit8"] := {id: "nav.digit8", layer: "Nav", code: "Digit8", action: "SendF8", note: ""}
gRuleMap["Nav|Digit9"] := {id: "nav.digit9", layer: "Nav", code: "Digit9", action: "SendF9", note: ""}
gRuleMap["Nav|Digit0"] := {id: "nav.digit0", layer: "Nav", code: "Digit0", action: "SendF10", note: ""}
gRuleMap["Nav|Minus"] := {id: "nav.minus", layer: "Nav", code: "Minus", action: "SendF11", note: ""}
gRuleMap["Nav|Equal"] := {id: "nav.jis_caret", layer: "Nav", code: "Equal", action: "SendF12", note: ""}
gRuleMap["Nav|Tab"] := {id: "nav.tab", layer: "Nav", code: "Tab", action: "NoOp", note: ""}
gRuleMap["Nav|KeyQ"] := {id: "nav.keyq", layer: "Nav", code: "KeyQ", action: "SendDigit1Code", note: ""}
gRuleMap["Nav|KeyW"] := {id: "nav.keyw", layer: "Nav", code: "KeyW", action: "SendDigit2Code", note: ""}
gRuleMap["Nav|KeyE"] := {id: "nav.keye", layer: "Nav", code: "KeyE", action: "SendDigit3Code", note: ""}
gRuleMap["Nav|KeyR"] := {id: "nav.keyr", layer: "Nav", code: "KeyR", action: "SendDigit4Code", note: ""}
gRuleMap["Nav|KeyT"] := {id: "nav.keyt", layer: "Nav", code: "KeyT", action: "SendDigit5Code", note: ""}
gRuleMap["Nav|KeyY"] := {id: "nav.keyy", layer: "Nav", code: "KeyY", action: "SendDigit6Code", note: ""}
gRuleMap["Nav|KeyU"] := {id: "nav.keyu", layer: "Nav", code: "KeyU", action: "SendDigit7Code", note: ""}
gRuleMap["Nav|KeyI"] := {id: "nav.keyi", layer: "Nav", code: "KeyI", action: "SendDigit8Code", note: ""}
gRuleMap["Nav|KeyO"] := {id: "nav.keyo", layer: "Nav", code: "KeyO", action: "SendDigit9Code", note: ""}
gRuleMap["Nav|KeyP"] := {id: "nav.keyp", layer: "Nav", code: "KeyP", action: "SendDigit0Code", note: ""}
gRuleMap["Nav|BracketLeft"] := {id: "nav.jis_at", layer: "Nav", code: "BracketLeft", action: "SendMinusCode", note: ""}
gRuleMap["Nav|BracketRight"] := {id: "nav.jis_lbracket", layer: "Nav", code: "BracketRight", action: "SendEqualCode", note: "タイプコストが高いため使わない想定。Equal は [Nav]+[x] で対応する"}
gRuleMap["Nav|CapsLock"] := {id: "nav.capslock", layer: "Nav", code: "CapsLock", action: "SendEscAfterImeOff", note: ""}
gRuleMap["Nav|KeyA"] := {id: "nav.keya", layer: "Nav", code: "KeyA", action: "SendHalfWidthFullWidth", note: ""}
gRuleMap["Nav|KeyS"] := {id: "nav.keys", layer: "Nav", code: "KeyS", action: "JumpHome", note: ""}
gRuleMap["Nav|KeyD"] := {id: "nav.keyd", layer: "Nav", code: "KeyD", action: "PageUpAction", note: ""}
gRuleMap["Nav|KeyF"] := {id: "nav.keyf", layer: "Nav", code: "KeyF", action: "PageDownAction", note: ""}
gRuleMap["Nav|KeyG"] := {id: "nav.keyg", layer: "Nav", code: "KeyG", action: "JumpEnd", note: ""}
gRuleMap["Nav|KeyH"] := {id: "nav.keyh", layer: "Nav", code: "KeyH", action: "MoveLeft", note: ""}
gRuleMap["Nav|KeyJ"] := {id: "nav.keyj", layer: "Nav", code: "KeyJ", action: "MoveDown", note: ""}
gRuleMap["Nav|KeyK"] := {id: "nav.keyk", layer: "Nav", code: "KeyK", action: "MoveUp", note: ""}
gRuleMap["Nav|KeyL"] := {id: "nav.keyl", layer: "Nav", code: "KeyL", action: "MoveRight", note: ""}
gRuleMap["Nav|Semicolon"] := {id: "nav.semicolon", layer: "Nav", code: "Semicolon", action: "SendEnter", note: ""}
gRuleMap["Nav|Quote"] := {id: "nav.jis_colon", layer: "Nav", code: "Quote", action: "SendShiftBracketLeftCode", note: "quote系に寄せるため ` (Backquote Shift+@) を割り当てる"}
gRuleMap["Nav|Enter"] := {id: "nav.enter", layer: "Nav", code: "Enter", action: "SendWinTab", note: ""}
gRuleMap["Nav|KeyZ"] := {id: "nav.keyz", layer: "Nav", code: "KeyZ", action: "SendShiftMinusCode", note: " = (Equal) かな入力時には へ にしたいのでそれはoverrideで対応"}
gRuleMap["Nav|KeyX"] := {id: "nav.keyx", layer: "Nav", code: "KeyX", action: "SendIntlYenCode", note: "余っているのでBackspaceキーの左にある[￥]を左下の[z]に割り当てるが他のキーで対応しているので不要"}
gRuleMap["Nav|KeyC"] := {id: "nav.keyc", layer: "Nav", code: "KeyC", action: "SendAppsKey", note: ""}
gRuleMap["Nav|KeyV"] := {id: "nav.keyv", layer: "Nav", code: "KeyV", action: "SendDelete", note: ""}
gRuleMap["Nav|KeyB"] := {id: "nav.keyb", layer: "Nav", code: "KeyB", action: "SendTab", note: ""}
gRuleMap["Nav|KeyN"] := {id: "nav.keyn", layer: "Nav", code: "KeyN", action: "SendBackspace", note: ""}
gRuleMap["Nav|KeyM"] := {id: "nav.keym", layer: "Nav", code: "KeyM", action: "NoOp", note: "MacroキーのためNoOp"}
gRuleMap["Nav|Comma"] := {id: "nav.comma", layer: "Nav", code: "Comma", action: "SendBracketRightCode", note: "BkacketRightだがJIS配列では [ ゜が出力される"}
gRuleMap["Nav|Period"] := {id: "nav.period", layer: "Nav", code: "Period", action: "SendBackslashCode", note: "SendBackslashCodeだがJIS配列では ] むが出力される"}
gRuleMap["Nav|Slash"] := {id: "nav.slash", layer: "Nav", code: "Slash", action: "SendIntlRoCode", note: "このキーの右隣にある「\ ろ」をここに寄せる"}
gRuleMap["Nav|IntlRo"] := {id: "nav.jis_yen_bottom", layer: "Nav", code: "IntlRo", action: "NoOp", note: "未割り当て"}
gRuleMap["Nav|Space"] := {id: "nav.space", layer: "Nav", code: "Space", action: "SendLeaderKey", note: ""}
gRuleMap["NavSelect|Digit1"] := {id: "navselect.digit1", layer: "NavSelect", code: "Digit1", action: "SendShiftF1", note: ""}
gRuleMap["NavSelect|Digit2"] := {id: "navselect.digit2", layer: "NavSelect", code: "Digit2", action: "SendShiftF2", note: ""}
gRuleMap["NavSelect|Digit3"] := {id: "navselect.digit3", layer: "NavSelect", code: "Digit3", action: "SendShiftF3", note: ""}
gRuleMap["NavSelect|Digit4"] := {id: "navselect.digit4", layer: "NavSelect", code: "Digit4", action: "SendShiftF4", note: ""}
gRuleMap["NavSelect|Digit5"] := {id: "navselect.digit5", layer: "NavSelect", code: "Digit5", action: "SendShiftF5", note: ""}
gRuleMap["NavSelect|Digit6"] := {id: "navselect.digit6", layer: "NavSelect", code: "Digit6", action: "SendShiftF6", note: ""}
gRuleMap["NavSelect|Digit7"] := {id: "navselect.digit7", layer: "NavSelect", code: "Digit7", action: "SendShiftF7", note: ""}
gRuleMap["NavSelect|Digit8"] := {id: "navselect.digit8", layer: "NavSelect", code: "Digit8", action: "SendShiftF8", note: ""}
gRuleMap["NavSelect|Digit9"] := {id: "navselect.digit9", layer: "NavSelect", code: "Digit9", action: "SendShiftF9", note: ""}
gRuleMap["NavSelect|Digit0"] := {id: "navselect.digit0", layer: "NavSelect", code: "Digit0", action: "SendShiftF10", note: ""}
gRuleMap["NavSelect|Minus"] := {id: "navselect.minus", layer: "NavSelect", code: "Minus", action: "SendShiftF11", note: ""}
gRuleMap["NavSelect|Equal"] := {id: "navselect.jis_caret", layer: "NavSelect", code: "Equal", action: "SendShiftF12", note: ""}
gRuleMap["NavSelect|Tab"] := {id: "navselect.tab", layer: "NavSelect", code: "Tab", action: "NoOp", note: ""}
gRuleMap["NavSelect|KeyQ"] := {id: "navselect.keyq", layer: "NavSelect", code: "KeyQ", action: "SendShiftDigit1Code", note: "!"}
gRuleMap["NavSelect|KeyW"] := {id: "navselect.keyw", layer: "NavSelect", code: "KeyW", action: "SendBracketLeftCode", note: "@"}
gRuleMap["NavSelect|KeyE"] := {id: "navselect.keye", layer: "NavSelect", code: "KeyE", action: "SendShiftDigit3Code", note: "#"}
gRuleMap["NavSelect|KeyR"] := {id: "navselect.keyr", layer: "NavSelect", code: "KeyR", action: "SendShiftDigit4Code", note: "$"}
gRuleMap["NavSelect|KeyT"] := {id: "navselect.keyt", layer: "NavSelect", code: "KeyT", action: "SendShiftDigit5Code", note: "%"}
gRuleMap["NavSelect|KeyY"] := {id: "navselect.keyy", layer: "NavSelect", code: "KeyY", action: "SendEqualCode", note: "^"}
gRuleMap["NavSelect|KeyU"] := {id: "navselect.keyu", layer: "NavSelect", code: "KeyU", action: "SendShiftDigit6Code", note: "&"}
gRuleMap["NavSelect|KeyI"] := {id: "navselect.keyi", layer: "NavSelect", code: "KeyI", action: "SendShiftQuoteCode", note: "*"}
gRuleMap["NavSelect|KeyO"] := {id: "navselect.keyo", layer: "NavSelect", code: "KeyO", action: "SendShiftDigit8Code", note: "("}
gRuleMap["NavSelect|KeyP"] := {id: "navselect.keyp", layer: "NavSelect", code: "KeyP", action: "SendShiftDigit9Code", note: ")"}
gRuleMap["NavSelect|BracketLeft"] := {id: "navselect.jis_at", layer: "NavSelect", code: "BracketLeft", action: "SendShiftIntlRoCode", note: "_"}
gRuleMap["NavSelect|BracketRight"] := {id: "navselect.jis_lbracket", layer: "NavSelect", code: "BracketRight", action: "SendShiftEqualCode", note: ""}
gRuleMap["NavSelect|CapsLock"] := {id: "navselect.capslock", layer: "NavSelect", code: "CapsLock", action: "ReleaseAllModifiers", note: ""}
gRuleMap["NavSelect|KeyA"] := {id: "navselect.keya", layer: "NavSelect", code: "KeyA", action: "SendRomaKana", note: ""}
gRuleMap["NavSelect|KeyS"] := {id: "navselect.keys", layer: "NavSelect", code: "KeyS", action: "ExtendHome", note: ""}
gRuleMap["NavSelect|KeyD"] := {id: "navselect.keyd", layer: "NavSelect", code: "KeyD", action: "ExtendPageUp", note: ""}
gRuleMap["NavSelect|KeyF"] := {id: "navselect.keyf", layer: "NavSelect", code: "KeyF", action: "ExtendPageDown", note: ""}
gRuleMap["NavSelect|KeyG"] := {id: "navselect.keyg", layer: "NavSelect", code: "KeyG", action: "ExtendEnd", note: ""}
gRuleMap["NavSelect|KeyH"] := {id: "navselect.keyh", layer: "NavSelect", code: "KeyH", action: "ExtendLeft", note: ""}
gRuleMap["NavSelect|KeyJ"] := {id: "navselect.keyj", layer: "NavSelect", code: "KeyJ", action: "ExtendDown", note: ""}
gRuleMap["NavSelect|KeyK"] := {id: "navselect.keyk", layer: "NavSelect", code: "KeyK", action: "ExtendUp", note: ""}
gRuleMap["NavSelect|KeyL"] := {id: "navselect.keyl", layer: "NavSelect", code: "KeyL", action: "ExtendRight", note: ""}
gRuleMap["NavSelect|Semicolon"] := {id: "navselect.semicolon", layer: "NavSelect", code: "Semicolon", action: "SendShiftEnter", note: ""}
gRuleMap["NavSelect|Quote"] := {id: "navselect.jis_colon", layer: "NavSelect", code: "Quote", action: "SendShiftEqualCode", note: " ~ (Childa)"}
gRuleMap["NavSelect|KeyZ"] := {id: "navselect.keyz", layer: "NavSelect", code: "KeyZ", action: "SendShiftSemicolonCode", note: " + (Plus)"}
gRuleMap["NavSelect|KeyX"] := {id: "navselect.keyx", layer: "NavSelect", code: "KeyX", action: "SendShiftIntlYenCode", note: " | (Pipeline)"}
gRuleMap["NavSelect|KeyC"] := {id: "navselect.keyc", layer: "NavSelect", code: "KeyC", action: "NoOp", note: ""}
gRuleMap["NavSelect|KeyV"] := {id: "navselect.keyv", layer: "NavSelect", code: "KeyV", action: "SendShiftDel", note: ""}
gRuleMap["NavSelect|KeyB"] := {id: "navselect.keyb", layer: "NavSelect", code: "KeyB", action: "SendShiftTab", note: ""}
gRuleMap["NavSelect|KeyN"] := {id: "navselect.keyn", layer: "NavSelect", code: "KeyN", action: "SendShiftBackspace", note: ""}
gRuleMap["NavSelect|KeyM"] := {id: "navselect.keym", layer: "NavSelect", code: "KeyM", action: "NoOp", note: "MacroキーのためNoOp"}
gRuleMap["NavSelect|Comma"] := {id: "navselect.comma", layer: "NavSelect", code: "Comma", action: "SendShiftBracketRightCode", note: "{"}
gRuleMap["NavSelect|Period"] := {id: "navselect.period", layer: "NavSelect", code: "Period", action: "SendShiftBackslashCode", note: "}"}
gRuleMap["NavSelect|Slash"] := {id: "navselect.slash", layer: "NavSelect", code: "Slash", action: "SendShiftIntlYenCode", note: " | (Pipeline)"}
gRuleMap["NavSelect|IntlRo"] := {id: "navselect.jis_yen_bottom", layer: "NavSelect", code: "IntlRo", action: "NoOp", note: ""}

global gOverrides := []
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.base.jis_colon", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "base.jis_colon", action: "SendQuoteCode", note: "Base では ANSI ライクな single quote を送信するが、JIS のかな入力では Quote 位置の本来のかな刻印 「け」を壊さないため、この条件では literal text ではなく物理 Quote code を送信する。", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.nav.keyz", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "nav.keyz", action: "SendEqualCode", note: "= を割り当てたため、かな入力時の出力が壊れたのを本overrideで修正。「へ」を出す", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyq", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyq", action: "InsertFullWidthExclamation", note: "！（全角の感嘆符）を出力", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyw", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyw", action: "InsertEllipsis", note: "…（三点リーダ）を出力", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyy", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyy", action: "SendShiftDigit6Code", note: "^ を割り当てたため、かな入力時の出力が壊れたのを本overrideで修正。「ぉ」を出す", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyu", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyu", action: "SendShiftDigit7Code", note: "& を割り当てたため、かな入力時の出力が壊れたのを本overrideで修正。「ゃ」を出す", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyi", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyi", action: "SendShiftDigit8Code", note: "* を割り当てたため、かな入力時の出力が壊れたのを本overrideで修正。「ゅ」を出す", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyo", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyo", action: "SendShiftDigit9Code", note: "( を割り当てたため、かな入力時の出力が壊れたのを本overrideで修正。「ょ」を出す", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyp", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyp", action: "SendShiftDigit0Code", note: ") を割り当てたため、かな入力時の出力が壊れたのを本overrideで修正。「を」を出す", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.jis_at", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.jis_at", action: "SendIntlYenCode", note: "[￥ |] sc07D: IntlYen を割り当てる。ローマ字入力 ￥ かな入力 ー を出力", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.jis_colon", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.jis_colon", action: "InsertFullWidthTilde", note: "～（全角の破線）を出力", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyz", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.keyz", action: "InsertFullWidthPlus", note: "＋（全角のプラス）を出力", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})
gOverrides.Push({id: "override-set.os-jis_keyboard-jis_kana:override.navselect.keyslash", override_set: "override-set.os-jis_keyboard-jis_kana", target_layer_profile: "os-jis_keyboard-jis", target_rule_id: "navselect.slash", action: "InsertFullWidthQuestionMark", note: "？（全角の疑問符）を出力", when_ime_state: "on", when_japanese_input_mode: "any", when_os_layout: "os-jis", when_app: "any"})

global gChordBindings := []
gChordBindings.Push({id: "macroselect.keyd", chord_set: "chord-set.keyboard-jis_macro", context: "MacroSelect", code: "KeyD", action: "PasteCurrentDateIso8601ExtendedLocal", note: "ISO 8601 拡張形式の日付文字列を返す（現在日付） 例: 2025-12-17", specificity: 3, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "trigger_role", trigger_role: "Select"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macroselect.keyf", chord_set: "chord-set.keyboard-jis_macro", context: "MacroSelect", code: "KeyF", action: "PasteCurrentDateTimeIso8601ExtendedLocal", note: "ISO 8601 拡張形式文字列を返す（現在時刻） 例: 2025-12-17T06:50:49+09:00", specificity: 3, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "trigger_role", trigger_role: "Select"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macro.keyd", chord_set: "chord-set.keyboard-jis_macro", context: "Macro", code: "KeyD", action: "PasteCurrentDateIso8601BasicLocal", note: "ISO 8601 基本形式の日付文字列を返す（現在日付） 例: 20251217", specificity: 2, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macro.keyf", chord_set: "chord-set.keyboard-jis_macro", context: "Macro", code: "KeyF", action: "PasteCurrentDateTimeIso8601BasicLocal", note: "ISO 8601 基本形式文字列を返す（現在時刻） 例: 20251217T065049+0900", specificity: 2, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macro.keyh", chord_set: "chord-set.keyboard-jis_macro", context: "Macro", code: "KeyH", action: "ShowPreviousView", note: "対象アプリごとに前の表示対象へ切り替える。ブラウザは前のタブ", specificity: 2, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macro.keyl", chord_set: "chord-set.keyboard-jis_macro", context: "Macro", code: "KeyL", action: "ShowNextView", note: "対象アプリごとに次の表示対象へ切り替える。ブラウザは次のタブ", specificity: 2, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macro.keyc", chord_set: "chord-set.keyboard-jis_macro", context: "Macro", code: "KeyC", action: "RunClipboardTool", note: "ローカル設定で指定したクリップボードツールを起動する", specificity: 2, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "code", code: "KeyM"}]})
gChordBindings.Push({id: "macro.keyv", chord_set: "chord-set.keyboard-jis_macro", context: "Macro", code: "KeyV", action: "PasteClipboardAsPlainText", note: "クリップボードの内容をプレーンテキストとして貼り付ける", specificity: 2, requirements: [{kind: "trigger_role", trigger_role: "Nav"}, {kind: "code", code: "KeyM"}]})

InitImeIndicator()

; ------------------------------
; Generated modifier remaps
; ------------------------------
RAlt::RCtrl

global gAssociatedMouseComboTriggerHotkeys := {}
gAssociatedMouseComboTriggerHotkeys["KeyW"] := ["F10"]
gAssociatedMouseComboTriggerHotkeys["KeyE"] := ["F10"]
gAssociatedMouseComboTriggerHotkeys["KeyR"] := ["F10"]
gAssociatedMouseComboTriggerHotkeys["KeyT"] := ["F10"]
gAssociatedMouseComboTriggerHotkeys["KeyS"] := ["F10", "F12"]
gAssociatedMouseComboTriggerHotkeys["KeyD"] := ["F10"]
gAssociatedMouseComboTriggerHotkeys["KeyF"] := ["F10"]
gAssociatedMouseComboTriggerHotkeys["Enter"] := ["F10", "F12"]
gAssociatedMouseComboTriggerHotkeys["KeyX"] := ["F10", "F12"]
gAssociatedMouseComboTriggerHotkeys["KeyV"] := ["F10", "F12"]
gAssociatedMouseComboTriggerHotkeys["KeyC"] := ["F10", "F12"]
gAssociatedMouseComboTriggerHotkeys["KeyZ"] := ["F12"]

IsAssociatedMouseComboTriggerDown(code) {
    global gAssociatedMouseComboTriggerHotkeys
    if !IsObject(gAssociatedMouseComboTriggerHotkeys)
        return false
    if !gAssociatedMouseComboTriggerHotkeys.HasKey(code)
        return false
    for index, triggerHotkey in gAssociatedMouseComboTriggerHotkeys[code] {
        if GetKeyState(triggerHotkey, "P")
            return true
    }
    return false
}

; ------------------------------
; Associated mouse combo pass-through hotkeys
; ------------------------------
#If IsAssociatedMouseComboTriggerDown("KeyW")
~*w::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyE")
~*e::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyR")
~*r::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyT")
~*t::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyS")
~*s::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyD")
~*d::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyF")
~*f::
return
#If

#If IsAssociatedMouseComboTriggerDown("Enter")
~*Enter::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyX")
~*x::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyV")
~*v::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyC")
~*c::
return
#If

#If IsAssociatedMouseComboTriggerDown("KeyZ")
~*z::
return
#If

return

; ------------------------------
; Generated tray menu
; ------------------------------
TucknTrayOpen:
    ListLines
return

TucknTrayHelp:
    SplitPath, A_AhkPath,, ahkDir
    helpPath := ahkDir . "\AutoHotkey.chm"
    if FileExist(helpPath)
        Run, %helpPath%
return

TucknTrayWindowSpy:
    SplitPath, A_AhkPath,, ahkDir
    windowSpyPath := ahkDir . "\WindowSpy.ahk"
    windowSpyExePath := ahkDir . "\WindowSpy.exe"
    if FileExist(windowSpyPath)
        Run, % """" . A_AhkPath . """ """ . windowSpyPath . """"
    else if FileExist(windowSpyExePath)
        Run, %windowSpyExePath%
return

TucknTrayReload:
    Reload
return

TucknTrayEdit:
    Edit
return

TucknTrayToggleSuspend:
    Suspend, Toggle
    HideImeIndicator()
    SetTraySuspendMenuChecked(A_IsSuspended)
    SetTrayIconPaused(A_IsPaused || A_IsSuspended)
return

TucknTrayTogglePause:
    if (A_IsPaused) {
        Pause, Off
        SetTrayPauseMenuChecked(false)
        SetTrayIconPaused(A_IsSuspended)
    } else {
        SetTrayIconPaused(true)
        SetTrayPauseMenuChecked(true)
        HideImeIndicator()
        Pause, On
    }
return

TucknTrayExit:
    ExitApp
return

; ------------------------------
; Generated hotkeys
; ------------------------------
*sc03A::
    if HandlePhysicalShiftCapsLock()
        return
    if ShouldIgnoreRepeatedLockHotkey()
        return
    HandleWildcard("CapsLock")
return

*sc028::
    HandleWildcard("Quote")
return

*1::
    HandleWildcard("Digit1")
return

*2::
    HandleWildcard("Digit2")
return

*3::
    HandleWildcard("Digit3")
return

*4::
    HandleWildcard("Digit4")
return

*5::
    HandleWildcard("Digit5")
return

*6::
    HandleWildcard("Digit6")
return

*7::
    HandleWildcard("Digit7")
return

*8::
    HandleWildcard("Digit8")
return

*9::
    HandleWildcard("Digit9")
return

*0::
    HandleWildcard("Digit0")
return

*-::
    HandleWildcard("Minus")
return

*sc00D::
    HandleWildcard("Equal")
return

*sc07D::
    HandleWildcard("IntlYen")
return

*Backspace::
    HandleWildcard("Backspace")
return

*Tab::
    HandleWildcard("Tab")
return

*q::
    HandleWildcard("KeyQ")
return

*w::
    HandleWildcard("KeyW")
return

*e::
    HandleWildcard("KeyE")
return

*r::
    HandleWildcard("KeyR")
return

*t::
    HandleWildcard("KeyT")
return

*y::
    HandleWildcard("KeyY")
return

*u::
    HandleWildcard("KeyU")
return

*i::
    HandleWildcard("KeyI")
return

*o::
    HandleWildcard("KeyO")
return

*p::
    HandleWildcard("KeyP")
return

*sc01A::
    HandleWildcard("BracketLeft")
return

*sc01B::
    HandleWildcard("BracketRight")
return

*a::
    HandleWildcard("KeyA")
return

*s::
    HandleWildcard("KeyS")
return

*d::
    HandleWildcard("KeyD")
return

*f::
    HandleWildcard("KeyF")
return

*g::
    HandleWildcard("KeyG")
return

*h::
    HandleWildcard("KeyH")
return

*j::
    HandleWildcard("KeyJ")
return

*k::
    HandleWildcard("KeyK")
return

*l::
    HandleWildcard("KeyL")
return

*`;::
    HandleWildcard("Semicolon")
return

*sc02B::
    HandleWildcard("Backslash")
return

*Enter::
    HandleWildcard("Enter")
return

*z::
    HandleWildcard("KeyZ")
return

*x::
    HandleWildcard("KeyX")
return

*c::
    HandleWildcard("KeyC")
return

*v::
    HandleWildcard("KeyV")
return

*b::
    HandleWildcard("KeyB")
return

*n::
    HandleWildcard("KeyN")
return

*m::
    HandleWildcard("KeyM")
return

*,::
    HandleWildcard("Comma")
return

*.::
    HandleWildcard("Period")
return

*/::
    HandleWildcard("Slash")
return

*sc073::
    HandleWildcard("IntlRo")
return

*Space::
    HandleWildcard("Space")
return

sc079::
return

sc07B::
return

sc079 & 1::
    if IsSelectTriggerDown()
        Dispatch("Digit1", "NavSelect")
    else
        Dispatch("Digit1", "Nav")
return
sc079 & 2::
    if IsSelectTriggerDown()
        Dispatch("Digit2", "NavSelect")
    else
        Dispatch("Digit2", "Nav")
return
sc079 & 3::
    if IsSelectTriggerDown()
        Dispatch("Digit3", "NavSelect")
    else
        Dispatch("Digit3", "Nav")
return
sc079 & 4::
    if IsSelectTriggerDown()
        Dispatch("Digit4", "NavSelect")
    else
        Dispatch("Digit4", "Nav")
return
sc079 & 5::
    if IsSelectTriggerDown()
        Dispatch("Digit5", "NavSelect")
    else
        Dispatch("Digit5", "Nav")
return
sc079 & 6::
    if IsSelectTriggerDown()
        Dispatch("Digit6", "NavSelect")
    else
        Dispatch("Digit6", "Nav")
return
sc079 & 7::
    if IsSelectTriggerDown()
        Dispatch("Digit7", "NavSelect")
    else
        Dispatch("Digit7", "Nav")
return
sc079 & 8::
    if IsSelectTriggerDown()
        Dispatch("Digit8", "NavSelect")
    else
        Dispatch("Digit8", "Nav")
return
sc079 & 9::
    if IsSelectTriggerDown()
        Dispatch("Digit9", "NavSelect")
    else
        Dispatch("Digit9", "Nav")
return
sc079 & 0::
    if IsSelectTriggerDown()
        Dispatch("Digit0", "NavSelect")
    else
        Dispatch("Digit0", "Nav")
return
sc079 & -::
    if IsSelectTriggerDown()
        Dispatch("Minus", "NavSelect")
    else
        Dispatch("Minus", "Nav")
return
sc079 & sc00D::
    if IsSelectTriggerDown()
        Dispatch("Equal", "NavSelect")
    else
        Dispatch("Equal", "Nav")
return
sc079 & Tab::
    if IsSelectTriggerDown()
        Dispatch("Tab", "NavSelect")
    else
        Dispatch("Tab", "Nav")
return
sc079 & q::
    if IsSelectTriggerDown()
        Dispatch("KeyQ", "NavSelect")
    else
        Dispatch("KeyQ", "Nav")
return
sc079 & w::
    if IsSelectTriggerDown()
        Dispatch("KeyW", "NavSelect")
    else
        Dispatch("KeyW", "Nav")
return
sc079 & e::
    if IsSelectTriggerDown()
        Dispatch("KeyE", "NavSelect")
    else
        Dispatch("KeyE", "Nav")
return
sc079 & r::
    if IsSelectTriggerDown()
        Dispatch("KeyR", "NavSelect")
    else
        Dispatch("KeyR", "Nav")
return
sc079 & t::
    if IsSelectTriggerDown()
        Dispatch("KeyT", "NavSelect")
    else
        Dispatch("KeyT", "Nav")
return
sc079 & y::
    if IsSelectTriggerDown()
        Dispatch("KeyY", "NavSelect")
    else
        Dispatch("KeyY", "Nav")
return
sc079 & u::
    if IsSelectTriggerDown()
        Dispatch("KeyU", "NavSelect")
    else
        Dispatch("KeyU", "Nav")
return
sc079 & i::
    if IsSelectTriggerDown()
        Dispatch("KeyI", "NavSelect")
    else
        Dispatch("KeyI", "Nav")
return
sc079 & o::
    if IsSelectTriggerDown()
        Dispatch("KeyO", "NavSelect")
    else
        Dispatch("KeyO", "Nav")
return
sc079 & p::
    if IsSelectTriggerDown()
        Dispatch("KeyP", "NavSelect")
    else
        Dispatch("KeyP", "Nav")
return
sc079 & sc01A::
    if IsSelectTriggerDown()
        Dispatch("BracketLeft", "NavSelect")
    else
        Dispatch("BracketLeft", "Nav")
return
sc079 & sc01B::
    if IsSelectTriggerDown()
        Dispatch("BracketRight", "NavSelect")
    else
        Dispatch("BracketRight", "Nav")
return
sc079 & sc03A::
    if ShouldIgnoreRepeatedLockHotkey()
        return
    if IsSelectTriggerDown()
        Dispatch("CapsLock", "NavSelect")
    else
        Dispatch("CapsLock", "Nav")
return
sc079 & a::
    if IsSelectTriggerDown()
        Dispatch("KeyA", "NavSelect")
    else
        Dispatch("KeyA", "Nav")
return
sc079 & s::
    if IsSelectTriggerDown()
        Dispatch("KeyS", "NavSelect")
    else
        Dispatch("KeyS", "Nav")
return
sc079 & d::
    if IsSelectTriggerDown()
        Dispatch("KeyD", "NavSelect")
    else
        Dispatch("KeyD", "Nav")
return
sc079 & f::
    if IsSelectTriggerDown()
        Dispatch("KeyF", "NavSelect")
    else
        Dispatch("KeyF", "Nav")
return
sc079 & g::
    if IsSelectTriggerDown()
        Dispatch("KeyG", "NavSelect")
    else
        Dispatch("KeyG", "Nav")
return
sc079 & h::
    if IsSelectTriggerDown()
        Dispatch("KeyH", "NavSelect")
    else
        Dispatch("KeyH", "Nav")
return
sc079 & j::
    if IsSelectTriggerDown()
        Dispatch("KeyJ", "NavSelect")
    else
        Dispatch("KeyJ", "Nav")
return
sc079 & k::
    if IsSelectTriggerDown()
        Dispatch("KeyK", "NavSelect")
    else
        Dispatch("KeyK", "Nav")
return
sc079 & l::
    if IsSelectTriggerDown()
        Dispatch("KeyL", "NavSelect")
    else
        Dispatch("KeyL", "Nav")
return
sc079 & `;::
    if IsSelectTriggerDown()
        Dispatch("Semicolon", "NavSelect")
    else
        Dispatch("Semicolon", "Nav")
return
sc079 & sc028::
    if IsSelectTriggerDown()
        Dispatch("Quote", "NavSelect")
    else
        Dispatch("Quote", "Nav")
return
sc079 & Enter::
    if IsSelectTriggerDown()
        Dispatch("Enter", "NavSelect")
    else
        Dispatch("Enter", "Nav")
return
sc079 & z::
    if IsSelectTriggerDown()
        Dispatch("KeyZ", "NavSelect")
    else
        Dispatch("KeyZ", "Nav")
return
sc079 & x::
    if IsSelectTriggerDown()
        Dispatch("KeyX", "NavSelect")
    else
        Dispatch("KeyX", "Nav")
return
sc079 & c::
    if IsSelectTriggerDown()
        Dispatch("KeyC", "NavSelect")
    else
        Dispatch("KeyC", "Nav")
return
sc079 & v::
    if IsSelectTriggerDown()
        Dispatch("KeyV", "NavSelect")
    else
        Dispatch("KeyV", "Nav")
return
sc079 & b::
    if IsSelectTriggerDown()
        Dispatch("KeyB", "NavSelect")
    else
        Dispatch("KeyB", "Nav")
return
sc079 & n::
    if IsSelectTriggerDown()
        Dispatch("KeyN", "NavSelect")
    else
        Dispatch("KeyN", "Nav")
return
sc079 & m::
    if IsSelectTriggerDown()
        Dispatch("KeyM", "NavSelect")
    else
        Dispatch("KeyM", "Nav")
return
sc079 & ,::
    if IsSelectTriggerDown()
        Dispatch("Comma", "NavSelect")
    else
        Dispatch("Comma", "Nav")
return
sc079 & .::
    if IsSelectTriggerDown()
        Dispatch("Period", "NavSelect")
    else
        Dispatch("Period", "Nav")
return
sc079 & /::
    if IsSelectTriggerDown()
        Dispatch("Slash", "NavSelect")
    else
        Dispatch("Slash", "Nav")
return
sc079 & sc073::
    if IsSelectTriggerDown()
        Dispatch("IntlRo", "NavSelect")
    else
        Dispatch("IntlRo", "Nav")
return
sc079 & Space::
    if IsSelectTriggerDown()
        Dispatch("Space", "NavSelect")
    else
        Dispatch("Space", "Nav")
return

sc07B & 1::
    if IsNavTriggerDown()
        Dispatch("Digit1", "NavSelect")
    else
        Dispatch("Digit1", "Select")
return

sc07B & 2::
    if IsNavTriggerDown()
        Dispatch("Digit2", "NavSelect")
    else
        Dispatch("Digit2", "Select")
return

sc07B & 3::
    if IsNavTriggerDown()
        Dispatch("Digit3", "NavSelect")
    else
        Dispatch("Digit3", "Select")
return

sc07B & 4::
    if IsNavTriggerDown()
        Dispatch("Digit4", "NavSelect")
    else
        Dispatch("Digit4", "Select")
return

sc07B & 5::
    if IsNavTriggerDown()
        Dispatch("Digit5", "NavSelect")
    else
        Dispatch("Digit5", "Select")
return

sc07B & 6::
    if IsNavTriggerDown()
        Dispatch("Digit6", "NavSelect")
    else
        Dispatch("Digit6", "Select")
return

sc07B & 7::
    if IsNavTriggerDown()
        Dispatch("Digit7", "NavSelect")
    else
        Dispatch("Digit7", "Select")
return

sc07B & 8::
    if IsNavTriggerDown()
        Dispatch("Digit8", "NavSelect")
    else
        Dispatch("Digit8", "Select")
return

sc07B & 9::
    if IsNavTriggerDown()
        Dispatch("Digit9", "NavSelect")
    else
        Dispatch("Digit9", "Select")
return

sc07B & 0::
    if IsNavTriggerDown()
        Dispatch("Digit0", "NavSelect")
    else
        Dispatch("Digit0", "Select")
return

sc07B & -::
    if IsNavTriggerDown()
        Dispatch("Minus", "NavSelect")
    else
        Dispatch("Minus", "Select")
return

sc07B & sc00D::
    if IsNavTriggerDown()
        Dispatch("Equal", "NavSelect")
    else
        Dispatch("Equal", "Select")
return

sc07B & sc07D::
    if IsNavTriggerDown()
        Dispatch("IntlYen", "NavSelect")
    else
        Dispatch("IntlYen", "Select")
return

sc07B & Backspace::
    if IsNavTriggerDown()
        Dispatch("Backspace", "NavSelect")
    else
        Dispatch("Backspace", "Select")
return

sc07B & Tab::
    if IsNavTriggerDown()
        Dispatch("Tab", "NavSelect")
    else
        Dispatch("Tab", "Select")
return

sc07B & q::
    if IsNavTriggerDown()
        Dispatch("KeyQ", "NavSelect")
    else
        Dispatch("KeyQ", "Select")
return

sc07B & w::
    if IsNavTriggerDown()
        Dispatch("KeyW", "NavSelect")
    else
        Dispatch("KeyW", "Select")
return

sc07B & e::
    if IsNavTriggerDown()
        Dispatch("KeyE", "NavSelect")
    else
        Dispatch("KeyE", "Select")
return

sc07B & r::
    if IsNavTriggerDown()
        Dispatch("KeyR", "NavSelect")
    else
        Dispatch("KeyR", "Select")
return

sc07B & t::
    if IsNavTriggerDown()
        Dispatch("KeyT", "NavSelect")
    else
        Dispatch("KeyT", "Select")
return

sc07B & y::
    if IsNavTriggerDown()
        Dispatch("KeyY", "NavSelect")
    else
        Dispatch("KeyY", "Select")
return

sc07B & u::
    if IsNavTriggerDown()
        Dispatch("KeyU", "NavSelect")
    else
        Dispatch("KeyU", "Select")
return

sc07B & i::
    if IsNavTriggerDown()
        Dispatch("KeyI", "NavSelect")
    else
        Dispatch("KeyI", "Select")
return

sc07B & o::
    if IsNavTriggerDown()
        Dispatch("KeyO", "NavSelect")
    else
        Dispatch("KeyO", "Select")
return

sc07B & p::
    if IsNavTriggerDown()
        Dispatch("KeyP", "NavSelect")
    else
        Dispatch("KeyP", "Select")
return

sc07B & sc01A::
    if IsNavTriggerDown()
        Dispatch("BracketLeft", "NavSelect")
    else
        Dispatch("BracketLeft", "Select")
return

sc07B & sc01B::
    if IsNavTriggerDown()
        Dispatch("BracketRight", "NavSelect")
    else
        Dispatch("BracketRight", "Select")
return

sc07B & sc03A::
    if ShouldIgnoreRepeatedLockHotkey()
        return
    if IsNavTriggerDown()
        Dispatch("CapsLock", "NavSelect")
    else
        Dispatch("CapsLock", "Select")
return

sc07B & a::
    if IsNavTriggerDown()
        Dispatch("KeyA", "NavSelect")
    else
        Dispatch("KeyA", "Select")
return

sc07B & s::
    if IsNavTriggerDown()
        Dispatch("KeyS", "NavSelect")
    else
        Dispatch("KeyS", "Select")
return

sc07B & d::
    if IsNavTriggerDown()
        Dispatch("KeyD", "NavSelect")
    else
        Dispatch("KeyD", "Select")
return

sc07B & f::
    if IsNavTriggerDown()
        Dispatch("KeyF", "NavSelect")
    else
        Dispatch("KeyF", "Select")
return

sc07B & g::
    if IsNavTriggerDown()
        Dispatch("KeyG", "NavSelect")
    else
        Dispatch("KeyG", "Select")
return

sc07B & h::
    if IsNavTriggerDown()
        Dispatch("KeyH", "NavSelect")
    else
        Dispatch("KeyH", "Select")
return

sc07B & j::
    if IsNavTriggerDown()
        Dispatch("KeyJ", "NavSelect")
    else
        Dispatch("KeyJ", "Select")
return

sc07B & k::
    if IsNavTriggerDown()
        Dispatch("KeyK", "NavSelect")
    else
        Dispatch("KeyK", "Select")
return

sc07B & l::
    if IsNavTriggerDown()
        Dispatch("KeyL", "NavSelect")
    else
        Dispatch("KeyL", "Select")
return

sc07B & `;::
    if IsNavTriggerDown()
        Dispatch("Semicolon", "NavSelect")
    else
        Dispatch("Semicolon", "Select")
return

sc07B & sc028::
    if IsNavTriggerDown()
        Dispatch("Quote", "NavSelect")
    else
        Dispatch("Quote", "Select")
return

sc07B & sc02B::
    if IsNavTriggerDown()
        Dispatch("Backslash", "NavSelect")
    else
        Dispatch("Backslash", "Select")
return

sc07B & Enter::
    if IsNavTriggerDown()
        Dispatch("Enter", "NavSelect")
    else
        Dispatch("Enter", "Select")
return

sc07B & z::
    if IsNavTriggerDown()
        Dispatch("KeyZ", "NavSelect")
    else
        Dispatch("KeyZ", "Select")
return

sc07B & x::
    if IsNavTriggerDown()
        Dispatch("KeyX", "NavSelect")
    else
        Dispatch("KeyX", "Select")
return

sc07B & c::
    if IsNavTriggerDown()
        Dispatch("KeyC", "NavSelect")
    else
        Dispatch("KeyC", "Select")
return

sc07B & v::
    if IsNavTriggerDown()
        Dispatch("KeyV", "NavSelect")
    else
        Dispatch("KeyV", "Select")
return

sc07B & b::
    if IsNavTriggerDown()
        Dispatch("KeyB", "NavSelect")
    else
        Dispatch("KeyB", "Select")
return

sc07B & n::
    if IsNavTriggerDown()
        Dispatch("KeyN", "NavSelect")
    else
        Dispatch("KeyN", "Select")
return

sc07B & m::
    if IsNavTriggerDown()
        Dispatch("KeyM", "NavSelect")
    else
        Dispatch("KeyM", "Select")
return

sc07B & ,::
    if IsNavTriggerDown()
        Dispatch("Comma", "NavSelect")
    else
        Dispatch("Comma", "Select")
return

sc07B & .::
    if IsNavTriggerDown()
        Dispatch("Period", "NavSelect")
    else
        Dispatch("Period", "Select")
return

sc07B & /::
    if IsNavTriggerDown()
        Dispatch("Slash", "NavSelect")
    else
        Dispatch("Slash", "Select")
return

sc07B & sc073::
    if IsNavTriggerDown()
        Dispatch("IntlRo", "NavSelect")
    else
        Dispatch("IntlRo", "Select")
return

sc07B & Space::
    if IsNavTriggerDown()
        Dispatch("Space", "NavSelect")
    else
        Dispatch("Space", "Select")
return

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/Ime.ahk
; --------------------------------------------
GetImeState() {
    global gUseMockImeState, gMockImeState
    if (gUseMockImeState)
        return gMockImeState
    return ImeIsEnabling() ? "on" : "off"
}

GetJapaneseInputMode(imeState) {
    global gMockJapaneseInputMode
    ; Phase 1 では packaged profile 側で kana-oriented override を選択する。
    if (imeState != "on")
        return "none"
    return gMockJapaneseInputMode
}

ImeOff(winTitle := "A") {
    global gUseMockImeState, gMockImeState
    if (gUseMockImeState) {
        gMockImeState := "off"
        return 0
    }
    return ImeSetOpenStatus(0, winTitle)
}

ImeIsEnabling(winTitle := "A") {
    hwnd := GetImeTargetWindowHandle(winTitle)
    if (!hwnd)
        return false

    defaultImeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (!defaultImeWnd)
        return false

    return DllCall("SendMessage"
        , "Ptr", defaultImeWnd
        , "UInt", 0x0283  ; WM_IME_CONTROL
        , "Int", 0x0005   ; IMC_GETOPENSTATUS
        , "Int", 0)
}

ImeSetOpenStatus(setStatus, winTitle := "A") {
    hwnd := GetImeTargetWindowHandle(winTitle)
    if (!hwnd)
        return 0

    defaultImeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (!defaultImeWnd)
        return 0

    return DllCall("SendMessage"
        , "Ptr", defaultImeWnd
        , "UInt", 0x0283  ; WM_IME_CONTROL
        , "Int", 0x0006   ; IMC_SETOPENSTATUS
        , "Int", setStatus)
}

GetImeOpenStatusForWindow(hwnd) {
    if !hwnd
        return -1
    imeWindow := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if !imeWindow
        return -1
    result := 0
    ok := DllCall("SendMessageTimeout", "Ptr", imeWindow, "UInt", 0x0283
        , "Ptr", 0x0005, "Ptr", 0, "UInt", 0x22, "UInt", 25, "PtrP", result, "Ptr")
    return ok ? (result != 0 ? 1 : 0) : -1
}

GetImeTargetWindowHandle(winTitle := "A") {
    ControlGet, hwnd, HWND, , , %winTitle%
    if (hwnd = "")
        WinGet, hwnd, ID, %winTitle%
    if (hwnd = "")
        return 0

    if WinActive(winTitle) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize := 4 + 4 + (ptrSize * 6) + 16, 0)
        NumPut(cbSize, stGTI, 0, "UInt")
        focusedHwnd := DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", &stGTI)
            ? NumGet(stGTI, 8 + ptrSize, "Ptr")
            : 0
        if (focusedHwnd)
            hwnd := focusedHwnd
    }

    return hwnd
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/ImeIndicator.ahk
; --------------------------------------------
InitImeIndicator() {
    global gImeIndicator
    gImeIndicator := {enabled: false, hwnd: 0, visible: false, x: 0, y: 0}
    enabled := Trim(GetLocalConfigValue("ImeIndicator", "enabled", "0"))
    if !RegExMatch(enabled, "i)^(1|true|on|yes)$")
        return

    defaults := GetImeIndicatorDefaults()
    color := Trim(GetLocalConfigValue("ImeIndicator", "color", defaults.color))
    if !RegExMatch(color, "i)^#?([0-9a-f]{6})$", match)
        color := defaults.color
    else
        color := match1
    gImeIndicator.color := color
    ConfigureImeIndicatorGeometry()

    try {
        ; Layered + transparent + no-activate: the marker never consumes clicks or focus.
        Gui, ImeIndicator:New, +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08080020 +Hwndhwnd, TucknHotkey IME indicator
        gImeIndicator.hwnd := hwnd
        Gui, ImeIndicator:Color, %color%
        if !DllCall("SetLayeredWindowAttributes", "Ptr", hwnd, "UInt", 0, "UChar", 255, "UInt", 2)
            throw Exception("Cannot initialize IME indicator")
        SetImeIndicatorShape(hwnd)
        gImeIndicator.enabled := true
        OnExit(Func("StopImeIndicator"))
        timer := Func("UpdateImeIndicator")
        SetTimer, %timer%, 100
    } catch {
        StopImeIndicator()
    }
}

ConfigureImeIndicatorGeometry() {
    global gImeIndicator
    defaults := GetImeIndicatorDefaults()
    shape := Trim(GetLocalConfigValue("ImeIndicator", "shape", ""))
    ; Preserve old underline-only configurations; explicit shape/dimensions opt in to the new defaults.
    legacy := shape = "" && Trim(GetLocalConfigValue("ImeIndicator", "size_px", "")) != ""
        && Trim(GetLocalConfigValue("ImeIndicator", "width_px", "")) = ""
        && Trim(GetLocalConfigValue("ImeIndicator", "height_px", "")) = ""
    if legacy
        shape := "rectangle"
    gImeIndicator.shape := shape = "rectangle" ? "rectangle" : (shape = "ellipse" ? "ellipse" : defaults.shape)
    widthDefault := legacy ? GetImeIndicatorInteger("size_px", 10, 3, 24) : defaults.width_px
    gImeIndicator.width := GetImeIndicatorInteger("width_px", widthDefault, 2, 32)
    gImeIndicator.height := GetImeIndicatorInteger("height_px", legacy ? 2 : defaults.height_px, 2, 32)
    gImeIndicator.offsetX := GetImeIndicatorInteger("offset_x_px", legacy ? 5 : defaults.offset_x_px, -64, 64)
    gImeIndicator.offsetY := GetImeIndicatorInteger("offset_y_px", legacy ? -4 : defaults.offset_y_px, -64, 64)
}

GetImeIndicatorInteger(key, fallback, minimum, maximum) {
    value := Trim(GetLocalConfigValue("ImeIndicator", key, ""))
    if (!RegExMatch(value, "^-?\d+$") || value < minimum || value > maximum)
        return fallback
    return value + 0
}

SetImeIndicatorShape(hwnd) {
    global gImeIndicator
    if (gImeIndicator.shape != "ellipse")
        return
    region := DllCall("gdi32\CreateEllipticRgn", "Int", 0, "Int", 0
        , "Int", gImeIndicator.width, "Int", gImeIndicator.height, "Ptr")
    if !region
        throw Exception("Cannot create IME indicator shape")
    try {
        if !DllCall("SetWindowRgn", "Ptr", hwnd, "Ptr", region, "Int", false)
            throw Exception("Cannot apply IME indicator shape")
        ; SetWindowRgn transfers ownership to Windows, which frees it with the window.
        region := 0
    } finally {
        if region
            DllCall("gdi32\DeleteObject", "Ptr", region)
    }
}

UpdateImeIndicator() {
    global gImeIndicator
    static updating := false
    if (updating || !gImeIndicator.enabled)
        return
    updating := true
    try {
        if (A_IsSuspended || A_IsPaused) {
            HideImeIndicator()
            return
        }
        target := GetImeIndicatorTarget()
        if !IsObject(target) {
            HideImeIndicator()
            return
        }
        ; Unknown/timeout is deliberately not treated as a confirmed IME ON state.
        if (GetImeOpenStatusForWindow(target.focus) != 1 || !IsImeIndicatorTargetCurrent(target)) {
            HideImeIndicator()
            return
        }
        ShowImeIndicator(target.x, target.y, target.height)
    } catch {
        HideImeIndicator()
    } finally {
        updating := false
    }
}

GetImeIndicatorTarget() {
    foreground := DllCall("GetForegroundWindow", "Ptr")
    if !foreground
        return false
    cbSize := 8 + A_PtrSize * 6 + 16
    VarSetCapacity(info, cbSize, 0)
    NumPut(cbSize, info, 0, "UInt")
    if !DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", &info)
        return false
    focus := NumGet(info, 8 + A_PtrSize, "Ptr")
    caretWindow := NumGet(info, 8 + A_PtrSize * 5, "Ptr")
    ; Ignore menus/move-size mode and absent/hidden caret owners, but not the blink phase.
    if (!focus || !caretWindow || (NumGet(info, 4, "UInt") & 0x1E)
        || !DllCall("IsWindowVisible", "Ptr", caretWindow))
        return false

    ; rcCaret is the native caret rectangle, including its current font-dependent height.
    rectOffset := 8 + A_PtrSize * 6
    height := NumGet(info, rectOffset + 12, "Int") - NumGet(info, rectOffset + 4, "Int")
    if (height < 4)
        return false

    previousMode := A_CoordModeCaret
    try {
        CoordMode, Caret, Screen
        x := A_CaretX
        y := A_CaretY
    } finally {
        CoordMode, Caret, %previousMode%
    }
    if (x = "" || y = "")
        return false
    return {foreground: foreground, focus: focus, x: x, y: y, height: height}
}

IsImeIndicatorTargetCurrent(target) {
    global gImeIndicator
    return gImeIndicator.enabled && !A_IsSuspended && !A_IsPaused
        && DllCall("GetForegroundWindow", "Ptr") = target.foreground
        && GetImeTargetWindowHandle() = target.focus
}

ShowImeIndicator(caretX, caretY, caretHeight) {
    global gImeIndicator
    if !gImeIndicator.enabled
        return
    if (caretHeight < 4) {
        HideImeIndicator()
        return
    }
    ; The marker's top-left is relative to the caret's bottom-left (screen pixels).
    x := caretX + gImeIndicator.offsetX
    y := caretY + caretHeight + gImeIndicator.offsetY
    if (gImeIndicator.visible && gImeIndicator.x = x && gImeIndicator.y = y)
        return
    ; Screen coordinates and unscaled pixels; no per-frame A_WinDelay.
    if !DllCall("SetWindowPos", "Ptr", gImeIndicator.hwnd, "Ptr", -1
        , "Int", x, "Int", y, "Int", gImeIndicator.width, "Int", gImeIndicator.height, "UInt", 0x50) {
        HideImeIndicator()
        return
    }
    gImeIndicator.x := x
    gImeIndicator.y := y
    gImeIndicator.visible := true
}

HideImeIndicator() {
    global gImeIndicator
    if !IsObject(gImeIndicator) || !gImeIndicator.hwnd
        return
    Gui, ImeIndicator:Hide
    gImeIndicator.visible := false
}

StopImeIndicator(exitReason := "", exitCode := 0) {
    global gImeIndicator
    timer := Func("UpdateImeIndicator")
    SetTimer, %timer%, Off
    if !IsObject(gImeIndicator)
        return
    gImeIndicator.enabled := false
    HideImeIndicator()
    if gImeIndicator.hwnd
        Gui, ImeIndicator:Destroy
    gImeIndicator.hwnd := 0
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/ActionExecutor.ahk
; --------------------------------------------
GetContext(actionSource := "keyboard") {
    global gProfile, gLayerProfile, gKeyboardProfile, gOsLayout
    WinGet, exe, ProcessName, A
    ctx := {}
    ctx.profile := gProfile
    ctx.layer_profile := gLayerProfile
    ctx.keyboard_profile := gKeyboardProfile
    ctx.os_layout := gOsLayout
    ctx.action_source := actionSource
    ctx.ime_state := GetImeState()
    ctx.japanese_input_mode := GetJapaneseInputMode(ctx.ime_state)
    ctx.app := (exe = "") ? "any" : exe
    return ctx
}

GetCurrentActionContext() {
    global gCurrentActionContext
    return IsObject(gCurrentActionContext) ? gCurrentActionContext : ""
}

OverrideMatches(ov, ctx) {
    if (ov.when_ime_state != "any" && ov.when_ime_state != ctx.ime_state)
        return false
    if (ov.when_japanese_input_mode != "any" && ov.when_japanese_input_mode != ctx.japanese_input_mode)
        return false
    if (ov.when_os_layout != "any" && ov.when_os_layout != ctx.os_layout)
        return false
    if (ov.when_app != "any" && ov.when_app != ctx.app)
        return false
    return true
}

ExecuteAction(actionId, ctx) {
    global gActions, gSendKeys, gSendCodes, gModPrefix, gCurrentActionContext
    if !gActions.HasKey(actionId)
        return
    action := gActions[actionId]
    if (action.kind = "key") {
        SendInput % "{Blind}" . gSendKeys[action.key]
        return
    }
    if (action.kind = "code") {
        SendInput % "{Blind}" . gSendCodes[action.code]
        return
    }
    if (action.kind = "text") {
        SendInput % "{Blind}{Text}" . action.text
        return
    }
    if (action.kind = "shortcut") {
        seq := "{Blind}"
        for index, mod in action.mods
            seq .= gModPrefix[mod]
        if (action.HasKey("key"))
            seq .= gSendKeys[action.key]
        else if (action.HasKey("code"))
            seq .= gSendCodes[action.code]
        else
            return
        SendInput % seq
        ResyncSyntheticShortcutModifiers(action)
        return
    }
    if (action.kind = "special") {
        if !IsFunc(actionId)
            return
        specialAction := Func(actionId)
        savedActionContext := GetCurrentActionContext()
        gCurrentActionContext := ctx
        specialAction.Call()
        gCurrentActionContext := savedActionContext
        return
    }
}

ResyncSyntheticShortcutModifiers(action) {
    if ActionHasModifier(action, "Shift")
        ResyncShiftAfterSyntheticShift()
    if ActionHasModifier(action, "Control")
        ResyncCtrlAfterSyntheticCtrl()
}

ResyncShiftAfterSyntheticShift() {
    if IsPhysicalShiftModifierDown()
        return
    if !IsLogicalShiftModifierDown()
        return
    SendEvent, {LShift down}{LShift up}{RShift down}{RShift up}
    SendInput {Shift up}{LShift up}{RShift up}
}

ResyncCtrlAfterSyntheticCtrl() {
    if IsPhysicalCtrlModifierDown()
        return
    if !IsLogicalCtrlModifierDown()
        return
    SendEvent, {RCtrl down}{RCtrl up}{LCtrl down}{LCtrl up}
    SendInput {Ctrl up}{LCtrl up}{RCtrl up}
}

ActionHasModifier(action, modifier) {
    if !action.HasKey("mods")
        return false
    for index, mod in action.mods {
        if (mod = modifier)
            return true
    }
    return false
}

IsPhysicalShiftModifierDown() {
    return GetKeyState("LShift", "P") || GetKeyState("RShift", "P")
}

IsPhysicalCtrlModifierDown() {
    return GetKeyState("LCtrl", "P") || GetKeyState("RCtrl", "P")
}

IsLogicalShiftModifierDown() {
    return GetKeyState("Shift")
}

IsLogicalCtrlModifierDown() {
    return GetKeyState("Ctrl")
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/Dispatcher.ahk
; --------------------------------------------
HandleWildcard(code) {
    requestedLayer := GetRequestedLayer()
    if (requestedLayer != "Base")
        SuppressLayerAltTriggers()
    Dispatch(code, requestedLayer)
}

HandlePhysicalShiftCapsLock() {
    if !IsPhysicalShiftDown()
        return false
    if IsAnyLayerTriggerDown()
        return false
    if ShouldIgnoreRepeatedLockHotkey()
        return true
    if GetKeyState("CapsLock", "T")
        SetCapsLockState, AlwaysOff
    else
        SetCapsLockState, On
    return true
}

IsPhysicalShiftDown() {
    return GetKeyState("LShift", "P") || GetKeyState("RShift", "P")
}

SuppressLayerAltTriggers() {
    global gLayerTriggerSuppressUpSequence
    if (gLayerTriggerSuppressUpSequence = "")
        return
    SendInput % "{Blind}" . gLayerTriggerSuppressUpSequence
}

IsNavTriggerDown() {
    global gNavTriggerHotkey
    return IsLayerTriggerHotkeyDown("Nav", gNavTriggerHotkey)
}

IsSelectTriggerDown() {
    global gSelectTriggerHotkey
    return IsLayerTriggerHotkeyDown("Select", gSelectTriggerHotkey)
}

IsLayerTriggerHotkeyDown(triggerRole, fallbackHotkey) {
    global gLayerTriggerPhysicalHotkeys
    if IsObject(gLayerTriggerPhysicalHotkeys) && gLayerTriggerPhysicalHotkeys.HasKey(triggerRole)
        return GetKeyState(gLayerTriggerPhysicalHotkeys[triggerRole], "P")
    return GetKeyState(fallbackHotkey, "P")
}

IsAnyLayerTriggerDown() {
    return IsNavTriggerDown() || IsSelectTriggerDown()
}

GetRequestedLayer() {
    if IsNavTriggerDown() {
        if IsSelectTriggerDown()
            return "NavSelect"
        return "Nav"
    }
    if IsSelectTriggerDown()
        return "Select"
    return "Base"
}

ResolveChordBinding(code, requestedLayer) {
    global gChordBindings
    for index, binding in gChordBindings {
        if (binding.code != code)
            continue
        if !ChordMatches(binding, requestedLayer)
            continue
        return binding
    }
    return ""
}

ChordMatches(binding, requestedLayer) {
    for index, requirement in binding.requirements {
        if (requirement.kind = "trigger_role") {
            if !IsTriggerRoleActive(requirement.trigger_role, requestedLayer)
                return false
            continue
        }
        if (requirement.kind = "code") {
            if !IsCodeDown(requirement.code)
                return false
            continue
        }
        return false
    }
    return true
}

IsTriggerRoleActive(triggerRole, requestedLayer) {
    if (triggerRole = "Nav") {
        if (requestedLayer = "Nav" || requestedLayer = "NavSelect")
            return true
        return IsNavTriggerDown()
    }
    if (triggerRole = "Select") {
        if (requestedLayer = "Select" || requestedLayer = "NavSelect")
            return true
        return IsSelectTriggerDown()
    }
    return false
}

IsCodeDown(code) {
    global gCodeToHotkey
    if !IsObject(gCodeToHotkey)
        return false
    if !gCodeToHotkey.HasKey(code)
        return false
    return GetKeyState(gCodeToHotkey[code], "P")
}

Dispatch(code, requestedLayer) {
    chord := ResolveChordBinding(code, requestedLayer)
    if IsObject(chord) {
        ctx := GetContext()
        ExecuteAction(chord.action, ctx)
        return
    }
    rule := ResolveRule(code, requestedLayer, requestedLayer)
    if !IsObject(rule) {
        SendCodeFallback(code)
        return
    }
    ctx := GetContext()
    actionId := ResolveActionId(rule, ctx)
    ExecuteAction(actionId, ctx)
}

ResolveRule(code, effectiveLayer, requestedLayer) {
    global gRuleMap
    key := effectiveLayer "|" code
    if gRuleMap.HasKey(key)
        return gRuleMap[key]
    if (effectiveLayer = "NavSelect") {
        navKey := "Nav|" code
        if gRuleMap.HasKey(navKey)
            return gRuleMap[navKey]
        selectKey := "Select|" code
        if gRuleMap.HasKey(selectKey)
            return gRuleMap[selectKey]
    }
    requestedKey := requestedLayer "|" code
    if gRuleMap.HasKey(requestedKey)
        return gRuleMap[requestedKey]
    baseKey := "Base|" code
    return gRuleMap.HasKey(baseKey) ? gRuleMap[baseKey] : ""
}

ResolveActionId(rule, ctx) {
    global gOverrides
    actionId := rule.action
    for index, ov in gOverrides {
        if (ov.target_layer_profile != ctx.layer_profile)
            continue
        if (ov.target_rule_id != rule.id)
            continue
        if !OverrideMatches(ov, ctx)
            continue
        actionId := ov.action
    }
    return actionId
}

SendCodeFallback(code) {
    global gSendCodes
    if !gSendCodes.HasKey(code)
        return
    SendInput % "{Blind}" . gSendCodes[code]
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/SpecialActions.ahk
; --------------------------------------------
NoOp() {
}

ShouldIgnoreRepeatedLockHotkey(thresholdMs := 200) {
    return (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotKey < thresholdMs)
}

SendEscAfterImeOff() {
    SendKeyAfterImeOff("Escape")
}

ReleaseAllModifiers() {
    SendEvent, {LShift down}{LShift up}{RShift down}{RShift up}
    SendEvent, {RCtrl down}{RCtrl up}{LCtrl down}{LCtrl up}
    SendInput {Ctrl up}{LCtrl up}{RCtrl up}{Shift up}{LShift up}{RShift up}{Alt up}{LAlt up}{RAlt up}{LWin up}{RWin up}
    SetLockStateKeysOff()
}

PasteCurrentDateIso8601ExtendedLocal() {
    dateText := GetCurrentDateIso8601ExtendedLocal()
    if (dateText = "")
        return
    PasteText(dateText)
}

PasteCurrentDateIso8601BasicLocal() {
    dateText := GetCurrentDateIso8601BasicLocal()
    if (dateText = "")
        return
    PasteText(dateText)
}

PasteCurrentDateTimeIso8601ExtendedLocal() {
    dateTimeText := GetCurrentDateTimeIso8601ExtendedLocal()
    if (dateTimeText = "")
        return
    PasteText(dateTimeText)
}

PasteCurrentDateTimeIso8601BasicLocal() {
    dateTimeText := GetCurrentDateTimeIso8601BasicLocal()
    if (dateTimeText = "")
        return
    PasteText(dateTimeText)
}

PasteClipboardAsPlainText() {
    plainText := Clipboard
    if (plainText = "")
        return
    PasteText(plainText)
}

SendKeyAfterImeOff(key) {
    global gSendKeys
    if !gSendKeys.HasKey(key)
        return
    ImeOff()
    SendInput % "{Blind}" . gSendKeys[key]
}

GetCurrentDateIso8601ExtendedLocal() {
    dateTime := GetCurrentDateTimeLocalRaw()
    if (dateTime = "")
        return ""

    year := SubStr(dateTime, 1, 4)
    month := SubStr(dateTime, 5, 2)
    day := SubStr(dateTime, 7, 2)
    return year "-" month "-" day
}

GetCurrentDateIso8601BasicLocal() {
    dateTime := GetCurrentDateTimeLocalRaw()
    if (dateTime = "")
        return ""

    year := SubStr(dateTime, 1, 4)
    month := SubStr(dateTime, 5, 2)
    day := SubStr(dateTime, 7, 2)
    return year month day
}

GetCurrentDateTimeIso8601ExtendedLocal() {
    dateTime := GetCurrentDateTimeLocalRaw()
    if (dateTime = "")
        return ""

    year := SubStr(dateTime, 1, 4)
    month := SubStr(dateTime, 5, 2)
    day := SubStr(dateTime, 7, 2)
    hour := SubStr(dateTime, 9, 2)
    minute := SubStr(dateTime, 11, 2)
    second := SubStr(dateTime, 13, 2)
    offsetText := GetCurrentUtcOffsetIso8601ExtendedLocal()
    return year "-" month "-" day "T" hour ":" minute ":" second offsetText
}

GetCurrentDateTimeIso8601BasicLocal() {
    dateTime := GetCurrentDateTimeLocalRaw()
    if (dateTime = "")
        return ""

    year := SubStr(dateTime, 1, 4)
    month := SubStr(dateTime, 5, 2)
    day := SubStr(dateTime, 7, 2)
    hour := SubStr(dateTime, 9, 2)
    minute := SubStr(dateTime, 11, 2)
    second := SubStr(dateTime, 13, 2)
    offsetText := GetCurrentUtcOffsetIso8601BasicLocal()
    return year month day "T" hour minute second offsetText
}

GetCurrentDateTimeLocalRaw() {
    return A_Now
}

GetCurrentUtcOffsetSecondsLocal() {
    localNow := A_Now
    utcNow := A_NowUTC
    EnvSub, localNow, %utcNow%, Seconds
    return localNow
}

GetCurrentUtcOffsetIso8601ExtendedLocal() {
    offsetSeconds := GetCurrentUtcOffsetSecondsLocal()
    sign := (offsetSeconds >= 0) ? "+" : "-"
    offsetSeconds := Abs(offsetSeconds)
    offsetHour := Floor(offsetSeconds / 3600)
    offsetMinute := Floor(Mod(offsetSeconds, 3600) / 60)
    return Format("{}{:02}:{:02}", sign, offsetHour, offsetMinute)
}

GetCurrentUtcOffsetIso8601BasicLocal() {
    offsetSeconds := GetCurrentUtcOffsetSecondsLocal()
    sign := (offsetSeconds >= 0) ? "+" : "-"
    offsetSeconds := Abs(offsetSeconds)
    offsetHour := Floor(offsetSeconds / 3600)
    offsetMinute := Floor(Mod(offsetSeconds, 3600) / 60)
    return Format("{}{:02}{:02}", sign, offsetHour, offsetMinute)
}

PasteText(text) {
    savedClipboard := ClipboardAll
    Clipboard := text
    ClipWait, 2
    if (ErrorLevel) {
        Clipboard := savedClipboard
        savedClipboard := ""
        return false
    }
    SendInput +{Insert}
    ResyncShiftAfterSyntheticShift()
    Sleep, 500
    Clipboard := savedClipboard
    savedClipboard := ""
    return true
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/ToolActions.ahk
; --------------------------------------------
RunClipboardTool() {
    command := GetClipboardToolCommand()
    if (command = "") {
        ShowMissingClipboardToolCommand()
        return
    }

    Run, % command,, UseErrorLevel
    if (ErrorLevel = "ERROR")
        ShowClipboardToolLaunchError(command)
}

GetClipboardToolCommand() {
    return GetLocalConfigValue("Tools", "ClipboardToolCommand", "")
}

GetLocalConfigValue(section, key, defaultValue := "") {
    configPath := GetLocalConfigPath()
    missingSentinel := "__TKN_MISSING__"
    IniRead, value, %configPath%, %section%, %key%, %missingSentinel%
    if (value != missingSentinel)
        return value
    return GetLocalConfigValueFromText(configPath, section, key, defaultValue)
}

GetLocalConfigValueFromText(configPath, section, key, defaultValue := "") {
    if !FileExist(configPath)
        return defaultValue

    FileRead, configText, %configPath%
    if (ErrorLevel)
        return defaultValue

    if (SubStr(configText, 1, 1) = Chr(0xFEFF))
        configText := SubStr(configText, 2)

    currentSection := ""
    Loop, Parse, configText, `n, `r
    {
        line := Trim(A_LoopField, " `t")
        if (line = "")
            continue

        firstChar := SubStr(line, 1, 1)
        if (firstChar = ";" || firstChar = "#")
            continue

        if RegExMatch(line, "^\[(.*)\]$", match)
        {
            currentSection := match1
            continue
        }

        if (currentSection != section)
            continue

        delimiterPos := InStr(line, "=")
        if (!delimiterPos)
            continue

        currentKey := Trim(SubStr(line, 1, delimiterPos - 1), " `t")
        if (currentKey != key)
            continue

        return Trim(SubStr(line, delimiterPos + 1), " `t")
    }

    return defaultValue
}

GetLocalConfigPath() {
    return A_ScriptDir . "\TucknHotkey.ini"
}

ShowMissingClipboardToolCommand() {
    global gAppName
    configPath := GetLocalConfigPath()
    TrayTip, % gAppName, % "Set [Tools] ClipboardToolCommand in`n" . configPath, 5
}

ShowClipboardToolLaunchError(command) {
    global gAppName
    TrayTip, % gAppName, % "Failed to run clipboard tool.`n" . command, 5
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/ViewActions.ahk
; --------------------------------------------
ShowPreviousView() {
    win := PrepareWindowForShowViewAction()
    if !IsObject(win)
        return

    if IsExcelVbaWindow(win) {
        Send, !w
        Send, {Up}
        Send, {Enter}
        return
    }
    if IsExcelWindow(win) {
        SendViewShortcut("^{PgUp}")
        return
    }
    if (win.process_name = "devenv.exe") {
        SendEscThenViewShortcut("^!{PgUp}")
        return
    }
    if (win.process_name = "Code.exe") {
        SendEscThenViewShortcut("^{PgUp}")
        return
    }
    if (win.process_name = "MassiGra.exe") {
        SendViewShortcut("{Up}")
        return
    }
    if IsMpcBeWindow(win) {
        SendViewShortcut("{PgUp}")
        return
    }
    if (win.process_name = "FreeCommander.exe" && win.win_class = "TfcViewerForm") {
        SendViewShortcut("{Left}")
        return
    }

    SendViewShortcut("^+{Tab}")
}

ShowNextView() {
    win := PrepareWindowForShowViewAction()
    if !IsObject(win)
        return

    if IsExcelVbaWindow(win) {
        SendViewShortcut("^{Down}")
        return
    }
    if IsExcelWindow(win) {
        SendViewShortcut("^{PgDn}")
        return
    }
    if (win.process_name = "devenv.exe") {
        SendEscThenViewShortcut("^!{PgDn}")
        return
    }
    if (win.process_name = "Code.exe") {
        SendEscThenViewShortcut("^{PgDn}")
        return
    }
    if (win.process_name = "MassiGra.exe") {
        SendViewShortcut("{Down}")
        return
    }
    if IsMpcBeWindow(win) {
        SendViewShortcut("{PgDn}")
        return
    }
    if (win.process_name = "FreeCommander.exe" && win.win_class = "TfcViewerForm") {
        SendViewShortcut("{Right}")
        return
    }

    SendViewShortcut("^{Tab}")
}

PrepareWindowForShowViewAction() {
    ctx := GetCurrentActionContext()
    if IsObject(ctx) && ctx.action_source = "mouse"
        return PrepareWindowUnderCursorForViewAction()
    return PrepareActiveWindowForViewAction()
}

PrepareActiveWindowForViewAction() {
    win := GetActiveWindowForViewAction()
    return PrepareWindowForViewAction(win)
}

PrepareWindowUnderCursorForViewAction() {
    win := GetActionContextTargetWindowForViewAction()
    if !IsObject(win)
        win := GetWindowUnderCursorForViewAction()
    return PrepareWindowForViewAction(win)
}

PrepareWindowForViewAction(win) {
    if !IsObject(win)
        return ""

    WinActivate, % "ahk_id " . win.hwnd
    ImeOff()
    return win
}

GetActionContextTargetWindowForViewAction() {
    ctx := GetCurrentActionContext()
    if !IsObject(ctx)
        return ""
    if !ctx.HasKey("target_hwnd")
        return ""
    return GetWindowInfoForViewAction(ctx.target_hwnd)
}

GetWindowUnderCursorForViewAction() {
    savedCoordModeMouse := A_CoordModeMouse
    CoordMode, Mouse, Screen

    MouseGetPos, , , hwnd

    CoordMode, Mouse, %savedCoordModeMouse%
    return GetWindowInfoForViewAction(hwnd)
}

GetActiveWindowForViewAction() {
    WinGet, hwnd, ID, A
    return GetWindowInfoForViewAction(hwnd)
}

GetWindowInfoForViewAction(hwnd) {
    if (hwnd = "")
        return ""

    WinGet, processName, ProcessName, % "ahk_id " . hwnd
    WinGetClass, winClass, % "ahk_id " . hwnd
    WinGetTitle, title, % "ahk_id " . hwnd

    win := {}
    win.hwnd := hwnd
    win.process_name := processName
    win.win_class := winClass
    win.title := title
    return win
}

IsExcelVbaWindow(win) {
    return win.win_class = "wndclass_desked_gsk"
}

IsExcelWindow(win) {
    return win.process_name = "EXCEL.EXE" || win.process_name = "excel.exe"
}

IsMpcBeWindow(win) {
    return win.process_name = "mpc-be.exe" || win.process_name = "mpc-be64.exe"
}

SendEscThenViewShortcut(shortcut) {
    Send, {Esc}
    SendViewShortcut(shortcut)
}

SendViewShortcut(shortcut) {
    Send, % shortcut
}

; Generated defaults: runtime/ahk/TucknHotkey.ini (edit source and regenerate).
GetImeIndicatorDefaults() {
    static defaults := {color: "E04040", shape: "ellipse", width_px: 6, height_px: 6, offset_x_px: 3, offset_y_px: -3}
    return defaults
}

