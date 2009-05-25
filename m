Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42442 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZEYSb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 14:31:27 -0400
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels
 older than 2.6.26)
From: Andy Walls <awalls@radix.net>
To: David Ward <david.ward@gatech.edu>
Cc: Matt Doran <matt.doran@papercut.com>, linux-media@vger.kernel.org
In-Reply-To: <4A19EBDE.4080602@gatech.edu>
References: <4A19D3D9.9010800@papercut.com>  <4A19EBDE.4080602@gatech.edu>
Content-Type: text/plain
Date: Mon, 25 May 2009 14:32:57 -0400
Message-Id: <1243276377.3167.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-05-24 at 20:52 -0400, David Ward wrote:
> On 05/24/2009 07:10 PM, Matt Doran wrote:
> > Hi there,
> >
> > I tried using the latest v4l code on an Mythtv box running 2.6.20, but
> > the v4l videodev module fails to load with the following warnings:
> >
> >    videodev: Unknown symbol i2c_unregister_device
> >    v4l2_common: Unknown symbol v4l2_device_register_subdev
> >
> >
> > It seems the "i2c_unregister_device" function was added in 2.6.26.
> > References to this function in v4l2-common.c are enclosed in an ifdef
> > like:
> >
> >    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> >
> >
> > However in "v4l2_device_unregister()" in v4l2-device.c, there is a
> > reference to "i2c_unregister_device" without any ifdefs.   I am
> > running a pretty old kernel, but I'd guess anyone running 2.6.25 or
> > earlier will have this problem.   It seems this code was added by
> > Mauro 3 weeks ago in this rev:
> >
> >    http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf
> >
> >
> >
> >
> > I also had some other compile problems, but don't have all the details
> > (sorry!).  I had to disable the following drivers to get it to compile:
> >
> >    * CONFIG_VIDEO_PVRUSB2
> >    * CONFIG_VIDEO_THS7303
> >    * CONFIG_VIDEO_ADV7343
> >    * CONFIG_DVB_SIANO_SMS1XXX
> >
> >
> > Regards,
> > Matt
> >
> 
> Matt, I checked out v4l-dvb today and am using it under 2.6.24 and so 
> far so good.  When did the error appear -- when you were trying to load 
> the module?
> 
> I have been seeing the errors compiling adv7343.c and ths7303.c under 
> 2.6.24 as well.  Andy Walls and Chaithrika Subrahmanya had written 
> patches for those two modules respectively, but there were some comments 
> during the review of the patches, so I think they are still being worked on.

Well, just to manage expectations: I am not working on this.  I do not
advise waiting for something from me. ;)


As an end user, you work-around is to use "make menuconfig" (or
whatever) as Matt did: disable the modules that aren't compiling on
older kernels.


If it really bugs you (it would bug me), please submit a tested patch
against:

	v4l-dvb/v4l/versions.txt

to disable compilations of the offending drivers for older kernels.

Backward compatability fixes are not going to be appealing work for
anyone, especially if you're not actually using the problem drivers.

Regards,
Andy


> David

