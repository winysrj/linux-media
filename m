Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:35623 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZGSTUx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 15:20:53 -0400
Message-ID: <4A637212.2000002@rtr.ca>
Date: Sun, 19 Jul 2009 15:20:50 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org
Subject: Regression 2.6.31:  ioctl(EVIOCGNAME) no longer returns device name
References: <1247862585.10066.16.camel@palomino.walls.org>	<1247862937.10066.21.camel@palomino.walls.org>	<20090719144749.689c2b3a@hyperion.delvare>	<4A6316F9.4070109@rtr.ca>	<20090719145513.0502e0c9@hyperion.delvare>	<4A631B41.5090301@rtr.ca>	<4A631CEA.4090802@rtr.ca>	<4A632FED.1000809@rtr.ca> <20090719190833.29451277@hyperion.delvare> <4A63656D.4070901@rtr.ca>
In-Reply-To: <4A63656D.4070901@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Lord wrote:
> (resending.. somebody trimmed linux-kernel from the CC: earlier)
> 
> Jean Delvare wrote:
>> On Sun, 19 Jul 2009 10:38:37 -0400, Mark Lord wrote:
>>> I'm debugging various other b0rked things in 2.6.31 here right now,
>>> so I had a closer look at the Hauppauge I/R remote issue.
>>>
>>> The ir_kbd_i2c driver *does* still find it after all.
>>> But the difference is that the output from 'lsinput' has changed
>>> and no longer says "Hauppauge".  Which prevents the application from
>>> finding the remote control in the same way as before.
>>
>> OK, thanks for the investigation.
>>
>>> I'll hack the application code here now to use the new output,
>>> but I wonder what the the thousands of other users will do when
>>> they first try 2.6.31 after release ?
..

Mmm.. appears to be a systemwide thing, not just for the i2c stuff.
*All* of the input devices now no longer show their real names
when queried with ioctl(EVIOCGNAME).  This is a regression from 2.6.30.
Note that the real names *are* still stored somewhere, because they
do still show up correctly under /sys/


> Here's a test program for you:
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <linux/input.h>
> 
> // Invoke with "/dev/input/event4" as argv[1]
> //
> // On 2.6.30, this gives the real name, eg. "i2c IR (Hauppauge)".
> // On 2.6.31, it simply gives "event4" as the "name".
> 
> int main(int argc, char *argv[])
> {
>     char buf[32];
>     int fd, rc;
> 
>     fd = open(argv[1], O_RDONLY);
>     if (fd == -1) {
>         perror(argv[1]);
>         exit(1);
>     }
>     rc = ioctl(fd,EVIOCGNAME(sizeof(buf)),buf);
>     if (rc >= 0)
>         fprintf(stderr,"   name    : \"%.*s\"\n", rc, buf);
>     return 0;
> }
..

Since this regression should be visible on *any* system, not just mine,
I think perhaps the input-subsystem developers ought to be the ones to
go and burn some time on a git-bisect, if need be.

Eg.  Here's what's different on my notebook here:


--- lsinput.2.6.30	2009-07-19 15:14:38.278293568 -0400
+++ lsinput.2.6.31	2009-07-19 15:15:43.725375340 -0400
@@ -3,7 +3,7 @@
    vendor  : 0x1
    product : 0x1
    version : 43841
-   name    : "AT Translated Set 2 keyboard"
+   name    : "event0"
    phys    : "isa0060/serio0/input0"
    bits ev : EV_SYN EV_KEY EV_MSC EV_LED EV_REP
 
@@ -12,7 +12,7 @@
    vendor  : 0x2
    product : 0x7
    version : 4017
-   name    : "SynPS/2 Synaptics TouchPad"
+   name    : "event1"
    phys    : "isa0060/serio1/input0"
    bits ev : EV_SYN EV_KEY EV_ABS
 
@@ -21,7 +21,7 @@
    vendor  : 0x0
    product : 0x5
    version : 0
-   name    : "Lid Switch"
+   name    : "event2"
    phys    : "PNP0C0D/button/input0"
    bits ev : EV_SYN EV_SW
 
@@ -30,7 +30,7 @@
    vendor  : 0x0
    product : 0x1
    version : 0
-   name    : "Power Button"
+   name    : "event3"
    phys    : "PNP0C0C/button/input0"
    bits ev : EV_SYN EV_KEY
 
@@ -39,7 +39,7 @@
    vendor  : 0x0
    product : 0x3
    version : 0
-   name    : "Sleep Button"
+   name    : "event4"
    phys    : "PNP0C0E/button/input0"
    bits ev : EV_SYN EV_KEY
 
@@ -48,34 +48,16 @@
    vendor  : 0x1f
    product : 0x1
    version : 256
-   name    : "PC Speaker"
+   name    : "event5"
    phys    : "isa0061/input0"
    bits ev : EV_SYN EV_SND
 
 /dev/input/event6
-   bustype : (null)
-   vendor  : 0x0
-   product : 0x0
-   version : 0
-   name    : "HDA Intel Mic at Ext Right Jack"
-   phys    : "ALSA"
-   bits ev : EV_SYN EV_SW
-
-/dev/input/event7
-   bustype : (null)
-   vendor  : 0x0
-   product : 0x0
-   version : 0
-   name    : "HDA Intel HP Out at Ext Right Ja"
-   phys    : "ALSA"
-   bits ev : EV_SYN EV_SW
-
-/dev/input/event8
    bustype : BUS_USB
    vendor  : 0x46d
    product : 0xc016
    version : 272
-   name    : "Logitech Optical USB Mouse"
+   name    : "event6"
    phys    : "usb-0000:00:1d.7-5.4/input0"
    uniq    : ""
    bits ev : EV_SYN EV_KEY EV_REL EV_MSC


