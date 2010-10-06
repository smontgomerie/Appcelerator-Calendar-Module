//
//  MroBinarySearch.h
//
//  Created by Marcus Rohrmoser on 12.01.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#if 0
// No Logging
#define NSLogD(x,...)                             /* NSLog(x,##__VA_ARGS__) */
#else
// Do Logging
#define NSLogD(x,...) NSLog(x,##__VA_ARGS__)
#endif

/** Add binary search capabilities to NSArray.
 *
 * A port from http://www.jcurl.org/m2/site/jc-core/0.7-SNAPSHOT/apidocs/org/jcurl/math/CurveCombined.html#binarySearch(double[],%20int,%20int,%20double)
 * with the author's friendly permission.
 *
 */
@interface NSArray(MroBinarySearch)

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
