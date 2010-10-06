//
//  CalendarTestViewController.h
//  CalendarTest
//
//  Created by Ved Surtani on 10/03/09.
//  Copyright Pramati Technologies 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCalendarView.h"
#import "CheckmarkTile.h"

@interface CalendarViewController : UIViewController<KLCalendarViewDelegate> {
	KLCalendarView *calendarView;
	KLTile *currentTile;
	UITableView *myTableView;
	NSMutableArray *tableViewData;
	KLTile *tile;
	BOOL shouldPushAnotherView;
	
}

@end

