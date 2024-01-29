//
//  UserNotifications.swift
//  Notifiers - Alerts
//
//  Copyright © 2024 dataJAR Ltd. All rights reserved.
//

// Imports
import UserNotifications

// Add the notifications body
func addNotificationBody(ncContent: UNMutableNotificationContent, notificationString: String,
                         parsedResult: ArgParser) -> (UNMutableNotificationContent, String) {
    // Var declaration
    var tempString = notificationString
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - message")
    }
    // Set the message to the body of the notification
    ncContent.body = parsedResult.message
    // Append to tempString
    tempString += ncContent.body
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - notificationString - \(tempString)")
    }
    // Return the modified vars
    return(ncContent, tempString)
}

// Adds an action to the notification body
func addNotificationBodyOrButtonAction(contentKey: String, ncContent: UNMutableNotificationContent,
                                       notificationString: String, parsedResult: ArgParser)
                                       -> (UNMutableNotificationContent, String) {
    // Var declaration
    var tempString = notificationString
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - \(contentKey)")
    }
    // If we're looking at the messageAction
    if contentKey == "messageAction" {
        // If the action, in lowercase is logout
        if parsedResult.messageaction.lowercased() == "logout" {
            // Set the action in .userinfo to logout
            ncContent.userInfo[contentKey] = "logout"
            // Append action to notificationString
            tempString += "logout"
            // If we're in verbose mode
            if parsedResult.verbose {
                // Progress log
                NSLog("\(#function.components(separatedBy: "(")[0]) - added action: logout")
            }
        // If the action isn't logout
        } else {
            // Set the action in .userinfo
            ncContent.userInfo[contentKey] = parsedResult.messageaction
            // Append action to notificationString
            tempString += "\(String(describing: parsedResult.messageaction))"
            // If we're in verbose mode
            if parsedResult.verbose {
                // Progress log
                NSLog("\(#function.components(separatedBy: "(")[0]) - added action: \(parsedResult.messageaction)")
            }
        }
    // If we're looking at messeageButtonAction
    } else {
        // If the action, in lowercase is logout
        if parsedResult.messagebuttonaction.lowercased() == "logout" {
            // Set the action in .userinfo to logout
            ncContent.userInfo[contentKey] = "logout"
            // Append action to notificationString
            tempString += "logout"
        // If the action isn't logout
        } else {
            // Set the action in .userinfo
            ncContent.userInfo[contentKey] = parsedResult.messagebuttonaction
            // Append action to notificationString
            tempString += "\(String(describing: parsedResult.messagebuttonaction))"
        }
        // If we're in verbose mode
        if parsedResult.verbose {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - notificationString - \(tempString)")
        }
    }
    // Return the modified vars
    return(ncContent, tempString)
}

// Adds a sound to the notification, which is played on delivery
func addNotificationSound(ncContent: UNMutableNotificationContent, notificationString: String,
                          parsedResult: ArgParser) -> (UNMutableNotificationContent, String) {
    // Var declaration
    var tempString = notificationString
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - sound")
    }
    // If we've been passed default for the sound
    if parsedResult.sound.lowercased() == "default" {
        // Set the notifications sound, to macOS's default
        ncContent.sound = UNNotificationSound.default
        // Append to notificationString
        tempString += "\(String(describing: parsedResult.sound))"
        // If we're in verbose mode
        if parsedResult.verbose {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - notificationString - \(tempString)")
        }
    // If we've been passed another sound
    } else {
        // Set the notifications sound
        ncContent.sound = UNNotificationSound(named:
                                                UNNotificationSoundName(rawValue:
                                                                            parsedResult.sound))
        // Append to notificationString
        tempString += "\(String(describing: parsedResult.sound))"
        // If we're in verbose mode
        if parsedResult.verbose {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - notificationString - \(tempString)")
        }
    }
    // Return the modified vars
    return(ncContent, tempString)
}

// Adds a subtitle or title to the notification
func addNotificationSubtitleOrTitle(contentKey: String, ncContent: UNMutableNotificationContent,
                                    notificationString: String, parsedResult: ArgParser)
                                    -> (UNMutableNotificationContent, String) {
    // Var declaration
    var tempString = notificationString
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - \(contentKey)")
    }
    // If we're to set the subtitle
    if contentKey == "subtitle" {
        // Set the notifications subtitle
        ncContent.subtitle = parsedResult.subtitle
        // Append to notificationString
        tempString += ncContent.subtitle
    // If we're to set the title
    } else {
        // Set the notifications title
        ncContent.title = parsedResult.title
        // Append to notificationString
        tempString += ncContent.title
    }
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - notificationString - \(tempString)")
    }
    // Return the modified vars
    return(ncContent, tempString)
}

// Process userinfo for notification
func handleNotification(forResponse response: UNNotificationResponse) {
    // Retrieve userInfo from the response object
    let userInfo = response.notification.request.content.userInfo
    // If verboseMode is set
    if userInfo["verboseMode"] != nil {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - message - interacted")
    }
    // Triggered when the notification message is clicked
    if response.actionIdentifier == "com.apple.UNNotificationDefaultActionIdentifier" {
        // If verbose mode is set
        if userInfo["verboseMode"] != nil {
            // Progress log
            NSLog("""
                  \(#function.components(separatedBy: "(")[0]) - message - clicked \
                  - userInfo \(String(describing: userInfo))
                  """)
        }
        // Performs any actions set when the user clicks the message
        handleNotificationActions(userInfoKey: "messageAction", userInfo: userInfo)
    // If the notification was dismissed
    } else if response.actionIdentifier == "com.apple.UNNotificationDismissActionIdentifier" {
        // If verbose mode is set
        if userInfo["verboseMode"] != nil {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - message - message was dismissed")
        }
    // If the messageButton was clicked
    } else {
        // If verbose mode is set
        if userInfo["verboseMode"] != nil {
            // Progress log
            NSLog("""
                  \(#function.components(separatedBy: "(")[0]) - message button - \
                  clicked - userInfo \(String(describing: userInfo))
                  """)
        }
        // Performs any actions set when the user clicks the messagebutton
        handleNotificationActions(userInfoKey: "messageButton", userInfo: userInfo)
    }
    // If verbose mode is set
    if userInfo["verboseMode"] != nil {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - message - removing notification")
    }
    // Remove the delivered notification
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:
                                                                        [response.notification.request.identifier])
    // Sleep for a second
    sleep(1)
    // If verbose mode is set
    if userInfo["verboseMode"] != nil {
        // Progress log
        NSLog("""
              \(#function.components(separatedBy: "(")[0]) - message - \
              removing notification - done
              """)
    }
    // Exit
    exit(0)
}

// Handles when a notification is interacted with
func handleNotificationActions(userInfoKey: String, userInfo: [AnyHashable: Any]) {
    // If we have a userInfoKey in the notifications userinfo
    if userInfo[userInfoKey] != nil {
        // iIf the action is logout
        if (userInfo[userInfoKey] as? String) == "logout" {
            // If verbose mode is set
            if userInfo["verboseMode"] != nil {
                // Progress log
                NSLog("\(#function.components(separatedBy: "(")[0]) - \(userInfoKey) - logout")
            }
            // Prompt to logout
            gracefulLogout(userInfo: userInfo)
            // If we have an action thaty's not logout
        } else {
            // If verbose mode is set
            if userInfo["verboseMode"] != nil {
                // Progress log
                NSLog("""
                      \(#function.components(separatedBy: "(")[0]) - \(userInfoKey) \
                      - \(String(describing: userInfo[userInfoKey]))
                      """)
            }
            // Open the item passed
            openItem(userInfo: userInfo, userInfoKey: userInfoKey)
        }
    }
}

// Post the notification
func postNotification(ncCenter: UNUserNotificationCenter, ncContent: UNMutableNotificationContent,
                      notificationString: String, parsedResult: ArgParser) {
    // Convert notificationString into base64
    let ncContentbase64 = base64String(stringContent: notificationString)
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("""
              \(#function.components(separatedBy: "(")[0]) - notification \
              request - ncContentbase64 - \(ncContentbase64)
              """)
    }
    // Set the notification to be posted in 1 second
    let ncTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    // Create the request object
    let ncRequest = UNNotificationRequest(identifier: ncContentbase64, content: ncContent, trigger: ncTrigger)
    // Post the notification
    ncCenter.add(ncRequest)
    // Sleep for a second
    sleep(1)
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - notification delivered")
    }
    // Exit
    exit(0)
}

// Either adds a message button if passed), or sets to an empty value
func processNotificationButton(ncCenter: UNUserNotificationCenter, ncContent: UNMutableNotificationContent,
                               notificationString: String, parsedResult: ArgParser)
                               -> (UNMutableNotificationContent, String) {
    // Var declaration
    var tempString = notificationString
    // If we're to add button to the message
    if parsedResult.messagebutton != "" {
        // If we're in verbose mode
        if parsedResult.verbose {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - messagebutton")
        }
        // Create an action object
        let ncAction = UNNotificationAction(identifier: "messagebutton", title: parsedResult.messagebutton,
                                            options: .init(rawValue: 0))
        // Create a category object
        let ncCategory = UNNotificationCategory(identifier: "alert", actions: [ncAction], intentIdentifiers: [],
                                                options: .customDismissAction)
        // Add to categories to ncCenter
        ncCenter.setNotificationCategories([ncCategory])
        // Add category identifier to ncContent
        ncContent.categoryIdentifier = "alert"
        // Set the message to the body of the notification
        ncContent.body = parsedResult.message
        // Append to tempString
        tempString += ncContent.body
        // If we're in verbose mode
        if parsedResult.verbose {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - notificationString - \(tempString)")
        }
    // If we have nothing passed to messagebutton
    } else {
        // If verbose mode is set
        if parsedResult.verbose {
            // Progress log
            NSLog("\(#function.components(separatedBy: "(")[0]) - no messagebutton")
        }
        // Create a category object
        let ncCategory = UNNotificationCategory(identifier: "alert", actions: [], intentIdentifiers: [],
                                                options: .customDismissAction)
        // Add to categories to ncCenter
        ncCenter.setNotificationCategories([ncCategory])
        // Add category identifier to ncContent
        ncContent.categoryIdentifier = "alert"
    }
    // Return the modified vars
    return(ncContent, tempString)
}

// If we're to remove a specific prior posted notification
func removePriorNotification(ncCenter: UNUserNotificationCenter, notificationString: String, parsedResult: ArgParser) {
    // Convert notificationString into base64
    let ncContentbase64 = base64String(stringContent: notificationString)
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("""
              \(#function.components(separatedBy: "(")[0]) - remove prior \
              - ncContentbase64 - \(notificationString)
              """)
    }
    // Remove any prior notifications with the same identifier as ncContentbase64
    ncCenter.removeDeliveredNotifications(withIdentifiers: [ncContentbase64])
    // Sleep for a second
    sleep(1)
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - remove prior - done")
    }
    // Exit
    exit(0)
}

// If we're to remove all prior posted notifications
func removeAllPriorNotifications(ncCenter: UNUserNotificationCenter, parsedResult: ArgParser) {
    // If we're in verbose mode
    if parsedResult.verbose {
        // Verbose message
        NSLog("\(#function.components(separatedBy: "(")[0]) - ncRemove all")
    }
    // Remove all delivered notifications
    ncCenter.removeAllDeliveredNotifications()
    // Sleep for a second
    sleep(1)
    // If we're in verbose mode
    if parsedResult.verbose {
        // Progress log
        NSLog("\(#function.components(separatedBy: "(")[0]) - ncRemove all - done")
    }
    // Exit
    exit(0)
}

// Request authorisation
func requestAuthorisation(parsedResult: ArgParser) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, _) in
        // If we're not been granted authorization to post notifications
        if !granted {
            // Print error
            print("ERROR: Authorisation not granted, exiting...")
            // If verbose mode is set
            if parsedResult.verbose {
                // Progress log
                NSLog("""
                      \(#function.components(separatedBy: "(")[0]) - ERROR: \
                      Authorisation not granted, exiting...
                      """)
            }
            // Exit 1
            exit(1)
        }
    }
}

// Respond to notification message click
func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
    // Get the interacted notification
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification"),
                                    object: nil,
                                    userInfo: response.notification.request.content.userInfo)
    // Handle the response
    handleNotification(forResponse: response)
}

// Ensure that notification is shown, even if app is active
func userNotificationCenter(_ center: UNUserNotificationCenter,
                            willPresent notification: UNNotification,
                            withCompletionHandler completionHandler: @escaping
                            (UNNotificationPresentationOptions) -> Void) {
    // Raise an error is an issue with completionHandler
    completionHandler(.alert)
}
