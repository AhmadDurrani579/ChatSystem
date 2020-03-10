//
//  MOModelUser.h
//  ChatSystem
//
//  Created by Ahmed Durrani on 10/03/2020.
//  Copyright © 2020 Geranl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface MOModelUser : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *jabberId;

-(id)initWithModel:(NSString *)name
          jabberId:(NSString*)jabberId ;


@end

NS_ASSUME_NONNULL_END
