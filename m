Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:54171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1BRUxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 15:53:35 -0500
Date: Fri, 18 Feb 2011 21:53:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Juliano Valentini <juliano@pinaculo.com.br>
cc: linux-media@vger.kernel.org
Subject: Re: Leopardimaging SoC Camera
In-Reply-To: <AANLkTindyMGE+LgtDR7kM-GDSmJO3SF98QYs+zAe04MD@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1102181331060.1851@axis700.grange>
References: <AANLkTimMhMyz8E1K8__wGFC8xNeh5hVRyfOUfzsWYwiG@mail.gmail.com>
 <Pine.LNX.4.64.1102081300510.1393@axis700.grange>
 <AANLkTindyMGE+LgtDR7kM-GDSmJO3SF98QYs+zAe04MD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 18 Feb 2011, Juliano Valentini wrote:

> Dears,
> 
> I'm trying to apply Guennadi's patch
> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/linux-2.6-omap3isp-bbxm-mt9p031.gitdiff)
> to official 2.6.37.1 Kernel version.

No, this cannot work. That kernel patch requires media-controller and 
omap3isp, so, it is based on the omap3isp branch of the development tree 
by Laurent Pinchart:

git://linuxtv.org/pinchartl/media.git

But that tree has been rebased since then, so, I wouldn't expect that 
patch to apply cleanly, porting it to the current kernel would require a 
non-zero development effort.

> I suppose that kernel version is wrong or missing previous patches
> (see result at the end).
> I have to make it work:  MT9P031 SoC camera module on Beagleboard Xm.
> Could somebody help me? Where/how can I get the right kernel version?

I'll send you a tarball of those "old" patches off-list.

Thanks
Guennadi

> 
> Kind regards,
> 
> Juliano Valentini
> Mobile: +55 51 8161 8366
> MSN: jvalentini@gmail.com
> Skype: julianovalentini
> 
> 
> On Tue, Feb 8, 2011 at 10:18 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Dear Juliano
> >
> > On Tue, 8 Feb 2011, Juliano Valentini wrote:
> >
> >> Dear Dr. Guennadi!
> >>
> >> I'm a researcher at Advance Tecnologia Ltda. (www.pinaculo.com.br), from Brazil.
> >> At the this time we are developing right now a solution for help low
> >> vision and blind people. We are implementing a small embedded device
> >> that converts photo information into audio through a system of
> >> capture, OCR and then TTS(Text to Speech). We have chosen OMAP3530
> >> platform and processor, we are using Ubuntu Linux as OS with the
> >> newest Kernel version.
> >
> > Well, yes, as you've probably read elsewhere, I've got a kernel with
> > drivers and user-space for exactly this hardware - beagleboard xM and
> > LM-5M03 / MT9P031. A snapshot of my work is available at
> > http://download.open-technology.de/BeagleBoard_xM-MT9P031/ including a
> > plain-text description. Please, have a look, this is still very
> > experimental, and the description is very scarce. Please, let me know, if
> > you have any further question. But then, please, also CC
> >
> > Linux Media Mailing List <linux-media@vger.kernel.org>
> >
> > Thanks
> > Guennadi
> >
> >>
> >> Before our own hardware be ready I'm doing software and hardware tests
> >> with a Beagleboard xM, very similar to our target hardware.
> >>
> >> So, I'm contacting you because we can't do work a SoC camera plugged
> >> in the Beagleboard. I have connected the LM-5M03/MT9P031
> >> (http://shop.leopardimaging.com/product.sc?productId=50&categoryId=7)
> >> to the Beagleboard but the there is no a suitable kernel module to get
> >> work with the V4L system.
> >>
> >> I saw you had written a driver for MT9T031 CMOS Image Sensor. It seems
> >> to be very similar to the MT9P031...
> >>
> >> Can you help us to get things working by porting a suitable module to
> >> our platform or simply suggesting another 5 mega pixel image sensor
> >> ready to work on our SoC bus?
> >>
> >> Kind Regards
> >>
> >> Juliano Valentini
> >> Mobile: +55 51 8161 8366
> >> MSN: jvalentini@gmail.com
> >> Skype: julianovalentini
> >>
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> >
> 
> 
> 
> -----------
> jvalentini@dev-vocalizer:~/vocalizer/beagleboard_xM/bzr/2.6-stable/KERNEL$
> patch -p1 < linux-2.6-omap3isp-bbxm-mt9p031.gitdiff
> patching file arch/arm/mach-omap2/Makefile
> Hunk #1 succeeded at 131 (offset 13 lines).
> patching file arch/arm/mach-omap2/board-omap3beagle-camera.c
> patching file arch/arm/mach-omap2/board-omap3beagle.c
> Hunk #1 succeeded at 367 (offset 97 lines).
> Hunk #2 FAILED at 335.
> Hunk #3 succeeded at 556 with fuzz 1 (offset 114 lines).
> Hunk #4 succeeded at 723 (offset 135 lines).
> 1 out of 4 hunks FAILED -- saving rejects to file
> arch/arm/mach-omap2/board-omap3beagle.c.rej
> patching file arch/arm/mach-omap2/devices.c
> Hunk #1 succeeded at 124 (offset -25 lines).
> patching file arch/arm/plat-omap/iommu.c
> patching file arch/arm/plat-omap/omap-pm-noop.c
> Hunk #1 succeeded at 84 (offset -4 lines).
> patching file drivers/media/video/Kconfig
> Hunk #1 succeeded at 321 with fuzz 2 (offset -8 lines).
> patching file drivers/media/video/Makefile
> Hunk #1 FAILED at 70.
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/media/video/Makefile.rej
> patching file drivers/media/video/isp/isp.c
> Hunk #1 FAILED at 174.
> Hunk #2 FAILED at 235.
> 2 out of 2 hunks FAILED -- saving rejects to file
> drivers/media/video/isp/isp.c.rej
> patching file drivers/media/video/isp/isp.h
> Hunk #1 FAILED at 133.
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/media/video/isp/isp.h.rej
> patching file drivers/media/video/isp/ispccdc.c
> Hunk #1 FAILED at 47.
> Hunk #2 FAILED at 1094.
> Hunk #3 FAILED at 1111.
> Hunk #4 FAILED at 1153.
> Hunk #5 FAILED at 2198.
> Hunk #6 FAILED at 2206.
> 6 out of 6 hunks FAILED -- saving rejects to file
> drivers/media/video/isp/ispccdc.c.rej
> patching file drivers/media/video/isp/ispvideo.c
> Hunk #1 FAILED at 225.
> Hunk #2 FAILED at 259.
> 2 out of 2 hunks FAILED -- saving rejects to file
> drivers/media/video/isp/ispvideo.c.rej
> patching file drivers/media/video/mt9p031.c
> patching file drivers/media/video/mt9t031.c
> patching file include/linux/usb/otg.h
> patching file include/media/mt9p031.h
> patching file include/media/v4l2-chip-ident.h
> Hunk #1 succeeded at 292 (offset -1 lines).
> -----------
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
