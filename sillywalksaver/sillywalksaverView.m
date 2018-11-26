//
//  sillywalksaverView.m
//  sillywalksaver
//
//  Created by Mark Nagy on 2018. 11. 26..
//  Copyright © 2018. Mark Nagy. All rights reserved.
//

#import "sillywalksaverView.h"

@implementation sillywalksaverView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:60.0];
        
        NSBundle* saverBundle = [NSBundle bundleForClass: [self class]];
        NSString* hourPath = [saverBundle pathForResource: @"hourLeg" ofType: @"png"];
        NSString* minutePath = [saverBundle pathForResource: @"minuteLeg" ofType: @"png"];
        
        minuteLeg = [[NSImage alloc] initWithContentsOfFile: minutePath];
        hourLeg = [[NSImage alloc] initWithContentsOfFile: hourPath];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [calendar components: (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate: now];
    
    NSInteger hour = dateComps.hour;
    NSInteger minute = dateComps.minute;
    NSInteger second = dateComps.second;
    
    NSBundle *saverBundle = [NSBundle bundleForClass: [self class]];

    NSString *bgPath = [saverBundle pathForResource: @"bricks" ofType: @"png"];
    NSString* facePath = [saverBundle pathForResource: @"clockface" ofType: @"png"];
    
    clockFace = [[NSImage alloc] initWithContentsOfFile: facePath];

    NSImage *bg = [[NSImage alloc] initWithContentsOfFile: bgPath];
    NSColor *backgroundColor = [NSColor colorWithPatternImage:bg];
    [backgroundColor set];

    NSRectFill ([self bounds]);
    
    [self drawClockFace];

    [self drawMinuteLegAtAngle:minute * 6.0 + second * 0.1];
    [self drawClockFace];
    [self drawHourLegAtAngle:(hour % 12) * 30.0 + minute * 0.5];
}

- (void)animateOneFrame
{
    self.needsDisplay = YES;
}

- (void)drawHourLegAtAngle:(CGFloat)angle
{
    CGSize newSize = CGSizeMake(hourLeg.size.width*scale, hourLeg.size.height*scale);
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    
    [transform translateXBy: self.bounds.size.width / 2.0
                        yBy: self.bounds.size.height / 2.0];
    [transform rotateByDegrees:-angle];
    
    [transform translateXBy: -newSize.width * 5/6
                        yBy: -newSize.height / 10];
    
    [transform concat];
    
    CGRect hourRect = CGRectMake(0, 0, newSize.width , newSize.height);
    
    [hourLeg drawInRect:hourRect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
    
    [context restoreGraphicsState];
    
}

-(void)drawMinuteLegAtAngle:(CGFloat)angle
{
    CGSize newSize = CGSizeMake(minuteLeg.size.width*scale, minuteLeg.size.height*scale);
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    
    [transform translateXBy: self.bounds.size.width / 2.0
                        yBy: self.bounds.size.height / 2.0];
    
    [transform rotateByDegrees:-angle];
    
    [transform translateXBy: -newSize.width * 3/4
                        yBy: -newSize.height / 10];
    
    [transform concat];
    
    CGRect minuteRect = CGRectMake(0, 0, newSize.width , newSize.height);
    
    [minuteLeg drawInRect:minuteRect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
    
    [context restoreGraphicsState];
}

-(void)drawClockFace
{
    CGFloat clockSize = self.bounds.size.height / 2.0;
    scale = clockSize / clockFace.size.height;
    
    NSRect clockRect = NSZeroRect;
    clockRect.origin.x = (self.bounds.size.width - clockSize) / 2.0;
    clockRect.origin.y = (self.bounds.size.height - clockSize) / 2.0;
    clockRect.size.width = clockSize;
    clockRect.size.height = clockSize;
    
    [clockFace drawInRect: clockRect fromRect: NSZeroRect
                operation: NSCompositingOperationSourceOver fraction: 1.0];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
