Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55164 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412Ab2C2TSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 15:18:08 -0400
References: <20120329174427.D1F6E15D201A8@alastor.dyndns.org> <E9BA201A-4F44-4E01-8553-0977724C79B1@gmail.com>
In-Reply-To: <E9BA201A-4F44-4E01-8553-0977724C79B1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Compilation problem : too few arguments to function 'kmap_atomic
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 29 Mar 2012 15:18:16 -0400
To: =?ISO-8859-1?Q?Lo=EFc_Bertron?= <loic.bertron@gmail.com>,
	linux-media@vger.kernel.org
Message-ID: <d43931cd-9951-4e72-bee7-90308c99a54e@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Loïc Bertron" <loic.bertron@gmail.com> wrote

>Hello,
>
>I'm running into an issue when compiling the last version of
>media_build : 
>
>/usr/src/linux-headers-2.6.32-5-common/include/linux/kernel.h:366:1:
>warning: this is the location of the previous definition
>  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-control.o
>  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-core.o
>  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-video.o
>  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-i2c.o
>  CC [M]  /home/toto/sources/media_build/v4l/hopper_cards.o
>  CC [M]  /home/toto/sources/media_build/v4l/hopper_vp3028.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-routing.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-cards.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-controls.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-driver.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-fileops.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-firmware.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-gpio.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-i2c.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-ioctl.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-irq.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-mailbox.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-queue.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-streams.o
>  CC [M]  /home/toto/sources/media_build/v4l/ivtv-udma.o
>/home/toto/sources/media_build/v4l/ivtv-udma.c: In function
>'ivtv_udma_fill_sg_list':
>/home/toto/sources/media_build/v4l/ivtv-udma.c:60: error: too few
>arguments to function 'kmap_atomic'
>/home/toto/sources/media_build/v4l/ivtv-udma.c:62:21: error: macro
>"kunmap_atomic" requires 2 arguments, but only 1 given 
>/home/toto/sources/media_build/v4l/ivtv-udma.c:62: error:
>'kunmap_atomic' undeclared (first use in this function)
>/home/toto/sources/media_build/v4l/ivtv-udma.c:62: error: (Each
>undeclared identifier is reported only once
>/home/toto/sources/media_build/v4l/ivtv-udma.c:62: error: for each
>function it appears in.)
>make[5]: *** [/home/toto/sources/media_build/v4l/ivtv-udma.o] Error 1
>make[4]: *** [_module_/home/toto/sources/media_build/v4l] Error 2
>make[3]: *** [sub-make] Error 2
>make[2]: *** [all] Error 2
>make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-5-amd64'
>make[1]: *** [default] Error 2
>make[1]: Leaving directory `/home/toto/sources/media_build/v4l'
>make: *** [all] Error 2
>build failed at ./build line 410.
>
>After searching a bit on Google, I found someone with the same issue
>than me who post it today : http://pastebin.com/zgqN7LRE
>
>Any idea ? --
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Backport builds to older kernels are never guarnteed to work.

The ivtv driver source has to keep up with the latest kernel.  In this case kmap_atomic and kunmap_atomic in the latest kernels have one less argument that in the older kernel version you are using.

You will need to fix the drivers/media/video/ivtv/ source files to fix the problem.  If you develop a patch for the backport, you can submit it and hopefully get it included as a backward compatibilty patch for the media_build repo.

Of course that may not be the only problem.   A PVR-x50 user recent noted that media_build ivtv didn't work right with 2.6.32.  I investigated it down to an I2c driver module binding problem, also due to the media_build backport not having a patch.

I have no time, nor desire, to fix things for kernels that old, which are likely Enterprise kernels anyway.  If you do need support for an Enterprise kernel, I recommend getting it from the Enterprise kernel vendor or a consultant.

Regards,
Andy
