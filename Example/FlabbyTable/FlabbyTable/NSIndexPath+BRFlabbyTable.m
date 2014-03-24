//
//  NSIndexPath+BRFlabbyTable.m
//  FlabbyTable
//
//  Created by Julien Ducret on 20/03/2014.
//  Copyright (c) 2014 Julien Ducret. All rights reserved.
//

#import "NSIndexPath+BRFlabbyTable.h"

@implementation NSIndexPath (BRFlabbyTable)

- (NSIndexPath *)nextIndexPathInTable:(UITableView *)tableView{
    NSUInteger rowsInSection = [tableView numberOfRowsInSection:self.section];
    if (self.row+1 < rowsInSection) return [NSIndexPath indexPathForRow:self.row+1 inSection:self.section];
    else return nil;
}

- (NSIndexPath *)previousIndexPathInTable:(UITableView *)tableView{
    if (self.row > 0) return [NSIndexPath indexPathForRow:self.row-1 inSection:self.section];
    else return nil;
}

@end