Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38241 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755904AbZKEQ7e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2009 11:59:34 -0500
Date: Thu, 5 Nov 2009 17:59:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH/RFC 9/9 v2] mt9t031: make the use of the soc-camera client
 API optional
In-Reply-To: <200911051657.59303.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0911051753540.5620@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798D56@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0911041703000.4837@axis700.grange> <200911051657.59303.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Nov 2009, Hans Verkuil wrote:

> On Wednesday 04 November 2009 17:49:28 Guennadi Liakhovetski wrote:
> > Now that we have moved most of the functions over to the v4l2-subdev API, only
> > quering and setting bus parameters are still performed using the legacy
> > soc-camera client API. Make the use of this API optional for mt9t031.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > On Mon, 2 Nov 2009, Karicheri, Muralidharan wrote:
> > 
> > > >> >+static struct soc_camera_ops mt9t031_ops = {
> > > >> >+	.set_bus_param		= mt9t031_set_bus_param,
> > > >> >+	.query_bus_param	= mt9t031_query_bus_param,
> > > >> >+	.controls		= mt9t031_controls,
> > > >> >+	.num_controls		= ARRAY_SIZE(mt9t031_controls),
> > > >> >+};
> > > >> >+
> > > >>
> > > >> [MK] Why don't you implement queryctrl ops in core? query_bus_param
> > > >> & set_bus_param() can be implemented as a sub device operation as well
> > > >> right? I think we need to get the bus parameter RFC implemented and
> > > >> this driver could be targeted for it's first use so that we could
> > > >> work together to get it accepted. I didn't get a chance to study your
> > > >> bus image format RFC, but plan to review it soon and to see if it can be
> > > >> used in my platform as well. For use of this driver in our platform,
> > > >> all reference to soc_ must be removed. I am ok if the structure is
> > > >> re-used, but if this driver calls any soc_camera function, it canot
> > > >> be used in my platform.
> > > >
> > > >Why? Some soc-camera functions are just library functions, you just have
> > > >to build soc-camera into your kernel. (also see below)
> > > >
> > > My point is that the control is for the sensor device, so why to implement
> > > queryctrl in SoC camera? Just for this I need to include SOC camera in 
> > > my build? That doesn't make any sense at all. IMHO, queryctrl() 
> > > logically belongs to this sensor driver which can be called from the 
> > > bridge driver using sudev API call. Any reverse dependency from MT9T031 
> > > to SoC camera to be removed if it is to be re-used across other 
> > > platforms. Can we agree on this?
> > 
> > In general I'm sure you understand, that there are lots of functions in 
> > the kernel, that we use in specific modules, not because they interact 
> > with other systems, but because they implement some common functionality 
> > and just reduce code-duplication. And I can well imagine that in many such 
> > cases using just one or a couple of such functions will pull a much larger 
> > pile of unused code with them. But in this case those calls can indeed be 
> > very easily eliminated. Please have a look at the version below.
> 
> I'm not following this, I'm afraid. The sensor drivers should just support
> queryctrl and should use v4l2_ctrl_query_fill() from v4l2-common.c to fill
> in the v4l2_queryctrl struct.

I think, this is unrelated. Muralidharan just complained about the 
soc_camera_find_qctrl() function being used in client subdev drivers, that 
were to be converted to v4l2-subdev, specifically, in mt9t031.c. And I 
just explained, that that's just a pretty trivial library function, that 
does not introduce any restrictions on how that subdev driver can be used 
in non-soc-camera configurations, apart from the need to build and load 
the soc-camera module. In other words, any v4l2-device bridge driver 
should be able to communicate with such a subdev driver, calling that 
function.

> This will also make it easy to convert them to the control framework that I
> am working on.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
