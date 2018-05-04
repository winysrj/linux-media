Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33821 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbeEDMtO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 08:49:14 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH 2/2] media: platform: add driver for TI SCAN921226H video deserializer
Date: Fri,  4 May 2018 14:49:03 +0200
Message-Id: <20180504124903.6276-3-jlu@pengutronix.de>
In-Reply-To: <20180504124903.6276-1-jlu@pengutronix.de>
References: <20180504124903.6276-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although one could have a working setup with a sensor such as the
MT9V024 connected via LVDS to the deserializer and then via parallel to
the SoC's camera interface even without having a driver for the
deserializer, controlling the deserializer's state is needed when
multiple cameras share the parallel bus. By enabling only one at a time,
a camera can be selected at runtime using mediactl.

This driver will en-/disable the deserializer via GPIOs as needed
depending on the media entity link state.

The current v4l2-compliance doesn't report any warnings or errors.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/media/platform/Kconfig       |   7 +
 drivers/media/platform/Makefile      |   2 +
 drivers/media/platform/scan921226h.c | 353 +++++++++++++++++++++++++++
 3 files changed, 362 insertions(+)
 create mode 100644 drivers/media/platform/scan921226h.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7a1cf8a1b01..f321f895d173 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -384,6 +384,13 @@ config VIDEO_STI_DELTA_DRIVER
 
 endif # VIDEO_STI_DELTA
 
+config VIDEO_SCAN921226H
+	tristate "TI SCAN921226H LVDS deserializer driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	help
+	      Enables support for the SCAN921226H LVDS deserializer, which is
+	      controlled via two GPIOs (output enable and power down).
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 932515df4477..45f90189a193 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -53,6 +53,8 @@ obj-y					+= stm32/
 
 obj-y					+= davinci/
 
+obj-$(CONFIG_VIDEO_SCAN921226H)		+= scan921226h.o
+
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
diff --git a/drivers/media/platform/scan921226h.c b/drivers/media/platform/scan921226h.c
new file mode 100644
index 000000000000..59fcd55ceaa2
--- /dev/null
+++ b/drivers/media/platform/scan921226h.c
@@ -0,0 +1,353 @@
+/*
+ * TI SCAN921226H deserializer driver
+ *
+ * Copyright (C) 2018 Pengutronix, Jan Luebbe <kernel@pengutronix.de>
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
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+struct video_des {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[2];
+	struct v4l2_mbus_framefmt format_mbus;
+	struct gpio_desc *npwrdn_gpio;
+	struct gpio_desc *enable_gpio;
+	struct mutex lock;
+	int active;
+};
+
+static inline struct video_des *v4l2_subdev_to_video_des(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct video_des, subdev);
+}
+
+static int video_des_link_setup(struct media_entity *entity,
+				const struct media_pad *local,
+				const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
+
+	/*
+	 * The deserializer state is determined by the enabled source pad link.
+	 * Enabling or disabling the sink pad link has no effect.
+	 */
+	if (local->flags & MEDIA_PAD_FL_SINK)
+		return 0;
+
+	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
+		remote->entity->name, remote->index, local->entity->name,
+		local->index, flags & MEDIA_LNK_FL_ENABLED);
+
+	mutex_lock(&vdes->lock);
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		dev_dbg(sd->dev, "going active\n");
+		gpiod_set_value_cansleep(vdes->npwrdn_gpio, 1);
+		udelay(10); /* wait for the PLL to lock */
+		gpiod_set_value_cansleep(vdes->enable_gpio, 1);
+	} else {
+		dev_dbg(sd->dev, "going inactive\n");
+		gpiod_set_value_cansleep(vdes->enable_gpio, 0);
+		gpiod_set_value_cansleep(vdes->npwrdn_gpio, 0);
+	}
+
+	mutex_unlock(&vdes->lock);
+
+	return 0;
+}
+
+static const struct media_entity_operations video_des_ops = {
+	.link_setup = video_des_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static int video_des_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct v4l2_subdev *upstream_sd;
+	struct media_pad *pad;
+
+	pad = media_entity_remote_pad(&sd->entity.pads[0]);
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
+static const struct v4l2_subdev_video_ops video_des_subdev_video_ops = {
+	.s_stream = video_des_s_stream,
+};
+
+static struct v4l2_mbus_framefmt *
+__video_des_get_pad_format(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
+			   unsigned int pad, u32 which)
+{
+	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
+
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &vdes->format_mbus;
+	default:
+		return NULL;
+	}
+}
+
+static int video_des_get_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
+
+	mutex_lock(&vdes->lock);
+
+	sdformat->format = *__video_des_get_pad_format(sd, cfg, sdformat->pad,
+						       sdformat->which);
+
+	mutex_unlock(&vdes->lock);
+
+	return 0;
+}
+
+static int video_des_set_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+	struct media_pad *pad = &vdes->pads[sdformat->pad];
+
+	mbusformat = __video_des_get_pad_format(sd, cfg, sdformat->pad,
+					    sdformat->which);
+	if (!mbusformat)
+		return -EINVAL;
+
+	mutex_lock(&vdes->lock);
+
+	/* Source pad mirrors sink pad, no limitations on sink pads */
+	if ((pad->flags & MEDIA_PAD_FL_SOURCE)) {
+		sdformat->format = vdes->format_mbus;
+	} else {
+		/* any sizes are allowed */
+		v4l_bound_align_image(
+			&sdformat->format.width, 1, UINT_MAX-1, 0,
+			&sdformat->format.height, 1, UINT_MAX-1, 0,
+			0);
+		if (sdformat->format.field == V4L2_FIELD_ANY)
+			sdformat->format.field = V4L2_FIELD_NONE;
+		switch (sdformat->format.code) {
+		/* only 8 bit formats are supported */
+		case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
+		case MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE:
+		case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
+		case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+		case MEDIA_BUS_FMT_BGR565_2X8_BE:
+		case MEDIA_BUS_FMT_BGR565_2X8_LE:
+		case MEDIA_BUS_FMT_RGB565_2X8_BE:
+		case MEDIA_BUS_FMT_RGB565_2X8_LE:
+		case MEDIA_BUS_FMT_Y8_1X8:
+		case MEDIA_BUS_FMT_UV8_1X8:
+		case MEDIA_BUS_FMT_UYVY8_1_5X8:
+		case MEDIA_BUS_FMT_VYUY8_1_5X8:
+		case MEDIA_BUS_FMT_YUYV8_1_5X8:
+		case MEDIA_BUS_FMT_YVYU8_1_5X8:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_VYUY8_2X8:
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_YVYU8_2X8:
+		case MEDIA_BUS_FMT_SBGGR8_1X8:
+		case MEDIA_BUS_FMT_SGBRG8_1X8:
+		case MEDIA_BUS_FMT_SGRBG8_1X8:
+		case MEDIA_BUS_FMT_SRGGB8_1X8:
+		case MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8:
+		case MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8:
+		case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
+		case MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8:
+		case MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8:
+		case MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8:
+		case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+		case MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8:
+		case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
+		case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE:
+		case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE:
+		case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE:
+		case MEDIA_BUS_FMT_JPEG_1X8:
+		case MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8:
+			break;
+		default:
+			sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;
+		}
+	}
+
+	*mbusformat = sdformat->format;
+
+	mutex_unlock(&vdes->lock);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops video_des_pad_ops = {
+	.get_fmt = video_des_get_format,
+	.set_fmt = video_des_set_format,
+};
+
+static int video_des_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	mutex_lock(&vdes->lock);
+
+	format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
+	*format = vdes->format_mbus;
+	format = v4l2_subdev_get_try_format(sd, fh->pad, 1);
+	*format = vdes->format_mbus;
+
+	mutex_unlock(&vdes->lock);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops video_des_subdev_internal_ops = {
+	.open = video_des_open,
+};
+
+static const struct v4l2_subdev_ops video_des_subdev_ops = {
+	.pad = &video_des_pad_ops,
+	.video = &video_des_subdev_video_ops,
+};
+
+static int video_des_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct device_node *ep;
+	struct video_des *vdes;
+	unsigned int num_pads = 0;
+	int ret;
+
+	vdes = devm_kzalloc(dev, sizeof(*vdes), GFP_KERNEL);
+	if (!vdes)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, vdes);
+
+	v4l2_subdev_init(&vdes->subdev, &video_des_subdev_ops);
+	snprintf(vdes->subdev.name, sizeof(vdes->subdev.name), "%s", np->name);
+	vdes->subdev.internal_ops = &video_des_subdev_internal_ops;
+	vdes->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	vdes->subdev.dev = dev;
+
+	/*
+	 * We only have two ports: sink and source
+	 */
+	for_each_endpoint_of_node(np, ep) {
+		struct of_endpoint endpoint;
+
+		of_graph_parse_endpoint(ep, &endpoint);
+		num_pads = max(num_pads, endpoint.port + 1);
+	}
+
+	if (num_pads != 2) {
+		dev_err(dev, "Wrong number of ports %d (!= 2)\n", num_pads);
+		return -EINVAL;
+	}
+
+	vdes->npwrdn_gpio = devm_gpiod_get(dev, "npwrdn", GPIOD_OUT_LOW);
+	if (IS_ERR(vdes->npwrdn_gpio)) {
+		ret = PTR_ERR(vdes->npwrdn_gpio);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get npwrdn GPIO: %d\n", ret);
+		return ret;
+	}
+
+	vdes->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(vdes->enable_gpio)) {
+		ret = PTR_ERR(vdes->enable_gpio);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get enable GPIO: %d\n", ret);
+		return ret;
+	}
+
+	mutex_init(&vdes->lock);
+
+	vdes->pads[0].flags = MEDIA_PAD_FL_SINK;
+	vdes->pads[1].flags = MEDIA_PAD_FL_SOURCE;
+
+	vdes->format_mbus.width = 1;
+	vdes->format_mbus.height = 1;
+	vdes->format_mbus.code = MEDIA_BUS_FMT_Y8_1X8;
+	vdes->format_mbus.field = V4L2_FIELD_NONE;
+
+	vdes->subdev.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
+	ret = media_entity_pads_init(&vdes->subdev.entity, 2,
+				     vdes->pads);
+	if (ret < 0)
+		return ret;
+
+	vdes->subdev.entity.ops = &video_des_ops;
+
+	return v4l2_async_register_subdev(&vdes->subdev);
+}
+
+static int video_des_remove(struct platform_device *pdev)
+{
+	struct video_des *vdes = platform_get_drvdata(pdev);
+	struct v4l2_subdev *sd = &vdes->subdev;
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+
+	return 0;
+}
+
+static const struct of_device_id video_des_dt_ids[] = {
+	{ .compatible = "ti,scan921226h", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, video_des_dt_ids);
+
+static struct platform_driver video_des_driver = {
+	.probe		= video_des_probe,
+	.remove		= video_des_remove,
+	.driver		= {
+		.of_match_table = video_des_dt_ids,
+		.name = "scan921226h",
+	},
+};
+
+module_platform_driver(video_des_driver);
+
+MODULE_DESCRIPTION("SCAN921226H video deserializer");
+MODULE_AUTHOR("Jan Luebbe, Pengutronix");
+MODULE_LICENSE("GPL");
-- 
2.17.0
