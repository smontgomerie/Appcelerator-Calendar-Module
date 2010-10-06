/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiCalendarView.h"
#import "KLGridView.h"
#import "KLTile.h"
#import "KLDateSort.h"
#import "MroBinarySearch.h"

#import "TiUtils.h"

@implementation TiCalendarView

@synthesize dates, month;

- (id) init
{
	// NSLog(@"Init view");

	self = [super init];
	if (self != nil)
	{
		calendarView = [[[KLCalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 360) delegate:self] autorelease];
		//myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,260,320,160) style:UITableViewStylePlain];
		
		id c = [self.proxy valueForUndefinedKey:@"calendarColor"];
		if ( c != nil )
		{
			NSLog(@"Setting color: %@", c);
			TiColor *color = [TiUtils colorValue:c];
			[calendarView setBackgroundColor:[color _color]];
		}

		NSLog(@"Init");
		
		//myTableView.dataSource = self;
		//myTableView.delegate = self;
		UIView *myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,myTableView.frame.size.width , 20)];
		c = [self.proxy valueForUndefinedKey:@"headerColor"];
		if ( c != nil )
		{
			TiColor *color = [TiUtils colorValue:c];
			myHeaderView.backgroundColor = [color _color];
		}
		else
		{
			myHeaderView.backgroundColor = [UIColor grayColor];
		}
		//[myTableView setTableHeaderView:myHeaderView];
		
		
	//	[self addSubview:myTableView];
		[self addSubview:calendarView];
		//[self bringSubviewToFront:myTableView];
		
		
	}
	return self;
}

/*
-(UIView*) calendar
{
	NSLog(@"Build view");

	
	if (map==nil)
	{
		map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,  320.0f, 360)];
		map.delegate = self;
		map.userInteractionEnabled = YES;
		map.showsUserLocation = YES; // defaults
		map.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self addSubview:map];
	}
	return map;
}
 */

#pragma mark tableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// [cell setText:@"No Data For Now"];
	
	return cell;
	
}


/*----- Calendar Delegates -----> */

- (void)calendarView:(KLCalendarView *)calView tappedTile:(KLTile *)aTile{
	NSLog(@"Date Selected is %@",[aTile date]);
	
	[aTile flash];
	
	if(tile == nil)
	{
		tile = aTile;
	}
	else
	{
		[tile restoreBackgroundColor];
//		tile.backgroundColor = calendarView.backgroundColor;
		tile = aTile;
	}
	
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
						[[aTile date] toNSDate],@"date",
						nil];
	
	[self.proxy fireEvent:@"dateSelected" withObject: data propagate:NO];
//	[self _fireEventToListener:@"dateSelected" withObject:[aTile date] listener:callback thisObject:nil];
}

- (KLTile *)calendarView:(KLCalendarView *)calView createTileForDate:(KLDate *)date{
	
	//NSLog(@"createTileForDate: %@", date);
	
	CheckmarkTile *t = [[CheckmarkTile alloc] init];
	t.checkmarked = NO;//based on any condition you can checkMark a tile

	bool checked = [self dateChecked: date];
	
	/*
	int index = [dates indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
		if ( [date compareWithNSDate: ((NSDate*) obj)] == NSOrderedSame)
		{
	//		NSLog(@"Same %@ with %@", date, obj);
			*stop =YES;
			return YES;
		}
		return NO;
	}];
	*/
//	NSLog(@"index: %d", index);
	
	if ( checked )
	{
		((CheckmarkTile*) t).checkmarked = YES;
		[t setNeedsDisplay];
	}
	
//	t.backgroundColor = calendarView.backgroundColor;
	
	return t;
	
}

- (void)didChangeMonths{
	
    UIView *clip = calendarView.superview;
    if (!clip)
        return;
    
    CGRect f = clip.frame;
    NSInteger weeks = [calendarView selectedMonthNumberOfWeeks];
    CGFloat adjustment = 0.f;
    
    switch (weeks) {
        case 4:
            adjustment = (92/321)*360+30;
            break;
        case 5:
            adjustment = (46/321)*360;
            break;
        case 6:
            adjustment = 0.f;
            break;
        default:
            break;
    }
    f.size.height = 360 - adjustment;
    clip.frame = f; 
	
	CGRect f2 = CGRectMake(0,260-adjustment,320,160+adjustment);
	myTableView.frame = f2;
	[self bringSubviewToFront:myTableView];
	tile = nil;
}

-(bool) dateChecked: (KLDate*) date
{
//	NSLog(@"datechecked %@", date);
/*
	bool found=false;
	for ( int i=0; i< dates.count; i++)
	{
		NSDate* obj = [dates objectAtIndex:i];
	//	NSLog(@"Comparing %@ with %@", date, obj);
		if ( [date compareWithNSDate: ((NSDate*) obj)] == NSOrderedSame)
		{
			found = TRUE;
			break;
		}
	
		if (found) break;
	}
	NSLog(@"index: %d", found);
*/	
	
	MroBinarySearch* binarySearch = [[MroBinarySearch alloc] initWithArray:dates];	
	NSInteger index=	[binarySearch binarySearch:date usingFunction: KLDateSort context:NULL];
//	NSLog(@"bs1 index: %d", index);

	/*	NSInteger bs1 = [dates binarySearch:[date toNSDate]];
	NSLog(@"bs1 index: %d", bs1);
	
	NSInteger bs = [dates binarySearch:date usingFunction:KLDateSort context:NULL];
	NSLog(@"bs index: %d", bs);
*/
	
	return ( index >=0 && dates.count > 0 );	
}


- (void) setDatesArray: (NSArray*) datesArray
{
	ENSURE_TYPE(datesArray,NSArray);
	

	NSLog(@"setdatesArray %d objects", datesArray.count);
	dates = [NSMutableArray arrayWithCapacity:datesArray.count];
	
	if ( datesArray.count > 0 )
	{
		for (int i=0; i<datesArray.count; i++) {

			NSDate* date =  [datesArray objectAtIndex:i];
			ENSURE_TYPE(date,NSDate);
			
			[dates addObject: date];
		}
	}
	
	[dates retain];
	
// NSLog(@"Dates: %@", dates);
//	NSLog(@"Retain Count: %d, %d", dates.retainCount, [[dates objectAtIndex:0] retainCount]);
	
	KLGridView* grid = calendarView.grid ;
	for ( KLTile* t in grid.tiles )
	{		
		((CheckmarkTile*) t).checkmarked = [self dateChecked: t.date];
	}
}

- (void) setMonth: (NSNumber*) value
{
	self.month = value;
	NSLog(@"%@", value);
}

- (void) setCalendarColor_: (id) color
{
	TiColor*  c = [TiUtils colorValue:color];
	UIColor * newColor = [c _color];
	NSLog(@"Set color %@", c);
	if ( newColor != nil)
	{
		[calendarView setBackgroundColor:newColor];
	}
	
	KLGridView* grid = calendarView.grid ;
	for ( KLTile* t in grid.tiles )
	{
		t.backgroundColor = newColor;
	}
}

- (void) setHeaderColor_: (id) color
{
	UIColor * newColor = [[TiUtils colorValue:color] _color];
	if ( newColor != nil)
	{
//		[myHeaderView setBackgroundColor:newColor];
	}
}

-(void)_destroy
{
	NSLog(@"destroy");
	RELEASE_TO_NIL(dates);
}

@end
