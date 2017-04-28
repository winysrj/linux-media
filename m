Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56397 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S969469AbdD1ONh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 10:13:37 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 2/2] [media] platform: add video-multiplexer subdevice driver
Date: Fri, 28 Apr 2017 16:13:30 +0200
Message-Id: <20170428141330.16187-2-p.zabel@pengutronix.de>
In-Reply-To: <20170428141330.16187-1-p.zabel@pengutronix.de>
References: <20170428141330.16187-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver can handle SoC internal and external video bus multiplexers,
controlled by mux controllers provided by the mux controller framework,
such as MMIO register bitfields or GPIOs. The subdevice passes through
the mbus configuration of the active input to the output side.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
This has been last sent as part of the i.MX media series.

Changes since https://patchwork.kernel.org/patch/9647869/:
 - Split out the actual mux operation to be provided by the mux controller
   framework [1]. GPIO and MMIO control can be provided by individual mux
   controller drivers [2][3].
   [1] https://patchwork.kernel.org/patch/9695837/
   [2] https://patchwork.kernel.org/patch/9695839/
   [3] https://patchwork.kernel.org/patch/9704509/
 - Shortened 'video-multiplexer' to 'video-mux', replaced all instances of
   vidsw with video_mux.
 - Made the mux inactive by default, only activated by user interaction.
 - Added CONFIG_OF and CONFIG_MULTIPLEXER dependencies.
 - Reuse subdev.entity.num_pads instead of keeping our own count.
 - Removed implicit link disabling. Instead, trying to enable a second
   sink pad link yields -EBUSY.
 - Merged _async_init into _probe.
 - Removed superfluous pad index check from _set_format.
 - Added is_source_pad helper to tell source and sink pads apart.
 - Removed test for status property in endpoint nodes. Disable the remote
   device or sever the endpoint link to disable a sink pad.
---
 drivers/media/platform/Kconfig     |   6 +
 drivers/media/platform/Makefile    |   2 +
 drivers/media/platform/video-mux.c | 341 +++++++++++++++++++++++++++++++++++++
 3 files changed, 349 insertions(+)
 create mode 100644 drivers/media/platform/video-mux.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c9106e105baba..b046a6d39fee5 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -74,6 +74,12 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
+config VIDEO_MUX
+	tristate "Video Multiplexer"
+	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER && MULTIPLEXER
+	help
+	  This driver provides support for N:1 video bus multiplexers.
+
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 349ddf6a69da2..fd2735ca3ff75 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
 
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
+obj-$(CONFIG_VIDEO_MUX)			+= video-mux.o
+
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
new file mode 100644
index 0000000000000..419541729f67e
--- /dev/null
+++ b/drivers/media/platform/video-mux.c
@@ -0,0 +1,341 @@
+/*
+ * video stream multiplexer controlled via mux control
+ *
+ * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
+ * Copyright (C) 2016 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/mux/consumer.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+
+struct video_mux {
+	struct v4l2_subdev subdev;
+	struct media_pad *pads;
+	struct v4l2_mbus_framefmt *format_mbus;
+	struct v4l2_of_endpoint *endpoint;
+	struct mux_control *mux;
+	int active;
+};
+
+static inline struct video_mux *v4l2_subdev_to_video_mux(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct video_mux, subdev);
+}
+
+static inline bool is_source_pad(struct video_mux *vmux, unsigned int pad)
+{
+	return pad == vmux->subdev.entity.num_pads - 1;
+}
+
+static int video_mux_link_setup(struct media_entity *entity,
+				const struct media_pad *local,
+				const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	int ret;
+
+	/*
+	 * The mux state is determined by the enabled sink pad link.
+	 * Enabling or disabling the source pad link has no effect.
+	 */
+	if (is_source_pad(vmux, local->index))
+		return 0;
+
+	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
+		remote->entity->name, remote->index, local->entity->name,
+		local->index, flags & MEDIA_LNK_FL_ENABLED);
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (vmux->active == local->index)
+			return 0;
+
+		if (vmux->active >= 0)
+			return -EBUSY;
+
+		dev_dbg(sd->dev, "setting %d active\n", local->index);
+		ret = mux_control_try_select(vmux->mux, local->index);
+		if (ret < 0)
+			return ret;
+		vmux->active = local->index;
+	} else {
+		if (vmux->active != local->index)
+			return 0;
+
+		dev_dbg(sd->dev, "going inactive\n");
+		mux_control_deselect(vmux->mux);
+		vmux->active = -1;
+	}
+
+	return 0;
+}
+
+static struct media_entity_operations video_mux_ops = {
+	.link_setup = video_mux_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static bool video_mux_endpoint_disabled(struct device_node *ep)
+{
+	struct device_node *rpp = of_graph_get_remote_port_parent(ep);
+
+	return !of_device_is_available(rpp);
+}
+
+static int video_mux_g_mbus_config(struct v4l2_subdev *sd,
+				   struct v4l2_mbus_config *cfg)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	struct v4l2_of_endpoint *endpoint;
+	struct media_pad *pad;
+	int ret;
+
+	if (vmux->active == -1) {
+		dev_err(sd->dev, "no configuration for inactive mux\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Retrieve media bus configuration from the entity connected to the
+	 * active input
+	 */
+	pad = media_entity_remote_pad(&vmux->pads[vmux->active]);
+	if (pad) {
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		ret = v4l2_subdev_call(sd, video, g_mbus_config, cfg);
+		if (ret == -ENOIOCTLCMD)
+			pad = NULL;
+		else if (ret < 0) {
+			dev_err(sd->dev, "failed to get source configuration\n");
+			return ret;
+		}
+	}
+	if (!pad) {
+		endpoint = &vmux->endpoint[vmux->active];
+
+		/* Mirror the input side on the output side */
+		cfg->type = endpoint->bus_type;
+		if (cfg->type == V4L2_MBUS_PARALLEL ||
+		    cfg->type == V4L2_MBUS_BT656)
+			cfg->flags = endpoint->bus.parallel.flags;
+	}
+
+	return 0;
+}
+
+static int video_mux_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	struct v4l2_subdev *upstream_sd;
+	struct media_pad *pad;
+
+	if (vmux->active == -1) {
+		dev_err(sd->dev, "Can not start streaming on inactive mux\n");
+		return -EINVAL;
+	}
+
+	pad = media_entity_remote_pad(&sd->entity.pads[vmux->active]);
+	if (!pad) {
+		dev_err(sd->dev, "Failed to find remote source pad\n");
+		return -ENOLINK;
+	}
+
+	if (!is_media_entity_v4l2_subdev(pad->entity)) {
+		dev_err(sd->dev, "Upstream entity is not a v4l2 subdev\n");
+		return -ENODEV;
+	}
+
+	upstream_sd = media_entity_to_v4l2_subdev(pad->entity);
+
+	return v4l2_subdev_call(upstream_sd, video, s_stream, enable);
+}
+
+static const struct v4l2_subdev_video_ops video_mux_subdev_video_ops = {
+	.g_mbus_config = video_mux_g_mbus_config,
+	.s_stream = video_mux_s_stream,
+};
+
+static struct v4l2_mbus_framefmt *
+__video_mux_get_pad_format(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
+			   unsigned int pad, u32 which)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &vmux->format_mbus[pad];
+	default:
+		return NULL;
+	}
+}
+
+static int video_mux_get_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	sdformat->format = *__video_mux_get_pad_format(sd, cfg, sdformat->pad,
+						   sdformat->which);
+	return 0;
+}
+
+static int video_mux_set_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+
+	mbusformat = __video_mux_get_pad_format(sd, cfg, sdformat->pad,
+					    sdformat->which);
+	if (!mbusformat)
+		return -EINVAL;
+
+	/* Source pad mirrors active sink pad, no limitations on sink pads */
+	if (is_source_pad(vmux, sdformat->pad) && vmux->active >= 0)
+		sdformat->format = vmux->format_mbus[vmux->active];
+
+	*mbusformat = sdformat->format;
+
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops video_mux_pad_ops = {
+	.get_fmt = video_mux_get_format,
+	.set_fmt = video_mux_set_format,
+};
+
+static struct v4l2_subdev_ops video_mux_subdev_ops = {
+	.pad = &video_mux_pad_ops,
+	.video = &video_mux_subdev_video_ops,
+};
+
+static int video_mux_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct v4l2_of_endpoint endpoint;
+	struct device_node *ep;
+	struct video_mux *vmux;
+	unsigned int num_pads = 0;
+	int ret;
+	int i;
+
+	vmux = devm_kzalloc(dev, sizeof(*vmux), GFP_KERNEL);
+	if (!vmux)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, vmux);
+
+	v4l2_subdev_init(&vmux->subdev, &video_mux_subdev_ops);
+	snprintf(vmux->subdev.name, sizeof(vmux->subdev.name), "%s", np->name);
+	vmux->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	vmux->subdev.dev = dev;
+
+	/*
+	 * The largest numbered port is the output port. It determines
+	 * total number of pads.
+	 */
+	for_each_endpoint_of_node(np, ep) {
+		of_graph_parse_endpoint(ep, &endpoint.base);
+		num_pads = max(num_pads, endpoint.base.port + 1);
+	}
+
+	if (num_pads < 2) {
+		dev_err(dev, "Not enough ports %d\n", num_pads);
+		return -EINVAL;
+	}
+
+	vmux->mux = devm_mux_control_get(dev, NULL);
+	if (IS_ERR(vmux->mux)) {
+		ret = PTR_ERR(vmux->mux);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get mux: %d\n", ret);
+		return ret;
+	}
+
+	vmux->active = -1;
+	vmux->pads = devm_kzalloc(dev, sizeof(*vmux->pads) * num_pads,
+				  GFP_KERNEL);
+	vmux->format_mbus = devm_kzalloc(dev, sizeof(*vmux->format_mbus) *
+					 num_pads, GFP_KERNEL);
+	vmux->endpoint = devm_kzalloc(dev, sizeof(*vmux->endpoint) *
+				      (num_pads - 1), GFP_KERNEL);
+
+	for (i = 0; i < num_pads - 1; i++)
+		vmux->pads[i].flags = MEDIA_PAD_FL_SINK;
+	vmux->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
+
+	vmux->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
+	ret = media_entity_pads_init(&vmux->subdev.entity, num_pads,
+				     vmux->pads);
+	if (ret < 0)
+		return ret;
+
+	vmux->subdev.entity.ops = &video_mux_ops;
+
+	for_each_endpoint_of_node(np, ep) {
+		v4l2_of_parse_endpoint(ep, &endpoint);
+
+		if (video_mux_endpoint_disabled(ep)) {
+			dev_dbg(dev, "port %d disabled\n", endpoint.base.port);
+			continue;
+		}
+
+		vmux->endpoint[endpoint.base.port] = endpoint;
+	}
+
+	return v4l2_async_register_subdev(&vmux->subdev);
+}
+
+static int video_mux_remove(struct platform_device *pdev)
+{
+	struct video_mux *vmux = platform_get_drvdata(pdev);
+	struct v4l2_subdev *sd = &vmux->subdev;
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+
+	return 0;
+}
+
+static const struct of_device_id video_mux_dt_ids[] = {
+	{ .compatible = "video-mux", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, video_mux_dt_ids);
+
+static struct platform_driver video_mux_driver = {
+	.probe		= video_mux_probe,
+	.remove		= video_mux_remove,
+	.driver		= {
+		.of_match_table = video_mux_dt_ids,
+		.name = "video-mux",
+	},
+};
+
+module_platform_driver(video_mux_driver);
+
+MODULE_DESCRIPTION("video stream multiplexer");
+MODULE_AUTHOR("Sascha Hauer, Pengutronix");
+MODULE_AUTHOR("Philipp Zabel, Pengutronix");
+MODULE_LICENSE("GPL");
-- 
2.11.0
