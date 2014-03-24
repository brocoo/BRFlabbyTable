//
//  NSIndexPath+BRFlabbyTable.h
//  FlabbyTable
//
//  Created by Julien Ducret on 20/03/2014.
//  Copyright (c) 2014 Julien Ducret. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (BRFlabbyTable)

- (NSIndexPath *)nextIndexPathInTable:(UITableView *)tableView;

- (NSIndexPath *)previousIndexPathInTable:(UITableView *)tableView;

@end