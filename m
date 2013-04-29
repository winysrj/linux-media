Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3D2KBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 06:01:14 -0400
Date: Mon, 29 Apr 2013 12:01:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice
 registration
Message-ID: <20130429100105.GH32299@pengutronix.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
 <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
 <20130426084422.GB16843@pengutronix.de>
 <Pine.LNX.4.64.1304262302500.5698@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304262302500.5698@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 26, 2013 at 11:07:24PM +0200, Guennadi Liakhovetski wrote:
> Hi Sascha
> 
> On Fri, 26 Apr 2013, Sascha Hauer wrote:
> 
> > Hi Guennadi,
> > 
> > On Fri, Apr 12, 2013 at 05:40:22PM +0200, Guennadi Liakhovetski wrote:
> > > +
> > > +static bool match_i2c(struct device *dev, struct v4l2_async_hw_info *hw_dev)
> > > +{
> > > +	struct i2c_client *client = i2c_verify_client(dev);
> > > +	return client &&
> > > +		hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
> > > +		hw_dev->match.i2c.adapter_id == client->adapter->nr &&
> > > +		hw_dev->match.i2c.address == client->addr;
> > > +}
> > > +
> > > +static bool match_platform(struct device *dev, struct v4l2_async_hw_info *hw_dev)
> > > +{
> > > +	return hw_dev->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
> > > +		!strcmp(hw_dev->match.platform.name, dev_name(dev));
> > > +}
> > 
> > I recently solved the same problem without being aware of your series.
> > 
> > How about registering the asynchronous subdevices with a 'void *key'
> > instead of a bus specific matching function?
> 
> Personally I don't think adding dummy data is a good idea. You can of 
> course use pointers to real data, even just to the device object itself. 
> But I really was trying to unbind host and subdevice devices, similar how 
> clocks or pinmux entries or regulators are matched to their users. In the 
> DT case we already use phandles to bind entities / pads / in whatever 
> terms you prefer to think;-)

Do you have some preview patches for doing asynchronous subdevice
registration with devicetree? I mean this series and the v4l2 of parser
patches are not enough for the whole picture, right?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
