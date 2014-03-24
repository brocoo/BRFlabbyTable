//
//  BRFlabbyTableManager.m
//  FlabbyTable
//
//  Created by Julien Ducret on 13/03/2014.
//  Copyright (c) 2014 Julien Ducret. All rights reserved.
//

#import "BRFlabbyTableManager.h"
#import "BRFlabbyTableViewCell.h"
#import "NSIndexPath+BRFlabbyTable.h"

static void     *flabbyContext = &flabbyContext;
static NSString *flabbyKeyPath = @"contentOffset";

@interface BRFlabbyTableManager () <UIGestureRecognizerDelegate>

@property (assign, nonatomic)   CGFloat                         previousVerticalVelocity;
@property (strong, nonatomic)   UITapGestureRecognizer          *tapGestureRecognizer;
@property (strong, nonatomic)   UILongPressGestureRecognizer    *longPressGestureRecognizer;
@property (strong, nonatomic)   UIPanGestureRecognizer          *panGestureRecognizer;
@property (weak, nonatomic)     BRFlabbyTableViewCell           *highlightedFlabbyCell;

@end

@implementation BRFlabbyTableManager

- (instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        _previousVerticalVelocity = 0.0;
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableViewTap:)];
        [_tapGestureRecognizer setCancelsTouchesInView:NO];
        [_tapGestureRecognizer setDelegate:self];
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableViewTap:)];
        [_longPressGestureRecognizer setCancelsTouchesInView:NO];
        [_longPressGestureRecognizer setDelegate:self];
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableViewGesture:)];
        [_panGestureRecognizer setCancelsTouchesInView:NO];
        [_panGestureRecognizer setDelegate:self];
        [self setTableView:tableView];
        _highlightedFlabbyCell = nil;
    }
    return self;
}

#pragma mark - Custom setter

- (void)setTableView:(UITableView *)tableView{
    
    if (tableView != _tableView) {
        if (_tableView){
            [_tableView removeGestureRecognizer:_tapGestureRecognizer];
            [_tableView removeGestureRecognizer:_longPressGestureRecognizer];
            [_tableView removeGestureRecognizer:_panGestureRecognizer];
            [_tableView removeObserver:self forKeyPath:flabbyKeyPath];
        }
        if (tableView){
            [tableView addGestureRecognizer:_tapGestureRecognizer];
            [tableView addGestureRecognizer:_longPressGestureRecognizer];
            [tableView addGestureRecognizer:_panGestureRecognizer];
            [tableView addObserver:self
                        forKeyPath:flabbyKeyPath
                           options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                           context:flabbyContext];
        }
    }
    _tableView = tableView;
}

#pragma mark - Touches handling

- (void)handleTableViewTap:(UITapGestureRecognizer *)sender{
    [self applyFlabbinessForVerticalVelocity:0.0];
}

- (void)handleTableViewGesture:(UIGestureRecognizer *)sender{
    
    CGPoint point = [sender locationInView:_tableView];
    
    BRFlabbyTableViewCell *cellBefore = nil;
    BRFlabbyTableViewCell *currentCell = nil;
    BRFlabbyTableViewCell *cellAfter = nil;
    for (BRFlabbyTableViewCell *cell in _tableView.visibleCells) {
        [cell setFlabbyHighlightState:BRFlabbyHighlightStateNone];
        if (CGRectContainsPoint(cell.frame, point)) currentCell = cell;
        else if (!currentCell) cellBefore = cell;
        else if (!cellAfter) cellAfter = cell;
    }
    
    cellBefore = [cellBefore isKindOfClass:[BRFlabbyTableViewCell class]]?cellBefore:nil;
    currentCell = [currentCell isKindOfClass:[BRFlabbyTableViewCell class]]?currentCell:nil;
    cellAfter = [cellAfter isKindOfClass:[BRFlabbyTableViewCell class]]?cellAfter:nil;
    
    if (![currentCell longPressIsAnimated]) return;
    
    CGFloat touchXLocation = [sender locationInView:currentCell].x;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            if (cellBefore){
                [cellBefore setFlabbyHighlightState:BRFlabbyHighlightStateCellBelowTouched];
                [cellBefore setTouchXLocationInCell:touchXLocation];
            }
            if (currentCell){
                _highlightedFlabbyCell = currentCell;
                [currentCell setFlabbyHighlightState:BRFlabbyHighlightStateCellTouched];
                if (cellBefore) [cellBefore setFlabbyColorBelow:currentCell.flabbyColor];
                if (cellAfter) [cellAfter setFlabbyColorAbove:currentCell.flabbyColor];
            }
            if (cellAfter){
                [cellAfter setFlabbyHighlightState:BRFlabbyHighlightStateCellAboveTouched];
                [cellAfter setTouchXLocationInCell:touchXLocation];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            if (_highlightedFlabbyCell == currentCell) {
                if (cellBefore){
                    [cellBefore setFlabbyHighlightState:BRFlabbyHighlightStateCellBelowTouched];
                    [cellBefore setTouchXLocationInCell:touchXLocation];
                }
                if (currentCell){
                    [currentCell setFlabbyHighlightState:BRFlabbyHighlightStateCellTouched];
                    if (cellBefore) [cellBefore setFlabbyColorBelow:currentCell.flabbyColor];
                    if (cellAfter) [cellAfter setFlabbyColorAbove:currentCell.flabbyColor];
                }
                if (cellAfter){
                    [cellAfter setFlabbyHighlightState:BRFlabbyHighlightStateCellAboveTouched];
                    [cellAfter setTouchXLocationInCell:touchXLocation];
                }
                break;
            }
        default:
            if (cellBefore) [cellBefore setFlabbyHighlightState:BRFlabbyHighlightStateNone];
            if (currentCell) [currentCell setFlabbyHighlightState:BRFlabbyHighlightStateNone];
            if (cellAfter) [cellAfter setFlabbyHighlightState:BRFlabbyHighlightStateNone];
            break;
    }
    if (cellBefore) [cellBefore setNeedsDisplay];
    if (currentCell) [currentCell setNeedsDisplay];
    if (cellAfter) [cellAfter setNeedsDisplay];
}

#pragma mark - UIGestureRecognizer methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == flabbyContext && [keyPath isEqualToString:flabbyKeyPath]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeSetting) {
            CGPoint newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
            CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
            CGFloat verticalVelocity =  oldOffset.y - newOffset.y;
            if (fabsf(verticalVelocity - _previousVerticalVelocity)>CGFLOAT_MIN) {
                if (verticalVelocity/newOffset.y > 1.05 || verticalVelocity/newOffset.y < 0.95) {
                    [self applyFlabbinessForVerticalVelocity:verticalVelocity];
                }
            }
        }
    }
}

#pragma mark - TableViewCell methods

- (void)applyFlabbinessForVerticalVelocity:(CGFloat)verticalVelocity{
    
    NSAssert(_tableView, @"tableView can't be nil");
    
    _verticalVelocity = verticalVelocity;
    BOOL scrollingDown = _verticalVelocity<0;
    
    if (_delegate && [_delegate respondsToSelector:@selector(flabbyTableManager:scrolledWithVelocity:)]) {
        [_delegate flabbyTableManager:self scrolledWithVelocity:verticalVelocity];
    }
    
    NSArray *indexPaths = [_tableView indexPathsForVisibleRows];
    if (scrollingDown) indexPaths = [[indexPaths reverseObjectEnumerator] allObjects];

    NSIndexPath *firstIndexPath = [indexPaths firstObject];
    NSIndexPath *previousIndexPath = scrollingDown?[firstIndexPath nextIndexPathInTable:_tableView]:[firstIndexPath previousIndexPathInTable:_tableView];
    
    UIColor *overlapColor = [UIColor clearColor];
    if (previousIndexPath && _delegate && [_delegate respondsToSelector:@selector(flabbyTableManager:flabbyColorForIndexPath:)]) {
        overlapColor = [_delegate flabbyTableManager:self flabbyColorForIndexPath:previousIndexPath];
    }
    
    NSArray *cells = scrollingDown?[[[_tableView visibleCells] reverseObjectEnumerator] allObjects]:[_tableView visibleCells];
    for (BRFlabbyTableViewCell *cell in cells) {
        if ([cell isKindOfClass:[BRFlabbyTableViewCell class]]) {
            [cell setVerticalVelocity:verticalVelocity];
            [cell setFlabbyOverlapColor:overlapColor];
            [cell setNeedsDisplay];
            overlapColor = [cell flabbyColor];
        }else{
            overlapColor = [cell backgroundColor];
        }
    }
}

@end