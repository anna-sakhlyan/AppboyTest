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
    [Appboy startWithApiKey:AppboyAPIKey
              inApplication:[UIApplication sharedApplication]
          withLaunchOptions:launchOptions
          withAppboyOptions:@{ABKRequestProcessingPolicyOptionKey: @(ABKAutomaticRequestProcessing),
                              ABKSessionTimeoutKey : @(30),
                              ABKInAppMessageControllerDelegateKey:self}];
    [Appboy sharedInstance].useNUITheming = NO;
    [[Appboy sharedInstance] changeUser:AppboyUserID];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  [[Appboy sharedInstance] pushAuthorizationFromUserNotificationCenter:granted];
                              }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert);
}

//comment this method to see that it works without it
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[Appboy sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
    completionHandler();
}

- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage withKeyboardIsUp:(BOOL)keyboardIsUp {
    return ABKDisplayInAppMessageNow;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@",deviceToken]];
}

@end
