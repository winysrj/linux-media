Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:22528 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161457AbeCAUJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 15:09:30 -0500
Date: Thu, 1 Mar 2018 14:09:18 -0600
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
Subject: Re: [PATCH v8 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20180301200918.GL6807@ti.com>
References: <20180215133335.9335-1-maxime.ripard@bootlin.com>
 <20180215133335.9335-3-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180215133335.9335-3-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxime,

Thank you for the patch.

Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Feb-15 14:33:35 +0100]:
> The Cadence CSI-2 RX Controller is an hardware block meant to be used as a
> bridge between a CSI-2 bus and pixel grabbers.
> 
> It supports operating with internal or external D-PHY, with up to 4 lanes,
> or without any D-PHY. The current code only supports the latter case.
> 
> It also support dynamic mapping of the CSI-2 virtual channels to the
> associated pixel grabbers, but that isn't allowed at the moment either.
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/platform/Kconfig               |   1 +
>  drivers/media/platform/Makefile              |   2 +
>  drivers/media/platform/cadence/Kconfig       |  17 +
>  drivers/media/platform/cadence/Makefile      |   1 +
>  drivers/media/platform/cadence/cdns-csi2rx.c | 499 +++++++++++++++++++++++++++
>  5 files changed, 520 insertions(+)
>  create mode 100644 drivers/media/platform/cadence/Kconfig
>  create mode 100644 drivers/media/platform/cadence/Makefile
>  create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 614fbef08ddc..c001b646d441 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -26,6 +26,7 @@ config VIDEO_VIA_CAMERA
>  #
>  # Platform multimedia device configuration
>  #
> +source "drivers/media/platform/cadence/Kconfig"
>  
>  source "drivers/media/platform/davinci/Kconfig"
>  
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 7f3080437be6..3d29082fcf72 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -3,6 +3,8 @@
>  # Makefile for the video capture/playback device drivers.
>  #
>  
> +obj-$(CONFIG_VIDEO_CADENCE)		+= cadence/
> +
>  obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
>  
>  obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
> diff --git a/drivers/media/platform/cadence/Kconfig b/drivers/media/platform/cadence/Kconfig
> new file mode 100644
> index 000000000000..18f061e5cbd1
> --- /dev/null
> +++ b/drivers/media/platform/cadence/Kconfig
> @@ -0,0 +1,17 @@
> +config VIDEO_CADENCE
> +	bool "Cadence Video Devices"
> +
> +if VIDEO_CADENCE
> +
> +config VIDEO_CADENCE_CSI2RX
> +	tristate "Cadence MIPI-CSI2 RX Controller"
> +	depends on MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	select V4L2_FWNODE
> +	help
> +	  Support for the Cadence MIPI CSI2 Receiver controller.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called cdns-csi2rx.
> +
> +endif
> diff --git a/drivers/media/platform/cadence/Makefile b/drivers/media/platform/cadence/Makefile
> new file mode 100644
> index 000000000000..99a4086b7448
> --- /dev/null
> +++ b/drivers/media/platform/cadence/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_CADENCE_CSI2RX)	+= cdns-csi2rx.o
> diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
> new file mode 100644
> index 000000000000..99662e1a536b
> --- /dev/null
> +++ b/drivers/media/platform/cadence/cdns-csi2rx.c
> @@ -0,0 +1,499 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Driver for Cadence MIPI-CSI2 RX Controller v1.3
> + *
> + * Copyright (C) 2017 Cadence Design Systems Inc.
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define CSI2RX_DEVICE_CFG_REG			0x000
> +
> +#define CSI2RX_SOFT_RESET_REG			0x004
> +#define CSI2RX_SOFT_RESET_PROTOCOL			BIT(1)
> +#define CSI2RX_SOFT_RESET_FRONT				BIT(0)
> +
> +#define CSI2RX_STATIC_CFG_REG			0x008
> +#define CSI2RX_STATIC_CFG_DLANE_MAP(llane, plane)	((plane) << (16 + (llane) * 4))
> +#define CSI2RX_STATIC_CFG_LANES_MASK			GENMASK(11, 8)
> +
> +#define CSI2RX_STREAM_BASE(n)		(((n) + 1) * 0x100)
> +
> +#define CSI2RX_STREAM_CTRL_REG(n)		(CSI2RX_STREAM_BASE(n) + 0x000)
> +#define CSI2RX_STREAM_CTRL_START			BIT(0)
> +
> +#define CSI2RX_STREAM_DATA_CFG_REG(n)		(CSI2RX_STREAM_BASE(n) + 0x008)
> +#define CSI2RX_STREAM_DATA_CFG_EN_VC_SELECT		BIT(31)
> +#define CSI2RX_STREAM_DATA_CFG_VC_SELECT(n)		BIT((n) + 16)
> +
> +#define CSI2RX_STREAM_CFG_REG(n)		(CSI2RX_STREAM_BASE(n) + 0x00c)
> +#define CSI2RX_STREAM_CFG_FIFO_MODE_LARGE_BUF		(1 << 8)
> +
> +#define CSI2RX_LANES_MAX	4
> +#define CSI2RX_STREAMS_MAX	4
> +
> +enum csi2rx_pads {
> +	CSI2RX_PAD_SINK,
> +	CSI2RX_PAD_SOURCE_STREAM0,
> +	CSI2RX_PAD_SOURCE_STREAM1,
> +	CSI2RX_PAD_SOURCE_STREAM2,
> +	CSI2RX_PAD_SOURCE_STREAM3,
> +	CSI2RX_PAD_MAX,
> +};
> +
> +struct csi2rx_priv {
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
> +	struct clk			*sys_clk;
> +	struct clk			*p_clk;
> +	struct clk			*pixel_clk[CSI2RX_STREAMS_MAX];
> +	struct phy			*dphy;
> +
> +	u8				lanes[CSI2RX_LANES_MAX];
> +	u8				num_lanes;
> +	u8				max_lanes;
> +	u8				max_streams;
> +	bool				has_internal_dphy;
> +
> +	struct v4l2_subdev		subdev;
> +	struct v4l2_async_notifier	notifier;
> +	struct media_pad		pads[CSI2RX_PAD_MAX];
> +
> +	/* Remote source */
> +	struct v4l2_async_subdev	asd;
> +	struct v4l2_subdev		*source_subdev;
> +	int				source_pad;
> +};
> +
> +static inline
> +struct csi2rx_priv *v4l2_subdev_to_csi2rx(struct v4l2_subdev *subdev)
> +{
> +	return container_of(subdev, struct csi2rx_priv, subdev);
> +}
> +
> +static void csi2rx_reset(struct csi2rx_priv *csi2rx)
> +{
> +	writel(CSI2RX_SOFT_RESET_PROTOCOL | CSI2RX_SOFT_RESET_FRONT,
> +	       csi2rx->base + CSI2RX_SOFT_RESET_REG);
> +
> +	udelay(10);
> +
> +	writel(0, csi2rx->base + CSI2RX_SOFT_RESET_REG);
> +}
> +
> +static int csi2rx_start(struct csi2rx_priv *csi2rx)
> +{
> +	unsigned int i;
> +	unsigned long lanes_used = 0;
> +	u32 reg;
> +	int ret;
> +
> +	ret = clk_prepare_enable(csi2rx->p_clk);
> +	if (ret)
> +		return ret;
> +
> +	csi2rx_reset(csi2rx);
> +
> +	reg = csi2rx->num_lanes << 8;
> +	for (i = 0; i < csi2rx->num_lanes; i++) {
> +		reg |= CSI2RX_STATIC_CFG_DLANE_MAP(i, csi2rx->lanes[i]);
> +		set_bit(csi2rx->lanes[i], &lanes_used);
> +	}
> +
> +	/*
> +	 * Even the unused lanes need to be mapped. In order to avoid
> +	 * to map twice to the same physical lane, keep the lanes used
> +	 * in the previous loop, and only map unused physical lanes to
> +	 * the rest of our logical lanes.
> +	 */
> +	for (i = csi2rx->num_lanes; i < csi2rx->max_lanes; i++) {
> +		unsigned int idx = find_first_zero_bit(&lanes_used,
> +						       sizeof(lanes_used));
> +		set_bit(idx, &lanes_used);
> +		reg |= CSI2RX_STATIC_CFG_DLANE_MAP(i, i + 1);
> +	}
> +
> +	writel(reg, csi2rx->base + CSI2RX_STATIC_CFG_REG);
> +
> +	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
> +	if (ret)
> +		goto err_disable_pclk;
> +
> +	/*
> +	 * Create a static mapping between the CSI virtual channels
> +	 * and the output stream.
> +	 *
> +	 * This should be enhanced, but v4l2 lacks the support for
> +	 * changing that mapping dynamically.
> +	 *
> +	 * We also cannot enable and disable independant streams here,
> +	 * hence the reference counting.
> +	 */
> +	for (i = 0; i < csi2rx->max_streams; i++) {
> +		ret = clk_prepare_enable(csi2rx->pixel_clk[i]);
> +		if (ret)
> +			goto err_disable_pixclk;
> +
> +		writel(CSI2RX_STREAM_CFG_FIFO_MODE_LARGE_BUF,
> +		       csi2rx->base + CSI2RX_STREAM_CFG_REG(i));
> +
> +		writel(CSI2RX_STREAM_DATA_CFG_EN_VC_SELECT |
> +		       CSI2RX_STREAM_DATA_CFG_VC_SELECT(i),
> +		       csi2rx->base + CSI2RX_STREAM_DATA_CFG_REG(i));
> +
> +		writel(CSI2RX_STREAM_CTRL_START,
> +		       csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
> +	}
> +
> +	ret = clk_prepare_enable(csi2rx->sys_clk);
> +	if (ret)
> +		goto err_disable_pixclk;
> +
> +	clk_disable_unprepare(csi2rx->p_clk);
> +
> +	return 0;
> +
> +err_disable_pixclk:
> +	for (; i >= 0; i--)
> +		clk_disable_unprepare(csi2rx->pixel_clk[i]);
> +
> +err_disable_pclk:
> +	clk_disable_unprepare(csi2rx->p_clk);
> +
> +	return ret;
> +}
> +
> +static int csi2rx_stop(struct csi2rx_priv *csi2rx)
> +{
> +	unsigned int i;
> +
> +	clk_prepare_enable(csi2rx->p_clk);
> +	clk_disable_unprepare(csi2rx->sys_clk);
> +
> +	for (i = 0; i < csi2rx->max_streams; i++) {
> +		writel(0, csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
> +
> +		clk_disable_unprepare(csi2rx->pixel_clk[i]);
> +	}
> +
> +	clk_disable_unprepare(csi2rx->p_clk);
> +
> +	return v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, false);
> +}
> +
> +static int csi2rx_s_stream(struct v4l2_subdev *subdev, int enable)
> +{
> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
> +	int ret = 0;
> +
> +	mutex_lock(&csi2rx->lock);
> +
> +	if (enable) {
> +		/*
> +		 * If we're not the first users, there's no need to
> +		 * enable the whole controller.
> +		 */
> +		if (!csi2rx->count) {
> +			ret = csi2rx_start(csi2rx);
> +			if (ret)
> +				goto out;
> +		}
> +
> +		csi2rx->count++;
> +	} else {
> +		csi2rx->count--;
> +
> +		/*
> +		 * Let the last user turn off the lights.
> +		 */
> +		if (!csi2rx->count) {
> +			ret = csi2rx_stop(csi2rx);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&csi2rx->lock);
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_video_ops csi2rx_video_ops = {
> +	.s_stream	= csi2rx_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops csi2rx_subdev_ops = {
> +	.video		= &csi2rx_video_ops,
> +};
> +
> +static int csi2rx_async_bound(struct v4l2_async_notifier *notifier,
> +			      struct v4l2_subdev *s_subdev,
> +			      struct v4l2_async_subdev *asd)
> +{
> +	struct v4l2_subdev *subdev = notifier->sd;
> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
> +
> +	csi2rx->source_pad = media_entity_get_fwnode_pad(&s_subdev->entity,
> +							 s_subdev->fwnode,
> +							 MEDIA_PAD_FL_SOURCE);
> +	if (csi2rx->source_pad < 0) {
> +		dev_err(csi2rx->dev, "Couldn't find output pad for subdev %s\n",
> +			s_subdev->name);
> +		return csi2rx->source_pad;
> +	}
> +
> +	csi2rx->source_subdev = s_subdev;
> +
> +	dev_dbg(csi2rx->dev, "Bound %s pad: %d\n", s_subdev->name,
> +		csi2rx->source_pad);
> +
> +	return media_create_pad_link(&csi2rx->source_subdev->entity,
> +				     csi2rx->source_pad,
> +				     &csi2rx->subdev.entity, 0,
> +				     MEDIA_LNK_FL_ENABLED |
> +				     MEDIA_LNK_FL_IMMUTABLE);
> +}
> +
> +static const struct v4l2_async_notifier_operations csi2rx_notifier_ops = {
> +	.bound		= csi2rx_async_bound,
> +};
> +
> +static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
> +				struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	unsigned char i;
> +	u32 dev_cfg;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	csi2rx->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(csi2rx->base))
> +		return PTR_ERR(csi2rx->base);
> +
> +	csi2rx->sys_clk = devm_clk_get(&pdev->dev, "sys_clk");
> +	if (IS_ERR(csi2rx->sys_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get sys clock\n");
> +		return PTR_ERR(csi2rx->sys_clk);
> +	}
> +
> +	csi2rx->p_clk = devm_clk_get(&pdev->dev, "p_clk");
> +	if (IS_ERR(csi2rx->p_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> +		return PTR_ERR(csi2rx->p_clk);
> +	}
> +
> +	csi2rx->dphy = devm_phy_optional_get(&pdev->dev, "dphy");
> +	if (IS_ERR(csi2rx->dphy)) {
> +		dev_err(&pdev->dev, "Couldn't get external D-PHY\n");
> +		return PTR_ERR(csi2rx->dphy);
> +	}
> +
> +	/*
> +	 * FIXME: Once we'll have external D-PHY support, the check
> +	 * will need to be removed.
> +	 */
> +	if (csi2rx->dphy) {
> +		dev_err(&pdev->dev, "External D-PHY not supported yet\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_prepare_enable(csi2rx->p_clk);
> +	dev_cfg = readl(csi2rx->base + CSI2RX_DEVICE_CFG_REG);
> +	clk_disable_unprepare(csi2rx->p_clk);
> +
> +	csi2rx->max_lanes = dev_cfg & 7;
> +	if (csi2rx->max_lanes > CSI2RX_LANES_MAX) {
> +		dev_err(&pdev->dev, "Invalid number of lanes: %u\n",
> +			csi2rx->max_lanes);
> +		return -EINVAL;
> +	}
> +
> +	csi2rx->max_streams = (dev_cfg >> 4) & 7;
> +	if (csi2rx->max_streams > CSI2RX_STREAMS_MAX) {
> +		dev_err(&pdev->dev, "Invalid number of streams: %u\n",
> +			csi2rx->max_streams);
> +		return -EINVAL;
> +	}
> +
> +	csi2rx->has_internal_dphy = dev_cfg & BIT(3) ? true : false;
> +
> +	/*
> +	 * FIXME: Once we'll have internal D-PHY support, the check
> +	 * will need to be removed.
> +	 */
> +	if (csi2rx->has_internal_dphy) {
> +		dev_err(&pdev->dev, "Internal D-PHY not supported yet\n");
> +		return -EINVAL;
> +	}

As one of the more critical thing is usually how the CSI2 Receiver interact
with a DPHY when can we expect this part of the driver to be implemented?

Regards,
Benoit

[snip]
