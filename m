Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269Ab1LFMEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 07:04:04 -0500
Date: Tue, 6 Dec 2011 13:04:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: add convenience macros to the subdevice / Media
 Controller API
In-Reply-To: <201112061149.08271.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1112061216300.10715@axis700.grange>
References: <Pine.LNX.4.64.1109291016250.30865@axis700.grange>
 <201109291311.37133.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112060932040.10715@axis700.grange>
 <201112061149.08271.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Dec 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday 06 December 2011 09:40:41 Guennadi Liakhovetski wrote:
> > On Thu, 29 Sep 2011, Laurent Pinchart wrote:
> > > On Thursday 29 September 2011 10:44:14 Guennadi Liakhovetski wrote:
> > > > On Thu, 29 Sep 2011, Laurent Pinchart wrote:
> > > > > On Thursday 29 September 2011 10:18:31 Guennadi Liakhovetski wrote:
> > > > > > Drivers, that can be built and work with and without
> > > > > > CONFIG_VIDEO_V4L2_SUBDEV_API, need the v4l2_subdev_get_try_format()
> > > > > > and v4l2_subdev_get_try_crop() functions, even though their return
> > > > > > value should never be dereferenced. Also add convenience macros to
> > > > > > init and clean up subdevice internal media entities.
> > > > > 
> > > > > Why don't you just make the drivers depend on
> > > > > CONFIG_VIDEO_V4L2_SUBDEV_API ? They don't need to actually export a
> > > > > device node to userspace, but they require the in-kernel API.
> > > > 
> > > > Why? Why should the user build and load all the media controller stuff,
> > > > buy all the in-kernel objects and code to never actually use it? Where
> > > > OTOH all is needed to avoid that is a couple of NOP macros?
> > > 
> > > Because the automatic compatibility layer that will translate video
> > > operations to pad operations will need to access pads, so subdevs that
> > > implement a pad- level API need to export it to the bridge, even if the
> > > bridge is not MC-aware.
> > 
> > I might be missing something, but it seems to me, that if
> > CONFIG_VIDEO_V4L2_SUBDEV_API is not defined, no pads are exported to the
> > user space (and you mean a compatibility layer in the user space, don't
> > you?), so, noone will be able to accesss them.
> 
> No, I meant a compatibility layer in kernel space. Basically something like 
> (totally untested)

Aha, so, a "future" layer.

> int v4l2_subdev_get_mbus_format(struct v4l2_subdev *sd, struct 
> v4l2_mbus_framefmt *format)
> {
> 	struct v4l2_subdev_format fmt;
> 	int ret;
> 
> 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, format);
> 	if (ret != ENOIOCTLCMD)

you mean "-E..."

> 		return ret;
> 
> 	fmt.pad = 0;
> 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> 	fmt.format = *format;
> 
> 	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> 	if (ret < 0 && ret != ENOIOCTLCMD)

You, probably, actually mean "if (!ret)"

> 		*format = fmt.format;
> 
> 	return ret;
> }
> 
> Or the other way around, trying pad::get_fmt before video::g_mbus_fmt.

Ok, I understand what you mean now. Any idea when this layer is going to 
be implemented?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
