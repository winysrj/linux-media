Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42852 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab3BGRfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:35:06 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHV00BHJ26HVI10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Feb 2013 02:35:05 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHV0031I2673MA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Feb 2013 02:35:05 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	swarren@wwwdotorg.org, t.figa@samsung.com,
	myungjoo.ham@samsung.com, sw0312.kim@samsung.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v6] [media] Add a V4L2 OF parser
Date: Thu, 07 Feb 2013 18:34:53 +0100
Message-id: <1360258493-21052-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Add a V4L2 OF parser, implementing bindings documented in
Documentation/devicetree/bindings/media/video-interfaces.txt.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
[s.nawrocki@samsung.com: various corrections and improvements
since the initial version]
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---

Changes since v5:
 - renamed v4l2_of_parse_mipi_csi2_bus -> v4l2_of_parse_csi_bus,
 - corrected v4l2_of_get_remote_port_parent() function declaration
   for !CONFIG_OF,
 - reworked v4l2_of_get_next_endpoint() function to consider the
   'port' nodes can be grouped under optional 'ports' node,
 - added kerneldoc description for v4l2_of_get_next_endpoint()
   function.

This patch and the related bindings documentation can be browsed at:
http://git.linuxtv.org/snawrocki/samsung.git/devicetree

Changes since v4:
 - reworked v4l2_of_get_remote_port() function to consider cases
   where 'port' nodes are grouped in a parent 'ports' node,
 - rearranged struct v4l2_of_endpoint and related changes added
   in the parser code,
 - added kerneldoc description for struct v4l2_of_endpoint,
 - s/link/endpoint in the comments,
---
 drivers/media/v4l2-core/Makefile  |    3 +
 drivers/media/v4l2-core/v4l2-of.c |  260 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           |   98 ++++++++++++++
 3 files changed, 361 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index a9d3552..00c4a19 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -9,6 +9,9 @@ videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
+ifeq ($(CONFIG_OF),y)
+  videodev-objs += v4l2-of.o
+endif

 obj-$(CONFIG_VIDEO_DEV) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
new file mode 100644
index 0000000..0bf1f75
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -0,0 +1,260 @@
+/*
+ * V4L2 OF binding parsing library
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <media/v4l2-of.h>
+
+/**
+ * v4l2_of_parse_csi_bus() - parse MIPI CSI-2 bus properties
+ * @node: pointer to endpoint device_node
+ * @endpoint: pointer to v4l2_of_endpoint data structure
+ *
+ * Return: 0 on success or negative error value otherwise.
+ */
+int v4l2_of_parse_csi_bus(const struct device_node *node,
+			  struct v4l2_of_endpoint *endpoint)
+{
+	struct v4l2_mbus_mipi_csi2 *mipi_csi2 = &endpoint->mbus.mipi_csi2;
+	u32 data_lanes[ARRAY_SIZE(mipi_csi2->data_lanes)];
+	struct property *prop;
+	const __be32 *lane = NULL;
+	u32 v;
+	int i = 0;
+
+	prop = of_find_property(node, "data-lanes", NULL);
+	if (!prop)
+		return -EINVAL;
+	do {
+		lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
+	} while (lane && i++ < ARRAY_SIZE(data_lanes));
+
+	mipi_csi2->num_data_lanes = i;
+	while (i--)
+		mipi_csi2->data_lanes[i] = data_lanes[i];
+
+	if (!of_property_read_u32(node, "clock-lanes", &v))
+		mipi_csi2->clock_lane = v;
+
+	if (of_get_property(node, "clock-noncontinuous", &v))
+		endpoint->mbus.flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_of_parse_csi_bus);
+
+/**
+ * v4l2_of_parse_parallel_bus() - parse parallel bus properties
+ * @node: pointer to endpoint device_node
+ * @endpoint: pointer to v4l2_of_endpoint data structure
+ */
+void v4l2_of_parse_parallel_bus(const struct device_node *node,
+				struct v4l2_of_endpoint *endpoint)
+{
+	unsigned int flags = 0;
+	u32 v;
+
+	if (WARN_ON(!endpoint))
+		return;
+
+	if (!of_property_read_u32(node, "hsync-active", &v))
+		flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
+			V4L2_MBUS_HSYNC_ACTIVE_LOW;
+
+	if (!of_property_read_u32(node, "vsync-active", &v))
+		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
+			V4L2_MBUS_VSYNC_ACTIVE_LOW;
+
+	if (!of_property_read_u32(node, "pclk-sample", &v))
+		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
+			V4L2_MBUS_PCLK_SAMPLE_FALLING;
+
+	if (!of_property_read_u32(node, "field-even-active", &v))
+		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
+			V4L2_MBUS_FIELD_EVEN_LOW;
+	if (flags)
+		endpoint->mbus.type = V4L2_MBUS_PARALLEL;
+	else
+		endpoint->mbus.type = V4L2_MBUS_BT656;
+
+	if (!of_property_read_u32(node, "data-active", &v))
+		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
+			V4L2_MBUS_DATA_ACTIVE_LOW;
+
+	if (of_get_property(node, "slave-mode", &v))
+		flags |= V4L2_MBUS_SLAVE;
+
+	if (!of_property_read_u32(node, "bus-width", &v))
+		endpoint->mbus.parallel.bus_width = v;
+
+	if (!of_property_read_u32(node, "data-shift", &v))
+		endpoint->mbus.parallel.data_shift = v;
+
+	endpoint->mbus.flags = flags;
+}
+EXPORT_SYMBOL(v4l2_of_parse_parallel_bus);
+
+/**
+ * v4l2_of_parse_endpoint() - parse all endpoint node properties
+ * @node: pointer to endpoint device_node
+ * @endpoint: pointer to v4l2_of_endpoint data structure
+ *
+ * All properties are optional. If none are found, we don't set any flags.
+ * This means the port has a static configuration and no properties have
+ * to be specified explicitly.
+ * If any properties that identify the bus as parallel are found and
+ * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we recognise
+ * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
+ * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
+ * The caller should hold a reference to @node.
+ */
+void v4l2_of_parse_endpoint(const struct device_node *node,
+			    struct v4l2_of_endpoint *endpoint)
+{
+	const struct device_node *port_node = of_get_parent(node);
+	struct v4l2_of_mbus *mbus = &endpoint->mbus;
+	bool data_lanes_present = false;
+
+	memset(endpoint, 0, sizeof(*endpoint));
+
+	endpoint->local_node = node;
+	/*
+	 * It doesn't matter whether the two calls below succeed. If they
+	 * don't then the default value 0 is used.
+	 */
+	of_property_read_u32(port_node, "reg", &endpoint->port);
+	of_property_read_u32(node, "reg", &endpoint->id);
+
+	v4l2_of_parse_parallel_bus(node, endpoint);
+
+	/* If any parallel bus properties have been found, skip serial ones. */
+	if (mbus->parallel.bus_width || mbus->parallel.data_shift ||
+	    mbus->flags) {
+		/* Default parallel bus-master. */
+		if (!(mbus->flags & V4L2_MBUS_SLAVE))
+			mbus->flags |= V4L2_MBUS_MASTER;
+		return;
+	}
+
+	mbus->type = V4L2_MBUS_CSI2;
+
+	if (!v4l2_of_parse_csi_bus(node, endpoint))
+		data_lanes_present = true;
+
+	if ((mbus->mipi_csi2.clock_lane || data_lanes_present) &&
+	    !(mbus->flags & V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK)) {
+		/* Default CSI-2: continuous clock. */
+		mbus->flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	}
+}
+EXPORT_SYMBOL(v4l2_of_parse_endpoint);
+
+/**
+ * v4l2_of_get_next_endpoint() - get next endpoint node
+ * @parent: pointer to the parent's device node
+ * @prev: previous endpoint node, or NULL to get first
+ *
+ * Return: An 'endpoint' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is not decremented, the caller have to use
+ * of_node_put() on it when done.
+ */
+struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
+					struct device_node *prev)
+{
+	struct device_node *endpoint, *port = NULL;
+
+	if (!parent)
+		return NULL;
+
+	if (!prev) {
+		/*
+		 * It's the first call, we have to find a port subnode
+		 * within this node or within an optional 'ports' node.
+		 */
+		while ((port = of_get_next_child(parent, port))) {
+			if (!of_node_cmp(port->name, "port"))
+				break;
+			if (!of_node_cmp(port->name, "ports")) {
+				parent = port;
+				of_node_put(port);
+				port = NULL;
+			}
+		};
+		if (port) {
+			/* Found a port, get an endpoint. */
+			endpoint = of_get_next_child(port, NULL);
+			of_node_put(port);
+		} else {
+			endpoint = NULL;
+		}
+		if (!endpoint)
+			pr_err("%s(): no endpoint nodes specified for %s\n",
+			       __func__, parent->full_name);
+	} else {
+		port = of_get_parent(prev);
+		if (!port)
+			/* Hm, has someone given us the root node ?... */
+			return NULL;
+
+		/* Avoid dropping prev node refcount to 0. */
+		of_node_get(prev);
+		endpoint = of_get_next_child(port, prev);
+		if (endpoint) {
+			of_node_put(port);
+			return endpoint;
+		}
+
+		/* No more endpoints under this port, try the next one. */
+		do {
+			port = of_get_next_child(parent, port);
+			if (!port)
+				return NULL;
+		} while (of_node_cmp(port->name, "port"));
+
+		/* Pick up the first endpoint in this port. */
+		endpoint = of_get_next_child(port, NULL);
+		of_node_put(port);
+	}
+
+	return endpoint;
+}
+EXPORT_SYMBOL(v4l2_of_get_next_endpoint);
+
+/**
+ * v4l2_of_get_remote_port_parent() - get remote port's parent node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote device node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *v4l2_of_get_remote_port_parent(
+			       const struct device_node *node)
+{
+	struct device_node *np;
+	unsigned int lv = 3;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+
+	/* Walk 3 levels up only if there is 'ports' node. */
+	while (np && lv && (lv != 1 || !of_node_cmp(np->name, "ports"))) {
+		lv--;
+		np = of_get_next_parent(np);
+	}
+	return np;
+}
+EXPORT_SYMBOL(v4l2_of_get_remote_port_parent);
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
new file mode 100644
index 0000000..458e97b
--- /dev/null
+++ b/include/media/v4l2-of.h
@@ -0,0 +1,98 @@
+/*
+ * V4L2 OF binding parsing library
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+#ifndef _V4L2_OF_H
+#define _V4L2_OF_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+
+#include <media/v4l2-mediabus.h>
+
+struct device_node;
+
+struct v4l2_mbus_mipi_csi2 {
+	unsigned char data_lanes[4];
+	unsigned char clock_lane;
+	unsigned short num_data_lanes;
+};
+
+struct v4l2_mbus_parallel {
+	unsigned char bus_width;
+	unsigned char data_shift;
+};
+
+/**
+ * struct v4l2_of_endpoint - the endpoint data structure
+ * @port: identifier (value of reg property) of a port this endpoint belongs to
+ * @id: identifier (value of reg property) of this endpoint
+ * @head: list head for this structure
+ * @local_node: pointer to device_node of this endpoint
+ * @remote: phandle to remote endpoint node
+ * @type: media bus type
+ * @flags: media bus (V4L2_MBUS_*) flags
+ * @mipi_csi2: MIPI CSI-2 bus configuration data structure
+ * @parallel: parallel bus configuration data structure
+ */
+struct v4l2_of_endpoint {
+	unsigned int port;
+	unsigned int id;
+	struct list_head head;
+	const struct device_node *local_node;
+	const __be32 *remote;
+	struct v4l2_of_mbus {
+		enum v4l2_mbus_type type;
+		unsigned int flags;
+		union {
+			struct v4l2_mbus_mipi_csi2 mipi_csi2;
+			struct v4l2_mbus_parallel parallel;
+		};
+	} mbus;
+};
+
+#ifdef CONFIG_OF
+int v4l2_of_parse_csi_bus(const struct device_node *node,
+				struct v4l2_of_endpoint *endpoint);
+void v4l2_of_parse_parallel_bus(const struct device_node *node,
+				struct v4l2_of_endpoint *endpoint);
+void v4l2_of_parse_endpoint(const struct device_node *node,
+				struct v4l2_of_endpoint *link);
+struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
+					struct device_node *previous);
+struct device_node *v4l2_of_get_remote_port_parent(
+					const struct device_node *node);
+#else /* CONFIG_OF */
+
+static inline int v4l2_of_parse_endpoint(const struct device_node *node,
+					struct v4l2_of_endpoint *link)
+{
+	return -ENOSYS;
+}
+
+static inline struct device_node *v4l2_of_get_next_endpoint(
+					const struct device_node *parent,
+					struct device_node *previous)
+{
+	return NULL;
+}
+
+static inline struct device_node *v4l2_of_get_remote_port_parent(
+					const struct device_node *node)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_OF */
+
+#endif /* _V4L2_OF_H */
--
1.7.9.5

