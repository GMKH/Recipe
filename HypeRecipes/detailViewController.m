//
//  detailViewController.m
//  HypeRecipes
//
//  Created by Mina Khosravifard on 27/07/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import "detailViewController.h"
#import "TableandViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "KeychainItemWrapper.h"


@interface detailViewController ()

@property (strong) KeychainItemWrapper *keychain;
@property (strong) NSString *token;

@end

@implementation detailViewController
@synthesize recipeDescription,recipeDetail,recipeDifficulty,recipeImage,recipeInstruction;
@synthesize editdescription,editdifficulty,editname,editinstructions,token,keychain;



-(void)loadView{
    [super loadView];
    [self showrecipe];
    self.editname.hidden=true;
    self.editdifficulty.hidden=true;
    self.editdescription.hidden=true;
    self.editinstructions.hidden=true;
}

-(void)showrecipe{
    self.recipeDescription.text = [self.recipeDetail objectForKey:@"description"];
    self.recipeInstruction.text = [self.recipeDetail objectForKey:@"instructions"];
    self.recipeDifficulty.text = [[self.recipeDetail objectForKey:@"difficulty"]stringValue];
    self.recipeName.text = [self.recipeDetail objectForKey:@"name"];
    
    NSDictionary *urlPhoto=[recipeDetail objectForKey:@"photo"];
    if (!([urlPhoto objectForKey:@"url"]==[NSNull null])) {
        [self.recipeImage setImageWithURL:[NSURL URLWithString:[urlPhoto objectForKey:@"url"]]];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveUpdates:(id)sender {
    [self editCurrentRecipe];
  }

- (IBAction)activeEditMode:(id)sender{
    self.editname.hidden=false;
    self.editdifficulty.hidden=false;
    self.editdescription.hidden=false;
    self.editinstructions.hidden=false;
    
    self.editdescription.text = [self.recipeDetail objectForKey:@"description"];
    self.editinstructions.text = [self.recipeDetail objectForKey:@"instructions"];
    self.editdifficulty.text = [[self.recipeDetail objectForKey:@"difficulty"]stringValue];
    self.editname.text = [self.recipeDetail objectForKey:@"name"];

   
}

-(void)alert:(NSString*)title withMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)editCurrentRecipe{
    NSDictionary *recipesparameter=@{@"recipe": @{
                                             @"name": editname.text,
                                             @"description": editdescription.text,
                                             @"instructions": editinstructions.text,
                                             @"difficulty": [NSNumber numberWithInt:[editdifficulty.text intValue]],
                                             }};
    
    NSInteger recipesID= [[recipeDetail objectForKey:@"id"] intValue];
    NSURL *url = [NSURL URLWithString:@"http://hyper-recipes.herokuapp.com/recipes/"];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%d", recipesID] relativeToURL:url];
    
    NSURLSessionConfiguration *config1 = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //add the token to the request of http header
    keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"Hyper_recipes" accessGroup:nil];
    token = [keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *tokennotreal=token;
    NSString *tokenstring=@"Token token=";
    tokenstring= [tokenstring stringByAppendingString:tokennotreal];
    [config1 setHTTPAdditionalHeaders:@{@"Authorization":tokenstring}];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config1];
    
    
    // Convert the dictionary into JSON data.
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:recipesparameter
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[JSONData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:JSONData];
    
    NSError *error;
    if (!error) {
        
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:JSONData completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       NSLog(@"the http respoce is %@", response);
                                                                   }];
        [uploadTask resume];
        NSLog(@"upload recipes");
        recipeDetail=recipesparameter;
        [self alert:@"Update" withMessage:@"you are now successfully updated your recipe"];
    }
    
}



@end
