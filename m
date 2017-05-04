Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57600 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751459AbdEDWNi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 18:13:38 -0400
Date: Fri, 5 May 2017 01:13:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v6 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
Message-ID: <20170504221304.GE7456@valkosipuli.retiisi.org.uk>
References: <20170427223658.14148-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427223658.14148-3-niklas.soderlund+renesas@ragnatech.se>
 <20170504133525.GW7456@valkosipuli.retiisi.org.uk>
 <20170504213019.GX1532@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170504213019.GX1532@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thu, May 04, 2017 at 11:30:19PM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your feedback.

You're welcome!

> On 2017-05-04 16:35:26 +0300, Sakari Ailus wrote:
> > Hi Niklas,
> > 
> > On Fri, Apr 28, 2017 at 12:36:58AM +0200, Niklas Söderlund wrote:
> > > A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> > > supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2
> > > hardware blocks are connected between the video sources and the video
> > > grabbers (VIN).
> > > 
> > > Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  drivers/media/platform/rcar-vin/Kconfig     |  11 +
> > >  drivers/media/platform/rcar-vin/Makefile    |   1 +
> > >  drivers/media/platform/rcar-vin/rcar-csi2.c | 872 ++++++++++++++++++++++++++++
> > >  3 files changed, 884 insertions(+)
> > >  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
> > > 
> > > diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> > > index 111d2a151f6a4d44..f1df85d526e96a74 100644
> > > --- a/drivers/media/platform/rcar-vin/Kconfig
> > > +++ b/drivers/media/platform/rcar-vin/Kconfig
> > > @@ -1,3 +1,14 @@
> > > +config VIDEO_RCAR_CSI2
> > > +	tristate "R-Car MIPI CSI-2 Receiver"
> > > +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> > > +	depends on ARCH_RENESAS || COMPILE_TEST
> > > +	---help---
> > > +	  Support for Renesas R-Car MIPI CSI-2 receiver.
> > > +	  Supports R-Car Gen3 SoCs.
> > > +
> > > +	  To compile this driver as a module, choose M here: the
> > > +	  module will be called rcar-csi2.
> > > +
> > >  config VIDEO_RCAR_VIN
> > >  	tristate "R-Car Video Input (VIN) Driver"
> > >  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
> > > diff --git a/drivers/media/platform/rcar-vin/Makefile b/drivers/media/platform/rcar-vin/Makefile
> > > index 48c5632c21dc060b..5ab803d3e7c1aa57 100644
> > > --- a/drivers/media/platform/rcar-vin/Makefile
> > > +++ b/drivers/media/platform/rcar-vin/Makefile
> > > @@ -1,3 +1,4 @@
> > >  rcar-vin-objs = rcar-core.o rcar-dma.o rcar-v4l2.o
> > >  
> > > +obj-$(CONFIG_VIDEO_RCAR_CSI2) += rcar-csi2.o
> > >  obj-$(CONFIG_VIDEO_RCAR_VIN) += rcar-vin.o
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > new file mode 100644
> > > index 0000000000000000..53601e171aa179b7
> > > --- /dev/null
> > > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > @@ -0,0 +1,872 @@
> > > +/*
> > > + * Driver for Renesas R-Car MIPI CSI-2 Receiver
> > > + *
> > > + * Copyright (C) 2017 Renesas Electronics Corp.
> > > + *
> > > + * This program is free software; you can redistribute  it and/or modify it
> > > + * under  the terms of  the GNU General  Public License as published by the
> > > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > > + * option) any later version.
> > > + */
> > > +
> > > +#include <linux/delay.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/io.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/pm_runtime.h>
> > > +
> > > +#include <media/v4l2-ctrls.h>
> > > +#include <media/v4l2-device.h>
> > > +#include <media/v4l2-mc.h>
> > > +#include <media/v4l2-of.h>
> > 
> > Could you rebase also this on the V4L2 fwnode patchset?
> > 
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
> 
> Yes, I rebased the series on top of v4l2-acpi-merge. I like the fwnode 
> patches, nice work!

I'm glad you like it. :-)

> 
> > 
> > > +#include <media/v4l2-subdev.h>
> > > +
> > > +/* Register offsets and bits */
> > > +
> > > +/* Control Timing Select */
> > > +#define TREF_REG			0x00
> > > +#define TREF_TREF			(1 << 0)
> > > +
> > > +/* Software Reset */
> > > +#define SRST_REG			0x04
> > > +#define SRST_SRST			(1 << 0)
> > > +
> > > +/* PHY Operation Control */
> > > +#define PHYCNT_REG			0x08
> > > +#define PHYCNT_SHUTDOWNZ		(1 << 17)
> > > +#define PHYCNT_RSTZ			(1 << 16)
> > > +#define PHYCNT_ENABLECLK		(1 << 4)
> > > +#define PHYCNT_ENABLE_3			(1 << 3)
> > > +#define PHYCNT_ENABLE_2			(1 << 2)
> > > +#define PHYCNT_ENABLE_1			(1 << 1)
> > > +#define PHYCNT_ENABLE_0			(1 << 0)
> > > +
> > > +/* Checksum Control */
> > > +#define CHKSUM_REG			0x0c
> > > +#define CHKSUM_ECC_EN			(1 << 1)
> > > +#define CHKSUM_CRC_EN			(1 << 0)
> > > +
> > > +/*
> > > + * Channel Data Type Select
> > > + * VCDT[0-15]:  Channel 1 VCDT[16-31]:  Channel 2
> > > + * VCDT2[0-15]: Channel 3 VCDT2[16-31]: Channel 4
> > > + */
> > > +#define VCDT_REG			0x10
> > > +#define VCDT2_REG			0x14
> > > +#define VCDT_VCDTN_EN			(1 << 15)
> > > +#define VCDT_SEL_VC(n)			(((n) & 0x3) << 8)
> > > +#define VCDT_SEL_DTN_ON			(1 << 6)
> > > +#define VCDT_SEL_DT(n)			(((n) & 0x1f) << 0)
> > > +
> > > +/* Frame Data Type Select */
> > > +#define FRDT_REG			0x18
> > > +
> > > +/* Field Detection Control */
> > > +#define FLD_REG				0x1c
> > > +#define FLD_FLD_NUM(n)			(((n) & 0xff) << 16)
> > > +#define FLD_FLD_EN4			(1 << 3)
> > > +#define FLD_FLD_EN3			(1 << 2)
> > > +#define FLD_FLD_EN2			(1 << 1)
> > > +#define FLD_FLD_EN			(1 << 0)
> > > +
> > > +/* Automatic Standby Control */
> > > +#define ASTBY_REG			0x20
> > > +
> > > +/* Long Data Type Setting 0 */
> > > +#define LNGDT0_REG			0x28
> > > +
> > > +/* Long Data Type Setting 1 */
> > > +#define LNGDT1_REG			0x2c
> > > +
> > > +/* Interrupt Enable */
> > > +#define INTEN_REG			0x30
> > > +
> > > +/* Interrupt Source Mask */
> > > +#define INTCLOSE_REG			0x34
> > > +
> > > +/* Interrupt Status Monitor */
> > > +#define INTSTATE_REG			0x38
> > > +
> > > +/* Interrupt Error Status Monitor */
> > > +#define INTERRSTATE_REG			0x3c
> > > +
> > > +/* Short Packet Data */
> > > +#define SHPDAT_REG			0x40
> > > +
> > > +/* Short Packet Count */
> > > +#define SHPCNT_REG			0x44
> > > +
> > > +/* LINK Operation Control */
> > > +#define LINKCNT_REG			0x48
> > > +#define LINKCNT_MONITOR_EN		(1 << 31)
> > > +#define LINKCNT_REG_MONI_PACT_EN	(1 << 25)
> > > +#define LINKCNT_ICLK_NONSTOP		(1 << 24)
> > > +
> > > +/* Lane Swap */
> > > +#define LSWAP_REG			0x4c
> > > +#define LSWAP_L3SEL(n)			(((n) & 0x3) << 6)
> > > +#define LSWAP_L2SEL(n)			(((n) & 0x3) << 4)
> > > +#define LSWAP_L1SEL(n)			(((n) & 0x3) << 2)
> > > +#define LSWAP_L0SEL(n)			(((n) & 0x3) << 0)
> > > +
> > > +/* PHY Test Interface Clear */
> > > +#define PHTC_REG			0x58
> > > +#define PHTC_TESTCLR			(1 << 0)
> > > +
> > > +/* PHY Frequency Control */
> > > +#define PHYPLL_REG			0x68
> > > +#define PHYPLL_HSFREQRANGE(n)		((n) << 16)
> > > +
> > > +struct phypll_hsfreqrange {
> > > +	unsigned int	mbps;
> > > +	unsigned char	reg;
> > > +};
> > > +
> > > +static const struct phypll_hsfreqrange phypll_hsfreqrange_map[] = {
> > > +	{ .mbps =   80,	.reg = 0x00 },
> > > +	{ .mbps =   90,	.reg = 0x10 },
> > > +	{ .mbps =  100,	.reg = 0x20 },
> > > +	{ .mbps =  110,	.reg = 0x30 },
> > > +	{ .mbps =  120,	.reg = 0x01 },
> > > +	{ .mbps =  130,	.reg = 0x11 },
> > > +	{ .mbps =  140,	.reg = 0x21 },
> > > +	{ .mbps =  150,	.reg = 0x31 },
> > > +	{ .mbps =  160,	.reg = 0x02 },
> > > +	{ .mbps =  170,	.reg = 0x12 },
> > > +	{ .mbps =  180,	.reg = 0x22 },
> > > +	{ .mbps =  190,	.reg = 0x32 },
> > > +	{ .mbps =  205,	.reg = 0x03 },
> > > +	{ .mbps =  220,	.reg = 0x13 },
> > > +	{ .mbps =  235,	.reg = 0x23 },
> > > +	{ .mbps =  250,	.reg = 0x33 },
> > > +	{ .mbps =  275,	.reg = 0x04 },
> > > +	{ .mbps =  300,	.reg = 0x14 },
> > > +	{ .mbps =  325,	.reg = 0x05 },
> > > +	{ .mbps =  350,	.reg = 0x15 },
> > > +	{ .mbps =  400,	.reg = 0x25 },
> > > +	{ .mbps =  450,	.reg = 0x06 },
> > > +	{ .mbps =  500,	.reg = 0x16 },
> > > +	{ .mbps =  550,	.reg = 0x07 },
> > > +	{ .mbps =  600,	.reg = 0x17 },
> > > +	{ .mbps =  650,	.reg = 0x08 },
> > > +	{ .mbps =  700,	.reg = 0x18 },
> > > +	{ .mbps =  750,	.reg = 0x09 },
> > > +	{ .mbps =  800,	.reg = 0x19 },
> > > +	{ .mbps =  850,	.reg = 0x29 },
> > > +	{ .mbps =  900,	.reg = 0x39 },
> > > +	{ .mbps =  950,	.reg = 0x0A },
> > > +	{ .mbps = 1000,	.reg = 0x1A },
> > > +	{ .mbps = 1050,	.reg = 0x2A },
> > > +	{ .mbps = 1100,	.reg = 0x3A },
> > > +	{ .mbps = 1150,	.reg = 0x0B },
> > > +	{ .mbps = 1200,	.reg = 0x1B },
> > > +	{ .mbps = 1250,	.reg = 0x2B },
> > > +	{ .mbps = 1300,	.reg = 0x3B },
> > > +	{ .mbps = 1350,	.reg = 0x0C },
> > > +	{ .mbps = 1400,	.reg = 0x1C },
> > > +	{ .mbps = 1450,	.reg = 0x2C },
> > > +	{ .mbps = 1500,	.reg = 0x3C },
> > > +	/* guard */
> > > +	{ .mbps =   0,	.reg = 0x00 },
> > > +};
> > > +
> > > +/* PHY ESC Error Monitor */
> > > +#define PHEERM_REG			0x74
> > > +
> > > +/* PHY Clock Lane Monitor */
> > > +#define PHCLM_REG			0x78
> > > +
> > > +/* PHY Data Lane Monitor */
> > > +#define PHDLM_REG			0x7c
> > > +
> > > +enum rcar_csi2_pads {
> > > +	RCAR_CSI2_SINK,
> > > +	RCAR_CSI2_SOURCE_VC0,
> > > +	RCAR_CSI2_SOURCE_VC1,
> > > +	RCAR_CSI2_SOURCE_VC2,
> > > +	RCAR_CSI2_SOURCE_VC3,
> > > +	RCAR_CSI2_PAD_MAX,
> > 
> > It might be a matter of taste to some extent, but PAD_MAX appears to
> > indicate that this remains a valid number. How about e.g.
> > NR_OF_RCAR_CSI2_PAD?
> 
> I see your point, will update for next version.
> 
> > 
> > > +};
> > > +
> > > +struct rcar_csi2 {
> > > +	struct device *dev;
> > > +	void __iomem *base;
> > > +
> > > +	unsigned short lanes;
> > > +	unsigned char lane_swap[4];
> > > +
> > > +	struct v4l2_subdev subdev;
> > > +	struct media_pad pads[RCAR_CSI2_PAD_MAX];
> > > +
> > > +	struct v4l2_mbus_framefmt mf;
> > > +
> > > +	struct mutex lock;
> > > +	int stream_count;
> > > +
> > > +	struct v4l2_async_notifier notifier;
> > > +	struct {
> > > +		struct v4l2_async_subdev asd;
> > > +		struct v4l2_subdev *subdev;
> > > +		struct of_endpoint endpoint;
> > > +		unsigned int source_pad;
> > > +	} remote;
> > > +};
> > > +
> > > +static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
> > > +{
> > > +	return container_of(sd, struct rcar_csi2, subdev);
> > > +}
> > > +
> > > +static u32 rcar_csi2_read(struct rcar_csi2 *priv, unsigned int reg)
> > > +{
> > > +	return ioread32(priv->base + reg);
> > > +}
> > > +
> > > +static void rcar_csi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
> > > +{
> > > +	iowrite32(data, priv->base + reg);
> > > +}
> > > +
> > > +static void rcar_csi2_reset(struct rcar_csi2 *priv)
> > > +{
> > > +	rcar_csi2_write(priv, SRST_REG, SRST_SRST);
> > > +	rcar_csi2_write(priv, SRST_REG, 0);
> > > +}
> > > +
> > > +static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> > > +{
> > > +	int timeout;
> > > +
> > > +	/* Wait for the clock and data lanes to enter LP-11 state. */
> > > +	for (timeout = 100; timeout >= 0; timeout--) {
> > > +		const u32 lane_mask = (1 << priv->lanes) - 1;
> > > +
> > > +		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) == 1 &&
> > > +		    (rcar_csi2_read(priv, PHDLM_REG) & lane_mask) == lane_mask)
> > > +			return 0;
> > > +
> > > +		msleep(20);
> > 
> > Some sensors will stay in LP-11 state very briefly. Do you need to wait for
> > this before the initialisation may proceed?
> > 
> > AFAIR i.MX6 CSI-2 receiver had a similar issue.
> 
> Hum, I'm not sure I follow. Are you saying that some CSI-2 transmitters
> only stays in LP-11 state for such a short time that the code in this 
> driver might miss it and report that it timeout waiting for it?
> 
> I have never seen any issues whit this, but then again so for I have 
> only tested it together with the ADV7482.

If ADV7482 can explicitly do LP-11, that's perfect. Not all hardware does.

...

> > 
> > > +	return -ETIMEDOUT;
> > > +}
> > > +
> > > +static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
> > > +				 struct v4l2_subdev *source,
> > > +				 struct v4l2_mbus_framefmt *mf,
> > > +				 u32 *phypll)
> > > +{
> > > +	const struct phypll_hsfreqrange *hsfreq;
> > > +	struct v4l2_ext_controls ctrls;
> > > +	struct v4l2_ext_control ctrl;
> > > +	unsigned int bpp;
> > > +	u64 mbps;
> > > +	int ret;
> > > +
> > > +	memset(&ctrls, 0, sizeof(ctrls));
> > > +	memset(&ctrl, 0, sizeof(ctrl));
> > > +
> > > +	ctrl.id = V4L2_CID_PIXEL_RATE;
> > > +
> > > +	ctrls.count = 1;
> > > +	ctrls.controls = &ctrl;
> > > +
> > > +	ret = v4l2_g_ext_ctrls(source->ctrl_handler, &ctrls);
> > 
> > 
> > Could you use v4l2_ctrl_g_ctrl()?
> 
> I had a look at that and if I use v4l2_ctrl_g_ctrl() I will get the 
> control value back as s32 but as I understand it I need the 64 bit value 
> for V4L2_CID_PIXEL_RATE. Or do I misunderstand this?

On, indeed. For 64-bit controls you'll need v4l2_ctrl_g_ctrl_int64(). I
think I thought about the link frequency control which is an integer menu.

...

> > > +	source_pad =
> > > +		media_entity_remote_pad(&priv->subdev.entity.pads[RCAR_CSI2_SINK]);
> > 
> > Over 80 characters per line.
> 
> Yes, I had trouble trimming this line down to less then 80 chars. It 
> seems silly to introduce a intermediate variable just to shorten line 
> length. And I don't think it's hard to read and understand whats 
> happening. But I have no strong feelings, if you think an intermediate 
> variable is useful I be happy to do so in the next version.

You could just split the line at suitable spots. In the vast majority of the
cases it helps. Say,

	source_pad = media_entity_remote_pad(
		&priv->subdev.entity.pads[RCAR_CSI2_SINK]);

...

> > > +static int rcar_csi2_s_power(struct v4l2_subdev *sd, int on)
> > > +{
> > > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > > +
> > > +	if (on)
> > > +		pm_runtime_get_sync(priv->dev);
> > 
> > Can pm_runtime_get_sync() fail?
> 
> Geert talked about this as a response to your review on VIN Gen3 
> patches. I looked around there are lots of drivers not checking the 
> return code for thees calls. So I think I keep it as is for now.

Makes sense. If it really won't then there's certainly no need for error
handling logic.

...

> > > +static struct platform_driver __refdata rcar_csi2_pdrv = {
> > 
> > const?
> 
> I added const here but got lots of warnings when compiling.  Also 
> checking the tree I can't find any other drivers declaring this as 
> const. But I do agree it would make sens if this where const.

I later realised it can't be const indeed. Please ignore the comment.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
