Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3AHK1N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 05:27:13 -0500
Date: Tue, 8 Jan 2013 11:26:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice
 registration
In-Reply-To: <13183539.ohZBrHhPax@avalon>
Message-ID: <Pine.LNX.4.64.1301081123590.1794@axis700.grange>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
 <1917427.TMDygJ49eg@avalon> <Pine.LNX.4.64.1301081052100.1794@axis700.grange>
 <13183539.ohZBrHhPax@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 8 Jan 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday 08 January 2013 10:56:43 Guennadi Liakhovetski wrote:
> > On Tue, 8 Jan 2013, Laurent Pinchart wrote:
> > > On Tuesday 08 January 2013 10:25:15 Guennadi Liakhovetski wrote:
> > > > On Tue, 8 Jan 2013, Laurent Pinchart wrote:
> > > > > On Monday 07 January 2013 11:23:55 Guennadi Liakhovetski wrote:
> > > > > > >From 0e1eae338ba898dc25ec60e3dba99e5581edc199 Mon Sep 17 00:00:00
> > > > > > >2001
> > 
> > [snip]
> > 
> > > > > > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > > > > > +				 struct v4l2_async_notifier *notifier);
> > > > > > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier
> > > > > > *notifier);
> > > > > > +/*
> > > > > > + * If subdevice probing fails any time after
> > > > > > v4l2_async_subdev_bind(),
> > > > > > no
> > > > > > + * clean up must be called. This function is only a message of
> > > > > > intention.
> > > > > > + */
> > > > > > +int v4l2_async_subdev_bind(struct v4l2_async_subdev_list *asdl);
> > > > > > +int v4l2_async_subdev_bound(struct v4l2_async_subdev_list *asdl);
> > > > > 
> > > > > Could you please explain why you need both a bind notifier and a bound
> > > > > notifier ? I was expecting a single v4l2_async_subdev_register() call
> > > > > in subdev drivers (and, thinking about it, I would probably name it
> > > > > v4l2_subdev_register()).
> > > > 
> > > > I think I can, yes. Because between .bind() and .bound() the subdevice
> > > > driver does the actual hardware probing. So, .bind() is used to make
> > > > sure the hardware can be accessed, most importantly to provide a clock
> > > > to the subdevice. You can look at soc_camera_async_bind(). There I'm
> > > > registering the clock for the subdevice, about to bind. Why I cannot do
> > > > it before, is because I need subdevice name for clock matching. With I2C
> > > > subdevices the subdevice name contains the name of the driver, adapter
> > > > number and i2c address. The latter 2 I've got from host subdevice list.
> > > > But not the driver name. I thought about also passing the driver name
> > > > there, but that seemed too limiting to me. I also request regulators
> > > > there, because before ->bound() the sensor driver, but that could be
> > > > done on the first call to soc_camera_power_on(), although doing this
> > > > "first call" thingie is kind of hackish too. I could add one more soc-
> > > > camera-power helper like soc_camera_prepare() or similar too.
> > > 
> > > I think a soc_camera_power_init() function (or similar) would be a good
> > > idea, yes.
> > > 
> > > > So, the main problem is the clock
> > > > 
> > > > subdevice name. Also see the comment in soc_camera.c:
> > > > 	/*
> > > > 	 * It is ok to keep the clock for the whole soc_camera_device
> > > > 	 life-time,
> > > > 	 * in principle it would be more logical to register the clock on icd
> > > > 	 * creation, the only problem is, that at that time we don't know the
> > > > 	 * driver name yet.
> > > > 	 */
> > > 
> > > I think we should fix that problem instead of shaping the async API around
> > > a workaround :-)
> > > 
> > > From the subdevice point of view, the probe function should request
> > > resources, perform whatever initialization is needed (including verifying
> > > that the hardware is functional when possible), and the register the
> > > subdev with the code if everything succeeded. Splitting registration into
> > > bind() and bound() appears a bit as a workaround to me.
> > > 
> > > If we need a workaround, I'd rather pass the device name in addition to
> > > the I2C adapter number and address, instead of embedding the workaround in
> > > this new API.
> > 
> > ...or we can change the I2C subdevice name format. The actual need to do
> > 
> > 	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
> > 		 asdl->dev->driver->name,
> > 		 i2c_adapter_id(client->adapter), client->addr);
> > 
> > in soc-camera now to exactly match the subdevice name, as created by
> > v4l2_i2c_subdev_init(), doesn't make me specifically happy either. What if
> > the latter changes at some point? Or what if one driver wishes to create
> > several subdevices for one I2C device?
> 
> The common clock framework uses %d-%04x, maybe we could use that as well for 
> clock names ?

And preserve the subdevice names? Then matching would be more difficult 
and less precise. Or change subdevice names too? I think, we can do the 
latter, since anyway at any time only one driver can be attached to an I2C 
device.

> > > > > > +void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list *asdl);
> > > > > > +#endif

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
