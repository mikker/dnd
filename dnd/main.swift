//
//  main.swift
//  dnd-toggle
//
//  Created by Mikkel Malmberg on 30/06/2020.
//

import Foundation

let version = "1.0.0"

func dndOn() -> Bool {
  let state =
    CFPreferencesCopyValue(
      "doNotDisturb" as CFString, "com.apple.notificationcenterui" as CFString,
      kCFPreferencesCurrentUser, kCFPreferencesCurrentHost) as! Bool
  return state
}

func commitDNDChanges() {
  CFPreferencesSynchronize(
    "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser,
    kCFPreferencesCurrentHost)
  DistributedNotificationCenter.default().postNotificationName(
    NSNotification.Name(rawValue: "com.apple.notificationcenterui.dndprefs_changed"), object: nil,
    userInfo: nil, deliverImmediately: true)
}

func enableDND() {
  CFPreferencesSetValue(
    "dndStart" as CFString, CGFloat(0) as CFPropertyList,
    "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser,
    kCFPreferencesCurrentHost)

  CFPreferencesSetValue(
    "dndEnd" as CFString, CGFloat(1440) as CFPropertyList,
    "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser,
    kCFPreferencesCurrentHost)

  CFPreferencesSetValue(
    "doNotDisturb" as CFString, true as CFPropertyList,
    "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser,
    kCFPreferencesCurrentHost)

  commitDNDChanges()
}

func disableDND() {
  CFPreferencesSetValue(
    "dndStart" as CFString, nil, "com.apple.notificationcenterui" as CFString,
    kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)

  CFPreferencesSetValue(
    "dndEnd" as CFString, nil, "com.apple.notificationcenterui" as CFString,
    kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)

  CFPreferencesSetValue(
    "doNotDisturb" as CFString, false as CFPropertyList,
    "com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser,
    kCFPreferencesCurrentHost)
  
  commitDNDChanges()
}

enum Cmd {
  case toggle
  case on
  case off
  case usage
  case version
}

var cmd: Cmd
if CommandLine.arguments.count == 1 {
  cmd = .usage
} else {
  switch CommandLine.arguments[1] {
  case "on":
    cmd = .on
    break
  case "off":
    cmd = .off
    break
  case "toggle":
    cmd = .toggle
    break
  case "version":
    cmd = .version
    break
  default:
    cmd = .usage
    break
  }
}

switch cmd {
case .usage:
  print("dnd [on|off|toggle|usage|version]")
  exit(1)
case .version:
  print(version)
  break
case .on:
  enableDND()
  break
case .off:
  disableDND()
  break
case .toggle:
  dndOn() ? disableDND() : enableDND()
  break
}
