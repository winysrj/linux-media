Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57911 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaFCJaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 05:30:35 -0400
Message-ID: <1401787831.3434.12.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media] mt9v032: Add support for mt9v022 and mt9v024
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Tue, 03 Jun 2014 11:30:31 +0200
In-Reply-To: <7046827.ExJCarEAac@avalon>
References: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de>
	 <2161017.E5TWD97cmR@avalon>
	 <1401287815.3054.60.camel@paszta.hi.pengutronix.de>
	 <7046827.ExJCarEAac@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Guennadi,

Am Mittwoch, den 28.05.2014, 16:44 +0200 schrieb Laurent Pinchart:
> If you had submitted an entirely new driver for a sensor already supported by 
> an soc-camera sensor driver, I would have told you to fix the problem on soc-
> camera side. As you're only expanding hardware support for an existing driver, 
> it's hard to nack your patch in all fairness :-) I will thus not veto option 
> 2, even though I would prefer if we fixed the problem once and for all.
>
> > > > I'm ok with either 1 or 3, whereas 3 is
> > > > more difficult than 1.
> > > 
> > > This topic has been discussed over and over. It indeed "just" requires
> > > someone to do it, although it might be more complex than that sounds.
> > > 
> > > We need to fix the infrastructure to make sensor drivers completely
> > > unaware of soc-camera. This isn't about extending the mt9v022 driver to
> > > work with non soc-camera hosts, it's about fixing soc-camera not to
> > > require any change to sensor drivers. Philipp, if you have time to work
> > > on that, we can discuss what needs to be done.

What steps would need to be taken to make soc_camera work with the
non-soc_camera drivers in drivers/media/i2c?
I don't have any soc_camera platform at hand, although I could try to revive
a PXA270 board.

> > I don't have a use case for soc_camera. Instead of trying to fix it to
> > use generic sensor drivers, I'd rather use that time to prepare
> > non-soc_camera capture host support.
> 
> Which host would that be, if you can tell ?

Yes, i.MX6.

> > > On the sensor side, we should have a single driver for the mt9v022, 024
> > > and 032 sensors. I would vote for merging the two drivers into
> > > drivers/media/i2c/mt9v032.c, as that one is closer to the goal of not
> > > being soc-camera specific.

regards
Philipp


