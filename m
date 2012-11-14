Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52850 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2KNQ66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 11:58:58 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so575244lbb.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 08:58:56 -0800 (PST)
Message-ID: <50A3CDCD.6020900@googlemail.com>
Date: Wed, 14 Nov 2012 17:58:53 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Michael Yang <yze007@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: The em28xx driver error
References: <loom.20121111T054512-795@post.gmane.org>
In-Reply-To: <loom.20121111T054512-795@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 11.11.2012 05:46, schrieb Michael Yang:
> Hi I am using a v4l2 usb video capturer (em28xx based) on the TI-DM3730 board
> I used the  default driver ,the video can't be captured. I solve this issue by 
> change the em28xx driver :
>
> linux-stable/drivers/media/video/em28xx/em28xx-core.c
>
> /* FIXME: this only function read values from dev */
> int em28xx_resolution_set(struct em28xx *dev)
> {
> int width, height;
> width = norm_maxw(dev);
> height = norm_maxh(dev);
>
> /* Properly setup VBI */
> dev->vbi_width = 720;
> if (dev->norm & V4L2_STD_525_60)
> dev->vbi_height = 12;
> else
> dev->vbi_height = 18;
>
> if (!dev->progressive)
> height >>= norm_maxh(dev) ;//change to" height = norm_maxh(dev) >> 1 ;"
This looks indeed like a bug.
a >>= b means a = a >> b, which in this case means shifting height 480
or 576 bits to the right...
height >> 1 means height /= 2 which seems to be sane for interlaced devices.
OTOH, I wonder why it seems to be working on other platforms !?
Unfortunately I don't have an interlaced device here for testing. :(


> em28xx_set_outfmt(dev);
>
>
>
> Then I can capture the video.But  about 3 minutes later, the os throw out 
> errors:
>
> Read a frame, the size is:325 
> Read a frame, the size is:304 
> ehci-omap ehci-omap.0: request c15b1000 would overflow (3898+63 >= 3936)  //the 
> video shut up
> ehci-omap ehci-omap.0: request c15b0000 would overflow (3906+63 >= 3936) 
> ehci-omap ehci-omap.0: request c1558800 would overflow (3915+63 >= 3936) 
> ehci-omap ehci-omap.0: request c15b0800 would overflow (3924+63 >= 3936) 
> Read a frame, the size is:253 
> ehci-omap ehci-omap.0: request c143f800 would overflow (3909+63 >= 3936) 
Couldn't this be an ehci-omap issue ?

> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> usb 1-2.2: kworker/0:2 timed out on ep0in len=8/1 
> ............
> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> usb 1-2.2: kworker/0:2 timed out on ep0in len=8/1 
> ^Cusb 1-2.2: test_h264 timed out on ep0in len=0/1 
> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> ^Cusb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> ^Cusb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
>
> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
>
> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> ^C 
> usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> ^Cusb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
> usb 1-2.2: test_h264 timed out on ep0out len=8/0 
> em28xx #0: cannot change alternate number to 0 (error=-110) 
This means usb_set_interface() failed with -ETIMEDOUT. No idea what that
means.
I also wonder why the driver tries to switch to alternate setting 0...
Could you please post the output of lsusb -v for this device ?

Regards,
Frank


