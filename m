Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47396 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab1EZN5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 09:57:42 -0400
Received: by qwk3 with SMTP id 3so369098qwk.19
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 06:57:41 -0700 (PDT)
References: <4DDE5168.1090805@MessageNetSystems.com>
In-Reply-To: <4DDE5168.1090805@MessageNetSystems.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <89C9F515-ECF8-48DD-8DB9-EEA58A78CAD3@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: use compile uvc_video
Date: Thu, 26 May 2011 09:57:47 -0400
To: Jerry Geis <geisj@MessageNetSystems.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 26, 2011, at 9:11 AM, Jerry Geis wrote:

> I am using centos 5.6 (older kernel) and I get compile errors when I grabbed
> the latest from http://linuxtv.org/hg/v4l-dvb (which I expect as I have an older 2.6.18 kernel)

Okay, but do realize that it hasn't been updated in ages, and its
completely unmaintained.


> All I need is uvc so I thought I would do "make menuconfig" and turn everything off
> but v4l/UVC stuff.
> 
> when I do make I get an error:
> Kernel build directory is /lib/modules/2.6.18-194.32.1.el5/build

That's not a 5.6 kernel, its a 5.5 kernel. (5.6 is 2.6.18-238.x.y.el5).
Doesn't really make a difference, but felt compelled to point it out. :)


> make -C /lib/modules/2.6.18-194.32.1.el5/build SUBDIRS=/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l  modules
> make[2]: Entering directory `/usr/src/kernels/2.6.18-194.32.1.el5-x86_64'
> CC [M]  /home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o
> In file included from /home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.c:19:
> /home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/compat.h:133: error: static declaration of 'strict_strtoul' follows non-static declaration
> include/linux/kernel.h:141: error: previous declaration of 'strict_strtoul' was here

The above lines tell you exactly what the failure was, and its easily
worked around by removing the extraneous definition from v4l/compat.h.


> Is there a way I can just compile the linux/drivers/media/video/uvc ?

Edit the .config file, disable anything you don't want to build.


> thats all I need. How do I do that?

Another option you can try is something along the lines of this:

cd linux/drivers/media/video/uvc
make -C /lib/modules/2.6.18-194.32.1.el5/build M=$PWD modules

No guarantees that won't fail miserably though.

Backporting newer drivers to older kernels often takes a fair bit of
effort and subject matter expertise -- especially when the kernel base
is as ancient as the one you're targeting. There's a reason media_build
doesn't support anything that old. :)

-- 
Jarod Wilson
jarod@wilsonet.com



