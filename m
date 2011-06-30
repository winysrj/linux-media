Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:61892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3WmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 18:42:14 -0400
Date: Fri, 1 Jul 2011 00:42:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC v4] V4L: add media bus configuration subdev operations
In-Reply-To: <4E0CEFEB.2080005@gmail.com>
Message-ID: <Pine.LNX.4.64.1107010036390.20437@axis700.grange>
References: <Pine.LNX.4.64.1106291819520.12577@axis700.grange>
 <4E0CEFEB.2080005@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 30 Jun 2011, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 06/29/2011 06:27 PM, Guennadi Liakhovetski wrote:
> > Add media bus configuration types and two subdev operations to get
> > supported mediabus configurations and to set a specific configuration.
> > Subdevs can support several configurations, e.g., they can send video data
> > on 1 or several lanes, can be configured to use a specific CSI-2 channel,
> > in such cases subdevice drivers return bitmasks with all respective bits
> > set. When a set-configuration operation is called, a non-ambiguous
> > configuration has to be specified.
> > 
> > Signed-off-by: Stanimir Varbanov<svarbanov@mm-sol.com>
> > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > ---
> > 
> > v4: more comments by Hans:
> > 
> > 1. one more variable type to unsigned int
> > 
> > 2. master mode clarified
> > 
> > 3. switch-case fall-through commented
> > 
> > 4. more BT.656, BT.1120 commenting
> > 
> > 5. .s_mbus_config() marked as soc-camera compatibility
> > 
> > v3: addressed comments by Hans - thanks!
> > 
> > 1. moved too big inline function into a new .c file
> > 
> > 2. changed flags types to int, local variables to bool, added "const"
> > 
> > 3. accepting BT.656 now too
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
> 
> Doesn't sound like a good idea to me to be passing clock pointers in platform
> data (if that's what you mean) or adding additional callbacks there. 
> Would such callback be implemented in a board setup file, which are
> being phased out in favour of the device tree?

As you see, the clock pointer has been removed in v2. We'll see if and 
when we need it.

> > also opinions, that the clkdev API is completely unsuitable for this
> > purpose. I'd commit this without any timing first, and consider
> > possibilities as a second step.
> > 
> >   drivers/media/video/Makefile  |    2 +-
> >   include/media/v4l2-mediabus.h |   66 +++++++++++++++++++++++++++++++++++++++++
> >   include/media/v4l2-subdev.h   |   10 ++++++
> >   3 files changed, 77 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index 459db02..e0223ce 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
> >   omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
> > 
> >   videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> > -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> > +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-mediabus.o
> > 
> >   # V4L2 core modules
> > 
> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> > index 971c7fa..e0fb39a 100644
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -13,6 +13,72 @@
> > 
> >   #include<linux/v4l2-mediabus.h>
> > 
> > +/* Parallel flags */
> > +/*
> > + * Can the client run in master or in slave mode. By "Master mode" an operation
> > + * mode is meant, when the client (e.g., a camera sensor) is producing
> > + * horizontal and vertical synchronisation. In "Slave mode" the host is
> > + * providing these signals to the slave.
> > + */
> > +#define V4L2_MBUS_MASTER			(1<<  0)
> > +#define V4L2_MBUS_SLAVE				(1<<  1)
> > +/* Which signal polarities it supports */
> > +/* Note: in BT.656 mode HSYNC and VSYNC are unused */
> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1<<  2)
> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1<<  3)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1<<  4)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1<<  5)
> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1<<  6)
> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1<<  7)
> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1<<  8)
> > +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1<<  9)
> > +
> > +/* Serial flags */
> > +/* How many lanes the client can use */
> > +#define V4L2_MBUS_CSI2_1_LANE			(1<<  0)
> > +#define V4L2_MBUS_CSI2_2_LANE			(1<<  1)
> > +#define V4L2_MBUS_CSI2_3_LANE			(1<<  2)
> > +#define V4L2_MBUS_CSI2_4_LANE			(1<<  3)
> > +/* On which channels it can send video data */
> > +#define V4L2_MBUS_CSI2_CHANNEL_0		(1<<  4)
> > +#define V4L2_MBUS_CSI2_CHANNEL_1		(1<<  5)
> > +#define V4L2_MBUS_CSI2_CHANNEL_2		(1<<  6)
> > +#define V4L2_MBUS_CSI2_CHANNEL_3		(1<<  7)
> > +/* Does it support only continuous or also non-continuous clock mode */
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
> > + * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
> > + *			also be used for BT.1120
> > + * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
> > + */
> > +enum v4l2_mbus_type {
> > +	V4L2_MBUS_PARALLEL,
> > +	V4L2_MBUS_BT656,
> > +	V4L2_MBUS_CSI2,
> 
> How about internal connections between processing blocks inside SoCs?
> Don't we want to also list those here? I mean direct connections
> like Preview Engine -> Resizer in TI SoCs or Display Mixer -> Video Capture
> Engine in Samsung SoCs.
> If there is no all possible bus types in this list I can't see how
> driver's for such hardware could be converted to use this new interface. 
> 
> Perhaps we could add something like
> V4L2_MBUS_INTERNAL or V4L2_MBUS_USER1...?

Maybe. But again, this patch is not aiming at covering all possible cases. 
We discuss it to avoid stupid or wrong things. Correct but incomplete 
things can always be added. So, once someone get to implement such a 
connection, using this API, they will just add one more type here. Why I'm 
also unsure whether and how to add it now is, that these types define bus 
properties. E.g., on CSI-2 you have up to 4 data lanes, a clock lane with 
certain properties etc. What properties does the "internal" bus have? I 
would leave it out until we really get to implement it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
