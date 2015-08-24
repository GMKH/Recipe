//
//  NewRecipeViewController.m
//  HypeRecipes
//
//  Created by Mina Khosravifard on 02/08/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import "NewRecipeViewController.h"
#import "KeychainItemWrapper.h"

@interface NewRecipeViewController (){
   
}
@property (strong) KeychainItemWrapper *keychain;
@property (strong) NSString *token;
@end

@implementation NewRecipeViewController
@synthesize recipeName,RecipeDiffculty,recipeInstructions,recipeDescription,keychain,token;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.recipeDescription resignFirstResponder];
    [self.recipeInstructions resignFirstResponder];
}

-(void)alert:(NSString*)title withMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)postNewRecipe:(id)sender {
    
        NSDictionary *recipesparameter=@{@"recipe": @{
                                                 @"name": recipeName.text,
                                                 @"description": recipeDescription.text,
                                                 @"instructions": recipeInstructions.text,
                                                 @"difficulty": [NSNumber numberWithInt:[RecipeDiffculty.text intValue]],
                                                 }};
        
        NSURLSessionConfiguration *config1 = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"Hyper_recipes" accessGroup:nil];
        token = [keychain objectForKey:(__bridge id)(kSecValueData)];
        NSString *tokennotreal=token;
        NSString *tokenstring=@"Token token=";
        tokenstring= [tokenstring stringByAppendingString:tokennotreal];
        
        //[config1 setHTTPAdditionalHeaders:@{@"Authorization":@"Token token=\"3f78124e98419428b7f7\""}];
        [config1 setHTTPAdditionalHeaders:@{@"Authorization":tokenstring}];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config1];
        
        NSError *error;
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:recipesparameter
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://hyper-recipes.herokuapp.com/recipes"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsondata];
        
        if (!error) {
            
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                       fromData:jsondata completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                           NSLog(@"the http respoce is %@", response);
                                                                       }];
            [uploadTask resume];
            NSLog(@"upload recipes");
        }
    
   }
@end
