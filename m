Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:60503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326Ab1FVWSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 18:18:06 -0400
Date: Thu, 23 Jun 2011 00:17:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
In-Reply-To: <201106222353.39567.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1106230009200.3535@axis700.grange>
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange>
 <201106222353.39567.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans

Thanks for the review, agree to all, except one:

On Wed, 22 Jun 2011, Hans Verkuil wrote:

> On Wednesday, June 22, 2011 23:26:29 Guennadi Liakhovetski wrote:

[snip]

> > +static inline unsigned long v4l2_mbus_config_compatible(struct v4l2_mbus_config *cfg,
> > +							unsigned long flags)
> 
> This function is too big to be a static inline. I would also go for a bool return type.
> And cfg should be a const pointer.

return is not just a bool, it's a mask of common flags.

> > +	switch (cfg->type) {
> > +	case V4L2_MBUS_PARALLEL:
> > +		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> > +					V4L2_MBUS_HSYNC_ACTIVE_LOW);
> > +		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
> > +					V4L2_MBUS_VSYNC_ACTIVE_LOW);
> > +		pclk = common_flags & (V4L2_MBUS_PCLK_SAMPLE_RISING |
> > +				       V4L2_MBUS_PCLK_SAMPLE_FALLING);
> > +		data = common_flags & (V4L2_MBUS_DATA_ACTIVE_HIGH |
> > +				       V4L2_MBUS_DATA_ACTIVE_LOW);
> > +		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
> > +		return (!hsync || !vsync || !pclk || !data || !mode) ?
> > +			0 : common_flags;
> > +	case V4L2_MBUS_CSI2:
> > +		mipi_lanes = common_flags & V4L2_MBUS_CSI2_LANES;
> > +		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
> > +					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
> > +		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
> > +	case V4L2_MBUS_BT656:
> > +		/* TODO: implement me */
> 
> Isn't this identical to MBUS_PARALLEL, except that it can ignore the hsync/vsync
> signals? So this case can go in between the 'vsync =' and 'pclk =' lines above.
> (hsync and vsync should be initialized to true of course).

Well, maybe. We could do that or leave it unimplemented until someone 
really uses it.

> > @@ -294,6 +298,8 @@ struct v4l2_subdev_video_ops {
> >  			    struct v4l2_mbus_framefmt *fmt);
> >  	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> >  			  struct v4l2_mbus_framefmt *fmt);
> > +	int (*g_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> > +	int (*s_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> 
> cfg can be a const pointer.

In s_... you mean, not in g_...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
