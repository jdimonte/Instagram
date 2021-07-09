//
//  DetailsViewController.m
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/7/21.
//

#import "DetailsViewController.h"
#import "User.h"

@interface DetailsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *timePosted;
@property (strong, nonatomic) IBOutlet UILabel *caption;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *caption = self.post[@"caption"];
    self.caption.text = caption;
    
//    NSNumber *likeCount = self.post[@"likeCount"];
//    NSNumber *commentCount = self.post[@"commentCount"];
//    self.likes.text = [likeCount stringValue];
//    self.comments.text = [commentCount stringValue];
    
    PFFileObject *postImage = self.post[@"image"];
    NSURL *url = [NSURL URLWithString:postImage.url];
    NSData *photoData = [NSData dataWithContentsOfURL:url];
    UIImage *photo = [UIImage imageWithData:photoData];
    [self.image setImage: photo];
    
    self.profilePicture.layer.cornerRadius =  self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = true;
    
    User *user = self.post[@"author"];
    if(user != nil){
        self.username.text = user.username;
    }
    
    PFFileObject *profileImage = user[@"profilePicture"];
    NSURL *profileUrl = [NSURL URLWithString:profileImage.url];
    NSData *profileData = [NSData dataWithContentsOfURL:profileUrl];
    UIImage *profilePhoto = [UIImage imageWithData:profileData];
    self.profilePicture.image = profilePhoto;
    
    NSDate *date = self.post.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd 'at' HH:mm";
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.timePosted.text = dateString;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
