Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:35669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932358Ab0HJTHv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 15:07:51 -0400
Date: Tue, 10 Aug 2010 21:08:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
In-Reply-To: <20100810102536.GA13418@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008102050580.18934@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008052211560.26127@axis700.grange> <20100810102536.GA13418@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 10 Aug 2010, Michael Grzeschik wrote:

> Hi Guennadi,
> 
> On Thu, Aug 05, 2010 at 10:17:11PM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > 
> > > change this driver back to register and probe, since some platforms
> > > first have to initialize an already registered power regulator to switch
> > > on the camera.
> > 
> > I shall be preparing a pull-request for 2.6.36-rc1 #2, but since we 
> > haven't finished discussing this and when this is ready, this will be a 
> > fix - without this your platform doesn't work, right? So, we can push it 
> > after rc1.
> 
> The issue is, that we cannot change the platform code from the
> late_initcall structure. For me there is no other solution than that,
> because we have to enable the regulator before the camera chip to
> communicate over i2c. If we would move to the notify way we would
> first listen for the i2c enabled clients but for that we would still
> have to first enable the regulator. At this moment i don't see a
> solution in this way.

Hm, I think, there is an easier way to do this: just use the .power() 
callback from struct soc_camera_link. It is called for the first time 
before the camera is added to the i2c bus, so, before any IO is taking 
place. Just be careful to make sure you don't call one-time init actions 
(like gpio_request()) multiple times - .power is called also later again 
upon each open / close. So, you'll need some flag to detect the very first 
power-on.

Sorry, for keeping on my attempts to avoid your patch - it really seems to 
me, a better solution is possible.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
