//
//  LogIO.m
//  logioios
//
//  Created by appdev on 2018/4/12.
//  Copyright © 2018年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/socket.h>

#include "LogIO.h"


int logio_clientfd = -1;

// Get host information (used to establishConnection)
struct addrinfo *getHostInfo(const char* host, const char* port) {
    int r;
    struct addrinfo hints, *getaddrinfo_res;
    // Setup hints
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    if ((r = getaddrinfo(host, port, &hints, &getaddrinfo_res))) {
        //fprintf(stderr, "[getHostInfo:21:getaddrinfo] %s\n", gai_strerror(r));
        NSLog(@"[getHostInfo:21:getaddrinfo] %s", gai_strerror(r) );
        return NULL;
    }
    
    return getaddrinfo_res;
}
// Establish connection with host
int establishConnection(struct addrinfo *info) {
    if (info == NULL) return -1;
    
    int clientfd;
    for (;info != NULL; info = info->ai_next) {
        if ((clientfd = socket(info->ai_family,
                               info->ai_socktype,
                               info->ai_protocol)) < 0) {
            NSLog(@"[establishConnection:35:socket]");
            continue;
        }
        
        if (connect(clientfd, info->ai_addr, info->ai_addrlen) < 0) {
            close(clientfd);
            NSLog(@"[establishConnection:42:connect]");
            continue;
        }
        
        freeaddrinfo(info);
        return clientfd;
    }
    
    freeaddrinfo(info);
    return -1;
}


int logio_init(const char* hostname, const char* port) {
    
    // Establish connection with <hostname>:<port>
    logio_clientfd = establishConnection(getHostInfo(hostname, port));
    if (logio_clientfd == -1) {
        NSLog(@"Failed to connect to: %s:%s", hostname, port);
        return 3;
    }
    
    NSLog(@"logio init ok");
    
    //close(logio_clientfd);
    return 0;
}



void logio(NSString* format, ...) {
    va_list vl;
    va_start(vl, format);
    NSString* str = [[NSString alloc] initWithFormat:format arguments:vl];
    va_end(vl);
    
    NSLog(@"%@", str);
    if (logio_clientfd > 0) {
        const char* cstr = [str UTF8String];
        char req[1000] = {0};
        sprintf(req, "+log|my_stream|my_node|info|%s\r\n", cstr);
        send(logio_clientfd, req, strlen(req), 0);
        
        /*
        char recvbuf[100] = {0};
        while (recv(logio_clientfd, recvbuf, 100, 0) > 0) {
            //fputs(buf, stdout);
            NSLog(@"recvbuf [%s]", recvbuf);
            memset(recvbuf, 0, BUF_SIZE);
        }*/
    }
}


/*
/////////////
@interface LogIOObject ()

@end

@implementation LogIOObject
+(id) shared {
    static dispatch_once_t pred;
    static LogIOObject *sharedInstance;
    dispatch_once(&pred, ^{
        sharedInstance = [[LogIOObject alloc] init];
    });
    return sharedInstance;
}
@end
*/







