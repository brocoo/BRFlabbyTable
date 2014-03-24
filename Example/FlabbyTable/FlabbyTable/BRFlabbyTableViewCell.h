//
//  BRFlabbyTableViewCell.h
//  FlabbyTable
//
//  Created by Julien Ducret on 13/03/2014.
//  Copyright (c) 2014 Julien Ducret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BRFlabbyHighlightState){
    BRFlabbyHighlightStateNone,
    BRFlabbyHighlightStateCellAboveTouched,
    BRFlabbyHighlightStateCellBelowTouched,
    BRFlabbyHighlightStateCellTouched
};

@interface BRFlabbyTableViewCell : UITableViewCell

@property (assign, nonatomic)                                   CGFloat                 verticalVelocity;
@property (assign, nonatomic, setter = setFlabby:)              BOOL                    isFlabby;
@property (assign, nonatomic, setter = setLongPressAnimated:)   BOOL                    longPressIsAnimated;
@property (copy, nonatomic)                                     UIColor                 *flabbyOverlapColor;
@property (copy, nonatomic)                                     UIColor                 *flabbyColor;
@property (assign, nonatomic)                                   BRFlabbyHighlightState  flabbyHighlightState;
@property (assign, nonatomic)                                   CGFloat                 touchXLocationInCell;
@property (copy, nonatomic)                                     UIColor                 *flabbyColorAbove;
@property (copy, nonatomic)                                     UIColor                 *flabbyColorBelow;

@end