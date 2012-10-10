Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54574 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2JJNV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:21:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Wed, 10 Oct 2012 15:22:12 +0200
Message-ID: <4911109.4UeH6qZopn@avalon>
In-Reply-To: <201210081741.43546.hverkuil@xs4all.nl>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1210081708240.14454@axis700.grange> <201210081741.43546.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 08 October 2012 17:41:43 Hans Verkuil wrote:
> On Mon October 8 2012 17:15:53 Guennadi Liakhovetski wrote:
> > On Mon, 8 Oct 2012, Hans Verkuil wrote:
> > > On Mon October 8 2012 16:30:53 Guennadi Liakhovetski wrote:
> > > > On Mon, 8 Oct 2012, Hans Verkuil wrote:

[snip]

> > > > > I wonder, don't we have the necessary code already? V4L2 subdev
> > > > > drivers can have internal_ops with register/unregister ops. These
> > > > > are called by v4l2_device_register_subdev. This happens during the
> > > > > bridge driver's probe.
> > > > > 
> > > > > Suppose the subdev's probe does not actually access the i2c device,
> > > > > but instead defers that to the register callback? The bridge driver
> > > > > will turn on the clock before calling v4l2_device_register_subdev to
> > > > > ensure that the register callback can access the i2c registers. The
> > > > > register callback will do any initialization and can return an
> > > > > error. In case of an error the i2c client is automatically
> > > > > unregistered as well.
> > > > 
> > > > Yes, if v4l2_i2c_new_subdev_board() is used. This has been discussed
> > > > several times before and always what I didn't like in this is, that
> > > > I2C device probe() in this case succeeds without even trying to access
> > > > the hardware. And think about DT. In this case we don't instantiate
> > > > the I2C device, OF code does it for us. What do you do then? If you
> > > > let probe() succeed, then you will have to somehow remember the
> > > > subdevice to later match it against bridges...
> > > 
> > > Yes, but you need that information anyway. The bridge still needs to
> > > call v4l2_device_register_subdev so it needs to know which subdevs are
> > > loaded.
> > 
> > But how do you get the subdev pointer? With the notifier I get it from
> > i2c_get_clientdata(client) and what do you do without it? How do you get
> > to the client?
> > 
> > > And can't it get that from DT as well?
> > 
> > No, I don't think there is a way to get a device pointer from a DT node.
> 
> Not a device pointer, but the i2c bus and i2c address. With that information
> you can get the i2c_client, and with that you can get the subdev pointer.

That could work as well, but it might be easier to keep a mapping from the DT 
node to struct device or struct v4l2_subdev instead. I have no strong opinion 
on this at the moment.

> If there is no way to get that information from the proposed V4L2 DT, then
> it needs to be modified since a bridge driver really needs to know which
> subdevs it has to register with the v4l2_device struct. That information is
> also board specific so it should be part of the DT.
> 
> > > In my view you cannot do a proper initialization unless you have both
> > > the bridge driver and all subdev drivers loaded and instantiated. They
> > > need one another. So I am perfectly fine with letting the probe function
> > > do next to nothing and postponing that until register() is called. I2C
> > > and actual probing to check if it's the right device is a bad idea in
> > > general since you have no idea what a hardware access to an unknown i2c
> > > device will do. There are still some corner cases where that is needed,
> > > but I do not think that that is an issue here.
> > > 
> > > It would simplify things a lot IMHO. Also note that the register() op
> > > will work with any device, not just i2c. That may be a useful property
> > > as well.
> > 
> > And what if the subdevice device is not yet instantiated by OF by the time
> > your bridge driver probes?
> 
> That is where you still need to have a bus notifier mechanism. You have to
> be able to wait until all dependent drivers are loaded/instantiated, or
> alternatively you have to be able to load them explicitly. But this should
> be relatively easy to implement in a generic manner.
> 
> I still think this sucks (excuse my language), but I see no way around it as
> long as there is no explicit probe order one can rely on.

-- 
Regards,

Laurent Pinchart

