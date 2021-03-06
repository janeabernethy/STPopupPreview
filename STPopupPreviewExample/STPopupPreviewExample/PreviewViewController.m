//
//  PreviewViewController.m
//  STPopupPreviewExample
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "PreviewViewController.h"
#import "ImageLoader.h"
#import <STPopup/STPopup.h>

@interface PreviewViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *captionLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *footerViewHeightConstraint;

@end

@implementation PreviewViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // Default content size
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Resize content size based on image dimensions
    CGFloat imageWidth = [self.data[@"dimensions"][@"width"] doubleValue];
    CGFloat imageHeight = [self.data[@"dimensions"][@"height"] doubleValue];
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat contentHeight = contentWidth * imageHeight / imageWidth + _headerViewHeightConstraint.constant + _footerViewHeightConstraint.constant;
    self.contentSizeInPopup = CGSizeMake(contentWidth, contentHeight);
    
    self.avatarImageView.layer.cornerRadius = 16;
    NSURL *avatarImageURL = [NSURL URLWithString:@"https://igcdn-photos-b-a.akamaihd.net/hphotos-ak-ash/t51.2885-19/10808772_990078594337433_65931114_a.jpg"];
    if ([ImageLoader cachedImageForURL:avatarImageURL]) {
        self.avatarImageView.image = [ImageLoader cachedImageForURL:avatarImageURL];
    }
    else {
        [ImageLoader loadImageForURL:avatarImageURL completion:^(UIImage *image) {
            self.avatarImageView.image = image;
        }];
    }
    
    self.imageView.image = self.placeholderImage;
    [ImageLoader loadImageForURL:[NSURL URLWithString:self.data[@"display_src"]] completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    self.captionLabel.text = self.data[@"caption"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.popupController.navigationBarHidden = YES;
}

@end
