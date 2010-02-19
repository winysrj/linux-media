Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48554 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755011Ab0BSTg2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:36:28 -0500
Date: Fri, 19 Feb 2010 20:36:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Richard =?iso-8859-15?Q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: adv7180 as SoC camera device
In-Reply-To: <20100219174451.GH21778@enneenne.com>
Message-ID: <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
References: <20100219174451.GH21778@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 19 Feb 2010, Rodolfo Giometti wrote:

> Hello,
> 
> on my pxa27x based board I have a adv7180 connected with the CIF
> interface. Due this fact I'm going to use the pxa_camera.c driver
> which in turn registers a soc_camera_host.
> 
> In the latest kernel I found your driver for the ADV7180, but it
> registers the chip as a v4l sub device.
> 
> I suppose these two interfaces are not compatible, aren't they?

Congratulations! Thereby you're in a position to develop the first 
v4l2-subdev / soc-camera universal driver;) The answer to this your 
question is - they are... kinda. This means - yes, soc-camera is also 
using the v4l2-subdev API, but - with a couple of additions. Basically, 
there are two things you have to change in the adv7180 driver to make it 
compatible with soc-camera - (1) add bus-configuration methods, even if 
they don't do much (see .query_bus_param() and .set_bus_param() methods 
from struct soc_camera_ops), and (2) migrate the driver to the mediabus 
API. The latter one requires some care - in principle, mediabus should be 
the future API to negotiate parameters on the video bus between bridges 
(in your case PXA CIF) and clients, but for you this means you also have 
to migrate any other bridge drivers in the mainline to that API, and, if 
they also interface to some other subdevices - those too, and if those can 
also work with other bridges - those too...;) But, I think, that chain 
will terminate quite soon, in fact, I cannot find any users of that driver 
currently in the mainline, Richard?

> In this situation, should I write a new driver for the
> soc_camera_device? Which is The-Right-Thing(TM) to do? :)

Please, have a look and try to convert the driver as described above. All 
the APIs and a few examples are in the mainline, so, you should have 
enough copy-paste sources;) Ask on the list (with me on cc) if anything is 
still unclear.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
