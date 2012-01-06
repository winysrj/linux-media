Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44377 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2AFNJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 08:09:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Using OMAP3 ISP live display and snapshot sample applications
Date: Fri, 6 Jan 2012 14:09:30 +0100
Cc: linux-media@vger.kernel.org
References: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com> <CAOy7-nOMhG8T+bPKMtWAX6LzBcGarUST-fp3HNUxf-PWLJCJEA@mail.gmail.com> <CAOy7-nPtGHCbfN+kpcRsJGWAf-9ytikyQjTv=BJr_1susgm-sg@mail.gmail.com>
In-Reply-To: <CAOy7-nPtGHCbfN+kpcRsJGWAf-9ytikyQjTv=BJr_1susgm-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061409.30592.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Friday 06 January 2012 07:24:54 James wrote:

[snip]

> After googling for the warning, I proceed with the following steps to
> make the application on Steve's GNOME-R13 image from this site as it
> has all the tools for native-compilation on the Tobi board.
> 
> 1) Inside /usr/src/linux, run "make headers_install ARCH=arm" and my
> /usr/include is now populated with lots of files.

omap3-isp-live requires recent kernel headers that are not shipped by 
distributions yet, so you need to install them to some location first. "make 
headers_install ARCH=arm" should install them to /usr/src/linux/usr/include, 
not /usr/include.

> 2) Inside omap3-isp-live, I ran "make KDIR=/usr/src/linux
> CROSS_COMPILE=arm-angstrom-linux-gnueabi-".
> 
> This gave me an error about not finding linux/omap3isp.h file.
> Thus, I modified the 2 Makefile and replaced "-I$(KDIR)/usr/include"
> with "-I$(KDIR)/include"

That's weird. The make headers_install step above should have installed the 
headers in /usr/src/linux/usr/include, so the makefile should be correct.

> Ran "make KDIR=/usr/src/linux
> CROSS_COMPILE=arm-angstrom-linux-gnueabi-" again and it compiled
> nicely without warnings about using kernel headers from user space.
> 
> Only 3 warnings about
> 
> a) omap3isp.c:271:13: warning: 'omap3_isp_pool_free_buffers' defined
> but not used

Fixed in the latest version.

> b) omap3isp.c:329:15: warning: 'nbufs' may be used uninitialized in
> this function

Fixed in the latest version as well.

> c) subdev.c:49:20: warning: 'pixelcode_to_string' defined but not used

I'll fix that, but it's harmless.

> Hope I got it right compiling it this time!! (^^)"
> 
> 3) Copied isp/libomap3isp.so to /usr/lib/ directory when this message
> appeared when I ran ./live -h
> 
> "./live: error while loading shared libraries: libomap3isp.so: cannot
> open shared object file: No such file or directory"
> 
> 4) Ran ./live again and got this error message "unable to find video
> output device"

That should be fixed in the latest version. Could you please upgrade ?

> overo: setting xclk to 25000000 hz
> Device /dev/videovero: setting xclk to 0 hz
> o6 opened: OMAP3 ISP resizer output (media).
> viewfinder configured for 2011 1024x768
> error: unable to find video output device
> 
> The output of the DVI goes 'blue' and nothing shown.
> What is missing?
> 
> lsmod shows the list of modules loaded.
> 
> Module                  Size  Used by
> fuse                   59943  3
> bufferclass_ti          4976  0
> omaplfb                 8025  0
> pvrsrvkm              146868  2 bufferclass_ti,omaplfb
> mt9v032                 5958  1
> omap3_isp             104303  0
> v4l2_common             8543  2 mt9v032,omap3_isp
> videodev               78271  3 mt9v032,omap3_isp,v4l2_common
> libertas_sdio          14871  0
> media                  11885  3 mt9v032,omap3_isp,videodev
> libertas               92472  1 libertas_sdio
> cfg80211              157222  1 libertas
> lib80211                5291  1 libertas
> firmware_class          6269  2 libertas_sdio,libertas
> ads7846                10331  0
> ipv6                  226224  18
> 
> 5) Ran ./snapshot and it continues till Ctrl+C.
> Does it has any output others then those messages?
> 
> Many thanks in adv.

-- 
Regards,

Laurent Pinchart
