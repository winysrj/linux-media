Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55931 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936360AbcJGQBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 10/22] [media] platform: add video-multiplexer subdevice driver
Date: Fri,  7 Oct 2016 18:00:55 +0200
Message-Id: <20161007160107.5074-11-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver can handle SoC internal and external video bus multiplexers,
controlled either by register bit fields or by a GPIO. The subdevice
passes through frame interval and mbus configuration of the active input
to the output side.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../bindings/media/video-multiplexer.txt           |  59 +++
 drivers/media/platform/Kconfig                     |   8 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/video-multiplexer.c         | 444 +++++++++++++++++++++
 4 files changed, 513 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/video-multiplexer.txt
 create mode 100644 drivers/media/platform/video-multiplexer.c

diff --git a/Documentation/devicetree/bindings/media/video-multiplexer.txt b/Documentation/devicetree/bindings/media/video-multiplexer.txt
new file mode 100644
index 0000000..9d133d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/video-multiplexer.txt
@@ -0,0 +1,59 @@
+Video Multiplexer
+=================
+
+Video multiplexers allow to select between multiple input ports. Video received
+on the active input port is passed through to the output port. Muxes described
+by this binding may be controlled by a syscon register bitfield or by a GPIO.
+
+Required properties:
+- compatible : should be "video-multiplexer"
+- reg: should be register base of the register containing the control bitfield
+- bit-mask: bitmask of the control bitfield in the control register
+- bit-shift: bit offset of the control bitfield in the control register
+- gpios: alternatively to reg, bit-mask, and bit-shift, a single GPIO phandle
+  may be given to switch between two inputs
+- #address-cells: should be <1>
+- #size-cells: should be <0>
+- port@*: at least three port nodes containing endpoints connecting to the
+  source and sink devices according to of_graph bindings. The last port is
+  the output port, all others are inputs.
+
+Example:
+
+syscon {
+	compatible = "syscon", "simple-mfd";
+
+	mux {
+		compatible = "video-multiplexer";
+		/* Single bit (1 << 19) in syscon register 0x04: */
+		reg = <0x04>;
+		bit-mask = <1>;
+		bit-shift = <19>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			mux_in0: endpoint {
+				remote-endpoint = <&video_source0_out>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			mux_in1: endpoint {
+				remote-endpoint = <&video_source1_out>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			mux_out: endpoint {
+				remote-endpoint = <&capture_interface_in>;
+			};
+		};
+	};
+};
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 105bf57..92680f6 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -76,6 +76,14 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
+config VIDEO_MULTIPLEXER
+	tristate "Video Multiplexer"
+	depends on VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	help
+	  This driver provides support for SoC internal N:1 video bus
+	  multiplexers controlled by register bitfields as well as external
+	  2:1 video multiplexers controlled by a single GPIO.
+
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index f7f9008..a251755a 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
 
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
+obj-$(CONFIG_VIDEO_MULTIPLEXER)		+= video-multiplexer.o
+
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
diff --git a/drivers/media/platform/video-multiplexer.c b/drivers/media/platform/video-multiplexer.c
new file mode 100644
index 0000000..e9137ba
--- /dev/null
+++ b/drivers/media/platform/video-multiplexer.c
@@ -0,0 +1,444 @@
+/*
+ * video stream multiplexer controlled via gpio or syscon
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
+#include <linux/gpio/consumer.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+
+struct vidsw {
+	struct v4l2_subdev subdev;
+	unsigned int num_pads;
+	struct media_pad *pads;
+	struct v4l2_mbus_framefmt *format_mbus;
+	struct v4l2_fract timeperframe;
+	struct v4l2_of_endpoint *endpoint;
+	struct regmap_field *field;
+	struct gpio_desc *gpio;
+	int active;
+};
+
+static inline struct vidsw *v4l2_subdev_to_vidsw(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct vidsw, subdev);
+}
+
+static void vidsw_set_active(struct vidsw *vidsw, int active)
+{
+	vidsw->active = active;
+	if (active < 0)
+		return;
+
+	dev_dbg(vidsw->subdev.dev, "setting %d active\n", active);
+
+	if (vidsw->field)
+		regmap_field_write(vidsw->field, active);
+	else if (vidsw->gpio)
+		gpiod_set_value(vidsw->gpio, active);
+}
+
+static int vidsw_link_setup(struct media_entity *entity,
+			    const struct media_pad *local,
+			    const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
+
+	/* We have no limitations on enabling or disabling our output link */
+	if (local->index == vidsw->num_pads - 1)
+		return 0;
+
+	dev_dbg(sd->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		if (local->index == vidsw->active) {
+			dev_dbg(sd->dev, "going inactive\n");
+			vidsw->active = -1;
+		}
+		return 0;
+	}
+
+	if (vidsw->active >= 0) {
+		struct media_pad *pad;
+
+		if (vidsw->active == local->index)
+			return 0;
+
+		pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
+		if (pad) {
+			struct media_link *link;
+			int ret;
+
+			link = media_entity_find_link(pad,
+						&vidsw->pads[vidsw->active]);
+			if (link) {
+				ret = __media_entity_setup_link(link, 0);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
+	vidsw_set_active(vidsw, local->index);
+
+	return 0;
+}
+
+static struct media_entity_operations vidsw_ops = {
+	.link_setup = vidsw_link_setup,
+};
+
+static bool vidsw_endpoint_disabled(struct device_node *ep)
+{
+	struct device_node *rpp;
+
+	if (!of_device_is_available(ep))
+		return true;
+
+	rpp = of_graph_get_remote_port_parent(ep);
+	if (!rpp)
+		return true;
+
+	return !of_device_is_available(rpp);
+}
+
+static int vidsw_async_init(struct vidsw *vidsw, struct device_node *node)
+{
+	struct device_node *ep;
+	u32 portno;
+	int numports;
+	int ret;
+	int i;
+	bool active_link = false;
+
+	numports = vidsw->num_pads;
+
+	for (i = 0; i < numports - 1; i++)
+		vidsw->pads[i].flags = MEDIA_PAD_FL_SINK;
+	vidsw->pads[numports - 1].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_pads_init(&vidsw->subdev.entity, numports,
+				     vidsw->pads);
+	if (ret < 0)
+		return ret;
+
+	vidsw->subdev.entity.ops = &vidsw_ops;
+
+	for_each_endpoint_of_node(node, ep) {
+		struct v4l2_of_endpoint endpoint;
+
+		v4l2_of_parse_endpoint(ep, &endpoint);
+
+		portno = endpoint.base.port;
+		if (portno >= numports - 1)
+			continue;
+
+		if (vidsw_endpoint_disabled(ep)) {
+			dev_dbg(vidsw->subdev.dev, "port %d disabled\n", portno);
+			continue;
+		}
+
+		vidsw->endpoint[portno] = endpoint;
+
+		if (portno == vidsw->active)
+			active_link = true;
+	}
+
+	for (portno = 0; portno < numports - 1; portno++) {
+		if (!vidsw->endpoint[portno].base.local_node)
+			continue;
+
+		/* If the active input is not connected, use another */
+		if (!active_link) {
+			vidsw_set_active(vidsw, portno);
+			active_link = true;
+		}
+	}
+
+	return v4l2_async_register_subdev(&vidsw->subdev);
+}
+
+int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg)
+{
+	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
+	struct media_pad *pad;
+	int ret;
+
+	if (vidsw->active == -1) {
+		dev_err(sd->dev, "no configuration for inactive mux\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Retrieve media bus configuration from the entity connected to the
+	 * active input
+	 */
+	pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
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
+		/* Mirror the input side on the output side */
+		cfg->type = vidsw->endpoint[vidsw->active].bus_type;
+		if (cfg->type == V4L2_MBUS_PARALLEL ||
+		    cfg->type == V4L2_MBUS_BT656)
+			cfg->flags = vidsw->endpoint[vidsw->active].bus.parallel.flags;
+	}
+
+	return 0;
+}
+
+static int vidsw_g_frame_interval(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_frame_interval *fi)
+{
+	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
+
+	fi->interval = vidsw->timeperframe;
+
+	return 0;
+}
+
+static int vidsw_s_frame_interval(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_frame_interval *fi)
+{
+	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
+
+	vidsw->timeperframe = fi->interval;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops vidsw_subdev_video_ops = {
+	.g_mbus_config = vidsw_g_mbus_config,
+	.g_frame_interval = vidsw_g_frame_interval,
+	.s_frame_interval = vidsw_s_frame_interval,
+};
+
+static struct v4l2_mbus_framefmt *
+__vidsw_get_pad_format(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       unsigned int pad, u32 which)
+{
+	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
+
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &vidsw->format_mbus[pad];
+	default:
+		return NULL;
+	}
+}
+
+static int vidsw_get_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	sdformat->format = *__vidsw_get_pad_format(sd, cfg, sdformat->pad,
+						   sdformat->which);
+	return 0;
+}
+
+static int vidsw_set_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+
+	if (sdformat->pad >= vidsw->num_pads)
+		return -EINVAL;
+
+	mbusformat = __vidsw_get_pad_format(sd, cfg, sdformat->pad,
+					    sdformat->which);
+	if (!mbusformat)
+		return -EINVAL;
+
+	/* Output pad mirrors active input pad, no limitations on input pads */
+	if (sdformat->pad == (vidsw->num_pads - 1) && vidsw->active >= 0)
+		sdformat->format = vidsw->format_mbus[vidsw->active];
+
+	*mbusformat = sdformat->format;
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
+	.registered = v4l2_of_subdev_registered,
+};
+
+static int of_get_reg_field(struct device_node *node, struct reg_field *field)
+{
+	u32 bit_mask;
+	int ret;
+
+	ret = of_property_read_u32(node, "reg", &field->reg);
+	if (ret < 0)
+		return ret;
+
+	ret = of_property_read_u32(node, "bit-mask", &bit_mask);
+	if (ret < 0)
+		return ret;
+
+	ret = of_property_read_u32(node, "bit-shift", &field->lsb);
+	if (ret < 0)
+		return ret;
+
+	field->msb = field->lsb + fls(bit_mask) - 1;
+
+	return 0;
+}
+
+static int vidsw_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct of_endpoint endpoint;
+	struct device_node *ep;
+	struct reg_field field;
+	struct vidsw *vidsw;
+	struct regmap *map;
+	unsigned int num_pads;
+	int ret;
+
+	vidsw = devm_kzalloc(&pdev->dev, sizeof(*vidsw), GFP_KERNEL);
+	if (!vidsw)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, vidsw);
+
+	v4l2_subdev_init(&vidsw->subdev, &vidsw_subdev_ops);
+	vidsw->subdev.internal_ops = &vidsw_internal_ops;
+	snprintf(vidsw->subdev.name, sizeof(vidsw->subdev.name), "%s",
+			np->name);
+	vidsw->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	vidsw->subdev.dev = &pdev->dev;
+
+	/*
+	 * The largest numbered port is the output port. It determines
+	 * total number of pads
+	 */
+	for_each_endpoint_of_node(np, ep) {
+		of_graph_parse_endpoint(ep, &endpoint);
+		num_pads = max(num_pads, endpoint.port + 1);
+	}
+
+	num_pads = of_get_child_count(np);
+	if (num_pads < 2) {
+		dev_err(&pdev->dev, "Not enough ports %d\n", num_pads);
+		return -EINVAL;
+	}
+
+	ret = of_get_reg_field(np, &field);
+	if (ret == 0) {
+		map = syscon_node_to_regmap(np->parent);
+		if (!map) {
+			dev_err(&pdev->dev, "Failed to get syscon register map\n");
+			return PTR_ERR(map);
+		}
+
+		vidsw->field = devm_regmap_field_alloc(&pdev->dev, map, field);
+		if (IS_ERR(vidsw->field)) {
+			dev_err(&pdev->dev, "Failed to allocate regmap field\n");
+			return PTR_ERR(vidsw->field);
+		}
+
+		regmap_field_read(vidsw->field, &vidsw->active);
+	} else {
+		if (num_pads > 3) {
+			dev_err(&pdev->dev, "Too many ports %d\n", num_pads);
+			return -EINVAL;
+		}
+
+		vidsw->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
+		if (IS_ERR(vidsw->gpio)) {
+			dev_warn(&pdev->dev,
+				 "could not request control gpio: %d\n", ret);
+			vidsw->gpio = NULL;
+		}
+
+		vidsw->active = gpiod_get_value(vidsw->gpio) ? 1 : 0;
+	}
+
+	vidsw->num_pads = num_pads;
+	vidsw->pads = devm_kzalloc(&pdev->dev, sizeof(*vidsw->pads) * num_pads,
+			GFP_KERNEL);
+	vidsw->format_mbus = devm_kzalloc(&pdev->dev,
+			sizeof(*vidsw->format_mbus) * num_pads, GFP_KERNEL);
+	vidsw->endpoint = devm_kzalloc(&pdev->dev,
+			sizeof(*vidsw->endpoint) * (num_pads - 1), GFP_KERNEL);
+
+	ret = vidsw_async_init(vidsw, np);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int vidsw_remove(struct platform_device *pdev)
+{
+	struct vidsw *vidsw = platform_get_drvdata(pdev);
+
+	v4l2_async_register_subdev(&vidsw->subdev);
+
+	return 0;
+}
+
+static const struct of_device_id vidsw_dt_ids[] = {
+	{ .compatible = "video-multiplexer", },
+	{ /* sentinel */ }
+};
+
+static struct platform_driver vidsw_driver = {
+	.probe		= vidsw_probe,
+	.remove		= vidsw_remove,
+	.driver		= {
+		.of_match_table = vidsw_dt_ids,
+		.name = "video-multiplexer",
+	},
+};
+
+module_platform_driver(vidsw_driver);
+
+MODULE_DESCRIPTION("video stream multiplexer");
+MODULE_AUTHOR("Sascha Hauer, Pengutronix");
+MODULE_AUTHOR("Philipp Zabel, Pengutronix");
+MODULE_LICENSE("GPL");
-- 
2.9.3

