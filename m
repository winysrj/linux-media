Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32942 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1CJRyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 12:54:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: mt9p031 support for Beagleboard.
Date: Thu, 10 Mar 2011 18:54:32 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com> <201103101741.41403.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404E1F52AB5@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E1F52AB5@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101854.33109.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Vaibhav,

On Thursday 10 March 2011 18:09:42 Hiremath, Vaibhav wrote:
> On Thursday, March 10, 2011 10:12 PM Laurent Pinchart wrote:
> > On Thursday 10 March 2011 17:23:52 Hiremath, Vaibhav wrote:
> > >
> > > BeagleXM supports set of parallel sensors (MT9V113, MT9P031, MT9T111,
> > > etc...),  out of this I believe reset gpio, regulator and data channel
> > > path enable part is going to be common between all of the sensors.
> > > 
> > > The things which will be different would be, especially clock
> > > configuration and i2c address. I2C address is going to be very crucial
> > > and need some thinking, since there are sensors with same I2C address.
> > 
> > I2C addresses, signals polarities and data lane shifting will need to be
> > configured.
> > 
> > > I guess I am still not following you completely (must be missing
> > > something), would you mind help me to understand your concern here.
> > 
> > Those parameters all need to be provided by board code. You can't push a
> > patch that adds hardcoded support for the MT9P031 to the
> > board-omap3beagle.c file upstream, as not all Beagleboards will have an
> > MT9P031 sensor connected (or even any sensor at all). How can we push the
> > code upstream and still make it configurable enough ?
> 
> I don't think some of these parameters we can make configurable, for
> example, platform_data for sensor, it has to be sensor specific. I2C
> address, it has to be sensor dependent, etc...

What I mean is that we can't hardcode the presence of a given sensor in the 
board file, as the sensors can be plugged in as addon board. Support for a 
specific sensor module connected to the Beagleboard must thus come in the form 
of a kernel build option or a module (I'm not talking about the sensor driver 
itself, but the sensor and OMAP3 ISP data that must be provided by board 
code).

> Also, I am quite not sure how can we make things configurable based on
> presence of daughter card here. If we do not have daughter card connected
> to board, enumeration will fail.
> 
> > > [By next week I should be able to make all my changes public (into my
> > > Arago repo) for reference]
> > 
> > There are too many repositories with code lying around. We should try to
> > coordinate our efforts.
> 
> I agree with you.

Any suggestion ? Should I create a repository based on mainline (or latest 
linux-media tree) and maintain sensor drivers there before they get pushed to 
mainline ?

-- 
Regards,

Laurent Pinchart
