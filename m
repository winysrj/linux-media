Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54785 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750933AbZHERl6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2009 13:41:58 -0400
Date: Wed, 5 Aug 2009 19:42:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"m-karicheri2@ti.com" <m-karicheri2@ti.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 0/4] soc-camera: cleanup + scaling / cropping API fix
In-Reply-To: <4A798F05.808@epfl.ch>
Message-ID: <Pine.LNX.4.64.0908051604220.5802@axis700.grange>
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange> <4A71A159.60903@epfl.ch>
 <Pine.LNX.4.64.0907302019270.6813@axis700.grange> <4A798F05.808@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 Aug 2009, Valentin Longchamp wrote:

> I have some feedback with your patches. I have tried to add support for my
> platform by doing the same as you did for pcm037. However it does not work. I
> have applied your patches directly on 2.6.31-rc4.
> 
> The first problem is that in order to be able to probe the camera correctly, I
> cannot have mt9t031 built as module and not loaded at this time. This
> certainly is not critcal for the time being, but it should be  handled
> correctly later (the error comes from v4l2_i2c_new_subdev_board -called from
> soc_camera_init_i2c - that does not create the subdev with the module not
> loaded - kernel boot).

The behaviour, imposed by v4l2-subdev is as follows:
1. your i2c adapter driver must be loaded before your camera host driver 
(mx3_camera)
2. when you load the camera host driver, the camera (sensor) driver should 
either already be loaded, or it will be loaded automatically - if your 
user-space supports this.

> The second and bigger problem is that even if I can register everything on the
> system (/dev/video0 gets created), when I try to access it, I get a device or
> resourse busy error.
> 
> Kernel log (end):
> 
> > Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
> > Platform driver 'fsl-usb2-udc' needs updating - please use dev_pm_ops
> > i2c /dev entries driver
> > Linux video capture interface: v2.00
> > camera 0-0: Probing 0-0
> > mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> > mt9t031 0-005d: Detected a MT9T031 chip ID 1621
> > mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
> > i.MX SDHC driver
> > i.MX SDHC driver
> > TCP cubic registered
> > NET: Registered protocol family 17
> > RPC: Registered udp transport module.
> > RPC: Registered tcp transport module.
> > VFP support v0.3: implementor 41 architecture 1 part 20 variant b rev 2
> > Waiting for root device /dev/mmcblk0p1...
> > mmc0: new SD card at address b368
> > mmcblk0: mmc0:b368 NCard 1.85 GiB  mmcblk0: p1
> > EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
> > VFS: Mounted root (ext2 filesystem) on device 179:1.
> > Freeing init memory: 100K
> 
> 
> > root@mx31moboard:~# ./gst.sh Setting pipeline to PAUSED ...
> > mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> > mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
> > ERROR: Pipeline doesn't want to pause.
> > ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not
> > open .
> > Additional debug info:
> > v4l2_calls.c(477): gst_v4l2_open ():
> > /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> > system error: Device or resource busy
> > Setting pipeline to NULL ...
> > Freeing pipeline ...
> 
> I have noticed that using the old way of doing the things (without v4lsubdev
> support, using some code that works with 2.6.30), it does not work either with
> 2.6.31-rc4 (same device or resource busy). So maybe am I missing something
> here already. Here is the "log":
> 
> > root@mx31moboard:~# insmod modules/mt9t031.ko camera 0-0: MX3 Camera driver
> > attached to camera 0
> > camera 0-0: Detected a MT9T031 chip ID 1621
> > camera 0-0: MX3 Camera driver detached from camera 0
> > root@mx31moboard:~# camera 0-0: MX3 Camera driver attached to camera 0
> > camera 0-0: MX3 Camera driver detached from camera 0

This is strange. As I said above, mt9t031 should either be loaded before 
mx3-camera, or it would be loaded automatically, are you sure your insmod 
actually worked? can it be that your old module has been loaded instead or 
something like that?

> > root@mx31moboard:~# ./gst.sh Setting pipeline to PAUSED ...
> > camera 0-0: MX3 Camera driver attached to camera 0
> > camera 0-0: MX3 Camera driver detached from camera 0
> > ERROR: Pipeline doesn't want to pause.
> > ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not
> > open .
> > Additional debug info:
> > v4l2_calls.c(477): gst_v4l2_open ():
> > /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> > system error: Device or resource busy
> > Setting pipeline to NULL ...
> > Freeing pipeline ...

This is indeed strange. works for me (tm). Verify your modules. (I am away 
next week starting tomorrow, so, you have enough time to check this:-))

Thanks
Guennadi
---
Guennadi Liakhovetski
