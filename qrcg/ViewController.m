//
//  ViewController.m
//  qrcg
//
//  Created by Carter Chang on 11/10/15.
//  Copyright © 2015 Carter Chang. All rights reserved.
//

#import "ViewController.h"
#import <TTQRCodeScanner.h>
#define UI_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *cameraView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TTQRCodeScanner *scanner = [[TTQRCodeScanner alloc]init];
    
    [scanner scanWithCodeType:ScanCodeTypeQR inView:self.view interestRect:self.cameraView.frame interestMaskImage:[UIImage imageNamed:@"background"] scanerLine:[UIImage imageNamed:@"line"] scanerInterval:0.03 completionHandler:^(NSString *scanResult) {
        [scanner stopScan];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scanResult]];
        exit(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
