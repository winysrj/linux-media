Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2GPRSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 13:18:55 -0400
Date: Mon, 16 Jul 2012 19:18:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: Jonathan Corbet <corbet@lwn.net>, Chao Xie <cxie4@marvell.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH 1/7] media: mmp_camera: Add V4l2 camera driver for Marvell
 PXA910/PXA688/PXA2128 CCIC
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083AB33977@SC-VEXCH1.marvell.com>
Message-ID: <alpine.DEB.2.00.1207161904510.25446@axis700.grange>
References: <1342016549-23084-1-git-send-email-twang13@marvell.com> <20120714111405.09164acc@tpl.lwn.net> <477F20668A386D41ADCC57781B1F7043083AB33977@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert, Jonathan

On Mon, 16 Jul 2012, Albert Wang wrote:

> Hi, Jonathan
> 
> We really appreciate you can find time to review our patch and give us 
> suggestion.

I think, my current position with regard to this situation with the two 
drivers would be the following (please, discuss, if you disagree, I'm open 
to suggestions and ideas):

 - IIUC, Albert would prefer to push this driver upstream without any 
   integration with marvell-ccic. I _might_ accept and support this 
   intention, but for that I'd either need an ack from Jon, that indeed, 
   the new driver has much more to offer and only reimplements very 
   insignificant parts of marvell-ccic, or I would have to try to verify 
   this myself. The latter would take time.

 - If Jon says, that on the contrary, these two hardware implementations 
   share a lot in common and a shared code base definitely makes sense, I 
   will accept that and we will look for ways to also organise the drivers 
   accordingly.

In either case, unless you guys come to an agreement, I will need to find 
a larger time slot (like a long flight or a boring holiday:-)) to try to 
look at the code (and datasheets, if made available) myself and make a 
decision. No idea when I'll be able to find the time.

BTW, are datasheets openly available? If not, a copy of each would be 
appreciated.

Thanks
Guennadi

> On Sunday, 15 July, 2012 01:14
> 
> Jonathan Corbet <corbet@lwn.net<mailto:corbet@lwn.net>> wrote:
> 
> 
> 
> > ...
> 
> 
> 
> >> This v4l2 camera driver is based on soc-camera and videobuf2 framework
> 
> >> Support Marvell MMP Soc family TD-PXA910/MMP2-PXA688/MMP3-PXA2128 CCIC
> 
> >> Support Dual CCIC controllers on PXA688/PXA2128 Support MIPI-CSI2 mode
> 
> >> and DVP-Parallel mode
> 
> 
> 
> >This is going to be really quick.  Life is difficult here, I don't really have much time to put into anything.
> 
> 
> 
> >>  arch/arm/mach-mmp/include/mach/camera.h    |   21 +
> 
> 
> 
> >I don't think that this file belongs here; it should be in the driver tree.  This camera may not always be tied to this platform; indeed, the original Cafe was not.  There will never be a 64-bit SoC with
> 
> >some variant of this device?
> 
> 
> 
> Yes, your suggestion is reasonable.
> 
> How do you like we change the file name to mrvl-camera.h and move it to include/Linux/platform_data/?
> 
> 
> 
> 
> 
> >> +config VIDEO_MMP
> 
> >> +     tristate "Marvell MMP CCIC driver based on SOC_CAMERA"
> 
> >> +     depends on VIDEO_DEV && SOC_CAMERA
> 
> >> +     select VIDEOBUF2_DMA_CONTIG
> 
> >> +     ---help---
> 
> >> +       This is a v4l2 driver for the Marvell PXA910/PXA688/PXA2128 CCIC
> 
> >> +       To compile this driver as a module, choose M here: the module will
> 
> >> +       be called mmp_camera.
> 
> 
> 
> >But...the existing driver already builds as mmp_camera.  Even if we eventually agree that this separate driver should go into the mainline, it really needs to not build into a module with the same name.
> 
> 
> 
> OK. We will think about changing the module name for avoiding the name conflict.
> 
> 
> 
> >> +/*
> 
> >> + * V4L2 Driver for Marvell Mobile SoC PXA910/PXA688/PXA2128 CCIC
> 
> >> + * (CMOS Camera Interface Controller)
> 
> >> + *
> 
> >> + * This driver is based on soc_camera and videobuf2 framework,
> 
> >> + * but part of the low level register function is base on café-driver.c
> 
> >> + *
> 
> >> + * Copyright 2006 One Laptop Per Child Association, Inc.
> 
> >> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net<mailto:corbet@lwn.net>>
> 
> 
> 
> >Nit: some of the code clearly comes from marvell-ccic/mcam-core.c, so the copyright dates (if they really need to be kept) should stretch into 2011 or so.
> 
> 
> 
> Yes, we will keep it and change the copyright dates to 2011.
> 
> 
> 
> >I don't see anything else obvious, but it was a very quick reading, sorry.
> 
> 
> 
> >Jon
> 
> 
> 
> Thanks
> 
> Albert Wang
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
