//
//  User.h
//  Instagram
//
//  Created by Jacqueline DiMonte on 7/7/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFObject

@property (nonatomic, strong) NSString *username;

@end

NS_ASSUME_NONNULL_END
