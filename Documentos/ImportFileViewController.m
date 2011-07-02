//
//  ImportFileViewController.m
//  Documentos
//
//  Created by Matheus Brum on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImportFileViewController.h"
#import "DocumentosAppDelegate.h"

@implementation ImportFileViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    
  //  NSLog(@"%@",[AppDelegate arrayFromDocsFolder]);
    UIBarButtonItem *btCancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel   target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem=btCancel;
    [btCancel release];
    self.title=@"Importar";
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)cancel{
    [self dismissModalViewControllerAnimated:YES];
   
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [[AppDelegate arrayFromDocsFolder] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    cell.textLabel.text=(NSString *)[[[AppDelegate arrayFromDocsFolder] objectAtIndex:indexPath.row]lastPathComponent];

    // Configure the cell...
    
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableView beginUpdates];
        DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *stringURL=[NSString stringWithFormat:@"%@/%@",[AppDelegate applicationDocumentsDirectory],[[[AppDelegate arrayFromDocsFolder]objectAtIndex:indexPath.row]lastPathComponent]];
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
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentosAppDelegate *AppDelegate = (DocumentosAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *stringURL=[NSString stringWithFormat:@"%@/%@",[AppDelegate applicationDocumentsDirectory],[[[AppDelegate arrayFromDocsFolder]objectAtIndex:indexPath.row]lastPathComponent]];
    NSString *toURL=[NSString stringWithFormat:@"%@/%@",[AppDelegate applicationPrivateDocumentsDirectory],[[[AppDelegate arrayFromDocsFolder]objectAtIndex:indexPath.row]lastPathComponent]];
    NSError *error;
    if ([[NSFileManager defaultManager]fileExistsAtPath:stringURL]) {
        [[NSFileManager defaultManager]copyItemAtPath:stringURL toPath:toURL error:&error];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
