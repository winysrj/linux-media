Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1392 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab0BVQKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:10:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: adv7180 as SoC camera device
Date: Mon, 22 Feb 2010 17:11:18 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Richard =?iso-8859-1?q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange> <20100222160139.GL21778@enneenne.com>
In-Reply-To: <20100222160139.GL21778@enneenne.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002221711.18874.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 February 2010 17:01:39 Rodolfo Giometti wrote:
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
> 
> It seems to me that the driver is not used by any machines into
> mainline so if soc-camera is also using the v4l2-subdev API but with a
> couple of additions I suppose I can move it to soc_camera API...

The long-term goal is to remove the last soc-camera API dependencies from
the sensor subdev drivers. Subdevice (usually i2c) drivers should be fully
reusable and a dependency on soc-camera defeats that goal.

I think the only missing piece is low-level bus setup (i.e. sync polarities,
rising/falling edge sampling, etc.). Some proposals were made, but basically
nobody has had the time to actually implement this.

Right now, if you want to use your sensor with soc-camera, then you need to
support the soc-camera API (or what is left of it) in your subdev driver as
well.

Regards,

	Hans

> 
> Is that right?
> 
> Ciao,
> 
> Rodolfo
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
