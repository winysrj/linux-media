Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34242 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbcDXVKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:30 -0400
Received: by mail-wm0-f67.google.com with SMTP id n3so20028657wmn.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:29 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 16/24] media: video-bus-switch: new driver
Date: Mon, 25 Apr 2016 00:08:16 +0300
Message-Id: <1461532104-24032-17-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/media/platform/Kconfig            |  10 +
 drivers/media/platform/Makefile           |   2 +
 drivers/media/platform/video-bus-switch.c | 366 ++++++++++++++++++++++++++++++
 3 files changed, 378 insertions(+)
 create mode 100644 drivers/media/platform/video-bus-switch.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 201f5c2..7c91fd2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -91,6 +91,16 @@ config VIDEO_OMAP3_DEBUG
 	---help---
 	  Enable debug messages on OMAP 3 camera controller driver.
 
+config VIDEO_BUS_SWITCH
+	tristate "Video Bus switch"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CONTROLLER
+	depends on OF
+	---help---
+	  Driver for a GPIO controlled video bus switch, which is used to
+	  connect two camera sensors to the same port a the image signal
+	  processor.
+
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index bbb7bd1..c456917 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -10,6 +10,8 @@ obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
+obj-$(CONFIG_VIDEO_BUS_SWITCH) += video-bus-switch.o
+
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 
 obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/platform/video-bus-switch.c
new file mode 100644
index 0000000..7c850fd
--- /dev/null
+++ b/drivers/media/platform/video-bus-switch.c
@@ -0,0 +1,366 @@
+/*
+ * Generic driver for video bus switches
+ *
+ * Copyright (C) 2015 Sebastian Reichel <sre@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#define DEBUG
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/gpio/consumer.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+
+/*
+ * TODO:
+ * isp_subdev_notifier_complete() calls v4l2_device_register_subdev_nodes()
+ */
+
+#define CSI_SWITCH_SUBDEVS 2
+#define CSI_SWITCH_PORTS 3
+
+enum vbs_state {
+	CSI_SWITCH_DISABLED,
+	CSI_SWITCH_PORT_1,
+	CSI_SWITCH_PORT_2,
+};
+
+struct vbs_src_pads {
+	struct media_entity *src;
+	int src_pad;
+};
+
+struct vbs_data {
+	struct gpio_desc *swgpio;
+	struct v4l2_subdev subdev;
+	struct v4l2_async_notifier notifier;
+	struct media_pad pads[CSI_SWITCH_PORTS];
+	struct vbs_src_pads src_pads[CSI_SWITCH_PORTS];
+	enum vbs_state state;
+};
+
+struct vbs_async_subdev {
+	struct v4l2_subdev *sd;
+	struct v4l2_async_subdev asd;
+	u8 port;
+};
+
+static int vbs_of_parse_nodes(struct device *dev, struct vbs_data *pdata)
+{
+	struct v4l2_async_notifier *notifier = &pdata->notifier;
+	struct device_node *node = NULL;
+
+	notifier->subdevs = devm_kcalloc(dev, CSI_SWITCH_SUBDEVS,
+		sizeof(*notifier->subdevs), GFP_KERNEL);
+	if (!notifier->subdevs)
+		return -ENOMEM;
+
+	notifier->num_subdevs = 0;
+	while (notifier->num_subdevs < CSI_SWITCH_SUBDEVS &&
+	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
+		struct v4l2_of_endpoint vep;
+		struct vbs_async_subdev *ssd;
+
+		/* skip first port (connected to isp) */
+		v4l2_of_parse_endpoint(node, &vep);
+		if (vep.base.port == 0) {
+			struct device_node *ispnode;
+
+			ispnode = of_graph_get_remote_port_parent(node);
+			if (!ispnode) {
+				dev_warn(dev, "bad remote port parent\n");
+				return -EINVAL;
+			}
+
+			of_node_put(node);
+			continue;
+		}
+
+		ssd = devm_kzalloc(dev, sizeof(*ssd), GFP_KERNEL);
+		if (!ssd) {
+			of_node_put(node);
+			return -ENOMEM;
+		}
+
+		ssd->port = vep.base.port;
+
+		notifier->subdevs[notifier->num_subdevs] = &ssd->asd;
+
+		ssd->asd.match.of.node = of_graph_get_remote_port_parent(node);
+		of_node_put(node);
+		if (!ssd->asd.match.of.node) {
+			dev_warn(dev, "bad remote port parent\n");
+			return -EINVAL;
+		}
+
+		ssd->asd.match_type = V4L2_ASYNC_MATCH_OF;
+		notifier->num_subdevs++;
+	}
+
+	return notifier->num_subdevs;
+}
+
+static int vbs_registered(struct v4l2_subdev *sd)
+{
+	struct v4l2_device *v4l2_dev = sd->v4l2_dev;
+	struct vbs_data *pdata;
+	int err;
+
+	dev_dbg(sd->dev, "registered, init notifier...\n");
+
+	pdata = v4l2_get_subdevdata(sd);
+
+	err = v4l2_async_notifier_register(v4l2_dev, &pdata->notifier);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static struct v4l2_subdev *vbs_get_remote_subdev(struct v4l2_subdev *sd)
+{
+	struct vbs_data *pdata = v4l2_get_subdevdata(sd);
+	struct media_entity *src;
+
+	if (pdata->state == CSI_SWITCH_DISABLED)
+		return ERR_PTR(-ENXIO);
+
+	src = pdata->src_pads[pdata->state].src;
+
+	return media_entity_to_v4l2_subdev(src);
+}
+
+static int vbs_link_setup(struct media_entity *entity,
+			  const struct media_pad *local,
+			  const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vbs_data *pdata = v4l2_get_subdevdata(sd);
+	bool enable = flags & MEDIA_LNK_FL_ENABLED;
+
+	if (local->index > CSI_SWITCH_PORTS - 1)
+		return -ENXIO;
+
+	/* no configuration needed on source port */
+	if (local->index == 0)
+		return 0;
+
+	if (!enable) {
+		if (local->index == pdata->state) {
+			pdata->state = CSI_SWITCH_DISABLED;
+
+			/* Make sure we have both cameras enabled */
+			gpiod_set_value(pdata->swgpio, 1);
+			return 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	/* there can only be one active sink at the same time */
+	if (pdata->state != CSI_SWITCH_DISABLED)
+		return -EBUSY;
+
+	gpiod_set_value(pdata->swgpio, local->index == CSI_SWITCH_PORT_2);
+	pdata->state = local->index;
+
+	sd = vbs_get_remote_subdev(sd);
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+
+	pdata->subdev.ctrl_handler = sd->ctrl_handler;
+
+	return 0;
+}
+
+static int vbs_subdev_notifier_bound(struct v4l2_async_notifier *async,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
+{
+	struct vbs_data *pdata = container_of(async,
+		struct vbs_data, notifier);
+	struct vbs_async_subdev *ssd =
+		container_of(asd, struct vbs_async_subdev, asd);
+	struct media_entity *sink = &pdata->subdev.entity;
+	struct media_entity *src = &subdev->entity;
+	int sink_pad = ssd->port;
+	int src_pad;
+
+	if (sink_pad >= sink->num_pads) {
+		dev_err(pdata->subdev.dev, "no sink pad in internal entity!\n");
+		return -EINVAL;
+	}
+
+	for (src_pad = 0; src_pad < subdev->entity.num_pads; src_pad++) {
+		if (subdev->entity.pads[src_pad].flags & MEDIA_PAD_FL_SOURCE)
+			break;
+	}
+
+	if (src_pad >= src->num_pads) {
+		dev_err(pdata->subdev.dev, "no source pad in external entity\n");
+		return -EINVAL;
+	}
+
+	pdata->src_pads[sink_pad].src = src;
+	pdata->src_pads[sink_pad].src_pad = src_pad;
+	ssd->sd = subdev;
+
+	return 0;
+}
+
+static int vbs_subdev_notifier_complete(struct v4l2_async_notifier *async)
+{
+	struct vbs_data *pdata = container_of(async, struct vbs_data, notifier);
+	struct media_entity *sink = &pdata->subdev.entity;
+	int sink_pad;
+
+	for (sink_pad = 1; sink_pad < CSI_SWITCH_PORTS; sink_pad++) {
+		struct media_entity *src = pdata->src_pads[sink_pad].src;
+		int src_pad = pdata->src_pads[sink_pad].src_pad;
+		int err;
+
+		err = media_create_pad_link(src, src_pad, sink, sink_pad, 0);
+		if (err < 0)
+			return err;
+
+		dev_dbg(pdata->subdev.dev, "create link: %s[%d] -> %s[%d])\n",
+			src->name, src_pad, sink->name, sink_pad);
+	}
+
+	return v4l2_device_register_subdev_nodes(pdata->subdev.v4l2_dev);
+}
+
+static int vbs_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct v4l2_subdev *subdev = vbs_get_remote_subdev(sd);
+
+	if (IS_ERR(subdev))
+		return PTR_ERR(subdev);
+
+	return v4l2_subdev_call(subdev, video, s_stream, enable);
+}
+
+static const struct v4l2_subdev_internal_ops vbs_internal_ops = {
+	.registered = &vbs_registered,
+};
+
+static const struct media_entity_operations vbs_media_ops = {
+	.link_setup = vbs_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops vbs_video_ops = {
+	.s_stream = vbs_s_stream,
+};
+
+static const struct v4l2_subdev_ops vbs_ops = {
+	.video = &vbs_video_ops,
+};
+
+static int video_bus_switch_probe(struct platform_device *pdev)
+{
+	struct vbs_data *pdata;
+	int err = 0;
+
+	/* platform data */
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, pdata);
+
+	/* switch gpio */
+	pdata->swgpio = devm_gpiod_get(&pdev->dev, "switch", GPIOD_OUT_HIGH);
+	if (IS_ERR(pdata->swgpio)) {
+		err = PTR_ERR(pdata->swgpio);
+		dev_err(&pdev->dev, "Failed to request gpio: %d\n", err);
+		return err;
+	}
+
+	/* find sub-devices */
+	err = vbs_of_parse_nodes(&pdev->dev, pdata);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to parse nodes: %d\n", err);
+		return err;
+	}
+
+	pdata->state = CSI_SWITCH_DISABLED;
+	pdata->notifier.bound = vbs_subdev_notifier_bound;
+	pdata->notifier.complete = vbs_subdev_notifier_complete;
+
+	/* setup subdev */
+	pdata->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+	pdata->pads[1].flags = MEDIA_PAD_FL_SINK;
+	pdata->pads[2].flags = MEDIA_PAD_FL_SINK;
+
+	v4l2_subdev_init(&pdata->subdev, &vbs_ops);
+	pdata->subdev.dev = &pdev->dev;
+	pdata->subdev.owner = pdev->dev.driver->owner;
+	strncpy(pdata->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
+	v4l2_set_subdevdata(&pdata->subdev, pdata);
+	pdata->subdev.entity.flags |= MEDIA_ENT_F_SWITCH;
+	pdata->subdev.entity.ops = &vbs_media_ops;
+	pdata->subdev.internal_ops = &vbs_internal_ops;
+	err = media_entity_pads_init(&pdata->subdev.entity, CSI_SWITCH_PORTS,
+				pdata->pads);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to init media entity: %d\n", err);
+		return err;
+	}
+
+	/* register subdev */
+	err = v4l2_async_register_subdev(&pdata->subdev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to register v4l2 subdev: %d\n", err);
+		media_entity_cleanup(&pdata->subdev.entity);
+		return err;
+	}
+
+	return 0;
+}
+
+static int video_bus_switch_remove(struct platform_device *pdev)
+{
+	struct vbs_data *pdata = platform_get_drvdata(pdev);
+
+	v4l2_async_notifier_unregister(&pdata->notifier);
+	v4l2_async_unregister_subdev(&pdata->subdev);
+	media_entity_cleanup(&pdata->subdev.entity);
+
+	return 0;
+}
+
+static const struct of_device_id video_bus_switch_of_match[] = {
+	{ .compatible = "video-bus-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, video_bus_switch_of_match);
+
+static struct platform_driver video_bus_switch_driver = {
+	.driver = {
+		.name	= "video-bus-switch",
+		.of_match_table = video_bus_switch_of_match,
+	},
+	.probe		= video_bus_switch_probe,
+	.remove		= video_bus_switch_remove,
+};
+
+module_platform_driver(video_bus_switch_driver);
+
+MODULE_AUTHOR("Sebastian Reichel <sre@kernel.org>");
+MODULE_DESCRIPTION("Video Bus Switch");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:video-bus-switch");
-- 
1.9.1

