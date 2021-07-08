//
//  PostCell.h
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *likes;
@property (strong, nonatomic) IBOutlet UILabel *comments;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end

NS_ASSUME_NONNULL_END
