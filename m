Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:23193 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161626AbeCAUf3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 15:35:29 -0500
Date: Thu, 1 Mar 2018 14:35:16 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, <nm@ti.com>,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v5 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180301203515.GM6807@ti.com>
References: <20180301113049.16470-1-maxime.ripard@bootlin.com>
 <20180301113049.16470-3-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180301113049.16470-3-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxime,

Thanks you for the patch,

Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Mar-01 12:30:49 +0100]:
> The Cadence MIPI-CSI2 TX controller is an hardware block meant to be used
> as a bridge between pixel interfaces and a CSI-2 bus.
> 
> It supports operating with an internal or external D-PHY, with up to 4
> lanes, or without any D-PHY. The current code only supports the latter
> case.
> 
> While the virtual channel input on the pixel interface can be directly
> mapped to CSI2, the datatype input is actually a selection signal (3-bits)
> mapping to a table of up to 8 preconfigured datatypes/formats (programmed
> at start-up)
> 
> The block supports up to 8 input datatypes.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/platform/cadence/Kconfig       |  11 +
>  drivers/media/platform/cadence/Makefile      |   1 +
>  drivers/media/platform/cadence/cdns-csi2tx.c | 527 +++++++++++++++++++++++++++
>  3 files changed, 539 insertions(+)
>  create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c
> 
> diff --git a/drivers/media/platform/cadence/Kconfig b/drivers/media/platform/cadence/Kconfig
> index 18f061e5cbd1..83dcf2b1814b 100644
> --- a/drivers/media/platform/cadence/Kconfig
> +++ b/drivers/media/platform/cadence/Kconfig
> @@ -14,4 +14,15 @@ config VIDEO_CADENCE_CSI2RX
>  	  To compile this driver as a module, choose M here: the module will be
>  	  called cdns-csi2rx.
>  
> +config VIDEO_CADENCE_CSI2TX
> +	tristate "Cadence MIPI-CSI2 TX Controller"
> +	depends on MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	select V4L2_FWNODE
> +	help
> +	  Support for the Cadence MIPI CSI2 Transceiver controller.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called cdns-csi2tx.
> +
>  endif
> diff --git a/drivers/media/platform/cadence/Makefile b/drivers/media/platform/cadence/Makefile
> index 99a4086b7448..7fe992273162 100644
> --- a/drivers/media/platform/cadence/Makefile
> +++ b/drivers/media/platform/cadence/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_VIDEO_CADENCE_CSI2RX)	+= cdns-csi2rx.o
> +obj-$(CONFIG_VIDEO_CADENCE_CSI2TX)	+= cdns-csi2tx.o
> diff --git a/drivers/media/platform/cadence/cdns-csi2tx.c b/drivers/media/platform/cadence/cdns-csi2tx.c
> new file mode 100644
> index 000000000000..8de277e6aec1
> --- /dev/null
> +++ b/drivers/media/platform/cadence/cdns-csi2tx.c
> @@ -0,0 +1,527 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Driver for Cadence MIPI-CSI2 TX Controller
> + *
> + * Copyright (C) 2017 Cadence Design Systems Inc.
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define CSI2TX_DEVICE_CONFIG_REG	0x00
> +
> +#define CSI2TX_CONFIG_REG		0x20
> +#define CSI2TX_CONFIG_CFG_REQ			BIT(2)
> +#define CSI2TX_CONFIG_SRST_REQ			BIT(1)
> +
> +#define CSI2TX_DPHY_CFG_REG		0x28
> +#define CSI2TX_DPHY_CFG_CLK_RESET		BIT(16)
> +#define CSI2TX_DPHY_CFG_LANE_RESET(n)		BIT((n) + 12)
> +#define CSI2TX_DPHY_CFG_MODE_MASK		GENMASK(9, 8)
> +#define CSI2TX_DPHY_CFG_MODE_LPDT		(2 << 8)
> +#define CSI2TX_DPHY_CFG_MODE_HS			(1 << 8)
> +#define CSI2TX_DPHY_CFG_MODE_ULPS		(0 << 8)
> +#define CSI2TX_DPHY_CFG_CLK_ENABLE		BIT(4)
> +#define CSI2TX_DPHY_CFG_LANE_ENABLE(n)		BIT(n)
> +
> +#define CSI2TX_DPHY_CLK_WAKEUP_REG	0x2c
> +#define CSI2TX_DPHY_CLK_WAKEUP_ULPS_CYCLES(n)	((n) & 0xffff)
> +
> +#define CSI2TX_DT_CFG_REG(n)		(0x80 + (n) * 8)
> +#define CSI2TX_DT_CFG_DT(n)			(((n) & 0x3f) << 2)
> +
> +#define CSI2TX_DT_FORMAT_REG(n)		(0x84 + (n) * 8)
> +#define CSI2TX_DT_FORMAT_BYTES_PER_LINE(n)	(((n) & 0xffff) << 16)
> +#define CSI2TX_DT_FORMAT_MAX_LINE_NUM(n)	((n) & 0xffff)
> +
> +#define CSI2TX_STREAM_IF_CFG_REG(n)	(0x100 + (n) * 4)
> +#define CSI2TX_STREAM_IF_CFG_FILL_LEVEL(n)	((n) & 0x1f)
> +
> +#define CSI2TX_LANES_MAX	4
> +#define CSI2TX_STREAMS_MAX	4
> +
> +enum csi2tx_pads {
> +	CSI2TX_PAD_SOURCE,
> +	CSI2TX_PAD_SINK_STREAM0,
> +	CSI2TX_PAD_SINK_STREAM1,
> +	CSI2TX_PAD_SINK_STREAM2,
> +	CSI2TX_PAD_SINK_STREAM3,
> +	CSI2TX_PAD_MAX,
> +};
> +
> +struct csi2tx_fmt {
> +	u32	mbus;
> +	u32	dt;
> +	u32	bpp;
> +};
> +
> +struct csi2tx_priv {
> +	struct device			*dev;
> +	unsigned int			count;
> +
> +	/*
> +	 * Used to prevent race conditions between multiple,
> +	 * concurrent calls to start and stop.
> +	 */
> +	struct mutex			lock;
> +
> +	void __iomem			*base;
> +
> +	struct clk			*esc_clk;
> +	struct clk			*p_clk;
> +	struct clk			*pixel_clk[CSI2TX_STREAMS_MAX];
> +
> +	struct v4l2_subdev		subdev;
> +	struct media_pad		pads[CSI2TX_PAD_MAX];
> +	struct v4l2_mbus_framefmt	pad_fmts[CSI2TX_PAD_MAX];
> +
> +	bool				has_internal_dphy;
> +	u8				lanes[CSI2TX_LANES_MAX];
> +	unsigned int			num_lanes;
> +	unsigned int			max_lanes;
> +	unsigned int			max_streams;
> +};
> +
> +static const struct csi2tx_fmt csi2tx_formats[] = {
> +	{
> +		.mbus	= MEDIA_BUS_FMT_UYVY8_1X16,
> +		.bpp	= 2,
> +		.dt	= 0x1e,
> +	},
> +	{
> +		.mbus	= MEDIA_BUS_FMT_RGB888_1X24,
> +		.bpp	= 3,
> +		.dt	= 0x24,
> +	},
> +};
> +
> +static const struct v4l2_mbus_framefmt fmt_default = {
> +	.width		= 1280,
> +	.height		= 720,
> +	.code		= MEDIA_BUS_FMT_RGB888_1X24,
> +	.field		= V4L2_FIELD_NONE,
> +	.colorspace	= V4L2_COLORSPACE_DEFAULT,
> +};
> +
> +static inline
> +struct csi2tx_priv *v4l2_subdev_to_csi2tx(struct v4l2_subdev *subdev)
> +{
> +	return container_of(subdev, struct csi2tx_priv, subdev);
> +}
> +
> +static const struct csi2tx_fmt *csitx_get_fmt_from_mbus(struct v4l2_mbus_framefmt *mfmt)
> +{
> +	unsigned int i;
> +
> +	if (!mfmt)
> +		return NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(csi2tx_formats); i++)
> +		if (csi2tx_formats[i].mbus == mfmt->code)
> +			return &csi2tx_formats[i];
> +
> +	return NULL;
> +}
> +
> +static int csi2tx_enum_mbus_code(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->pad || code->index >= ARRAY_SIZE(csi2tx_formats))
> +		return -EINVAL;
> +
> +	code->code = csi2tx_formats[code->index].mbus;
> +
> +	return 0;
> +}
> +
> +static int csi2tx_get_pad_format(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_format *fmt)
> +{
> +	struct csi2tx_priv *csi2tx = v4l2_subdev_to_csi2tx(subdev);
> +
> +	fmt->format = csi2tx->pad_fmts[fmt->pad];
> +
> +	return 0;
> +}
> +
> +static int csi2tx_set_pad_format(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_format *fmt)
> +{
> +	struct csi2tx_priv *csi2tx = v4l2_subdev_to_csi2tx(subdev);
> +
> +	csi2tx->pad_fmts[fmt->pad] = fmt->format;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops csi2tx_pad_ops = {
> +	.enum_mbus_code	= csi2tx_enum_mbus_code,
> +	.get_fmt	= csi2tx_get_pad_format,
> +	.set_fmt	= csi2tx_set_pad_format,
> +};
> +
> +static void csi2tx_reset(struct csi2tx_priv *csi2tx)
> +{
> +	writel(CSI2TX_CONFIG_SRST_REQ, csi2tx->base + CSI2TX_CONFIG_REG);
> +
> +	udelay(10);
> +}
> +
> +static int csi2tx_start(struct csi2tx_priv *csi2tx)
> +{
> +	struct media_entity *entity = &csi2tx->subdev.entity;
> +	struct media_link *link;
> +	unsigned int i;
> +	u32 reg;
> +
> +	csi2tx_reset(csi2tx);
> +
> +	writel(CSI2TX_CONFIG_CFG_REQ, csi2tx->base + CSI2TX_CONFIG_REG);
> +
> +	udelay(10);
> +
> +	writel(CSI2TX_DPHY_CLK_WAKEUP_ULPS_CYCLES(32),
> +	       csi2tx->base + CSI2TX_DPHY_CLK_WAKEUP_REG);

I am sorry if I missed this previously but do all these
CSI2TX_DPHY* reg access assume that "has_internal_dphy" is true?

Regards,
Benoit

[snip]
