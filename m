Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57903 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751066AbdFGJdy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 05:33:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v8 3/3] [media] platform: add video-multiplexer subdevice driver
Date: Wed,  7 Jun 2017 11:33:45 +0200
Message-Id: <1496828025-4848-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1496828025-4848-1-git-send-email-p.zabel@pengutronix.de>
References: <1496828025-4848-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver can handle SoC internal and external video bus multiplexers,
controlled by mux controllers provided by the mux controller framework,
such as MMIO register bitfields or GPIOs. The subdevice passes through
the mbus configuration of the active input to the output side.

Since the mux framework is not yet merged, this driver contains
temporary mmio-mux support to work without the framework. The driver
should be converted to use the multiplexer API once the "mux: minimal
mux subsystem" and "mux: mmio-based syscon mux controller" patches are
merged.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
No changes since v7 [1]. No changes necessary for the recently merged V4L2
fwnode API.

[1] https://patchwork.linuxtv.org/patch/41537/
---
 drivers/media/platform/Kconfig     |   6 +
 drivers/media/platform/Makefile    |   2 +
 drivers/media/platform/video-mux.c | 334 +++++++++++++++++++++++++++++++++++++
 3 files changed, 342 insertions(+)
 create mode 100644 drivers/media/platform/video-mux.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index a4b7cefbde32d..23dfec53dc736 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -74,6 +74,12 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
+config VIDEO_MUX
+	tristate "Video Multiplexer"
+	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	help
+	  This driver provides support for N:1 video bus multiplexers.
+
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 231f3c2894c9d..a9ff99d595b86 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -28,6 +28,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
 
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
+obj-$(CONFIG_VIDEO_MUX)			+= video-mux.o
+
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
new file mode 100644
index 0000000000000..665744716f73b
--- /dev/null
+++ b/drivers/media/platform/video-mux.c
@@ -0,0 +1,334 @@
+/*
+ * video stream multiplexer controlled via mux control
+ *
+ * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
+ * Copyright (C) 2016-2017 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
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
+#include <linux/mutex.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+struct video_mux {
+	struct v4l2_subdev subdev;
+	struct media_pad *pads;
+	struct v4l2_mbus_framefmt *format_mbus;
+	struct regmap_field *field;
+	struct mutex lock;
+	int active;
+};
+
+static inline struct video_mux *v4l2_subdev_to_video_mux(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct video_mux, subdev);
+}
+
+static int video_mux_link_setup(struct media_entity *entity,
+				const struct media_pad *local,
+				const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	int ret = 0;
+
+	/*
+	 * The mux state is determined by the enabled sink pad link.
+	 * Enabling or disabling the source pad link has no effect.
+	 */
+	if (local->flags & MEDIA_PAD_FL_SOURCE)
+		return 0;
+
+	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
+		remote->entity->name, remote->index, local->entity->name,
+		local->index, flags & MEDIA_LNK_FL_ENABLED);
+
+	mutex_lock(&vmux->lock);
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (vmux->active == local->index)
+			goto out;
+
+		if (vmux->active >= 0) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		dev_dbg(sd->dev, "setting %d active\n", local->index);
+		ret = regmap_field_write(vmux->field, local->index);
+		if (ret < 0)
+			goto out;
+		vmux->active = local->index;
+	} else {
+		if (vmux->active != local->index)
+			goto out;
+
+		dev_dbg(sd->dev, "going inactive\n");
+		vmux->active = -1;
+	}
+
+out:
+	mutex_unlock(&vmux->lock);
+	return ret;
+}
+
+static const struct media_entity_operations video_mux_ops = {
+	.link_setup = video_mux_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
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
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+
+	mutex_lock(&vmux->lock);
+
+	sdformat->format = *__video_mux_get_pad_format(sd, cfg, sdformat->pad,
+						       sdformat->which);
+
+	mutex_unlock(&vmux->lock);
+
+	return 0;
+}
+
+static int video_mux_set_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+	struct media_pad *pad = &vmux->pads[sdformat->pad];
+
+	mbusformat = __video_mux_get_pad_format(sd, cfg, sdformat->pad,
+					    sdformat->which);
+	if (!mbusformat)
+		return -EINVAL;
+
+	mutex_lock(&vmux->lock);
+
+	/* Source pad mirrors active sink pad, no limitations on sink pads */
+	if ((pad->flags & MEDIA_PAD_FL_SOURCE) && vmux->active >= 0)
+		sdformat->format = vmux->format_mbus[vmux->active];
+
+	*mbusformat = sdformat->format;
+
+	mutex_unlock(&vmux->lock);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops video_mux_pad_ops = {
+	.get_fmt = video_mux_get_format,
+	.set_fmt = video_mux_set_format,
+};
+
+static const struct v4l2_subdev_ops video_mux_subdev_ops = {
+	.pad = &video_mux_pad_ops,
+	.video = &video_mux_subdev_video_ops,
+};
+
+static int video_mux_probe_mmio_mux(struct video_mux *vmux)
+{
+	struct device *dev = vmux->subdev.dev;
+	struct of_phandle_args args;
+	struct reg_field field;
+	struct regmap *regmap;
+	u32 reg, mask;
+	int ret;
+
+	ret = of_parse_phandle_with_args(dev->of_node, "mux-controls",
+					 "#mux-control-cells", 0, &args);
+	if (ret)
+		return ret;
+
+	if (!of_device_is_compatible(args.np, "mmio-mux"))
+		return -EINVAL;
+
+	regmap = syscon_node_to_regmap(args.np->parent);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	ret = of_property_read_u32_index(args.np, "mux-reg-masks",
+					 2 * args.args[0], &reg);
+	if (!ret)
+		ret = of_property_read_u32_index(args.np, "mux-reg-masks",
+						 2 * args.args[0] + 1, &mask);
+	if (ret < 0)
+		return ret;
+
+	field.reg = reg;
+	field.msb = fls(mask) - 1;
+	field.lsb = ffs(mask) - 1;
+
+	vmux->field = devm_regmap_field_alloc(dev, regmap, field);
+	if (IS_ERR(vmux->field))
+		return PTR_ERR(vmux->field);
+
+	return 0;
+}
+
+static int video_mux_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
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
+		struct of_endpoint endpoint;
+
+		of_graph_parse_endpoint(ep, &endpoint);
+		num_pads = max(num_pads, endpoint.port + 1);
+	}
+
+	if (num_pads < 2) {
+		dev_err(dev, "Not enough ports %d\n", num_pads);
+		return -EINVAL;
+	}
+
+	ret = video_mux_probe_mmio_mux(vmux);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get mux: %d\n", ret);
+		return ret;
+	}
+
+	mutex_init(&vmux->lock);
+	vmux->active = -1;
+	vmux->pads = devm_kcalloc(dev, num_pads, sizeof(*vmux->pads),
+				  GFP_KERNEL);
+	vmux->format_mbus = devm_kcalloc(dev, num_pads,
+					 sizeof(*vmux->format_mbus),
+					 GFP_KERNEL);
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
