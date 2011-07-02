//
//  RootViewController.m
//  Documentos
//
//  Created by Matheus Brum on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DocumentosAppDelegate.h"
@implementation RootViewController
@synthesize docInteractionController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title=@"Documentos";
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",[AppDelegate arrayFromPrivateFolder]);
    UIBarButtonItem *btImport=[[UIBarButtonItem alloc]initWithTitle:@"Importar" style:UIBarButtonItemStyleBordered target:self action:@selector(import)];
    self.navigationItem.leftBarButtonItem=btImport;
    [btImport release];
}
-(void)import{
    ImportFileViewController *viewImport=[[[ImportFileViewController alloc]initWithNibName:@"ImportFileViewController" bundle:nil] autorelease];
    UINavigationController *navC=[[[UINavigationController alloc]initWithRootViewController:viewImport]autorelease];
    [self presentModalViewController:navC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [[AppDelegate arrayFromPrivateFolder] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setupDocumentControllerWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[AppDelegate applicationPrivateDocumentsDirectory],[[AppDelegate arrayFromPrivateFolder] objectAtIndex:indexPath.row]]]];
    NSInteger iconCount = [docInteractionController.icons count];
    if (iconCount != 0){
        cell.imageView.image = [docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    cell.textLabel.text=(NSString *)[[[AppDelegate arrayFromPrivateFolder] objectAtIndex:indexPath.row]lastPathComponent];
    cell.detailTextLabel.text=[docInteractionController UTI];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // Delete the row from the data source.
        [self.tableView beginUpdates];
        DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *stringURL=[NSString stringWithFormat:@"%@/%@",[AppDelegate applicationPrivateDocumentsDirectory],[[[AppDelegate arrayFromPrivateFolder]objectAtIndex:indexPath.row]lastPathComponent]];
        NSError *error;
        BOOL success;
        NSLog(@"Deletando %@",stringURL);
        if ([[NSFileManager defaultManager]fileExistsAtPath:stringURL]) {
            success = [[NSFileManager defaultManager] removeItemAtPath:stringURL error:&error];
        }
        if (!success) {
            NSLog(@"ERRO");
        }
        [self.tableView  endUpdates];   
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    previewController.currentPreviewItemIndex = indexPath.row;
    [[self navigationController] pushViewController:previewController animated:YES];
    [previewController release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
- (void)setupDocumentControllerWithURL:(NSURL *)url{
    if (self.docInteractionController == nil){
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }else{
        self.docInteractionController.URL = url;
    }
}
- (void)dealloc
{
    [super dealloc];
}
#pragma mark -
#pragma mark QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [[AppDelegate arrayFromPrivateFolder] count];
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController{
    return self;
}
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx{
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[AppDelegate applicationPrivateDocumentsDirectory],[[AppDelegate arrayFromPrivateFolder] objectAtIndex:idx]]];
}


@end
