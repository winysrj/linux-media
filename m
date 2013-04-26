Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51979 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302Ab3DZJP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 05:15:57 -0400
Date: Fri, 26 Apr 2013 11:15:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 23/24] V4L2: mt9p031: add struct
 v4l2_subdev_platform_data to platform data
Message-ID: <20130426091556.GQ32299@pengutronix.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
 <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1304182346060.28933@axis700.grange>
 <1621615.OUnKCBbkfO@avalon>
 <Pine.LNX.4.64.1304221435540.23906@axis700.grange>
 <20130426083023.GA16843@pengutronix.de>
 <Pine.LNX.4.64.1304261033170.32320@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304261033170.32320@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 26, 2013 at 10:43:28AM +0200, Guennadi Liakhovetski wrote:
> Hi Sascha
> 
> On Fri, 26 Apr 2013, Sascha Hauer wrote:
> 
> > > > 
> > > > That information should be conveyed by platform/DT data for the host, and be 
> > > > used to convert the 12-bit media bus code into a 8-bit media bus code in the 
> > > > host (a core helper function would probably be helpful).
> > > 
> > > Yes, and we discussed this before too, I think. I proposed based then to 
> > > implement some compatibility table of "trivial" transformations, like a 
> > > 12-bit Bayer, right-shifted by 4 bits, produces a respective 8-bit Bayer 
> > > etc. Such transformations would fit nicely in soc_mediabus.c ;-) This just 
> > > needs to be implemented...
> > 
> > These "trivial" transformations may turn out not to be so trivial. In
> > the devicetree we would then need kind of 'shift-4-bit-left' properties.
> 
> We already have a "data-shift" property exactly for this purpose.
> 
> > How about instead describing the sensor node with:
> > 
> > 	mbus-formats = <0x3010, 0x2013>;
> > 
> > and the corresponding host interface with:
> > 
> > 	mbus-formats = <0x3013, 0x2001>;
> 
> How would this describe _how_ the transformation should be performed?

nth index in the sensor array matches nth index in the csi array. The
above describes:

V4L2_MBUS_FMT_SGBRG12_1X12 on the sensor matches V4L2_MBUS_FMT_SGBRG8_1X8 on the host
V4L2_MBUS_FMT_Y12_1X12 on the sensor matches V4L2_MBUS_FMT_Y8_1X8 on the host

effectively implementing a shift by four bits. But also more complicated
transformations could be described, like a colour space converter
implemented in a DSP (not sure if anyone does this, but you get the
idea)

> And why does the host driver need mbus formats?

Because mbus formats are effectively the input of a host driver. I
assumed that we translate the mbus formats the sensor can output into
the corresponding mbus formats that arrive at the host interface. Then
afterwards the usual translation from mbus to fourcc a host interface
can do is performed.
I think what you aim at instead is a translation directly from the
sensor to memory which I think is more complicated to build correctly.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
