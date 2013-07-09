//
//  Card.m
//  Matchismo
//
//  Created by ZackFang on 7/5/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
