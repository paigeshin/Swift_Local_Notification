# Swift_Local_Notification

# Swift Local Notification, Simplest Way

### 2 Types of Notification

- Local Notification
- Push Notification, Remote Notification

### Five Steps - The Simplest Way

```swift
/**  Step 1 : Ask for permission  **/
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        
        /**  Step 2 :  Create the notification content **/
        let content = UNMutableNotificationContent()
        content.title = "Hey I'm a notification!"
        content.body = "Look at me"
        
        /**  Step3 : Create the notification trigger **/
        let date = Date().addingTimeInterval(10) //10초 후에..
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date) //pass future date
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        /** Step4 : Create the request **/
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        /** Step5 : Register with notification center **/
        center.add(request) { (error) in
            //Check the error
            if let error = error {
                print(error.localizedDescription)
            }
        }
```

`let date = Date().addingTimeInterval(10) //10초 후에..`

⇒ background를 추가하면 진행

# Swift Local Notification in Detail

### AppDelegate

```swift
//
//  AppDelegate.swift
//  Swift LocalNotification
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private func requestNotificationAuthorization(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }

    //Handle Badge number, ios13에서는 처리 안헤줘도 알아서 해주는 듯...
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
}
```

### NotificationPublisher

```swift
//
//  NotificationPublisher.swift
//  Swift LocalNotification
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import UserNotifications

//UNUserNotificationCenter의 특정 delegate method를 사용하려면 NSObject를 상속 받아야 한다.
class NotificationPublisher: NSObject {
    
    func sendNotification(title: String,
                          subTitle: String,
                          body: String,
                          badge: Int?,
                          delayInterval: TimeInterval?) {
        
        //create content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subTitle
        notificationContent.body = body
        
        //create trigger
        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval {
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delayInterval, repeats: false)
        }
        
        //app badge number, 안읽은 notification의 수
        if let badge = badge {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount
        }
        
        //delegate
        UNUserNotificationCenter.current().delegate = self

        //sound setting
        notificationContent.sound = UNNotificationSound.default //You can check multiple options
        
        //create request
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: notificationContent, trigger: delayTimeTrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
        
    }
    
}

//UNUnserNotification
extension NotificationPublisher: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("The notification is about to be presented")
        //badge는 icon을 으미
        completionHandler([.badge, .sound, .alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print("The notification wasdismissed")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app from the notification")
            completionHandler()
        default:
            print("The default case was called")
            completionHandler()
        }
        
    }
    
    
//    func isEqual(_ object: Any?) -> Bool {
//        <#code#>
//    }
//
//    var hash: Int {
//        <#code#>
//    }
//
//    var superclass: AnyClass? {
//        <#code#>
//    }
//
//    func `self`() -> Self {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func isProxy() -> Bool {
//        <#code#>
//    }
//
//    func isKind(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//
//    func isMember(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//
//    func conforms(to aProtocol: Protocol) -> Bool {
//        <#code#>
//    }
//
//    func responds(to aSelector: Selector!) -> Bool {
//        <#code#>
//    }
//
//    var description: String {
//        <#code#>
//    }
    
}
```

### How to use

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationPublisher.sendNotification(title: "Hey", subTitle: "We made a cool", body: "Notification app", badge: 1, delayInterval: 10)
        
    }
    
    @IBAction func sendNotification(_ sender: UIButton) {
        notificationPublisher.sendNotification(title: "Hey", subTitle: "We made a cool", body: "Notification app", badge: 1, delayInterval: nil)
    }

```