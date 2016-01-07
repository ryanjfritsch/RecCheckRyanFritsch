//
//  SavedPinsTableViewController.h
//  RecCheckRyanFritsch
//
//  Created by Ryan Fritsch on 1/6/16.
//  Copyright © 2016 Ryan Fritsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedPinsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) NSArray* pinArray;

//@property (strong, nonatomic) IBOutlet UITableView *pinTable;

@end
