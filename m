Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.187]:62960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1EIH2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 03:28:53 -0400
Date: Mon, 9 May 2011 09:28:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Question about soc-camera framework driver load sequence
In-Reply-To: <BANLkTi=1EJiARZ9Js38OUtbXY2NdQ9L-Nw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105090923260.21938@axis700.grange>
References: <BANLkTi=1EJiARZ9Js38OUtbXY2NdQ9L-Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

(replaced the ML-owner address with the correct one)

On Mon, 9 May 2011, Josh Wu wrote:

> Hi,
> 
> I am working on the an image sensor interface(isi) driver with the
> *soc-camera framework*. The kernel code base is 2.6.39_rc3.
> 
> Now the isi driver and ov2640 sensor driver both are statically built into
> kernel. When system boot up, I find soc_camera_probe() is never got called.
> And consequently /dev/video0 won't be created.
> After checking the code and I find this maybe releate to sequence of modules
> loading.
> In this bad case, the soc-camera framework driver module (soc_camera.c) is
> loaded after the isi driver module (my driver). This means:
> soc_camera_pdrv_probe() will called *after* soc_camera_host_register().  So
> when soc_camera_host_register() is called, no camera device will be found
> and registered because at this time, soc_camera_pdrv_probe() has not been
> called yet.
> To make sure my driver is loaded after the *soc-camera framework*, I used
> late_initcall in my isi driver. It works.
> 
> My question is: when using soc-camera framework, should every individual
> camera driver take the loading sequence into account? Or the current
> soc-camera framework has provided some mechanisms to handle this?

In the modular case, your (ISI) camera host driver depends on soc-camera 
core, e.g., by calling the soc_camera_host_register() function. So, before 
your driver can be loaded, the core will be loaded. It will then register 
the platform driver, probe the devices, then your host driver will have no 
problem finding attached clients. In the static build case, it is 
important to place your host driver in the drivers/media/video/Makefile 
_after_ the soc-camera core, there is also a comment about it there. Just 
put your driver somewhere next to other host drivers.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
