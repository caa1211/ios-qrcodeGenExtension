//
//  ActionViewController.m
//  qrcoCamExtension
//
//  Created by Carter Chang on 11/11/15.
//  Copyright © 2015 Carter Chang. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
           
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                // It's a plain text!
                
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *item, NSError *error) {
                    NSLog(@"Type is URL:%@",kUTTypeURL);
                    if (item) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"========URL %@==================", item.absoluteString);
                            [self openCamApp];
                            
                        }];
                    }
                }];
            }

        
        }
       
    }
}

- (void) openCamApp {
    NSString *  urlstr = @"qrcg://";
    
    UIResponder* responder = self;
    while ((responder = [responder nextResponder]) != nil)
    {
        NSLog(@"responder = %@", responder);
        if([responder respondsToSelector:@selector(openURL:)] == YES)
        {
            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:urlstr]];
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
