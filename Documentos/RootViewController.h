//
//  RootViewController.h
//  Documentos
//
//  Created by Matheus Brum on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportFileViewController.h"
#import <QuickLook/QuickLook.h>

@interface RootViewController : UITableViewController <QLPreviewControllerDataSource,UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *docInteractionController;

}
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;
- (void)setupDocumentControllerWithURL:(NSURL *)url;
-(void)import;
@end
