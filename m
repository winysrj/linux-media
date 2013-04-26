Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3DZIni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 04:43:38 -0400
Date: Fri, 26 Apr 2013 10:43:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 23/24] V4L2: mt9p031: add struct v4l2_subdev_platform_data
 to platform data
In-Reply-To: <20130426083023.GA16843@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1304261033170.32320@axis700.grange>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
 <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1304182346060.28933@axis700.grange> <1621615.OUnKCBbkfO@avalon>
 <Pine.LNX.4.64.1304221435540.23906@axis700.grange> <20130426083023.GA16843@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha

On Fri, 26 Apr 2013, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Mon, Apr 22, 2013 at 02:39:57PM +0200, Guennadi Liakhovetski wrote:
> > On Mon, 22 Apr 2013, Laurent Pinchart wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > On Thursday 18 April 2013 23:47:26 Guennadi Liakhovetski wrote:
> > > > On Thu, 18 Apr 2013, Guennadi Liakhovetski wrote:
> > > > > Adding struct v4l2_subdev_platform_data to mt9p031's platform data allows
> > > > > the driver to use generic functions to manage sensor power supplies.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > 
> > > > A small addition to this one too: to be absolutely honest, I also had to
> > > > replace 12-bit formats with their 8-bit counterparts, because only 8 data
> > > > lanes are connected to my camera host. We'll need to somehow properly
> > > > solve this too.
> > > 
> > > That information should be conveyed by platform/DT data for the host, and be 
> > > used to convert the 12-bit media bus code into a 8-bit media bus code in the 
> > > host (a core helper function would probably be helpful).
> > 
> > Yes, and we discussed this before too, I think. I proposed based then to 
> > implement some compatibility table of "trivial" transformations, like a 
> > 12-bit Bayer, right-shifted by 4 bits, produces a respective 8-bit Bayer 
> > etc. Such transformations would fit nicely in soc_mediabus.c ;-) This just 
> > needs to be implemented...
> 
> These "trivial" transformations may turn out not to be so trivial. In
> the devicetree we would then need kind of 'shift-4-bit-left' properties.

We already have a "data-shift" property exactly for this purpose.

> How about instead describing the sensor node with:
> 
> 	mbus-formats = <0x3010, 0x2013>;
> 
> and the corresponding host interface with:
> 
> 	mbus-formats = <0x3013, 0x2001>;

How would this describe _how_ the transformation should be performed? And 
why does the host driver need mbus formats? The translation is from mbus 
formats to fourcc formats (in memory). If you use those as bridge DT node 
properties, that would only tell the bridge driver which mbus format to 
request from the subdevice when requested fourcc format X. This decision 
soc-camera currently performs automatically, if this is ever needed as a 
configuration parameter, we'll think then where and how to put it.

Thanks
Guennadi

> This would allow to describe arbitrary transformations without having to
> limit to the 'trivial' ones. The result would be easier to understand
> also I think.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
