Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39533 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756891Ab0E0HfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 03:35:21 -0400
Date: Thu, 27 May 2010 09:35:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: Idea of a v4l -> fb interface driver
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E616F05@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1005270905300.2293@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
 <19F8576C6E063C45BE387C64729E7394044E616F05@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 May 2010, Hiremath, Vaibhav wrote:

> > OTOH V4L2 has a standard video output driver support, it is not very
> > widely used, in the userspace I know only of gstreamer, that somehow
> > supports video-output v4l2 devices in latest versions. But, being a part
> > of the v4l2 subsystem, these drivers already now can take a full advantage
> > of all v4l2 APIs, including the v4l2-subdev API for the driver reuse.
> > 
> > So, how can we help graphics driver developers on the one hand by
> > providing them with a capable driver framework (v4l2) and on the other
> > hand by simplifying the task of interfacing to the user-space?
> > 
> [Hiremath, Vaibhav] I think this is really complex question which 
> requires healthy discussion over list.

So, let's do that;)

> > How about a v4l2-output - fbdev translation layer? You write a v4l2-output
> > driver and get a framebuffer device free of charge... TBH, I haven't given
> > this too much of a thought, but so far I don't see anything that would
> > make this impossible in principle. The video buffer management is quite
> > different between the two systems, but maybe we can teach video-output
> > drivers to work with just one buffer too? 
>
> [Hiremath, Vaibhav] I believe V4L2 buf won't limit you to do this. 
> Atleast in case of OMAP v4L2 display driver we are sticking to last 
> buffer if application fails to queue one. So for me this is single 
> buffer keeps on displaying unless application queue next buffer.

Good, so, that's not a problem.

> > Anyway, feel free to tell me why
> > this is an absolutely impossible / impractical idea;)
> > 
> [Hiremath, Vaibhav] If I understanding correctly you are trying to 
> propose something like,
> 
> Without changing Fbdev interface to user space application, create 
> translation layers which will allow driver developer to write driver 
> under V4L2 framework providing /dev/fbx but using V4L2 API/framework.

Exactly.

> Also as mentioned by Jaya, it would be great if you put benefits we are 
> targeting would be helpful.

One of the benefits is the availability the subdevice API, and the 
forthcoming media controller API. I think, on some SoCs graphics 
processing units (scalers, format converters, compressors / decompressors) 
can be configured to either video input or output paths, so, it would make 
sense to manage them from one (v4l) driver framework. And I don't see a 
reason why you cannot have a /dev/fbX interface to the user-space at the 
same time. Yes, you can code it into your v4l driver, and some drivers do 
that already, but why not have it once for all? Last but not lease, having 
multiple incompatible subsystems in the kernel for pretty much the same 
task seems somewhat redundant to me. Yes, I know, this is not a complete 
redundancy, both v4l and fbdev have features, unsupported by the other, 
but IMHO some redundancy is definitely there.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
