//
//  ViewController.swift
//  Swift LocalNotification
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    private let notificationPublisher = NotificationPublisher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationPublisher.sendNotification(title: "Hey", subTitle: "We made a cool", body: "Notification app", badge: 1, delayInterval: 10)
        
    }
    
    @IBAction func sendNotification(_ sender: UIButton) {
        notificationPublisher.sendNotification(title: "Hey", subTitle: "We made a cool", body: "Notification app", badge: 1, delayInterval: nil)
    }
    
    


}

