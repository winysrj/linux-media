Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45657 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1LKXh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 18:37:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: add convenience macros to the subdevice / Media Controller API
Date: Mon, 12 Dec 2011 00:38:12 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1109291016250.30865@axis700.grange> <201112061149.08271.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1112061216300.10715@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1112061216300.10715@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112120038.13102.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 06 December 2011 13:04:00 Guennadi Liakhovetski wrote:
> On Tue, 6 Dec 2011, Laurent Pinchart wrote:
> > On Tuesday 06 December 2011 09:40:41 Guennadi Liakhovetski wrote:
> > > On Thu, 29 Sep 2011, Laurent Pinchart wrote:
> > > > On Thursday 29 September 2011 10:44:14 Guennadi Liakhovetski wrote:
> > > > > On Thu, 29 Sep 2011, Laurent Pinchart wrote:
> > > > > > On Thursday 29 September 2011 10:18:31 Guennadi Liakhovetski 
wrote:
> > > > > > > Drivers, that can be built and work with and without
> > > > > > > CONFIG_VIDEO_V4L2_SUBDEV_API, need the
> > > > > > > v4l2_subdev_get_try_format() and v4l2_subdev_get_try_crop()
> > > > > > > functions, even though their return value should never be
> > > > > > > dereferenced. Also add convenience macros to init and clean up
> > > > > > > subdevice internal media entities.
> > > > > > 
> > > > > > Why don't you just make the drivers depend on
> > > > > > CONFIG_VIDEO_V4L2_SUBDEV_API ? They don't need to actually export
> > > > > > a device node to userspace, but they require the in-kernel API.
> > > > > 
> > > > > Why? Why should the user build and load all the media controller
> > > > > stuff, buy all the in-kernel objects and code to never actually
> > > > > use it? Where OTOH all is needed to avoid that is a couple of NOP
> > > > > macros?
> > > > 
> > > > Because the automatic compatibility layer that will translate video
> > > > operations to pad operations will need to access pads, so subdevs
> > > > that implement a pad- level API need to export it to the bridge,
> > > > even if the bridge is not MC-aware.
> > > 
> > > I might be missing something, but it seems to me, that if
> > > CONFIG_VIDEO_V4L2_SUBDEV_API is not defined, no pads are exported to
> > > the user space (and you mean a compatibility layer in the user space,
> > > don't you?), so, noone will be able to accesss them.
> > 
> > No, I meant a compatibility layer in kernel space. Basically something
> > like (totally untested)
> 
> Aha, so, a "future" layer.
> 
> > int v4l2_subdev_get_mbus_format(struct v4l2_subdev *sd, struct
> > v4l2_mbus_framefmt *format)
> > {
> > 
> > 	struct v4l2_subdev_format fmt;
> > 	int ret;
> > 	
> > 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, format);
> > 	if (ret != ENOIOCTLCMD)
> 
> you mean "-E..."
> 
> > 		return ret;
> > 	
> > 	fmt.pad = 0;
> > 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > 	fmt.format = *format;
> > 	
> > 	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> > 	if (ret < 0 && ret != ENOIOCTLCMD)
> 
> You, probably, actually mean "if (!ret)"
> 
> > 		*format = fmt.format;
> > 	
> > 	return ret;
> > 
> > }
> > 
> > Or the other way around, trying pad::get_fmt before video::g_mbus_fmt.
> 
> Ok, I understand what you mean now. Any idea when this layer is going to
> be implemented?

As soon as someone needs it and works on it I guess :-) I can give it a try, 
but I'm pretty busy at the moment. Do you have driver(s) that would be good 
test candidates for that ?

-- 
Regards,

Laurent Pinchart
