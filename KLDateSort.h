//
//  KLDateSort.h
//  CalendarModule
//
//  Created by Scott Montgomerie on 10-09-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NSInteger KLDateSort(id date, id kldate, void *context);

@interface MroBinarySearch :NSObject {
	NSArray *theArray;
}

- (MroBinarySearch*) initWithArray: (NSArray*) array;
- (int)count;
- (id)objectAtIndex:(NSUInteger)index;

-(NSInteger)binarySearch:(id)key;

/**
 * @see MroBinarySearch::binarySearch:
 * @see NSArray::sortedArrayUsingSelector:
 */
-(NSInteger)binarySearch:(id)key usingSelector:(SEL)comparator;

/**
 * Binary search a part of an array.
 *
 * @param key nil returns -1
 * @param comparator may be nil to use @selector(compare:)
 * @param range
 * @return found index.
 *
 * @see MroBinarySearch::binarySearch:
 * @see NSArray::sortedArrayUsingSelector:
 */
-(NSInteger)binarySearch:(id)key usingSelector:(SEL)comparator inRange:(NSRange)range;

/**
 * @see MroBinarySearch::binarySearch:
 * @see NSArray::sortedArrayUsingFunction:context:
 */
-(NSInteger)binarySearch:(id)key usingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context;

/**
 * @see MroBinarySearch::binarySearch:
 * @see NSArray::sortedArrayUsingFunction:context:
 */
-(NSInteger)binarySearch:(id)key usingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context inRange:(NSRange)range;

/**
 * @see MroBinarySearch::binarySearch:
 * @see NSArray::sortedArrayUsingDescriptors:
 */
-(NSInteger)binarySearch:(id)key usingDescriptors:(NSArray *)sortDescriptors;

-(NSInteger)binarySearch:(id)key usingDescriptors:(NSArray *)sortDescriptors inRange:(NSRange)range;

@end
