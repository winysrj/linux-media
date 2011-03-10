Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37987 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1CJQlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 11:41:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: mt9p031 support for Beagleboard.
Date: Thu, 10 Mar 2011 17:41:41 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com> <201103101701.19396.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404E1F52AA2@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E1F52AA2@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101741.41403.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Vaibhav,

On Thursday 10 March 2011 17:23:52 Hiremath, Vaibhav wrote:
> On Thursday, March 10, 2011 9:31 PM Laurent Pinchart wrote: > > On Thursday 
10 March 2011 16:47:46 Hiremath, Vaibhav wrote:
> > > On Thursday, March 10, 2011 9:14 PM Laurent Pinchart wrote:
> > > > I'm curious about the Beagleboard code, as the camera module is an
> > > > expansion board you obviously can't hardcode support for it in the
> > > > board file. How do you plan to handle that ?
> > > 
> > > I did not understand your concern here, I already have MT9V113 sensor
> > > running with Media-controller (YUV format) on top of beagleXm board.
> > 
> > It's easy to patch the board-omap3beagle.c file to support the sensor,
> > but how can that patch be pushed to mainline ? We have a wide range of
> > sensors that can be connected to the Beagleboard, so this needs to be
> > somehow configurable.
> 
> Let me put my understanding here,
> 
> BeagleXM supports set of parallel sensors (MT9V113, MT9P031, MT9T111,
> etc...),  out of this I believe reset gpio, regulator and data channel
> path enable part is going to be common between all of the sensors.
> 
> The things which will be different would be, especially clock configuration
> and i2c address. I2C address is going to be very crucial and need some
> thinking, since there are sensors with same I2C address.

I2C addresses, signals polarities and data lane shifting will need to be 
configured.

> I guess I am still not following you completely (must be missing
> something), would you mind help me to understand your concern here.

Those parameters all need to be provided by board code. You can't push a patch 
that adds hardcoded support for the MT9P031 to the board-omap3beagled.c file 
upstream, as not all Beagleboards will have an MT9P031 sensor connected (or 
even any sensor at all). How can we push the code upstream and still make it 
configurable enough ?

> [By next week I should be able to make all my changes public (into my Arago
> repo) for reference]

There are too many repositories with code lying around. We should try to 
coordinate our efforts.

-- 
Regards,

Laurent Pinchart
