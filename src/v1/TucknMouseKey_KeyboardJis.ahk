#Requires AutoHotkey v1.1.33+
#NoEnv
#SingleInstance Force
#InstallKeybdHook
#UseHook
#MenuMaskKey vkE8
#MaxHotkeysPerInterval 120
SendMode Event
SetWorkingDir %A_ScriptDir%

SetLockStateKeysOff() {
    SetCapsLockState, Off
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

global gProfile := "mouse-set.keyboard-jis_nonedit-edit-gesture"
global gMouseSet := "mouse-set.keyboard-jis_nonedit-edit-gesture"
global gLayerProfile := ""
global gKeyboardProfile := ""
global gOsLayout := "any"
global gAppName := "TucknHotkey"
global gUseMockImeState := false
global gMockImeState := "off" ; debug helper 用の mock state
global gMockJapaneseInputMode := "none"
global gTrayIconNormalPath := A_ScriptDir . "\TucknMouseKey.ico"
global gTrayIconPausePath := A_ScriptDir . "\TucknMouseKey_Pause.ico"
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

global gActions := {}
gActions["SendF10"] := {kind: "key", key: "F10", description: ""}
gActions["SendF12"] := {kind: "key", key: "F12", description: ""}
gActions["JumpHome"] := {kind: "key", key: "Home", description: ""}
gActions["JumpEnd"] := {kind: "key", key: "End", description: ""}
gActions["PageUpAction"] := {kind: "key", key: "PageUp", description: ""}
gActions["PageDownAction"] := {kind: "key", key: "PageDown", description: ""}
gActions["MoveLeft"] := {kind: "key", key: "ArrowLeft", description: ""}
gActions["MoveDown"] := {kind: "key", key: "ArrowDown", description: ""}
gActions["MoveUp"] := {kind: "key", key: "ArrowUp", description: ""}
gActions["MoveRight"] := {kind: "key", key: "ArrowRight", description: ""}
gActions["ExtendHome"] := {kind: "shortcut", mods: ["Shift"], key: "Home", description: ""}
gActions["ExtendEnd"] := {kind: "shortcut", mods: ["Shift"], key: "End", description: ""}
gActions["ExtendPageUp"] := {kind: "shortcut", mods: ["Shift"], key: "PageUp", description: ""}
gActions["ExtendPageDown"] := {kind: "shortcut", mods: ["Shift"], key: "PageDown", description: ""}
gActions["ExtendLeft"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowLeft", description: ""}
gActions["ExtendDown"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowDown", description: ""}
gActions["ExtendUp"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowUp", description: ""}
gActions["ExtendRight"] := {kind: "shortcut", mods: ["Shift"], key: "ArrowRight", description: ""}
gActions["SendWinTab"] := {kind: "shortcut", mods: ["Win"], code: "Tab", description: "Windows タスクビューを開く"}
gActions["SwitchVirtualDesktopLeft"] := {kind: "special", description: "仮想デスクトップを左へ切り替える"}
gActions["SwitchVirtualDesktopRight"] := {kind: "special", description: "仮想デスクトップを右へ切り替える"}
gActions["AlwaysOnTopToggle"] := {kind: "shortcut", mods: ["Control", "Win"], code: "KeyT", description: "PowerToys: Always On Top - 常に最前面に表示するアクティブウィンドウを切り替える"}
gActions["SendUndo"] := {kind: "shortcut", mods: ["Control"], code: "KeyZ", description: "Ctrl+Z を送信する"}
gActions["SendRedo"] := {kind: "shortcut", mods: ["Control"], code: "KeyY", description: "Ctrl+Y を送信する"}
gActions["SendCut"] := {kind: "shortcut", mods: ["Control"], code: "KeyX", description: "Ctrl+X を送信する"}
gActions["SendCopy"] := {kind: "shortcut", mods: ["Control"], code: "KeyC", description: "Ctrl+C を送信する"}
gActions["TakeScreenshotAndSave"] := {kind: "shortcut", mods: ["Win", "Shift"], code: "KeyS", description: "Windows Snipping Tool スクリーンショットを撮影し、クリップ画像を自動保存する"}
gActions["TakeZoomItScreenshot"] := {kind: "shortcut", mods: ["Control"], code: "Digit6", description: "ZoomIt: スクリーンショットを撮影するが、クリップ画像は保存しない"}
gActions["CopyFilePath"] := {kind: "special", description: "ファイルパスをコピー"}
gActions["MoveWindowUnderCursor"] := {kind: "special", description: "NonEdit trigger を押している間、カーソル下のウィンドウを移動する"}
gActions["ResizeWindowUnderCursor"] := {kind: "special", description: "NonEdit trigger を押している間、カーソル下のウィンドウをリサイズする"}
gActions["SendWindowUnderCursorToBack"] := {kind: "special", description: "カーソル下のウィンドウを最背面へ送る"}
gActions["AcceleratedScrollUp"] := {kind: "special", description: "連続したホイール上入力を加速して送信する"}
gActions["AcceleratedScrollDown"] := {kind: "special", description: "連続したホイール下入力を加速して送信する"}
gActions["PasteClipboardAsPlainText"] := {kind: "special", description: "クリップボードの内容をプレーンテキストとして貼り付ける"}
gActions["RunClipboardTool"] := {kind: "special", description: "ローカル設定で指定したクリップボードツールを起動する"}
gActions["ShowPreviousView"] := {kind: "special", description: "対象アプリごとに前の表示対象へ切り替える"}
gActions["ShowNextView"] := {kind: "special", description: "対象アプリごとに次の表示対象へ切り替える"}
gActions["GoBackToPreviousLocation"] := {kind: "special", description: "カーソル下の対応アプリで前の場所や履歴へ戻る"}
gActions["GoToForwardLocation"] := {kind: "special", description: "カーソル下の対応アプリで次の場所や履歴へ進む"}
gActions["CloseViewUnderCursor"] := {kind: "special", description: "カーソル下の対応アプリで現在のタブやサブウィンドウを閉じる"}
gActions["RestoreOrMinimizeWindow"] := {kind: "special", description: "対象ウィンドウへ Win+Down を送信し、最大化解除または最小化する"}
gActions["MaximizeOrSnapWindowUp"] := {kind: "special", description: "対象ウィンドウへ Win+Up を送信し、最大化または上半分へ配置する"}
gActions["JumpToTop"] := {kind: "special", description: "対象アプリで最上部へ移動する。Excel は Ctrl+Up、それ以外は Home"}
gActions["JumpToBottom"] := {kind: "special", description: "対象アプリで最下部へ移動する。Excel は Ctrl+Down、それ以外は End"}
gActions["OpenParentLocation"] := {kind: "special", description: "親の場所へ移動する。現時点では Backspace を送信する"}
gActions["ZoomInDesktop"] := {kind: "special", description: "Windows 拡大鏡を起動または拡大する"}
gActions["ZoomOutDesktop"] := {kind: "special", description: "Windows 拡大鏡を起動または縮小する"}

global gMouseBindings := []
gMouseBindings.Push({id: "base.wheelup", section: "Base", trigger_role: "", input_kind: "mouse", input_value: "WheelUp", mods: "", action: "AcceleratedScrollUp", note: "通常ホイール上を連続入力時だけ加速して送る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "base.wheeldown", section: "Base", trigger_role: "", input_kind: "mouse", input_value: "WheelDown", mods: "", action: "AcceleratedScrollDown", note: "通常ホイール下を連続入力時だけ加速して送る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "base.xbutton1", section: "Base", trigger_role: "", input_kind: "mouse", input_value: "XButton1", mods: "", action: "ShowPreviousView", note: "戻るボタンで前の表示対象へ切り替える", specificity: 0, requirements: []})
gMouseBindings.Push({id: "base.xbutton2", section: "Base", trigger_role: "", input_kind: "mouse", input_value: "XButton2", mods: "", action: "ShowNextView", note: "進むボタンで次の表示対象へ切り替える", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.left", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "4", mods: "", action: "GoBackToPreviousLocation", note: "F11 + 左ジェスチャーでカーソル下の対応アプリの前の場所や履歴へ戻る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.right", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "6", mods: "", action: "GoToForwardLocation", note: "F11 + 右ジェスチャーでカーソル下の対応アプリの次の場所や履歴へ進む", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.downleft", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "1", mods: "", action: "RestoreOrMinimizeWindow", note: "F11 + 左下ジェスチャーで対象ウィンドウへ Win+Down を送る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.downright", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "3", mods: "", action: "CloseViewUnderCursor", note: "F11 + 右下ジェスチャーで対象ビューを閉じる", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.down", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "2", mods: "", action: "JumpToBottom", note: "F11 + 下ジェスチャーで対象アプリの最下部へ移動する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.up", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "8", mods: "", action: "JumpToTop", note: "F11 + 上ジェスチャーで対象アプリの最上部へ移動する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.upright", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "9", mods: "", action: "MaximizeOrSnapWindowUp", note: "F11 + 右上ジェスチャーで対象ウィンドウへ Win+Up を送る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.downright-right", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "42", mods: "", action: "SendWindowUnderCursorToBack", note: "F11 + 左→下ジェスチャーで対象ウィンドウを最背面へ送る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.up-left", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "84", mods: "", action: "ShowPreviousView", note: "F11 + 上→左ジェスチャーで前の表示対象へ切り替える", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.up-right", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "86", mods: "", action: "ShowNextView", note: "F11 + 上→右ジェスチャーで次の表示対象へ切り替える", specificity: 0, requirements: []})
gMouseBindings.Push({id: "gesture.left-up", section: "Gesture", trigger_role: "Gesture", input_kind: "gesture", input_value: "48", mods: "", action: "OpenParentLocation", note: "F11 + 左→上ジェスチャーで親の場所へ移動する。現時点では Backspace", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.lbutton", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "LButton", mods: "", action: "MoveWindowUnderCursor", note: "F10 + 左クリック押下中はカーソル下のウィンドウを移動する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.rbutton", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "RButton", mods: "", action: "ResizeWindowUnderCursor", note: "F10 + 右クリック押下中はカーソル下のウィンドウをリサイズする", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.mbutton", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "MButton", mods: "", action: "SendWindowUnderCursorToBack", note: "F10 + ホイールクリックでカーソル下のウィンドウを最背面へ送る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.wheelup", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "WheelUp", mods: "", action: "ZoomInDesktop", note: "F10 + ホイール上で Zoom In", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.wheeldown", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "WheelDown", mods: "", action: "ZoomOutDesktop", note: "F10 + ホイール下で Zoom Out", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.xbutton1", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "XButton1", mods: "", action: "SwitchVirtualDesktopLeft", note: "F10 + 戻るボタンを押し、戻るボタンを離した時点で左の仮想デスクトップへ移動する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.xbutton2", section: "NonEdit", trigger_role: "NonEdit", input_kind: "mouse", input_value: "XButton2", mods: "", action: "SwitchVirtualDesktopRight", note: "F10 + 進むボタンを押し、進むボタンを離した時点で右の仮想デスクトップへ移動する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyw", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyW", mods: "", action: "JumpHome", note: "", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keye", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyE", mods: "", action: "MoveUp", note: "F10 + e で↑。右手からマウスを離さず細かい移動を実現", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyr", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyR", mods: "", action: "PageUpAction", note: "", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyt", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyT", mods: "", action: "AlwaysOnTopToggle", note: "F10 + t で常に最前面に表示するウィンドウを切り替える。要PowerToys", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keys", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyS", mods: "", action: "MoveLeft", note: "F10 + s で←。右手からマウスを離さず細かい移動を実現", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyd", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyD", mods: "", action: "MoveDown", note: "F10 + d で↓。右手からマウスを離さず細かい移動を実現", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyf", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyF", mods: "", action: "MoveRight", note: "F10 + f で→。右手からマウスを離さず細かい移動を実現", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.enter", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "Enter", mods: "", action: "SendWinTab", note: "F10 + Enter で Windows タスクビューを開く", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyx", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyX", mods: "", action: "JumpEnd", note: "", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyv", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyV", mods: "", action: "PageDownAction", note: "", specificity: 0, requirements: []})
gMouseBindings.Push({id: "nonedit.keyc", section: "NonEdit", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyC", mods: "", action: "CopyFilePath", note: "", specificity: 0, requirements: []})
gMouseBindings.Push({id: "noneditselect.keyw", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyW", mods: "", action: "ExtendHome", note: "", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keye", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyE", mods: "", action: "ExtendUp", note: "F10 + Select + e で Shift+↑", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyr", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyR", mods: "", action: "ExtendPageUp", note: "", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyt", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyT", mods: "", action: "AlwaysOnTopToggle", note: "F10 + t で常に最前面に表示するウィンドウを切り替える。要PowerToys", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keys", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyS", mods: "", action: "ExtendLeft", note: "F10 + Select + s で Shift+←", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyd", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyD", mods: "", action: "ExtendDown", note: "F10 + Select + d で Shift+↓", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyf", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyF", mods: "", action: "ExtendRight", note: "F10 + Select + f で Shift+→", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyx", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyX", mods: "", action: "ExtendEnd", note: "", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyv", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyV", mods: "", action: "ExtendPageDown", note: "", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "noneditselect.keyc", section: "NonEditSelect", trigger_role: "NonEdit", input_kind: "code", input_value: "KeyC", mods: "", action: "CopyFilePath", note: "", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})
gMouseBindings.Push({id: "edit.rbutton", section: "Edit", trigger_role: "Edit", input_kind: "mouse", input_value: "RButton", mods: "", action: "RunClipboardTool", note: "F12 + 右クリックでクリップボードツールを起動する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.wheelup", section: "Edit", trigger_role: "Edit", input_kind: "mouse", input_value: "WheelUp", mods: "", action: "SendUndo", note: "F12 + ホイール上で Undo", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.wheeldown", section: "Edit", trigger_role: "Edit", input_kind: "mouse", input_value: "WheelDown", mods: "", action: "SendRedo", note: "F12 + ホイール下で Redo", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.xbutton1", section: "Edit", trigger_role: "Edit", input_kind: "mouse", input_value: "XButton1", mods: "", action: "GoBackToPreviousLocation", note: "@TODO F12 + 戻るボタンで前の場所に戻る", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.xbutton2", section: "Edit", trigger_role: "Edit", input_kind: "mouse", input_value: "XButton2", mods: "", action: "GoToForwardLocation", note: "@TODO F12 + 進むボタンで次の場所に進む", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.keys", section: "Edit", trigger_role: "Edit", input_kind: "code", input_value: "KeyS", mods: "", action: "TakeScreenshotAndSave", note: "F12 + s でスクリーンショットを撮影し、クリップ画像を自動保存する", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.enter", section: "Edit", trigger_role: "Edit", input_kind: "code", input_value: "Enter", mods: "", action: "CloseViewUnderCursor", note: "F12 + Enter でカーソル下のビューを閉じる", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.keyz", section: "Edit", trigger_role: "Edit", input_kind: "code", input_value: "KeyZ", mods: "", action: "SendUndo", note: "F12 + z で Undo。MouseGestureL の dispatch にも使う", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.keyx", section: "Edit", trigger_role: "Edit", input_kind: "code", input_value: "KeyX", mods: "", action: "SendCut", note: "F12 + x で Cut。MouseGestureL の dispatch にも使う", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.keyc", section: "Edit", trigger_role: "Edit", input_kind: "code", input_value: "KeyC", mods: "", action: "SendCopy", note: "F12 + c で Copy。MouseGestureL の dispatch にも使う", specificity: 0, requirements: []})
gMouseBindings.Push({id: "edit.keyv", section: "Edit", trigger_role: "Edit", input_kind: "code", input_value: "KeyV", mods: "", action: "PasteClipboardAsPlainText", note: "F12 + v でプレーンテキスト貼り付け", specificity: 0, requirements: []})
gMouseBindings.Push({id: "editselect.keys", section: "EditSelect", trigger_role: "Edit", input_kind: "code", input_value: "KeyS", mods: "", action: "TakeZoomItScreenshot", note: "F12 + Select + s で ZoomIt によるスクリーンショットを撮影し、クリップ画像は保存しない", specificity: 1, requirements: [{kind: "keyboard_role", keyboard_role: "Select"}]})

global gMouseKeyboardRoleHotkeys := {}
gMouseKeyboardRoleHotkeys["Select"] := "sc07B"

global gMouseTriggerHotkeys := {}
gMouseTriggerHotkeys["NonEdit"] := "F10"
gMouseTriggerHotkeys["Gesture"] := "F11"
gMouseTriggerHotkeys["Edit"] := "F12"

global gMouseTriggerDispatchRoles := []
gMouseTriggerDispatchRoles.Push("NonEdit")
gMouseTriggerDispatchRoles.Push("Edit")

global gMouseTriggerRoleActive := {}
global gMouseTriggerRoleUsed := {}
global gMouseTriggerPassthroughActions := {}
gMouseTriggerPassthroughActions["NonEdit"] := "SendF10"
gMouseTriggerPassthroughActions["Edit"] := "SendF12"

global gMouseGestureSettings := {}
gMouseGestureSettings["Gesture"] := {trigger_role: "Gesture", notation: "keypad8", threshold_px: 60, repeat_pause_ms: 160, sample_interval_ms: 10, max_length: 8, trail_enabled: true, trail_mode: "dots", trail_color: "00A6FF", trail_point_size_px: 6, trail_max_points: 48, cancel_mouse: "RButton"}
global gMouseGestureActive := false
global gMouseGestureTriggerRole := ""
global gMouseGestureTriggerHotkey := ""
global gMouseGestureTargetHwnd := ""
global gMouseGesturePattern := ""
global gMouseGestureCancelled := false
global gMouseGestureSegmentX := 0
global gMouseGestureSegmentY := 0
global gMouseGesturePreviousX := 0
global gMouseGesturePreviousY := 0
global gMouseGestureLastMovementAt := 0
global gMouseGestureLastDirection := ""
global gMouseGestureRepeatReady := false
global gMouseGestureTimerFunc := ""
global gMouseGestureTrailPoints := []

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
        Pause, On
    }
return

TucknTrayExit:
    ExitApp
return

; ------------------------------
; Generated mouse hotkeys
; ------------------------------
*F10::
    StartMouseTriggerRole("NonEdit")
return

*F10 Up::
    FinishMouseTriggerRole("NonEdit")
return

*F12::
    StartMouseTriggerRole("Edit")
return

*F12 Up::
    FinishMouseTriggerRole("Edit")
return

*F11::
    StartMouseGesture("Gesture")
return

*F11 Up::
    FinishMouseGesture("Gesture")
return

#If IsMouseGestureActive("Gesture")
*RButton::
    CancelMouseGesture("Gesture")
return

#If

WheelUp::
    DispatchMouseInput("mouse", "WheelUp")
return

WheelDown::
    DispatchMouseInput("mouse", "WheelDown")
return

XButton1::
    DispatchMouseInput("mouse", "XButton1")
return

XButton2::
    DispatchMouseInput("mouse", "XButton2")
return

#If IsMouseTriggerRoleActive("NonEdit")
*LButton::
    DispatchMouseBinding("NonEdit", "mouse", "LButton")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*RButton::
    DispatchMouseBinding("NonEdit", "mouse", "RButton")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*RButton::
    DispatchMouseBinding("Edit", "mouse", "RButton")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*MButton::
    DispatchMouseBinding("NonEdit", "mouse", "MButton")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*w::
    DispatchMouseBinding("NonEdit", "code", "KeyW")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*e::
    DispatchMouseBinding("NonEdit", "code", "KeyE")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*r::
    DispatchMouseBinding("NonEdit", "code", "KeyR")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*t::
    DispatchMouseBinding("NonEdit", "code", "KeyT")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*s::
    DispatchMouseBinding("NonEdit", "code", "KeyS")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*s::
    DispatchMouseBinding("Edit", "code", "KeyS")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*d::
    DispatchMouseBinding("NonEdit", "code", "KeyD")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*f::
    DispatchMouseBinding("NonEdit", "code", "KeyF")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*Enter::
    DispatchMouseBinding("NonEdit", "code", "Enter")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*Enter::
    DispatchMouseBinding("Edit", "code", "Enter")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*x::
    DispatchMouseBinding("NonEdit", "code", "KeyX")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*x::
    DispatchMouseBinding("Edit", "code", "KeyX")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*v::
    DispatchMouseBinding("NonEdit", "code", "KeyV")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*v::
    DispatchMouseBinding("Edit", "code", "KeyV")
return

#If

#If IsMouseTriggerRoleActive("NonEdit")
*c::
    DispatchMouseBinding("NonEdit", "code", "KeyC")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*c::
    DispatchMouseBinding("Edit", "code", "KeyC")
return

#If

#If IsMouseTriggerRoleActive("Edit")
*z::
    DispatchMouseBinding("Edit", "code", "KeyZ")
return

#If

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
; Runtime fragment: runtime/ahk/v1/MouseDispatcher.ahk
; --------------------------------------------
DispatchMouseAction(actionId) {
    ctx := GetMouseActionContext()
    ExecuteAction(actionId, ctx)
}

GetMouseActionContext() {
    global gMouseGestureTargetHwnd
    ctx := GetContext("mouse")
    if (gMouseGestureTargetHwnd != "")
        ctx.target_hwnd := gMouseGestureTargetHwnd
    return ctx
}

DispatchMouseBinding(triggerRole, inputKind, inputValue, mods := "") {
    binding := ResolveMouseBinding(triggerRole, inputKind, inputValue, mods)
    if !IsObject(binding)
        return
    if (triggerRole != "" && IsMouseTriggerRoleActive(triggerRole))
        MarkMouseTriggerRoleUsed(triggerRole)
    if !WaitForVirtualDesktopMouseRelease(binding)
        return
    DispatchMouseAction(binding.action)
}

DispatchMouseInput(inputKind, inputValue, mods := "") {
    global gMouseTriggerDispatchRoles

    if IsObject(gMouseTriggerDispatchRoles) {
        for index, triggerRole in gMouseTriggerDispatchRoles {
            if !IsMouseTriggerRoleActive(triggerRole)
                continue
            binding := ResolveMouseBinding(triggerRole, inputKind, inputValue, mods)
            if !IsObject(binding)
                continue
            MarkMouseTriggerRoleUsed(triggerRole)
            if !WaitForVirtualDesktopMouseRelease(binding)
                return
            DispatchMouseAction(binding.action)
            return
        }
    }

    DispatchMouseBinding("", inputKind, inputValue, mods)
}

WaitForVirtualDesktopMouseRelease(binding) {
    if (binding.input_kind != "mouse")
        return true
    if (binding.input_value != "XButton1" && binding.input_value != "XButton2")
        return true
    if (binding.action != "SwitchVirtualDesktopLeft" && binding.action != "SwitchVirtualDesktopRight")
        return true

    ; The binding and trigger use are captured before waiting, even if F10 is released first.
    ; Keep the existing post-action modifier-up recovery. Do not synthesize a mouse release.
    ; Abandon this action after 60 seconds if the physical release cannot be observed.
    KeyWait, % binding.input_value, T60
    return !ErrorLevel
}

StartMouseTriggerRole(triggerRole) {
    local
    global gMouseTriggerRoleActive, gMouseTriggerRoleUsed

    if !IsObject(gMouseTriggerRoleActive)
        return
    if (gMouseTriggerRoleActive.HasKey(triggerRole) && gMouseTriggerRoleActive[triggerRole])
        return

    gMouseTriggerRoleActive[triggerRole] := true
    gMouseTriggerRoleUsed[triggerRole] := false
}

FinishMouseTriggerRole(triggerRole) {
    local
    global gMouseTriggerRoleActive, gMouseTriggerRoleUsed, gMouseTriggerPassthroughActions

    if !IsObject(gMouseTriggerRoleActive)
        return
    if (!gMouseTriggerRoleActive.HasKey(triggerRole) || !gMouseTriggerRoleActive[triggerRole])
        return

    triggerWasUsed := gMouseTriggerRoleUsed.HasKey(triggerRole) && gMouseTriggerRoleUsed[triggerRole]
    gMouseTriggerRoleActive[triggerRole] := false
    gMouseTriggerRoleUsed[triggerRole] := false

    if (triggerWasUsed)
        return
    if !IsObject(gMouseTriggerPassthroughActions)
        return
    if !gMouseTriggerPassthroughActions.HasKey(triggerRole)
        return

    passthroughAction := gMouseTriggerPassthroughActions[triggerRole]
    if (passthroughAction = "")
        return
    DispatchMouseAction(passthroughAction)
}

IsMouseTriggerRoleActive(triggerRole) {
    global gMouseTriggerRoleActive

    if !IsObject(gMouseTriggerRoleActive)
        return false
    if (!gMouseTriggerRoleActive.HasKey(triggerRole) || !gMouseTriggerRoleActive[triggerRole])
        return false
    return IsMouseTriggerRoleHotkeyDown(triggerRole)
}

IsMouseTriggerRoleHotkeyDown(triggerRole) {
    global gMouseTriggerHotkeys

    if !IsObject(gMouseTriggerHotkeys)
        return false
    if !gMouseTriggerHotkeys.HasKey(triggerRole)
        return false
    hotkey := gMouseTriggerHotkeys[triggerRole]
    return GetKeyState(hotkey, "P") || GetKeyState(hotkey)
}

MarkMouseTriggerRoleUsed(triggerRole) {
    global gMouseTriggerRoleUsed

    if !IsObject(gMouseTriggerRoleUsed)
        return
    gMouseTriggerRoleUsed[triggerRole] := true
}

ResolveMouseBinding(triggerRole, inputKind, inputValue, mods := "") {
    global gMouseBindings
    bestBinding := ""
    bestSpecificity := -1

    for index, binding in gMouseBindings {
        if (binding.trigger_role != triggerRole)
            continue
        if (binding.input_kind != inputKind)
            continue
        if (binding.input_value != inputValue)
            continue
        if (binding.mods != mods)
            continue
        if !MouseBindingMatches(binding)
            continue
        if (binding.specificity > bestSpecificity) {
            bestBinding := binding
            bestSpecificity := binding.specificity
        }
    }

    return bestBinding
}

MouseBindingMatches(binding) {
    for index, requirement in binding.requirements {
        if (requirement.kind = "keyboard_role") {
            if !IsMouseKeyboardRoleDown(requirement.keyboard_role)
                return false
            continue
        }
        return false
    }
    return true
}

IsMouseKeyboardRoleDown(keyboardRole) {
    global gMouseKeyboardRoleHotkeys
    if !IsObject(gMouseKeyboardRoleHotkeys)
        return false
    if !gMouseKeyboardRoleHotkeys.HasKey(keyboardRole)
        return false
    return GetKeyState(gMouseKeyboardRoleHotkeys[keyboardRole], "P")
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/MouseGesture.ahk
; --------------------------------------------
StartMouseGesture(triggerRole) {
    global gMouseGestureActive
    global gMouseGestureTriggerRole
    global gMouseGestureTriggerHotkey
    global gMouseGesturePattern
    global gMouseGestureCancelled
    global gMouseGestureSegmentX
    global gMouseGestureSegmentY
    global gMouseGesturePreviousX
    global gMouseGesturePreviousY
    global gMouseGestureLastMovementAt
    global gMouseGestureLastDirection
    global gMouseGestureRepeatReady
    global gMouseGestureTimerFunc
    global gMouseGestureTrailPoints
    global gMouseGestureTargetHwnd

    if !IsMouseGestureConfigured(triggerRole)
        return
    if (gMouseGestureActive)
        return

    HideMouseGestureTrail()
    GetMouseGestureCursorPos(startX, startY)
    gMouseGestureTargetHwnd := GetMouseGestureTargetHwnd()
    gMouseGestureTriggerRole := triggerRole
    gMouseGestureTriggerHotkey := GetMouseTriggerHotkey(triggerRole, "")
    gMouseGesturePattern := ""
    gMouseGestureCancelled := false
    gMouseGestureSegmentX := startX
    gMouseGestureSegmentY := startY
    gMouseGesturePreviousX := startX
    gMouseGesturePreviousY := startY
    gMouseGestureLastMovementAt := A_TickCount
    gMouseGestureLastDirection := ""
    gMouseGestureRepeatReady := false
    gMouseGestureActive := true

    if !IsObject(gMouseGestureTimerFunc)
        gMouseGestureTimerFunc := Func("UpdateMouseGesture")
    sampleInterval := GetMouseGestureSetting(triggerRole, "sample_interval_ms", 10)
    SetTimer, % gMouseGestureTimerFunc, %sampleInterval%
    ShowMouseGestureTrail("start")
}

FinishMouseGesture(triggerRole) {
    global gMouseGestureActive
    global gMouseGestureTriggerRole
    global gMouseGesturePattern
    global gMouseGestureCancelled
    global gMouseGestureTargetHwnd

    if !IsMouseGestureActive(triggerRole)
        return

    pattern := gMouseGesturePattern
    cancelled := gMouseGestureCancelled
    gMouseGestureActive := false
    StopMouseGestureTimer()
    HideMouseGestureTrail()
    gMouseGestureTriggerRole := ""
    gMouseGesturePattern := ""
    gMouseGestureCancelled := false

    if (!cancelled && pattern != "")
        DispatchMouseBinding(triggerRole, "gesture", pattern)
    gMouseGestureTargetHwnd := ""
}

CancelMouseGesture(triggerRole := "") {
    global gMouseGestureActive
    global gMouseGestureTriggerRole
    global gMouseGesturePattern
    global gMouseGestureCancelled
    global gMouseGestureTargetHwnd

    if !IsMouseGestureActive(triggerRole)
        return

    gMouseGestureActive := false
    StopMouseGestureTimer()
    HideMouseGestureTrail()
    gMouseGestureTriggerRole := ""
    gMouseGesturePattern := ""
    gMouseGestureCancelled := true
    gMouseGestureTargetHwnd := ""
}

IsMouseGestureActive(triggerRole := "") {
    global gMouseGestureActive
    global gMouseGestureTriggerRole

    if !gMouseGestureActive
        return false
    return (triggerRole = "" || gMouseGestureTriggerRole = triggerRole)
}

IsMouseGestureConfigured(triggerRole) {
    global gMouseGestureSettings

    if !IsObject(gMouseGestureSettings)
        return false
    return gMouseGestureSettings.HasKey(triggerRole)
}

UpdateMouseGesture() {
    global gMouseGestureTriggerRole
    global gMouseGestureTriggerHotkey
    global gMouseGestureSegmentX
    global gMouseGestureSegmentY
    global gMouseGesturePreviousX
    global gMouseGesturePreviousY
    global gMouseGestureLastMovementAt
    global gMouseGestureRepeatReady

    if !IsMouseGestureActive() {
        StopMouseGestureTimer()
        return
    }
    if (gMouseGestureTriggerHotkey != "" && !GetKeyState(gMouseGestureTriggerHotkey, "P")) {
        FinishMouseGesture(gMouseGestureTriggerRole)
        return
    }

    GetMouseGestureCursorPos(mouseX, mouseY)
    sampleDx := mouseX - gMouseGesturePreviousX
    sampleDy := mouseY - gMouseGesturePreviousY
    if (Abs(sampleDx) > 2 || Abs(sampleDy) > 2) {
        gMouseGesturePreviousX := mouseX
        gMouseGesturePreviousY := mouseY
        gMouseGestureLastMovementAt := A_TickCount
        ShowMouseGestureTrail("move")
    } else if (A_TickCount - gMouseGestureLastMovementAt >= GetMouseGestureSetting(gMouseGestureTriggerRole, "repeat_pause_ms", 160)) {
        gMouseGestureRepeatReady := true
    }

    dx := mouseX - gMouseGestureSegmentX
    dy := mouseY - gMouseGestureSegmentY
    threshold := GetMouseGestureSetting(gMouseGestureTriggerRole, "threshold_px", 60)
    if (Abs(dx) < threshold && Abs(dy) < threshold)
        return

    direction := GetMouseGestureDirection(dx, dy)
    if (direction = "")
        return

    AppendMouseGestureDirection(direction)
    gMouseGestureSegmentX := mouseX
    gMouseGestureSegmentY := mouseY
    ShowMouseGestureTrail("pattern")
}

AppendMouseGestureDirection(direction) {
    global gMouseGestureTriggerRole
    global gMouseGesturePattern
    global gMouseGestureLastDirection
    global gMouseGestureRepeatReady

    if (direction != gMouseGestureLastDirection || gMouseGestureRepeatReady) {
        maxLength := GetMouseGestureSetting(gMouseGestureTriggerRole, "max_length", 8)
        if (StrLen(gMouseGesturePattern) < maxLength)
            gMouseGesturePattern .= direction
    }
    gMouseGestureLastDirection := direction
    gMouseGestureRepeatReady := false
}

GetMouseGestureDirection(dx, dy) {
    absX := Abs(dx)
    absY := Abs(dy)
    if (absX = 0 && absY = 0)
        return ""
    if (absX >= absY * 2)
        return (dx > 0) ? "6" : "4"
    if (absY >= absX * 2)
        return (dy > 0) ? "2" : "8"
    if (dx > 0 && dy > 0)
        return "3"
    if (dx > 0 && dy < 0)
        return "9"
    if (dx < 0 && dy > 0)
        return "1"
    if (dx < 0 && dy < 0)
        return "7"
    return ""
}

GetMouseGestureCursorPos(ByRef mouseX, ByRef mouseY) {
    savedCoordModeMouse := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY
    CoordMode, Mouse, %savedCoordModeMouse%
}

GetMouseGestureTargetHwnd() {
    savedCoordModeMouse := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseGetPos, , , hwnd
    CoordMode, Mouse, %savedCoordModeMouse%
    return hwnd
}

GetMouseGestureSetting(triggerRole, key, defaultValue) {
    global gMouseGestureSettings

    if !IsObject(gMouseGestureSettings)
        return defaultValue
    if !gMouseGestureSettings.HasKey(triggerRole)
        return defaultValue
    settings := gMouseGestureSettings[triggerRole]
    if !IsObject(settings)
        return defaultValue
    if !settings.HasKey(key)
        return defaultValue
    return settings[key]
}

ShowMouseGestureTrail(reason := "") {
    global gMouseGestureTriggerRole
    global gMouseGesturePattern

    if !IsMouseGestureActive()
        return
    if !GetMouseGestureSetting(gMouseGestureTriggerRole, "trail_enabled", true)
        return

    GetMouseGestureCursorPos(mouseX, mouseY)
    trailMode := GetMouseGestureSetting(gMouseGestureTriggerRole, "trail_mode", "tooltip")
    if (trailMode = "dots") {
        if (reason != "pattern")
            AddMouseGestureTrailDot(mouseX, mouseY)
        return
    }

    displayText := "Gesture: " . (gMouseGesturePattern = "" ? "." : gMouseGesturePattern)
    ToolTip, %displayText%, % mouseX + 16, % mouseY + 16, 20
}

HideMouseGestureTrail() {
    ToolTip, , , , 20
    ClearMouseGestureTrailDots()
    DestroyAllMouseGestureTrailWindows()
}

AddMouseGestureTrailDot(mouseX, mouseY) {
    global gMouseGestureTriggerRole
    global gMouseGestureTrailPoints

    if !IsMouseGestureActive()
        return
    if !IsObject(gMouseGestureTrailPoints)
        gMouseGestureTrailPoints := []

    pointSize := GetMouseGestureSetting(gMouseGestureTriggerRole, "trail_point_size_px", 6)
    color := GetMouseGestureSetting(gMouseGestureTriggerRole, "trail_color", "00A6FF")
    maxPoints := GetMouseGestureSetting(gMouseGestureTriggerRole, "trail_max_points", 48)
    xPos := mouseX - Floor(pointSize / 2)
    yPos := mouseY - Floor(pointSize / 2)
    pointIndex := gMouseGestureTrailPoints.Length() + 1
    guiName := "MouseGestureTrail" . A_TickCount . "_" . pointIndex
    trailTitle := GetMouseGestureTrailWindowTitle()

    Gui, %guiName%:New, +AlwaysOnTop -Caption +ToolWindow +E0x20 +HwndpointHwnd, %trailTitle%
    Gui, %guiName%:Color, %color%
    point := {name: guiName, hwnd: pointHwnd}
    gMouseGestureTrailPoints.Push(point)

    if !IsMouseGestureActive() {
        DestroyMouseGestureTrailDot(point)
        return
    }

    try {
        Gui, %guiName%:Show, x%xPos% y%yPos% w%pointSize% h%pointSize% NoActivate
        WinSet, Transparent, 220, ahk_id %pointHwnd%
    } catch err {
        DestroyMouseGestureTrailDot(point)
        OutputDebug, % "Gesture trail creation failed: " . err.Message
        return
    }

    while (gMouseGestureTrailPoints.Length() > maxPoints) {
        oldPoint := gMouseGestureTrailPoints.RemoveAt(1)
        DestroyMouseGestureTrailDot(oldPoint)
    }
}

ClearMouseGestureTrailDots() {
    global gMouseGestureTrailPoints

    if !IsObject(gMouseGestureTrailPoints) {
        gMouseGestureTrailPoints := []
        return
    }
    pointsToDestroy := gMouseGestureTrailPoints
    gMouseGestureTrailPoints := []
    for index, point in pointsToDestroy
        DestroyMouseGestureTrailDot(point)
}

DestroyMouseGestureTrailDot(point) {
    local

    if !IsObject(point)
        return
    ; These are our own GUIs. WinHide adds A_WinDelay (100ms by default) per dot.
    if point.HasKey("name") {
        guiName := point.name
        try {
            Gui, %guiName%:Hide
        } catch err {
            OutputDebug, % "Gesture trail Hide failed: " . err.Message
        }
        try {
            Gui, %guiName%:Destroy
        } catch err {
            OutputDebug, % "Gesture trail Destroy failed: " . err.Message
        }
    }
}

DestroyAllMouseGestureTrailWindows() {
    local

    title := GetMouseGestureTrailWindowTitle()
    pid := DllCall("GetCurrentProcessId", "UInt")
    WinGet, trailHwnds, List, % title . " ahk_pid " . pid
    Loop, %trailHwnds% {
        hwnd := trailHwnds%A_Index%
        ; The PID/title filter selects our trail GUIs; Gui also accepts an HWND.
        ; Avoid WinHide here too so orphan recovery has no per-dot window delay.
        try {
            Gui, %hwnd%:Hide
        } catch err {
            OutputDebug, % "Gesture trail orphan Hide failed: " . err.Message
        }
        try {
            Gui, %hwnd%:Destroy
        } catch err {
            OutputDebug, % "Gesture trail cleanup failed: " . err.Message
        }
    }
}

GetMouseGestureTrailWindowTitle() {
    return "TucknGestureTrail"
}

StopMouseGestureTimer() {
    global gMouseGestureTimerFunc

    if IsObject(gMouseGestureTimerFunc)
        SetTimer, % gMouseGestureTimerFunc, Off
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/MouseActions.ahk
; --------------------------------------------
MoveWindowUnderCursor() {
    DragWindowUnderCursor(GetMouseTriggerHotkey("NonEdit", "F10"), "LButton")
}

ResizeWindowUnderCursor() {
    DragResizeWindowUnderCursor(GetMouseTriggerHotkey("NonEdit", "F10"), "RButton")
}

SendWindowUnderCursorToBack() {
    winHwnd := GetActionContextTargetHwndForMouseAction()
    if (winHwnd = "")
        winHwnd := GetWindowHwndUnderCursor()
    if (winHwnd = "")
        return

    WinActivate, % "ahk_id " . winHwnd
    WinWaitActive, % "ahk_id " . winHwnd,, 0.2
    if !WinActive("ahk_id " . winHwnd)
        return

    SendInput, !{Esc}
}

AcceleratedScrollUp() {
    AcceleratedScroll("WheelUp")
}

AcceleratedScrollDown() {
    AcceleratedScroll("WheelDown")
}

AcceleratedScroll(direction) {
    static lastDirection := ""
    static lastAt := 0
    static distance := 0
    static vmax := 1

    if !ShouldUseAcceleratedScroll() {
        lastDirection := ""
        lastAt := 0
        distance := 0
        vmax := 1
        MouseClick, %direction%
        return
    }

    timeout := GetAcceleratedScrollTimeoutMs()
    fastInterval := GetAcceleratedScrollFastIntervalMs()
    startDistance := GetAcceleratedScrollStartDistance()
    curve := GetAcceleratedScrollCurve()
    boost := GetAcceleratedScrollBoost()
    limit := GetAcceleratedScrollLimit()

    now := A_TickCount
    elapsed := (lastAt > 0) ? (now - lastAt) : timeout + 1
    if (direction = lastDirection && elapsed < timeout) {
        distance += 1
        isFast := (distance >= startDistance && elapsed < fastInterval && elapsed > 1)
        if (isFast) {
            velocity := (curve / elapsed) - 1
        } else {
            velocity := 1
            if (elapsed >= fastInterval)
                vmax := 1
        }

        if (isFast && boost > 1 && distance > boost) {
            if (velocity > vmax)
                vmax := velocity
            else
                velocity := vmax
            velocity *= distance / boost
        }

        if (velocity > 1) {
            velocity := (velocity > limit) ? limit : Floor(velocity)
        } else {
            velocity := 1
        }
    } else {
        distance := 0
        vmax := 1
        velocity := 1
    }

    lastDirection := direction
    lastAt := now
    MouseClick, %direction%, , , %velocity%
}

ShouldUseAcceleratedScroll() {
    if !GetAcceleratedScrollEnabled()
        return false

    appName := GetAcceleratedScrollAppName()
    disabledApps := GetLocalConfigValue("Mouse", "disabled_apps", "")
    if (disabledApps = "")
        disabledApps := GetLocalConfigValue("Mouse", "accelerated_scroll_disabled_apps", "")
    if (disabledApps = "")
        return true

    return !ConfigListContains(disabledApps, appName)
}

GetAcceleratedScrollEnabled() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_enabled", "1")
    StringLower, normalizedValue, value
    return !(normalizedValue = "0" || normalizedValue = "false" || normalizedValue = "off" || normalizedValue = "no")
}

GetAcceleratedScrollTimeoutMs() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_timeout_ms", "500")
    return GetConfigInteger(value, 500, 1, 5000)
}

GetAcceleratedScrollFastIntervalMs() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_fast_interval_ms", "60")
    return GetConfigInteger(value, 60, 1, 500)
}

GetAcceleratedScrollStartDistance() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_start_distance", "3")
    return GetConfigInteger(value, 3, 1, 50)
}

GetAcceleratedScrollCurve() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_curve", "250")
    return GetConfigInteger(value, 250, 1, 5000)
}

GetAcceleratedScrollBoost() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_boost", "30")
    return GetConfigInteger(value, 30, 0, 1000)
}

GetAcceleratedScrollLimit() {
    value := GetLocalConfigValue("Mouse", "accelerated_scroll_limit", "80")
    return GetConfigInteger(value, 80, 1, 300)
}

GetConfigInteger(value, defaultValue, minValue, maxValue) {
    if !RegExMatch(value, "^\s*\d+\s*$")
        return defaultValue
    number := value + 0
    if (number < minValue || number > maxValue)
        return defaultValue
    return Floor(number)
}

GetAcceleratedScrollAppName() {
    ctx := GetCurrentActionContext()
    if IsObject(ctx) && ctx.app != ""
        return ctx.app

    WinGet, appName, ProcessName, A
    return appName
}

ConfigListContains(listText, targetValue) {
    if (targetValue = "")
        return false

    StringLower, normalizedTarget, targetValue
    Loop, Parse, listText, CSV
    {
        item := Trim(A_LoopField, " `t")
        if (item = "")
            continue
        StringLower, normalizedItem, item
        if (normalizedItem = normalizedTarget)
            return true
    }
    return false
}

GetMouseTriggerHotkey(triggerRole, defaultHotkey := "") {
    global gMouseTriggerHotkeys
    if IsObject(gMouseTriggerHotkeys) && gMouseTriggerHotkeys.HasKey(triggerRole)
        return gMouseTriggerHotkeys[triggerRole]
    return defaultHotkey
}

GetWindowHwndUnderCursor() {
    savedCoordModeMouse := A_CoordModeMouse
    CoordMode, Mouse, Screen

    MouseGetPos, , , winHwnd

    CoordMode, Mouse, %savedCoordModeMouse%
    return winHwnd
}

GetActionContextTargetHwndForMouseAction() {
    ctx := GetCurrentActionContext()
    if !IsObject(ctx)
        return ""
    if !ctx.HasKey("target_hwnd")
        return ""
    return ctx.target_hwnd
}

DragWindowUnderCursor(triggerKey, mouseButton) {
    if (triggerKey = "" || mouseButton = "")
        return

    savedCoordModeMouse := A_CoordModeMouse
    CoordMode, Mouse, Screen

    MouseGetPos, startX, startY, winHwnd
    if (winHwnd = "") {
        CoordMode, Mouse, %savedCoordModeMouse%
        return
    }

    startedAt := A_TickCount
    WinGetPos, winX, winY, , , % "ahk_id " . winHwnd
    while ShouldContinueMouseDrag(triggerKey, mouseButton, startedAt) {
        MouseGetPos, nowX, nowY
        lenX := startX - nowX
        lenY := startY - nowY
        WinMove, % "ahk_id " . winHwnd, , % winX - lenX, % winY - lenY
        Sleep, 10
    }

    CoordMode, Mouse, %savedCoordModeMouse%
}

DragResizeWindowUnderCursor(triggerKey, mouseButton) {
    if (triggerKey = "" || mouseButton = "")
        return

    savedCoordModeMouse := A_CoordModeMouse
    CoordMode, Mouse, Screen

    MouseGetPos, startX, startY, winHwnd
    if (winHwnd = "") {
        CoordMode, Mouse, %savedCoordModeMouse%
        return
    }

    startedAt := A_TickCount
    WinGetPos, winX, winY, winW, winH, % "ahk_id " . winHwnd
    while ShouldContinueMouseDrag(triggerKey, mouseButton, startedAt) {
        MouseGetPos, nowX, nowY
        lenX := startX - nowX
        lenY := startY - nowY

        if GetKeyState("Shift", "P") {
            WinMove, % "ahk_id " . winHwnd, , % winX - lenX, % winY - lenY, % winW + lenX, % winH + lenY
        } else {
            WinMove, % "ahk_id " . winHwnd, , , , % winW - lenX, % winH - lenY
        }
        Sleep, 10
    }

    CoordMode, Mouse, %savedCoordModeMouse%
}

ShouldContinueMouseDrag(triggerKey, mouseButton, startedAt, timeoutMs := 60000) {
    if !GetKeyState(triggerKey, "P")
        return false
    if !GetKeyState(mouseButton, "P")
        return false
    if GetKeyState("Escape", "P")
        return false
    return (A_TickCount - startedAt) < timeoutMs
}

; --------------------------------------------
; Runtime fragment: runtime/ahk/v1/SpecialActions.ahk
; --------------------------------------------
PasteClipboardAsPlainText() {
    plainText := Clipboard
    if (plainText = "")
        return
    PasteText(plainText)
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

CopyFilePath() {
    pathText := GetCopyFilePathText()
    if (pathText = "")
        return
    Clipboard := pathText
}

ZoomInDesktop() {
    if !EnsureMagnifierRunning() {
        ReleaseDesktopToolActionKeys()
        return
    }

    SendInput, #{NumpadAdd}
    ReleaseDesktopToolActionKeys()
}

ZoomOutDesktop() {
    if !IsMagnifierRunning() {
        EnsureMagnifierRunning()
        ReleaseDesktopToolActionKeys()
        return
    }

    SendInput, #{NumpadSub}
    ReleaseDesktopToolActionKeys()
}

SwitchVirtualDesktopLeft() {
    SwitchVirtualDesktop("Left")
}

SwitchVirtualDesktopRight() {
    SwitchVirtualDesktop("Right")
}

SwitchVirtualDesktop(direction) {
    static lastTick := 0

    if (direction != "Left" && direction != "Right")
        return

    now := A_TickCount
    if (lastTick != 0 && now - lastTick < 350)
        return
    lastTick := now

    SendInput, % "{LCtrl down}{LWin down}{" . direction . "}{LWin up}{LCtrl up}"
    ReleaseDesktopToolActionKeys()
}

ReleaseDesktopToolActionKeys() {
    SendInput, {LCtrl up}{RCtrl up}{Ctrl up}{LWin up}{RWin up}{F10 up}
}

GetCopyFilePathText() {
    WinGet, activeHwnd, ID, A
    if (activeHwnd = "")
        return ""

    WinGet, processName, ProcessName, % "ahk_id " . activeHwnd
    if (processName = "explorer.exe")
        return GetExplorerCopyFilePathText(activeHwnd)
    if (processName = "FreeCommander.exe")
        return GetFreeCommanderCopyFilePathText(activeHwnd)
    if (processName = "EXCEL.EXE" || processName = "excel.exe")
        return GetExcelCopyFilePathText(activeHwnd)
    if (processName = "Code.exe")
        return GetVsCodeCopyFilePathText(activeHwnd)
    if (processName = "sakura.exe")
        return GetSakuraCopyFilePathText(activeHwnd)

    return ""
}

GetFreeCommanderCopyFilePathText(activeHwnd) {
    pathText := GetClipboardTextByShortcut(activeHwnd, "!{Ins}")
    if (pathText != "")
        return pathText

    return GetClipboardTextByShortcut(activeHwnd, "^!{Ins}")
}

GetExcelCopyFilePathText(activeHwnd) {
    try xlApp := ComObjActive("Excel.Application")
    catch e
        return ""

    if !IsObject(xlApp)
        return ""

    try appHwnd := xlApp.Hwnd
    catch e
        appHwnd := ""

    if (appHwnd != "") {
        WinGet, activePid, PID, % "ahk_id " . activeHwnd
        WinGet, appPid, PID, % "ahk_id " . appHwnd
        if (activePid != "" && appPid != "" && activePid != appPid)
            return ""
    }

    workbook := GetExcelActiveWorkbook(xlApp)
    if !IsObject(workbook)
        return ""

    try workbookPath := workbook.Path
    catch e
        workbookPath := ""

    if (workbookPath = "")
        return ""

    try workbookFullName := workbook.FullName
    catch e
        workbookFullName := ""

    if (workbookFullName != "")
        return workbookFullName

    try workbookName := workbook.Name
    catch e
        workbookName := ""

    if (workbookName = "")
        return ""

    return workbookPath . "\" . workbookName
}

GetExcelActiveWorkbook(xlApp) {
    try workbook := xlApp.ActiveWorkbook
    catch e
        workbook := ""

    if IsObject(workbook)
        return workbook

    try protectedViewWindow := xlApp.ActiveProtectedViewWindow
    catch e
        protectedViewWindow := ""

    if !IsObject(protectedViewWindow)
        return ""

    try workbook := protectedViewWindow.Workbook
    catch e
        workbook := ""

    if IsObject(workbook)
        return workbook
    return ""
}

GetVsCodeCopyFilePathText(activeHwnd) {
    return GetClipboardTextByChord(activeHwnd, "^k", "p")
}

GetSakuraCopyFilePathText(activeHwnd) {
    return GetClipboardTextByCommand(activeHwnd, 30620)
}

GetClipboardTextByShortcut(activeHwnd, shortcut, timeoutSeconds := 1.0) {
    savedClipboard := PrepareClipboardCapture()
    WinActivate, % "ahk_id " . activeHwnd
    SendInput, % shortcut
    return WaitForCapturedClipboardText(savedClipboard, timeoutSeconds)
}

GetClipboardTextByChord(activeHwnd, firstShortcut, secondShortcut, timeoutSeconds := 1.0) {
    savedClipboard := PrepareClipboardCapture()
    WinActivate, % "ahk_id " . activeHwnd
    SendInput, % firstShortcut
    Sleep, 50
    SendInput, % secondShortcut
    return WaitForCapturedClipboardText(savedClipboard, timeoutSeconds)
}

GetClipboardTextByCommand(activeHwnd, commandId, timeoutSeconds := 1.0) {
    savedClipboard := PrepareClipboardCapture()
    PostMessage, 0x111, %commandId%, 0,, % "ahk_id " . activeHwnd
    return WaitForCapturedClipboardText(savedClipboard, timeoutSeconds)
}

PrepareClipboardCapture() {
    savedClipboard := ClipboardAll
    Clipboard := ""
    return savedClipboard
}

WaitForCapturedClipboardText(savedClipboard, timeoutSeconds := 1.0) {
    ClipWait, % timeoutSeconds
    if (ErrorLevel) {
        Clipboard := savedClipboard
        return ""
    }

    clipboardText := Clipboard
    if (clipboardText = "") {
        Clipboard := savedClipboard
        return ""
    }

    return clipboardText
}

GetExplorerCopyFilePathText(activeHwnd) {
    for explorerWindow in ComObjCreate("Shell.Application").Windows
    {
        try windowHwnd := explorerWindow.HWND
        catch e
            continue

        if (windowHwnd != activeHwnd)
            continue

        pathText := GetExplorerSelectedPathText(explorerWindow)
        if (pathText != "")
            return pathText

        return GetExplorerFolderPathText(explorerWindow)
    }

    return ""
}

GetExplorerSelectedPathText(explorerWindow) {
    paths := ""

    try selectedItems := explorerWindow.Document.SelectedItems
    catch e
        return ""

    if !IsObject(selectedItems)
        return ""

    selectedCount := selectedItems.Count
    if (selectedCount <= 0)
        return ""

    Loop, % selectedCount
    {
        item := selectedItems.Item(A_Index - 1)
        if !IsObject(item)
            continue

        try itemPath := item.Path
        catch e
            itemPath := ""

        if (itemPath = "")
            continue

        if (paths != "")
            paths .= "`r`n"
        paths .= itemPath
    }

    return paths
}

GetExplorerFolderPathText(explorerWindow) {
    try folderPath := explorerWindow.Document.Folder.Self.Path
    catch e
        folderPath := ""

    return folderPath
}

GetClipboardToolCommand() {
    return GetLocalConfigValue("Tools", "ClipboardToolCommand", "")
}

GetMagnifierCommand() {
    return GetLocalConfigValue("Tools", "MagnifierCommand", "C:\Windows\System32\Magnify.exe")
}

GetMagnifierExeName() {
    command := GetMagnifierCommand()
    SplitPath, command, outName
    if (outName = "")
        return "Magnify.exe"
    return outName
}

IsMagnifierRunning() {
    return WinExist("ahk_exe " . GetMagnifierExeName()) != 0
}

EnsureMagnifierRunning(timeoutMs := 2000) {
    if IsMagnifierRunning()
        return true
    if !RunMagnifier()
        return false

    startedAt := A_TickCount
    while !IsMagnifierRunning() {
        if ((A_TickCount - startedAt) >= timeoutMs)
            return false
        Sleep, 50
    }

    Sleep, 100
    return true
}

RunMagnifier() {
    command := GetMagnifierCommand()
    if (command = "")
        return false

    Run, % command,, UseErrorLevel
    return ErrorLevel != "ERROR"
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

GoBackToPreviousLocation() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    if IsExcelVbaWindow(win) {
        SendViewShortcut("+^{F2}")
        return
    }
    if IsExcelWindow(win) {
        SendViewShortcut("^{PgUp}")
        return
    }
    if IsIrfanViewWindow(win) {
        SendViewShortcut("{BS}")
        return
    }
    if IsMassiGraWindow(win) {
        SendViewShortcut("{BS}")
        return
    }
    if IsVisualStudioWindow(win) {
        SendViewShortcut("^{-}")
        return
    }
    if IsObsidianWindow(win) {
        SendViewShortcut("^!{Left}")
        return
    }

    SendViewShortcut("!{Left}")
}

GoToForwardLocation() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    if IsExcelWindow(win) {
        SendViewShortcut("^{PgDn}")
        return
    }
    if IsVisualStudioWindow(win) {
        SendViewShortcut("^+{-}")
        return
    }
    if IsObsidianWindow(win) {
        SendViewShortcut("^!{Right}")
        return
    }

    SendViewShortcut("!{Right}")
}

CloseViewUnderCursor() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    if IsBrowserWindowForViewAction(win) {
        SendEscThenViewShortcut("^w")
        return
    }
    if SupportsCloseViewShortcut(win) {
        SendViewShortcut("^w")
        return
    }
}

RestoreOrMinimizeWindow() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    SendViewShortcut("#{Down}")
}

MaximizeOrSnapWindowUp() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    SendViewShortcut("#{Up}")
}

JumpToTop() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    if IsExcelWindow(win) {
        SendViewShortcut("^{Up}")
        return
    }
    SendViewShortcut("{Home}")
}

JumpToBottom() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    if IsExcelWindow(win) {
        SendViewShortcut("^{Down}")
        return
    }
    SendViewShortcut("{End}")
}

OpenParentLocation() {
    win := PrepareWindowUnderCursorForViewAction()
    if !IsObject(win)
        return

    SendViewShortcut("{BS}")
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

SupportsCloseViewShortcut(win) {
    return IsBrowserWindowForViewAction(win)
        || win.process_name = "Code.exe"
        || IsObsidianWindow(win)
        || win.process_name = "explorer.exe"
        || win.process_name = "FreeCommander.exe"
}

IsBrowserWindowForViewAction(win) {
    return win.process_name = "chrome.exe"
        || win.process_name = "msedge.exe"
        || win.process_name = "firefox.exe"
        || win.process_name = "brave.exe"
        || win.process_name = "vivaldi.exe"
        || win.process_name = "opera.exe"
        || win.process_name = "iexplore.exe"
}

IsExcelVbaWindow(win) {
    return win.win_class = "wndclass_desked_gsk"
}

IsExcelWindow(win) {
    return win.process_name = "EXCEL.EXE" || win.process_name = "excel.exe"
}

IsIrfanViewWindow(win) {
    return win.win_class = "IrfanView"
}

IsMassiGraWindow(win) {
    return win.process_name = "MassiGra.exe"
}

IsVisualStudioWindow(win) {
    return win.process_name = "devenv.exe"
}

IsObsidianWindow(win) {
    return win.process_name = "Obsidian.exe"
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

