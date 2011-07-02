//
//  DocumentosAppDelegate.h
//  Documentos
//
//  Created by Matheus Brum on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentosAppDelegate : NSObject <UIApplicationDelegate,UIDocumentInteractionControllerDelegate> {


}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
- (NSString *)applicationPrivateDocumentsDirectory;
- (NSString *)applicationDocumentsDirectory;
-(NSMutableArray *)arrayFromDocsFolder;
-(NSArray *)arrayFromPrivateFolder;
@end
