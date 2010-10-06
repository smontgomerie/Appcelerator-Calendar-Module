/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiCalendarViewProxy.h"
#import "TiCalendarView.h"
#import "TiUtils.h"
#import <EventKit/EventKit.h>

@implementation TiCalendarViewProxy

#pragma mark Internal

-(void)_configure
{
	NSLog(@"configure");
}

-(void)_destroy
{
	NSLog(@"destroy");
}

-(void)viewDidAttach
{
	NSLog(@"view Did Attach");
}

-(NSArray*) dates
{
	return [((TiCalendarView* ) self.view) dates];
}

- (void) setDates: (NSArray*) datesArray
{
	ENSURE_UI_THREAD(setDates,datesArray);

	NSLog(@"setDates %d", datesArray.count);
	
	dates = [NSMutableArray arrayWithCapacity:datesArray.count];
	
	for (int i=0; i<datesArray.count; i++) {
		[dates addObject: [datesArray objectAtIndex:i]];
	}
	
	[dates retain];
	
	NSLog(@"Retain Count: %d, %d", dates.retainCount, [[dates objectAtIndex:0] retainCount]);

	//	NSLog(@"%@", datesArray);
	[((TiCalendarView* ) self.view) setDatesArray:datesArray];
}

-(NSNumber*) month
{
	return [((TiCalendarView* ) self.view) month];
}

- (void) setMonth: (NSNumber*) value
{
	[((TiCalendarView* ) self.view) setMonth:value];
}

- (id) saveEvent: (id) args
{
	id arg1 = [args objectAtIndex:0];  // Start Date
	id arg2 = [args objectAtIndex:1];  // End Date
	id arg3 = [args objectAtIndex:2];  // Title
	id arg4 = [args objectAtIndex:3];  // Location
	id arg5 = [args objectAtIndex:4];  // Text
	
	ENSURE_TYPE(arg1, NSDate);
	ENSURE_TYPE(arg2, NSDate);
	ENSURE_TYPE(arg3, NSString);
	ENSURE_TYPE(arg4, NSString);
	ENSURE_TYPE(arg5, NSString);
	
	//NSDateFormatter *df = [[NSDateFormatter alloc] init];
//	[df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//	NSDate *startdate = [df dateFromString: arg1];
//	NSDate *enddate = [df dateFromString: arg2];
//	
	EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
	
	EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
	
	event.title     = arg3;
	event.location  = arg4;
	event.notes     = arg5;
	event.startDate = arg1;
	event.endDate   = arg2;
	
	[event setCalendar:[eventStore defaultCalendarForNewEvents]];
	NSError *err;
	[eventStore saveEvent:event span:EKSpanThisEvent error:&err];
	
	if ( err )
	{
		NSLog(@"%@", err);
	}
	
	return event.eventIdentifier;	
}

@end
