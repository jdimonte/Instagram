//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/6/21.
//

#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "Post.h"
#import "User.h"
#import <Parse/Parse.h>

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(setPostsArray) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setPostsArray];
}
- (IBAction)logoutTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (void) setPostsArray: (int) numOfElements{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    [query includeKey:@"user"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    query.limit = numOfElements;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = posts;
            NSLog(@"Hello");
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void) setPostsArray{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    //[query includeKey:@"user"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = posts;
            NSLog(@"Hello");
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        return;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:@"PostCell"forIndexPath:indexPath];
    Post *postInfo = self.postsArray[indexPath.row];
    
    NSString *caption = postInfo[@"caption"];
    cell.caption.text = caption;
    
    NSNumber *likeCount = postInfo[@"likeCount"];
    NSNumber *commentCount = postInfo[@"commentCount"];
    cell.likes.text = [likeCount stringValue];
    cell.comments.text = [commentCount stringValue];
    
    PFFileObject *postImage = postInfo[@"image"];
    NSURL *url = [NSURL URLWithString:postImage.url];
    NSData *photoData = [NSData dataWithContentsOfURL:url];
    UIImage *photo = [UIImage imageWithData:photoData];
    [cell.image setImage: photo];
    
//    User *user = postInfo[@"author"];
//    if(user != nil){
//        cell.username.text = user.username;
//    }
    NSLog(@"Hi");
    
    cell.profilePicture.layer.cornerRadius =  cell.profilePicture.frame.size.width / 2;
    cell.profilePicture.clipsToBounds = true;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postsArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.postsArray count]){
        int count = [self.postsArray count];
        count += 20;
        [self setPostsArray:count];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"details"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}


@end
