#Requires AutoHotkey v2.0
#SingleInstance Force
InstallKeybdHook
#UseHook
SetCapsLockState "AlwaysOff"
SendMode "Event"
SetWorkingDir A_ScriptDir

SetLockStateKeysOff() {
    SetCapsLockState "AlwaysOff"
}

SetTrayIconPaused(paused) {
    global gTrayIconNormalPath, gTrayIconPausePath
    iconPath := paused ? gTrayIconPausePath : gTrayIconNormalPath
    if FileExist(iconPath)
        TraySetIcon iconPath,, true
}

SetTrayPauseMenuChecked(paused) {
    if (paused)
        A_TrayMenu.Check("Pause Script")
    else
        A_TrayMenu.Uncheck("Pause Script")
}

SetTraySuspendMenuChecked(suspended) {
    if (suspended)
        A_TrayMenu.Check("Suspend Hotkeys")
    else
        A_TrayMenu.Uncheck("Suspend Hotkeys")
}

gProfile := "os-ansi_keyboard-ansi"
gLayerProfile := "os-ansi_keyboard-ansi"
gKeyboardProfile := "keyboard-ansi"
gOsLayout := "os-ansi"
gAppName := "TucknHotkey"
gUseMockImeState := false
gMockImeState := "off" ; debug helper 用の mock state
gMockJapaneseInputMode := "none"
gTrayIconNormalPath := A_ScriptDir . "\TucknHotkey.ico"
gTrayIconPausePath := A_ScriptDir . "\TucknHotkey_Pause.ico"
SetTrayIconPaused(false)
A_IconTip := A_ScriptName
A_TrayMenu.Delete()
A_TrayMenu.Add("Open", TucknTrayOpen)
A_TrayMenu.Default := "Open"
A_TrayMenu.Add("Help", TucknTrayHelp)
A_TrayMenu.Add()
A_TrayMenu.Add("Window Spy", TucknTrayWindowSpy)
A_TrayMenu.Add("Reload This Script", TucknTrayReload)
A_TrayMenu.Add("Edit This Script", TucknTrayEdit)
A_TrayMenu.Add()
A_TrayMenu.Add("Suspend Hotkeys", TucknTrayToggleSuspend)
A_TrayMenu.Add("Pause Script", TucknTrayTogglePause)
A_TrayMenu.Add("Exit", TucknTrayExit)

gCodeToHotkey := Map()
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

gSendKeys := Map()
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

gSendCodes := Map()
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

gModPrefix := Map()
gModPrefix["Shift"] := "+"
gModPrefix["Control"] := "^"
gModPrefix["Alt"] := "!"
gModPrefix["Win"] := "#"

gSelectTriggerCode := "AltLeft"
gNavTriggerCode := "AltRight"
gSelectTriggerHotkey := gCodeToHotkey[gSelectTriggerCode]
gNavTriggerHotkey := gCodeToHotkey[gNavTriggerCode]
gLayerTriggerPhysicalHotkeys := Map()
gLayerTriggerPhysicalHotkeys["Select"] := "sc038"
gLayerTriggerPhysicalHotkeys["Nav"] := "sc138"
gLayerTriggerSuppressUpSequence := "{vkA4sc038 up}{vkA5sc138 up}"
gActions := Map()
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
gActions["SendBackquoteCode"] := {kind: "code", code: "Backquote", description: "Backquote（Scancode sc029）。ANSIなら ``、101/102 設定の JIS キーボードではかな入力時に「ろ」が出力される"}
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
gActions["SendBackspace"] := {kind: "key", key: "Backspace", description: ""}
gActions["SendTab"] := {kind: "key", key: "Tab", description: ""}
gActions["SendBracketLeftCode"] := {kind: "code", code: "BracketLeft", description: ""}
gActions["SendBracketRightCode"] := {kind: "code", code: "BracketRight", description: "ANSIなら ] JISなら [ かな入力時は ゜（半濁点）"}
gActions["SendBackslashCode"] := {kind: "code", code: "Backslash", description: "Backslash（Scancode sc02B）。ANSIなら \ JISなら ] かな入力時は む"}
gActions["SendEnter"] := {kind: "key", key: "Enter", description: ""}
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
gActions["SendShiftBackquoteCode"] := {kind: "shortcut", mods: ["Shift"], code: "Backquote", description: "Shift + Backquote（Scancode sc029）。ANSIなら ~"}
gActions["SendShiftDigit1Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit1", description: ""}
gActions["SendShiftDigit2Code"] := {kind: "shortcut", mods: ["Shift"], code: "Digit2", description: "ANSI @ JIS `" "}
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
gActions["SendShiftBracketLeftCode"] := {kind: "shortcut", mods: ["Shift"], code: "BracketLeft", description: "ANSI { JIS `` (Backquote) かな入力時は無し"}
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
gActions["SendShiftQuoteCode"] := {kind: "shortcut", mods: ["Shift"], code: "Quote", description: "ANSIなら `" JISなら * かな入力時は無し"}
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
gActions["SendAltBackquoteCode"] := {kind: "shortcut", mods: ["Alt"], code: "Backquote", description: "ANSIにおいては半角/全角にあたるショートカット"}
gActions["SendRomaKana"] := {kind: "shortcut", mods: ["Alt"], code: "KanaMode", description: "Alt+かなキーでローマ字/かな切り替えを送信"}
gActions["SendWinTab"] := {kind: "shortcut", mods: ["Win"], code: "Tab", description: "Windows タスクビューを開く"}
gActions["SendEscAfterImeOff"] := {kind: "special", description: "IME をオフにして Esc を送信する"}
gActions["ReleaseAllModifiers"] := {kind: "special", description: "Ctrl / Shift / Alt / Win をすべて解放"}
gActions["SendLeaderKey"] := {kind: "shortcut", mods: ["Control"], code: "Semicolon", description: "自分専用のLeader keyであるCtrl+;"}
gActions["NoOp"] := {kind: "special", description: "継承を止めるための明示的な no-op"}

gRuleMap := Map()
gRuleMap["Base|CapsLock"] := {id: "base.capslock", layer: "Base", code: "CapsLock", action: "SendEsc", note: "CapsLockをEscに置き換える。Capsはロック機能があるが、修飾キーとしてて使わなければ影響なし"}
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
gRuleMap["Select|Equal"] := {id: "select.equal", layer: "Select", code: "Equal", action: "SendShiftEqualCode", note: ""}
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
gRuleMap["Select|BracketLeft"] := {id: "select.backetleft", layer: "Select", code: "BracketLeft", action: "SendShiftBracketLeftCode", note: ""}
gRuleMap["Select|BracketRight"] := {id: "select.backetright", layer: "Select", code: "BracketRight", action: "SendShiftBracketRightCode", note: "Row Bに配置するのでこの配置では使わない想定"}
gRuleMap["Select|Backslash"] := {id: "select.backslash", layer: "Select", code: "Backslash", action: "SendShiftBackslashCode", note: ""}
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
gRuleMap["Select|Semicolon"] := {id: "select.semicolon", layer: "Select", code: "Semicolon", action: "SendShiftSemicolonCode", note: ""}
gRuleMap["Select|Quote"] := {id: "select.quote", layer: "Select", code: "Quote", action: "SendShiftQuoteCode", note: ""}
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
gRuleMap["Nav|Equal"] := {id: "nav.equal", layer: "Nav", code: "Equal", action: "SendF12", note: ""}
gRuleMap["Nav|Tab"] := {id: "nav.tab", layer: "Nav", code: "Tab", action: "SendBackquoteCode", note: "Row Eにある `` (Backquote) を割り当てるが、; (Semicolon) にも割り当てるためここのは使わない想定"}
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
gRuleMap["Nav|BracketLeft"] := {id: "nav.backetleft", layer: "Nav", code: "BracketLeft", action: "SendMinusCode", note: ""}
gRuleMap["Nav|BracketRight"] := {id: "nav.bracketright", layer: "Nav", code: "BracketRight", action: "SendEqualCode", note: "タイプコストが高いため使わない想定。Equal は [Nav]+[x] で対応する"}
gRuleMap["Nav|CapsLock"] := {id: "nav.capslock", layer: "Nav", code: "CapsLock", action: "SendEscAfterImeOff", note: ""}
gRuleMap["Nav|KeyA"] := {id: "nav.keya", layer: "Nav", code: "KeyA", action: "SendAltBackquoteCode", note: ""}
gRuleMap["Nav|KeyS"] := {id: "nav.keys", layer: "Nav", code: "KeyS", action: "JumpHome", note: ""}
gRuleMap["Nav|KeyD"] := {id: "nav.keyd", layer: "Nav", code: "KeyD", action: "PageUpAction", note: ""}
gRuleMap["Nav|KeyF"] := {id: "nav.keyf", layer: "Nav", code: "KeyF", action: "PageDownAction", note: ""}
gRuleMap["Nav|KeyG"] := {id: "nav.keyg", layer: "Nav", code: "KeyG", action: "JumpEnd", note: ""}
gRuleMap["Nav|KeyH"] := {id: "nav.keyh", layer: "Nav", code: "KeyH", action: "MoveLeft", note: ""}
gRuleMap["Nav|KeyJ"] := {id: "nav.keyj", layer: "Nav", code: "KeyJ", action: "MoveDown", note: ""}
gRuleMap["Nav|KeyK"] := {id: "nav.keyk", layer: "Nav", code: "KeyK", action: "MoveUp", note: ""}
gRuleMap["Nav|KeyL"] := {id: "nav.keyl", layer: "Nav", code: "KeyL", action: "MoveRight", note: ""}
gRuleMap["Nav|Semicolon"] := {id: "nav.semicolon", layer: "Nav", code: "Semicolon", action: "SendEnter", note: ""}
gRuleMap["Nav|Quote"] := {id: "nav.quote", layer: "Nav", code: "Quote", action: "SendBackquoteCode", note: "quote系に寄せるため `` (Backquote) を割り当てる"}
gRuleMap["Nav|Enter"] := {id: "nav.enter", layer: "Nav", code: "Enter", action: "SendWinTab", note: ""}
gRuleMap["Nav|KeyZ"] := {id: "nav.keyz", layer: "Nav", code: "KeyZ", action: "SendEqualCode", note: "直接入力時は = かな入力時には「へ」に"}
gRuleMap["Nav|KeyC"] := {id: "nav.keyc", layer: "Nav", code: "KeyC", action: "SendAppsKey", note: ""}
gRuleMap["Nav|KeyV"] := {id: "nav.keyv", layer: "Nav", code: "KeyV", action: "SendDelete", note: ""}
gRuleMap["Nav|KeyB"] := {id: "nav.keyb", layer: "Nav", code: "KeyB", action: "SendTab", note: ""}
gRuleMap["Nav|KeyN"] := {id: "nav.keyn", layer: "Nav", code: "KeyN", action: "SendBackspace", note: ""}
gRuleMap["Nav|KeyM"] := {id: "nav.keym", layer: "Nav", code: "KeyM", action: "NoOp", note: "MacroキーのためNoOp"}
gRuleMap["Nav|Comma"] := {id: "nav.comma", layer: "Nav", code: "Comma", action: "SendBracketLeftCode", note: "["}
gRuleMap["Nav|Period"] := {id: "nav.period", layer: "Nav", code: "Period", action: "SendBracketRightCode", note: "]"}
gRuleMap["Nav|Slash"] := {id: "nav.slash", layer: "Nav", code: "Slash", action: "SendBackslashCode", note: "\ を出力する。かな入力時は「む」になってしまうが「ろ」を出したいのでoverride で Backquote に差し替える"}
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
gRuleMap["NavSelect|Equal"] := {id: "navselect.equal", layer: "NavSelect", code: "Equal", action: "SendShiftF12", note: ""}
gRuleMap["NavSelect|Tab"] := {id: "navselect.tab", layer: "NavSelect", code: "Tab", action: "SendShiftBackquoteCode", note: " ~ (Childa)"}
gRuleMap["NavSelect|KeyQ"] := {id: "navselect.keyq", layer: "NavSelect", code: "KeyQ", action: "SendShiftDigit1Code", note: "!"}
gRuleMap["NavSelect|KeyW"] := {id: "navselect.keyw", layer: "NavSelect", code: "KeyW", action: "SendShiftDigit2Code", note: "@"}
gRuleMap["NavSelect|KeyE"] := {id: "navselect.keye", layer: "NavSelect", code: "KeyE", action: "SendShiftDigit3Code", note: "#"}
gRuleMap["NavSelect|KeyR"] := {id: "navselect.keyr", layer: "NavSelect", code: "KeyR", action: "SendShiftDigit4Code", note: "$"}
gRuleMap["NavSelect|KeyT"] := {id: "navselect.keyt", layer: "NavSelect", code: "KeyT", action: "SendShiftDigit5Code", note: "%"}
gRuleMap["NavSelect|KeyY"] := {id: "navselect.keyy", layer: "NavSelect", code: "KeyY", action: "SendShiftDigit6Code", note: "^"}
gRuleMap["NavSelect|KeyU"] := {id: "navselect.keyu", layer: "NavSelect", code: "KeyU", action: "SendShiftDigit7Code", note: "&"}
gRuleMap["NavSelect|KeyI"] := {id: "navselect.keyi", layer: "NavSelect", code: "KeyI", action: "SendShiftDigit8Code", note: "*"}
gRuleMap["NavSelect|KeyO"] := {id: "navselect.keyo", layer: "NavSelect", code: "KeyO", action: "SendShiftDigit9Code", note: "("}
gRuleMap["NavSelect|KeyP"] := {id: "navselect.keyp", layer: "NavSelect", code: "KeyP", action: "SendShiftDigit0Code", note: ")"}
gRuleMap["NavSelect|BracketLeft"] := {id: "navselect.bracketleft", layer: "NavSelect", code: "BracketLeft", action: "SendShiftMinusCode", note: "_"}
gRuleMap["NavSelect|BracketRight"] := {id: "navselect.bracketright", layer: "NavSelect", code: "BracketRight", action: "SendShiftEqualCode", note: "タイプコストが高いため使わない想定"}
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
gRuleMap["NavSelect|Quote"] := {id: "navselect.quote", layer: "NavSelect", code: "Quote", action: "SendShiftBackquoteCode", note: " ~ (Childa)"}
gRuleMap["NavSelect|KeyZ"] := {id: "navselect.keyz", layer: "NavSelect", code: "KeyZ", action: "SendShiftEqualCode", note: " + (Equal)"}
gRuleMap["NavSelect|KeyC"] := {id: "navselect.keyc", layer: "NavSelect", code: "KeyC", action: "NoOp", note: ""}
gRuleMap["NavSelect|KeyV"] := {id: "navselect.keyv", layer: "NavSelect", code: "KeyV", action: "SendShiftDel", note: ""}
gRuleMap["NavSelect|KeyB"] := {id: "navselect.keyb", layer: "NavSelect", code: "KeyB", action: "SendShiftTab", note: ""}
gRuleMap["NavSelect|KeyN"] := {id: "navselect.keyn", layer: "NavSelect", code: "KeyN", action: "SendShiftBackspace", note: ""}
gRuleMap["NavSelect|KeyM"] := {id: "navselect.keym", layer: "NavSelect", code: "KeyM", action: "NoOp", note: "MacroキーのためNoOp"}
gRuleMap["NavSelect|Comma"] := {id: "navselect.comma", layer: "NavSelect", code: "Comma", action: "SendShiftBracketLeftCode", note: "{"}
gRuleMap["NavSelect|Period"] := {id: "navselect.period", layer: "NavSelect", code: "Period", action: "SendShiftBracketRightCode", note: "}"}
gRuleMap["NavSelect|Slash"] := {id: "navselect.slash", layer: "NavSelect", code: "Slash", action: "SendShiftBackslashCode", note: " | (Pipeline)"}

gOverrides := []

gChordBindings := []

InitImeIndicator()

; ------------------------------
; Generated modifier remaps
; ------------------------------
LWin::LAlt

RShift::LWin

gAssociatedMouseComboTriggerHotkeys := Map()
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
    if !gAssociatedMouseComboTriggerHotkeys.Has(code)
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
#HotIf IsAssociatedMouseComboTriggerDown("KeyW")
~*w:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyE")
~*e:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyR")
~*r:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyT")
~*t:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyS")
~*s:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyD")
~*d:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyF")
~*f:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("Enter")
~*Enter:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyX")
~*x:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyV")
~*v:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyC")
~*c:: {
}
#HotIf

#HotIf IsAssociatedMouseComboTriggerDown("KeyZ")
~*z:: {
}
#HotIf

return

; ------------------------------
; Generated tray menu
; ------------------------------
TucknTrayOpen(*) {
    ListLines
}

TucknTrayHelp(*) {
    SplitPath A_AhkPath,, &ahkDir
    helpPath := ahkDir . "\AutoHotkey.chm"
    if FileExist(helpPath)
        Run helpPath
}

TucknTrayWindowSpy(*) {
    SplitPath A_AhkPath,, &ahkDir
    windowSpyPath := ahkDir . "\WindowSpy.ahk"
    windowSpyExePath := ahkDir . "\WindowSpy.exe"
    if FileExist(windowSpyPath)
        Run Format('"{}" "{}"', A_AhkPath, windowSpyPath)
    else if FileExist(windowSpyExePath)
        Run windowSpyExePath
}

TucknTrayReload(*) {
    Reload
}

TucknTrayEdit(*) {
    Edit
}

TucknTrayToggleSuspend(*) {
    Suspend !A_IsSuspended
    HideImeIndicator()
    SetTraySuspendMenuChecked(A_IsSuspended)
    SetTrayIconPaused(A_IsPaused || A_IsSuspended)
}

TucknTrayTogglePause(*) {
    if (A_IsPaused) {
        Pause 0
        SetTrayPauseMenuChecked(false)
        SetTrayIconPaused(A_IsSuspended)
    } else {
        SetTrayIconPaused(true)
        SetTrayPauseMenuChecked(true)
        HideImeIndicator()
        Pause 1
    }
}

TucknTrayExit(*) {
    ExitApp
}

; ------------------------------
; Generated hotkeys
; ------------------------------
*sc03A:: {
    if HandlePhysicalShiftCapsLock()
        return
    if ShouldIgnoreRepeatedLockHotkey()
        return
    HandleWildcard("CapsLock")
}

*1:: {
    HandleWildcard("Digit1")
}

*2:: {
    HandleWildcard("Digit2")
}

*3:: {
    HandleWildcard("Digit3")
}

*4:: {
    HandleWildcard("Digit4")
}

*5:: {
    HandleWildcard("Digit5")
}

*6:: {
    HandleWildcard("Digit6")
}

*7:: {
    HandleWildcard("Digit7")
}

*8:: {
    HandleWildcard("Digit8")
}

*9:: {
    HandleWildcard("Digit9")
}

*0:: {
    HandleWildcard("Digit0")
}

*-:: {
    HandleWildcard("Minus")
}

*sc00D:: {
    HandleWildcard("Equal")
}

*Backspace:: {
    HandleWildcard("Backspace")
}

*Tab:: {
    HandleWildcard("Tab")
}

*q:: {
    HandleWildcard("KeyQ")
}

*w:: {
    HandleWildcard("KeyW")
}

*e:: {
    HandleWildcard("KeyE")
}

*r:: {
    HandleWildcard("KeyR")
}

*t:: {
    HandleWildcard("KeyT")
}

*y:: {
    HandleWildcard("KeyY")
}

*u:: {
    HandleWildcard("KeyU")
}

*i:: {
    HandleWildcard("KeyI")
}

*o:: {
    HandleWildcard("KeyO")
}

*p:: {
    HandleWildcard("KeyP")
}

*sc01A:: {
    HandleWildcard("BracketLeft")
}

*sc01B:: {
    HandleWildcard("BracketRight")
}

*sc02B:: {
    HandleWildcard("Backslash")
}

*a:: {
    HandleWildcard("KeyA")
}

*s:: {
    HandleWildcard("KeyS")
}

*d:: {
    HandleWildcard("KeyD")
}

*f:: {
    HandleWildcard("KeyF")
}

*g:: {
    HandleWildcard("KeyG")
}

*h:: {
    HandleWildcard("KeyH")
}

*j:: {
    HandleWildcard("KeyJ")
}

*k:: {
    HandleWildcard("KeyK")
}

*l:: {
    HandleWildcard("KeyL")
}

*`;:: {
    HandleWildcard("Semicolon")
}

*sc028:: {
    HandleWildcard("Quote")
}

*Enter:: {
    HandleWildcard("Enter")
}

*z:: {
    HandleWildcard("KeyZ")
}

*x:: {
    HandleWildcard("KeyX")
}

*c:: {
    HandleWildcard("KeyC")
}

*v:: {
    HandleWildcard("KeyV")
}

*b:: {
    HandleWildcard("KeyB")
}

*n:: {
    HandleWildcard("KeyN")
}

*m:: {
    HandleWildcard("KeyM")
}

*,:: {
    HandleWildcard("Comma")
}

*.:: {
    HandleWildcard("Period")
}

*/:: {
    HandleWildcard("Slash")
}

*Space:: {
    HandleWildcard("Space")
}

*sc138:: {
    SuppressLayerAltTriggers()
}

*sc138 Up:: {
    SuppressLayerAltTriggers()
}

*sc038:: {
    SuppressLayerAltTriggers()
}

*sc038 Up:: {
    SuppressLayerAltTriggers()
}


; --------------------------------------------
; Runtime fragment: runtime/ahk/v2/Ime.ahk
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
        , "Ptr", 0x0005, "Ptr", 0, "UInt", 0x22, "UInt", 25, "Ptr*", &result, "Ptr")
    return ok ? (result != 0 ? 1 : 0) : -1
}

GetImeTargetWindowHandle(winTitle := "A") {
    try hwnd := WinGetID(winTitle)
    catch
        hwnd := 0
    if (!hwnd)
        return 0

    if WinActive(winTitle) {
        ptrSize := A_PtrSize
        cbSize := 4 + 4 + (ptrSize * 6) + 16
        stGTI := Buffer(cbSize, 0)
        NumPut("UInt", cbSize, stGTI, 0)
        focusedHwnd := DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", stGTI)
            ? NumGet(stGTI, 8 + ptrSize, "Ptr")
            : 0
        if (focusedHwnd)
            hwnd := focusedHwnd
    }

    return hwnd
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v2/ImeIndicator.ahk
; --------------------------------------------
InitImeIndicator() {
    global gImeIndicator
    gImeIndicator := {enabled: false, hwnd: 0, window: 0, visible: false, x: 0, y: 0}
    enabled := Trim(GetLocalConfigValue("ImeIndicator", "enabled", "0"))
    if !RegExMatch(enabled, "i)^(1|true|on|yes)$")
        return

    defaults := GetImeIndicatorDefaults()
    color := Trim(GetLocalConfigValue("ImeIndicator", "color", defaults.color))
    if !RegExMatch(color, "i)^#?([0-9a-f]{6})$", &match)
        color := defaults.color
    else
        color := match[1]
    gImeIndicator.color := color
    ConfigureImeIndicatorGeometry()

    try {
        ; Layered + transparent + no-activate: the marker never consumes clicks or focus.
        window := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08080020", "TucknHotkey IME indicator")
        gImeIndicator.window := window
        gImeIndicator.hwnd := window.Hwnd
        window.BackColor := color
        if !DllCall("SetLayeredWindowAttributes", "Ptr", window.Hwnd, "UInt", 0, "UChar", 255, "UInt", 2)
            throw Error("Cannot initialize IME indicator")
        SetImeIndicatorShape(window.Hwnd)
        gImeIndicator.enabled := true
        OnExit(StopImeIndicator)
        SetTimer UpdateImeIndicator, 100
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
        throw Error("Cannot create IME indicator shape")
    try {
        if !DllCall("SetWindowRgn", "Ptr", hwnd, "Ptr", region, "Int", false)
            throw Error("Cannot apply IME indicator shape")
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
    info := Buffer(cbSize, 0)
    NumPut("UInt", cbSize, info)
    if !DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", info)
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
        CoordMode "Caret", "Screen"
        found := CaretGetPos(&x, &y)
    } finally {
        CoordMode "Caret", previousMode
    }
    if !found
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
    ; Screen coordinates and unscaled pixels; avoid Gui.Show's repeated layout work.
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
    if !IsSet(gImeIndicator) || !gImeIndicator.hwnd
        return
    DllCall("ShowWindow", "Ptr", gImeIndicator.hwnd, "Int", 0)
    gImeIndicator.visible := false
}

StopImeIndicator(*) {
    global gImeIndicator
    SetTimer UpdateImeIndicator, 0
    if !IsSet(gImeIndicator)
        return
    gImeIndicator.enabled := false
    HideImeIndicator()
    if IsObject(gImeIndicator.window)
        gImeIndicator.window.Destroy()
    gImeIndicator.window := 0
    gImeIndicator.hwnd := 0
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v2/ActionExecutor.ahk
; --------------------------------------------
GetContext(actionSource := "keyboard") {
    global gProfile, gLayerProfile, gKeyboardProfile, gOsLayout
    exe := GetActiveProcessNameOrEmpty()
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

GetActiveProcessNameOrEmpty() {
    try
        return WinGetProcessName("A")
    catch Error
        return ""
}

GetCurrentActionContext() {
    global gCurrentActionContext
    return IsSet(gCurrentActionContext) && IsObject(gCurrentActionContext) ? gCurrentActionContext : ""
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
    if !gActions.Has(actionId)
        return
    action := gActions[actionId]
    if (action.kind = "key") {
        SendInput "{Blind}" . gSendKeys[action.key]
        return
    }
    if (action.kind = "code") {
        SendInput "{Blind}" . gSendCodes[action.code]
        return
    }
    if (action.kind = "text") {
        SendInput "{Blind}{Text}" . action.text
        return
    }
    if (action.kind = "shortcut") {
        seq := "{Blind}"
        for index, mod in action.mods
            seq .= gModPrefix[mod]
        if HasProp(action, "key")
            seq .= gSendKeys[action.key]
        else if HasProp(action, "code")
            seq .= gSendCodes[action.code]
        else
            return
        SendInput seq
        ResyncSyntheticShortcutModifiers(action)
        return
    }
    if (action.kind = "special") {
        try specialAction := %actionId%
        catch
            return
        savedActionContext := GetCurrentActionContext()
        gCurrentActionContext := ctx
        specialAction()
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
    SendEvent "{LShift down}{LShift up}{RShift down}{RShift up}"
    SendInput "{Shift up}{LShift up}{RShift up}"
}

ResyncCtrlAfterSyntheticCtrl() {
    if IsPhysicalCtrlModifierDown()
        return
    if !IsLogicalCtrlModifierDown()
        return
    SendEvent "{RCtrl down}{RCtrl up}{LCtrl down}{LCtrl up}"
    SendInput "{Ctrl up}{LCtrl up}{RCtrl up}"
}

ActionHasModifier(action, modifier) {
    if !HasProp(action, "mods")
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
; Runtime fragment: runtime/ahk/v2/Dispatcher.ahk
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
        SetCapsLockState "AlwaysOff"
    else
        SetCapsLockState "On"
    return true
}

IsPhysicalShiftDown() {
    return GetKeyState("LShift", "P") || GetKeyState("RShift", "P")
}

SuppressLayerAltTriggers() {
    global gLayerTriggerSuppressUpSequence
    if (gLayerTriggerSuppressUpSequence = "")
        return
    SendInput "{Blind}" . gLayerTriggerSuppressUpSequence
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
    if IsObject(gLayerTriggerPhysicalHotkeys) && gLayerTriggerPhysicalHotkeys.Has(triggerRole)
        return GetPhysicalKeyStateOrFalse(gLayerTriggerPhysicalHotkeys[triggerRole])
    return GetPhysicalKeyStateOrFalse(fallbackHotkey)
}

GetPhysicalKeyStateOrFalse(hotkey) {
    try
        return GetKeyState(hotkey, "P")
    catch Error
        return false
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
    if !gCodeToHotkey.Has(code)
        return false
    return GetPhysicalKeyStateOrFalse(gCodeToHotkey[code])
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
    if gRuleMap.Has(key)
        return gRuleMap[key]
    if (effectiveLayer = "NavSelect") {
        navKey := "Nav|" code
        if gRuleMap.Has(navKey)
            return gRuleMap[navKey]
        selectKey := "Select|" code
        if gRuleMap.Has(selectKey)
            return gRuleMap[selectKey]
    }
    requestedKey := requestedLayer "|" code
    if gRuleMap.Has(requestedKey)
        return gRuleMap[requestedKey]
    baseKey := "Base|" code
    return gRuleMap.Has(baseKey) ? gRuleMap[baseKey] : ""
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
    if !gSendCodes.Has(code)
        return
    SendInput "{Blind}" . gSendCodes[code]
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v2/SpecialActions.ahk
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
    SendEvent "{LShift down}{LShift up}{RShift down}{RShift up}"
    SendEvent "{RCtrl down}{RCtrl up}{LCtrl down}{LCtrl up}"
    SendInput "{Ctrl up}{LCtrl up}{RCtrl up}{Shift up}{LShift up}{RShift up}{Alt up}{LAlt up}{RAlt up}{LWin up}{RWin up}"
    SetLockStateKeysOff()
}

SendKeyAfterImeOff(key) {
    global gSendKeys
    if !gSendKeys.Has(key)
        return
    ImeOff()
    SendInput "{Blind}" . gSendKeys[key]
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v2/ToolActions.ahk
; --------------------------------------------
GetLocalConfigValue(section, key, defaultValue := "") {
    configPath := GetLocalConfigPath()
    missingSentinel := "__TKN_MISSING__"
    value := IniRead(configPath, section, key, missingSentinel)
    if (value != missingSentinel)
        return value
    return GetLocalConfigValueFromText(configPath, section, key, defaultValue)
}

GetLocalConfigValueFromText(configPath, section, key, defaultValue := "") {
    if !FileExist(configPath)
        return defaultValue

    try configText := FileRead(configPath)
    catch
        return defaultValue

    if (SubStr(configText, 1, 1) = Chr(0xFEFF))
        configText := SubStr(configText, 2)

    currentSection := ""
    Loop Parse, configText, "`n", "`r" {
        line := Trim(A_LoopField, " `t")
        if (line = "")
            continue

        firstChar := SubStr(line, 1, 1)
        if (firstChar = ";" || firstChar = "#")
            continue

        match := ""
        if RegExMatch(line, "^\[(.*)\]$", &match) {
            currentSection := match[1]
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

; Generated defaults: runtime/ahk/TucknHotkey.ini (edit source and regenerate).
GetImeIndicatorDefaults() {
    static defaults := {color: "E04040", shape: "ellipse", width_px: 6, height_px: 6, offset_x_px: 3, offset_y_px: -3}
    return defaults
}

