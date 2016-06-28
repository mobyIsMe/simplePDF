//
//  ZPDFReaderController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFReaderController.h"
#import "ZPDFPageController.h"

#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

@implementation ZPDFReaderController
{
    UIPageViewController *pageViewCtrl;
    ZPDFPageModel *pdfPageModel;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [self.fileName substringToIndex:self.fileName.length-4];
    
    if(IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    //initial UIPageViewController
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                 options:options];
    
    //setting DataSource
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, (__bridge CFStringRef)self.subDirName);
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CFRelease(pdfURL);
    pdfPageModel = [[ZPDFPageModel alloc] initWithPDFDocument:pdfDocument];
    pdfPageModel.delegate=self;
    [pageViewCtrl setDataSource:pdfPageModel];
    
    NSInteger page = [[NSUserDefaults standardUserDefaults] integerForKey:_fileName];
    
    //setting initial VCs
    ZPDFPageController *initialViewController = [pdfPageModel viewControllerAtIndex:MAX(page, 1)];
    NSArray *viewControllers = @[initialViewController];
    [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    //show UIPageViewController
    [self addChildViewController:pageViewCtrl];
    [self.view addSubview:pageViewCtrl.view];
    [pageViewCtrl didMoveToParentViewController:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)pageChanged:(NSInteger)page
{
    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:_fileName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
