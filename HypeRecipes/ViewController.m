//
//  ViewController.m
//  HypeRecipes
//
//  Created by Mina Khosravifard on 09/07/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"

@interface ViewController ()
@property (strong) KeychainItemWrapper *keychain;

@end

@implementation ViewController
@synthesize keychain,email,password,password_confirmation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btnGetRecipes.hidden=true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailpattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailpattern];
    return [emailTest evaluateWithObject:emailStr];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.password_confirmation resignFirstResponder ];
}


-(void)addTokentoKeychain:(NSString*)auth_token{
    
    keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"Hyper_recipes" accessGroup:nil];
    [keychain setObject:auth_token forKey:(__bridge id)(kSecValueData)];
}

-(void)reArrangeDislayButton{
    self.btnGetRecipes.hidden=false;
    self.btnRegister.hidden=true;
}

-(void)addRegisteredFlag{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"RegisteredFlag"];
    [defaults synchronize];
}

-(void)registerUser{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters = @{@"user": @{@"email": email.text, @"password": password.text, @"password_confirmation": password_confirmation.text,@"seed_recipes":@"true"}};
    [manager POST:@"http://hyper-recipes.herokuapp.com/users" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *token=responseObject;
        [self addTokentoKeychain:[token valueForKey:@"auth_token"]];
        [self addRegisteredFlag];
        [self reArrangeDislayButton];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Status code:%@", error);
    }];

}

-(void)alert:(NSString*)title withMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)RegisterNewUser:(id)sender {
    if ((email.text.length && password.text.length && password_confirmation.text.length > 0) && ([self validateEmail:email.text]))
    {
        [self registerUser];
        [self alert:@"Congrats" withMessage:@"You are now parts of HypeRecipes."];
        self.btnGetRecipes.hidden=false;
        self.btnRegister.hidden=true;
        
    }
    else
    {
        [self alert:@"Error" withMessage:@"You must correctly fill all fields first."];
    }

}
@end
