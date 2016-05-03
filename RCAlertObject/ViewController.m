//
//  ViewController.m
//  RCAlertObject
//
//  Created by Roy on 16/4/29.
//  Copyright © 2016年 Roy CHANG. All rights reserved.
//

#import "ViewController.h"

#import "RCAlertObject.h"

static NSString *const g_CellID = @"Cell_ID";

static NSString *const AlertSectionTitle        = @"RCAlertTypeAlert";
static NSString *const ActionSheetSectionTitle  = @"RCAlertTypeActionSheet";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *alertTypeTableView;

@property (nonatomic, strong) NSMutableArray *alertTypes;

@end

@implementation ViewController

@synthesize alertTypes = _alertTypes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property

- (NSMutableArray *)alertTypes
{
    if(!_alertTypes)
    {
        _alertTypes = [NSMutableArray array];
        [_alertTypes addObject:@[@"1 Button", @"2 Buttons", @"3 Buttons", @"No Title"]];
        [_alertTypes addObject:@[@"Button & Destructive", @"Destructive & Buttons", @"Buttons", @"No Title"]];
    }
    
    return _alertTypes;
}

- (void)showAlertWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = @"This is message body.";
    NSString *title = @"This is title";
    
    RCAlertObject *alertOut = nil;
    
    if(0 == indexPath.section)
    {
        switch(indexPath.row)
        {
            case 0:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeAlert title:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil];
                alert.title = title;
                alertOut = alert;
            }
                break;
                
            case 1:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeAlert title:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil];
                alert.title = title;
                [alert addOtherButtonTitles:@[@"Button1"]];
                alertOut = alert;
            }
                break;
                
            case 2:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeAlert title:nil cancelButtonTitle:nil destructiveButtonTitle:nil];
                alert.title = title;
                [alert addOtherButtonTitles:@[@"Button1", @"Button2", @"Button3"]];
                alertOut = alert;
            }
                break;
                
            case 3:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeAlert title:nil cancelButtonTitle:nil destructiveButtonTitle:nil];
                [alert addOtherButtonTitles:@[@"Button1", @"Button2", @"Button3", @"Button4"]];
                alertOut = alert;
            }
                break;
        }
        
        alertOut.message = message;
    }
    else
    {
        switch(indexPath.row)
        {
            case 0:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeActionSheet title:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destructive"];
                alert.title = title;
                alertOut = alert;
            }
                break;
                
            case 1:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeActionSheet title:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destructive"];
                alert.title = title;
                [alert addOtherButtonTitles:@[@"Button1", @"Button2"]];
                alertOut = alert;
            }
                break;
                
            case 2:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeActionSheet title:nil cancelButtonTitle:nil destructiveButtonTitle:@"Destructive"];
                alert.title = title;
                [alert addOtherButtonTitles:@[@"Button1", @"Button2", @"Butotn3"]];
                alertOut = alert;
            }
                break;
                
            case 3:
            {
                RCAlertObject *alert = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeActionSheet title:nil cancelButtonTitle:nil destructiveButtonTitle:nil];
                [alert addOtherButtonTitles:@[@"Button1", @"Button2", @"Butotn3", @"Button4"]];
                alertOut = alert;
            }
                break;
        }
    }
    
    alertOut.alertDelegate = (id<RCAlertObjectDelegate>)self;
    [alertOut showInViewController:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showAlertWithIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.alertTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionObj = self.alertTypes[section];
    return sectionObj.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:g_CellID forIndexPath:indexPath];
    NSArray *sectionObj = self.alertTypes[indexPath.section];
    cell.textLabel.text = sectionObj[indexPath.row];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(0 == section)
    {
        return AlertSectionTitle;
    }
    
    return ActionSheetSectionTitle;
}

#pragma mark - RCAlertObjectDelegate

- (void)alert:(RCAlertObject *)alert didClickedIndex:(NSInteger)buttonIndex
{
    NSLog(@"\n%d index clicked.", (int)buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"\n%d index clicked.", (int)buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"\n%d index clicked.", (int)buttonIndex);
}

@end
