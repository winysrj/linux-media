Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:60756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525Ab1FFWnY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 18:43:24 -0400
Date: Tue, 7 Jun 2011 00:43:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC] V4L: add media bus configuration subdev operations
In-Reply-To: <4DED4655.2080607@gmail.com>
Message-ID: <Pine.LNX.4.64.1106070028360.18603@axis700.grange>
References: <Pine.LNX.4.64.1106061358310.11169@axis700.grange>
 <4DED4655.2080607@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 6 Jun 2011, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 06/06/2011 02:31 PM, Guennadi Liakhovetski wrote:
> > Add media bus configuration types and two subdev operations to get
> > supported mediabus configurations and to set a specific configuration.
> > Subdevs can support several configurations, e.g., they can send video data
> > on 1 or several lanes, can be configured to use a specific CSI-2 channel,
> > in such cases subdevice drivers return bitmasks with all respective bits
> > set. When a set-configuration operation is called, it has to specify a
> > non-ambiguous configuration.
> > 
> > Signed-off-by: Stanimir Varbanov<svarbanov@mm-sol.com>
> > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > ---
> > 
> > This change would allow a re-use of soc-camera and "standard" subdev
> > drivers. It is a modified and extended version of
> > 
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/29408
> > 
> > therefore the original Sob. After this we only would have to switch to the
> > control framework:) Please, comment.
> > 
> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> > index 971c7fa..0983b7b 100644
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -13,6 +13,76 @@
> > 
> >   #include<linux/v4l2-mediabus.h>
> > 
> > +/* Parallel flags */
> > +/* Can the client run in master or in slave mode */
> > +#define V4L2_MBUS_MASTER			(1<<  0)
> > +#define V4L2_MBUS_SLAVE				(1<<  1)
> > +/* Which signal polarities it supports */
> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1<<  2)
> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1<<  3)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1<<  4)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1<<  5)
> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1<<  6)
> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1<<  7)
> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1<<  8)
> > +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1<<  9)
> > +/* Which datawidths are supported */
> > +#define V4L2_MBUS_DATAWIDTH_4			(1<<  10)
> > +#define V4L2_MBUS_DATAWIDTH_8			(1<<  11)
> > +#define V4L2_MBUS_DATAWIDTH_9			(1<<  12)
> > +#define V4L2_MBUS_DATAWIDTH_10			(1<<  13)
> > +#define V4L2_MBUS_DATAWIDTH_15			(1<<  14)
> > +#define V4L2_MBUS_DATAWIDTH_16			(1<<  15)
> > +
> > +#define V4L2_MBUS_DATAWIDTH_MASK	(V4L2_MBUS_DATAWIDTH_4 | V4L2_MBUS_DATAWIDTH_8 | \
> > +					 V4L2_MBUS_DATAWIDTH_9 | V4L2_MBUS_DATAWIDTH_10 | \
> > +					 V4L2_MBUS_DATAWIDTH_15 | V4L2_MBUS_DATAWIDTH_16)
> > +
> > +/* Serial flags */
> > +/* How many lanes the client can use */
> > +#define V4L2_MBUS_CSI2_1_LANE			(1<<  0)
> > +#define V4L2_MBUS_CSI2_2_LANE			(1<<  1)
> > +#define V4L2_MBUS_CSI2_3_LANE			(1<<  2)
> > +#define V4L2_MBUS_CSI2_4_LANE			(1<<  3)
> > +/* On which channels it can send video data */
> > +#define V4L2_MBUS_CSI2_CHANNEL_0			(1<<  4)
> > +#define V4L2_MBUS_CSI2_CHANNEL_1			(1<<  5)
> > +#define V4L2_MBUS_CSI2_CHANNEL_2			(1<<  6)
> > +#define V4L2_MBUS_CSI2_CHANNEL_3			(1<<  7)
> > +/* Does it support only continuous or also non-contimuous clock mode */
> > +#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		(1<<  8)
> > +#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	(1<<  9)
> > +
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
> > + * @type:	interface type
> > + * @flags:	configuration flags, depending on @type
> > + * @clk:	output clock, the bridge driver can try to use clk_set_parent()
> > + *		to specify the master clock to the client
> > + */
> > +struct v4l2_mbus_config {
> > +	enum v4l2_mbus_type type;
> > +	unsigned long flags;
> > +	struct clk *clk;
> 
> This clock is interesting, however it is not quite clear to me 
> what was your original idea on how it should be used.
> Is it supposed to be managed by the bridge drivers only?
> 
> Or is it intended to be gated by subdev drivers with the clock API?
> 
> I think embedding struct clk here might be a good solution to pass
> clock frequency information around the host and subdev drivers
> (e.g. to mitigate the rounding errors).
> 
> Still the host drivers would individually need to be provided
> by the board code with clock frequency information per each subdev.
> But as the clock usually needs to be enabled before registering a subdev
> it does not seem to make sense to include the frequency information
> in struct v4l2_mbus_config.
> Sensors could just use clk_get_rate() to figure out what is their master
> clock rate.

The idea to include a pointer to struct clk originates from various 
clocking related fields from the original patch by Stanimir. However, I 
decided, that that was too unflixible and decided to use the clock API to 
handle the pixel clock in "advanced" cases. In simple cases this pointer 
can stay NULL and the bridge / host driver will have no information about 
the pixel clock frequency. It will just rely on clock actually running and 
will obtain data as fast as it arrives. This is also what many soc-camera 
host drivers are currently doing. In more complex cases the subdev would 
register a clock device during probing, using its platform data to decide 
upon the frequency and the parent(s). Later, having retrieved the bus 
configuration from the subdevice, the bridge will see a clock, then it can 
_try_ to reparent it to its own master clock - if desired, if needed, it 
can use the clock API to set and get the clock frequency. This scheme 
should pretty well cover both simple cases, where the master clock is used 
1-to-1 for the pixel clock, and complex cases, where the subdev includes 
programmable PLLs and dividers, and where the board includes logic to 
select one of several possible sources for the camera clock. This clock 
can also be bound into the runtime PM subsystem, if desired.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
