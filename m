Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53823 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaCEJVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 04:21:11 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 1/8] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Wed,  5 Mar 2014 10:20:35 +0100
Message-Id: <1394011242-16783-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves the parsing helpers used to parse connected graphs
in the device tree, like the video interface bindings documented in
Documentation/devicetree/bindings/media/video-interfaces.txt, from
drivers/media/v4l2-core/v4l2-of.c into drivers/of/base.c.

This allows to reuse the same parser code from outside the V4L2
framework, most importantly from display drivers.
The functions v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
and v4l2_of_get_remote_port_parent are moved. They are renamed to
of_graph_get_next_endpoint, of_graph_get_remote_port, and
of_graph_get_remote_port_parent, respectively.
Since there are not that many current users yet, switch all of
them to the new functions right away.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/adv7343.c                   |   4 +-
 drivers/media/i2c/mt9p031.c                   |   4 +-
 drivers/media/i2c/s5k5baf.c                   |   3 +-
 drivers/media/i2c/tvp514x.c                   |   3 +-
 drivers/media/i2c/tvp7002.c                   |   3 +-
 drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c |   3 +-
 drivers/media/platform/exynos4-is/mipi-csis.c |   3 +-
 drivers/media/v4l2-core/v4l2-of.c             | 117 -------------------------
 drivers/of/base.c                             | 118 ++++++++++++++++++++++++++
 include/linux/of_graph.h                      |  46 ++++++++++
 include/media/v4l2-of.h                       |  25 +-----
 12 files changed, 182 insertions(+), 153 deletions(-)
 create mode 100644 include/linux/of_graph.h

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index d4e15a6..9d38f7b 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -26,12 +26,12 @@
 #include <linux/videodev2.h>
 #include <linux/uaccess.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 
 #include <media/adv7343.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
 
 #include "adv7343_regs.h"
 
@@ -410,7 +410,7 @@ adv7343_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!np)
 		return NULL;
 
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e5ddf47..192c4aa 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/of_graph.h>
 #include <linux/pm.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
@@ -29,7 +30,6 @@
 #include <media/mt9p031.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
 #include "aptina-pll.h"
@@ -943,7 +943,7 @@ mt9p031_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!np)
 		return NULL;
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 77e10e0..2d768ef 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -21,6 +21,7 @@
 #include <linux/media.h>
 #include <linux/module.h>
 #include <linux/of_gpio.h>
+#include <linux/of_graph.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
@@ -1855,7 +1856,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 	if (ret < 0)
 		return ret;
 
-	node_ep = v4l2_of_get_next_endpoint(node, NULL);
+	node_ep = of_graph_get_next_endpoint(node, NULL);
 	if (!node_ep) {
 		dev_err(dev, "no endpoint defined at node %s\n",
 			node->full_name);
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 83d85df..ca00117 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
@@ -1068,7 +1069,7 @@ tvp514x_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!endpoint)
 		return NULL;
 
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 912e1cc..c4e1e2c 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -30,6 +30,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/tvp7002.h>
 #include <media/v4l2-async.h>
@@ -957,7 +958,7 @@ tvp7002_get_pdata(struct i2c_client *client)
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
 
-	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
 	if (!endpoint)
 		return NULL;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 13a4228..9bdfa45 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -24,13 +24,13 @@
 #include <linux/i2c.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
+#include <linux/of_graph.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "media-dev.h"
@@ -167,10 +167,10 @@ static int fimc_is_parse_sensor_config(struct fimc_is_sensor *sensor,
 	u32 tmp = 0;
 	int ret;
 
-	np = v4l2_of_get_next_endpoint(np, NULL);
+	np = of_graph_get_next_endpoint(np, NULL);
 	if (!np)
 		return -ENXIO;
-	np = v4l2_of_get_remote_port(np);
+	np = of_graph_get_remote_port(np);
 	if (!np)
 		return -ENXIO;
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index c1bce17..d0f82da 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -20,6 +20,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -473,7 +474,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 
 	pd->mux_id = (endpoint.port - 1) & 0x1;
 
-	rem = v4l2_of_get_remote_port_parent(ep);
+	rem = of_graph_get_remote_port_parent(ep);
 	of_node_put(ep);
 	if (rem == NULL) {
 		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index f3c3591..fd1ae65 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -20,6 +20,7 @@
 #include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_data/mipi-csis.h>
 #include <linux/platform_device.h>
@@ -762,7 +763,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 				 &state->max_num_lanes))
 		return -EINVAL;
 
-	node = v4l2_of_get_next_endpoint(node, NULL);
+	node = of_graph_get_next_endpoint(node, NULL);
 	if (!node) {
 		dev_err(&pdev->dev, "No port node at %s\n",
 				pdev->dev.of_node->full_name);
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 42e3e8a..f919db3 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -152,120 +152,3 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
-
-/**
- * v4l2_of_get_next_endpoint() - get next endpoint node
- * @parent: pointer to the parent device node
- * @prev: previous endpoint node, or NULL to get first
- *
- * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
- */
-struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
-					struct device_node *prev)
-{
-	struct device_node *endpoint;
-	struct device_node *port = NULL;
-
-	if (!parent)
-		return NULL;
-
-	if (!prev) {
-		struct device_node *node;
-		/*
-		 * It's the first call, we have to find a port subnode
-		 * within this node or within an optional 'ports' node.
-		 */
-		node = of_get_child_by_name(parent, "ports");
-		if (node)
-			parent = node;
-
-		port = of_get_child_by_name(parent, "port");
-
-		if (port) {
-			/* Found a port, get an endpoint. */
-			endpoint = of_get_next_child(port, NULL);
-			of_node_put(port);
-		} else {
-			endpoint = NULL;
-		}
-
-		if (!endpoint)
-			pr_err("%s(): no endpoint nodes specified for %s\n",
-			       __func__, parent->full_name);
-		of_node_put(node);
-	} else {
-		port = of_get_parent(prev);
-		if (!port)
-			/* Hm, has someone given us the root node ?... */
-			return NULL;
-
-		/* Avoid dropping prev node refcount to 0. */
-		of_node_get(prev);
-		endpoint = of_get_next_child(port, prev);
-		if (endpoint) {
-			of_node_put(port);
-			return endpoint;
-		}
-
-		/* No more endpoints under this port, try the next one. */
-		do {
-			port = of_get_next_child(parent, port);
-			if (!port)
-				return NULL;
-		} while (of_node_cmp(port->name, "port"));
-
-		/* Pick up the first endpoint in this port. */
-		endpoint = of_get_next_child(port, NULL);
-		of_node_put(port);
-	}
-
-	return endpoint;
-}
-EXPORT_SYMBOL(v4l2_of_get_next_endpoint);
-
-/**
- * v4l2_of_get_remote_port_parent() - get remote port's parent node
- * @node: pointer to a local endpoint device_node
- *
- * Return: Remote device node associated with remote endpoint node linked
- *	   to @node. Use of_node_put() on it when done.
- */
-struct device_node *v4l2_of_get_remote_port_parent(
-			       const struct device_node *node)
-{
-	struct device_node *np;
-	unsigned int depth;
-
-	/* Get remote endpoint node. */
-	np = of_parse_phandle(node, "remote-endpoint", 0);
-
-	/* Walk 3 levels up only if there is 'ports' node. */
-	for (depth = 3; depth && np; depth--) {
-		np = of_get_next_parent(np);
-		if (depth == 2 && of_node_cmp(np->name, "ports"))
-			break;
-	}
-	return np;
-}
-EXPORT_SYMBOL(v4l2_of_get_remote_port_parent);
-
-/**
- * v4l2_of_get_remote_port() - get remote port node
- * @node: pointer to a local endpoint device_node
- *
- * Return: Remote port node associated with remote endpoint node linked
- *	   to @node. Use of_node_put() on it when done.
- */
-struct device_node *v4l2_of_get_remote_port(const struct device_node *node)
-{
-	struct device_node *np;
-
-	/* Get remote endpoint node. */
-	np = of_parse_phandle(node, "remote-endpoint", 0);
-	if (!np)
-		return NULL;
-	return of_get_next_parent(np);
-}
-EXPORT_SYMBOL(v4l2_of_get_remote_port);
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 89e888a..b2f223f 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -21,6 +21,7 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
@@ -1982,3 +1983,120 @@ struct device_node *of_find_next_cache_node(const struct device_node *np)
 
 	return NULL;
 }
+
+/**
+ * of_graph_get_next_endpoint() - get next endpoint node
+ * @parent: pointer to the parent device node
+ * @prev: previous endpoint node, or NULL to get first
+ *
+ * Return: An 'endpoint' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is not decremented, the caller have to use
+ * of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
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
+		port = of_get_child_by_name(parent, "port");
+
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
+		of_node_put(node);
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
+EXPORT_SYMBOL(of_graph_get_next_endpoint);
+
+/**
+ * of_graph_get_remote_port_parent() - get remote port's parent node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote device node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_remote_port_parent(
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
+EXPORT_SYMBOL(of_graph_get_remote_port_parent);
+
+/**
+ * of_graph_get_remote_port() - get remote port node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote port node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_remote_port(const struct device_node *node)
+{
+	struct device_node *np;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!np)
+		return NULL;
+	return of_get_next_parent(np);
+}
+EXPORT_SYMBOL(of_graph_get_remote_port);
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
new file mode 100644
index 0000000..3bbeb60
--- /dev/null
+++ b/include/linux/of_graph.h
@@ -0,0 +1,46 @@
+/*
+ * OF graph binding parsing helpers
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * Copyright (C) 2012 Renesas Electronics Corp.
+ * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_OF_GRAPH_H
+#define __LINUX_OF_GRAPH_H
+
+#ifdef CONFIG_OF
+struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
+					struct device_node *previous);
+struct device_node *of_graph_get_remote_port_parent(
+					const struct device_node *node);
+struct device_node *of_graph_get_remote_port(const struct device_node *node);
+#else
+
+static inline struct device_node *of_graph_get_next_endpoint(
+					const struct device_node *parent,
+					struct device_node *previous)
+{
+	return NULL;
+}
+
+static inline struct device_node *of_graph_get_remote_port_parent(
+					const struct device_node *node)
+{
+	return NULL;
+}
+
+static inline struct device_node *of_graph_get_remote_port(
+					const struct device_node *node)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_OF */
+
+#endif /* __LINUX_OF_GRAPH_H */
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 541cea4..3a49735 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/of_graph.h>
 
 #include <media/v4l2-mediabus.h>
 
@@ -72,11 +73,6 @@ struct v4l2_of_endpoint {
 #ifdef CONFIG_OF
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint);
-struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
-					struct device_node *previous);
-struct device_node *v4l2_of_get_remote_port_parent(
-					const struct device_node *node);
-struct device_node *v4l2_of_get_remote_port(const struct device_node *node);
 #else /* CONFIG_OF */
 
 static inline int v4l2_of_parse_endpoint(const struct device_node *node,
@@ -85,25 +81,6 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
-static inline struct device_node *v4l2_of_get_next_endpoint(
-					const struct device_node *parent,
-					struct device_node *previous)
-{
-	return NULL;
-}
-
-static inline struct device_node *v4l2_of_get_remote_port_parent(
-					const struct device_node *node)
-{
-	return NULL;
-}
-
-static inline struct device_node *v4l2_of_get_remote_port(
-					const struct device_node *node)
-{
-	return NULL;
-}
-
 #endif /* CONFIG_OF */
 
 #endif /* _V4L2_OF_H */
-- 
1.9.0.rc3

