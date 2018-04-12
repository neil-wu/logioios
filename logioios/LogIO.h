//
//  LogIO.h
//  logioios
//
//  Created by appdev on 2018/4/12.
//  Copyright © 2018年 test. All rights reserved.
//


#ifndef LogIO_h
#define LogIO_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
 
    void logio(NSString* format, ...);
    
    int logio_init(const char* hostname, const char* port);
#ifdef __cplusplus
}
#endif
        


#endif /* LogIO_h */

/*
@interface LogIOObject : NSObject
+(id) shared;
@end
*/


