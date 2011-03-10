Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:32941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab1CJQYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 11:24:09 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 10 Mar 2011 21:53:52 +0530
Subject: RE: mt9p031 support for Beagleboard.
Message-ID: <19F8576C6E063C45BE387C64729E739404E1F52AA2@dbde02.ent.ti.com>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
 <201103101644.23547.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739404E1F52A88@dbde02.ent.ti.com>
 <201103101701.19396.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103101701.19396.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, March 10, 2011 9:31 PM
> To: Hiremath, Vaibhav
> Cc: Guennadi Liakhovetski; javier Martin; Linux Media Mailing List; Mauro
> Carvalho Chehab
> Subject: Re: mt9p031 support for Beagleboard.
> 
> On Thursday 10 March 2011 16:47:46 Hiremath, Vaibhav wrote:
> > On Thursday, March 10, 2011 9:14 PM Laurent Pinchart wrote:
> > >
> > > I'm curious about the Beagleboard code, as the camera module is an
> > > expansion board you obviously can't hardcode support for it in the
> board
> > > file. How do you plan to handle that ?
> >
> > I did not understand your concern here, I already have MT9V113 sensor
> > running with Media-controller (YUV format) on top of beagleXm board.
> 
> It's easy to patch the board-omap3beagle.c file to support the sensor, but
> how
> can that patch be pushed to mainline ? We have a wide range of sensors
> that
> can be connected to the Beagleboard, so this needs to be somehow
> configurable.
> 
[Hiremath, Vaibhav] Let me put my understanding here,

BeagleXM supports set of parallel sensors (MT9V113, MT9P031, MT9T111, etc...),  out of this I believe reset gpio, regulator and data channel path enable part is going to be common between all of the sensors.

The things which will be different would be, especially clock configuration and i2c address. I2C address is going to be very crucial and need some thinking, since there are sensors with same I2C address.

I guess I am still not following you completely (must be missing something), would you mind help me to understand your concern here.



[By next week I should be able to make all my changes public (into my Arago repo) for reference]

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
