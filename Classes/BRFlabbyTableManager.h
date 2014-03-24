//
//  BRFlabbyTableManager.h
//  FlabbyTable
//
//  Created by Julien Ducret on 13/03/2014.
//  Copyright (c) 2014 Julien Ducret. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BRFlabbyTableManager;

@protocol BRFlabbyTableManagerDelegate <NSObject>

- (UIColor *)flabbyTableManager:(BRFlabbyTableManager *)tableManager flabbyColorForIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)flabbyTableManager:(BRFlabbyTableManager *)tableManager scrolledWithVelocity:(CGFloat)velocity;

@end

@interface BRFlabbyTableManager : NSObject

@property (assign, nonatomic)           id<BRFlabbyTableManagerDelegate>    delegate;
@property (assign, nonatomic, readonly) CGFloat                             verticalVelocity;
@property (weak, nonatomic)             UITableView                         *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end