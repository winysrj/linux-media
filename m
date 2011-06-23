Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:57497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1FWWfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 18:35:16 -0400
Date: Fri, 24 Jun 2011 00:35:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
In-Reply-To: <20110623220129.GA10918@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1106240021540.5348@axis700.grange>
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange>
 <20110623220129.GA10918@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari

On Fri, 24 Jun 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> Thanks for the patch. I have a few comments below.
> 
> On Wed, Jun 22, 2011 at 11:26:29PM +0200, Guennadi Liakhovetski wrote:
> > Add media bus configuration types and two subdev operations to get
> > supported mediabus configurations and to set a specific configuration.
> > Subdevs can support several configurations, e.g., they can send video data
> > on 1 or several lanes, can be configured to use a specific CSI-2 channel,
> > in such cases subdevice drivers return bitmasks with all respective bits
> > set. When a set-configuration operation is called, it has to specify a
> > non-ambiguous configuration.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > v2:
> > 
> > 1. Removed parallel bus width flags. As Laurent correctly pointed out, bus 
> > width can be configured based on the mediabus format.
> > 
> > 2. Removed the clock parameter for now. Passing timing information between 
> > the subdevices and the host / bridge driver is indeed necessary, but it is 
> > not yet quite clear, what is the best way to do this. This requires more 
> > thinking and can be added as an extra field to struct v4l2_mbus_config 
> > later. The argument, that "struct clk" is still platform specific is 
> > correct, but I am too tempted by the possibilities, the clkdev offers us 
> > to give up this idea immediatrely. Maybe drivers, that need such a clock, 
> > could use a platform callback to create a clock instance for them, or get 
> > a clock object from the platform with platform data. However, there are 
> > also opinions, that the clkdev API is completely unsuitable for this 
> > purpose. I'd commit this without any timing first, and consider 
> > possibilities as a second step.
> > 
> >  include/media/v4l2-mediabus.h |   89 +++++++++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-subdev.h   |    6 +++
> >  2 files changed, 95 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> > index 971c7fa..e0ffba0 100644
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -13,6 +13,95 @@
> >  
> >  #include <linux/v4l2-mediabus.h>
> >  
> > +/* Parallel flags */
> > +/* Can the client run in master or in slave mode */
> > +#define V4L2_MBUS_MASTER			(1 << 0)
> > +#define V4L2_MBUS_SLAVE				(1 << 1)
> 
> What are master and slave in this case? Something other than transmitter and
> receiver?

No, these are master and slave modes of a parallel camera connection. In 
the master mode the client (sensor) is providing the pixel clock, in the 
slave mode the bridge is "clocking" data out of the client. In my 
experience, the slave mode is rarely used, but many camera sensors and 
some SoC host interfaces still support it.

> 
> > +/* Which signal polarities it supports */
> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
> > +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
> > +
> > +/* Serial flags */
> > +/* How many lanes the client can use */
> > +#define V4L2_MBUS_CSI2_1_LANE			(1 << 0)
> > +#define V4L2_MBUS_CSI2_2_LANE			(1 << 1)
> > +#define V4L2_MBUS_CSI2_3_LANE			(1 << 2)
> > +#define V4L2_MBUS_CSI2_4_LANE			(1 << 3)
> > +/* On which channels it can send video data */
> > +#define V4L2_MBUS_CSI2_CHANNEL_0		(1 << 4)
> > +#define V4L2_MBUS_CSI2_CHANNEL_1		(1 << 5)
> > +#define V4L2_MBUS_CSI2_CHANNEL_2		(1 << 6)
> > +#define V4L2_MBUS_CSI2_CHANNEL_3		(1 << 7)
> 
> It might not be just video data but e.g. metadata.
> 
> Is four the maximum number of channels in CSI2?

Yes.

> > +/* Does it support only continuous or also non-continuous clock mode */
> > +#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		(1 << 8)
> > +#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	(1 << 9)
> 
> What's noncontinuous clock for CSI2? Does it mean in some situations the
> clock may be stopped based on certain criteria?

It's when the clock lane is idle in certain intervals. See the 
specification for details. In any case, say, if the sensor supports both 
clock modes, and the bridge only supports the compulsory continuous mode, 
the optional non-continuous mode will not work.

> > +#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
> > +					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
> > +#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
> > +					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
> > +
> > +/**
> > + * v4l2_mbus_type - media bus type
> > + * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
> > + * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation
> > + * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
> > + */
> > +enum v4l2_mbus_type {
> > +	V4L2_MBUS_PARALLEL,
> > +	V4L2_MBUS_BT656,
> > +	V4L2_MBUS_CSI2,
> > +};
> > +
> > +/**
> > + * v4l2_mbus_config - media bus configuration
> > + * @type:	in: interface type
> > + * @flags:	in / out: configuration flags, depending on @type
> > + */
> > +struct v4l2_mbus_config {
> > +	enum v4l2_mbus_type type;
> > +	unsigned long flags;
> > +};
> > +
> > +static inline unsigned long v4l2_mbus_config_compatible(struct v4l2_mbus_config *cfg,
> > +							unsigned long flags)
> > +{
> > +	unsigned long common_flags, hsync, vsync, pclk, data, mode;
> > +	unsigned long mipi_lanes, mipi_clock;
> > +
> > +	common_flags = cfg->flags & flags;
> > +
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
> > +		return 0;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
> >  				const struct v4l2_mbus_framefmt *mbus_fmt)
> >  {
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 1562c4f..75919ef 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -255,6 +255,10 @@ struct v4l2_subdev_audio_ops {
> >     try_mbus_fmt: try to set a pixel format on a video data source
> >  
> >     s_mbus_fmt: set a pixel format on a video data source
> > +
> > +   g_mbus_config: get supported mediabus configurations
> > +
> > +   s_mbus_config: set a certain mediabus configuration
> >   */
> >  struct v4l2_subdev_video_ops {
> >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> > @@ -294,6 +298,8 @@ struct v4l2_subdev_video_ops {
> >  			    struct v4l2_mbus_framefmt *fmt);
> >  	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> >  			  struct v4l2_mbus_framefmt *fmt);
> > +	int (*g_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> > +	int (*s_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> 
> How would the ops be used and by whom?

In the first line I want to use them to make re-use of soc-camera and 
other subdev drivers possible. Soc-camera drivers would switch to these 
from their specific bus-configuration methods, other drivers are free to 
use or not to use them.

> How complete configuration for CSI2 bus is the above intend to be? Complete,
> I suppose, and so I think we'll also need to specify how e.g. the CSI2 clock
> and data lanes have been connected between transmitter and receiver. This is
> less trivial to guess than clock polarity and requires further information
> from the board and lane mapping configuration capabilities of both.
> Shouldn't this information be also added to CSI2 configuration?
> 
> Do you think a single bitmask would suffice for this in the long run?

If you have certain additions to this API I would be happy to consider 
them. Otherwise, if you just suppose, that we might need more 
configuration options, we can always add them in the future, when we know 
more about them and have specific use-cases, with which we can test them. 
E.g., I am not sure what data- and clock-lane connection possibilities you 
refer to above. Don't you _have_ to connect lane 1 to 1 etc?

> I can see some use for the information in the set operation in lane
> configuration, for example, as you mentioned. My guess would be that the
> number of lanes _might_ be something that the user space would want to know
> or possibly even configure --- but we'll first need to discuss low-level
> sensor control interface.
> 
> But otherwise the configuration should likely be rather static and board
> specific. Wouldn't the subdevs get this as part of the platform data, or
> how?
> 
> I would just keep the bus configuration static board dependent information
> until we have that part working and used by drivers and extend it later on.

As I said, drivers are free to not use these methods and implement a 
platform-provided configuration method. In which case, as, I think, Hans 
pointed out earlier, they can also choose to use this struct in their 
platform data.

> 
> Just my 0,05 euros.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
