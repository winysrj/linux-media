Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56092 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756167Ab0EKIML (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 04:12:11 -0400
Date: Tue, 11 May 2010 10:12:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera_platform: Add necessary v4l2_subdev_video_ops
 method
In-Reply-To: <uljbqg94r.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1005111009110.6810@axis700.grange>
References: <upr13f0mn.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1005110824330.5923@axis700.grange> <uljbqg94r.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 11 May 2010, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> Thank you for checking patch
> 
> > > +static int soc_camera_platform_s_fmt(struct v4l2_subdev *sd,
> > > +				     struct v4l2_mbus_framefmt *mf)
> > > +{
> > > +	return 0;
> > 
> > This function needs not only return 0, but also fill fmt with the current 
> > pixel format.
> 
> sorry.
> Does this "fill" mean "fill mf->xxxx" ?
> 
> mf->code = xxxx;
> mf->colorspace = xxx;

Exactly, sorry for being unclear.

> > >  static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
> > >  	.s_stream	= soc_camera_platform_s_stream,
> > >  	.try_mbus_fmt	= soc_camera_platform_try_fmt,
> > >  	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
> > > +	.cropcap	= soc_camera_platform_cropcap,
> > > +	.g_crop		= soc_camera_platform_g_crop,
> > > +	.g_mbus_fmt	= soc_camera_platform_try_fmt,
> > > +	.s_mbus_fmt	= soc_camera_platform_s_fmt,
> > 
> > Wouldn't
> > 
> > +	.s_mbus_fmt	= soc_camera_platform_try_fmt,
> > 
> > work here as well?
> 
> g_mbus_fmt / try_mbus_fmt are using same argument,
> and in this driver, it needs same operation I think.
> (same operation mean it fill mf->xxxx)
> But should I modify it ?

My expectation is, that you don't need to modify anything, just 
soc_camera_platform_try_fmt() for all three methods: .try_mbus_fmt, 
.g_mbus_fmt and .s_mbus_fmt. Please, verify, whether or not I am right.

> int (*g_mbus_fmt)(struct v4l2_subdev *sd,  struct v4l2_mbus_framefmt *fmt);
> int (*try_mbus_fmt)(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
