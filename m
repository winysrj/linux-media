Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:33342 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753479Ab0HDIYw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Aug 2010 04:24:52 -0400
Date: Wed, 4 Aug 2010 10:24:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Michael Grzeschik <mgr@pengutronix.de>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
In-Reply-To: <20100804070949.GR14113@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008041020280.29386@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008032016340.10845@axis700.grange> <20100803195727.GB12367@pengutronix.de>
 <Pine.LNX.4.64.1008040039550.10845@axis700.grange> <20100804070949.GR14113@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Aug 2010, Sascha Hauer wrote:

> On Wed, Aug 04, 2010 at 01:01:34AM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > 
> > > On Tue, Aug 03, 2010 at 08:22:13PM +0200, Guennadi Liakhovetski wrote:
> > > > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > > > 
> > > > > change this driver back to register and probe, since some platforms
> > > > > first have to initialize an already registered power regulator to switch
> > > > > on the camera.
> > > > 
> > > > Sorry, don't see a difference. Can you give an example of two call 
> > > > sequences, where this change changes the behaviour?
> > > >
> > > 
> > > Yes, when you look at the today posted patch [1] you find the function
> > > pcm970_baseboard_init_late as an late_initcall. It uses an already
> > > registred regulator device to turn on the power of the camera before the
> > > cameras device registration.
> > > 
> > > [1] [PATCH 1/2] ARM: i.MX27 pcm970: Add camera support
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-August/022317.html
> > 
> > Sorry again, still don't understand. What I mean is the following: take 
> > two cases - before and after your patch. What is the difference? As far as 
> > I know, the difference between platform_driver_probe() and 
> > platform_driver_register() is just that the probe method gets discarded in 
> > an __init section, which is suitable for non hotpluggable devices. I don't 
> > know what the difference this should make for call order. So, that's what 
> > I am asking about. Can you explain, how this patch changes the call order 
> > in your case? Can you tell, that in the unpatches case the probe is called 
> > at that moment, and in the patched case it is called at a different point 
> > of time and that fixes the problem.
> 
> 
> The following is above platform_driver_probe:
> 
>  * Use this instead of platform_driver_register() when you know the device
>  * is not hotpluggable and has already been registered, and you want to
>  * remove its run-once probe() infrastructure from memory after the
>  * driver has bound to the device.
> 
> So platform_driver_probe will only call the probe function when the device
> is already there when this function runs. This is not the case on our board.
> We have to register the camera in late_initcall (to make sure the needed
> regulators are already there). During late_initcall time the
> platform_driver_probe has already run.

Ok, now I see. I missed the key-phrase: "before the cameras device 
registration." Ok, in this case, it's certainly a valid reason for the 
change. Just one more question: wouldn't calling 
pcm970_baseboard_init_late() from device_initcall fix the problem without 
requiring to change the driver?

> I don't really like the trend to platform_driver_probe, because this
> makes cases like camera needs regulator which in turn needs SPI even
> more complicated.

Well, you can always change to using the platform_driver_register() if 
platform_driver_probe() causes problems, otherwise it does have its 
advantages, as described in the comment, you quoted above.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
