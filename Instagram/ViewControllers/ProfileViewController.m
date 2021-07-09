//
//  ProfileViewController.m
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/8/21.
//

#import "ProfileViewController.h"
#import "User.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self displayUserProfile];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayUserProfile) userInfo:nil repeats:true];
}

- (void) displayUserProfile {
    User *user = [PFUser currentUser];
    
    self.username.text = user[@"username"];
    self.name.text = user[@"name"];
    self.bio.text = user[@"bio"];
    
    PFFileObject *profileImage = user[@"profilePicture"];
    NSURL *profileUrl = [NSURL URLWithString:profileImage.url];
    NSData *profileData = [NSData dataWithContentsOfURL:profileUrl];
    UIImage *profilePhoto = [UIImage imageWithData:profileData];
    self.profilePicture.image = profilePhoto;
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
