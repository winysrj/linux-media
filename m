Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:49279 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756319Ab0HCXBe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Aug 2010 19:01:34 -0400
Date: Wed, 4 Aug 2010 01:01:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
In-Reply-To: <20100803195727.GB12367@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008040039550.10845@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008032016340.10845@axis700.grange> <20100803195727.GB12367@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Aug 2010, Michael Grzeschik wrote:

> On Tue, Aug 03, 2010 at 08:22:13PM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > 
> > > change this driver back to register and probe, since some platforms
> > > first have to initialize an already registered power regulator to switch
> > > on the camera.
> > 
> > Sorry, don't see a difference. Can you give an example of two call 
> > sequences, where this change changes the behaviour?
> >
> 
> Yes, when you look at the today posted patch [1] you find the function
> pcm970_baseboard_init_late as an late_initcall. It uses an already
> registred regulator device to turn on the power of the camera before the
> cameras device registration.
> 
> [1] [PATCH 1/2] ARM: i.MX27 pcm970: Add camera support
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-August/022317.html

Sorry again, still don't understand. What I mean is the following: take 
two cases - before and after your patch. What is the difference? As far as 
I know, the difference between platform_driver_probe() and 
platform_driver_register() is just that the probe method gets discarded in 
an __init section, which is suitable for non hotpluggable devices. I don't 
know what the difference this should make for call order. So, that's what 
I am asking about. Can you explain, how this patch changes the call order 
in your case? Can you tell, that in the unpatches case the probe is called 
at that moment, and in the patched case it is called at a different point 
of time and that fixes the problem.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
