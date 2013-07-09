//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by ZackFang on 7/5/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (id)init
{
    if (self = [super init]) {
        for (NSString *suit in [PlayingCard validSuit]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card atTop:YES];
            }
        }
    }
    return self;
}

@end
