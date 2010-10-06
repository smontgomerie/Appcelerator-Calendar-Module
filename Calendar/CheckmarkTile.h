
// needed to subclass KLTile
#import "KLCalendarView.h"

@interface CheckmarkTile : KLTile
{
	BOOL checkmarked;
}
@property (nonatomic, assign) BOOL checkmarked;

@end
