//
//  sillywalksaverView.h
//  sillywalksaver
//
//  Created by Mark Nagy on 2018. 11. 26..
//  Copyright © 2018. Mark Nagy. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface sillywalksaverView : ScreenSaverView
{
    CGFloat scale;
    NSImage *clockFace;
    NSImage *hourLeg;
    NSImage *minuteLeg;
}
@end
