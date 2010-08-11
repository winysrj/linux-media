Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42629 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0HKHNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 03:13:54 -0400
Date: Wed, 11 Aug 2010 09:13:53 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
Message-ID: <20100811071352.GE13418@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de> <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008052211560.26127@axis700.grange> <20100810102536.GA13418@pengutronix.de> <Pine.LNX.4.64.1008102050580.18934@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008102050580.18934@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hey Guennadi,

On Tue, Aug 10, 2010 at 09:08:11PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 10 Aug 2010, Michael Grzeschik wrote:
> 
> > Hi Guennadi,
> > 
> > On Thu, Aug 05, 2010 at 10:17:11PM +0200, Guennadi Liakhovetski wrote:
> > > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > > 
> > > > change this driver back to register and probe, since some platforms
> > > > first have to initialize an already registered power regulator to switch
> > > > on the camera.
> > > 
> > > I shall be preparing a pull-request for 2.6.36-rc1 #2, but since we 
> > > haven't finished discussing this and when this is ready, this will be a 
> > > fix - without this your platform doesn't work, right? So, we can push it 
> > > after rc1.
> > 
> > The issue is, that we cannot change the platform code from the
> > late_initcall structure. For me there is no other solution than that,
> > because we have to enable the regulator before the camera chip to
> > communicate over i2c. If we would move to the notify way we would
> > first listen for the i2c enabled clients but for that we would still
> > have to first enable the regulator. At this moment i don't see a
> > solution in this way.
> 
> Hm, I think, there is an easier way to do this: just use the .power() 
> callback from struct soc_camera_link. It is called for the first time 
> before the camera is added to the i2c bus, so, before any IO is taking 
> place. Just be careful to make sure you don't call one-time init actions 
> (like gpio_request()) multiple times - .power is called also later again 
> upon each open / close. So, you'll need some flag to detect the very first 
> power-on.

this seems for me to be the best solution so far. At this time i have a
patched version (v2) for my pcm970-baseboard.c glue code. I will send it
ASOP, so this "change back to probe and register patch" is not needed
anymore.

> Sorry, for keeping on my attempts to avoid your patch - it really seems to 
> me, a better solution is possible.
Good thoughts!

Thanks for the hints,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
