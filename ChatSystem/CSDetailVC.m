//
//  CSDetailVC.m
//  ChatSystem
//
//  Created by Ahmed Durrani on 10/03/2020.
//  Copyright © 2020 Geranl. All rights reserved.
//

#import "CSDetailVC.h"
#import "DBChatManager.h"
#import "CSGrowingTextView.h"
#import "YPOReceiverCell.h"
#import "YPOSenderCell.h"
#import "NSDate+NVTimeAgo.h"
#import "Chat+CoreDataClass.h"
@interface CSDetailVC ()<UITableViewDelegate , UITableViewDataSource> {
    Chat *userChat ;

}

    @property (weak, nonatomic) IBOutlet UIView *contentView;
    //@property (weak, nonatomic) IBOutlet UITextView *textView;
    @property (weak, nonatomic) IBOutlet CSGrowingTextView *growingTextView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *growingTextViewHeightConstraint;
    @property (strong, nonatomic) NSMutableArray *dataArray;
    @property (weak, nonatomic) IBOutlet UITableView *tbleView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@end

@implementation CSDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderCell" bundle:nil] forCellReuseIdentifier:@"YPOSenderCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverCell" bundle:nil] forCellReuseIdentifier:@"YPOReceiverCell"];
    self.growingTextView.placeholderLabel.textColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1.0];
    _tbleView.rowHeight = UITableViewAutomaticDimension ;
    _tbleView.estimatedRowHeight = 100 ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(messageReceived:)
        name:@"ChatMessageReceived"
        object:nil];

//    [NotifCentre addObserver:self selector:@selector(messageReceived:)  name:@"ChatMessageReceived" object:nil];

    self.growingTextView.placeholderLabel.text = @"Type a message" ;
    
    NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , _selectUser.jabberId] ;
//    appDelegate.fromJabberId = _selectedUser.jaber_ID ;
    NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];

//    [Utility setViewBorder:self.growingTextView withWidth:2 andColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]];
    self.growingTextView.delegate = self;
    self.dataArray = [arrayOfRecentUser mutableCopy];

    NSLog(@"hel") ;

    
}

- (void)messageReceived:(NSNotification*)notif
{
    
    Chat *obj = notif.object ;

    dispatch_async(dispatch_get_main_queue(), ^(void) {

            [self.tbleView beginUpdates];
//
            NSIndexPath *row1 = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
            [self.dataArray insertObject:obj atIndex:_dataArray.count];
//
            [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];

            [self.tbleView endUpdates];
            if (self.dataArray.count == 0){
//                [clearbtn_Pressed setHidden:true];
            } else {
//                [clearbtn_Pressed setHidden:false];

        }
            if([self.tbleView numberOfRowsInSection:0]!=0)
            {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
                [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
            }});
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [NotifCentre postNotificationName:kChatNotificationRemoved object:nil];
   

//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.isViewVisible = false ;

    
    __weak id this = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      __strong CSDetailVC *strongThis = this;
                                                      [strongThis keyboardWillAppearNotification:note];
                                                  }];
    
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated: true ] ;
}


- (IBAction)btnSendMessage:(UIButton *)sender {
    
    [SharedDBChatManager sendAndSaveMeesage:self.growingTextView.internalTextView.text  andMessageType:@"1" roasterLoadUser:_selectUser ofThread: userChat withCompletionHandler:^(Chat *soMessage, BOOL success) {
        self.growingTextView.internalTextView.text = @"";
        self.growingTextView.placeholderLabel.text = @"Type a message" ;
        
                    [self.dataArray insertObject:soMessage atIndex:self.dataArray.count];
        //            [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
                    
                    
                    [self.tbleView reloadData];

//        dispatch_async(dispatch_get_main_queue(), ^(void) {
////            [self.tbleView beginUpdates];
//
////            NSIndexPath *row1 = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
////            [self.dataArray insertObject:soMessage atIndex:_dataArray.count];
////            [self.dataArray insertObject:soMessage atIndex:self.dataArray.count];
//////            [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
////
////
////            [self.tbleView reloadData];
//            //Always scroll the chat table when the user sends the message
////            if([self.tbleView numberOfRowsInSection:0]!=0)
////            {
////                NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
////                [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
////            }
//        }) ;
    }] ;
   
//    [SharedDBChatManager sendAndSaveMeesage:self.growingTextView.internalTextView.text andMessageType:@"1" roasterLoadUser:_selectUser ofThread:_ userChat: withCompletionHandler:^(Chat *soMessage, BOOL success) {
// ;
//
//    }] ;
//    [SharedDBChatManager sendAndSaveMeesage: self.growingTextView.internalTextView.text andMessageType:@"1" ofThread: _selectUser withCompletionHandler:^(Chat *soMessage, BOOL success) {
//
//    }] ;

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}


#pragma mark - Layout Changes

- (void)keyboardWillAppearNotification:(NSNotification *)note {
    
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect contentViewFrame = self.view.bounds;
    
    BOOL isKeyboardShown = (CGRectGetMinY(keyboardFrame) < CGRectGetHeight([[UIScreen mainScreen] bounds]));
    if (isKeyboardShown) {
        contentViewFrame.size.height -= CGRectGetHeight(keyboardFrame);
    }
    
    [self adjustTableViewFrame:contentViewFrame
          keyboardNotification:note];
}

- (void)adjustTableViewFrame:(CGRect)frame
        keyboardNotification:(NSNotification *)note {
    
    UIViewAnimationOptions animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak id this = self;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurve
                     animations:^{
                         
                         __strong CSDetailVC *strongThis = this;
                         
//                         self.contentViewBottomConstraint.constant = CGRectGetHeight(strongThis.view.bounds) - CGRectGetMaxY(frame);
                         [strongThis.contentView setNeedsUpdateConstraints];
                         [strongThis.contentView.superview layoutIfNeeded];
                     } completion:nil];
}



#pragma mark - CSGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(CSGrowingTextView *)textView {
    [textView resignFirstResponder];
    
//    self.textView.text = textView.internalTextView.text;
//    textView.internalTextView.text = @"";
    
    return YES;
}

- (void)growingTextView:(CSGrowingTextView *)growingTextView willChangeHeight:(CGFloat)height {
    __weak id this = self;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                      __strong CSDetailVC *strongThis = this;
                        strongThis.growingTextViewHeightConstraint.constant = height;
                        [strongThis.growingTextView setNeedsUpdateConstraints];
                        [strongThis.growingTextView.superview layoutIfNeeded];
                     } completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOReceiverCell *receiveCell = (YPOReceiverCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOReceiverCell" forIndexPath:indexPath];
    YPOSenderCell *cell = (YPOSenderCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOSenderCell"];
   
    Chat *obj ;
    if (self.dataArray.count > 0) {
      obj  = (Chat *)[self.dataArray objectAtIndex:indexPath.row];
    }
    
         if (obj.is_Mine == true) {
         
            receiveCell.lblTextInput.text = obj.message ;
             NSString *mysqlDatetime = obj.dateOfMessage ;
             NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];

            receiveCell.lblTime.text = timeAgoFormattedDate ;
            return  receiveCell ;
        }
        else {
            
            cell.textOfMessage.text  =  obj.message ;
            NSString *mysqlDatetime = obj.dateOfMessage ;
            NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];

//            receiveCell.lblTime.text = timeAgoFormattedDate ;
            cell.lblDate.text        =  timeAgoFormattedDate ;
            return  cell ;

        }

    }

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension ;

}
//-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    Chat *obj ;
//    if (self.dataArray.count > 0) {
//        obj  = (Chat *)[self.dataArray objectAtIndex:indexPath.row];
//    }
//
//    if (obj.is_Mine == true) {
//
//    } else {
//
//        if (_isAnimated == true){
//            CGRect frame = cell.frame ;
//            [cell setFrame:CGRectMake(0, self.tbleView.frame.size.height, frame.size.width , frame.size.height)];
//            //    [cell setFrame:CGRectMake(0, self.tbleView.frame.size.height, frame.width, frame.height)];
//            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
//                [cell setFrame:frame];
//            } completion:^(BOOL finished) {
//            }];
//        }
//
//
//    }
//}



@end
