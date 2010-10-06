/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import <MapKit/MapKit.h>

#import "KLCalendarView.h"
#import "KLTile.h"
#import "CheckmarkTile.h"

@interface TiCalendarView : TiUIView<KLCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource> {

@private
	MKMapView *map;
	KLCalendarView *calendarView;
	KLTile *currentTile;
	UITableView *myTableView;
	NSMutableArray *tableViewData;
	KLTile *tile;
	BOOL shouldPushAnotherView;

	NSMutableArray* dates;
	NSNumber* month;
}

@property(nonatomic, retain) NSArray* dates;
@property(nonatomic, retain) NSNumber* month;

- (void) setDatesArray: (NSArray*) datesArray;
- (void) setMonth: (NSNumber*) value;
- (void) setCalendarColor_: (id) color;
- (void) setHeaderColor_: (id) color;
- (bool) dateChecked: (KLDate*) date;

//-(UIView*) calendar;


@end
