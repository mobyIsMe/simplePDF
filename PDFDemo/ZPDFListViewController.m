//
//  ZPDFListViewController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFListViewController.h"
#import "ZPDFReaderController.h"

#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define kSubDirectory @"files"

@interface ZPDFListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)NSArray *fileArray;

@end

@implementation ZPDFListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的PDF";
    self.view.backgroundColor=[UIColor whiteColor];
    
    pdfTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    pdfTableView.dataSource = self;
    pdfTableView.delegate = self;
    pdfTableView.tableHeaderView = [[UIView alloc] init];
    pdfTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:pdfTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"pdfTableView_cell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines=0;
        cell.detailTextLabel.textColor=[UIColor colorWithWhite:.6 alpha:.8];
        
        if (IOS7) {
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
    }
    NSURL *url = self.fileArray[indexPath.row];
    NSString *fileName = nil;
    NSDate *createDate = nil;
    [url getResourceValue:&fileName forKey:NSURLNameKey error:nil];
    
    [url getResourceValue:&createDate forKey:NSURLCreationDateKey error:nil];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showtimeNew = [formatter1 stringFromDate:createDate];
    
    cell.textLabel.text = [fileName substringToIndex:fileName.length-4];
    cell.detailTextLabel.text=showtimeNew;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZPDFReaderController *targetViewCtrl = [[ZPDFReaderController alloc] init];
    targetViewCtrl.fileName = [self.fileArray[indexPath.row] lastPathComponent];
    targetViewCtrl.subDirName=kSubDirectory;
    [self.navigationController pushViewController:targetViewCtrl animated:YES];
}

-(NSArray*)fileArray
{
    if(!_fileArray)
    {
        NSArray *urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"pdf" subdirectory:kSubDirectory];
        _fileArray = [[NSArray alloc]initWithArray:urls];
    }
    return _fileArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
