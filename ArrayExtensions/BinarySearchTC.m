//
//  BinarySearchTC.m
//
//  Created by Marcus Rohrmoser on 12.01.10.
//  Copyright 2009 Marcus Rohrmoser mobile Software. All rights reserved.
//

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>

@interface BinarySearchTC : SenTestCase {}
@end

#import "MroBinarySearch.h"

@implementation BinarySearchTC

-(void)testBinarySearchUsingSelector
{
    STAssertEquals(NSOrderedAscending, [@"0" compare:@"05"], @"");
    STAssertEquals(NSOrderedAscending, [@"05" compare:@"1"], @"");
    STAssertEquals(NSOrderedAscending, (NSComparisonResult)[@"0" performSelector:@selector(compare:) withObject:@"05"], @"");
    STAssertEquals(NSOrderedAscending, (NSComparisonResult)[@"05" performSelector:@selector(compare:) withObject:@"1"], @"");

    NSArray *a = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
    STAssertEquals(0, [a binarySearch:@"0"], @"0");
    STAssertEquals(1, [a binarySearch:@"1"], @"1");
    STAssertEquals(4, [a binarySearch:@"4"], @"4");
    STAssertEquals(-2, [a binarySearch:@"05"], @"05");
    STAssertEquals(-3, [a  binarySearch:@"1" usingSelector:nil inRange:NSMakeRange(2, a.count-2)], @"1");
}


NSInteger stringSort(id str1, id str2, void *context)
{
//    NSLogD(@"a:%@, b:%@", str1, str2);
    return [str1 compare:str2];
}


-(void)testBinarySearchUsingFunction
{
    STAssertEquals(NSOrderedAscending, stringSort(@"0", @"05", NULL), @"");
    STAssertEquals(NSOrderedAscending, stringSort(@"05", @"1", NULL), @"");

    NSArray *a = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
    STAssertEquals(0, [a binarySearch:@"0" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(1, [a binarySearch:@"1" usingFunction:stringSort context:NULL], @"1");
    STAssertEquals(4, [a binarySearch:@"4" usingFunction:stringSort context:NULL], @"4");
    STAssertEquals(-3, [a binarySearch:@"1" usingFunction:stringSort context:NULL inRange:NSMakeRange(2, a.count-2)], @"1");
    STAssertEquals(-2, [a binarySearch:@"05" usingFunction:stringSort context:NULL], @"05");

    a = [[NSArray arrayWithObjects:@"aa", @"ab", @"bb", @"bc", @"ca", @"cb", nil] sortedArrayUsingSelector:@selector(compare:)];
    STAssertEquals(-3, [a binarySearch:@"b" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(2, -(-3) - 1, @"");
    STAssertEquals(-5, [a binarySearch:@"bz" usingFunction:stringSort context:NULL], @"0");

    a = [NSArray array];
    STAssertEquals(-1, [a binarySearch:@"a" usingFunction:stringSort context:NULL], @"0");

    a = [NSArray arrayWithObjects:@"b", nil];
    STAssertEquals(-1, [a binarySearch:@"a" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(0, [a binarySearch:@"b" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(-2, [a binarySearch:@"c" usingFunction:stringSort context:NULL], @"0");

    a = [NSArray arrayWithObjects:@"b", @"d", nil];
    STAssertEquals(-1, [a binarySearch:@"a" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(0, [a binarySearch:@"b" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(-2, [a binarySearch:@"c" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(1, [a binarySearch:@"d" usingFunction:stringSort context:NULL], @"0");
    STAssertEquals(-3, [a binarySearch:@"e" usingFunction:stringSort context:NULL], @"0");
}


-(void)testBinarySearchUsingDescriptors
{

    NSArray *a = [NSArray arrayWithObjects:@"0", @"4", @"1", @"3", @"2", nil];
    NSSortDescriptor *tmp = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *sort = [NSArray arrayWithObject:tmp];
    a = [a sortedArrayUsingDescriptors:sort];

    STAssertEquals(NSOrderedAscending, [tmp compareObject:@"0" toObject:@"05"], @"");
    STAssertEquals(NSOrderedAscending, [tmp compareObject:@"05" toObject:@"1"], @"");
    [tmp release];

    STAssertEquals(0, [a binarySearch:@"0" usingDescriptors:sort], @"0");
    STAssertEquals(1, [a binarySearch:@"1" usingDescriptors:sort], @"1");
    STAssertEquals(4, [a binarySearch:@"4" usingDescriptors:sort], @"4");
    STAssertEquals(-2, [a binarySearch:@"05" usingDescriptors:sort], @"05");
    STAssertEquals(-3, [a  binarySearch:@"1" usingDescriptors:sort inRange:NSMakeRange(2, a.count-2)], @"1");
}

@end
