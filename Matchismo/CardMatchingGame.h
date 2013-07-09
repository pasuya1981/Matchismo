//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by ZackFang on 7/6/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

typedef NS_ENUM(int, MatchismoGameMode) {
    MatchismoGameMode2CardsMatch = 1,
    MatchismoGameMode3CardsMatch
};

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic) MatchismoGameMode matchismoGameMode;

@end
