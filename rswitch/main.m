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
        CGDisplayModeRef mode;
        CFIndex index, count;
        CFArrayRef modeList;
        long width, height;
        BOOL success = NO;
        
        modeList = CGDisplayCopyAllDisplayModes (main, NULL);
        count = CFArrayGetCount (modeList);
        
        for (index = 0; index < count; index++) // 4
        {
            mode = (CGDisplayModeRef)CFArrayGetValueAtIndex (modeList, index);
            height = CGDisplayModeGetHeight(mode);
            width = CGDisplayModeGetWidth(mode);
            
            if (width == 2880 && height == 1800) {
                success = YES;
                break;
            }
        }

        CFRelease(modeList);
        
        if (!success) { 
            NSLog(@"Could not locate 2880x1800 display mode for main monitor.");
        }
        
        CGDisplayConfigRef cfg;
        CGError err = CGBeginDisplayConfiguration(&cfg);
        
        if (err != kCGErrorSuccess) {
            NSLog((__bridge NSString*) CFSTR("FAIL: %u"), err);
            return 0;
        }
        err = CGConfigureDisplayWithDisplayMode(cfg, main, mode, NULL);
        if (err != kCGErrorSuccess) {
            NSLog((__bridge NSString*) CFSTR("FAIL: %u"), err);
            return 0;
        }

        err = CGCompleteDisplayConfiguration(cfg, kCGConfigurePermanently);
        if (err != kCGErrorSuccess) {
            NSLog((__bridge NSString*) CFSTR("FAIL: %u"), err);
            return 0;
        }

    }
    return 0;
}

