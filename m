Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-3.mail.aliyun.com ([115.124.20.3]:39435 "EHLO
        out20-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdF0LIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 07:08:13 -0400
From: Yong Deng <yong.deng@magewell.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        hans.verkuil@cisco.com, peter.griffin@linaro.org,
        hugues.fruchet@st.com, krzk@kernel.org, bparrot@ti.com,
        arnd@arndb.de, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com, yong.deng@magewell.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH RFC 1/2] media: V3s: Add support for Allwinner CSI.
Date: Tue, 27 Jun 2017 19:07:33 +0800
Message-Id: <1498561654-14658-2-git-send-email-yong.deng@magewell.com>
In-Reply-To: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
and CSI1 is used for parallel interface. This is not documented in
datatsheet but by testing and guess.

This patch implement a v4l2 framework driver for it.

Currently, the driver only support the parallel interface. MIPI-CSI2,
ISP's support are not included in this patch.

Signed-off-by: Yong Deng <yong.deng@magewell.com>
---
 drivers/media/platform/Kconfig                   |   1 +
 drivers/media/platform/Makefile                  |   2 +
 drivers/media/platform/sunxi-csi/Kconfig         |   8 +
 drivers/media/platform/sunxi-csi/Makefile        |   3 +
 drivers/media/platform/sunxi-csi/sunxi_csi.c     | 535 +++++++++++++++
 drivers/media/platform/sunxi-csi/sunxi_csi.h     | 203 ++++++
 drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c | 827 +++++++++++++++++++++++
 drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h | 206 ++++++
 drivers/media/platform/sunxi-csi/sunxi_video.c   | 667 ++++++++++++++++++
 drivers/media/platform/sunxi-csi/sunxi_video.h   |  61 ++
 10 files changed, 2513 insertions(+)
 create mode 100644 drivers/media/platform/sunxi-csi/Kconfig
 create mode 100644 drivers/media/platform/sunxi-csi/Makefile
 create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi.c
 create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi.h
 create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c
 create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h
 create mode 100644 drivers/media/platform/sunxi-csi/sunxi_video.c
 create mode 100644 drivers/media/platform/sunxi-csi/sunxi_video.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ac026ee..11c6c563 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -120,6 +120,7 @@ source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
 source "drivers/media/platform/atmel/Kconfig"
+source "drivers/media/platform/sunxi-csi/Kconfig"
 
 config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 63303d6..3e6c20a 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -77,3 +77,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
+
+obj-$(CONFIG_VIDEO_SUNXI_CSI)		+= sunxi-csi/
diff --git a/drivers/media/platform/sunxi-csi/Kconfig b/drivers/media/platform/sunxi-csi/Kconfig
new file mode 100644
index 0000000..f26592a
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/Kconfig
@@ -0,0 +1,8 @@
+config VIDEO_SUNXI_CSI
+	tristate "Allwinner Camera Sensor Interface driver"
+	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on ARCH_SUNXI
+	select VIDEOBUF2_DMA_CONTIG
+	select REGMAP_MMIO
+	---help---
+	   Support for the Allwinner Camera Sensor Interface Controller.
diff --git a/drivers/media/platform/sunxi-csi/Makefile b/drivers/media/platform/sunxi-csi/Makefile
new file mode 100644
index 0000000..f27c1c5
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/Makefile
@@ -0,0 +1,3 @@
+
+sunxi-csi-objs = sunxi_csi.o sunxi_video.o sunxi_csi_v3s.o
+obj-$(CONFIG_VIDEO_SUNXI_CSI) += sunxi-csi.o
diff --git a/drivers/media/platform/sunxi-csi/sunxi_csi.c b/drivers/media/platform/sunxi-csi/sunxi_csi.c
new file mode 100644
index 0000000..87277ca
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/sunxi_csi.c
@@ -0,0 +1,535 @@
+/*
+ * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing),
+ * All rights reserved.
+ * Author: Yong Deng <yong.deng@magewell.com>
+ *
+ * Based on drivers/media/platform/xilinx/xilinx-vipp.c
+ * Copyright (C) 2013-2015 Ideas on Board
+ * Copyright (C) 2013-2015 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+
+#include "sunxi_csi.h"
+
+/*
+ * struct sunxi_graph_entity - Entity in the video graph
+ * @list: list entry in a graph entities list
+ * @node: the entity's DT node
+ * @entity: media entity, from the corresponding V4L2 subdev
+ * @asd: subdev asynchronous registration information
+ * @subdev: V4L2 subdev
+ */
+struct sunxi_graph_entity {
+	struct list_head		list;
+	struct device_node		*node;
+	struct media_entity		*entity;
+
+	struct v4l2_async_subdev	asd;
+	struct v4l2_subdev		*subdev;
+};
+
+/* -----------------------------------------------------------------------------
+ * Graph Management
+ */
+
+static struct sunxi_graph_entity *
+sunxi_graph_find_entity(struct sunxi_csi *csi,
+			const struct device_node *node)
+{
+	struct sunxi_graph_entity *entity;
+
+	list_for_each_entry(entity, &csi->entities, list) {
+		if (entity->node == node)
+			return entity;
+	}
+
+	return NULL;
+}
+
+static int sunxi_graph_build_one(struct sunxi_csi *csi,
+				 struct sunxi_graph_entity *entity)
+{
+	u32 link_flags = MEDIA_LNK_FL_ENABLED;
+	struct media_entity *local = entity->entity;
+	struct media_entity *remote;
+	struct media_pad *local_pad;
+	struct media_pad *remote_pad;
+	struct sunxi_graph_entity *ent;
+	struct v4l2_of_link link;
+	struct device_node *ep = NULL;
+	struct device_node *next;
+	int ret = 0;
+
+	dev_dbg(csi->dev, "creating links for entity %s\n", local->name);
+
+	while (1) {
+		/* Get the next endpoint and parse its link. */
+		next = of_graph_get_next_endpoint(entity->node, ep);
+		if (next == NULL)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		dev_dbg(csi->dev, "processing endpoint %s\n", ep->full_name);
+
+		ret = v4l2_of_parse_link(ep, &link);
+		if (ret < 0) {
+			dev_err(csi->dev, "failed to parse link for %s\n",
+				ep->full_name);
+			continue;
+		}
+
+		/* Skip sink ports, they will be processed from the other end of
+		 * the link.
+		 */
+		if (link.local_port >= local->num_pads) {
+			dev_err(csi->dev, "invalid port number %u on %s\n",
+				link.local_port, link.local_node->full_name);
+			v4l2_of_put_link(&link);
+			ret = -EINVAL;
+			break;
+		}
+
+		local_pad = &local->pads[link.local_port];
+
+		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
+			dev_dbg(csi->dev, "skipping sink port %s:%u\n",
+				link.local_node->full_name, link.local_port);
+			v4l2_of_put_link(&link);
+			continue;
+		}
+
+		/* Skip video node, they will be processed separately. */
+		if (link.remote_node == csi->dev->of_node) {
+			dev_dbg(csi->dev, "skipping CSI port %s:%u\n",
+				link.local_node->full_name, link.local_port);
+			v4l2_of_put_link(&link);
+			continue;
+		}
+
+		/* Find the remote entity. */
+		ent = sunxi_graph_find_entity(csi, link.remote_node);
+		if (ent == NULL) {
+			dev_err(csi->dev, "no entity found for %s\n",
+				link.remote_node->full_name);
+			v4l2_of_put_link(&link);
+			ret = -ENODEV;
+			break;
+		}
+
+		remote = ent->entity;
+
+		if (link.remote_port >= remote->num_pads) {
+			dev_err(csi->dev, "invalid port number %u on %s\n",
+				link.remote_port, link.remote_node->full_name);
+			v4l2_of_put_link(&link);
+			ret = -EINVAL;
+			break;
+		}
+
+		remote_pad = &remote->pads[link.remote_port];
+
+		v4l2_of_put_link(&link);
+
+		/* Create the media link. */
+		dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
+			local->name, local_pad->index,
+			remote->name, remote_pad->index);
+
+		ret = media_create_pad_link(local, local_pad->index,
+					    remote, remote_pad->index,
+					    link_flags);
+		if (ret < 0) {
+			dev_err(csi->dev,
+				"failed to create %s:%u -> %s:%u link\n",
+				local->name, local_pad->index,
+				remote->name, remote_pad->index);
+			break;
+		}
+	}
+
+	of_node_put(ep);
+	return ret;
+}
+
+static int sunxi_graph_build_video(struct sunxi_csi *csi)
+{
+	u32 link_flags = MEDIA_LNK_FL_ENABLED;
+	struct device_node *node = csi->dev->of_node;
+	struct media_entity *source;
+	struct media_entity *sink;
+	struct media_pad *source_pad;
+	struct media_pad *sink_pad;
+	struct sunxi_graph_entity *ent;
+	struct v4l2_of_link link;
+	struct device_node *ep = NULL;
+	struct device_node *next;
+	struct sunxi_video *video = &csi->video;
+	int ret = 0;
+
+	dev_dbg(csi->dev, "creating link for video node\n");
+
+	while (1) {
+		/* Get the next endpoint and parse its link. */
+		next = of_graph_get_next_endpoint(node, ep);
+		if (next == NULL)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		dev_dbg(csi->dev, "processing endpoint %s\n", ep->full_name);
+
+		ret = v4l2_of_parse_link(ep, &link);
+		if (ret < 0) {
+			dev_err(csi->dev, "failed to parse link for %s\n",
+				ep->full_name);
+			continue;
+		}
+
+		/* Save the video port settings */
+		ret = v4l2_of_parse_endpoint(ep, &csi->v4l2_ep);
+		if (ret) {
+			ret = -EINVAL;
+			dev_err(csi->dev, "Could not parse the endpoint\n");
+			break;
+		}
+
+		dev_dbg(csi->dev, "creating link for video node %s\n",
+			video->vdev.name);
+
+		/* Find the remote entity. */
+		ent = sunxi_graph_find_entity(csi, link.remote_node);
+		if (ent == NULL) {
+			dev_err(csi->dev, "no entity found for %s\n",
+				link.remote_node->full_name);
+			v4l2_of_put_link(&link);
+			ret = -ENODEV;
+			break;
+		}
+
+		if (link.remote_port >= ent->entity->num_pads) {
+			dev_err(csi->dev, "invalid port number %u on %s\n",
+				link.remote_port, link.remote_node->full_name);
+			v4l2_of_put_link(&link);
+			ret = -EINVAL;
+			break;
+		}
+
+		source = ent->entity;
+		source_pad = &source->pads[link.remote_port];
+		sink = &video->vdev.entity;
+		sink_pad = &video->pad;
+
+		v4l2_of_put_link(&link);
+
+		/* Create the media link. */
+		dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
+			source->name, source_pad->index,
+			sink->name, sink_pad->index);
+
+		ret = media_create_pad_link(source, source_pad->index,
+					    sink, sink_pad->index,
+					    link_flags);
+		if (ret < 0) {
+			dev_err(csi->dev,
+				"failed to create %s:%u -> %s:%u link\n",
+				source->name, source_pad->index,
+				sink->name, sink_pad->index);
+			break;
+		}
+
+		/* Notify video node */
+		ret = media_entity_call(sink, link_setup, sink_pad, source_pad,
+					link_flags);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+
+		/* found one */
+		break;
+	}
+
+	of_node_put(ep);
+	return ret;
+}
+
+static int sunxi_graph_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct sunxi_csi *csi =
+			container_of(notifier, struct sunxi_csi, notifier);
+	struct sunxi_graph_entity *entity;
+	int ret;
+
+	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
+
+	/* Create links for every entity. */
+	list_for_each_entry(entity, &csi->entities, list) {
+		ret = sunxi_graph_build_one(csi, entity);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Create links for video node. */
+	ret = sunxi_graph_build_video(csi);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_device_register_subdev_nodes(&csi->v4l2_dev);
+	if (ret < 0)
+		dev_err(csi->dev, "failed to register subdev nodes\n");
+
+	return media_device_register(&csi->media_dev);
+}
+
+static int sunxi_graph_notify_bound(struct v4l2_async_notifier *notifier,
+				    struct v4l2_subdev *subdev,
+				    struct v4l2_async_subdev *asd)
+{
+	struct sunxi_csi *csi =
+			container_of(notifier, struct sunxi_csi, notifier);
+	struct sunxi_graph_entity *entity;
+
+	/* Locate the entity corresponding to the bound subdev and store the
+	 * subdev pointer.
+	 */
+	list_for_each_entry(entity, &csi->entities, list) {
+		if (entity->node != subdev->dev->of_node)
+			continue;
+
+		if (entity->subdev) {
+			dev_err(csi->dev, "duplicate subdev for node %s\n",
+				entity->node->full_name);
+			return -EINVAL;
+		}
+
+		dev_dbg(csi->dev, "subdev %s bound\n", subdev->name);
+		entity->entity = &subdev->entity;
+		entity->subdev = subdev;
+		return 0;
+	}
+
+	dev_err(csi->dev, "no entity for subdev %s\n", subdev->name);
+	return -EINVAL;
+}
+
+static int sunxi_graph_parse_one(struct sunxi_csi *csi,
+				 struct device_node *node)
+{
+	struct sunxi_graph_entity *entity;
+	struct device_node *remote;
+	struct device_node *ep = NULL;
+	int ret = 0;
+
+	dev_dbg(csi->dev, "parsing node %s\n", node->full_name);
+
+	while (1) {
+		ep = of_graph_get_next_endpoint(node, ep);
+		if (ep == NULL)
+			break;
+
+		dev_dbg(csi->dev, "handling endpoint %s\n", ep->full_name);
+
+		remote = of_graph_get_remote_port_parent(ep);
+		if (remote == NULL) {
+			ret = -EINVAL;
+			break;
+		}
+
+		/* Skip entities that we have already processed. */
+		if (remote == csi->dev->of_node ||
+		    sunxi_graph_find_entity(csi, remote)) {
+			of_node_put(remote);
+			continue;
+		}
+
+		entity = devm_kzalloc(csi->dev, sizeof(*entity), GFP_KERNEL);
+		if (entity == NULL) {
+			of_node_put(remote);
+			ret = -ENOMEM;
+			break;
+		}
+
+		entity->node = remote;
+		entity->asd.match_type = V4L2_ASYNC_MATCH_OF;
+		entity->asd.match.of.node = remote;
+		list_add_tail(&entity->list, &csi->entities);
+		csi->num_subdevs++;
+	}
+
+	of_node_put(ep);
+	return ret;
+}
+
+static int sunxi_graph_parse(struct sunxi_csi *csi)
+{
+	struct sunxi_graph_entity *entity;
+	int ret;
+
+	/*
+	 * Walk the links to parse the full graph. Start by parsing the
+	 * composite node and then parse entities in turn. The list_for_each
+	 * loop will handle entities added at the end of the list while walking
+	 * the links.
+	 */
+	ret = sunxi_graph_parse_one(csi, csi->dev->of_node);
+	if (ret < 0)
+		return 0;
+
+	list_for_each_entry(entity, &csi->entities, list) {
+		ret = sunxi_graph_parse_one(csi, entity->node);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static void sunxi_graph_cleanup(struct sunxi_csi *csi)
+{
+	struct sunxi_graph_entity *entityp;
+	struct sunxi_graph_entity *entity;
+
+	v4l2_async_notifier_unregister(&csi->notifier);
+
+	list_for_each_entry_safe(entity, entityp, &csi->entities, list) {
+		of_node_put(entity->node);
+		list_del(&entity->list);
+	}
+}
+
+static int sunxi_graph_init(struct sunxi_csi *csi)
+{
+	struct sunxi_graph_entity *entity;
+	struct v4l2_async_subdev **subdevs = NULL;
+	unsigned int num_subdevs;
+	unsigned int i;
+	int ret;
+
+	/* Parse the graph to extract a list of subdevice DT nodes. */
+	ret = sunxi_graph_parse(csi);
+	if (ret < 0) {
+		dev_err(csi->dev, "graph parsing failed\n");
+		goto done;
+	}
+
+	if (!csi->num_subdevs) {
+		dev_err(csi->dev, "no subdev found in graph\n");
+		goto done;
+	}
+
+	/* Register the subdevices notifier. */
+	num_subdevs = csi->num_subdevs;
+	subdevs = devm_kzalloc(csi->dev, sizeof(*subdevs) * num_subdevs,
+			       GFP_KERNEL);
+	if (subdevs == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	i = 0;
+	list_for_each_entry(entity, &csi->entities, list)
+		subdevs[i++] = &entity->asd;
+
+	csi->notifier.subdevs = subdevs;
+	csi->notifier.num_subdevs = num_subdevs;
+	csi->notifier.bound = sunxi_graph_notify_bound;
+	csi->notifier.complete = sunxi_graph_notify_complete;
+
+	ret = v4l2_async_notifier_register(&csi->v4l2_dev, &csi->notifier);
+	if (ret < 0) {
+		dev_err(csi->dev, "notifier registration failed\n");
+		goto done;
+	}
+
+	ret = 0;
+
+done:
+	if (ret < 0)
+		sunxi_graph_cleanup(csi);
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Media Controller and V4L2
+ */
+
+static void sunxi_csi_v4l2_cleanup(struct sunxi_csi *csi)
+{
+	v4l2_device_unregister(&csi->v4l2_dev);
+	media_device_unregister(&csi->media_dev);
+	media_device_cleanup(&csi->media_dev);
+}
+
+static int sunxi_csi_v4l2_init(struct sunxi_csi *csi)
+{
+	int ret;
+
+	csi->media_dev.dev = csi->dev;
+	strlcpy(csi->media_dev.model, "Allwinner Video Capture Device",
+		sizeof(csi->media_dev.model));
+	csi->media_dev.hw_revision = 0;
+
+	media_device_init(&csi->media_dev);
+
+	csi->v4l2_dev.mdev = &csi->media_dev;
+	ret = v4l2_device_register(csi->dev, &csi->v4l2_dev);
+	if (ret < 0) {
+		dev_err(csi->dev, "V4L2 device registration failed (%d)\n",
+			ret);
+		media_device_cleanup(&csi->media_dev);
+		return ret;
+	}
+	return 0;
+}
+
+int sunxi_csi_init(struct sunxi_csi *csi)
+{
+	int ret;
+
+	csi->num_subdevs = 0;
+	INIT_LIST_HEAD(&csi->entities);
+
+	ret = sunxi_csi_v4l2_init(csi);
+	if (ret < 0)
+		return ret;
+
+	ret = sunxi_video_init(&csi->video, csi, "sunxi-csi");
+	if (ret < 0)
+		goto v4l2_clean;
+
+	ret = sunxi_graph_init(csi);
+	if (ret < 0)
+		goto video_clean;
+
+	return 0;
+
+video_clean:
+	sunxi_video_cleanup(&csi->video);
+v4l2_clean:
+	sunxi_csi_v4l2_cleanup(csi);
+	return ret;
+}
+
+int sunxi_csi_cleanup(struct sunxi_csi *csi)
+{
+	sunxi_video_cleanup(&csi->video);
+	sunxi_graph_cleanup(csi);
+	sunxi_csi_v4l2_cleanup(csi);
+
+	return 0;
+}
diff --git a/drivers/media/platform/sunxi-csi/sunxi_csi.h b/drivers/media/platform/sunxi-csi/sunxi_csi.h
new file mode 100644
index 0000000..a44d39f
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/sunxi_csi.h
@@ -0,0 +1,203 @@
+/*
+ * Copyright (c) 2017 Yong Deng <yong.deng@magewell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __SUNXI_CSI_H__
+#define __SUNXI_CSI_H__
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+
+#include "sunxi_video.h"
+
+struct sunxi_csi;
+
+/**
+ * struct sunxi_csi_config - configs for sunxi csi
+ * @pixelformat: v4l2 pixel format (V4L2_PIX_FMT_*)
+ * @code:	media bus format code (MEDIA_BUS_FMT_*)
+ * @field:	used interlacing type (enum v4l2_field)
+ * @width:	frame width
+ * @height:	frame height
+ */
+struct sunxi_csi_config {
+	u32		pixelformat;
+	u32		code;
+	u32		field;
+	u32		width;
+	u32		height;
+};
+
+struct sunxi_csi_ops {
+	int (*get_supported_pixformats)(struct sunxi_csi *csi,
+					const u32 **pixformats);
+	bool (*is_format_support)(struct sunxi_csi *csi, u32 pixformat,
+				  u32 mbus_code);
+	int (*s_power)(struct sunxi_csi *csi, bool enable);
+	int (*update_config)(struct sunxi_csi *csi,
+			     struct sunxi_csi_config *config);
+	int (*update_buf_addr)(struct sunxi_csi *csi, dma_addr_t addr);
+	int (*s_stream)(struct sunxi_csi *csi, bool enable);
+};
+
+struct sunxi_csi {
+	struct device			*dev;
+	struct v4l2_device		v4l2_dev;
+	struct media_device		media_dev;
+
+	struct list_head		entities;
+	unsigned int			num_subdevs;
+	struct v4l2_async_notifier	notifier;
+
+	/* video port settings */
+	struct v4l2_of_endpoint		v4l2_ep;
+
+	struct sunxi_csi_config		config;
+
+	struct sunxi_video		video;
+
+	struct sunxi_csi_ops		*ops;
+};
+
+int sunxi_csi_init(struct sunxi_csi *csi);
+int sunxi_csi_cleanup(struct sunxi_csi *csi);
+
+/**
+ * sunxi_csi_get_supported_pixformats() - get csi supported pixformats
+ * @csi: 	pointer to the csi
+ * @pixformats: supported pixformats return from csi
+ *
+ * @return the count of pixformats or error(< 0)
+ */
+static inline int
+sunxi_csi_get_supported_pixformats(struct sunxi_csi *csi,
+				   const u32 **pixformats)
+{
+	if (csi->ops != NULL && csi->ops->get_supported_pixformats != NULL)
+		return csi->ops->get_supported_pixformats(csi, pixformats);
+
+	return -ENOIOCTLCMD;
+}
+
+/**
+ * sunxi_csi_is_format_support() - check if the format supported by csi
+ * @csi: 	pointer to the csi
+ * @pixformat:	v4l2 pixel format (V4L2_PIX_FMT_*)
+ * @mbus_code:	media bus format code (MEDIA_BUS_FMT_*)
+ */
+static inline bool
+sunxi_csi_is_format_support(struct sunxi_csi *csi, u32 pixformat, u32 mbus_code)
+{
+	if (csi->ops != NULL && csi->ops->is_format_support != NULL)
+		return csi->ops->is_format_support(csi, pixformat, mbus_code);
+
+	return -ENOIOCTLCMD;
+}
+
+/**
+ * sunxi_csi_set_power() - power on/off the csi
+ * @csi: 	pointer to the csi
+ * @enable:	on/off
+ */
+static inline int sunxi_csi_set_power(struct sunxi_csi *csi, bool enable)
+{
+	if (csi->ops != NULL && csi->ops->s_power != NULL)
+		return csi->ops->s_power(csi, enable);
+
+	return -ENOIOCTLCMD;
+}
+
+/**
+ * sunxi_csi_update_config() - update the csi register setttings
+ * @csi: 	pointer to the csi
+ * @config:	see struct sunxi_csi_config
+ */
+static inline int
+sunxi_csi_update_config(struct sunxi_csi *csi, struct sunxi_csi_config *config)
+{
+	if (csi->ops != NULL && csi->ops->update_config != NULL)
+		return csi->ops->update_config(csi, config);
+
+	return -ENOIOCTLCMD;
+}
+
+/**
+ * sunxi_csi_update_buf_addr() - update the csi frame buffer address
+ * @csi: 	pointer to the csi
+ * @addr:	frame buffer's physical address
+ */
+static inline int sunxi_csi_update_buf_addr(struct sunxi_csi *csi,
+					    dma_addr_t addr)
+{
+	if (csi->ops != NULL && csi->ops->update_buf_addr != NULL)
+		return csi->ops->update_buf_addr(csi, addr);
+
+	return -ENOIOCTLCMD;
+}
+
+/**
+ * sunxi_csi_set_stream() - start/stop csi streaming
+ * @csi: 	pointer to the csi
+ * @enable:	start/stop
+ */
+static inline int sunxi_csi_set_stream(struct sunxi_csi *csi, bool enable)
+{
+	if (csi->ops != NULL && csi->ops->s_stream != NULL)
+		return csi->ops->s_stream(csi, enable);
+
+	return -ENOIOCTLCMD;
+}
+
+static inline int v4l2_pixformat_get_bpp(unsigned int pixformat)
+{
+	switch (pixformat) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		return 8;
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+		return 10;
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_HM12:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		return 12;
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_YUV422P:
+		return 16;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_BGR24:
+		return 24;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_BGR32:
+		return 32;
+	}
+
+	return 0;
+}
+
+#endif /* __SUNXI_CSI_H__ */
diff --git a/drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c b/drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c
new file mode 100644
index 0000000..6496bdd
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c
@@ -0,0 +1,827 @@
+/*
+ * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing).
+ * All rights reserved.
+ * Author: Yong Deng <yong.deng@magewell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioctl.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+
+#include "sunxi_csi.h"
+#include "sunxi_csi_v3s.h"
+
+#define MODULE_NAME	"sunxi-csi"
+
+struct sunxi_csi_dev {
+	struct sunxi_csi		csi;
+	struct device			*dev;
+
+	struct regmap			*regmap;
+	struct clk			*clk_ahb;
+	struct clk			*clk_mod;
+	struct clk			*clk_ram;
+	struct reset_control		*rstc_ahb;
+
+	int				planar_offset[3];
+};
+
+static const u32 supported_pixformats[] = {
+	V4L2_PIX_FMT_SBGGR8,
+	V4L2_PIX_FMT_SGBRG8,
+	V4L2_PIX_FMT_SGRBG8,
+	V4L2_PIX_FMT_SRGGB8,
+	V4L2_PIX_FMT_SBGGR10,
+	V4L2_PIX_FMT_SGBRG10,
+	V4L2_PIX_FMT_SGRBG10,
+	V4L2_PIX_FMT_SRGGB10,
+	V4L2_PIX_FMT_SBGGR12,
+	V4L2_PIX_FMT_SGBRG12,
+	V4L2_PIX_FMT_SGRBG12,
+	V4L2_PIX_FMT_SRGGB12,
+	V4L2_PIX_FMT_YUYV,
+	V4L2_PIX_FMT_YVYU,
+	V4L2_PIX_FMT_UYVY,
+	V4L2_PIX_FMT_VYUY,
+	V4L2_PIX_FMT_HM12,
+	V4L2_PIX_FMT_NV12,
+	V4L2_PIX_FMT_NV21,
+	V4L2_PIX_FMT_YUV420,
+	V4L2_PIX_FMT_YVU420,
+	V4L2_PIX_FMT_NV16,
+	V4L2_PIX_FMT_NV61,
+	V4L2_PIX_FMT_YUV422P,
+};
+
+static inline struct sunxi_csi_dev *sunxi_csi_to_dev(struct sunxi_csi *csi)
+{
+	return container_of(csi, struct sunxi_csi_dev, csi);
+}
+
+/* TODO add 10&12 bit YUV, RGB support */
+static bool __is_format_support(struct sunxi_csi_dev *sdev,
+			      u32 fourcc, u32 mbus_code)
+{
+	/*
+	 * Some video receiver have capability both 8bit and 16bit.
+	 * Identify the media bus format from device tree.
+	 */
+	if (((sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_PARALLEL
+	      || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_BT656)
+	     && sdev->csi.v4l2_ep.bus.parallel.bus_width == 16)
+	    || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_CSI2) {
+		switch (fourcc) {
+		case V4L2_PIX_FMT_HM12:
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV61:
+		case V4L2_PIX_FMT_YUV420:
+		case V4L2_PIX_FMT_YVU420:
+		case V4L2_PIX_FMT_YUV422P:
+			switch (mbus_code) {
+			case MEDIA_BUS_FMT_UYVY8_1X16:
+			case MEDIA_BUS_FMT_VYUY8_1X16:
+			case MEDIA_BUS_FMT_YUYV8_1X16:
+			case MEDIA_BUS_FMT_YVYU8_1X16:
+				return true;
+			}
+			break;
+		}
+		return false;
+	}
+
+	switch (fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+		if (mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SGBRG8:
+		if (mbus_code == MEDIA_BUS_FMT_SGBRG8_1X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SGRBG8:
+		if (mbus_code == MEDIA_BUS_FMT_SGRBG8_1X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SRGGB8:
+		if (mbus_code == MEDIA_BUS_FMT_SRGGB8_1X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SBGGR10:
+		if (mbus_code == MEDIA_BUS_FMT_SBGGR10_1X10)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SGBRG10:
+		if (mbus_code == MEDIA_BUS_FMT_SGBRG10_1X10)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SGRBG10:
+		if (mbus_code == MEDIA_BUS_FMT_SGRBG10_1X10)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SRGGB10:
+		if (mbus_code == MEDIA_BUS_FMT_SRGGB10_1X10)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SBGGR12:
+		if (mbus_code == MEDIA_BUS_FMT_SBGGR12_1X12)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SGBRG12:
+		if (mbus_code == MEDIA_BUS_FMT_SGBRG12_1X12)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SGRBG12:
+		if (mbus_code == MEDIA_BUS_FMT_SGRBG12_1X12)
+			return true;
+		break;
+	case V4L2_PIX_FMT_SRGGB12:
+		if (mbus_code == MEDIA_BUS_FMT_SRGGB12_1X12)
+			return true;
+		break;
+
+	case V4L2_PIX_FMT_YUYV:
+		if (mbus_code == MEDIA_BUS_FMT_YUYV8_2X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		if (mbus_code == MEDIA_BUS_FMT_YVYU8_2X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		if (mbus_code == MEDIA_BUS_FMT_UYVY8_2X8)
+			return true;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		if (mbus_code == MEDIA_BUS_FMT_VYUY8_2X8)
+			return true;
+		break;
+
+	case V4L2_PIX_FMT_HM12:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV422P:
+		switch (mbus_code) {
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_VYUY8_2X8:
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_YVYU8_2X8:
+			return true;
+		}
+		break;
+	}
+
+	return false;
+}
+
+static enum csi_input_fmt get_csi_input_format(u32 mbus_code, u32 pixformat)
+{
+	/* bayer */
+	if ((mbus_code & 0xF000) == 0x3000)
+		return CSI_INPUT_FORMAT_RAW;
+
+	switch (pixformat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		return CSI_INPUT_FORMAT_RAW;
+	}
+
+	/* not support YUV420 input format yet */
+	return CSI_INPUT_FORMAT_YUV422;
+}
+
+static enum csi_output_fmt get_csi_output_format(u32 pixformat, u32 field)
+{
+	bool buf_interlaced = false;
+	if (field == V4L2_FIELD_INTERLACED
+	    || field == V4L2_FIELD_INTERLACED_TB
+	    || field == V4L2_FIELD_INTERLACED_BT)
+		buf_interlaced = true;
+
+	switch (pixformat) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		return buf_interlaced ? CSI_FRAME_RAW_8 : CSI_FIELD_RAW_8;
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+		return buf_interlaced ? CSI_FRAME_RAW_10 : CSI_FIELD_RAW_10;
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
+		return buf_interlaced ? CSI_FRAME_RAW_12 : CSI_FIELD_RAW_12;
+
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		return buf_interlaced ? CSI_FRAME_RAW_8 : CSI_FIELD_RAW_8;
+
+	case V4L2_PIX_FMT_HM12:
+		return buf_interlaced ? CSI_FRAME_MB_YUV420 :
+					CSI_FIELD_MB_YUV420;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		return buf_interlaced ? CSI_FRAME_UV_CB_YUV420 :
+					CSI_FIELD_UV_CB_YUV420;
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		return buf_interlaced ? CSI_FRAME_PLANAR_YUV420 :
+					CSI_FIELD_PLANAR_YUV420;
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		return buf_interlaced ? CSI_FRAME_UV_CB_YUV422 :
+					CSI_FIELD_UV_CB_YUV422;
+	case V4L2_PIX_FMT_YUV422P:
+		return buf_interlaced ? CSI_FRAME_PLANAR_YUV422 :
+					CSI_FIELD_PLANAR_YUV422;
+	}
+
+	return 0;
+}
+
+static enum csi_input_seq get_csi_input_seq(u32 mbus_code, u32 pixformat)
+{
+
+	switch (pixformat) {
+	case V4L2_PIX_FMT_HM12:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV422P:
+		switch(mbus_code) {
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY8_1X16:
+			return CSI_INPUT_SEQ_UYVY;
+		case MEDIA_BUS_FMT_VYUY8_2X8:
+		case MEDIA_BUS_FMT_VYUY8_1X16:
+			return CSI_INPUT_SEQ_VYUY;
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+			return CSI_INPUT_SEQ_YUYV;
+		case MEDIA_BUS_FMT_YVYU8_1X16:
+		case MEDIA_BUS_FMT_YVYU8_2X8:
+			return CSI_INPUT_SEQ_YVYU;
+		}
+		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_YVU420:
+		switch(mbus_code) {
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY8_1X16:
+			return CSI_INPUT_SEQ_VYUY;
+		case MEDIA_BUS_FMT_VYUY8_2X8:
+		case MEDIA_BUS_FMT_VYUY8_1X16:
+			return CSI_INPUT_SEQ_UYVY;
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+			return CSI_INPUT_SEQ_YVYU;
+		case MEDIA_BUS_FMT_YVYU8_1X16:
+		case MEDIA_BUS_FMT_YVYU8_2X8:
+			return CSI_INPUT_SEQ_YUYV;
+		}
+		break;
+	}
+
+	return CSI_INPUT_SEQ_YUYV;
+}
+
+#ifdef DEBUG
+static void sunxi_csi_dump_regs(struct sunxi_csi_dev *sdev)
+{
+	struct regmap *regmap = sdev->regmap;
+	u32 val;
+
+	regmap_read(regmap, CSI_EN_REG, &val);
+	printk("CSI_EN_REG=0x%x\n",		val);
+	regmap_read(regmap, CSI_IF_CFG_REG, &val);
+	printk("CSI_IF_CFG_REG=0x%x\n",		val);
+	regmap_read(regmap, CSI_CAP_REG, &val);
+	printk("CSI_CAP_REG=0x%x\n",		val);
+	regmap_read(regmap, CSI_SYNC_CNT_REG, &val);
+	printk("CSI_SYNC_CNT_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_FIFO_THRS_REG, &val);
+	printk("CSI_FIFO_THRS_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_PTN_LEN_REG, &val);
+	printk("CSI_PTN_LEN_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_PTN_ADDR_REG, &val);
+	printk("CSI_PTN_ADDR_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_VER_REG, &val);
+	printk("CSI_VER_REG=0x%x\n",		val);
+	regmap_read(regmap, CSI_CH_CFG_REG, &val);
+	printk("CSI_CH_CFG_REG=0x%x\n",		val);
+	regmap_read(regmap, CSI_CH_SCALE_REG, &val);
+	printk("CSI_CH_SCALE_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_F0_BUFA_REG, &val);
+	printk("CSI_CH_F0_BUFA_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_F1_BUFA_REG, &val);
+	printk("CSI_CH_F1_BUFA_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_F2_BUFA_REG, &val);
+	printk("CSI_CH_F2_BUFA_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_STA_REG, &val);
+	printk("CSI_CH_STA_REG=0x%x\n",		val);
+	regmap_read(regmap, CSI_CH_INT_EN_REG, &val);
+	printk("CSI_CH_INT_EN_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_INT_STA_REG, &val);
+	printk("CSI_CH_INT_STA_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_FLD1_VSIZE_REG, &val);
+	printk("CSI_CH_FLD1_VSIZE_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_HSIZE_REG, &val);
+	printk("CSI_CH_HSIZE_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_VSIZE_REG, &val);
+	printk("CSI_CH_VSIZE_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_BUF_LEN_REG, &val);
+	printk("CSI_CH_BUF_LEN_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_FLIP_SIZE_REG, &val);
+	printk("CSI_CH_FLIP_SIZE_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_FRM_CLK_CNT_REG, &val);
+	printk("CSI_CH_FRM_CLK_CNT_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_ACC_ITNL_CLK_CNT_REG, &val);
+	printk("CSI_CH_ACC_ITNL_CLK_CNT_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_FIFO_STAT_REG, &val);
+	printk("CSI_CH_FIFO_STAT_REG=0x%x\n",	val);
+	regmap_read(regmap, CSI_CH_PCLK_STAT_REG, &val);
+	printk("CSI_CH_PCLK_STAT_REG=0x%x\n",	val);
+}
+#endif
+
+static void sunxi_csi_setup_bus(struct sunxi_csi_dev *sdev)
+{
+	struct v4l2_of_endpoint *endpoint = &sdev->csi.v4l2_ep;
+	unsigned char bus_width;
+	u32 flags;
+	u32 cfg;
+
+	bus_width = endpoint->bus.parallel.bus_width;
+
+	regmap_read(sdev->regmap, CSI_IF_CFG_REG, &cfg);
+
+	cfg &= ~(CSI_IF_CFG_CSI_IF_MASK | CSI_IF_CFG_MIPI_IF_MASK |
+		 CSI_IF_CFG_IF_DATA_WIDTH_MASK |
+		 CSI_IF_CFG_CLK_POL_MASK | CSI_IF_CFG_VREF_POL_MASK |
+		 CSI_IF_CFG_HREF_POL_MASK | CSI_IF_CFG_FIELD_MASK);
+
+	switch (endpoint->bus_type) {
+	case V4L2_MBUS_CSI2:
+		cfg |= CSI_IF_CFG_MIPI_IF_MIPI;
+		break;
+	case V4L2_MBUS_PARALLEL:
+		cfg |= CSI_IF_CFG_MIPI_IF_CSI;
+
+		flags = endpoint->bus.parallel.flags;
+
+		cfg |= (bus_width == 16) ? CSI_IF_CFG_CSI_IF_YUV422_16BIT :
+					   CSI_IF_CFG_CSI_IF_YUV422_INTLV;
+
+		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
+			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
+
+		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+			cfg |= CSI_IF_CFG_VREF_POL_POSITIVE;
+		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+			cfg |= CSI_IF_CFG_HREF_POL_POSITIVE;
+
+		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
+		break;
+	case V4L2_MBUS_BT656:
+		cfg |= CSI_IF_CFG_MIPI_IF_CSI;
+
+		flags = endpoint->bus.parallel.flags;
+
+		cfg |= (bus_width == 16) ? CSI_IF_CFG_CSI_IF_BT1120 :
+					   CSI_IF_CFG_CSI_IF_BT656;
+
+		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
+			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
+
+		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	switch (bus_width) {
+	case 8:
+		cfg |= CSI_IF_CFG_IF_DATA_WIDTH_8BIT;
+		break;
+	case 10:
+		cfg |= CSI_IF_CFG_IF_DATA_WIDTH_10BIT;
+		break;
+	case 12:
+		cfg |= CSI_IF_CFG_IF_DATA_WIDTH_12BIT;
+		break;
+	default:
+		break;
+	}
+
+	regmap_write(sdev->regmap, CSI_IF_CFG_REG, cfg);
+}
+
+static void sunxi_csi_set_format(struct sunxi_csi_dev *sdev)
+{
+	struct sunxi_csi *csi = &sdev->csi;
+	u32 cfg;
+	u32 val;
+
+	regmap_read(sdev->regmap, CSI_CH_CFG_REG, &cfg);
+
+	cfg &= ~(CSI_CH_CFG_INPUT_FMT_MASK |
+		 CSI_CH_CFG_OUTPUT_FMT_MASK | CSI_CH_CFG_VFLIP_EN |
+		 CSI_CH_CFG_HFLIP_EN | CSI_CH_CFG_FIELD_SEL_MASK |
+		 CSI_CH_CFG_INPUT_SEQ_MASK);
+
+	val = get_csi_input_format(csi->config.code, csi->config.pixelformat);
+	cfg |= CSI_CH_CFG_INPUT_FMT(val);
+
+	val = get_csi_output_format(csi->config.code, csi->config.field);
+	cfg |= CSI_CH_CFG_OUTPUT_FMT(val);
+
+	val = get_csi_input_seq(csi->config.code, csi->config.pixelformat);
+	cfg |= CSI_CH_CFG_INPUT_SEQ(val);
+
+	if (csi->config.field == V4L2_FIELD_TOP)
+		cfg |= CSI_CH_CFG_FIELD_SEL_FIELD0;
+	else if (csi->config.field == V4L2_FIELD_BOTTOM)
+		cfg |= CSI_CH_CFG_FIELD_SEL_FIELD1;
+	else
+		cfg |= CSI_CH_CFG_FIELD_SEL_BOTH;
+
+	regmap_write(sdev->regmap, CSI_CH_CFG_REG, cfg);
+}
+
+static void sunxi_csi_set_window(struct sunxi_csi_dev *sdev)
+{
+	struct sunxi_csi_config *config = &sdev->csi.config;
+	u32 bytesperline_y;
+	u32 bytesperline_c;
+	int *planar_offset = sdev->planar_offset;
+
+	regmap_write(sdev->regmap, CSI_CH_HSIZE_REG,
+		     CSI_CH_HSIZE_HOR_LEN(config->width) |
+		     CSI_CH_HSIZE_HOR_START(0));
+	regmap_write(sdev->regmap, CSI_CH_VSIZE_REG,
+		     CSI_CH_VSIZE_VER_LEN(config->height) |
+		     CSI_CH_VSIZE_VER_START(0));
+
+	planar_offset[0] = 0;
+	switch(config->pixelformat) {
+	case V4L2_PIX_FMT_HM12:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		bytesperline_y = config->width;
+		bytesperline_c = config->width;
+		planar_offset[1] = bytesperline_y * config->height;
+		planar_offset[2] = -1;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		bytesperline_y = config->width;
+		bytesperline_c = config->width / 2;
+		planar_offset[1] = bytesperline_y * config->height;
+		planar_offset[2] = planar_offset[1] +
+				bytesperline_c * config->height / 2;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		bytesperline_y = config->width;
+		bytesperline_c = config->width / 2;
+		planar_offset[1] = bytesperline_y * config->height;
+		planar_offset[2] = planar_offset[1] +
+				bytesperline_c * config->height;
+		break;
+	default: /* raw */
+		bytesperline_y = (v4l2_pixformat_get_bpp(config->pixelformat) *
+				  config->width) / 8;
+		bytesperline_c = 0;
+		planar_offset[1] = -1;
+		planar_offset[2] = -1;
+		break;
+	}
+
+	regmap_write(sdev->regmap, CSI_CH_BUF_LEN_REG,
+		     CSI_CH_BUF_LEN_BUF_LEN_C(bytesperline_c) |
+		     CSI_CH_BUF_LEN_BUF_LEN_Y(bytesperline_y));
+}
+
+static int get_supported_pixformats(struct sunxi_csi *csi,
+				    const u32 **pixformats)
+{
+	if (pixformats != NULL)
+		*pixformats = supported_pixformats;
+
+	return ARRAY_SIZE(supported_pixformats);
+}
+
+static bool is_format_support(struct sunxi_csi *csi, u32 pixformat,
+			      u32 mbus_code)
+{
+	struct sunxi_csi_dev *sdev = sunxi_csi_to_dev(csi);
+
+	return __is_format_support(sdev, pixformat, mbus_code);
+}
+
+static int set_power(struct sunxi_csi *csi, bool enable)
+{
+	struct sunxi_csi_dev *sdev = sunxi_csi_to_dev(csi);
+	struct regmap *regmap = sdev->regmap;
+	int ret;
+
+	if (!enable) {
+		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
+
+		clk_disable_unprepare(sdev->clk_ram);
+		clk_disable_unprepare(sdev->clk_mod);
+		clk_disable_unprepare(sdev->clk_ahb);
+		reset_control_assert(sdev->rstc_ahb);
+		return 0;
+	}
+
+	ret = clk_prepare_enable(sdev->clk_ahb);
+	if (ret) {
+		dev_err(sdev->dev, "Enable ahb clk err %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(sdev->clk_mod);
+	if (ret) {
+		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(sdev->clk_ram);
+	if (ret) {
+		dev_err(sdev->dev, "Enable clk_dram_csi clk err %d\n", ret);
+		return ret;
+	}
+
+	if (!IS_ERR_OR_NULL(sdev->rstc_ahb)) {
+		ret = reset_control_deassert(sdev->rstc_ahb);
+		if (ret) {
+			dev_err(sdev->dev, "reset err %d\n", ret);
+			return ret;
+		}
+	}
+
+	regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, CSI_EN_CSI_EN);
+
+	return 0;
+}
+
+static int update_config(struct sunxi_csi *csi,
+			 struct sunxi_csi_config *config)
+{
+	struct sunxi_csi_dev *sdev = sunxi_csi_to_dev(csi);
+
+	if (config == NULL)
+		return -EINVAL;
+
+	memcpy(&csi->config, config, sizeof(csi->config));
+
+	sunxi_csi_setup_bus(sdev);
+	sunxi_csi_set_format(sdev);
+	sunxi_csi_set_window(sdev);
+
+	return 0;
+}
+
+static int update_buf_addr(struct sunxi_csi *csi, dma_addr_t addr)
+{
+	struct sunxi_csi_dev *sdev = sunxi_csi_to_dev(csi);
+	/* transform physical address to bus address */
+	dma_addr_t bus_addr = addr - 0x40000000;
+
+	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
+		     (bus_addr + sdev->planar_offset[0]) >> 2);
+	if (sdev->planar_offset[1] != -1)
+		regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
+			     (bus_addr + sdev->planar_offset[1]) >> 2);
+	if (sdev->planar_offset[2] != -1)
+		regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
+			     (bus_addr + sdev->planar_offset[2]) >> 2);
+
+	return 0;
+}
+
+static int set_stream(struct sunxi_csi *csi, bool enable)
+{
+	struct sunxi_csi_dev *sdev = sunxi_csi_to_dev(csi);
+	struct regmap *regmap = sdev->regmap;
+
+	if (!enable) {
+		regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON, 0);
+		regmap_write(regmap, CSI_CH_INT_EN_REG, 0);
+		return 0;
+	}
+
+	regmap_write(regmap, CSI_CH_INT_STA_REG, 0xFF);
+	regmap_write(regmap, CSI_CH_INT_EN_REG,
+		     CSI_CH_INT_EN_HB_OF_INT_EN |
+		     CSI_CH_INT_EN_FIFO2_OF_INT_EN |
+		     CSI_CH_INT_EN_FIFO1_OF_INT_EN |
+		     CSI_CH_INT_EN_FIFO0_OF_INT_EN |
+		     CSI_CH_INT_EN_FD_INT_EN |
+		     CSI_CH_INT_EN_CD_INT_EN);
+
+	regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON,
+			   CSI_CAP_CH0_VCAP_ON);
+
+	return 0;
+}
+
+static struct sunxi_csi_ops csi_ops = {
+	.get_supported_pixformats	= get_supported_pixformats,
+	.is_format_support		= is_format_support,
+	.s_power			= set_power,
+	.update_config			= update_config,
+	.update_buf_addr		= update_buf_addr,
+	.s_stream			= set_stream,
+};
+
+static irqreturn_t sunxi_csi_isr(int irq, void *dev_id)
+{
+	struct sunxi_csi_dev *sdev = (struct sunxi_csi_dev *)dev_id;
+	struct regmap *regmap = sdev->regmap;
+	u32 status;
+
+	regmap_read(regmap, CSI_CH_INT_STA_REG, &status);
+
+	if ((status & CSI_CH_INT_STA_FIFO0_OF_PD) ||
+	    (status & CSI_CH_INT_STA_FIFO1_OF_PD) ||
+	    (status & CSI_CH_INT_STA_FIFO2_OF_PD) ||
+	    (status & CSI_CH_INT_STA_HB_OF_PD)) {
+		regmap_write(regmap, CSI_CH_INT_STA_REG, status);
+		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
+		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN,
+				   CSI_EN_CSI_EN);
+		return IRQ_HANDLED;
+	}
+
+	if (status & CSI_CH_INT_STA_FD_PD) {
+		sunxi_video_frame_done(&sdev->csi.video);
+	}
+
+	regmap_write(regmap, CSI_CH_INT_STA_REG, status);
+
+	return IRQ_HANDLED;
+}
+
+static const struct regmap_config sunxi_csi_regmap_config = {
+	.reg_bits       = 32,
+	.reg_stride     = 4,
+	.val_bits       = 32,
+	.max_register	= 0x1000,
+};
+
+static int sunxi_csi_resource_request(struct sunxi_csi_dev *sdev,
+				      struct platform_device *pdev)
+{
+	struct resource *res;
+	void __iomem *io_base;
+	int ret;
+	int irq;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "csi");
+	io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(io_base))
+		return PTR_ERR(io_base);
+
+	sdev->regmap = devm_regmap_init_mmio(&pdev->dev, io_base,
+					    &sunxi_csi_regmap_config);
+	if (IS_ERR(sdev->regmap)) {
+		dev_err(&pdev->dev, "Failed to init register map\n");
+		return PTR_ERR(sdev->regmap);
+	}
+
+	sdev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(sdev->clk_ahb)) {
+		dev_err(&pdev->dev, "Unable to acquire ahb clock\n");
+		return PTR_ERR(sdev->clk_ahb);
+	}
+
+	sdev->clk_mod = devm_clk_get(&pdev->dev, "mod");
+	if (IS_ERR(sdev->clk_mod)) {
+		dev_err(&pdev->dev, "Unable to acquire csi clock\n");
+		return PTR_ERR(sdev->clk_mod);
+	}
+
+	sdev->clk_ram = devm_clk_get(&pdev->dev, "ram");
+	if (IS_ERR(sdev->clk_ram)) {
+		dev_err(&pdev->dev, "Unable to acquire dram-csi clock\n");
+		return PTR_ERR(sdev->clk_ram);
+	}
+
+	sdev->rstc_ahb = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
+	if (IS_ERR(sdev->rstc_ahb)) {
+		dev_err(&pdev->dev, "Cannot get reset controller\n");
+		return PTR_ERR(sdev->rstc_ahb);
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "No csi IRQ specified\n");
+		ret = -ENXIO;
+		return ret;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, sunxi_csi_isr, 0, MODULE_NAME,
+			       sdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot request csi IRQ\n");
+		return ret;
+	}
+	return 0;
+}
+
+static int sunxi_csi_probe(struct platform_device *pdev)
+{
+	struct sunxi_csi_dev *sdev;
+	int ret;
+
+	sdev = devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
+	if (!sdev)
+		return -ENOMEM;
+
+	sdev->dev = &pdev->dev;
+
+	ret = sunxi_csi_resource_request(sdev, pdev);
+	if (ret)
+		return ret;
+
+	sdev->csi.dev = &pdev->dev;
+	sdev->csi.ops = &csi_ops;
+	ret = sunxi_csi_init(&sdev->csi);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, sdev);
+
+	return 0;
+}
+
+static int sunxi_csi_remove(struct platform_device *pdev)
+{
+	struct sunxi_csi_dev *sdev = platform_get_drvdata(pdev);
+
+	sunxi_csi_cleanup(&sdev->csi);
+
+	return 0;
+}
+
+static const struct of_device_id sunxi_csi_of_match[] = {
+	{ .compatible = "allwinner,sun8i-v3s-csi", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, sunxi_csi_of_match);
+
+static struct platform_driver sunxi_csi_platform_driver = {
+	.probe = sunxi_csi_probe,
+	.remove = sunxi_csi_remove,
+	.driver = {
+		.name = MODULE_NAME,
+		.of_match_table = of_match_ptr(sunxi_csi_of_match),
+	},
+};
+module_platform_driver(sunxi_csi_platform_driver);
+
+MODULE_DESCRIPTION("Allwinner V3s Camera Sensor Interface driver");
+MODULE_AUTHOR("Yong Deng <yong.deng@magewell.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h b/drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h
new file mode 100644
index 0000000..6b50152
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h
@@ -0,0 +1,206 @@
+/*
+ * Copyright (c) 2017 Yong Deng <yong.deng@magewell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __SUNXI_CSI_V3S_H__
+#define __SUNXI_CSI_V3S_H__
+
+#include <linux/kernel.h>
+
+#define CSI_EN_REG			0x0
+#define CSI_EN_VER_EN				BIT(30)
+#define CSI_EN_CSI_EN				BIT(0)
+
+#define CSI_IF_CFG_REG			0x4
+#define CSI_IF_CFG_SRC_TYPE_MASK		BIT(21)
+#define CSI_IF_CFG_SRC_TYPE_PROGRESSED		((0 << 21) & CSI_IF_CFG_SRC_TYPE_MASK)
+#define CSI_IF_CFG_SRC_TYPE_INTERLACED		((1 << 21) & CSI_IF_CFG_SRC_TYPE_MASK)
+#define CSI_IF_CFG_FPS_DS_EN			BIT(20)
+#define CSI_IF_CFG_FIELD_MASK			BIT(19)
+#define CSI_IF_CFG_FIELD_NEGATIVE		((0 << 19) & CSI_IF_CFG_FIELD_MASK)
+#define CSI_IF_CFG_FIELD_POSITIVE		((1 << 19) & CSI_IF_CFG_FIELD_MASK)
+#define CSI_IF_CFG_VREF_POL_MASK		BIT(18)
+#define CSI_IF_CFG_VREF_POL_NEGATIVE		((0 << 18) & CSI_IF_CFG_VREF_POL_MASK)
+#define CSI_IF_CFG_VREF_POL_POSITIVE		((1 << 18) & CSI_IF_CFG_VREF_POL_MASK)
+#define CSI_IF_CFG_HREF_POL_MASK		BIT(17)
+#define CSI_IF_CFG_HREF_POL_NEGATIVE		((0 << 17) & CSI_IF_CFG_HREF_POL_MASK)
+#define CSI_IF_CFG_HREF_POL_POSITIVE		((1 << 17) & CSI_IF_CFG_HREF_POL_MASK)
+#define CSI_IF_CFG_CLK_POL_MASK			BIT(16)
+#define CSI_IF_CFG_CLK_POL_RISING_EDGE		((0 << 16) & CSI_IF_CFG_CLK_POL_MASK)
+#define CSI_IF_CFG_CLK_POL_FALLING_EDGE		((1 << 16) & CSI_IF_CFG_CLK_POL_MASK)
+#define CSI_IF_CFG_IF_DATA_WIDTH_MASK		GENMASK(10, 8)
+#define CSI_IF_CFG_IF_DATA_WIDTH_8BIT		((0 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
+#define CSI_IF_CFG_IF_DATA_WIDTH_10BIT		((1 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
+#define CSI_IF_CFG_IF_DATA_WIDTH_12BIT		((2 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
+#define CSI_IF_CFG_MIPI_IF_MASK			BIT(7)
+#define CSI_IF_CFG_MIPI_IF_CSI			(0 << 7)
+#define CSI_IF_CFG_MIPI_IF_MIPI			(1 << 7)
+#define CSI_IF_CFG_CSI_IF_MASK			GENMASK(4, 0)
+#define CSI_IF_CFG_CSI_IF_YUV422_INTLV		((0 << 0) & CSI_IF_CFG_CSI_IF_MASK)
+#define CSI_IF_CFG_CSI_IF_YUV422_16BIT		((1 << 0) & CSI_IF_CFG_CSI_IF_MASK)
+#define CSI_IF_CFG_CSI_IF_BT656			((4 << 0) & CSI_IF_CFG_CSI_IF_MASK)
+#define CSI_IF_CFG_CSI_IF_BT1120		((5 << 0) & CSI_IF_CFG_CSI_IF_MASK)
+
+#define CSI_CAP_REG			0x8
+#define CSI_CAP_CH0_CAP_MASK_MASK		GENMASK(5, 2)
+#define CSI_CAP_CH0_CAP_MASK(count)		((count << 2) & CSI_CAP_CH0_CAP_MASK_MASK)
+#define CSI_CAP_CH0_VCAP_ON			BIT(1)
+#define CSI_CAP_CH0_SCAP_ON			BIT(0)
+
+#define CSI_SYNC_CNT_REG		0xc
+#define CSI_FIFO_THRS_REG		0x10
+#define CSI_BT656_HEAD_CFG_REG		0x14
+#define CSI_PTN_LEN_REG			0x30
+#define CSI_PTN_ADDR_REG		0x34
+#define CSI_VER_REG			0x3c
+
+#define CSI_CH_CFG_REG			0x44
+#define CSI_CH_CFG_INPUT_FMT_MASK		GENMASK(23, 20)
+#define CSI_CH_CFG_INPUT_FMT(fmt)		((fmt << 20) & CSI_CH_CFG_INPUT_FMT_MASK)
+#define CSI_CH_CFG_OUTPUT_FMT_MASK		GENMASK(19, 16)
+#define CSI_CH_CFG_OUTPUT_FMT(fmt)		((fmt << 16) & CSI_CH_CFG_OUTPUT_FMT_MASK)
+#define CSI_CH_CFG_VFLIP_EN			BIT(13)
+#define CSI_CH_CFG_HFLIP_EN			BIT(12)
+#define CSI_CH_CFG_FIELD_SEL_MASK		GENMASK(11, 10)
+#define CSI_CH_CFG_FIELD_SEL_FIELD0		((0 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
+#define CSI_CH_CFG_FIELD_SEL_FIELD1		((1 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
+#define CSI_CH_CFG_FIELD_SEL_BOTH		((2 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
+#define CSI_CH_CFG_INPUT_SEQ_MASK		GENMASK(9, 8)
+#define CSI_CH_CFG_INPUT_SEQ(seq)		((seq << 8) & CSI_CH_CFG_INPUT_SEQ_MASK)
+
+#define CSI_CH_SCALE_REG		0x4c
+#define CSI_CH_SCALE_QUART_EN			BIT(0)
+
+#define CSI_CH_F0_BUFA_REG		0x50
+
+#define CSI_CH_F1_BUFA_REG		0x58
+
+#define CSI_CH_F2_BUFA_REG		0x60
+
+#define CSI_CH_STA_REG			0x6c
+#define CSI_CH_STA_FIELD_STA_MASK		BIT(2)
+#define CSI_CH_STA_FIELD_STA_FIELD0		((0 << 2) & CSI_CH_STA_FIELD_STA_MASK)
+#define CSI_CH_STA_FIELD_STA_FIELD1		((1 << 2) & CSI_CH_STA_FIELD_STA_MASK)
+#define CSI_CH_STA_VCAP_STA			BIT(1)
+#define CSI_CH_STA_SCAP_STA			BIT(0)
+
+#define CSI_CH_INT_EN_REG		0x70
+#define CSI_CH_INT_EN_VS_INT_EN			BIT(7)
+#define CSI_CH_INT_EN_HB_OF_INT_EN		BIT(6)
+#define CSI_CH_INT_EN_MUL_ERR_INT_EN		BIT(5)
+#define CSI_CH_INT_EN_FIFO2_OF_INT_EN		BIT(4)
+#define CSI_CH_INT_EN_FIFO1_OF_INT_EN		BIT(3)
+#define CSI_CH_INT_EN_FIFO0_OF_INT_EN		BIT(2)
+#define CSI_CH_INT_EN_FD_INT_EN			BIT(1)
+#define CSI_CH_INT_EN_CD_INT_EN			BIT(0)
+
+#define CSI_CH_INT_STA_REG		0x74
+#define CSI_CH_INT_STA_VS_PD			BIT(7)
+#define CSI_CH_INT_STA_HB_OF_PD			BIT(6)
+#define CSI_CH_INT_STA_MUL_ERR_PD		BIT(5)
+#define CSI_CH_INT_STA_FIFO2_OF_PD		BIT(4)
+#define CSI_CH_INT_STA_FIFO1_OF_PD		BIT(3)
+#define CSI_CH_INT_STA_FIFO0_OF_PD		BIT(2)
+#define CSI_CH_INT_STA_FD_PD			BIT(1)
+#define CSI_CH_INT_STA_CD_PD			BIT(0)
+
+#define CSI_CH_FLD1_VSIZE_REG		0x74
+
+#define CSI_CH_HSIZE_REG		0x80
+#define CSI_CH_HSIZE_HOR_LEN_MASK		GENMASK(28, 16)
+#define CSI_CH_HSIZE_HOR_LEN(len)		((len << 16) & CSI_CH_HSIZE_HOR_LEN_MASK)
+#define CSI_CH_HSIZE_HOR_START_MASK		GENMASK(12, 0)
+#define CSI_CH_HSIZE_HOR_START(start)		((start << 0) & CSI_CH_HSIZE_HOR_START_MASK)
+
+#define CSI_CH_VSIZE_REG		0x84
+#define CSI_CH_VSIZE_VER_LEN_MASK		GENMASK(28, 16)
+#define CSI_CH_VSIZE_VER_LEN(len)		((len << 16) & CSI_CH_VSIZE_VER_LEN_MASK)
+#define CSI_CH_VSIZE_VER_START_MASK		GENMASK(12, 0)
+#define CSI_CH_VSIZE_VER_START(start)		((start << 0) & CSI_CH_VSIZE_VER_START_MASK)
+
+#define CSI_CH_BUF_LEN_REG		0x88
+#define CSI_CH_BUF_LEN_BUF_LEN_C_MASK		GENMASK(29, 16)
+#define CSI_CH_BUF_LEN_BUF_LEN_C(len)		((len << 16) & CSI_CH_BUF_LEN_BUF_LEN_C_MASK)
+#define CSI_CH_BUF_LEN_BUF_LEN_Y_MASK		GENMASK(13, 0)
+#define CSI_CH_BUF_LEN_BUF_LEN_Y(len)		((len << 0) & CSI_CH_BUF_LEN_BUF_LEN_Y_MASK)
+
+#define CSI_CH_FLIP_SIZE_REG		0x8c
+#define CSI_CH_FLIP_SIZE_VER_LEN_MASK		GENMASK(28, 16)
+#define CSI_CH_FLIP_SIZE_VER_LEN(len)		((len << 16) & CSI_CH_FLIP_SIZE_VER_LEN_MASK)
+#define CSI_CH_FLIP_SIZE_VALID_LEN_MASK		GENMASK(12, 0)
+#define CSI_CH_FLIP_SIZE_VALID_LEN(len)		((len << 0) & CSI_CH_FLIP_SIZE_VALID_LEN_MASK)
+
+#define CSI_CH_FRM_CLK_CNT_REG		0x90
+#define CSI_CH_ACC_ITNL_CLK_CNT_REG	0x94
+#define CSI_CH_FIFO_STAT_REG		0x98
+#define CSI_CH_PCLK_STAT_REG		0x9c
+
+/*
+ * csi input data format
+ */
+enum csi_input_fmt
+{
+	CSI_INPUT_FORMAT_RAW		= 0,
+	CSI_INPUT_FORMAT_YUV422		= 3,
+	CSI_INPUT_FORMAT_YUV420		= 4,
+};
+
+/*
+ * csi output data format
+ */
+enum csi_output_fmt
+{
+	/* only when input format is RAW */
+	CSI_FIELD_RAW_8			= 0,
+	CSI_FIELD_RAW_10		= 1,
+	CSI_FIELD_RAW_12		= 2,
+	CSI_FIELD_RGB565		= 4,
+	CSI_FIELD_RGB888		= 5,
+	CSI_FIELD_PRGB888		= 6,
+	CSI_FRAME_RAW_8			= 8,
+	CSI_FRAME_RAW_10		= 9,
+	CSI_FRAME_RAW_12		= 10,
+	CSI_FRAME_RGB565		= 12,
+	CSI_FRAME_RGB888		= 13,
+	CSI_FRAME_PRGB888		= 14,
+
+	/* only when input format is YUV422/YUV420 */
+	CSI_FIELD_PLANAR_YUV422		= 0,
+	CSI_FIELD_PLANAR_YUV420		= 1,
+	CSI_FRAME_PLANAR_YUV420		= 2,
+	CSI_FRAME_PLANAR_YUV422		= 3,
+	CSI_FIELD_UV_CB_YUV422		= 4,
+	CSI_FIELD_UV_CB_YUV420		= 5,
+	CSI_FRAME_UV_CB_YUV420		= 6,
+	CSI_FRAME_UV_CB_YUV422		= 7,
+	CSI_FIELD_MB_YUV422		= 8,
+	CSI_FIELD_MB_YUV420		= 9,
+	CSI_FRAME_MB_YUV420		= 10,
+	CSI_FRAME_MB_YUV422		= 11,
+	CSI_FIELD_UV_CB_YUV422_10	= 12,
+	CSI_FIELD_UV_CB_YUV420_10	= 13,
+};
+
+/*
+ * csi YUV input data sequence
+ */
+enum csi_input_seq
+{
+	/* only when input format is YUV422 */
+	CSI_INPUT_SEQ_YUYV = 0,
+	CSI_INPUT_SEQ_YVYU,
+	CSI_INPUT_SEQ_UYVY,
+	CSI_INPUT_SEQ_VYUY,
+};
+
+#endif /* __SUNXI_CSI_V3S_H__ */
diff --git a/drivers/media/platform/sunxi-csi/sunxi_video.c b/drivers/media/platform/sunxi-csi/sunxi_video.c
new file mode 100644
index 0000000..57d7563
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/sunxi_video.c
@@ -0,0 +1,667 @@
+/*
+ * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing).
+ * All rights reserved.
+ * Author: Yong Deng <yong.deng@magewell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/of.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "sunxi_csi.h"
+#include "sunxi_video.h"
+
+struct sunxi_csi_buffer {
+	struct vb2_v4l2_buffer		vb;
+	struct list_head		list;
+
+	dma_addr_t			dma_addr;
+};
+
+static struct sunxi_csi_format *
+find_format_by_fourcc(struct sunxi_video *video, unsigned int fourcc)
+{
+	unsigned int num_formats = video->num_formats;
+	struct sunxi_csi_format *fmt;
+	unsigned int i;
+
+	for (i = 0; i < num_formats; i++) {
+		fmt = &video->formats[i];
+		if (fmt->fourcc == fourcc)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static struct v4l2_subdev *
+sunxi_video_remote_subdev(struct sunxi_video *video, u32 *pad)
+{
+	struct media_pad *remote;
+
+	remote = media_entity_remote_pad(&video->pad);
+
+	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
+		return NULL;
+
+	if (pad)
+		*pad = remote->index;
+
+	return media_entity_to_v4l2_subdev(remote->entity);
+}
+
+static int sunxi_video_queue_setup(struct vb2_queue *vq,
+				 unsigned int *nbuffers, unsigned int *nplanes,
+				 unsigned int sizes[],
+				 struct device *alloc_devs[])
+{
+	struct sunxi_video *video = vb2_get_drv_priv(vq);
+	unsigned int size = video->fmt.fmt.pix.sizeimage;
+
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	return 0;
+}
+
+static int sunxi_video_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct sunxi_csi_buffer *buf =
+			container_of(vbuf, struct sunxi_csi_buffer, vb);
+	struct sunxi_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = video->fmt.fmt.pix.sizeimage;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		v4l2_err(video->vdev.v4l2_dev, "buffer too small (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+
+	buf->dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	vbuf->field = video->fmt.fmt.pix.field;
+
+	return 0;
+}
+
+static int sunxi_pipeline_set_stream(struct sunxi_video *video, bool enable)
+{
+	struct media_entity *entity;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	entity = &video->vdev.entity;
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad = media_entity_remote_pad(pad);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			break;
+
+		entity = pad->entity;
+		subdev = media_entity_to_v4l2_subdev(entity);
+
+		ret = v4l2_subdev_call(subdev, video, s_stream, enable);
+		if (enable && ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sunxi_video_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct sunxi_video *video = vb2_get_drv_priv(vq);
+	struct sunxi_csi_buffer *buf;
+	struct sunxi_csi_config config;
+	unsigned long flags;
+	int ret;
+
+	video->sequence = 0;
+
+	ret = media_pipeline_start(&video->vdev.entity, &video->vdev.pipe);
+	if (ret < 0)
+		goto err_start_pipeline;
+
+	ret = sunxi_pipeline_set_stream(video, true);
+	if (ret < 0)
+		goto err_start_stream;
+
+	config.pixelformat = video->fmt.fmt.pix.pixelformat;
+	config.code = video->current_fmt->mbus_code;
+	config.field = video->fmt.fmt.pix.field;
+	config.width = video->fmt.fmt.pix.width;
+	config.height = video->fmt.fmt.pix.height;
+
+	ret = sunxi_csi_update_config(video->csi, &config);
+	if (ret < 0)
+		goto err_update_config;
+
+	spin_lock_irqsave(&video->dma_queue_lock, flags);
+	video->cur_frm = list_first_entry(&video->dma_queue,
+					  struct sunxi_csi_buffer, list);
+	list_del(&video->cur_frm->list);
+	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
+
+	ret = sunxi_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
+	if (ret < 0)
+		goto err_update_addr;
+
+	ret = sunxi_csi_set_stream(video->csi, true);
+	if (ret < 0)
+		goto err_csi_stream;
+
+	return 0;
+
+err_csi_stream:
+err_update_addr:
+err_update_config:
+	sunxi_pipeline_set_stream(video, false);
+err_start_stream:
+	media_pipeline_stop(&video->vdev.entity);
+err_start_pipeline:
+	spin_lock_irqsave(&video->dma_queue_lock, flags);
+	list_for_each_entry(buf, &video->dma_queue, list)
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	INIT_LIST_HEAD(&video->dma_queue);
+	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
+
+	return ret;
+}
+
+static void sunxi_video_stop_streaming(struct vb2_queue *vq)
+{
+	struct sunxi_video *video = vb2_get_drv_priv(vq);
+	unsigned long flags;
+	struct sunxi_csi_buffer *buf;
+
+	sunxi_pipeline_set_stream(video, false);
+
+	sunxi_csi_set_stream(video->csi, false);
+
+	media_pipeline_stop(&video->vdev.entity);
+
+	/* Release all active buffers */
+	spin_lock_irqsave(&video->dma_queue_lock, flags);
+	if (unlikely(video->cur_frm)) {
+		vb2_buffer_done(&video->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
+		video->cur_frm = NULL;
+	}
+	list_for_each_entry(buf, &video->dma_queue, list)
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	INIT_LIST_HEAD(&video->dma_queue);
+	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
+}
+
+static void sunxi_video_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct sunxi_csi_buffer *buf =
+			container_of(vbuf, struct sunxi_csi_buffer, vb);
+	struct sunxi_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long flags;
+
+	spin_lock_irqsave(&video->dma_queue_lock, flags);
+	if (!video->cur_frm && list_empty(&video->dma_queue) &&
+		vb2_is_streaming(vb->vb2_queue)) {
+		video->cur_frm = buf;
+		sunxi_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
+		sunxi_csi_set_stream(video->csi, 1);
+	} else
+		list_add_tail(&buf->list, &video->dma_queue);
+	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
+}
+
+void sunxi_video_frame_done(struct sunxi_video *video)
+{
+	spin_lock(&video->dma_queue_lock);
+
+	if (video->cur_frm) {
+		struct vb2_v4l2_buffer *vbuf = &video->cur_frm->vb;
+		struct vb2_buffer *vb = &vbuf->vb2_buf;
+
+		vb->timestamp = ktime_get_ns();
+		vbuf->sequence = video->sequence++;
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		video->cur_frm = NULL;
+	}
+
+	if (!list_empty(&video->dma_queue)
+	    && vb2_is_streaming(&video->vb2_vidq)) {
+		video->cur_frm = list_first_entry(&video->dma_queue,
+				struct sunxi_csi_buffer, list);
+		list_del(&video->cur_frm->list);
+		sunxi_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
+	} else
+		sunxi_csi_set_stream(video->csi, 0);
+
+	spin_unlock(&video->dma_queue_lock);
+}
+
+static struct vb2_ops sunxi_csi_vb2_ops = {
+	.queue_setup		= sunxi_video_queue_setup,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+	.buf_prepare		= sunxi_video_buffer_prepare,
+	.start_streaming	= sunxi_video_start_streaming,
+	.stop_streaming		= sunxi_video_stop_streaming,
+	.buf_queue		= sunxi_video_buffer_queue,
+};
+
+static int vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	struct sunxi_video *video = video_drvdata(file);
+
+	strlcpy(cap->driver, "sunxi-video", sizeof(cap->driver));
+	strlcpy(cap->card, video->vdev.name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 video->csi->dev->of_node->name);
+
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	struct sunxi_video *video = video_drvdata(file);
+	u32 index = f->index;
+
+	if (index >= video->num_formats)
+		return -EINVAL;
+
+	f->pixelformat = video->formats[index].fourcc;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct sunxi_video *video = video_drvdata(file);
+
+	*fmt = video->fmt;
+
+	return 0;
+}
+
+static int sunxi_video_try_fmt(struct sunxi_video *video, struct v4l2_format *f,
+			       struct sunxi_csi_format **current_fmt)
+{
+	struct sunxi_csi_format *csi_fmt;
+	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
+	struct v4l2_subdev_format format;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	subdev = sunxi_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -ENXIO;
+
+	csi_fmt = find_format_by_fourcc(video, pixfmt->pixelformat);
+	if (csi_fmt == NULL)
+		return -EINVAL;
+
+	format.pad = pad;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
+	v4l2_fill_mbus_format(&format.format, pixfmt, csi_fmt->mbus_code);
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
+	if (ret)
+		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
+
+	v4l2_fill_pix_format(pixfmt, &format.format);
+
+	pixfmt->bytesperline = (pixfmt->width * csi_fmt->bpp) >> 3;
+	pixfmt->sizeimage = (pixfmt->width * csi_fmt->bpp * pixfmt->height) / 8;
+
+	if (current_fmt)
+		*current_fmt = csi_fmt;
+
+	return 0;
+}
+
+static int sunxi_video_set_fmt(struct sunxi_video *video, struct v4l2_format *f)
+{
+	struct v4l2_subdev_format format;
+	struct sunxi_csi_format *current_fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = sunxi_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -ENXIO;
+
+	ret = sunxi_video_try_fmt(video, f, &current_fmt);
+	if (ret)
+		return ret;
+
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
+			      current_fmt->mbus_code);
+	ret = v4l2_subdev_call(subdev, pad, set_fmt, NULL, &format);
+	if (ret < 0)
+		return ret;
+
+	video->fmt = *f;
+	video->current_fmt = current_fmt;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct sunxi_video *video = video_drvdata(file);
+
+	if (vb2_is_streaming(&video->vb2_vidq))
+		return -EBUSY;
+
+	return sunxi_video_set_fmt(video, f);
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct sunxi_video *video = video_drvdata(file);
+
+	return sunxi_video_try_fmt(video, f, NULL);
+}
+
+static const struct v4l2_ioctl_ops sunxi_video_ioctl_ops = {
+	.vidioc_querycap		= vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 file operations
+ */
+static int sunxi_video_open(struct file *file)
+{
+	struct sunxi_video *video = video_drvdata(file);
+	struct v4l2_format format;
+	int ret;
+
+	if (mutex_lock_interruptible(&video->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	ret = v4l2_pipeline_pm_use(&video->vdev.entity, 1);
+	if (ret < 0)
+		goto fh_release;
+
+	if (!v4l2_fh_is_singular_file(file))
+		goto unlock;
+
+	ret = sunxi_csi_set_power(video->csi, true);
+	if (ret < 0)
+		goto fh_release;
+
+	/* setup default format */
+	if (video->num_formats > 0) {
+		format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		format.fmt.pix.width = 1280;
+		format.fmt.pix.height = 720;
+		format.fmt.pix.pixelformat = video->formats[0].fourcc;
+		sunxi_video_set_fmt(video, &format);
+	}
+
+	mutex_unlock(&video->lock);
+	return 0;
+
+fh_release:
+	v4l2_fh_release(file);
+unlock:
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
+static int sunxi_video_close(struct file *file)
+{
+	struct sunxi_video *video = video_drvdata(file);
+
+	mutex_lock(&video->lock);
+
+	_vb2_fop_release(file, NULL);
+
+	v4l2_pipeline_pm_use(&video->vdev.entity, 0);
+
+	if (v4l2_fh_is_singular_file(file))
+		sunxi_csi_set_power(video->csi, false);
+
+	mutex_unlock(&video->lock);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations sunxi_video_fops = {
+	.owner		= THIS_MODULE,
+	.open		= sunxi_video_open,
+	.release	= sunxi_video_close,
+	.unlocked_ioctl	= video_ioctl2,
+	.read		= vb2_fop_read,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll
+};
+
+/* -----------------------------------------------------------------------------
+ * Media Operations
+ */
+static int sunxi_video_formats_init(struct sunxi_video *video)
+{
+	struct v4l2_subdev_mbus_code_enum mbus_code = { 0 };
+	struct sunxi_csi *csi = video->csi;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	const u32 *pixformats;
+	int pixformat_count = 0;
+	u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
+	int codes_count = 0;
+	int num_fmts = 0;
+	int i, j;
+
+	subdev = sunxi_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -ENXIO;
+
+	/* Get supported pixformats of CSI */
+	pixformat_count = sunxi_csi_get_supported_pixformats(csi, &pixformats);
+	if (pixformat_count <= 0)
+		return -ENXIO;
+
+	/* Get subdev formats codes */
+	mbus_code.pad = pad;
+	mbus_code.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
+			&mbus_code)) {
+		subdev_codes[codes_count] = mbus_code.code;
+		codes_count++;
+		mbus_code.index++;
+	}
+
+	if (!codes_count)
+		return -ENXIO;
+
+	/* Get supported formats count */
+	for (i = 0; i < codes_count; i++) {
+		for (j = 0; j < pixformat_count; j++) {
+			if (!sunxi_csi_is_format_support(csi, pixformats[j],
+					mbus_code.code)) {
+				continue;
+			}
+			num_fmts++;
+		}
+	}
+
+	if (!num_fmts)
+		return -ENXIO;
+
+	video->num_formats = num_fmts;
+	video->formats = devm_kcalloc(video->csi->dev, num_fmts,
+			sizeof(struct sunxi_csi_format), GFP_KERNEL);
+	if (!video->formats) {
+		dev_err(video->csi->dev, "could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	/* Get supported formats */
+	num_fmts = 0;
+	for (i = 0; i < codes_count; i++) {
+		for (j = 0; j < pixformat_count; j++) {
+			if (!sunxi_csi_is_format_support(csi, pixformats[j],
+					mbus_code.code)) {
+				continue;
+			}
+
+			video->formats[num_fmts].fourcc = pixformats[j];
+			video->formats[num_fmts].mbus_code =
+					mbus_code.code;
+			video->formats[num_fmts].bpp =
+					v4l2_pixformat_get_bpp(pixformats[j]);
+			num_fmts++;
+		}
+	}
+
+	return 0;
+}
+
+static int sunxi_video_link_setup(struct media_entity *entity,
+				  const struct media_pad *local,
+				  const struct media_pad *remote, u32 flags)
+{
+	struct video_device *vdev = media_entity_to_video_device(entity);
+	struct sunxi_video *video = video_get_drvdata(vdev);
+
+	if (WARN_ON(video == NULL))
+		return 0;
+
+	return sunxi_video_formats_init(video);
+}
+
+static const struct media_entity_operations sunxi_video_media_ops = {
+	.link_setup = sunxi_video_link_setup,
+};
+
+int sunxi_video_init(struct sunxi_video *video, struct sunxi_csi *csi,
+		     const char *name)
+{
+	struct video_device *vdev = &video->vdev;
+	struct vb2_queue *vidq = &video->vb2_vidq;
+	int ret;
+
+	video->csi = csi;
+
+	/* Initialize the media entity... */
+	video->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
+	vdev->entity.ops = &sunxi_video_media_ops;
+	ret = media_entity_pads_init(&vdev->entity, 1, &video->pad);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&video->lock);
+
+	INIT_LIST_HEAD(&video->dma_queue);
+	spin_lock_init(&video->dma_queue_lock);
+
+	video->cur_frm = NULL;
+	video->sequence = 0;
+	video->num_formats = 0;
+
+	/* Initialize videobuf2 queue */
+	vidq->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vidq->io_modes			= VB2_MMAP | VB2_DMABUF;
+	vidq->drv_priv			= video;
+	vidq->buf_struct_size		= sizeof(struct sunxi_csi_buffer);
+	vidq->ops			= &sunxi_csi_vb2_ops;
+	vidq->mem_ops			= &vb2_dma_contig_memops;
+	vidq->timestamp_flags		= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vidq->lock			= &video->lock;
+	vidq->min_buffers_needed	= 1;
+	vidq->dev			= csi->dev;
+
+	ret = vb2_queue_init(vidq);
+	if (ret) {
+		v4l2_err(&csi->v4l2_dev, "vb2_queue_init failed: %d\n", ret);
+		goto error;
+	}
+
+	/* Register video device */
+	strlcpy(vdev->name, name, sizeof(vdev->name));
+	vdev->release		= video_device_release_empty;
+	vdev->fops		= &sunxi_video_fops;
+	vdev->ioctl_ops		= &sunxi_video_ioctl_ops;
+	vdev->vfl_type		= VFL_TYPE_GRABBER;
+	vdev->vfl_dir		= VFL_DIR_RX;
+	vdev->v4l2_dev		= &csi->v4l2_dev;
+	vdev->queue		= vidq;
+	vdev->lock		= &video->lock;
+	vdev->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+	video_set_drvdata(vdev, video);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		v4l2_err(&csi->v4l2_dev,
+			 "video_register_device failed: %d\n", ret);
+		goto error;
+	}
+
+	return 0;
+
+error:
+	sunxi_video_cleanup(video);
+	return ret;
+}
+
+void sunxi_video_cleanup(struct sunxi_video *video)
+{
+	if (video_is_registered(&video->vdev))
+		video_unregister_device(&video->vdev);
+
+	media_entity_cleanup(&video->vdev.entity);
+}
diff --git a/drivers/media/platform/sunxi-csi/sunxi_video.h b/drivers/media/platform/sunxi-csi/sunxi_video.h
new file mode 100644
index 0000000..b3a6139
--- /dev/null
+++ b/drivers/media/platform/sunxi-csi/sunxi_video.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2017 Yong Deng <yong.deng@magewell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __SUNXI_VIDEO_H__
+#define __SUNXI_VIDEO_H__
+
+#include <media/v4l2-dev.h>
+#include <media/videobuf2-core.h>
+
+/*
+ * struct sunxi_csi_format - CSI media bus format information
+ * @fourcc: Fourcc code for this format
+ * @mbus_code: V4L2 media bus format code.
+ * @bpp: Bytes per pixel (when stored in memory)
+ */
+struct sunxi_csi_format {
+	u32				fourcc;
+	u32				mbus_code;
+	u8				bpp;
+};
+
+struct sunxi_csi;
+
+struct sunxi_video {
+	struct video_device		vdev;
+	struct media_pad		pad;
+	struct sunxi_csi		*csi;
+
+	struct mutex			lock;
+
+	struct vb2_queue		vb2_vidq;
+	spinlock_t			dma_queue_lock;
+	struct list_head		dma_queue;
+
+	struct sunxi_csi_buffer		*cur_frm;
+	unsigned int			sequence;
+
+	struct sunxi_csi_format		*formats;
+	unsigned int			num_formats;
+	struct sunxi_csi_format		*current_fmt;
+	struct v4l2_format		fmt;
+};
+
+int sunxi_video_init(struct sunxi_video *video, struct sunxi_csi *csi,
+		     const char *name);
+void sunxi_video_cleanup(struct sunxi_video *video);
+
+void sunxi_video_frame_done(struct sunxi_video *video);
+
+#endif /* __SUNXI_VIDEO_H__ */
-- 
1.8.3.1
