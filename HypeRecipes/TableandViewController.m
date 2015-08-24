//
//  TableandViewController.m
//  HypeRecipes
//
//  Created by Mina Khosravifard on 28/07/15.
//  Copyright (c) 2015 Mina Khosravifard. All rights reserved.
//

#import "TableandViewController.h"
#import "detailViewController.h"
#import "KeychainItemWrapper.h"
#import "AFNetworking.h"

@interface TableandViewController ()
{
    NSURLSessionConfiguration *config;
    NSMutableArray *userarray;
    KeychainItemWrapper *keychain;
}

@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong) KeychainItemWrapper *keychain;
@property (strong) NSString *token;


@end

@implementation TableandViewController
@synthesize keychain,recipes,token;

- (void)viewdidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"Hyper_recipes" accessGroup:nil];
        token = [keychain objectForKey:(__bridge id)(kSecValueData)];
        [self getrecipes];
        [self.tableView reloadData]; // to reload selected cell
        
    });
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getrecipes];
        [self.tableView reloadData]; 

    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_main_queue(), ^{
        keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"Hyper_recipes" accessGroup:nil];
        token = [keychain objectForKey:(__bridge id)(kSecValueData)];
        //[self getrecipes];
        //[self.tableView reloadData];
        
    });
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma get recipe,delete recipe

-(void)getrecipes{
    NSURL *url = [NSURL URLWithString:@"http://hyper-recipes.herokuapp.com/recipes"];
    config = [NSURLSessionConfiguration defaultSessionConfiguration];
    keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"Hyper_recipes" accessGroup:nil];
    token = [keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *tokennotreal=token;
    NSString *tokenstring=@"Token token=";
    tokenstring= [tokenstring stringByAppendingString:tokennotreal];
    [config setHTTPAdditionalHeaders:@{@"Authorization":tokenstring}];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        recipes= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }
      ] resume];
}

-(void)deleteRecipewith:(int)recipeID{
    NSURL *url = [NSURL URLWithString:@"http://hyper-recipes.herokuapp.com/recipes/"];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%d", recipeID] relativeToURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *tokennotreal=token;
    NSString *tokenstring=@"Token token=";
    tokenstring= [tokenstring stringByAppendingString:tokennotreal];
    [config setHTTPAdditionalHeaders:@{@"Authorization":tokenstring}];

    
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request
                                                                                   completionHandler:^(NSData *data,
                                                                                                       NSURLResponse *response,
                                                                                                       NSError *error)
                                  {
                                      if (!error)
                                      {
                                          NSLog(@"delete Status code: %i", ((NSHTTPURLResponse *)response).statusCode);
                                      }
                                      else
                                      {
                                          NSLog(@"delete Error: %@", error.localizedDescription);
                                      }
                                  }];
    
    // Start the task.
    [task resume];
    
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [recipes count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"icell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell==Nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    NSDictionary *tempDictionary= [recipes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];    // Configure the cell...
    cell.detailTextLabel.text=[tempDictionary objectForKey:@"difficulty"] ;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tempDictionary=[recipes objectAtIndex:indexPath.row];
    NSInteger recipesID= [[tempDictionary objectForKey:@"id"] intValue];
    [self deleteRecipewith:recipesID];

    [recipes removeObjectAtIndex:indexPath.row];
    [tableView reloadData];

    
}

#pragma mark - Navigation


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if([segue.identifier isEqualToString:@"DetailRecipeView"]){
         detailViewController *vc=[segue destinationViewController];
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         vc.recipeDetail = [self.recipes objectAtIndex:indexPath.row];
 
 }
 
 }


- (IBAction)addRecipe:(id)sender {
    
}
@end
