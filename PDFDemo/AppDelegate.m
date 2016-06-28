//
//  AppDelegate.m
//  PDFDemo
//
//  Created by kiwik on 7/2/15.
//  Copyright (c) 2015 Kiwik. All rights reserved.
//

#import "AppDelegate.h"
#import "ZPDFListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ZPDFListViewController *listPdf=[[ZPDFListViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:listPdf];
    self.window.rootViewController=nav;
    
    return YES;
}

@end
