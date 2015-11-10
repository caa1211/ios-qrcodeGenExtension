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

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    // BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            
            
            
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                // It's a plain text!
                
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *item, NSError *error) {
                    NSLog(@"Type is URL:%@",kUTTypeURL);
                    if (item) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"========URL %@==================", item.absoluteString);
                            self.qrcodeView.image = [QRCodeGenerator qrImageForString:item.absoluteString imageSize:self.qrcodeView.bounds.size.width];
                            
                            
                        }];
                    }
                }];
            }

            
//            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
//                
//                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *jsDict, NSError *error) {
//                    
//                    if (jsDict) {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            NSDictionary *jsPreprocessingResults = jsDict[NSExtensionJavaScriptPreprocessingResultsKey];
//                            NSString *selectedText = jsPreprocessingResults[@"selection"];
//                            NSString *pageTitle = jsPreprocessingResults[@"title"];
//                            if ([selectedText length] > 0) {
//                                //self.textView.text = selectedText;
//                            } else if ([pageTitle length] > 0) {
//                                //self.textView.text = pageTitle;
//                            }
//                        }];
//                    }
//
//                    
//                }];
//            }
            
            
//            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
//                // This is an image. We'll load it, then place it in our image view.
//                __weak UIImageView *imageView = self.imageView;
//                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
//                    if(image) {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            [imageView setImage:image];
//                        }];
//                    }
//                }];
//                
//                imageFound = YES;
//                break;
//            }

        
        }
        
//        if (imageFound) {
//            // We only handle one image, so stop looking for more.
//            break;
//        }
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
