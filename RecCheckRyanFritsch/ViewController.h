//
//  ViewController.h
//  RecCheckRyanFritsch
//
//  Created by Ryan Fritsch on 1/6/16.
//  Copyright © 2016 Ryan Fritsch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface ViewController : UIViewController{
    MKMapView *mapView;

}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;



@end

