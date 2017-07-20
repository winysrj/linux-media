Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60938 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933751AbdGTJXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 05:23:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Date: Thu, 20 Jul 2017 11:23:02 +0200
Message-Id: <20170720092302.2982-3-maxime.ripard@free-electrons.com>
In-Reply-To: <20170720092302.2982-1-maxime.ripard@free-electrons.com>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Cadence CSI-2 RX Controller is an hardware block meant to be used as a
bridge between a CSI-2 bus and pixel grabbers.

It supports operating with internal or external D-PHY, with up to 4 lanes,
or without any D-PHY. The current code only supports the former case.

It also support dynamic mapping of the CSI-2 virtual channels to the
associated pixel grabbers, but that isn't allowed at the moment either.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/media/platform/Kconfig               |   1 +
 drivers/media/platform/Makefile              |   2 +
 drivers/media/platform/cadence/Kconfig       |  12 +
 drivers/media/platform/cadence/Makefile      |   1 +
 drivers/media/platform/cadence/cdns-csi2rx.c | 413 +++++++++++++++++++++++++++
 5 files changed, 429 insertions(+)
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 1313cd533436..a79d96e9b723 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -26,6 +26,7 @@ config VIDEO_VIA_CAMERA
 #
 # Platform multimedia device configuration
 #
+source "drivers/media/platform/cadence/Kconfig"
 
 source "drivers/media/platform/davinci/Kconfig"
 
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 9beadc760467..1d31eb51e9bb 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the video capture/playback device drivers.
 #
 
+obj-$(CONFIG_VIDEO_CADENCE)		+= cadence/
+
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
diff --git a/drivers/media/platform/cadence/Kconfig b/drivers/media/platform/cadence/Kconfig
new file mode 100644
index 000000000000..d1b6bbb6a0eb
--- /dev/null
+++ b/drivers/media/platform/cadence/Kconfig
@@ -0,0 +1,12 @@
+config VIDEO_CADENCE
+	bool "Cadence Video Devices"
+
+if VIDEO_CADENCE
+
+config VIDEO_CADENCE_CSI2RX
+	tristate "Cadence MIPI-CSI2 RX Controller v1.3"
+	depends on MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
+
+endif
diff --git a/drivers/media/platform/cadence/Makefile b/drivers/media/platform/cadence/Makefile
new file mode 100644
index 000000000000..99a4086b7448
--- /dev/null
+++ b/drivers/media/platform/cadence/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_CADENCE_CSI2RX)	+= cdns-csi2rx.o
diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
new file mode 100644
index 000000000000..9a58f275f53c
--- /dev/null
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -0,0 +1,413 @@
+/*
+ * Driver for Cadence MIPI-CSI2 RX Controller v1.3
+ *
+ * Copyright (C) 2017 Cadence Design Systems Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-subdev.h>
+
+#define CSI2RX_DEVICE_CFG_REG			0x000
+
+#define CSI2RX_SOFT_RESET_REG			0x004
+#define CSI2RX_SOFT_RESET_PROTOCOL			BIT(1)
+#define CSI2RX_SOFT_RESET_FRONT				BIT(0)
+
+#define CSI2RX_STATIC_CFG_REG			0x008
+
+#define CSI2RX_STREAM_BASE(n)		(((n) + 1) * 0x100)
+
+#define CSI2RX_STREAM_CTRL_REG(n)		(CSI2RX_STREAM_BASE(n) + 0x000)
+#define CSI2RX_STREAM_CTRL_START			BIT(0)
+
+#define CSI2RX_STREAM_DATA_CFG_REG(n)		(CSI2RX_STREAM_BASE(n) + 0x008)
+#define CSI2RX_STREAM_DATA_CFG_EN_VC_SELECT		BIT(31)
+#define CSI2RX_STREAM_DATA_CFG_VC_SELECT(n)		BIT((n) + 16)
+
+#define CSI2RX_STREAM_CFG_REG(n)		(CSI2RX_STREAM_BASE(n) + 0x00c)
+#define CSI2RX_STREAM_CFG_FIFO_MODE_LARGE_BUF		(1 << 8)
+
+#define CSI2RX_STREAMS_MAX	4
+
+enum csi2rx_pads {
+	CSI2RX_PAD_SINK,
+	CSI2RX_PAD_SOURCE_VC0,
+	CSI2RX_PAD_SOURCE_VC1,
+	CSI2RX_PAD_SOURCE_VC2,
+	CSI2RX_PAD_SOURCE_VC3,
+	CSI2RX_PAD_MAX,
+};
+
+struct csi2rx_priv {
+	struct device		*dev;
+
+	void __iomem		*base;
+	struct clk		*sys_clk;
+	struct clk		*p_clk;
+	struct clk		*p_free_clk;
+	struct clk		*pixel_clk[CSI2RX_STREAMS_MAX];
+	struct clk		*dphy_rx_clk;
+
+	u8			lanes;
+	u8			max_lanes;
+	u8			max_streams;
+	bool			cdns_dphy;
+
+	struct v4l2_subdev	subdev;
+	struct media_pad	pads[CSI2RX_PAD_MAX];
+
+	/* Remote sensor */
+	struct v4l2_async_subdev	asd;
+	struct device_node		*sensor_node;
+	struct v4l2_subdev		*sensor_subdev;
+	int				sensor_pad;
+};
+
+static inline
+struct csi2rx_priv *v4l2_subdev_to_csi2rx(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct csi2rx_priv, subdev);
+}
+
+static void csi2rx_reset(struct csi2rx_priv *csi2rx)
+{
+	writel(CSI2RX_SOFT_RESET_PROTOCOL | CSI2RX_SOFT_RESET_FRONT,
+	       csi2rx->base + CSI2RX_SOFT_RESET_REG);
+
+	udelay(10);
+
+	writel(0, csi2rx->base + CSI2RX_SOFT_RESET_REG);
+}
+
+static int csi2rx_start(struct csi2rx_priv *csi2rx)
+{
+	u32 reg;
+	int i;
+
+	csi2rx_reset(csi2rx);
+
+	// TODO: modify the mapping of the DPHY lanes?
+	reg = readl(csi2rx->base + CSI2RX_STATIC_CFG_REG);
+	reg &= ~GENMASK(11, 8);
+	writel(reg | (csi2rx->lanes << 8),
+	       csi2rx->base + CSI2RX_STATIC_CFG_REG);
+
+	/*
+	 * Create a static mapping between the CSI virtual channels
+	 * and the output stream.
+	 *
+	 * This should be enhanced, but v4l2 lacks the support for
+	 * changing that mapping dynamically.
+	 */
+	for (i = 0; i < csi2rx->max_streams; i++) {
+		writel(CSI2RX_STREAM_CFG_FIFO_MODE_LARGE_BUF,
+		       csi2rx->base + CSI2RX_STREAM_CFG_REG(i));
+
+		writel(CSI2RX_STREAM_DATA_CFG_EN_VC_SELECT |
+		       CSI2RX_STREAM_DATA_CFG_VC_SELECT(i),
+		       csi2rx->base + CSI2RX_STREAM_DATA_CFG_REG(i));
+
+		writel(CSI2RX_STREAM_CTRL_START,
+		       csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
+	}
+
+	return 0;
+}
+
+static int csi2rx_stop(struct csi2rx_priv *csi2rx)
+{
+	int i;
+
+	for (i = 0; i < csi2rx->max_streams; i++)
+		writel(0, csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
+
+	return 0;
+}
+
+static int csi2rx_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(sd);
+
+	v4l2_subdev_call(csi2rx->sensor_subdev, video, s_stream,
+			 enable);
+
+	if (enable)
+		csi2rx_start(csi2rx);
+	else
+		csi2rx_stop(csi2rx);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops csi2rx_video_ops = {
+	.s_stream	= csi2rx_s_stream,
+};
+
+static struct v4l2_subdev_ops csi2rx_subdev_ops = {
+	.video		= &csi2rx_video_ops,
+};
+
+static int csi2rx_async_bound(struct v4l2_async_notifier *notifier,
+			      struct v4l2_subdev *s_subdev,
+			      struct v4l2_async_subdev *asd)
+{
+	struct v4l2_subdev *subdev = subnotifier_to_v4l2_subdev(notifier);
+	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
+
+	csi2rx->sensor_pad = media_entity_get_fwnode_pad(&s_subdev->entity,
+							 &csi2rx->sensor_node->fwnode,
+							 MEDIA_PAD_FL_SOURCE);
+	if (csi2rx->sensor_pad < 0) {
+		dev_err(csi2rx->dev, "Couldn't find output pad for subdev %s\n",
+			s_subdev->name);
+		return csi2rx->sensor_pad;
+	}
+
+	csi2rx->sensor_subdev = s_subdev;
+
+	dev_dbg(csi2rx->dev, "Bound %s pad: %d\n", s_subdev->name,
+		csi2rx->sensor_pad);
+
+	return 0;
+}
+
+static int csi2rx_async_complete(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *subdev = subnotifier_to_v4l2_subdev(notifier);
+	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
+
+	return media_create_pad_link(&csi2rx->sensor_subdev->entity,
+				     csi2rx->sensor_pad,
+				     &csi2rx->subdev.entity, 0,
+				     MEDIA_LNK_FL_ENABLED |
+				     MEDIA_LNK_FL_IMMUTABLE);
+}
+
+static void csi2rx_async_unbind(struct v4l2_async_notifier *notifier,
+				struct v4l2_subdev *s_subdev,
+				struct v4l2_async_subdev *asd)
+{
+	struct v4l2_subdev *subdev = subnotifier_to_v4l2_subdev(notifier);
+	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
+
+	dev_dbg(csi2rx->dev, "Unbound %s pad: %d\n", s_subdev->name,
+		csi2rx->sensor_pad);
+
+	csi2rx->sensor_subdev = NULL;
+	csi2rx->sensor_pad = -EINVAL;
+}
+
+static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
+				struct platform_device *pdev)
+{
+	struct resource *res;
+	u32 reg;
+	int i;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	csi2rx->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(csi2rx->base)) {
+		dev_err(&pdev->dev, "Couldn't map our registers\n");
+		return PTR_ERR(csi2rx->base);
+	}
+
+	reg = readl(csi2rx->base + CSI2RX_DEVICE_CFG_REG);
+	csi2rx->max_lanes = (reg & 7) + 1;
+	csi2rx->max_streams = ((reg >> 4) & 7);
+	csi2rx->cdns_dphy = reg & BIT(3);
+
+	csi2rx->sys_clk = devm_clk_get(&pdev->dev, "sys_clk");
+	if (IS_ERR(csi2rx->sys_clk)) {
+		dev_err(&pdev->dev, "Couldn't get sys clock\n");
+		return PTR_ERR(csi2rx->sys_clk);
+	}
+
+	csi2rx->p_clk = devm_clk_get(&pdev->dev, "p_clk");
+	if (IS_ERR(csi2rx->p_clk)) {
+		dev_err(&pdev->dev, "Couldn't get P clock\n");
+		return PTR_ERR(csi2rx->p_clk);
+	}
+
+	csi2rx->p_free_clk = devm_clk_get(&pdev->dev, "p_free_clk");
+	if (IS_ERR(csi2rx->p_free_clk)) {
+		dev_err(&pdev->dev, "Couldn't get free running P clock\n");
+		return PTR_ERR(csi2rx->p_free_clk);
+	}
+
+	for (i = 0; i < csi2rx->max_streams; i++) {
+		char clk_name[16];
+
+		snprintf(clk_name, sizeof(clk_name), "pixel_if%u_clk", i);
+		csi2rx->pixel_clk[i] = devm_clk_get(&pdev->dev, clk_name);
+		if (IS_ERR(csi2rx->pixel_clk[i])) {
+			dev_err(&pdev->dev, "Couldn't get clock %s\n", clk_name);
+			return PTR_ERR(csi2rx->pixel_clk[i]);
+		}
+	}
+
+	if (csi2rx->cdns_dphy) {
+		csi2rx->dphy_rx_clk = devm_clk_get(&pdev->dev, "dphy_rx_clk");
+		if (IS_ERR(csi2rx->dphy_rx_clk)) {
+			dev_err(&pdev->dev, "Couldn't get D-PHY RX clock\n");
+			return PTR_ERR(csi2rx->dphy_rx_clk);
+		}
+	}
+
+	return 0;
+}
+
+static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
+{
+	struct v4l2_fwnode_endpoint v4l2_ep;
+	struct v4l2_async_subdev **subdevs;
+	struct device_node *ep, *remote;
+	int ret = 0;
+
+	ep = of_graph_get_endpoint_by_regs(csi2rx->dev->of_node, 0, 0);
+	if (!ep)
+		return -EINVAL;
+
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
+	if (ret) {
+		dev_err(csi2rx->dev, "Could not parse v4l2 endpoint\n");
+		goto out;
+	}
+
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(csi2rx->dev, "Unsupported media bus type: 0x%x\n",
+			v4l2_ep.bus_type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	csi2rx->lanes = v4l2_ep.bus.mipi_csi2.num_data_lanes;
+	if (csi2rx->lanes > csi2rx->max_lanes) {
+		dev_err(csi2rx->dev, "Unsupported number of data-lanes: %d\n",
+			csi2rx->lanes);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	remote = of_graph_get_remote_port_parent(ep);
+	if (!remote) {
+		dev_err(csi2rx->dev, "No device found for endpoint %pOF\n", ep);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	dev_dbg(csi2rx->dev, "Found remote device %pOF\n", remote);
+
+	csi2rx->sensor_node = remote;
+	csi2rx->asd.match.fwnode.fwnode = &remote->fwnode;
+	csi2rx->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+
+	subdevs = devm_kzalloc(csi2rx->dev, sizeof(*subdevs), GFP_KERNEL);
+	if (subdevs == NULL)
+		return -ENOMEM;
+	subdevs[0] = &csi2rx->asd;
+
+	ret = v4l2_async_subdev_notifier_register(&csi2rx->subdev, 1, subdevs,
+						  csi2rx_async_bound,
+						  csi2rx_async_complete,
+						  csi2rx_async_unbind);
+	if (ret < 0) {
+		dev_err(csi2rx->dev, "Failed to register our notifier\n");
+		return ret;
+	}
+
+out:
+	of_node_put(ep);
+	return ret;
+}
+
+static int csi2rx_probe(struct platform_device *pdev)
+{
+	struct csi2rx_priv *csi2rx;
+	int i, ret;
+
+	csi2rx = devm_kzalloc(&pdev->dev, sizeof(*csi2rx), GFP_KERNEL);
+	if (!csi2rx)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, csi2rx);
+	csi2rx->dev = &pdev->dev;
+
+	ret = csi2rx_get_resources(csi2rx, pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to get our resources\n");
+		return ret;
+	}
+
+	ret = csi2rx_parse_dt(csi2rx);
+	if (ret)
+		return ret;
+
+	csi2rx->subdev.owner = THIS_MODULE;
+	csi2rx->subdev.dev = &pdev->dev;
+	v4l2_subdev_init(&csi2rx->subdev, &csi2rx_subdev_ops);
+	v4l2_set_subdevdata(&csi2rx->subdev, &pdev->dev);
+	snprintf(csi2rx->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.%s",
+		 KBUILD_MODNAME, dev_name(&pdev->dev));
+
+	/* Create our media pads */
+	csi2rx->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	csi2rx->pads[CSI2RX_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	for (i = CSI2RX_PAD_SOURCE_VC0; i < CSI2RX_PAD_MAX; i++)
+		csi2rx->pads[i].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_pads_init(&csi2rx->subdev.entity, CSI2RX_PAD_MAX,
+				     csi2rx->pads);
+	if (ret)
+		return ret;
+
+	ret = v4l2_async_register_subdev(&csi2rx->subdev);
+	if (ret < 0)
+		return ret;
+
+	dev_info(&pdev->dev,
+		 "Probed CSI2RX with %d/%d lanes, %d streams, %s D-PHY\n",
+		 csi2rx->lanes, csi2rx->max_lanes, csi2rx->max_streams,
+		 csi2rx->cdns_dphy ? "Cadence" : "no");
+
+	return 0;
+}
+
+static int csi2rx_remove(struct platform_device *pdev)
+{
+	struct csi2rx_priv *csi2rx = platform_get_drvdata(pdev);
+
+	v4l2_async_unregister_subdev(&csi2rx->subdev);
+
+	return 0;
+}
+
+static const struct of_device_id csi2rx_of_table[] = {
+	{ .compatible = "cdns,csi2rx" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, csi2rx_of_table);
+
+static struct platform_driver csi2rx_driver = {
+	.probe	= csi2rx_probe,
+	.remove	= csi2rx_remove,
+
+	.driver	= {
+		.name		= "cdns-csi2rx",
+		.of_match_table	= csi2rx_of_table,
+	},
+};
+module_platform_driver(csi2rx_driver);
-- 
2.13.3
