//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/8/21.
//

#import "EditProfileViewController.h"
#import "User.h"
#import <Parse/Parse.h>

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    User *user = [PFUser currentUser];
    self.name.text = user[@"name"];
    self.bio.text = user[@"bio"];
    PFFileObject *profileImage = user[@"profilePicture"];
    NSURL *profileUrl = [NSURL URLWithString:profileImage.url];
    NSData *profileData = [NSData dataWithContentsOfURL:profileUrl];
    UIImage *profilePhoto = [UIImage imageWithData:profileData];
    self.profilePicture.image = profilePhoto;
}
- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)changeProfilePictureTapped:(id)sender {
    NSLog(@"Image tapped");
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *newImage = [self resizeImage:editedImage withSize:CGSizeMake(500, 500)];
    
    // Do something with the images (based on your use case)
    [self.profilePicture setImage: newImage];
    User *currentUser = [PFUser currentUser];
    NSData *imageData = UIImagePNGRepresentation(currentUser[@"profilePicture"]);
    currentUser.profilePicture =  [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)changeNameTapped:(id)sender {
    User *user = [PFUser currentUser];
    user[@"name"] = self.name.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"fail");
        } else {
            NSLog(@"success");
        }
    }];
}
- (IBAction)changeBioTapped:(id)sender {
    User *user = [PFUser currentUser];
    user[@"bio"] = self.bio.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"fail");
        } else {
            NSLog(@"success");
        }
    }];
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
