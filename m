Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57468 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750972AbZDPI6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 04:58:33 -0400
Date: Thu, 16 Apr 2009 10:58:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
In-Reply-To: <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904161032050.4947@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <Pine.LNX.4.64.0904151403500.4729@axis700.grange>
 <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> Hello Guennadi,
> 
> 
> Reviewing your patch, I've got curious about a thing.
> I think your soc camera subsystem is covering multiple camera
> devices(sensors) in one target board, but if that is true I'm afraid
> I'm confused how to handle them properly.
> Because according to your patch, video_dev_create() takes camera
> device as parameter and it seems to be creating device node for each
> camera devices.

This patch is a preparatory step for the v4l2-(sub)dev conversion. With it 
yes (I think) a video device will be created for every registered on the 
platform level camera, but only the one(s) that probed successfully will 
actually work, others will return -ENODEV on open().

> It means, if I have one camera host and several camera devices, there
> should be several device nodes for camera devices but cannot be used
> at the same time. Because typical camera host(camera interface) can
> handle only one camera device at a time. But multiple device nodes
> mean "we can open and handle them at the same time".
> 
> How about registering camera host device as v4l2 device and make
> camera device a input device which could be handled using
> VIDIOC_S_INPUT/G_INPUT api?

There are also cases, when you have several cameras simultaneously (think 
for example about stereo vision), even though we don't have any such cases 
just yet.

> Actually, I'm working on S3C64xx camera interface driver with soc
> camera subsystem,

Looking forward to it!:-)

> and I'm facing that issue right now because I've got
> dual camera on my target board.

Good, I think, there also has been a similar design based on a pxa270 SoC. 
How are cameras switched in your case? You probably have some additional 
hardware logic to switch between them, right? So, you need some code to 
control that. I think, you should even be able to do this automatically in 
your platform code using power hooks from the struct soc_camera_link. You 
could fail to power on a camera if another camera is currently active. In 
fact, I have to add a return code test to the call to icl->power(icl, 1) 
in soc_camera_open(), I'll do this for the final v4l2-dev version. Would 
this work for you or do you have another requirements? In which case, can 
you describe your use-case in more detail - should both cameras be open by 
applications simultaneously (looks like not), do you need a more explicit 
switching control, than just "first open switches," which shouldn't be the 
case, since you can even create a separate task, that does nothing but 
just keeps the required camera device open.

> I hope you to consider this concept, and also want to know your opinion.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
