Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63008 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2LaQDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:03:36 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 02/15] [media] Add a V4L2 OF parser
Date: Mon, 31 Dec 2012 17:03:00 +0100
Message-id: <1356969793-27268-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Add a V4L2 OF parser, implementing bindings, documented in
Documentation/devicetree/bindings/media/video-interfaces.txt.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---

Changes since previous version:
- merged into this one all my fixup patches from this series [1]:
  v4l2-of: Support variable length of data-lanes property
  v4l2-of: Add v4l2_of_parse_data_lanes() function
  v4l2-of: Corrected v4l2_of_parse_link() function declaration
  v4l2_of_parse_link() return value type is int, not void.
  v4l2-of: Replace "remote" property with "remote-endpoint"

[1] https://lkml.org/lkml/2012/12/10/464
---
 drivers/media/v4l2-core/Makefile  |    3 +
 drivers/media/v4l2-core/v4l2-of.c |  249 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           |   79 ++++++++++++
 3 files changed, 331 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index c2d61d4..00f64d6 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -9,6 +9,9 @@ videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
+ifeq ($(CONFIG_OF),y)
+  videodev-objs += v4l2-of.o
+endif
 
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
new file mode 100644
index 0000000..cdac04b
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -0,0 +1,249 @@
+/*
+ * V4L2 OF binding parsing library
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <media/v4l2-of.h>
+
+/**
+ * v4l2_of_parse_mipi_csi2() - parse MIPI CSI-2 bus properties
+ * @node: pointer to endpoint device_node
+ * @endpoint: pointer to v4l2_of_endpoint data structure
+ *
+ * Return: 0 on success or negative error value otherwise.
+ */
+int v4l2_of_parse_mipi_csi2(const struct device_node *node,
+			    struct v4l2_of_endpoint *endpoint)
+{
+	struct v4l2_of_mipi_csi2 *mipi_csi2 = &endpoint->mipi_csi_2;
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
+		endpoint->mbus_flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
+
+	return 0;
+}
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
+		endpoint->mbus_type = V4L2_MBUS_PARALLEL;
+	else
+		endpoint->mbus_type = V4L2_MBUS_BT656;
+
+	if (!of_property_read_u32(node, "data-active", &v))
+		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
+			V4L2_MBUS_DATA_ACTIVE_LOW;
+
+	if (of_get_property(node, "slave-mode", &v))
+		flags |= V4L2_MBUS_SLAVE;
+
+	if (!of_property_read_u32(node, "bus-width", &v))
+		endpoint->parallel.bus_width = v;
+
+	if (!of_property_read_u32(node, "data-shift", &v))
+		endpoint->parallel.data_shift = v;
+
+	endpoint->mbus_flags = flags;
+}
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
+	bool data_lanes_present = false;
+
+	memset(endpoint, 0, sizeof(*endpoint));
+
+	endpoint->local_node = node;
+
+	/* Doesn't matter, whether the below two calls succeed */
+	of_property_read_u32(port_node, "reg", &endpoint->port);
+	of_property_read_u32(node, "reg", &endpoint->addr);
+
+	v4l2_of_parse_parallel_bus(node, endpoint);
+
+	/* If any parallel bus properties have been found, skip serial ones */
+	if (endpoint->parallel.bus_width || endpoint->parallel.data_shift ||
+	    endpoint->mbus_flags) {
+		/* Default parallel bus-master */
+		if (!(endpoint->mbus_flags & V4L2_MBUS_SLAVE))
+			endpoint->mbus_flags |= V4L2_MBUS_MASTER;
+		return;
+	}
+
+	endpoint->mbus_type = V4L2_MBUS_CSI2;
+
+	if (!v4l2_of_parse_mipi_csi2(node, endpoint))
+		data_lanes_present = true;
+
+	if ((endpoint->mipi_csi_2.clock_lane || data_lanes_present) &&
+	    !(endpoint->mbus_flags & V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK)) {
+		/* Default CSI-2: continuous clock */
+		endpoint->mbus_flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	}
+}
+EXPORT_SYMBOL(v4l2_of_parse_endpoint);
+
+/*
+ * Return a refcounted next "endpoint" DT node. Contrary to the common OF
+ * practice, we do not drop the reference to previous, users have to do it
+ * themselves, when they're done with the node.
+ */
+struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
+					struct device_node *previous)
+{
+	struct device_node *child, *port;
+
+	if (!parent)
+		return NULL;
+
+	if (!previous) {
+		/*
+		 * If this is the first call, we have to find a port within this
+		 * node
+		 */
+		for_each_child_of_node(parent, port) {
+			if (!of_node_cmp(port->name, "port"))
+				break;
+		}
+		if (port) {
+			/* Found a port, get a link */
+			child = of_get_next_child(port, NULL);
+			of_node_put(port);
+		} else {
+			child = NULL;
+		}
+		if (!child)
+			pr_err("%s(): Invalid DT: %s has no link children!\n",
+			       __func__, parent->name);
+	} else {
+		port = of_get_parent(previous);
+		if (!port)
+			/* Hm, has someone given us the root node?... */
+			return NULL;
+
+		/* Avoid dropping previous refcount to 0 */
+		of_node_get(previous);
+		child = of_get_next_child(port, previous);
+		if (child) {
+			of_node_put(port);
+			return child;
+		}
+
+		/* No more links under this port, try the next one */
+		do {
+			port = of_get_next_child(parent, port);
+			if (!port)
+				return NULL;
+		} while (of_node_cmp(port->name, "port"));
+
+		/* Pick up the first link on this port */
+		child = of_get_next_child(port, NULL);
+		of_node_put(port);
+	}
+
+	return child;
+}
+EXPORT_SYMBOL(v4l2_of_get_next_endpoint);
+
+/**
+ * v4l2_of_get_remote_port_parent() - get remote port's parent node
+ * @node: pointer to local endpoint device_node
+ *
+ * Return: Remote device node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *v4l2_of_get_remote_port_parent(
+			       const struct device_node *node)
+{
+	struct device_node *re, *tmp;
+
+	/* Get remote endpoint DT node. */
+	re = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!re)
+		return NULL;
+
+	/* Remote port. */
+	tmp = of_get_parent(re);
+	of_node_put(re);
+	if (!tmp)
+		return NULL;
+
+	/* Remote device node. */
+	re = of_get_parent(tmp);
+	of_node_put(tmp);
+
+	return re;
+}
+EXPORT_SYMBOL(v4l2_of_get_remote_port_parent);
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
new file mode 100644
index 0000000..1aba3b3
--- /dev/null
+++ b/include/media/v4l2-of.h
@@ -0,0 +1,79 @@
+/*
+ * V4L2 OF binding parsing library
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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
+struct v4l2_of_mipi_csi2 {
+	unsigned char data_lanes[4];
+	unsigned char clock_lane;
+	unsigned short num_data_lanes;
+};
+
+struct v4l2_of_endpoint {
+	unsigned int port;
+	unsigned int addr;
+	struct list_head head;
+	const struct device_node *local_node;
+	const __be32 *remote;
+	enum v4l2_mbus_type mbus_type;
+	unsigned int mbus_flags;
+	union {
+		struct {
+			unsigned char bus_width;
+			unsigned char data_shift;
+		} parallel;
+		struct v4l2_of_mipi_csi2 mipi_csi_2;
+	};
+};
+
+#ifdef CONFIG_OF
+int v4l2_of_parse_mipi_csi2(const struct device_node *node,
+			    struct v4l2_of_endpoint *endpoint);
+void v4l2_of_parse_parallel_bus(const struct device_node *node,
+				struct v4l2_of_endpoint *endpoint);
+void v4l2_of_parse_endpoint(const struct device_node *node,
+			    struct v4l2_of_endpoint *link);
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
+static inline struct device_node *v4l2_of_get_remote_endpoint(
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

