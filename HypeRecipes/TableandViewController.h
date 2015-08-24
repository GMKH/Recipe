//
//  TableandViewController.h
//  HypeRecipes
//
//  Created by Mina Khosravifard on 28/07/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableandViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)addRecipe:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
