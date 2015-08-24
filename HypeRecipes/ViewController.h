//
//  ViewController.h
//  HypeRecipes
//
//  Created by Mina Khosravifard on 09/07/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password_confirmation;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UIButton *btnGetRecipes;
- (IBAction)RegisterNewUser:(id)sender;
@end

