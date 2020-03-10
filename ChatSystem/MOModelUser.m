//
//  MOModelUser.m
//  ChatSystem
//
//  Created by Ahmed Durrani on 10/03/2020.
//  Copyright © 2020 Geranl. All rights reserved.
//

#import "MOModelUser.h"

@implementation MOModelUser

-(id)initWithModel:(NSString *)name jabberId:(NSString*)jabberId {
    self.name = name;
    self.jabberId = jabberId;
    return self;
}


@end
