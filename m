Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63712 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3CRT7N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 15:59:13 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	prabhakar.lad@ti.com, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, dh09.lee@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] [media] Add a V4L2 OF parser
Date: Mon, 18 Mar 2013 20:58:54 +0100
Message-id: <1363636734-21128-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Add a V4L2 OF parser, implementing bindings documented in
Documentation/devicetree/bindings/media/video-interfaces.txt.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
[s.nawrocki@samsung.com: various corrections and improvements
since the initial version]
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Geunnadi,

I have made couple further changes to this parsing library, mostly
addressing your review comments. Hopefully it looks better now.

It would be good to get more reviews and opinions of other media
sub-maintainers. Any Acked/Tested-by are also of course most
welcome.

I have a feeling this is about ready for upstream ;-) We have
used it in couple subsystems already and the overall design
looks good and seems to be proving itself in practice.

Thanks,
Sylwester

The last version of the bindings documentation patch can be found
at: https://patchwork.kernel.org/patch/2074951

Changes since v7 include mostly corrections of issues pointed
out by Guennadi, and few others:

 - v4l2_of_parse_parallel_bus() and v4l2_of_parse_csi_bus() are
   made static and are not exported anymore;
 - swapped order of parsing the serial and parallel bus properties
   in v4l2_of_parse_endpoint() function; the rationale is that
   MIPI CSI-2 has less properties and an overall number of searches
   of non-existent properties is less this way;
 - v4l2_mbus_mipi_csi2, v4l2_mbus_parallel structs renamed to
   v4l2_of_bus_mipi_csi2, v4l2_of_bus_parallel respectively;
 - added kernel-doc for the above two data structures;
 - the flags field split into to fields - separate fields for the
   parallel and serial bus, V4L2_MBUS_* bit flags are defined
   separately for MIPI CSI-2 and parallel busses so they were
   clashing when used together in single data structure member!;
 - the head member of struct v4l2_endpoint made last member of
   this data structure, it is now not cleared with memset() at the
   beginning of v4l2_of_parse_endpoint() function; I believe
   clearing list head in this function is not expected;
 - fixed bug in v4l2_of_get_remote_port_parent() function;
 - reworked first port node searching in v4l2_of_get_next_endpoint();
 - moved code setting V4L2_MBUS_MASTER and V4L2_MBUS_CSI2_CONTINUOUS_CLOCK
   out from v4l2_of_parse_endpoint() to v4l2_of_parse_mipi_csi2/
   parallel_bus() functions;
 - ensured we recognize presence of the clock-lanes property regardless
   of the clock lane index being 0;
 - added v4l2_of_get_remote_port() function.

Changes since v6:
 - minor v4l2_of_get_remote_port_parent() function cleanup.

Changes since v5:
 - renamed v4l2_of_parse_mipi_csi2 -> v4l2_of_parse_csi_bus;
 - corrected v4l2_of_get_remote_port_parent() function declaration
   for !CONFIG_OF;
 - reworked v4l2_of_get_next_endpoint() function to consider the
   'port' nodes can be grouped under optional 'ports' node;
 - added kerneldoc description for v4l2_of_get_next_endpoint()
   function.

Changes since v4:
 - reworked v4l2_of_get_remote_port() function to consider cases
   where 'port' nodes are grouped in a parent 'ports' node;
 - rearranged struct v4l2_of_endpoint and related changes added
   in the parser code;
 - added kerneldoc description for struct v4l2_of_endpoint;
 - s/link/endpoint in the comments.
---
 drivers/media/v4l2-core/Makefile  |    3 +
 drivers/media/v4l2-core/v4l2-of.c |  267 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           |  111 +++++++++++++++
 3 files changed, 381 insertions(+)
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
index 0000000..e38e210
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -0,0 +1,267 @@
+/*
+ * V4L2 OF binding parsing library
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
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
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <media/v4l2-of.h>
+
+static void v4l2_of_parse_csi_bus(const struct device_node *node,
+				  struct v4l2_of_endpoint *endpoint)
+{
+	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
+	u32 data_lanes[ARRAY_SIZE(bus->data_lanes)];
+	struct property *prop;
+	bool have_clk_lane = false;
+	unsigned int flags = 0;
+	u32 v;
+
+	prop = of_find_property(node, "data-lanes", NULL);
+	if (prop) {
+		const __be32 *lane = NULL;
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(data_lanes); i++) {
+			lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
+			if (!lane)
+				break;
+		}
+		bus->num_data_lanes = i;
+		while (i--)
+			bus->data_lanes[i] = data_lanes[i];
+	}
+
+	if (!of_property_read_u32(node, "clock-lanes", &v)) {
+		bus->clock_lane = v;
+		have_clk_lane = true;
+	}
+
+	if (of_get_property(node, "clock-noncontinuous", &v))
+		flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
+	else if (have_clk_lane || bus->num_data_lanes > 0)
+		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+
+	bus->flags = flags;
+	endpoint->bus_type = V4L2_MBUS_CSI2;
+}
+
+static void v4l2_of_parse_parallel_bus(const struct device_node *node,
+				       struct v4l2_of_endpoint *endpoint)
+{
+	struct v4l2_of_bus_parallel *bus = &endpoint->bus.parallel;
+	unsigned int flags = 0;
+	u32 v;
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
+		endpoint->bus_type = V4L2_MBUS_PARALLEL;
+	else
+		endpoint->bus_type = V4L2_MBUS_BT656;
+
+	if (!of_property_read_u32(node, "data-active", &v))
+		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
+			V4L2_MBUS_DATA_ACTIVE_LOW;
+
+	if (of_get_property(node, "slave-mode", &v))
+		flags |= V4L2_MBUS_SLAVE;
+	else
+		flags |= V4L2_MBUS_MASTER;
+
+	if (!of_property_read_u32(node, "bus-width", &v))
+		bus->bus_width = v;
+
+	if (!of_property_read_u32(node, "data-shift", &v))
+		bus->data_shift = v;
+
+	bus->flags = flags;
+
+}
+EXPORT_SYMBOL(v4l2_of_parse_parallel_bus);
+
+/**
+ * v4l2_of_parse_endpoint() - parse all endpoint node properties
+ * @node: pointer to endpoint device_node
+ * @endpoint: pointer to the V4L2 OF endpoint data structure
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
+	struct device_node *port_node = of_get_parent(node);
+
+	memset(endpoint, 0, offsetof(struct v4l2_of_endpoint, head));
+
+	endpoint->local_node = node;
+	/*
+	 * It doesn't matter whether the two calls below succeed.
+	 * If they don't then the default value 0 is used.
+	 */
+	of_property_read_u32(port_node, "reg", &endpoint->port);
+	of_property_read_u32(node, "reg", &endpoint->id);
+
+	v4l2_of_parse_csi_bus(node, endpoint);
+	/*
+	 * Parse the parallel video bus properties only if none
+	 * of the MIPI CSI-2 specific properties were found.
+	 */
+	if (endpoint->bus.mipi_csi2.flags == 0)
+		v4l2_of_parse_parallel_bus(node, endpoint);
+
+	of_node_put(port_node);
+}
+EXPORT_SYMBOL(v4l2_of_parse_endpoint);
+
+/**
+ * v4l2_of_get_next_endpoint() - get next endpoint node
+ * @parent: pointer to the parent device node
+ * @prev: previous endpoint node, or NULL to get first
+ *
+ * Return: An 'endpoint' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is not decremented, the caller have to use
+ * of_node_put() on it when done.
+ */
+struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
+					struct device_node *prev)
+{
+	struct device_node *endpoint;
+	struct device_node *port = NULL;
+
+	if (!parent)
+		return NULL;
+
+	if (!prev) {
+		struct device_node *node;
+		/*
+		 * It's the first call, we have to find a port subnode
+		 * within this node or within an optional 'ports' node.
+		 */
+		node = of_get_child_by_name(parent, "ports");
+		if (node)
+			parent = node;
+
+		for_each_child_of_node(parent, node) {
+			if (!of_node_cmp(node->name, "port")) {
+				port = node;
+				break;
+			}
+		}
+		if (port) {
+			/* Found a port, get an endpoint. */
+			endpoint = of_get_next_child(port, NULL);
+			of_node_put(port);
+		} else {
+			endpoint = NULL;
+		}
+
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
+	unsigned int depth;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+
+	/* Walk 3 levels up only if there is 'ports' node. */
+	for (depth = 3; depth && np; depth--) {
+		np = of_get_next_parent(np);
+		if (depth == 2 && of_node_cmp(np->name, "ports"))
+			break;
+	}
+	return np;
+}
+EXPORT_SYMBOL(v4l2_of_get_remote_port_parent);
+
+/**
+ * v4l2_of_get_remote_port() - get remote port node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote port node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *v4l2_of_get_remote_port(const struct device_node *node)
+{
+	struct device_node *np;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!np)
+		return NULL;
+	return of_get_parent(np);
+}
+EXPORT_SYMBOL(v4l2_of_get_remote_port);
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
new file mode 100644
index 0000000..00f9147
--- /dev/null
+++ b/include/media/v4l2-of.h
@@ -0,0 +1,111 @@
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
+/**
+ * struct v4l2_of_bus_mipi_csi2 - MIPI CSI-2 bus data structure
+ * @flags: media bus (V4L2_MBUS_*) flags
+ * @data_lanes: an array of physical data lane indexes
+ * @clock_lane: physical lane index of the clock lane
+ * @num_data_lanes: number of data lanes
+ */
+struct v4l2_of_bus_mipi_csi2 {
+	unsigned int flags;
+	unsigned char data_lanes[4];
+	unsigned char clock_lane;
+	unsigned short num_data_lanes;
+};
+
+/**
+ * struct v4l2_of_bus_parallel - parallel data bus data structure
+ * @flags: media bus (V4L2_MBUS_*) flags
+ * @bus_width: bus width in bits
+ * @data_shift: data shift in bits
+ */
+struct v4l2_of_bus_parallel {
+	unsigned int flags;
+	unsigned char bus_width;
+	unsigned char data_shift;
+};
+
+/**
+ * struct v4l2_of_endpoint - the endpoint data structure
+ * @port: identifier (value of reg property) of a port this endpoint belongs to
+ * @id: identifier (value of reg property) of this endpoint
+ * @local_node: pointer to device_node of this endpoint
+ * @remote: phandle to remote endpoint node
+ * @bus_type: bus type
+ * @bus: bus configuration data structure
+ * @head: list head for this structure
+ */
+struct v4l2_of_endpoint {
+	unsigned int port;
+	unsigned int id;
+	const struct device_node *local_node;
+	const __be32 *remote;
+	enum v4l2_mbus_type bus_type;
+	union {
+		struct v4l2_of_bus_parallel parallel;
+		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
+	} bus;
+	struct list_head head;
+};
+
+#ifdef CONFIG_OF
+void v4l2_of_parse_endpoint(const struct device_node *node,
+				struct v4l2_of_endpoint *link);
+struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
+					struct device_node *previous);
+struct device_node *v4l2_of_get_remote_port_parent(
+					const struct device_node *node);
+struct device_node *v4l2_of_get_remote_port(const struct device_node *node);
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
+static inline struct device_node *v4l2_of_get_remote_port(
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

