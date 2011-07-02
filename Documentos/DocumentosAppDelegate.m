//
//  DocumentosAppDelegate.m
//  Documentos
//
//  Created by Matheus Brum on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocumentosAppDelegate.h"
#import "RootViewController.h"
@implementation DocumentosAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
  //  NSLog(@"%@",[self applicationDocumentsDirectory]);
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url != nil){
        UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:url];
        docController.delegate = self;  // we implement only: documentInteractionControllerViewControllerForPreview
        [docController presentPreviewAnimated:YES];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    docController.delegate = self;  // we implement only: documentInteractionControllerViewControllerForPreview
    [docController presentPreviewAnimated:YES];
    return YES;
}
-(NSMutableArray *)arrayFromDocsFolder{
    NSMutableArray *doc=[NSMutableArray array];
    NSString *documentsDirectoryPath = [self applicationDocumentsDirectory];
	NSArray *documentsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath error:NULL];
	for (NSString* curFileName in [documentsDirectoryContents objectEnumerator]){
		NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:curFileName];
		NSURL *fileURL = [NSURL fileURLWithPath:filePath];
		BOOL isDirectory;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!(isDirectory && [curFileName isEqualToString: @"Inbox"])){//é um arquivo normal
            [doc addObject:fileURL];
        }else{//é a pasta inbox
            NSError *error;
            NSString *arquivoNaInbox=[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error] objectAtIndex:0];//pega o arquivo que esta dentro dela
            NSString *arquivoNaInboxPath=[NSString stringWithFormat:@"%@/%@",filePath,arquivoNaInbox];
            if ( [[NSFileManager defaultManager] fileExistsAtPath:arquivoNaInboxPath]){
                NSString *toURL=[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],arquivoNaInbox];
                if ([[NSFileManager defaultManager] moveItemAtPath:arquivoNaInboxPath toPath:toURL error:&error]) {//move o arquivo
                    [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];//deleta a pasta
                    NSURL *fileInboxURL = [NSURL fileURLWithPath:toURL];
                    [doc addObject:fileInboxURL];
                }
            }
        }
	}
    return doc;
}
-(NSArray *)arrayFromPrivateFolder{
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self applicationPrivateDocumentsDirectory] error:NULL];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (NSString *)applicationDocumentsDirectory{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
- (NSString *)applicationPrivateDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *privateDict = [paths objectAtIndex:0];
    privateDict = [privateDict stringByAppendingPathComponent:@"Private Documents"];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:privateDict withIntermediateDirectories:YES attributes:nil error:&error];   
	return privateDict;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return [self.navigationController.viewControllers objectAtIndex:0];
}
- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
