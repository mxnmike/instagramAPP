//
//  ViewController.m
//  instagramAPP
//
//  Created by Miguel Garcia Topete on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "ViewController.h"
#import "WebHandler.h"
#import "JsonParser.h"
#import "CustomCellObject.h"
#import "PictureObject.h"

#define INSTAGRAM_URL @"https://api.instagram.com/v1/tags/selfie/media/recent?client_id=babb6803c17245479863a5ed7a02f248"

NSArray *arrayOfObjects;
NSArray *tmpArray;
WebHandler *wh;
NSURL *currentURL;
@interface ViewController ()<WebHandlerDelegate,JsonParserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    wh = [WebHandler new];
    arrayOfObjects = [NSArray new];
    currentURL = [NSURL URLWithString:INSTAGRAM_URL];
    [wh setDelegate:self];
    [wh startConnectionWithURL:currentURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayOfObjects.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0)
    {
        return CGSizeMake(300, 300);
    }
    else
    {
        return CGSizeMake(145, 145);
    }
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellObject *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.alpha = 0.0;
    PictureObject *aPicture = [arrayOfObjects objectAtIndex:indexPath.row];
    
    if (aPicture.imgLowRes)
    {
        cell.imgView.image = aPicture.imgLowRes;
        cell.alpha = 1.0;
    }
    else
    {
        dispatch_queue_t myQueue = dispatch_queue_create("one", nil);
        dispatch_async(myQueue, ^(void){
            [aPicture setImgLowRes:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aPicture.strURLLowRes]]]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [cell.imgView setImage:aPicture.imgLowRes];
                [UIView animateWithDuration:0.25 animations:^{
                    cell.alpha = 1.0f;
                }];
                
            });
        });
    }
    if (indexPath.row == arrayOfObjects.count-3)
    {
        [wh startConnectionWithURL:currentURL];
    }

    
    return cell;
}


#pragma mark - WebHandler Delegate

-(void)didFinishSuccesfullWithData:(NSData *)data
{
    JsonParser *parser = [JsonParser new];
    [parser setDelegate:self];
    [parser startParsingData:data];
    
}

-(void)didFinishWithErrors:(NSError *)error
{
    
}



#pragma mark -JsonParser Delegate
-(void)ParseFinishedWithObjects:(NSMutableArray *)parsedObjects
{
    currentURL = [parsedObjects lastObject];
    [parsedObjects removeLastObject];
    arrayOfObjects = [arrayOfObjects arrayByAddingObjectsFromArray:[parsedObjects copy]];
    [self.mainCollectionView reloadData];

}
-(void)ParseFailedWithError:(NSError *)parseError
{
    
}
@end
