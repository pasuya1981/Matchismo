//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by ZackFang on 7/6/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;// score is readOnly in public API
@property (strong, nonatomic) NSMutableArray *matchCardsHolder; // for 3 cards match game mode
@end

@implementation CardMatchingGame
@synthesize matchCardsHolder = _matchCardsHolder;


- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            
            if (!card) {
                self = nil;
            }
            else {
                self.cards[i] = card;
            }
        }
        self.matchismoGameMode = MatchismoGameMode2CardsMatch;
    }
    return self;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MATCH_BONUS_TRIPLE 8
#define MIS_MATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = self.cards[index];
    
    if (self.matchismoGameMode == MatchismoGameMode2CardsMatch) {
        if (!card.isUnplayable) {
            if (!card.isFaceUp) {
                // See if fliping this card up creates a match
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        int matchScore = [card match:@[otherCard]];
                        
                        if (matchScore) {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            
                            self.score += matchScore * MATCH_BONUS;
                        }
                        else {
                            otherCard.faceUp = NO;
                            self.score -= MIS_MATCH_PENALTY;
                        }
                        break;
                    }
                }
                self.score -= FLIP_COST;
            }
            card.faceUp = !card.isFaceUp;
        }
    }
    else if (self.matchismoGameMode == MatchismoGameMode3CardsMatch) {
        //TODO 3 Cards Match Mode
        if (!card.isUnplayable) {
            if (!card.isFaceUp) {
                if (self.matchCardsHolder.count == 0) {// 1st flip
                    card.faceUp = YES;
                    [self.matchCardsHolder addObject:card];
                }
                else if (self.matchCardsHolder.count == 1) {// 2nd flip
                    int matchScore = [card match:self.matchCardsHolder];
                    
                    if (matchScore) {
                        Card *matchCard = [self.matchCardsHolder lastObject];
                        matchCard.unplayable = YES;
                        card.faceUp = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        [self.matchCardsHolder addObject:card];
                    }
                    else {// fail to match
                        card.faceUp = YES;
                        Card *unmatchCard = [self.matchCardsHolder lastObject];
                        unmatchCard.faceUp = NO;
                        [self.matchCardsHolder removeLastObject];
                        [self.matchCardsHolder addObject:card];
                    }
                }
                else if (self.matchCardsHolder.count == 2) {// 3rd flip
                    int scoreFlag = 0;
                    Card *card1ToMatch = [self.matchCardsHolder objectAtIndex:0];
                    int matchScore1 = [card match:@[card1ToMatch]];
                    Card *card2ToMatch = [self.matchCardsHolder objectAtIndex:1];
                    int matchScore2 = [card match:@[card2ToMatch]];
                    
                    if (matchScore1) {
                        scoreFlag += matchScore1;
                        self.score += matchScore1 * MATCH_BONUS_TRIPLE;
                    }
                    
                    if (matchScore2) {
                        scoreFlag += matchScore2;
                        self.score += matchScore2 * MATCH_BONUS_TRIPLE;
                    }
                    
                    if (scoreFlag) {
                        if ([self faceUpPlayableCard]) [self faceUpPlayableCard].faceUp = NO;// make other faceup card face down
                        card.unplayable = YES;
                        card.faceUp = YES;
                        [self.matchCardsHolder removeAllObjects];// done 3 cards match, remove them from holder for new match
                    }
                    else {// fail to match
                        
                        // check any other faceup & playable card
                        if ([self faceUpPlayableCard]) {
                            [self faceUpPlayableCard].faceUp = NO;
                        }
                        card.faceUp = YES;
                    }
                }
            }
            NSLog(@"Holder Count: %d", self.matchCardsHolder.count);
            self.score -= FLIP_COST;
        }
    }
}

- (Card *)faceUpPlayableCard
{
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            return card;
        }
    }
    return nil;
}

- (NSMutableArray *)matchCardsHolder
{
    if (!_matchCardsHolder) _matchCardsHolder = [NSMutableArray array];
    return _matchCardsHolder;
}

@end
