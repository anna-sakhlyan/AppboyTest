//
//  AppDelegate.m
//  AppboyTest
//
//  Created by AnnaSakhlyan on 5/15/17.
//  Copyright © 2017 AnnaSakhlyan. All rights reserved.
//

#import "AppDelegate.h"
#import <AppboyKit.h>
#import "ABKAppboyEndpointDelegate.h"

static NSString *const AppboyAPIKey = @"";
static NSString *const AppboyUserID = @"";

@interface AppDelegate () <ABKInAppMessageControllerDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Appboy startWithApiKey:@"3c5ec576-a44d-42b9-bf86-1e41107362a9"
              inApplication:[UIApplication sharedApplication]
          withLaunchOptions:launchOptions
          withAppboyOptions:@{ABKRequestProcessingPolicyOptionKey: @(ABKAutomaticRequestProcessing),
                              ABKSessionTimeoutKey : @(30),
                              ABKInAppMessageControllerDelegateKey:self}];
    [Appboy sharedInstance].useNUITheming = NO;
    [[Appboy sharedInstance] changeUser:@"223824951054102"];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  NSLog(@"Permission granted.");
                                  [[Appboy sharedInstance] pushAuthorizationFromUserNotificationCenter:granted];
                              }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[Appboy sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
    completionHandler();
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) {
    
}
- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage withKeyboardIsUp:(BOOL)keyboardIsUp {
    return ABKDisplayInAppMessageNow;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@",deviceToken]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
