//
//  MroBinarySearch.m
//
//  Created by Marcus Rohrmoser on 12.01.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "MroBinarySearch.h"

@implementation NSArray(MroBinarySearch)

#pragma mark Using Selector

-(NSInteger)binarySearch:(id)key
{
    return [self binarySearch:key usingSelector:nil];
}


-(NSInteger)binarySearch:(id)key usingSelector:(SEL)comparator
{
    return [self binarySearch:key usingSelector:comparator inRange:NSMakeRange(0, self.count)];
}


-(NSInteger)binarySearch:(id)key usingSelector:(SEL)comparator inRange:(NSRange)range
{
    NSLogD(@"[NSArray(MroBinarySearch) binarySearch:%@ usingSelector:]", key);
    if (self.count == 0 || key == nil)
        return -1;
    if(comparator == nil)
        comparator = @selector(compare:);

//	check overflow?
    NSInteger min = range.location;
    NSInteger max = range.location + range.length - 1;

    while (min <= max)
    {
    	// http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html
        const NSInteger mid = min + (max - min) / 2;
        switch ((NSComparisonResult)[key performSelector:comparator withObject:[self objectAtIndex:mid]])
        {
            case NSOrderedSame:
                return mid;
            case NSOrderedDescending:
                min = mid + 1;
                break;
            case NSOrderedAscending:
                max = mid - 1;
                break;
        }
    }
    return -(min + 1);
}


#pragma mark Using C-Function

-(NSInteger)binarySearch:(id)key usingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context
{
    return [self binarySearch:key usingFunction:comparator context:context inRange:NSMakeRange(0, self.count)];
}


-(NSInteger)binarySearch:(id)key usingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context inRange:(NSRange)range
{
    NSLogD(@"[NSArray(MroBinarySearch) binarySearch:%@ usingFunction:]", key);
    if(self.count == 0 || key == nil || comparator == NULL)
        return [self binarySearch:key usingSelector:nil inRange:range];

//	check overflow?
    NSInteger min = range.location;
    NSInteger max = range.location + range.length - 1;

    while (min <= max)
    {
    	// http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html
        const NSInteger mid = min + (max - min) / 2;
        switch (comparator(key, [self objectAtIndex:mid], context))
        {
            case NSOrderedSame:
                return mid;
            case NSOrderedDescending:
                min = mid + 1;
                break;
            case NSOrderedAscending:
                max = mid - 1;
                break;
        }
    }
    return -(min + 1);
}


#pragma mark Using NSSortDescriptors

-(NSInteger)binarySearch:(id)key usingDescriptors:(NSArray *)sortDescriptors
{
    return [self binarySearch:key usingDescriptors:sortDescriptors inRange:NSMakeRange(0, self.count)];
}


/// internal helper
-(NSComparisonResult)_mroInternalCompare:(const NSArray const*)sortDescriptors a:(id)object1 b:(id)object2
{
    for (const NSSortDescriptor const *d in sortDescriptors)
    {
        const NSComparisonResult r = [d compareObject:object1 toObject:object2];
        if (r != NSOrderedSame)
            return r;
    }
    return NSOrderedSame;
}


-(NSInteger)binarySearch:(id)key usingDescriptors:(NSArray *)sortDescriptors inRange:(NSRange)range
{
    NSLogD(@"[NSArray(MroBinarySearch) binarySearch:%@  usingDescriptors:]", key);
    if (self.count == 0 || key == nil || sortDescriptors == nil || sortDescriptors.count == 0)
        return [self binarySearch:key usingSelector:nil inRange:range];

//	check overflow?
    NSInteger min = range.location;
    NSInteger max = range.location + range.length - 1;

    while (min <= max)
    {
    	// http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html
        const NSInteger mid = min + (max - min) / 2;
        switch ([self _mroInternalCompare:sortDescriptors a:key b:[self objectAtIndex:mid]])
        {
            case NSOrderedSame:
                return mid;
            case NSOrderedDescending:
                min = mid + 1;
                break;
            case NSOrderedAscending:
                max = mid - 1;
                break;
        }
    }
    return -(min + 1);
}

@end
