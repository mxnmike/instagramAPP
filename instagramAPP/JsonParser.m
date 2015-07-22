//
//  JsonParser.m
//  instagramAPP
//
//  Created by Miguel Garcia Topete on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "JsonParser.h"
#import "PictureObject.h"
@implementation JsonParser
-(void)startParsingData:(NSData *)data
{
    
    NSMutableArray *resultObjects = [[NSMutableArray alloc]init];
    NSError *error;

    NSMutableDictionary *pictureArray = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments error:&error];
    
    //Parse objects into MutableArray
    int x;
    NSArray *arrSelfies = [pictureArray objectForKey:@"data"];
    x = [[[pictureArray objectForKey:@"meta"] objectForKey:@"code"] intValue];

    if (arrSelfies == nil)
    {

        arrSelfies = [pictureArray objectForKeyedSubscript:@"meta"];
    }
    if (x == 200)
    {
        x=0;
        for (NSDictionary *currentSelfy in arrSelfies)
        {
            PictureObject *pic = [[PictureObject alloc]init];
            pic.strURLThumb = [[[currentSelfy objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
            pic.strURLLowRes = [[[currentSelfy objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
            pic.strURLStdRes = [[[currentSelfy objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
            pic.strFromUser = [[currentSelfy objectForKey:@"user"] objectForKey:@"username"];
            [resultObjects addObject:pic];
        }
        
        NSURL *nextPageURL = [NSURL URLWithString:[[pictureArray objectForKey:@"pagination"] objectForKey:@"next_url"]];
        
        [resultObjects addObject:nextPageURL];

        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            
            if ([self.delegate respondsToSelector:@selector(ParseFinishedWithObjects:)])
            {
                [self.delegate performSelector:@selector(ParseFinishedWithObjects:) withObject:resultObjects];
            }
            else
            {
                NSLog(@"Parse Finished. No delegate method or self de-allocated.");
            }
        });
    }
    else
    {
        //error Handling.
    }
}








@end
