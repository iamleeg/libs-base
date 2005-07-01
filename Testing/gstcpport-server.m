/* Test/example program for the base library

   Copyright (C) 2005 Free Software Foundation, Inc.
   
   This file is part of the GNUstep Base Library.
*/
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSPortMessage.h>
#include <Foundation/NSPortNameServer.h>
#include <Foundation/NSPort.h>

@class GSTcpPort;
@interface NSPortNameServer (hack)
- (Class) setPortClass: (Class)c;
@end

@interface MyDelegate : NSObject
- (void) handlePortMessage: (NSPortMessage*)m;
@end

@implementation	MyDelegate
- (void) handlePortMessage: (NSPortMessage*)m
{
  NSLog(@"Got port message - %@", m);
}
@end

int
main()
{
  NSRunLoop		*loop;
  GSTcpPort		*local;
  NSPortNameServer	*names;
  MyDelegate		*del;
  CREATE_AUTORELEASE_POOL(pool);

  local = [GSTcpPort new];
  del = [MyDelegate new];
  [(id)local setDelegate: del];
  loop = [NSRunLoop currentRunLoop];
  [NSPortNameServer setPortClass: [GSTcpPort class]];
  names = [NSPortNameServer systemDefaultPortNameServer];
  [names registerPort: (NSPort*)local forName: @"GSTcpPort"];
  [loop addPort: (NSPort*)local forMode: NSDefaultRunLoopMode];
  [loop run];
  RELEASE(pool);
  exit(0);
}

