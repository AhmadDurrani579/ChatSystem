//
//  ViewController.m
//  ChatSystem
//
//  Created by Ahmed Durrani on 10/03/2020.
//  Copyright © 2020 Geranl. All rights reserved.
//

#import "ViewController.h"
#import "DBChatManager.h"
#import "MOModelUser.h"
#import "UserInfoCell.h"
#import "CSDetailVC.h"
@interface ViewController () <UITableViewDelegate  , UITableViewDataSource> {
    
//    MOModelUser* model ;
    __weak IBOutlet UITableView *tblView;
    NSArray<MOModelUser *> *players ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    players = @[
        [[MOModelUser alloc] initWithModel:@"Ahmad" jabberId:@"ahmed_1@service61.secureother.com"],
        [[MOModelUser alloc] initWithModel:@"srk" jabberId:@"srk_1@service61.secureother.com"],
        [[MOModelUser alloc] initWithModel:@"srk2" jabberId:@"srk_2@service61.secureother.com"],
        [[MOModelUser alloc] initWithModel:@"Anupam" jabberId:@"anupam@service61.secureother.com"],
        [[MOModelUser alloc] initWithModel:@"jaspreet" jabberId:@"jaspreet@service61.secureother.com"],

    ];
    [SharedDBChatManager makeConnectionWithChatServer];

//    model  = [MOModelUser new];
    
//    model.name = ""
    
    // Do any additional setup after loading the view.
}

- (IBAction)btnSendMessage:(UIButton *)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  players.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   UserInfoCell *receiveCell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
    MOModelUser *obj  = (MOModelUser *)[players objectAtIndex:indexPath.row];
    receiveCell.lblTextInput.text = obj.name ;
    return  receiveCell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60.0 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CSDetailVC"];
    MOModelUser *checkList = (MOModelUser *)[players objectAtIndex:indexPath.row];
    vc.selectUser = checkList ;
    [self.navigationController pushViewController:vc animated:true] ;

}
@end
