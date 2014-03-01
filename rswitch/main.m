//
//  main.m
//  rswitch
//
//  Created by Greg Eldridge on 6/18/12.
//  This is a very basic usage of the OS API.  You may do with it as you wish.
//  Please mail corrections, suggestions or questions to greg@desult.com.
//
    
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
       
        // based on https://developer.apple.com/library/mac/#documentation/graphicsimaging/Conceptual/QuartzDisplayServicesConceptual/Articles/DisplayModes.html
        CGDirectDisplayID main =  CGMainDisplayID();        
        CGDisplayModeRef mode, largestMode;
        CFArrayRef modeList;
        CFStringRef bpp_str;
        
        modeList = CGDisplayCopyAllDisplayModes (main, NULL);
        CFIndex count = CFArrayGetCount (modeList);
        
        largestMode = (CGDisplayModeRef)CFArrayGetValueAtIndex (modeList, 0);
        for (CFIndex index = 1; index < count; index++) // 4
        {
            mode = (CGDisplayModeRef)CFArrayGetValueAtIndex (modeList, index);
            bpp_str = CGDisplayModeCopyPixelEncoding(mode);
            CFIndex bpp = CFStringGetLength(bpp_str);
            CFRelease(bpp_str);
            if(bpp == 32 && (CGDisplayModeGetWidth(mode) > CGDisplayModeGetWidth(largestMode) || CGDisplayModeGetHeight(mode) > CGDisplayModeGetHeight(largestMode))) {
                largestMode = mode;
            }
            
        }

        CFRelease(modeList);
        
        CGDisplayConfigRef cfg;
        CGError err = CGBeginDisplayConfiguration(&cfg);
        
        if (err != kCGErrorSuccess) {
            NSLog(@"FAILED: %d", err);
            return 0;
        }
        err = CGConfigureDisplayWithDisplayMode(cfg, main, largestMode, NULL);
        if (err != kCGErrorSuccess) {
            NSLog(@"FAILED: %d", err);
            return 0;
        }

        err = CGCompleteDisplayConfiguration(cfg, kCGConfigurePermanently);
        if (err != kCGErrorSuccess) {
            NSLog(@"FAILED: %d", err);
            return 0;
        }
        
        NSLog(@"Success.");

    }
    return 0;
}

