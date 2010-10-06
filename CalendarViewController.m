//
//  CalendarTestViewController.m
//  CalendarTest
//
//  Created by Ved Surtani on 10/03/09.
//  Copyright Pramati Technologies 2009. All rights reserved.
//

#import "CalendarViewController.h"

@implementation CalendarViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


- (void)loadView {
	[super loadView];
	calendarView = [[[KLCalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,  320.0f, 360) delegate:self] autorelease];
	
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,260,320,160) style:UITableViewStylePlain];
	
	myTableView.dataSource = self;
	myTableView.delegate = self;
	UIView *myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,myTableView.frame.size.width , 20)];
	myHeaderView.backgroundColor = [UIColor grayColor];
	[myTableView setTableHeaderView:myHeaderView];
	
	
	[self.view addSubview:myTableView];
	[self.view addSubview:calendarView];
	[self.view bringSubviewToFront:myTableView];
	
}
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
	[cell setText:@"No Data For Now"];
	
	return cell;
	
}


/*----- Calendar Delegates -----> */

- (void)calendarView:(KLCalendarView *)calendarView tappedTile:(KLTile *)aTile{
	NSLog(@"Date Selected is %@",[aTile date]);
	
	[aTile flash];
	
	/*if(tile == nil)
		tile = aTile;
	else
		[tile restoreBackgroundColor];*/
	
	
	
}

- (KLTile *)calendarView:(KLCalendarView *)calendarView createTileForDate:(KLDate *)date{
	
	
	CheckmarkTile *tile = [[CheckmarkTile alloc] init];

	return tile;
	
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
	[self.view bringSubviewToFront:myTableView];
	tile = nil;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
