Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46146 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2AEJzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 04:55:42 -0500
Received: by werm1 with SMTP id m1so224228wer.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 01:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOy7-nNH7ffkvi42=Zccx==SwwZJHPh9bw5gEBhbPqb+vRMt-Q@mail.gmail.com>
References: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com>
	<201201031217.20473.laurent.pinchart@ideasonboard.com>
	<CAOy7-nNH7ffkvi42=Zccx==SwwZJHPh9bw5gEBhbPqb+vRMt-Q@mail.gmail.com>
Date: Thu, 5 Jan 2012 17:55:40 +0800
Message-ID: <CAOy7-nOMhG8T+bPKMtWAX6LzBcGarUST-fp3HNUxf-PWLJCJEA@mail.gmail.com>
Subject: Re: Using OMAP3 ISP live display and snapshot sample applications
From: James <angweiyang@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jan 4, 2012 at 3:07 PM, James <angweiyang@gmail.com> wrote:
> Hi Laurent,
>
> On Tue, Jan 3, 2012 at 7:17 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi James,
>>
>> On Tuesday 03 January 2012 10:40:10 James wrote:
>>> Hi Laurent,
>>>
>>> Happy New Year!!
>>
>> Thank you. Happy New Year to you as well. May 2012 bring you a workable OMAP3
>> ISP solution ;-)
>>
>
> Yeah! that's on #1 of my 2012 wishlist!! (^^)
>
> But, it start off with a disappointment on the quest to get
> "gst-launch v4l2src" to work..
> http://patches.openembedded.org/patch/8895/
>
> Saw reported success in get v4l2src to work with MT9V032 by applying
> the hack but no luck with my Y12 monochrome sensor. (-.-)"
>
>>> I saw that there is a simple viewfinder in your repo for OMAP3 and
>>> wish to know more about it.
>>>
>>> http://git.ideasonboard.org/?p=omap3-isp-live.git;a=summary
>>>
>>> I intend to test it with my 12-bit (Y12) monochrome camera sensor
>>> driver, running on top of Gumstix's (Steve v3.0) kernel.
>>>
>>> Is it workable at the moment?
>>
>> The application is usable but supports raw Bayer sensors only at the moment.
>> It requires a frame buffer and an omap_vout device (both should be located
>> automatically) and configures the OMAP3 ISP pipeline automatically to produce
>> the display resolution.
>>
>
> Will there be a need to patch for Y12 support or workable out-of-the-box?
>
> Likely your previous notes, I know that 12-bit Y12 to the screen is an
> overkill but will it be able to capture Y12 from CCDC output and then
> output to the screen?
>
> Y12 sensor-> CCDC -> CCDC output -> screen
>
> I've one board connected to a LCD monitor via a DVI chip using GS's
> Tobi board as reference and another via 4.3" LG LCD Touchscreen using
> GS's Chestnut board as reference.
>
> Many thanks in adv
>
> --
> Regards,
> James

I did a native compilation on my overo and the result is as below.

root@omap3-multi:~/omap3-isp-live# ln -s
/usr/src/linux-sakoman-pm-3.0-r102/include/ /usr/src/linux/usr/include
root@omap3-multi:~/omap3-isp-live# make KDIR=/usr/src/linux
CROSS_COMPILE=arm-angstrom-linux-gnueabi-
make -C isp CROSS_COMPILE=arm-angstrom-linux-gnueabi- KDIR=/usr/src/linux
make[1]: Entering directory `/home/root/omap3-isp-live/isp'
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -fPIC -c -o controls.o controls.c
In file included from /usr/src/linux/usr/include/linux/omap3isp.h:30:0,
                 from controls.c:25:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -fPIC -c -o media.o media.c
In file included from /usr/src/linux/usr/include/linux/videodev2.h:66:0,
                 from media.c:34:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -fPIC -c -o omap3isp.o omap3isp.c
In file included from /usr/src/linux/usr/include/linux/v4l2-mediabus.h:14:0,
                 from omap3isp-priv.h:26,
                 from omap3isp.c:31:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
omap3isp.c:271:13: warning: 'omap3_isp_pool_free_buffers' defined but not used
omap3isp.c: In function 'omap3_isp_pipeline_build':
omap3isp.c:329:15: warning: 'nbufs' may be used uninitialized in this function
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -fPIC -c -o subdev.o subdev.c
In file included from /usr/src/linux/usr/include/linux/v4l2-subdev.h:27:0,
                 from subdev.c:33:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
subdev.c:49:20: warning: 'pixelcode_to_string' defined but not used
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -fPIC -c -o v4l2.o v4l2.c
In file included from /usr/src/linux/usr/include/linux/videodev2.h:66:0,
                 from v4l2.c:36:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -fPIC -c -o v4l2-pool.o v4l2-pool.c
In file included from /usr/src/linux/usr/include/linux/videodev2.h:66:0,
                 from v4l2-pool.h:25,
                 from v4l2-pool.c:26:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -o libomap3isp.so -shared controls.o
media.o omap3isp.o subdev.o v4l2.o v4l2-pool.o
make[1]: Leaving directory `/home/root/omap3-isp-live/isp'
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -c -o live.o live.c
In file included from /usr/src/linux/usr/include/linux/fb.h:4:0,
                 from live.c:44:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -c -o videoout.o videoout.c
In file included from /usr/src/linux/usr/include/linux/videodev2.h:66:0,
                 from videoout.c:23:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -Lisp -o live live.o videoout.o -lomap3isp -lrt
arm-angstrom-linux-gnueabi-gcc -O2 -W -Wall
-I/usr/src/linux/usr/include -c -o snapshot.o snapshot.c
In file included from /usr/src/linux/usr/include/linux/spi/spidev.h:25:0,
                 from snapshot.c:41:
/usr/src/linux/usr/include/linux/types.h:13:2: warning: #warning
"Attempt to use kernel headers from user space, see
http://kernelnewbies.org/KernelHeaders"
arm-angstrom-linux-gnueabi-gcc -Lisp -o snapshot snapshot.o -lomap3isp -lrt
root@omap3-multi:~/omap3-isp-live# ls
LICENSE   README  live	  live.o    snapshot.c	videoout.c  videoout.o
Makefile  isp	  live.c  snapshot  snapshot.o	videoout.h
root@omap3-multi:~/omap3-isp-live# live --help
-sh: live: command not found
root@omap3-multi:~/omap3-isp-live# ./live --help
./live: error while loading shared libraries: libomap3isp.so: cannot
open shared object file: No such file or directory
root@omap3-multi:~/omap3-isp-live# cd isp
root@omap3-multi:~/omap3-isp-live/isp# ls
LICENSE     libomap3isp.so  omap3isp-priv.h  subdev.h	  v4l2-pool.o
Makefile    list.h	    omap3isp.c	     subdev.o	  v4l2.c
controls.c  media.c	    omap3isp.h	     tools.h	  v4l2.h
controls.h  media.h	    omap3isp.o	     v4l2-pool.c  v4l2.o
controls.o  media.o	    subdev.c	     v4l2-pool.h
root@omap3-multi:~/omap3-isp-live/isp# cd ..
root@omap3-multi:~/omap3-isp-live# ls /
bin   dev  home  linuxrc     media  proc  sys  usr
boot  etc  lib	 lost+found  mnt    sbin  tmp  var
root@omap3-multi:~/omap3-isp-live# ls /usr/
arm-angstrom-linux-gnueabi  etc    include  libexec  share
bin			    games  lib	    sbin     src
root@omap3-multi:~/omap3-isp-live#

I ran ./live --help and there is an error
./live --help
./live: error while loading shared libraries: libomap3isp.so: cannot
open shared object file: No such file or directory

Please advise.

Many thanks in adv.

-- 
Regards,
James
