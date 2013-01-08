Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36821 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3AHKeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 05:34:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
Date: Tue, 08 Jan 2013 11:35:42 +0100
Message-ID: <18858693.KSUhrxG65A@avalon>
In-Reply-To: <Pine.LNX.4.64.1301081123590.1794@axis700.grange>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <13183539.ohZBrHhPax@avalon> <Pine.LNX.4.64.1301081123590.1794@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 08 January 2013 11:26:57 Guennadi Liakhovetski wrote:
> On Tue, 8 Jan 2013, Laurent Pinchart wrote:
> > On Tuesday 08 January 2013 10:56:43 Guennadi Liakhovetski wrote:
> > > On Tue, 8 Jan 2013, Laurent Pinchart wrote:
> > > > On Tuesday 08 January 2013 10:25:15 Guennadi Liakhovetski wrote:
> > > > > On Tue, 8 Jan 2013, Laurent Pinchart wrote:

[snip]

> > > > > > Could you please explain why you need both a bind notifier and a
> > > > > > bound notifier ? I was expecting a single
> > > > > > v4l2_async_subdev_register() call in subdev drivers (and, thinking
> > > > > > about it, I would probably name it v4l2_subdev_register()).
> > > > > 
> > > > > I think I can, yes. Because between .bind() and .bound() the
> > > > > subdevice driver does the actual hardware probing. So, .bind() is
> > > > > used to make sure the hardware can be accessed, most importantly to
> > > > > provide a clock to the subdevice. You can look at
> > > > > soc_camera_async_bind(). There I'm registering the clock for the
> > > > > subdevice, about to bind. Why I cannot do it before, is because I
> > > > > need subdevice name for clock matching. With I2C subdevices the
> > > > > subdevice name contains the name of the driver, adapter number and
> > > > > i2c address. The latter 2 I've got from host subdevice list. But not
> > > > > the driver name. I thought about also passing the driver name there,
> > > > > but that seemed too limiting to me. I also request regulators there,
> > > > > because before ->bound() the sensor driver, but that could be done
> > > > > on the first call to soc_camera_power_on(), although doing this
> > > > > "first call" thingie is kind of hackish too. I could add one more
> > > > > soc-camera-power helper like soc_camera_prepare() or similar too.
> > > > 
> > > > I think a soc_camera_power_init() function (or similar) would be a
> > > > good idea, yes.
> > > > 
> > > > > So, the main problem is the clock
> > > > > 
> > > > > subdevice name. Also see the comment in soc_camera.c:
> > > > > 	/*
> > > > > 	 * It is ok to keep the clock for the whole soc_camera_device
> > > > > 	 * life-time, in principle it would be more logical to register
> > > > > 	 * the clock on icd creation, the only problem is, that at that
> > > > > 	 * time we don't know the driver name yet.
> > > > > 	 */
> > > > 
> > > > I think we should fix that problem instead of shaping the async API
> > > > around a workaround :-)
> > > > 
> > > > From the subdevice point of view, the probe function should request
> > > > resources, perform whatever initialization is needed (including
> > > > verifying that the hardware is functional when possible), and the
> > > > register the subdev with the code if everything succeeded. Splitting
> > > > registration into bind() and bound() appears a bit as a workaround to
> > > > me.
> > > > 
> > > > If we need a workaround, I'd rather pass the device name in addition
> > > > to the I2C adapter number and address, instead of embedding the
> > > > workaround in this new API.
> > > 
> > > ...or we can change the I2C subdevice name format. The actual need to do
> > > 
> > > 	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
> > > 	
> > > 		 asdl->dev->driver->name,
> > > 		 i2c_adapter_id(client->adapter), client->addr);
> > > 
> > > in soc-camera now to exactly match the subdevice name, as created by
> > > v4l2_i2c_subdev_init(), doesn't make me specifically happy either. What
> > > if the latter changes at some point? Or what if one driver wishes to
> > > create several subdevices for one I2C device?
> > 
> > The common clock framework uses %d-%04x, maybe we could use that as well
> > for clock names ?
> 
> And preserve the subdevice names? Then matching would be more difficult
> and less precise. Or change subdevice names too? I think, we can do the
> latter, since anyway at any time only one driver can be attached to an I2C
> device.

That's right. Where else is the subdev name used ?

> > > > > > > +void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list
> > > > > > > *asdl);
> > > > > > > +#endif

-- 
Regards,

Laurent Pinchart

