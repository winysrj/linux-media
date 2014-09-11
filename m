Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbaIKPdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 11:33:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 5/8] of: Add of_graph_get_port_by_id function
Date: Thu, 11 Sep 2014 17:33:04 +0200
Message-Id: <1410449587-1677-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
References: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a function to get a port device tree node by port id,
or reg property value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - Fixed and simplified of_graph_get_port_by_id function
---
 drivers/of/base.c        | 26 ++++++++++++++++++++++++++
 include/linux/of_graph.h |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index a49b5628..76e2651 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2053,6 +2053,32 @@ int of_graph_parse_endpoint(const struct device_node *node,
 EXPORT_SYMBOL(of_graph_parse_endpoint);
 
 /**
+ * of_graph_get_port_by_id() - get the port matching a given id
+ * @parent: pointer to the parent device node
+ * @id: id of the port
+ *
+ * Return: A 'port' node pointer with refcount incremented. The caller
+ * has to use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id)
+{
+	struct device_node *port;
+
+	for_each_child_of_node(node, port) {
+		u32 port_id = 0;
+
+		if (of_node_cmp(port->name, "port") != 0)
+			continue;
+		of_property_read_u32(port, "reg", &port_id);
+		if (id == port_id)
+			return port;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(of_graph_get_port_by_id);
+
+/**
  * of_graph_get_next_endpoint() - get next endpoint node
  * @parent: pointer to the parent device node
  * @prev: previous endpoint node, or NULL to get first
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index e43442e..3c1c95a 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -40,6 +40,7 @@ struct of_endpoint {
 #ifdef CONFIG_OF
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
+struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_remote_port_parent(
@@ -53,6 +54,12 @@ static inline int of_graph_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+static inline struct device_node *of_graph_get_port_by_id(
+					struct device_node *node, u32 id)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_graph_get_next_endpoint(
 					const struct device_node *parent,
 					struct device_node *previous)
-- 
2.1.0

