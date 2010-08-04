Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40852 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab0HDHJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 03:09:50 -0400
Date: Wed, 4 Aug 2010 09:09:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <mgr@pengutronix.de>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
Message-ID: <20100804070949.GR14113@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de> <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008032016340.10845@axis700.grange> <20100803195727.GB12367@pengutronix.de> <Pine.LNX.4.64.1008040039550.10845@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008040039550.10845@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 04, 2010 at 01:01:34AM +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> 
> > On Tue, Aug 03, 2010 at 08:22:13PM +0200, Guennadi Liakhovetski wrote:
> > > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > > 
> > > > change this driver back to register and probe, since some platforms
> > > > first have to initialize an already registered power regulator to switch
> > > > on the camera.
> > > 
> > > Sorry, don't see a difference. Can you give an example of two call 
> > > sequences, where this change changes the behaviour?
> > >
> > 
> > Yes, when you look at the today posted patch [1] you find the function
> > pcm970_baseboard_init_late as an late_initcall. It uses an already
> > registred regulator device to turn on the power of the camera before the
> > cameras device registration.
> > 
> > [1] [PATCH 1/2] ARM: i.MX27 pcm970: Add camera support
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-August/022317.html
> 
> Sorry again, still don't understand. What I mean is the following: take 
> two cases - before and after your patch. What is the difference? As far as 
> I know, the difference between platform_driver_probe() and 
> platform_driver_register() is just that the probe method gets discarded in 
> an __init section, which is suitable for non hotpluggable devices. I don't 
> know what the difference this should make for call order. So, that's what 
> I am asking about. Can you explain, how this patch changes the call order 
> in your case? Can you tell, that in the unpatches case the probe is called 
> at that moment, and in the patched case it is called at a different point 
> of time and that fixes the problem.


The following is above platform_driver_probe:

 * Use this instead of platform_driver_register() when you know the device
 * is not hotpluggable and has already been registered, and you want to
 * remove its run-once probe() infrastructure from memory after the
 * driver has bound to the device.

So platform_driver_probe will only call the probe function when the device
is already there when this function runs. This is not the case on our board.
We have to register the camera in late_initcall (to make sure the needed
regulators are already there). During late_initcall time the
platform_driver_probe has already run.

I don't really like the trend to platform_driver_probe, because this
makes cases like camera needs regulator which in turn needs SPI even
more complicated.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
