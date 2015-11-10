//
//  ActionViewController.m
//  qrcoGenExtension
//
//  Created by Carter Chang on 11/10/15.
//  Copyright © 2015 Carter Chang. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QRCodeGenerator.h>
@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ActionViewController


- (NSString *)URLDecode:(NSString *)stringToDecode
{
    NSString *result = [stringToDecode stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {

                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *item, NSError *error) {
                    NSLog(@"Type is URL:%@",kUTTypeURL);
                    if (item) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSString *urlString = item.absoluteString;
                            self.qrcodeView.image = [QRCodeGenerator qrImageForString:urlString imageSize:self.qrcodeView.bounds.size.width];
                            
                            self.titleLabel.text = [self URLDecode: urlString];
                        }];
                    }
                }];
            }
            
            
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *jsDict, NSError *error) {
                    
                    if (jsDict) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                            NSDictionary *jsPreprocessingResults = jsDict[NSExtensionJavaScriptPreprocessingResultsKey];
                            //NSString *selectedText = jsPreprocessingResults[@"selection"];
                            NSString *pageTitle = jsPreprocessingResults[@"title"];
                            NSString *pageUrl = jsPreprocessingResults[@"URL"];
                            if([pageTitle length] > 0) {
                                self.titleLabel.text = pageTitle;
                            }else {
                                self.titleLabel.text = pageUrl;
                            }
                            
                            if([pageUrl length] > 0) {
                                self.qrcodeView.image = [QRCodeGenerator qrImageForString:pageUrl imageSize:self.qrcodeView.bounds.size.width];
                            }
                        }];
                    }
                    
                    
                }];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
