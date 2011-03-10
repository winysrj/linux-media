Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37205 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab1CJRJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 12:09:58 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 10 Mar 2011 22:39:42 +0530
Subject: RE: mt9p031 support for Beagleboard.
Message-ID: <19F8576C6E063C45BE387C64729E739404E1F52AB5@dbde02.ent.ti.com>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
 <201103101701.19396.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739404E1F52AA2@dbde02.ent.ti.com>
 <201103101741.41403.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103101741.41403.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, March 10, 2011 10:12 PM
> To: Hiremath, Vaibhav
> Cc: Guennadi Liakhovetski; javier Martin; Linux Media Mailing List; Mauro
> Carvalho Chehab
> Subject: Re: mt9p031 support for Beagleboard.
> 
> Hi Vaibhav,
> 
> On Thursday 10 March 2011 17:23:52 Hiremath, Vaibhav wrote:
> > On Thursday, March 10, 2011 9:31 PM Laurent Pinchart wrote: > > On
> Thursday
> 10 March 2011 16:47:46 Hiremath, Vaibhav wrote:
> > > > On Thursday, March 10, 2011 9:14 PM Laurent Pinchart wrote:
<snip>
> >
> > BeagleXM supports set of parallel sensors (MT9V113, MT9P031, MT9T111,
> > etc...),  out of this I believe reset gpio, regulator and data channel
> > path enable part is going to be common between all of the sensors.
> >
> > The things which will be different would be, especially clock
> configuration
> > and i2c address. I2C address is going to be very crucial and need some
> > thinking, since there are sensors with same I2C address.
> 
> I2C addresses, signals polarities and data lane shifting will need to be
> configured.
> 
> > I guess I am still not following you completely (must be missing
> > something), would you mind help me to understand your concern here.
> 
> Those parameters all need to be provided by board code. You can't push a
> patch
> that adds hardcoded support for the MT9P031 to the board-omap3beagled.c
> file
> upstream, as not all Beagleboards will have an MT9P031 sensor connected
> (or
> even any sensor at all). How can we push the code upstream and still make
> it
> configurable enough ?
> 
[Hiremath, Vaibhav] I don't think some of these parameters we can make configurable, for example, platform_data for sensor, it has to be sensor specific. I2C address, it has to be sensor dependent, etc...

Also, I am quite not sure how can we make things configurable based on presence of daughter card here. If we do not have daughter card connected to board, enumeration will fail.

> > [By next week I should be able to make all my changes public (into my
> Arago
> > repo) for reference]
> 
> There are too many repositories with code lying around. We should try to
> coordinate our efforts.
> 
[Hiremath, Vaibhav] I agree with you.

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
