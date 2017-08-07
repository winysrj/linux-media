Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42551 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbdHGUls (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 16:41:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Date: Mon, 07 Aug 2017 23:42:01 +0300
Message-ID: <5380447.UyHVojvDsx@avalon>
In-Reply-To: <20170720092302.2982-3-maxime.ripard@free-electrons.com>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com> <20170720092302.2982-3-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Thursday 20 Jul 2017 11:23:02 Maxime Ripard wrote:
> The Cadence CSI-2 RX Controller is an hardware block meant to be used as a
> bridge between a CSI-2 bus and pixel grabbers.
> 
> It supports operating with internal or external D-PHY, with up to 4 lanes,
> or without any D-PHY. The current code only supports the former case.
> 
> It also support dynamic mapping of the CSI-2 virtual channels to the
> associated pixel grabbers, but that isn't allowed at the moment either.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/media/platform/Kconfig               |   1 +
>  drivers/media/platform/Makefile              |   2 +
>  drivers/media/platform/cadence/Kconfig       |  12 +
>  drivers/media/platform/cadence/Makefile      |   1 +
>  drivers/media/platform/cadence/cdns-csi2rx.c | 413 ++++++++++++++++++++++++
>  5 files changed, 429 insertions(+)
>  create mode 100644 drivers/media/platform/cadence/Kconfig
>  create mode 100644 drivers/media/platform/cadence/Makefile
>  create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c

[snip]

> diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c
> b/drivers/media/platform/cadence/cdns-csi2rx.c new file mode 100644
> index 000000000000..9a58f275f53c
> --- /dev/null
> +++ b/drivers/media/platform/cadence/cdns-csi2rx.c
> @@ -0,0 +1,413 @@
> +/*
> + * Driver for Cadence MIPI-CSI2 RX Controller v1.3
> + *
> + * Copyright (C) 2017 Cadence Design Systems Inc.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by
> the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
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
> +
> +#define CSI2RX_STREAM_BASE(n)		(((n) + 1) * 0x100)
> +
> +#define CSI2RX_STREAM_CTRL_REG(n)		(CSI2RX_STREAM_BASE(n) + 
0x000)
> +#define CSI2RX_STREAM_CTRL_START			BIT(0)
> +
> +#define CSI2RX_STREAM_DATA_CFG_REG(n)		(CSI2RX_STREAM_BASE(n) 
+ 0x008)
> +#define CSI2RX_STREAM_DATA_CFG_EN_VC_SELECT		BIT(31)
> +#define CSI2RX_STREAM_DATA_CFG_VC_SELECT(n)		BIT((n) + 16)
> +
> +#define CSI2RX_STREAM_CFG_REG(n)		(CSI2RX_STREAM_BASE(n) + 
0x00c)
> +#define CSI2RX_STREAM_CFG_FIFO_MODE_LARGE_BUF		(1 << 8)
> +
> +#define CSI2RX_STREAMS_MAX	4
> +
> +enum csi2rx_pads {
> +	CSI2RX_PAD_SINK,
> +	CSI2RX_PAD_SOURCE_VC0,
> +	CSI2RX_PAD_SOURCE_VC1,
> +	CSI2RX_PAD_SOURCE_VC2,
> +	CSI2RX_PAD_SOURCE_VC3,
> +	CSI2RX_PAD_MAX,
> +};
> +
> +struct csi2rx_priv {
> +	struct device		*dev;
> +
> +	void __iomem		*base;
> +	struct clk		*sys_clk;
> +	struct clk		*p_clk;
> +	struct clk		*p_free_clk;
> +	struct clk		*pixel_clk[CSI2RX_STREAMS_MAX];
> +	struct clk		*dphy_rx_clk;
> +
> +	u8			lanes;
> +	u8			max_lanes;
> +	u8			max_streams;
> +	bool			cdns_dphy;
> +
> +	struct v4l2_subdev	subdev;
> +	struct media_pad	pads[CSI2RX_PAD_MAX];
> +
> +	/* Remote sensor */
> +	struct v4l2_async_subdev	asd;
> +	struct device_node		*sensor_node;
> +	struct v4l2_subdev		*sensor_subdev;
> +	int				sensor_pad;

The remove subdev might not be a sensor. I would rename those three fields to 
source_* (don't forget to update the comment accordingly).

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
> +	u32 reg;
> +	int i;

i is never negative, you can make it an unsigned int.

> +	csi2rx_reset(csi2rx);
> +
> +	// TODO: modify the mapping of the DPHY lanes?

The mapping should be read from DT and applied here.

> +	reg = readl(csi2rx->base + CSI2RX_STATIC_CFG_REG);
> +	reg &= ~GENMASK(11, 8);

Could you define a macro for this register field ?

> +	writel(reg | (csi2rx->lanes << 8),
> +	       csi2rx->base + CSI2RX_STATIC_CFG_REG);
> +
> +	/*
> +	 * Create a static mapping between the CSI virtual channels
> +	 * and the output stream.
> +	 *
> +	 * This should be enhanced, but v4l2 lacks the support for
> +	 * changing that mapping dynamically.

V4L2 also lacks the ability to start/stop streams independently. That will 
hopefully be implemented at some point.

> +	 */
> +	for (i = 0; i < csi2rx->max_streams; i++) {
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
> +	return 0;
> +}
> +
> +static int csi2rx_stop(struct csi2rx_priv *csi2rx)
> +{
> +	int i;

i is never negative, you can make it an unsigned int.

> +	for (i = 0; i < csi2rx->max_streams; i++)
> +		writel(0, csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
> +
> +	return 0;
> +}
> +
> +static int csi2rx_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(sd);
> +
> +	v4l2_subdev_call(csi2rx->sensor_subdev, video, s_stream,
> +			 enable);

Shouldn't you handle errors here ?

I'm not familiar with this IP core, but most D-PHYs need to synchronize to the 
input and must be started before the source.

> +	if (enable)
> +		csi2rx_start(csi2rx);
> +	else
> +		csi2rx_stop(csi2rx);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops csi2rx_video_ops = {
> +	.s_stream	= csi2rx_s_stream,
> +};
> +
> +static struct v4l2_subdev_ops csi2rx_subdev_ops = {

This structure can be made const.

> +	.video		= &csi2rx_video_ops,
> +};
> +
> +static int csi2rx_async_bound(struct v4l2_async_notifier *notifier,
> +			      struct v4l2_subdev *s_subdev,
> +			      struct v4l2_async_subdev *asd)
> +{
> +	struct v4l2_subdev *subdev = subnotifier_to_v4l2_subdev(notifier);
> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
> +
> +	csi2rx->sensor_pad = media_entity_get_fwnode_pad(&s_subdev->entity,
> +							 &csi2rx->sensor_node-
>fwnode,
> +							 MEDIA_PAD_FL_SOURCE);
> +	if (csi2rx->sensor_pad < 0) {
> +		dev_err(csi2rx->dev, "Couldn't find output pad for subdev 
%s\n",
> +			s_subdev->name);
> +		return csi2rx->sensor_pad;
> +	}
> +
> +	csi2rx->sensor_subdev = s_subdev;
> +
> +	dev_dbg(csi2rx->dev, "Bound %s pad: %d\n", s_subdev->name,
> +		csi2rx->sensor_pad);
> +
> +	return 0;
> +}
> +
> +static int csi2rx_async_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *subdev = subnotifier_to_v4l2_subdev(notifier);
> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
> +
> +	return media_create_pad_link(&csi2rx->sensor_subdev->entity,
> +				     csi2rx->sensor_pad,
> +				     &csi2rx->subdev.entity, 0,
> +				     MEDIA_LNK_FL_ENABLED |
> +				     MEDIA_LNK_FL_IMMUTABLE);
> +}
> +
> +static void csi2rx_async_unbind(struct v4l2_async_notifier *notifier,
> +				struct v4l2_subdev *s_subdev,
> +				struct v4l2_async_subdev *asd)
> +{
> +	struct v4l2_subdev *subdev = subnotifier_to_v4l2_subdev(notifier);
> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
> +
> +	dev_dbg(csi2rx->dev, "Unbound %s pad: %d\n", s_subdev->name,
> +		csi2rx->sensor_pad);
> +
> +	csi2rx->sensor_subdev = NULL;
> +	csi2rx->sensor_pad = -EINVAL;
> +}
> +
> +static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
> +				struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	u32 reg;
> +	int i;

i is never negative, you can make it an unsigned int.

> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	csi2rx->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(csi2rx->base)) {
> +		dev_err(&pdev->dev, "Couldn't map our registers\n");

devm_ioremap_resource() prints an error message, no need to duplicate it.

> +		return PTR_ERR(csi2rx->base);
> +	}
> +
> +	reg = readl(csi2rx->base + CSI2RX_DEVICE_CFG_REG);

Shouldn't you enable the register access clock(s) before reading the register 
?

> +	csi2rx->max_lanes = (reg & 7) + 1;

Up to 8 lanes ? Shouldn't this be (reg & 3) + 1 ?

> +	csi2rx->max_streams = ((reg >> 4) & 7);

Should you validate the value as you use it as an array access index ?

> +	csi2rx->cdns_dphy = reg & BIT(3);
> +
> +	csi2rx->sys_clk = devm_clk_get(&pdev->dev, "sys_clk");
> +	if (IS_ERR(csi2rx->sys_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get sys clock\n");

If you wrote this as

		dev_err(&pdev->dev, "Couldn't get %s clock\n", "sys");

and the next messages in a similar fashion, most of the message wouldn't be 
duplicated, resulting in smaller code size.

> +		return PTR_ERR(csi2rx->sys_clk);
> +	}
> +
> +	csi2rx->p_clk = devm_clk_get(&pdev->dev, "p_clk");
> +	if (IS_ERR(csi2rx->p_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> +		return PTR_ERR(csi2rx->p_clk);
> +	}
> +
> +	csi2rx->p_free_clk = devm_clk_get(&pdev->dev, "p_free_clk");
> +	if (IS_ERR(csi2rx->p_free_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get free running P clock\n");
> +		return PTR_ERR(csi2rx->p_free_clk);
> +	}
> +
> +	for (i = 0; i < csi2rx->max_streams; i++) {
> +		char clk_name[16];

Isn't 13 enough ?

> +
> +		snprintf(clk_name, sizeof(clk_name), "pixel_if%u_clk", i);
> +		csi2rx->pixel_clk[i] = devm_clk_get(&pdev->dev, clk_name);
> +		if (IS_ERR(csi2rx->pixel_clk[i])) {
> +			dev_err(&pdev->dev, "Couldn't get clock %s\n", 
clk_name);
> +			return PTR_ERR(csi2rx->pixel_clk[i]);
> +		}
> +	}
> +
> +	if (csi2rx->cdns_dphy) {
> +		csi2rx->dphy_rx_clk = devm_clk_get(&pdev->dev, "dphy_rx_clk");
> +		if (IS_ERR(csi2rx->dphy_rx_clk)) {
> +			dev_err(&pdev->dev, "Couldn't get D-PHY RX clock\n");
> +			return PTR_ERR(csi2rx->dphy_rx_clk);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
> +{
> +	struct v4l2_fwnode_endpoint v4l2_ep;
> +	struct v4l2_async_subdev **subdevs;
> +	struct device_node *ep, *remote;
> +	int ret = 0;

No need to initialize ret to 0.

> +
> +	ep = of_graph_get_endpoint_by_regs(csi2rx->dev->of_node, 0, 0);
> +	if (!ep)
> +		return -EINVAL;
> +
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> +	if (ret) {
> +		dev_err(csi2rx->dev, "Could not parse v4l2 endpoint\n");
> +		goto out;
> +	}
> +
> +	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
> +		dev_err(csi2rx->dev, "Unsupported media bus type: 0x%x\n",
> +			v4l2_ep.bus_type);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	csi2rx->lanes = v4l2_ep.bus.mipi_csi2.num_data_lanes;
> +	if (csi2rx->lanes > csi2rx->max_lanes) {
> +		dev_err(csi2rx->dev, "Unsupported number of data-lanes: %d\n",
> +			csi2rx->lanes);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	remote = of_graph_get_remote_port_parent(ep);
> +	if (!remote) {
> +		dev_err(csi2rx->dev, "No device found for endpoint %pOF\n", 
ep);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	dev_dbg(csi2rx->dev, "Found remote device %pOF\n", remote);
> +
> +	csi2rx->sensor_node = remote;
> +	csi2rx->asd.match.fwnode.fwnode = &remote->fwnode;
> +	csi2rx->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +
> +	subdevs = devm_kzalloc(csi2rx->dev, sizeof(*subdevs), GFP_KERNEL);

Could you store this in the csi2rx_priv structure to avoid a dynamic 
allocation ?

> +	if (subdevs == NULL)
> +		return -ENOMEM;
> +	subdevs[0] = &csi2rx->asd;
> +
> +	ret = v4l2_async_subdev_notifier_register(&csi2rx->subdev, 1, subdevs,
> +						  csi2rx_async_bound,
> +						  csi2rx_async_complete,
> +						  csi2rx_async_unbind);
> +	if (ret < 0) {
> +		dev_err(csi2rx->dev, "Failed to register our notifier\n");
> +		return ret;
> +	}

I would register the notifier in the probe function, as this is not DT 
parsing.

> +out:
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +static int csi2rx_probe(struct platform_device *pdev)
> +{
> +	struct csi2rx_priv *csi2rx;
> +	int i, ret;

i is never negative, you can make it an unsigned int.

> +
> +	csi2rx = devm_kzalloc(&pdev->dev, sizeof(*csi2rx), GFP_KERNEL);

Please don't use devm_kzalloc() to allocate structures that can be accessed 
from userspace (in this case because it embeds the subdev structure, 
accessible at least through the subdevs ioctls). This is incompatible with 
proper unplug handling. There are many other issues that we will need to solve 
in the V4L2 core to handling unplugging properly, but let's not add a new one.

> +	if (!csi2rx)
> +		return -ENOMEM;
> +	platform_set_drvdata(pdev, csi2rx);
> +	csi2rx->dev = &pdev->dev;
> +
> +	ret = csi2rx_get_resources(csi2rx, pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to get our resources\n");

You already print error messages in the csi2rx_get_resources() function, 
there's no need to add a new one.

> +		return ret;
> +	}
> +
> +	ret = csi2rx_parse_dt(csi2rx);
> +	if (ret)
> +		return ret;
> +
> +	csi2rx->subdev.owner = THIS_MODULE;
> +	csi2rx->subdev.dev = &pdev->dev;
> +	v4l2_subdev_init(&csi2rx->subdev, &csi2rx_subdev_ops);
> +	v4l2_set_subdevdata(&csi2rx->subdev, &pdev->dev);
> +	snprintf(csi2rx->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.%s",
> +		 KBUILD_MODNAME, dev_name(&pdev->dev));
> +
> +	/* Create our media pads */
> +	csi2rx->subdev.entity.function = 
MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +	csi2rx->pads[CSI2RX_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> +	for (i = CSI2RX_PAD_SOURCE_VC0; i < CSI2RX_PAD_MAX; i++)
> +		csi2rx->pads[i].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&csi2rx->subdev.entity, CSI2RX_PAD_MAX,
> +				     csi2rx->pads);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_async_register_subdev(&csi2rx->subdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_info(&pdev->dev,
> +		 "Probed CSI2RX with %d/%d lanes, %d streams, %s D-PHY\n",

Please use %u for unsigned integers.

> +		 csi2rx->lanes, csi2rx->max_lanes, csi2rx->max_streams,
> +		 csi2rx->cdns_dphy ? "Cadence" : "no");

As the driver currently doesn't support external PHYs, should you treat the 
presence of an external PHY in DT as an error ?

> +	return 0;
> +}
> +
> +static int csi2rx_remove(struct platform_device *pdev)
> +{
> +	struct csi2rx_priv *csi2rx = platform_get_drvdata(pdev);
> +
> +	v4l2_async_unregister_subdev(&csi2rx->subdev);
> +
> +	return 0;
> +}

[snip]

-- 
Regards,

Laurent Pinchart
