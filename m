Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40785 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1FHQoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 12:44:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] V4L: add media bus configuration subdev operations
Date: Wed, 8 Jun 2011 18:42:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1106061358310.11169@axis700.grange> <201106071725.32948.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106071725.32948.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106081842.17240.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Replying to myself, after a chat with Guennadi.

On Tuesday 07 June 2011 17:25:32 Laurent Pinchart wrote:
> On Monday 06 June 2011 14:31:57 Guennadi Liakhovetski wrote:
> > Add media bus configuration types and two subdev operations to get
> > supported mediabus configurations and to set a specific configuration.
> > Subdevs can support several configurations, e.g., they can send video
> > data on 1 or several lanes, can be configured to use a specific CSI-2
> > channel, in such cases subdevice drivers return bitmasks with all
> > respective bits set. When a set-configuration operation is called, it
> > has to specify a non-ambiguous configuration.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This change would allow a re-use of soc-camera and "standard" subdev
> > drivers. It is a modified and extended version of
> > 
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/2
> > 94 08
> > 
> > therefore the original Sob. After this we only would have to switch to
> > the control framework:) Please, comment.
> 
> I still believe we shouldn't use any set operation :-) The host/bridge
> driver should just use the get operation before starting the stream to
> configure it's sensor interface.

I can be convinced to accept a set mbus config operation to allow existing 
soc-camera drivers to be ported to the new API without requiring hardcoding 
all the related configurations in board code in one go. However, I'm still not 
convinced that we should allow new drivers to use the set operation, which 
should in my (current) opinion be temporary only.

I will try this patch with an OMAP3 platform that uses CSI2 sensors and check 
whether the features I require are present.

> > diff --git a/include/media/v4l2-mediabus.h
> > b/include/media/v4l2-mediabus.h index 971c7fa..0983b7b 100644
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -13,6 +13,76 @@
> > 
> >  #include <linux/v4l2-mediabus.h>
> > 
> > +/* Parallel flags */
> > +/* Can the client run in master or in slave mode */
> > +#define V4L2_MBUS_MASTER			(1 << 0)
> > +#define V4L2_MBUS_SLAVE				(1 << 1)
> > +/* Which signal polarities it supports */
> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
> > +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
> > +/* Which datawidths are supported */
> > +#define V4L2_MBUS_DATAWIDTH_4			(1 << 10)
> > +#define V4L2_MBUS_DATAWIDTH_8			(1 << 11)
> > +#define V4L2_MBUS_DATAWIDTH_9			(1 << 12)
> > +#define V4L2_MBUS_DATAWIDTH_10			(1 << 13)
> > +#define V4L2_MBUS_DATAWIDTH_15			(1 << 14)
> > +#define V4L2_MBUS_DATAWIDTH_16			(1 << 15)
> > +
> > +#define V4L2_MBUS_DATAWIDTH_MASK	(V4L2_MBUS_DATAWIDTH_4 |
> > V4L2_MBUS_DATAWIDTH_8 | \ +					 V4L2_MBUS_DATAWIDTH_9 |
> > V4L2_MBUS_DATAWIDTH_10 | \
> > +					 V4L2_MBUS_DATAWIDTH_15 | V4L2_MBUS_DATAWIDTH_16)
> 
> The mbus data width is selected by the mbus format. Why do we need an
> explicit width here ?

This comment still holds.

> > +/* Serial flags */
> > +/* How many lanes the client can use */
> > +#define V4L2_MBUS_CSI2_1_LANE			(1 << 0)
> > +#define V4L2_MBUS_CSI2_2_LANE			(1 << 1)
> > +#define V4L2_MBUS_CSI2_3_LANE			(1 << 2)
> > +#define V4L2_MBUS_CSI2_4_LANE			(1 << 3)
> > +/* On which channels it can send video data */
> > +#define V4L2_MBUS_CSI2_CHANNEL_0			(1 << 4)
> > +#define V4L2_MBUS_CSI2_CHANNEL_1			(1 << 5)
> > +#define V4L2_MBUS_CSI2_CHANNEL_2			(1 << 6)
> > +#define V4L2_MBUS_CSI2_CHANNEL_3			(1 << 7)
> > +/* Does it support only continuous or also non-contimuous clock mode */
> > +#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		(1 << 8)
> > +#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	(1 << 9)
> > +
> > +#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE |
> > V4L2_MBUS_CSI2_2_LANE | \ +					 V4L2_MBUS_CSI2_3_LANE |
> > V4L2_MBUS_CSI2_4_LANE)
> > +#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 |
> > V4L2_MBUS_CSI2_CHANNEL_1 | \ +					 V4L2_MBUS_CSI2_CHANNEL_2 |
> > V4L2_MBUS_CSI2_CHANNEL_3)
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
> > + * @type:	interface type
> > + * @flags:	configuration flags, depending on @type
> > + * @clk:	output clock, the bridge driver can try to use 
clk_set_parent()
> > + *		to specify the master clock to the client
> > + */
> > +struct v4l2_mbus_config {
> > +	enum v4l2_mbus_type type;
> > +	unsigned long flags;
> > +	struct clk *clk;
> > +};
> 
> struct clk is being generalized as part of the ARM clock consolidation
> work, but we're not there yet. I don't think we can use it yet.

And this one as well. There's no system-wide struct clk at the moment.

> > +
> > 
> >  static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
> >  
> >  				const struct v4l2_mbus_framefmt *mbus_fmt)
> >  
> >  {
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 1562c4f..6ea25f4 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -255,6 +255,10 @@ struct v4l2_subdev_audio_ops {
> > 
> >     try_mbus_fmt: try to set a pixel format on a video data source
> >     
> >     s_mbus_fmt: set a pixel format on a video data source
> > 
> > +
> > +   g_mbus_param: get supported mediabus configurations
> > +
> > +   s_mbus_param: set a certain mediabus configuration
> > 
> >   */
> >  
> >  struct v4l2_subdev_video_ops {
> >  
> >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> > 
> > config); @@ -294,6 +298,8 @@ struct v4l2_subdev_video_ops {
> > 
> >  			    struct v4l2_mbus_framefmt *fmt);
> >  	
> >  	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> >  	
> >  			  struct v4l2_mbus_framefmt *fmt);
> > 
> > +	int (*g_mbus_param)(struct v4l2_subdev *sd, struct v4l2_mbus_config
> > *cfg); +	int (*s_mbus_param)(struct v4l2_subdev *sd, struct
> > v4l2_mbus_config *cfg); };
> > 
> >  /*

-- 
Regards,

Laurent Pinchart
