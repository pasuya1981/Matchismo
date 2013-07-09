//
//  MatchViewController.m
//  Matchismo
//
//  Created by ZackFang on 7/5/13.
//  Copyright (c) 2013 Pasuya. All rights reserved.
//

#import "MatchViewController.h"
#import "PlayingCardDeck.h"
#import "Deck.h"
#import "Card.h"
#import "CardMatchingGame.h"

@interface MatchViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tapCountLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;// of Model Ruls
@property (weak, nonatomic) IBOutlet UILabel *gameStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;
@property (weak, nonatomic) IBOutlet UISlider *gameModeSlider;
@property (strong, nonatomic) NSMutableDictionary *memoryStack;
@end

@implementation MatchViewController


- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

// Tracking Score and Card states for updating UI messgae
static int previsousScore = 0;
static Card *flippingCard;
static Card *otherFaceupPlayableCard;

- (void)updateUI
{    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateDisabled|UIControlStateSelected];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"poker-back.png"] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"poker-front.png"] forState:UIControlStateSelected];
        
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1;
    }
    
    if (self.game.matchismoGameMode == MatchismoGameMode2CardsMatch) {// 2 cards match mode
        
        if (!otherFaceupPlayableCard && !flippingCard) {
            self.gameStateLabel.text = @"Ready to GO!";
        }
        else if (!otherFaceupPlayableCard) {// fist time flipping card
            self.gameStateLabel.text = [NSString stringWithFormat:@"%@ Flipped!", flippingCard.contents];
        }
        else {
            if (previsousScore > self.game.score) {// Penalty
                int negativeScore = self.game.score - previsousScore;
                previsousScore = self.game.score;
                self.gameStateLabel.text = [NSString stringWithFormat:@"%@ & %@ Don't Match, %d penalty!",
                                            flippingCard.contents, otherFaceupPlayableCard.contents, negativeScore];
            }
            else {// Match
                int positiveScore = self.game.score - previsousScore;
                previsousScore = self.game.score;
                self.gameStateLabel.text = [NSString stringWithFormat:@"%@ & %@ Match, Get Point: %d",
                                            flippingCard.contents, otherFaceupPlayableCard.contents, positiveScore];
            }
        }
    }
    else if (self.game.matchismoGameMode == MatchismoGameMode3CardsMatch) {// 3 cards match mode
        // TODE--Update UI
        NSLog(@"MatchismoGameMode3CardsMatch");
    }
    
    // Update Score Label
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.tapCountLabel.text = [NSString stringWithFormat:@"Tap Count: %d", _flipCount];
}

- (void)setGameModeLabel:(UILabel *)gameModeLabel
{
    _gameModeLabel = gameModeLabel;
    if (self.game.matchismoGameMode == MatchismoGameMode2CardsMatch) {
        self.gameModeLabel.text = @"2 Card Match Mode";
    }
    else if (self.game.matchismoGameMode == MatchismoGameMode3CardsMatch) {
        self.gameModeLabel.text = @"3 Card Match Mode";
    }
}

- (IBAction)didFlipCard:(UIButton *)sender
{
    // Let Model flip the card
    NSUInteger flippingIndex = [self.cardButtons indexOfObject:sender];
    flippingCard = [self.game cardAtIndex:flippingIndex];// of static variable outside function
    otherFaceupPlayableCard = [self otherFaceupPlayableCard];// check if any faceup & playable card BEFORE model flips the card
    [self.game flipCardAtIndex:flippingIndex];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)didTapDealButton
{
    self.game = nil;
    previsousScore = 0;
    flippingCard = nil;
    otherFaceupPlayableCard = nil;
    self.flipCount = 0;
    self.game.matchismoGameMode = (self.gameModeSlider.value < 1.5) ? MatchismoGameMode2CardsMatch : MatchismoGameMode3CardsMatch;
    [self updateUI];
}

- (IBAction)gameModeDidChange:(UISlider *)sender
{
    if (sender.value <= 1.5) {
        [self didTapDealButton];
        self.game.matchismoGameMode = MatchismoGameMode2CardsMatch;
        self.gameModeLabel.text = @"2 Card Match Mode";
    }
    else if (sender.value > 1.5) {
        [self didTapDealButton];
        self.game.matchismoGameMode = MatchismoGameMode3CardsMatch;
        self.gameModeLabel.text = @"3 Card Match Mode";
    }
}

#pragma mark - Utility Methods

// Examine the User Interface for faceup and playable card
- (Card *)otherFaceupPlayableCard
{
    Card *card;
    for (NSUInteger index = 0; index < [self.cardButtons count]; index++) {
        card = [self.game cardAtIndex:index];
        if (card.isFaceUp && !card.isUnplayable) return card;
    }
    return nil;
}

@end
