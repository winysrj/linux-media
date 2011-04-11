Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1DKM3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:29:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: mt9t111 sensor on Beagleboard xM
Date: Mon, 11 Apr 2011 14:29:41 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com> <201104111330.40504.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1104111352420.18511@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104111352420.18511@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104111429.41938.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Monday 11 April 2011 14:16:49 Guennadi Liakhovetski wrote:
> On Mon, 11 Apr 2011, Laurent Pinchart wrote:
> > On Monday 11 April 2011 11:11:06 javier Martin wrote:
> > > > Adding pad-level operations will not break any existing driver, as
> > > > long as you keep the existing operations functional.
> > > 
> > > Is it really possible to have a sensor driver supporting soc-camera,
> > > v4l2-subdev and pad-level operations?
> > 
> > Probably. Guennadi should be able to help you some more with that, he's
> > the soc-camera expert.
> 
> I'm afraid, I'm not sufficiently familiar with the (current state of)
> pad-level ops:-)
> 
> I don't think, it is a very good idea to support two APIs in sensor drivers:
> pad-level for reuse with ISP and other compatible drivers and subdev / soc-
> camera for soc-camera hosts.
> 
> I've tried pad-level ops as I played with the beagleboard-xM and an mt9p031
> camera module. At that time to use the OMAP3 camera framework you had to use
> MC-aware applications. Standard V4L2 applications had no chance. I am not
> sure, whether this is a limitation of the ISP implementation or of the MC /
> pad APIs themselves.

It's a limitation of the OMAP3 ISP driver. Pad-level operations are very 
similar to the mbus format operations, with the major difference being that 
they take an additional pad number argument.

> If this is still the case and if this backwards-compatible V4L2 mode is
> indeed difficult to implement with MC / pad, then soc-camera cannot migrate
> to that API atm.

It's not a compatibility mode per se. The V4L2 API is implemented by the 
bridge driver, no the subdevs. The bridge driver will call subdev ops. In the 
OMAP3 ISP case, those subdev ops must be called by userspace, but that's 
specific to the OMAP3 ISP.

> 
> So, ideally, what should happen, I think, is the following:
> 
> 1. we make sure, that the new APIs seamlessly support a "classic V4L2"
> fallback mode.

The "old" API is

        int (*g_mbus_fmt)(struct v4l2_subdev *sd,
                          struct v4l2_mbus_framefmt *fmt);
        int (*try_mbus_fmt)(struct v4l2_subdev *sd,
                            struct v4l2_mbus_framefmt *fmt);
        int (*s_mbus_fmt)(struct v4l2_subdev *sd,
                          struct v4l2_mbus_framefmt *fmt);

The corresponding pad-level API is

        int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
                       struct v4l2_subdev_format *format);
        int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
                       struct v4l2_subdev_format *format);

struct v4l2_subdev_format is defined as

struct v4l2_subdev_format {
        __u32 which;
        __u32 pad;
        struct v4l2_mbus_framefmt format;
        __u32 reserved[8];
};

g_mbus_fmt(fmt) and s_mbus_fmt(fmt) calls are thus translated to get_fmt(NULL, 
{V4L2_SUBDEV_FORMAT_ACTIVE, 0, fmt}) and set_fmt(NULL, 
{V4L2_SUBDEV_FORMAT_ACTIVE, 0, fmt}). It's quite straightforward.

try_mbus_fmt(fmt) is translated to set_fmt(fh, {V4L2_SUBDEV_FORMAT_TRY, 0, 
fmt}), but the issue is that we have no file handle. We need to decide on the 
best option (pass a fake fh, support it explicitly in sensor drivers, ...).

> 2. migrate (respective parts of) soc-camera to pad-level
> 
> 3. enable driver reuse, for which, I think, two more things will have to
> be done: (a) create and switch to a unified way to pass driver platform
> data to subdev drivers (soc-camera is currently using struct
> soc_camera_link for this), (b) solve the bus configuration problem.

Those two steps are independent of each other, and independent of 1. and 2., 
so we could start working on them now.

> > > I've been reviewing the code of mt9t112 and I'm not very sure
> > > soc-camera code can be easily isolated.
> > > 
> > > What is the future of soc-camera anyway? Since it seems v4l2-subdev and
> > > media-controller clearly make it deprecated.
> > 
> > My understanding is that soc-camera will stay, but sensor drivers will
> > likely not depend on soc-camera anymore. soc-camera will use pad-level
> > operations, as well as a bus configuration ioctl that has been proposed
> > on the list (but not finalized yet). Guennadi, can you share some
> > information about this ?
> 
> We want to reuse sensor drivers, yes:-)
> 
> > > Wouldn't it be more suitable to just develop a separate mt9t112 driver
> > > which includes v4l2-subdev and pad-level operations without soc-camera?
> > 
> > I don't think duplicate drivers will be accepted for mainline.
> 
> +1

-- 
Regards,

Laurent Pinchart
