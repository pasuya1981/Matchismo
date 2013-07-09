//
//  Deck.h
//  Matchismo
//
//  Created by ZackFang on 7/5/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end
