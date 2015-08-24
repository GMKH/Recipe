//
//  detailViewController.h
//  HypeRecipes
//
//  Created by Mina Khosravifard on 27/07/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController

//IBoutlets for defult mode
@property (strong,nonatomic) NSDictionary *recipeDetail;
@property (weak, nonatomic) IBOutlet UILabel *recipeInstruction;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeDescription;
@property (weak, nonatomic) IBOutlet UILabel *recipeDifficulty;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;

@property (weak, nonatomic) IBOutlet UITextField *editdifficulty;
@property (weak, nonatomic) IBOutlet UITextField *editname;
@property (weak, nonatomic) IBOutlet UITextField *editdescription;
@property (weak, nonatomic) IBOutlet UITextField *editinstructions;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *editActivateButton;

- (IBAction)saveUpdates:(id)sender;

- (IBAction)activeEditMode:(id)sender;


@end
