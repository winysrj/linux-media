Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45815 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756381AbZKJO2g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 09:28:36 -0500
Date: Tue, 10 Nov 2009 15:28:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH/RFC 7/9 v2] v4l: add an image-bus API for configuring
 v4l2 subdev pixel and frame formats
In-Reply-To: <200911101451.08451.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0911101511270.5074@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301438500.4378@axis700.grange>
 <200911101451.08451.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Nov 2009, Laurent Pinchart wrote:

> On Friday 30 October 2009 15:01:27 Guennadi Liakhovetski wrote:
> > Video subdevices, like cameras, decoders, connect to video bridges over
> > specialised busses. Data is being transferred over these busses in various
> > formats, which only loosely correspond to fourcc codes, describing how
> >  video data is stored in RAM. This is not a one-to-one correspondence,
> >  therefore we cannot use fourcc codes to configure subdevice output data
> >  formats. This patch adds codes for several such on-the-bus formats and an
> >  API, similar to the familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt()
> >  API for configuring those codes. After all users of the old API in struct
> >  v4l2_subdev_video_ops are converted, the API will be removed.
> 
> [snip]
> 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 04193eb..1e86f39 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> 
> [snip]
> 
> > @@ -206,6 +207,8 @@ struct v4l2_subdev_audio_ops {
> > 
> >     s_routing: see s_routing in audio_ops, except this version is for video
> >  	devices.
> > +
> > +   enum_imgbus_fmt: enumerate pixel formats provided by a video data
> 
> Do we need to make that dynamic (and O(n)) or could we use a static array of 
> image bug frame formats ?

The current soc-camera uses a static array. It works for its users, but I 
do not know about others.

> >  source */
> >  struct v4l2_subdev_video_ops {
> >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> >  config); @@ -227,6 +230,11 @@ struct v4l2_subdev_video_ops {
> >  	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
> >  	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> >  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> > +	int (*enum_imgbus_fmt)(struct v4l2_subdev *sd, int index,
> > +			       enum v4l2_imgbus_pixelcode *code);
> > +	int (*g_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt
> >  *fmt);
> > +	int (*try_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt
> >  *fmt);
> > +	int (*s_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt
> > *fmt); };
> 
> Obviously those calls will need to be moved to pad operations later.

Right.

> They will 
> be exposed to userspace through ioctls on the media controller device and/or 
> the subdevices, so the v4l2_imgbus_pixelcode type shouldn't be an enum.

Ok, will use __u32 for it then just as all other enum types...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
