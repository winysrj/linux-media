Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49659 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753857Ab0BVQQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:16:31 -0500
Date: Mon, 22 Feb 2010 17:16:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Richard =?iso-8859-15?Q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: adv7180 as SoC camera device
In-Reply-To: <20100222160139.GL21778@enneenne.com>
Message-ID: <Pine.LNX.4.64.1002221706480.4120@axis700.grange>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
 <20100222160139.GL21778@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Feb 2010, Rodolfo Giometti wrote:

> On Fri, Feb 19, 2010 at 08:36:38PM +0100, Guennadi Liakhovetski wrote:
> > On Fri, 19 Feb 2010, Rodolfo Giometti wrote:
> > 
> > > Hello,
> > > 
> > > on my pxa27x based board I have a adv7180 connected with the CIF
> > > interface. Due this fact I'm going to use the pxa_camera.c driver
> > > which in turn registers a soc_camera_host.
> > > 
> > > In the latest kernel I found your driver for the ADV7180, but it
> > > registers the chip as a v4l sub device.
> > > 
> > > I suppose these two interfaces are not compatible, aren't they?
> > 
> > Congratulations! Thereby you're in a position to develop the first 
> > v4l2-subdev / soc-camera universal driver;) The answer to this your 
> > question is - they are... kinda. This means - yes, soc-camera is also 
> > using the v4l2-subdev API, but - with a couple of additions. Basically, 
> > there are two things you have to change in the adv7180 driver to make it 
> > compatible with soc-camera - (1) add bus-configuration methods, even if 
> > they don't do much (see .query_bus_param() and .set_bus_param() methods 
> > from struct soc_camera_ops), and (2) migrate the driver to the mediabus 
> > API. The latter one requires some care - in principle, mediabus should be 
> > the future API to negotiate parameters on the video bus between bridges 
> > (in your case PXA CIF) and clients, but for you this means you also have 
> > to migrate any other bridge drivers in the mainline to that API, and, if 
> > they also interface to some other subdevices - those too, and if those can 
> > also work with other bridges - those too...;) But, I think, that chain 
> > will terminate quite soon, in fact, I cannot find any users of that driver 
> > currently in the mainline, Richard?
> > 
> > > In this situation, should I write a new driver for the
> > > soc_camera_device? Which is The-Right-Thing(TM) to do? :)
> > 
> > Please, have a look and try to convert the driver as described above. All 
> > the APIs and a few examples are in the mainline, so, you should have 
> > enough copy-paste sources;) Ask on the list (with me on cc) if anything is 
> > still unclear.
> 
> Thanks for your quick answer! :)
> 
> What I still don't understand is if should I move the driver form
> v4l2-subdev to a soc_camera device or trying to support both API...

Both. It is just one (v4l2-subdev) API, but soc-camera is using some 
extensions to it.

> It seems to me that the driver is not used by any machines into
> mainline

That makes your task even easier - you do not have to convert any bridge 
drivers to mediabus API.

> so if soc-camera is also using the v4l2-subdev API but with a
> couple of additions I suppose I can move it to soc_camera API...

Not move, extend. But preserve an ability to function without soc-camera 
additions too. I.e., the use of soc-camera extensions should be optional 
in your driver. Look here 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11486/focus=11493 
for an example.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
