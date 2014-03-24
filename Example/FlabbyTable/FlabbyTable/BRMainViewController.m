//
//  BRMainViewController.m
//  FlabbyTable
//
//  Created by Julien Ducret on 13/03/2014.
//  Copyright (c) 2014 Julien Ducret. All rights reserved.
//

#import "BRMainViewController.h"
#import "BRFlabbyTableManager.h"
#import "BRFlabbyTableViewCell.h"

@interface BRMainViewController ()<UITableViewDelegate, UITableViewDataSource, BRFlabbyTableManagerDelegate>

@property (weak, nonatomic) IBOutlet    UITableView             *tableView;
@property (strong, nonatomic)           BRFlabbyTableManager    *flabbyTableManager;
@property (strong, nonatomic)           NSArray                 *cellColors;

@end

@implementation BRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cellColors = @[[UIColor colorWithRed:27.0f/255.0f green:191.0f/255.0f blue:161.0f/255.0f alpha:1.0f],
                        [UIColor colorWithRed:126.0f/255.0f green:113.0f/255.0f blue:128.0f/255.0f alpha:1.0f],
                        [UIColor colorWithRed:255.0f/255.0f green:79.0f/255.0f blue:75.0f/255.0f alpha:1.0f],
                        [UIColor colorWithRed:150.0f/255.0f green:214.0f/255.0f blue:217.0f/255.0f alpha:1.0f],
                        [UIColor colorWithRed:230.0f/255.0f green:213.0f/255.0f blue:143.0f/255.0f alpha:1.0f]];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _flabbyTableManager = [[BRFlabbyTableManager alloc] initWithTableView:_tableView];
    [_flabbyTableManager setDelegate:self];

    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BRFlabbyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"BRFlabbyTableViewCellIdentifier"];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BRFlabbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRFlabbyTableViewCellIdentifier" forIndexPath:indexPath];
    [cell setFlabby:YES];
    [cell setLongPressAnimated:YES];
    [cell setFlabbyColor:[self colorForIndexPath:indexPath]];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

#pragma mark - BRFlabbyTableManagerDelegate methods

- (UIColor *)flabbyTableManager:(BRFlabbyTableManager *)tableManager flabbyColorForIndexPath:(NSIndexPath *)indexPath{
    return [self colorForIndexPath:indexPath];
}

#pragma mark - Miscellenanious

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    return _cellColors[row%_cellColors.count];
}

@end