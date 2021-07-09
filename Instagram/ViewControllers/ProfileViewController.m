//
//  ProfileViewController.m
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/8/21.
//

#import "ProfileViewController.h"
#import "User.h"
#import "Post.h"
#import "ProfilePostCell.h"
#import "DetailsViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *profilePostsArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self displayUserProfile];
    
    [self loadQueryPosts:20];
    
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
    
    self.profilePicture.layer.cornerRadius =  self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = true;

}

- (void) loadQueryPosts: (int)numUnique{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    User *user = [PFUser currentUser];
    
    //NOTE: not finding any posts
    //[query whereKey:@"author" equalTo:user.objectId];
    
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    NSLog(@"%@", user.objectId);
    
    query.limit = numUnique;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.profilePostsArray = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCell *cell = (ProfilePostCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell"forIndexPath:indexPath];
    Post *postInfo = self.profilePostsArray[indexPath.row];
    PFFileObject *postImage = postInfo[@"image"];
    NSURL *url = [NSURL URLWithString:postImage.url];
    NSData *photoData = [NSData dataWithContentsOfURL:url];
    UIImage *photo = [UIImage imageWithData:photoData];
    [cell.image setImage: photo];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.profilePostsArray.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailsFromProfile"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.profilePostsArray[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}


@end
