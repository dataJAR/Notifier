//
//  AppDelegate.swift
//  Notifier - Alerts
//
//  Copyright © 2024 dataJAR Ltd. All rights reserved.
//

// Imports
import Cocoa
import UserNotifications

// Declaration
@NSApplicationMain
// The apps class
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    // IBOutlet declaration
    @IBOutlet weak var window: NSWindow!
    // When we've finished launching
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Exit if notificaiton center isn't running for the user
        isNotificationCenterRunning()
        // The first argument is always the executable, drop it
        let passedArgs = Array(CommandLine.arguments.dropFirst())
        // If no args passed, show help
        if passedArgs.isEmpty {
            // If no args, show help
            _ = ArgParser.parseOrExit(["--help"])
            // If we have args
        } else {
            // Get the parsed args
            let parsedResult = ArgParser.parseOrExit(passedArgs)
            // Ask permission
            requestAuthorisation(parsedResult: parsedResult)
            // See if we have any .userInfo when launched, such as from user interaction
            if let response = (aNotification as NSNotification).userInfo?[
                // Launch the app with the response in the .userInfo
                NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
                // Handle the notification
                handleUNNotification(forResponse: response)
            }
            // Create a notification center object
            let ncCenter =  UNUserNotificationCenter.current()
            // Set delegate
            ncCenter.delegate = self
            // If verbose mode is set
            if parsedResult.verbose {
                // Progress log
                NSLog("Notifier Log: alert - verbose enabled")
            }
            // Process the arguments as needed
            processArguments(ncCenter: ncCenter, parsedResult: parsedResult)
        }
    }
}

// Process the arguments as needed
func processArguments(ncCenter: UNUserNotificationCenter, parsedResult: ArgParser) {
    // Var declaration
    var notificationString = ""
    // Create a notification content object
    var ncContent = UNMutableNotificationContent()
    // If we're to remove all delivered notifications
    if parsedResult.remove.lowercased() == "all" {
        // Remove all notifications
        removeAllPriorNotifications(ncCenter: ncCenter, parsedResult: parsedResult)
    // If we're not removing
    } else {
        // Confirm that we have a message
        if parsedResult.message != "" {
            // Create the notifications body
            (ncContent, notificationString) = addNotificationBody(ncContent: ncContent,
                                                                  notificationString: notificationString,
                                                                  parsedResult: parsedResult)
        }
        // If we have a value for messageaction passed
        if parsedResult.messageaction != "" {
            // Add the notification message action
            (ncContent, notificationString) = addNotificationBodyOrButtonAction(contentKey: "messageAction",
                                                                                ncContent: ncContent,
                                                                                notificationString: notificationString,
                                                                                parsedResult: parsedResult)
        }
        // Process the notifications message button, this is performed whether set or not
        (ncContent, notificationString) = processNotificationButton(ncCenter: ncCenter, ncContent: ncContent,
                                                                    notificationString: notificationString,
                                                                    parsedResult: parsedResult)

        // If we have a value for messagebuttonaction passed
        if parsedResult.messagebuttonaction != "" {
            // Set the notifications message button
            (ncContent, notificationString) = addNotificationBodyOrButtonAction(contentKey: "messageButtonAction",
                                                                                ncContent: ncContent,
                                                                                notificationString: notificationString,
                                                                                parsedResult: parsedResult)
        }
        // If we have a value for sound passed
        if parsedResult.sound != "" {
            // Add sound to the notification
            (ncContent, notificationString) = addNotificationSound(ncContent: ncContent,
                                                                   notificationString: notificationString,
                                                                   parsedResult: parsedResult)
        }
        // If we have a value for subtitle
        if parsedResult.subtitle != "" {
            // Add the subtitle to the notification
            (ncContent, notificationString) = addNotificationSubtitleOrTitle(contentKey: "subtitle",
                                                                             ncContent: ncContent,
                                                                             notificationString: notificationString,
                                                                             parsedResult: parsedResult)
        }
        // If we have a value for title
        if parsedResult.title != "" {
            // Add the title to the notification
            (ncContent, notificationString) = addNotificationSubtitleOrTitle(contentKey: "title", ncContent: ncContent,
                                                                             notificationString: notificationString,
                                                                             parsedResult: parsedResult)
        }
        // If we're to remove prior posted notificastions
        if parsedResult.remove.lowercased() == "prior" {
            // Remove a specific prior posted notification
            removePriorNotification(ncCenter: ncCenter, notificationString: notificationString,
                                    parsedResult: parsedResult)
        // If we're not removing
        } else {
            // Post the notification
            postNotification(ncCenter: ncCenter, ncContent: ncContent,
                             notificationString: notificationString, parsedResult: parsedResult)
        }
    }
}
