Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36312 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966140AbdACU6R (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:58:17 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 16/19] media: imx: Add video switch subdev driver
Date: Tue,  3 Jan 2017 12:57:26 -0800
Message-Id: <1483477049-19056-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This driver can handle SoC internal and extern video bus multiplexers,
controlled either by register bit fields or by GPIO.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/Makefile           |   1 +
 drivers/staging/media/imx/imx-video-switch.c | 351 +++++++++++++++++++++++++++
 2 files changed, 352 insertions(+)
 create mode 100644 drivers/staging/media/imx/imx-video-switch.c

diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index 0decef7..e3d6d8d 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
 obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o
 obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-camif.o
 obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-mipi-csi2.o
+obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-video-switch.o
diff --git a/drivers/staging/media/imx/imx-video-switch.c b/drivers/staging/media/imx/imx-video-switch.c
new file mode 100644
index 0000000..79d3837
--- /dev/null
+++ b/drivers/staging/media/imx/imx-video-switch.c
@@ -0,0 +1,351 @@
+/*
+ * devicetree probed mediacontrol video multiplexer.
+ *
+ * Copyright (C) 2013 Sascha Hauer, Pengutronix
+ * Copyright (c) 2016 Mentor Graphics Inc.
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
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/of_graph.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include "imx-media.h"
+
+struct vidsw {
+	struct device *dev;
+	struct imx_media_dev *md;
+	struct v4l2_subdev subdev;
+	struct media_pad *pads;
+	struct v4l2_mbus_framefmt *format_mbus;
+	struct v4l2_of_endpoint *endpoint;
+	struct regmap_field *field;
+	struct gpio_desc *gpio;
+	int output_pad;
+	int numpads;
+	int active;
+};
+
+#define to_vidsw(sd) container_of(sd, struct vidsw, subdev)
+
+static int vidsw_set_mux(struct vidsw *vidsw, int input_index)
+{
+	if (vidsw->active >= 0) {
+		if (vidsw->active == input_index)
+			return 0;
+		else
+			return -EBUSY;
+	}
+
+	vidsw->active = input_index;
+
+	dev_dbg(vidsw->dev, "setting %d active\n", vidsw->active);
+
+	if (vidsw->field)
+		regmap_field_write(vidsw->field, vidsw->active);
+	else if (vidsw->gpio)
+		gpiod_set_value(vidsw->gpio, vidsw->active);
+
+	return 0;
+}
+
+static int vidsw_link_setup(struct media_entity *entity,
+			    const struct media_pad *local,
+			    const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vidsw *vidsw = to_vidsw(sd);
+
+	dev_dbg(vidsw->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	if (local->flags & MEDIA_PAD_FL_SINK) {
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			if (local->index == vidsw->active) {
+				dev_dbg(vidsw->dev, "going inactive\n");
+				vidsw->active = -1;
+			}
+			return 0;
+		}
+
+		return vidsw_set_mux(vidsw, local->index);
+	}
+
+	return 0;
+}
+
+static struct media_entity_operations vidsw_ops = {
+	.link_setup = vidsw_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int vidsw_registered(struct v4l2_subdev *sd)
+{
+	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
+	struct device_node *np = vidsw->dev->of_node;
+	struct imx_media_subdev *imxsd;
+	struct device_node *epnode;
+	struct imx_media_pad *pad;
+	int i, ret;
+
+	vidsw->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	imxsd = imx_media_find_subdev_by_sd(vidsw->md, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+
+	if (imxsd->num_sink_pads < 2 || imxsd->num_src_pads != 1)
+		return -EINVAL;
+
+	vidsw->numpads = imxsd->num_sink_pads + imxsd->num_src_pads;
+
+	vidsw->pads = devm_kzalloc(vidsw->dev,
+				   vidsw->numpads * sizeof(*vidsw->pads),
+				   GFP_KERNEL);
+	if (!vidsw->pads)
+		return -ENOMEM;
+
+	vidsw->endpoint = devm_kzalloc(vidsw->dev,
+				       vidsw->numpads *
+				       sizeof(*vidsw->endpoint),
+				       GFP_KERNEL);
+	if (!vidsw->endpoint)
+		return -ENOMEM;
+
+	vidsw->format_mbus = devm_kzalloc(vidsw->dev,
+					  vidsw->numpads *
+					  sizeof(*vidsw->format_mbus),
+					  GFP_KERNEL);
+	if (!vidsw->format_mbus)
+		return -ENOMEM;
+
+	epnode = NULL;
+	for (i = 0; i < vidsw->numpads; i++) {
+		pad = &imxsd->pad[i];
+		vidsw->pads[i] = pad->pad;
+
+		epnode = of_graph_get_next_endpoint(np, epnode);
+		if (!epnode)
+			return -EINVAL;
+
+		v4l2_of_parse_endpoint(epnode, &vidsw->endpoint[i]);
+		of_node_put(epnode);
+
+		/* set a default mbus format  */
+		ret = imx_media_init_mbus_fmt(vidsw->format_mbus,
+					      640, 480, 0, V4L2_FIELD_NONE,
+					      NULL);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * the last endpoint must define the mux output pad,
+	 * the rest are the mux input pads.
+	 */
+	vidsw->output_pad = vidsw->numpads - 1;
+	if (!(vidsw->pads[vidsw->output_pad].flags & MEDIA_PAD_FL_SOURCE))
+		return -EINVAL;
+
+	return media_entity_pads_init(&sd->entity, vidsw->numpads, vidsw->pads);
+}
+
+static int vidsw_g_mbus_config(struct v4l2_subdev *sd,
+			       struct v4l2_mbus_config *cfg)
+{
+	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
+
+	dev_dbg(vidsw->dev, "reporting configration %d\n", vidsw->active);
+
+	/* Mirror the input side on the output side */
+	cfg->type = vidsw->endpoint[vidsw->active].bus_type;
+	if (cfg->type == V4L2_MBUS_PARALLEL || cfg->type == V4L2_MBUS_BT656)
+		cfg->flags = vidsw->endpoint[vidsw->active].bus.parallel.flags;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops vidsw_subdev_video_ops = {
+	.g_mbus_config = vidsw_g_mbus_config,
+};
+
+static int vidsw_get_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
+
+	sdformat->format = vidsw->format_mbus[sdformat->pad];
+
+	return 0;
+}
+
+static int vidsw_set_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
+
+	if (sdformat->pad >= vidsw->numpads)
+		return -EINVAL;
+
+	/* Output pad mirrors active input pad, no limitations on input pads */
+	if (sdformat->pad == vidsw->output_pad && vidsw->active >= 0)
+		sdformat->format = vidsw->format_mbus[vidsw->active];
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
+		cfg->try_fmt = sdformat->format;
+	else
+		vidsw->format_mbus[sdformat->pad] = sdformat->format;
+
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops vidsw_pad_ops = {
+	.get_fmt = vidsw_get_format,
+	.set_fmt = vidsw_set_format,
+};
+
+static struct v4l2_subdev_ops vidsw_subdev_ops = {
+	.pad = &vidsw_pad_ops,
+	.video = &vidsw_subdev_video_ops,
+};
+
+static struct v4l2_subdev_internal_ops vidsw_internal_ops = {
+	.registered = vidsw_registered,
+};
+
+static int of_get_reg_field(struct device_node *node, struct reg_field *field)
+{
+	u32 reg_bit_mask[2];
+	int ret;
+
+	ret = of_property_read_u32_array(node, "reg", reg_bit_mask, 2);
+	if (ret < 0)
+		return ret;
+
+	field->reg = reg_bit_mask[0];
+	field->lsb = __ffs(reg_bit_mask[1]);
+	field->msb = __fls(reg_bit_mask[1]);
+
+	return 0;
+}
+
+static int vidsw_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct reg_field field;
+	struct vidsw *vidsw;
+	struct regmap *map;
+	int ret;
+
+	vidsw = devm_kzalloc(&pdev->dev, sizeof(*vidsw), GFP_KERNEL);
+	if (!vidsw)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, vidsw);
+
+	v4l2_subdev_init(&vidsw->subdev, &vidsw_subdev_ops);
+	v4l2_set_subdevdata(&vidsw->subdev, &pdev->dev);
+	vidsw->subdev.internal_ops = &vidsw_internal_ops;
+	vidsw->subdev.entity.ops = &vidsw_ops;
+	snprintf(vidsw->subdev.name, sizeof(vidsw->subdev.name), "%s",
+		 np->name);
+	/* FIXME: this is a video mux, function isn't right */
+	vidsw->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	vidsw->subdev.grp_id = IMX_MEDIA_GRP_ID_VIDMUX;
+	vidsw->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	vidsw->subdev.dev = &pdev->dev;
+	vidsw->dev = &pdev->dev;
+
+	vidsw->active = -1;
+
+	ret = of_get_reg_field(np, &field);
+	if (ret == 0) {
+		struct device_node *gpr_np = of_get_parent(np);
+
+		if (!gpr_np) {
+			dev_err(&pdev->dev,
+				"Failed to get parent syscon node\n");
+			return -ENODEV;
+		}
+		map = syscon_node_to_regmap(gpr_np);
+		of_node_put(gpr_np);
+		if (IS_ERR(map)) {
+			dev_err(&pdev->dev,
+				"Failed to get syscon register map\n");
+			return PTR_ERR(map);
+		}
+
+		vidsw->field = devm_regmap_field_alloc(&pdev->dev, map, field);
+		if (IS_ERR(vidsw->field)) {
+			dev_err(&pdev->dev,
+				"Failed to allocate regmap field\n");
+			return PTR_ERR(vidsw->field);
+		}
+	} else {
+		vidsw->gpio = devm_gpiod_get_optional(&pdev->dev, "mux",
+						      GPIOD_OUT_LOW);
+		if (IS_ERR(vidsw->gpio)) {
+			dev_err(&pdev->dev, "request for gpio failed\n");
+			return PTR_ERR(vidsw->gpio);
+		}
+
+		if (!vidsw->gpio)
+			dev_warn(&pdev->dev, "no control gpio defined\n");
+	}
+
+	return v4l2_async_register_subdev(&vidsw->subdev);
+}
+
+static int vidsw_remove(struct platform_device *pdev)
+{
+	struct vidsw *vidsw = platform_get_drvdata(pdev);
+	struct v4l2_subdev *sd = &vidsw->subdev;
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static const struct of_device_id vidsw_dt_ids[] = {
+	{ .compatible = "imx-video-mux", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, vidsw_dt_ids);
+
+static struct platform_driver vidsw_driver = {
+	.probe		= vidsw_probe,
+	.remove		= vidsw_remove,
+	.driver		= {
+		.of_match_table = vidsw_dt_ids,
+		.name	= "imx-video-mux",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(vidsw_driver);
+
+MODULE_DESCRIPTION("i.MX video stream multiplexer");
+MODULE_AUTHOR("Sascha Hauer, Pengutronix");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
-- 
2.7.4

