//
//  SimpleWayForLocalNotification.swift
//  Swift LocalNotification
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UserNotifications

func theSimplestedWay() {
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
}

