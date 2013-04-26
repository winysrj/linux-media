Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58984 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab3DZIa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 04:30:27 -0400
Date: Fri, 26 Apr 2013 10:30:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 23/24] V4L2: mt9p031: add struct
 v4l2_subdev_platform_data to platform data
Message-ID: <20130426083023.GA16843@pengutronix.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
 <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1304182346060.28933@axis700.grange>
 <1621615.OUnKCBbkfO@avalon>
 <Pine.LNX.4.64.1304221435540.23906@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304221435540.23906@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, Apr 22, 2013 at 02:39:57PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 22 Apr 2013, Laurent Pinchart wrote:
> 
> > Hi Guennadi,
> > 
> > On Thursday 18 April 2013 23:47:26 Guennadi Liakhovetski wrote:
> > > On Thu, 18 Apr 2013, Guennadi Liakhovetski wrote:
> > > > Adding struct v4l2_subdev_platform_data to mt9p031's platform data allows
> > > > the driver to use generic functions to manage sensor power supplies.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > 
> > > A small addition to this one too: to be absolutely honest, I also had to
> > > replace 12-bit formats with their 8-bit counterparts, because only 8 data
> > > lanes are connected to my camera host. We'll need to somehow properly
> > > solve this too.
> > 
> > That information should be conveyed by platform/DT data for the host, and be 
> > used to convert the 12-bit media bus code into a 8-bit media bus code in the 
> > host (a core helper function would probably be helpful).
> 
> Yes, and we discussed this before too, I think. I proposed based then to 
> implement some compatibility table of "trivial" transformations, like a 
> 12-bit Bayer, right-shifted by 4 bits, produces a respective 8-bit Bayer 
> etc. Such transformations would fit nicely in soc_mediabus.c ;-) This just 
> needs to be implemented...

These "trivial" transformations may turn out not to be so trivial. In
the devicetree we would then need kind of 'shift-4-bit-left' properties.

How about instead describing the sensor node with:

	mbus-formats = <0x3010, 0x2013>;

and the corresponding host interface with:

	mbus-formats = <0x3013, 0x2001>;

This would allow to describe arbitrary transformations without having to
limit to the 'trivial' ones. The result would be easier to understand
also I think.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
