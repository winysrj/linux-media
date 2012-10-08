Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2JHQBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 12:01:01 -0400
Date: Mon, 8 Oct 2012 18:00:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
In-Reply-To: <Pine.LNX.4.64.1210081748390.14454@axis700.grange>
Message-ID: <Pine.LNX.4.64.1210081758280.14454@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <201210081653.55984.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210081708240.14454@axis700.grange>
 <201210081741.43546.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210081748390.14454@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Oct 2012, Guennadi Liakhovetski wrote:

> On Mon, 8 Oct 2012, Hans Verkuil wrote:
> 
> > On Mon October 8 2012 17:15:53 Guennadi Liakhovetski wrote:

[snip]

> > > No, I don't think there is a way to get a device pointer from a DT node.
> > 
> > Not a device pointer, but the i2c bus and i2c address. With that information
> > you can get the i2c_client, and with that you can get the subdev pointer.
> 
> How? How can you get a client pointer from adapter and i2c device address? 
> I haven't found anything suitable in i2c.h.

Ok, you could use of_find_i2c_device_by_node(), but the second argument 
remains - if you need notifiers in one case, I don't think it makes sense 
to implement multiple methods.

Thanks
Guennadi

> > If there is no way to get that information from the proposed V4L2 DT, then
> > it needs to be modified since a bridge driver really needs to know which
> > subdevs it has to register with the v4l2_device struct. That information is
> > also board specific so it should be part of the DT.
> > 
> > > 
> > > > In my view you cannot do a proper initialization unless you have both the
> > > > bridge driver and all subdev drivers loaded and instantiated. They need one
> > > > another. So I am perfectly fine with letting the probe function do next to
> > > > nothing and postponing that until register() is called. I2C and actual probing
> > > > to check if it's the right device is a bad idea in general since you have no
> > > > idea what a hardware access to an unknown i2c device will do. There are still
> > > > some corner cases where that is needed, but I do not think that that is an
> > > > issue here.
> > > > 
> > > > It would simplify things a lot IMHO. Also note that the register() op will
> > > > work with any device, not just i2c. That may be a useful property as well.
> > > 
> > > And what if the subdevice device is not yet instantiated by OF by the time 
> > > your bridge driver probes?
> > 
> > That is where you still need to have a bus notifier mechanism. You have to be
> > able to wait until all dependent drivers are loaded/instantiated,
> 
> No, drivers are not the problem, as you say, you can load them. Devices 
> are the problem. You don't know when they will be registered.
> 
> > or
> > alternatively you have to be able to load them explicitly. But this should
> > be relatively easy to implement in a generic manner.
> 
> So, if you need notifiers anyway, why not use them in all cases instead of 
> mixing multiple methods?
> 
> Thanks
> Guennadi
> 
> > I still think this sucks (excuse my language), but I see no way around it as
> > long as there is no explicit probe order one can rely on.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
