//
//  AppDelegate.swift
//  segment_ios
//
//  Created by Joey Ng on 15/7/23.
//

import UIKit
import Segment
import Segment_Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = AnalyticsConfiguration(writeKey: "cvcpH6mkKtcrTcXHirCxzokNQf20VWJo")
        configuration.trackApplicationLifecycleEvents = true // Enable this to record certain application events automatically!
        configuration.recordScreenViews = true // Enable this to record screen views automatically!
        configuration.flushAt = 1
        
        /** device-mode destinations */
        let mixpanelIntegration = SEGMixpanelIntegrationFactory.instance()!
        configuration.use(mixpanelIntegration)

        
        /** middlewares functions */
        let dropSpecificEvents = BlockMiddleware { (context, next) in
            let invalidEvents = [
                "Application Opened",
                "Order Completed",
                "Home Screen Tracked",
                "AnalyticsIOSTestApp. Screen Tracked",
            ]
            if let track = context.payload as? TrackPayload {
                if invalidEvents.contains(track.event) {
                    next(context.modify { ctx in
                        ctx.payload = TrackPayload(
                            event: track.event,
                            properties: track.properties,
                            context: track.context,
                            integrations: ["Mixpanel": false]
                        )
                    })
                    return
                }
            }
            next(context)
        }
        
        let blockTrackCallsToMixpanel = BlockMiddleware { (context, next) in
            if let track = context.payload as? TrackPayload {
                next(context.modify { ctx in
                    ctx.payload = TrackPayload(
                        event: track.event,
                        properties: track.properties,
                        context: track.context,
                        integrations: ["Mixpanel": false]
                    )
                })
                return
            }
            next(context)
        }
        
        
        configuration.sourceMiddleware = [
            dropSpecificEvents
        ]
        
        /** destination middlewares are not functioning for iOS, JIRA here - https://segment.atlassian.net/browse/LIBMOBILE-635 (Won't fix) **/
        // configuration.destinationMiddleware = [
        //     DestinationMiddleware(key: mixpanelIntegration.key(), middleware: [blockTrackCallsToMixpanel])
        // ]
    
        Analytics.setup(with: configuration)
        print("Initialized Analytics")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
