Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49826 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0BVQBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:01:47 -0500
Date: Mon, 22 Feb 2010 17:01:39 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Richard =?iso-8859-15?Q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-ID: <20100222160139.GL21778@enneenne.com>
References: <20100219174451.GH21778@enneenne.com>
 <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
Subject: Re: adv7180 as SoC camera device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 19, 2010 at 08:36:38PM +0100, Guennadi Liakhovetski wrote:
> On Fri, 19 Feb 2010, Rodolfo Giometti wrote:
> 
> > Hello,
> > 
> > on my pxa27x based board I have a adv7180 connected with the CIF
> > interface. Due this fact I'm going to use the pxa_camera.c driver
> > which in turn registers a soc_camera_host.
> > 
> > In the latest kernel I found your driver for the ADV7180, but it
> > registers the chip as a v4l sub device.
> > 
> > I suppose these two interfaces are not compatible, aren't they?
> 
> Congratulations! Thereby you're in a position to develop the first 
> v4l2-subdev / soc-camera universal driver;) The answer to this your 
> question is - they are... kinda. This means - yes, soc-camera is also 
> using the v4l2-subdev API, but - with a couple of additions. Basically, 
> there are two things you have to change in the adv7180 driver to make it 
> compatible with soc-camera - (1) add bus-configuration methods, even if 
> they don't do much (see .query_bus_param() and .set_bus_param() methods 
> from struct soc_camera_ops), and (2) migrate the driver to the mediabus 
> API. The latter one requires some care - in principle, mediabus should be 
> the future API to negotiate parameters on the video bus between bridges 
> (in your case PXA CIF) and clients, but for you this means you also have 
> to migrate any other bridge drivers in the mainline to that API, and, if 
> they also interface to some other subdevices - those too, and if those can 
> also work with other bridges - those too...;) But, I think, that chain 
> will terminate quite soon, in fact, I cannot find any users of that driver 
> currently in the mainline, Richard?
> 
> > In this situation, should I write a new driver for the
> > soc_camera_device? Which is The-Right-Thing(TM) to do? :)
> 
> Please, have a look and try to convert the driver as described above. All 
> the APIs and a few examples are in the mainline, so, you should have 
> enough copy-paste sources;) Ask on the list (with me on cc) if anything is 
> still unclear.

Thanks for your quick answer! :)

What I still don't understand is if should I move the driver form
v4l2-subdev to a soc_camera device or trying to support both API...

It seems to me that the driver is not used by any machines into
mainline so if soc-camera is also using the v4l2-subdev API but with a
couple of additions I suppose I can move it to soc_camera API...

Is that right?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
