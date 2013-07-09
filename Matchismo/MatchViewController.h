//
//  MatchViewController.h
//  Matchismo
//
//  Created by ZackFang on 7/5/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

typedef NS_ENUM (int, MatchismoGameState) {
    MatchismoGameStateFirstFlip = 0,
    MatchismoGameStateMatch,
    MatchismoGameStateMissMatch,
    MatchViewControllerEnd
};

#import <UIKit/UIKit.h>

@interface MatchViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) MatchismoGameState *matchismoGameState;
@end
