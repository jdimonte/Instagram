//
//  PostCell.m
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/7/21.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeTapped:(id)sender {
    //updates likes count UI
    self.likes.text = [NSString stringWithFormat:@"%d",[self.likes.text intValue]+1 ];
}
- (IBAction)commentTapped:(id)sender {
    self.comments.text = [NSString stringWithFormat:@"%d",[self.comments.text intValue]+1 ];
}

@end
