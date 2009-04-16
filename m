Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34851 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755101AbZDPSO1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 14:14:27 -0400
Date: Thu, 16 Apr 2009 20:14:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
In-Reply-To: <87tz4o7al6.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0904161955140.4947@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange> <87ljq1mz7f.fsf@free.fr>
 <87tz4o7al6.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Robert Jarzmik wrote:

> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
> > I need to make some additionnal tests with I2C loading/unloading, but otherwise
> > it works perfectly for (soc_camera / pxa_camera /mt9m111 combination).
> 
> Guennadi,
> 
> I made some testing, and there is something I don't understand in the new device
> model.
> This is the testcase I'm considering :
>  - I unload i2c-pxa, pxa-camera, mt9m111, soc-camera modules
>  - I load pxa-camera, mt9m111, soc-camera modules
>  - I then load i2c-pxa
>     => the mt9m111 is not detected

correct

>  - I unload and reload mt9m111 and pxa_camera
>     => not any better

Actually, I think, in this case it should be found again, as long as you 
reload pxa-camera while i2c-pxa is already loaded.

>  - I unload soc_camera, mt9m111, pxa_camera and reload
>     => this time the video device is detected
> 
> What I'm getting at is that if soc_camera is loaded before the i2c host driver,
> no camera will get any chance to work. Is that normal considering the new driver
> model ?
> I was naively thinking that there would be a "rescan" when the "control" was
> being available for a sensor.

Yes, unfortunately, it is "normal":-( On the one hand, we shouldn't really 
spend _too_ much time on this intermediate version, because, as I said, it 
is just a preparatory step for v4l2-subdev. We just have to make sure it 
doesn't introduce any significant regressions and doesn't crash too often. 
OTOH, this is also how it is with v4l2-subdev. With it you first must have 
the i2c-adapter driver loaded. Then, when a match between a camera host 
and a camera client (sensor) platform device is detected, it is reported 
to the v4l2-subdev core, which loads the respective camera i2c driver. If 
you then unload the camera-host and i2c adapter drivers, and then you load 
the camera-host driver, it then fails to get the adapter, and if you then 
load it, nothing else happens. To reprobe you have to unload and reload 
the camera host driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
