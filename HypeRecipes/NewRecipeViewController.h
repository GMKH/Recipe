//
//  NewRecipeViewController.h
//  HypeRecipes
//
//  Created by Mina Khosravifard on 02/08/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRecipeViewController : UIViewController<UITextFieldDelegate>
- (IBAction)postNewRecipe:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UITextField *RecipeDiffculty;
@property (weak, nonatomic) IBOutlet UITextView *recipeInstructions;
@property (weak, nonatomic) IBOutlet UITextField *recipeDescription;

@end
