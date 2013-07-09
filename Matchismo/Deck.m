//
//  Deck.m
//  Matchismo
//
//  Created by ZackFang on 7/5/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

- (NSMutableArray *)cards {
    if (!_cards) _cards = [NSMutableArray array];
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    }
    else {
        [self.cards addObject:card];
    }
}

- (Card *)drawRandomCard {
    Card *randomCard = nil;
    
    if (self.cards.count) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = [self.cards objectAtIndex:index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

@end
