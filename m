Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59909 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbdIVLrW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 07:47:22 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Date: Fri, 22 Sep 2017 13:47:03 +0200
Message-Id: <20170922114703.30511-3-maxime.ripard@free-electrons.com>
In-Reply-To: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Cadence MIPI-CSI2 TX controller is an hardware block meant to be used
as a bridge between pixel interfaces and a CSI-2 bus.

It supports operating with an internal or external D-PHY, with up to 4
lanes, or without any D-PHY. The current code only supports the former
case.

While the virtual channel input on the pixel interface can be directly
mapped to CSI2, the datatype input is actually a selection signal (3-bits)
mapping to a table of up to 8 preconfigured datatypes/formats (programmed
at start-up)

The block supports up to 8 input datatypes.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/media/platform/cadence/Kconfig       |   6 +
 drivers/media/platform/cadence/Makefile      |   1 +
 drivers/media/platform/cadence/cdns-csi2tx.c | 479 +++++++++++++++++++++++++++
 3 files changed, 486 insertions(+)
 create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c

diff --git a/drivers/media/platform/cadence/Kconfig b/drivers/media/platform/cadence/Kconfig
index d1b6bbb6a0eb..db49328ee8b2 100644
--- a/drivers/media/platform/cadence/Kconfig
+++ b/drivers/media/platform/cadence/Kconfig
@@ -9,4 +9,10 @@ config VIDEO_CADENCE_CSI2RX
 	depends on VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 
+config VIDEO_CADENCE_CSI2TX
+	tristate "Cadence MIPI-CSI2 TX Controller"
+	depends on MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
+
 endif
diff --git a/drivers/media/platform/cadence/Makefile b/drivers/media/platform/cadence/Makefile
index 99a4086b7448..7fe992273162 100644
--- a/drivers/media/platform/cadence/Makefile
+++ b/drivers/media/platform/cadence/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VIDEO_CADENCE_CSI2RX)	+= cdns-csi2rx.o
+obj-$(CONFIG_VIDEO_CADENCE_CSI2TX)	+= cdns-csi2tx.o
diff --git a/drivers/media/platform/cadence/cdns-csi2tx.c b/drivers/media/platform/cadence/cdns-csi2tx.c
new file mode 100644
index 000000000000..859bbce8772b
--- /dev/null
+++ b/drivers/media/platform/cadence/cdns-csi2tx.c
@@ -0,0 +1,479 @@
+/*
+ * Driver for Cadence MIPI-CSI2 TX Controller
+ *
+ * Copyright (C) 2017 Cadence Design Systems Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/atomic.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-subdev.h>
+
+#define CSI2TX_DEVICE_CONFIG_REG	0x00
+
+#define CSI2TX_CONFIG_REG		0x20
+#define CSI2TX_CONFIG_CFG_REQ			BIT(2)
+#define CSI2TX_CONFIG_SRST_REQ			BIT(1)
+
+#define CSI2TX_DPHY_CFG_REG		0x28
+#define CSI2TX_DPHY_CFG_CLK_RESET		BIT(16)
+#define CSI2TX_DPHY_CFG_LANE_RESET(n)		BIT((n) + 12)
+#define CSI2TX_DPHY_CFG_MODE_MASK		GENMASK(9, 8)
+#define CSI2TX_DPHY_CFG_MODE_LPDT		(2 << 8)
+#define CSI2TX_DPHY_CFG_MODE_HS			(1 << 8)
+#define CSI2TX_DPHY_CFG_MODE_ULPS		(0 << 8)
+#define CSI2TX_DPHY_CFG_CLK_ENABLE		BIT(4)
+#define CSI2TX_DPHY_CFG_LANE_ENABLE(n)		BIT(n)
+
+#define CSI2TX_DPHY_CLK_WAKEUP_REG	0x2c
+#define CSI2TX_DPHY_CLK_WAKEUP_ULPS_CYCLES(n)	((n) & 0xffff)
+
+#define CSI2TX_DT_CFG_REG(n)		(0x80 + (n) * 8)
+#define CSI2TX_DT_CFG_DT(n)			(((n) & 0x3f) << 2)
+
+#define CSI2TX_DT_FORMAT_REG(n)		(0x84 + (n) * 8)
+#define CSI2TX_DT_FORMAT_BYTES_PER_LINE(n)	(((n) & 0xffff) << 16)
+#define CSI2TX_DT_FORMAT_MAX_LINE_NUM(n)	((n) & 0xffff)
+
+#define CSI2TX_STREAM_IF_CFG_REG(n)	(0x100 + (n) * 4)
+#define CSI2TX_STREAM_IF_CFG_FILL_LEVEL(n)	((n) & 0x1f)
+
+#define CSI2TX_STREAMS_MAX	4
+
+enum csi2tx_pads {
+	CSI2TX_PAD_SOURCE,
+	CSI2TX_PAD_SINK_STREAM0,
+	CSI2TX_PAD_SINK_STREAM1,
+	CSI2TX_PAD_SINK_STREAM2,
+	CSI2TX_PAD_SINK_STREAM3,
+	CSI2TX_PAD_MAX,
+};
+
+struct csi2tx_fmt {
+	u32	mbus;
+	u32	dt;
+	u32	bpp;
+};
+
+struct csi2tx_priv {
+	struct device			*dev;
+	atomic_t			count;
+
+	void __iomem			*base;
+
+	struct clk			*esc_clk;
+	struct clk			*p_clk;
+	struct clk			*pixel_clk[CSI2TX_STREAMS_MAX];
+
+	struct v4l2_subdev		subdev;
+	struct media_pad		pads[CSI2TX_PAD_MAX];
+	struct v4l2_mbus_framefmt	pad_fmts[CSI2TX_PAD_MAX];
+
+	bool				has_internal_dphy;
+	unsigned int			lanes;
+	unsigned int			max_lanes;
+	unsigned int			max_streams;
+};
+
+static struct csi2tx_fmt csi2tx_formats[] = {
+	{
+		.mbus	= MEDIA_BUS_FMT_UYVY8_1X16,
+		.bpp	= 2,
+		.dt	= 0x1e,
+	},
+	{
+		.mbus	= MEDIA_BUS_FMT_RGB888_1X24,
+		.bpp	= 3,
+		.dt	= 0x24,
+	},
+};
+
+static inline
+struct csi2tx_priv *v4l2_subdev_to_csi2tx(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct csi2tx_priv, subdev);
+}
+
+static void csi2tx_reset(struct csi2tx_priv *csi2tx)
+{
+	writel(CSI2TX_CONFIG_SRST_REQ, csi2tx->base + CSI2TX_CONFIG_REG);
+
+	usleep_range(10, 20);
+}
+
+static struct csi2tx_fmt *csitx_get_fmt_from_mbus(struct v4l2_mbus_framefmt *mfmt)
+{
+	int i;
+
+	if (!mfmt)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(csi2tx_formats); i++)
+		if (csi2tx_formats[i].mbus == mfmt->code)
+			return &csi2tx_formats[i];
+
+	return NULL;
+}
+
+static int csi2tx_enum_mbus_code(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->pad || code->index >= ARRAY_SIZE(csi2tx_formats))
+		return -EINVAL;
+
+	code->code = csi2tx_formats[code->index].mbus;
+
+	return 0;
+}
+
+static int csi2tx_get_pad_format(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_format *fmt)
+{
+	struct csi2tx_priv *csi2tx = v4l2_subdev_to_csi2tx(subdev);
+
+	fmt->format = csi2tx->pad_fmts[fmt->pad];
+
+	return 0;
+}
+
+static int csi2tx_set_pad_format(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_format *fmt)
+{
+	struct csi2tx_priv *csi2tx = v4l2_subdev_to_csi2tx(subdev);
+
+	csi2tx->pad_fmts[fmt->pad] = fmt->format;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops csi2tx_pad_ops = {
+	.enum_mbus_code	= csi2tx_enum_mbus_code,
+	.get_fmt	= csi2tx_get_pad_format,
+	.set_fmt	= csi2tx_set_pad_format,
+};
+
+static int csi2tx_start(struct csi2tx_priv *csi2tx)
+{
+	u32 reg;
+	int i;
+
+	/*
+	 * We're not the first users, there's no need to enable the
+	 * whole controller.
+	 */
+	if (atomic_inc_return(&csi2tx->count) > 1)
+		return 0;
+
+	csi2tx_reset(csi2tx);
+
+	writel(CSI2TX_CONFIG_CFG_REQ, csi2tx->base + CSI2TX_CONFIG_REG);
+
+	usleep_range(10, 20);
+
+	writel(CSI2TX_DPHY_CLK_WAKEUP_ULPS_CYCLES(32),
+	       csi2tx->base + CSI2TX_DPHY_CLK_WAKEUP_REG);
+
+	/* Put our lanes (clock and data) out of reset */
+	reg = CSI2TX_DPHY_CFG_CLK_RESET | CSI2TX_DPHY_CFG_MODE_LPDT;
+	for (i = 0; i < csi2tx->lanes; i++)
+		reg |= CSI2TX_DPHY_CFG_LANE_RESET(i);
+	writel(reg, csi2tx->base + CSI2TX_DPHY_CFG_REG);
+
+	usleep_range(10, 20);
+
+	/* Enable our (clock and data) lanes */
+	reg |= CSI2TX_DPHY_CFG_CLK_ENABLE;
+	for (i = 0; i < csi2tx->lanes; i++)
+		reg |= CSI2TX_DPHY_CFG_LANE_ENABLE(i);
+	writel(reg, csi2tx->base + CSI2TX_DPHY_CFG_REG);
+
+	usleep_range(10, 20);
+
+	/* Switch to HS mode */
+	reg &= ~CSI2TX_DPHY_CFG_MODE_MASK;
+	writel(reg | CSI2TX_DPHY_CFG_MODE_HS,
+	       csi2tx->base + CSI2TX_DPHY_CFG_REG);
+
+	usleep_range(10, 20);
+
+	/*
+	 * Create a static mapping between the CSI virtual channels
+	 * and the input streams.
+	 *
+	 * This should be enhanced, but v4l2 lacks the support for
+	 * changing that mapping dynamically.
+	 */
+	for (i = CSI2TX_PAD_SINK_STREAM0; i < CSI2TX_PAD_MAX; i++) {
+		struct v4l2_mbus_framefmt *mfmt = &csi2tx->pad_fmts[i];
+		struct csi2tx_fmt *fmt = csitx_get_fmt_from_mbus(mfmt);
+		int stream = i - CSI2TX_PAD_SINK_STREAM0;
+
+		/*
+		 * If no-one set a format, we consider this pad
+		 * disabled and just skip it.
+		 */
+		if (!fmt)
+			continue;
+
+		/*
+		 * We use the stream ID there, but it's wrong.
+		 *
+		 * A stream could very well send a data type that is
+		 * not equal to its stream ID. We need to find a
+		 * proper way to address it.
+		 */
+		writel(CSI2TX_DT_CFG_DT(fmt->dt),
+		       csi2tx->base + CSI2TX_DT_CFG_REG(stream));
+
+		writel(CSI2TX_DT_FORMAT_BYTES_PER_LINE(mfmt->width * fmt->bpp) |
+		       CSI2TX_DT_FORMAT_MAX_LINE_NUM(mfmt->height + 1),
+		       csi2tx->base + CSI2TX_DT_FORMAT_REG(stream));
+
+		/*
+		 * TODO: This needs to be calculated based on the
+		 * clock rate.
+		 */
+		writel(CSI2TX_STREAM_IF_CFG_FILL_LEVEL(4),
+		       csi2tx->base + CSI2TX_STREAM_IF_CFG_REG(stream));
+	}
+
+	/* Disable the configuration mode */
+	writel(0, csi2tx->base + CSI2TX_CONFIG_REG);
+
+	return 0;
+}
+
+static int csi2tx_stop(struct csi2tx_priv *csi2tx)
+{
+	/*
+	 * Let the last user turn off the lights
+	 */
+	if (!atomic_dec_and_test(&csi2tx->count))
+		return 0;
+
+	/* FIXME: Disable the IP here */
+
+	return 0;
+}
+
+static int csi2tx_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct csi2tx_priv *csi2tx = v4l2_subdev_to_csi2tx(subdev);
+	int ret;
+
+	if (enable)
+		ret = csi2tx_start(csi2tx);
+	else
+		ret = csi2tx_stop(csi2tx);
+
+	return ret;
+}
+
+static const struct v4l2_subdev_video_ops csi2tx_video_ops = {
+	.s_stream	= csi2tx_s_stream,
+};
+
+static struct v4l2_subdev_ops csi2tx_subdev_ops = {
+	.pad		= &csi2tx_pad_ops,
+	.video		= &csi2tx_video_ops,
+};
+
+static int csi2tx_get_resources(struct csi2tx_priv *csi2tx,
+				struct platform_device *pdev)
+{
+	struct resource *res;
+	u32 reg;
+	int i;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	csi2tx->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(csi2tx->base)) {
+		dev_err(&pdev->dev, "Couldn't map our registers\n");
+		return PTR_ERR(csi2tx->base);
+	}
+
+	csi2tx->p_clk = devm_clk_get(&pdev->dev, "p_clk");
+	if (IS_ERR(csi2tx->p_clk)) {
+		dev_err(&pdev->dev, "Couldn't get p_clk\n");
+		return PTR_ERR(csi2tx->p_clk);
+	}
+
+	csi2tx->esc_clk = devm_clk_get(&pdev->dev, "esc_clk");
+	if (IS_ERR(csi2tx->esc_clk)) {
+		dev_err(&pdev->dev, "Couldn't get the esc_clk\n");
+		return PTR_ERR(csi2tx->esc_clk);
+	}
+
+	clk_prepare_enable(csi2tx->p_clk);
+	reg = readl(csi2tx->base + CSI2TX_DEVICE_CONFIG_REG);
+	clk_disable_unprepare(csi2tx->p_clk);
+
+	csi2tx->max_lanes = (reg & 7);
+	if (csi2tx->max_lanes > 4) {
+		dev_err(&pdev->dev, "Invalid number of lanes: %u\n",
+			csi2tx->max_lanes);
+		return -EINVAL;
+	}
+
+	csi2tx->max_streams = ((reg >> 4) & 7);
+	if (csi2tx->max_streams > CSI2TX_STREAMS_MAX) {
+		dev_err(&pdev->dev, "Invalid number of streams: %u\n",
+			csi2tx->max_streams);
+		return -EINVAL;
+	}
+
+	csi2tx->has_internal_dphy = (reg & BIT(3)) ? true : false;
+
+	for (i = 0; i < csi2tx->max_streams; i++) {
+		char clk_name[16];
+
+		snprintf(clk_name, sizeof(clk_name), "pixel_if%u_clk", i);
+		csi2tx->pixel_clk[i] = devm_clk_get(&pdev->dev, clk_name);
+		if (IS_ERR(csi2tx->pixel_clk[i])) {
+			dev_err(&pdev->dev, "Couldn't get clock %s\n",
+				clk_name);
+			return PTR_ERR(csi2tx->pixel_clk[i]);
+		}
+	}
+
+	return 0;
+}
+
+static int csi2tx_get_num_lanes(struct device *dev)
+{
+	struct v4l2_fwnode_endpoint v4l2_ep;
+	struct device_node *ep, *np = dev->of_node;
+	int ret = 0;
+
+	ep = of_graph_get_endpoint_by_regs(np, 0, 0);
+	if (!ep)
+		return -EINVAL;
+
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
+	if (ret) {
+		dev_err(dev, "Could not parse v4l2 endpoint\n");
+		goto out;
+	}
+
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(dev, "Unsupported media bus type: 0x%x\n",
+			v4l2_ep.bus_type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = v4l2_ep.bus.mipi_csi2.num_data_lanes;
+
+out:
+	of_node_put(ep);
+	return ret;
+}
+
+static int csi2tx_probe(struct platform_device *pdev)
+{
+	struct csi2tx_priv *csi2tx;
+	int i, ret;
+
+	csi2tx = kzalloc(sizeof(*csi2tx), GFP_KERNEL);
+	if (!csi2tx)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, csi2tx);
+	csi2tx->dev = &pdev->dev;
+
+	ret = csi2tx_get_resources(csi2tx, pdev);
+	if (ret)
+		goto err_free_priv;
+
+	v4l2_subdev_init(&csi2tx->subdev, &csi2tx_subdev_ops);
+	csi2tx->subdev.owner = THIS_MODULE;
+	csi2tx->subdev.dev = &pdev->dev;
+	csi2tx->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	v4l2_set_subdevdata(&csi2tx->subdev, &pdev->dev);
+	snprintf(csi2tx->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.%s",
+		 KBUILD_MODNAME, dev_name(&pdev->dev));
+
+	csi2tx->lanes = csi2tx_get_num_lanes(&pdev->dev);
+	if (csi2tx->lanes < 0) {
+		dev_err(&pdev->dev, "Invalid number of lanes, bailing out.\n");
+		ret = csi2tx->lanes;
+		goto err_free_priv;
+	}
+
+	if (csi2tx->lanes > csi2tx->max_lanes) {
+		dev_err(&pdev->dev,
+			"Current configuration uses more lanes than supported\n");
+		ret = -EINVAL;
+		goto err_free_priv;
+	}
+
+	/* Create our media pads */
+	csi2tx->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	csi2tx->pads[CSI2TX_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	for (i = CSI2TX_PAD_SINK_STREAM0; i < CSI2TX_PAD_MAX; i++)
+		csi2tx->pads[i].flags = MEDIA_PAD_FL_SINK;
+
+	ret = media_entity_pads_init(&csi2tx->subdev.entity, CSI2TX_PAD_MAX,
+				     csi2tx->pads);
+	if (ret)
+		return ret;
+
+	ret = v4l2_async_register_subdev(&csi2tx->subdev);
+	if (ret < 0)
+		goto err_free_priv;
+
+	dev_info(&pdev->dev,
+		 "Probed CSI2TX with %u/%u lanes, %u streams, %s D-PHY\n",
+		 csi2tx->lanes, csi2tx->max_lanes, csi2tx->max_streams,
+		 csi2tx->has_internal_dphy ? "internal" : "no");
+
+	return 0;
+
+err_free_priv:
+	kfree(csi2tx);
+	return ret;
+}
+
+static int csi2tx_remove(struct platform_device *pdev)
+{
+	struct csi2tx_priv *csi2tx = platform_get_drvdata(pdev);
+
+	v4l2_async_unregister_subdev(&csi2tx->subdev);
+	kfree(csi2tx);
+
+	return 0;
+}
+
+static const struct of_device_id csi2tx_of_table[] = {
+	{ .compatible = "cdns,csi2tx" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, csi2tx_of_table);
+
+static struct platform_driver csi2tx_driver = {
+	.probe	= csi2tx_probe,
+	.remove	= csi2tx_remove,
+
+	.driver	= {
+		.name		= "cdns-csi2tx",
+		.of_match_table	= csi2tx_of_table,
+	},
+};
+module_platform_driver(csi2tx_driver);
-- 
2.13.5
