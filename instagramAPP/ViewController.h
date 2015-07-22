//
//  ViewController.h
//  instagramAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;


@end

