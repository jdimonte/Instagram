//
//  EditProfileViewController.h
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UITextView *name;
@property (strong, nonatomic) IBOutlet UITextView *bio;

@end

NS_ASSUME_NONNULL_END
