//
//  eshopApp.swift
//  eshop
//
//  Created by Bnext mobile on 08/09/22.
//

import SwiftUI
import Evergage
import AppTrackingTransparency
import SFMCSDK
import MarketingCloudSDK
import Firebase

@main
struct eshopApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var window: UIWindow?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                        ATTrackingManager.requestTrackingAuthorization { status in
                            ShowMessageTracking()
                        }
                    } else {
                        ShowMessageTracking()
                    }
                    
                    
                }
        }
    }
    
    func ShowMessageTracking(){
        let evergage = Evergage.sharedInstance()
        
    #if DEBUG
        evergage.logLevel = EVGLogLevel.off
    #endif
        let evergageId = UserDefaults.standard.string(forKey: "EvergageId")
        if(!(evergageId ?? "").isEmpty){
            evergage.userId = evergageId!
            
            evergage.start { (clientConfigurationBuilder) in
                clientConfigurationBuilder.account = Globals.Account
                clientConfigurationBuilder.dataset = Globals.Dateset
                clientConfigurationBuilder.usePushNotifications = false
                clientConfigurationBuilder.useDesignMode = true
            }
        }
        
        
    }
        
}


class AppDelegate: NSObject, UIApplicationDelegate, MarketingCloudSDKURLHandlingDelegate {
    func sfmc_handle(_ url: URL, type: String) {
        print(url)
    }
    
    
    let appID = "843cdf42-c2ee-41d1-a92c-59228b584fa1"
    let accessToken = "e8Qe39PtBHMfJWOunCQdpY9X"
    let appEndpoint = "https://mc9q6tzd8n0mybmv2n07qygb9fk8.device.marketingcloudapis.com/"
    let inbox = false
    let location = false
    let analytics = true
    
    @discardableResult
    func configureMarketingCloudSDK(contactKey: String) -> Bool {
            // Use the builder method to configure the SDK for usage. This gives you the maximum flexibility in SDK configuration.
            // The builder lets you configure the SDK parameters at runtime.
            let builder = MarketingCloudSDKConfigBuilder()
                .sfmc_setApplicationId(appID)
                .sfmc_setAccessToken(accessToken)
                .sfmc_setMarketingCloudServerUrl(appEndpoint)
                .sfmc_setInboxEnabled(inbox as NSNumber)
                .sfmc_setLocationEnabled(location as NSNumber)
                .sfmc_setAnalyticsEnabled(analytics as NSNumber)
                .sfmc_setDelayRegistration(untilContactKeyIsSet: true)
                .sfmc_build()!
            
            var success = false
            
            // Once you've created the builder, pass it to the sfmc_configure method.
            do {
                    try MarketingCloudSDK.sharedInstance().sfmc_configure(with:builder)
                    success = true
                } catch let error as NSError {
                    // Errors returned from configuration will be in the NSError parameter and can be used to determine
                    // if you've implemented the SDK correctly.
                    
                    let configErrorString = String(format: "MarketingCloudSDK sfmc_configure failed with error = %@", error)
                    print(configErrorString)
                }
                
                if success == true {
                    // The SDK has been fully configured and is ready for use!
                    
                    // Enable logging for debugging. Not recommended for production apps, as significant data
                    // about MobilePush will be logged to the console.
                    #if DEBUG
                    MarketingCloudSDK.sharedInstance().sfmc_setDebugLoggingEnabled(true)
                    #endif
                    
                    // Set the MarketingCloudSDKURLHandlingDelegate to a class adhering to the protocol.
                    // In this example, the AppDelegate class adheres to the protocol
                    // and handles URLs passed back from the SDK.
                    // For more information, see https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html
                    MarketingCloudSDK.sharedInstance().sfmc_setURLHandlingDelegate(self)

                    // Make sure to dispatch this to the main thread, as UNUserNotificationCenter will present UI.
                    DispatchQueue.main.async {
                        if #available(iOS 10.0, *) {
                            // Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
                            // In this exmple, the AppDelegate class adheres to the protocol (see below)
                            // and handles Notification Center delegate methods from iOS.
                            UNUserNotificationCenter.current().delegate = self
                            
                            // Request authorization from the user for push notification alerts.
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                                if error == nil {
                                    if granted == true {
                                        // Your application may want to do something specific if the user has granted authorization
                                        // for the notification types specified; it would be done here.
                                        print(MarketingCloudSDK.sharedInstance().sfmc_deviceToken() ?? "error: no token - was UIApplication.shared.registerForRemoteNotifications() called?")
                                    }
                                }
                            })
                        }
                        
                        // In any case, your application should register for remote notifications *each time* your application
                        // launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.
                        
                        // Registering in this manner does *not* mean that a user will see a notification - it only means
                        // that the application will receive a unique push token from iOS.
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            
            MarketingCloudSDK.sharedInstance().sfmc_setContactKey(contactKey)
            return success
        }
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        let evergageId = UserDefaults.standard.string(forKey: "EvergageId")
        if(!(evergageId ?? "").isEmpty){
            self.configureMarketingCloudSDK(contactKey: evergageId!)
        }
        
        
        return true
      }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        let evergageId = UserDefaults.standard.string(forKey: "EvergageId")
        if(!(evergageId ?? "").isEmpty){
            self.configureMarketingCloudSDK(contactKey: evergageId!)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      Messaging.messaging().appDidReceiveMessage(userInfo) // <- this line needs to be uncommented

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo:
         [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping
                         (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
          
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
        
      MarketingCloudSDK.sharedInstance().sfmc_setNotificationUserInfo(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication,
         didFailToRegisterForRemoteNotificationsWithError
         error: Error) {
        
    }
    
    func application(_ application: UIApplication,
         didRegisterForRemoteNotificationsWithDeviceToken
         deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        MarketingCloudSDK.sharedInstance().sfmc_setDeviceToken(deviceToken)
    }
}

extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let fct = fcmToken!
        UserDefaults.standard.set(fct, forKey: "fcmToken")
        print(dataDict)
        
        NotificationCenter.default.post(
              name: Notification.Name("FCMToken"),
              object: nil,
              userInfo: dataDict)
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        let userInfo = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)

      // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationRequest(response.notification.request)
        print(response.notification.request)
        let userInfo = response.notification.request.content.userInfo

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        
      Messaging.messaging().appDidReceiveMessage(userInfo)
        
      print(userInfo)

      completionHandler()
    }
}
