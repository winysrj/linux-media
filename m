Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JHMA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:00:28 -0400
Date: Mon, 8 Oct 2012 14:00:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: tingtingyang@rdamicro.com
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: Re: host driver of camera
In-Reply-To: <201210081934560685555@rdamicro.com>
Message-ID: <Pine.LNX.4.64.1210081356320.12203@axis700.grange>
References: <201210081914515571551@rdamicro.com>,
 <Pine.LNX.4.64.1210081320270.12203@axis700.grange> <201210081934560685555@rdamicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Mon, 8 Oct 2012, tingtingyang@rdamicro.com wrote:

>  Dear Guennadi,
> I am sorry , see you reply just now.
> I am in a puzzle about the soc camera 's init.
> In the following,
> 1. in soc_camera.c file
> 
> static struct platform_driver __refdata soc_camera_pdrv = {
> .remove  = __devexit_p(soc_camera_pdrv_remove),
> .driver  = {
> .name = "soc-camera-pdrv",
> .owner = THIS_MODULE,
> },
> };
> 
> 2.in pxa_camera.c  file
> 
> static struct platform_driver pxa_camera_driver = {
> .driver  = {
> .name = PXA_CAM_DRV_NAME,
> .pm = &pxa_camera_pm,
> },
> .probe = pxa_camera_probe,
> .remove = __devexit_p(pxa_camera_remove),
> };
> 
> My question is :
> In the soc board init file ,for example Devices.c . 

arch/arm/mach-pxa/devices.c is not a board init file, it is common for all 
PXA27x boards.

> I only find one 
> platform_device declare , soc-camera-pdrv or PXA_CAM_DRV_NAME .
> 
> But ,I think the two drivers should be both init . How the kernel do that  ?

See, e.g. in arch/arm/mach-pxa/pcm990-baseboard.c:

	pxa_set_camera_info(&pcm990_pxacamera_platform_data);

registers a platform device for the pxa_camera.c driver and

	platform_device_register(&pcm990_camera[0]);
	platform_device_register(&pcm990_camera[1]);

register two platform devices for the soc_camera.c driver, correcponding 
to two camera sensors mt9v022 and mt9m001.

Thanks
Guennadi

> 
> Regards
> tingtingyang
> 
> From: Guennadi Liakhovetski
> Date: 2012-10-08 19:20
> To: tingtingyang
> Subject: Re: host driver of camera
> On Mon, 8 Oct 2012, tingtingyang@rdamicro.com wrote:
> 
> > Dear Guennadi 
> 
> I asked you to CC linux-media.
> 
> Regards
> Guennadi
> 
> > I am studing linux kernel 3.4.0 driver coed.
> > In the file of soc_camera.txt, has a word " 
> > - camera host - an interface, to which a camera is connected. Typically a
> > specialised interface, present on many SoCs, e.g., PXA27x and PXA3xx, SuperH,
> > AVR32, i.MX27, i.MX31.
> > "
> > But,I can not find the driver of camera host driver in pxa27x.c .
> > I know ,the host driver in the pxa_camera.c ,but I do not understand how the function be called or init ,because there are nothing about the camera host in the file pxa27x.c  .
> > 
> > Where could I get some example code of camera host driver being probe ?
> > Best Wishes.
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
