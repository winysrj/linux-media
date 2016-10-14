Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33233 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754163AbcJNRfA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:35:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH v2 07/21] [media] imx-ipu: Add i.MX IPUv3 CSI subdevice driver
Date: Fri, 14 Oct 2016 19:34:27 +0200
Message-Id: <1476466481-24030-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a V4L2 subdevice driver for the two CMOS Sensor Interface (CSI)
modules contained in each IPUv3. These sample video data from the
parallel CSI0/1 pads or from the the MIPI CSI-2 bridge via IOMUXC video
bus multiplexers and write to IPU internal FIFOs to deliver data to
either the IDMAC or IC modules.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Propagate field and colorspace in ipucsi_subdev_set_format.
 - Recursively call s_stream on upstream subdev.
---
 drivers/media/platform/imx/Kconfig         |   7 +
 drivers/media/platform/imx/Makefile        |   1 +
 drivers/media/platform/imx/imx-ipuv3-csi.c | 547 +++++++++++++++++++++++++++++
 3 files changed, 555 insertions(+)
 create mode 100644 drivers/media/platform/imx/imx-ipuv3-csi.c

diff --git a/drivers/media/platform/imx/Kconfig b/drivers/media/platform/imx/Kconfig
index 1662bb0b..a88c4f7 100644
--- a/drivers/media/platform/imx/Kconfig
+++ b/drivers/media/platform/imx/Kconfig
@@ -8,3 +8,10 @@ config MEDIA_IMX
 
 config VIDEO_IMX_IPU_COMMON
 	tristate
+
+config VIDEO_IMX_IPU_CSI
+	tristate "i.MX5/6 CMOS Sensor Interface driver"
+	depends on VIDEO_DEV && IMX_IPUV3_CORE && MEDIA_IMX
+	select VIDEO_IMX_IPUV3
+	---help---
+	  This is a v4l2 subdevice driver for two CSI modules in each IPUv3.
diff --git a/drivers/media/platform/imx/Makefile b/drivers/media/platform/imx/Makefile
index 0ba601a..82a3616 100644
--- a/drivers/media/platform/imx/Makefile
+++ b/drivers/media/platform/imx/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_MEDIA_IMX)			+= imx-media.o
 obj-$(CONFIG_VIDEO_IMX_IPU_COMMON)	+= imx-ipu.o
+obj-$(CONFIG_VIDEO_IMX_IPU_CSI)		+= imx-ipuv3-csi.o
diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
new file mode 100644
index 0000000..83e0511
--- /dev/null
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -0,0 +1,547 @@
+/*
+ * i.MX IPUv3 CSI V4L2 Subdevice Driver
+ *
+ * Copyright (C) 2016, Pengutronix, Philipp Zabel <kernel@pengutronix.de>
+ *
+ * Based on code
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
+#include <media/v4l2-of.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include <video/imx-ipu-v3.h>
+
+#include "imx-ipu.h"
+
+#define DRIVER_NAME "imx-ipuv3-csi"
+
+struct ipucsi {
+	struct v4l2_subdev		subdev;
+
+	struct device			*dev;
+	u32				id;
+
+	struct ipu_csi			*csi;
+	struct ipu_soc			*ipu;
+	struct v4l2_of_endpoint		endpoint;
+	enum ipu_csi_dest		csi_dest;
+
+	struct media_pad		subdev_pad[2];
+	struct v4l2_mbus_framefmt	format_mbus[2];
+	struct v4l2_fract		timeperframe[2];
+};
+
+static int ipu_csi_get_mbus_config(struct ipucsi *ipucsi,
+				   struct v4l2_mbus_config *config)
+{
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret;
+
+	/*
+	 * Retrieve media bus configuration from the entity connected directly
+	 * to the CSI subdev sink pad.
+	 */
+	pad = media_entity_remote_pad(&ipucsi->subdev_pad[0]);
+	if (!pad) {
+		dev_err(ipucsi->dev,
+			"failed to retrieve mbus config from source entity\n");
+		return -ENODEV;
+	}
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, config);
+	if (ret == -ENOIOCTLCMD) {
+		/* Fall back to static mbus configuration from device tree */
+		config->type = ipucsi->endpoint.bus_type;
+		config->flags = ipucsi->endpoint.bus.parallel.flags;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static struct v4l2_mbus_framefmt *
+__ipucsi_get_pad_format(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg,
+			unsigned int pad, u32 which)
+{
+	struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
+
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &ipucsi->format_mbus[pad ? 1 : 0];
+	default:
+		return NULL;
+	}
+}
+
+static int ipucsi_subdev_log_status(struct v4l2_subdev *subdev)
+{
+	struct ipucsi *ipucsi = container_of(subdev, struct ipucsi, subdev);
+
+	ipu_csi_dump(ipucsi->csi);
+
+	return 0;
+}
+
+static int ipucsi_subdev_get_format(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *sdformat)
+{
+	sdformat->format = *__ipucsi_get_pad_format(sd, cfg, sdformat->pad,
+						    sdformat->which);
+	return 0;
+}
+
+static bool ipucsi_mbus_code_supported(const u32 mbus_code)
+{
+	static const u32 mbus_codes[] = {
+		MEDIA_BUS_FMT_Y8_1X8,
+		MEDIA_BUS_FMT_Y10_1X10,
+		MEDIA_BUS_FMT_Y12_1X12,
+		MEDIA_BUS_FMT_UYVY8_2X8,
+		MEDIA_BUS_FMT_YUYV8_2X8,
+		MEDIA_BUS_FMT_UYVY8_1X16,
+		MEDIA_BUS_FMT_YUYV8_1X16,
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mbus_codes); i++) {
+		if (mbus_code == mbus_codes[i])
+			return true;
+	}
+
+	return false;
+}
+
+static int ipucsi_subdev_set_format(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *sdformat)
+{
+	struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
+	struct v4l2_mbus_framefmt *mbusformat;
+	unsigned int width, height;
+	bool supported;
+
+	supported = ipucsi_mbus_code_supported(sdformat->format.code);
+	if (!supported)
+		return -EINVAL;
+
+	mbusformat = __ipucsi_get_pad_format(sd, cfg, sdformat->pad,
+					     sdformat->which);
+
+	if (sdformat->pad == 0) {
+		width = clamp_t(unsigned int, sdformat->format.width, 16, 8192);
+		height = clamp_t(unsigned int, sdformat->format.height, 16, 4096);
+		mbusformat->field = sdformat->format.field ?: V4L2_FIELD_NONE;
+		mbusformat->colorspace = sdformat->format.colorspace ?:
+					 V4L2_COLORSPACE_SRGB;
+	} else {
+		struct v4l2_mbus_framefmt *infmt = &ipucsi->format_mbus[0];
+
+		width = infmt->width;
+		height = infmt->height;
+		mbusformat->field = infmt->field;
+		mbusformat->colorspace = infmt->colorspace;
+	}
+
+	mbusformat->width = width;
+	mbusformat->height = height;
+	mbusformat->code = sdformat->format.code;
+
+	if (mbusformat->field == V4L2_FIELD_SEQ_TB &&
+	    mbusformat->width == 720 && mbusformat->height == 480 &&
+	    ipucsi->endpoint.bus_type == V4L2_MBUS_BT656) {
+		/* We capture NTSC bottom field first */
+		mbusformat->field = V4L2_FIELD_SEQ_BT;
+	}
+
+	sdformat->format = *mbusformat;
+
+	return 0;
+}
+
+static int ipucsi_subdev_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
+	struct v4l2_subdev *upstream_sd;
+	struct media_pad *pad;
+	int ret;
+
+	pad = media_entity_remote_pad(&sd->entity.pads[0]);
+	if (!pad) {
+		dev_err(ipucsi->dev, "Failed to find remote source pad\n");
+		return -ENOLINK;
+	}
+
+	if (!is_media_entity_v4l2_subdev(pad->entity)) {
+		dev_err(ipucsi->dev, "Upstream entity is not a v4l2 subdev\n");
+		return -ENODEV;
+	}
+
+	upstream_sd = media_entity_to_v4l2_subdev(pad->entity);
+
+	ret = v4l2_subdev_call(upstream_sd, video, s_stream, enable);
+	if (ret)
+		return ret;
+
+	if (enable) {
+		struct v4l2_mbus_framefmt *fmt = ipucsi->format_mbus;
+		struct v4l2_mbus_config mbus_config;
+		struct v4l2_rect window;
+		bool mux_mct;
+		int ret;
+
+		ret = ipu_csi_get_mbus_config(ipucsi, &mbus_config);
+		if (ret)
+			return ret;
+
+		window.left = 0;
+		window.top = 0;
+		window.width = fmt[0].width;
+		window.height = fmt[0].height;
+		ipu_csi_set_window(ipucsi->csi, &window);
+
+		/* Is CSI data source MCT (MIPI)? */
+		mux_mct = (mbus_config.type == V4L2_MBUS_CSI2);
+
+		ipu_set_csi_src_mux(ipucsi->ipu, ipucsi->id, mux_mct);
+		if (mux_mct)
+			ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0,
+						  &fmt[0]);
+
+		ret = ipu_csi_init_interface(ipucsi->csi, &mbus_config,
+					     &fmt[0]);
+		if (ret) {
+			dev_err(ipucsi->dev, "Failed to initialize CSI\n");
+			return ret;
+		}
+
+		ipu_csi_set_dest(ipucsi->csi, ipucsi->csi_dest);
+
+		ipu_csi_enable(ipucsi->csi);
+	} else {
+		ipu_csi_disable(ipucsi->csi);
+	}
+
+	return 0;
+}
+
+static int ipucsi_subdev_g_frame_interval(struct v4l2_subdev *subdev,
+					  struct v4l2_subdev_frame_interval *fi)
+{
+	struct ipucsi *ipucsi = container_of(subdev, struct ipucsi, subdev);
+
+	if (fi->pad > 4)
+		return -EINVAL;
+
+	fi->interval = ipucsi->timeperframe[(fi->pad == 0) ? 0 : 1];
+
+	return 0;
+}
+
+/*
+ * struct ipucsi_skip_desc - CSI frame skipping descriptor
+ * @keep - number of frames kept per max_ratio frames
+ * @max_ratio - width of skip_smfc, written to MAX_RATIO bitfield
+ * @skip_smfc - skip pattern written to the SKIP_SMFC bitfield
+ */
+struct ipucsi_skip_desc {
+	u8 keep;
+	u8 max_ratio;
+	u8 skip_smfc;
+};
+
+static const struct ipucsi_skip_desc ipucsi_skip[12] = {
+	{ 1, 1, 0x00 }, /* Keep all frames */
+	{ 5, 6, 0x10 }, /* Skip every sixth frame */
+	{ 4, 5, 0x08 }, /* Skip every fifth frame */
+	{ 3, 4, 0x04 }, /* Skip every fourth frame */
+	{ 2, 3, 0x02 }, /* Skip every third frame */
+	{ 3, 5, 0x0a }, /* Skip frames 1 and 3 of every 5 */
+	{ 1, 2, 0x01 }, /* Skip every second frame */
+	{ 2, 5, 0x0b }, /* Keep frames 1 and 4 of every 5 */
+	{ 1, 3, 0x03 }, /* Keep one in three frames */
+	{ 1, 4, 0x07 }, /* Keep one in four frames */
+	{ 1, 5, 0x0f }, /* Keep one in five frames */
+	{ 1, 6, 0x1f }, /* Keep one in six frames */
+};
+
+static int ipucsi_subdev_s_frame_interval(struct v4l2_subdev *subdev,
+					  struct v4l2_subdev_frame_interval *fi)
+{
+	struct ipucsi *ipucsi = container_of(subdev, struct ipucsi, subdev);
+	const struct ipucsi_skip_desc *skip;
+	struct v4l2_fract *want, *in;
+	u32 min_err = UINT_MAX;
+	int i, best_i = 0;
+	u64 want_us;
+
+	if (fi->pad > 4)
+		return -EINVAL;
+
+	if (fi->pad == 0) {
+		/* Believe what we are told about the input frame rate */
+		ipucsi->timeperframe[0] = fi->interval;
+		/* Reset output frame rate to input frame rate */
+		ipucsi->timeperframe[1] = fi->interval;
+		return 0;
+	}
+
+	want = &fi->interval;
+	in = &ipucsi->timeperframe[0];
+
+	if (want->numerator == 0 || want->denominator == 0 ||
+	    in->denominator == 0) {
+		ipucsi->timeperframe[1] = ipucsi->timeperframe[0];
+		fi->interval = ipucsi->timeperframe[1];
+		return 0;
+	}
+
+	want_us = 1000000ULL * want->numerator;
+	do_div(want_us, want->denominator);
+
+	/* Find the reduction closest to the requested timeperframe */
+	for (i = 0; i < ARRAY_SIZE(ipucsi_skip); i++) {
+		u64 tmp;
+		u32 err;
+
+		skip = &ipucsi_skip[i];
+		tmp = 1000000ULL * in->numerator * skip->max_ratio;
+		do_div(tmp, in->denominator * skip->keep);
+		err = (tmp > want_us) ? (tmp - want_us) : (want_us - tmp);
+		if (err < min_err) {
+			min_err = err;
+			best_i = i;
+		}
+	}
+
+	skip = &ipucsi_skip[best_i];
+
+	ipu_csi_set_skip_smfc(ipucsi->csi, skip->skip_smfc, skip->max_ratio - 1,
+			      0);
+
+	fi->interval.numerator = in->numerator * skip->max_ratio;
+	fi->interval.denominator = in->denominator * skip->keep;
+	ipucsi->timeperframe[1] = fi->interval;
+
+	dev_dbg(ipucsi->dev, "skip: %d/%d -> %d/%d frames:%d pattern:0x%x\n",
+	       in->numerator, in->denominator,
+	       fi->interval.numerator, fi->interval.denominator,
+	       skip->max_ratio, skip->skip_smfc);
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops ipucsi_subdev_core_ops = {
+	.log_status = ipucsi_subdev_log_status,
+};
+
+static struct v4l2_subdev_pad_ops ipucsi_subdev_pad_ops = {
+	.get_fmt = ipucsi_subdev_get_format,
+	.set_fmt = ipucsi_subdev_set_format,
+};
+
+static struct v4l2_subdev_video_ops ipucsi_subdev_video_ops = {
+	.s_stream = ipucsi_subdev_s_stream,
+	.g_frame_interval = ipucsi_subdev_g_frame_interval,
+	.s_frame_interval = ipucsi_subdev_s_frame_interval,
+};
+
+static const struct v4l2_subdev_ops ipucsi_subdev_ops = {
+	.core   = &ipucsi_subdev_core_ops,
+	.pad    = &ipucsi_subdev_pad_ops,
+	.video  = &ipucsi_subdev_video_ops,
+};
+
+static int ipu_csi_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+			      const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
+
+	ipucsi->csi_dest = IPU_CSI_DEST_IDMAC;
+
+	return 0;
+}
+
+struct media_entity_operations ipucsi_entity_ops = {
+	.link_setup = ipu_csi_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static int ipu_csi_registered(struct v4l2_subdev *sd)
+{
+	struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
+	struct device_node *rpp;
+
+	/*
+	 * Add source subdevice to asynchronous subdevice waiting list.
+	 */
+	rpp = of_graph_get_remote_port_parent(ipucsi->endpoint.base.local_node);
+	if (rpp) {
+		struct v4l2_async_subdev *asd;
+
+		asd = devm_kzalloc(sd->dev, sizeof(*asd), GFP_KERNEL);
+		if (!asd) {
+			of_node_put(rpp);
+			return -ENOMEM;
+		}
+
+		asd->match_type = V4L2_ASYNC_MATCH_OF;
+		asd->match.of.node = rpp;
+
+		__v4l2_async_notifier_add_subdev(sd->notifier, asd);
+	}
+
+	return 0;
+}
+
+struct v4l2_subdev_internal_ops ipu_csi_internal_ops = {
+	.registered = ipu_csi_registered,
+};
+
+static int ipucsi_subdev_init(struct ipucsi *ipucsi, struct device_node *node)
+{
+	struct device_node *endpoint;
+	int ret;
+
+	v4l2_subdev_init(&ipucsi->subdev, &ipucsi_subdev_ops);
+	ipucsi->subdev.dev = ipucsi->dev;
+
+	snprintf(ipucsi->subdev.name, sizeof(ipucsi->subdev.name), "%s%d %s%d",
+		 "IPU", ipu_get_num(ipucsi->ipu), "CSI", ipucsi->id);
+
+	endpoint = of_get_next_child(node, NULL);
+	if (endpoint)
+		v4l2_of_parse_endpoint(endpoint, &ipucsi->endpoint);
+
+	ipucsi->subdev.entity.ops = &ipucsi_entity_ops;
+
+	ipucsi->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	ipucsi->subdev.of_node = node;
+
+	ipucsi->subdev_pad[0].flags = MEDIA_PAD_FL_SINK;
+	ipucsi->subdev_pad[1].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&ipucsi->subdev.entity, 2,
+				     ipucsi->subdev_pad);
+	if (ret < 0)
+		return ret;
+
+	ipucsi->subdev.internal_ops = &ipu_csi_internal_ops;
+	ret = v4l2_async_register_subdev(&ipucsi->subdev);
+	if (ret < 0) {
+		dev_err(ipucsi->dev, "Failed to register CSI subdev \"%s\": %d\n",
+			ipucsi->subdev.name, ret);
+	}
+
+	return ret;
+}
+
+static u64 camera_mask = DMA_BIT_MASK(32);
+
+static int ipucsi_probe(struct platform_device *pdev)
+{
+	struct ipu_client_platformdata *pdata = pdev->dev.platform_data;
+	struct ipu_soc *ipu = dev_get_drvdata(pdev->dev.parent);
+	struct ipucsi *ipucsi;
+	int ret;
+	struct device_node *node;
+
+	pdev->dev.dma_mask = &camera_mask;
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
+	if (!pdata)
+		return -EINVAL;
+
+	ipucsi = devm_kzalloc(&pdev->dev, sizeof(*ipucsi), GFP_KERNEL);
+	if (!ipucsi)
+		return -ENOMEM;
+
+	ipucsi->ipu = ipu;
+	ipucsi->id = pdata->csi;
+	ipucsi->dev = &pdev->dev;
+
+	node = of_graph_get_port_by_id(pdev->dev.parent->of_node, ipucsi->id);
+	if (!node) {
+		dev_err(&pdev->dev, "cannot find node port@%d\n", ipucsi->id);
+		return -ENODEV;
+	}
+
+	ipucsi->csi = ipu_csi_get(ipu, ipucsi->id);
+	if (IS_ERR(ipucsi->csi))
+		return PTR_ERR(ipucsi->csi);
+
+	ret = ipucsi_subdev_init(ipucsi, node);
+	if (ret)
+		return ret;
+
+	of_node_put(node);
+
+	platform_set_drvdata(pdev, ipucsi);
+
+	dev_info(&pdev->dev, "loaded\n");
+
+	return 0;
+}
+
+static struct platform_driver ipucsi_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+	},
+	.probe = ipucsi_probe,
+};
+
+static int __init ipucsi_init(void)
+{
+	return platform_driver_register(&ipucsi_driver);
+}
+
+static void __exit ipucsi_exit(void)
+{
+	return platform_driver_unregister(&ipucsi_driver);
+}
+
+subsys_initcall(ipucsi_init);
+module_exit(ipucsi_exit);
+
+MODULE_DESCRIPTION("i.MX IPUv3 capture interface driver");
+MODULE_AUTHOR("Sascha Hauer, Pengutronix");
+MODULE_AUTHOR("Philipp Zabel, Pengutronix");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.9.3

