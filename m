Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754516AbdEQPEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 11:04:09 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/3] of: base: Provide of_graph_get_port_parent()
Date: Wed, 17 May 2017 16:03:37 +0100
Message-Id: <56c9c74fa9e2879aea9e008d54d8b8d7b450b8ae.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

When handling endpoints, the v4l2 async framework needs to identify the
parent device of a port endpoint.

Adapt the existing of_graph_get_remote_port_parent() such that a caller
can obtain the parent of a port without parsing the remote-endpoint
first.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/of/base.c        | 30 ++++++++++++++++++++++--------
 include/linux/of_graph.h |  1 +
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d7c4629a3a2d..f81100500999 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2455,6 +2455,27 @@ struct device_node *of_graph_get_endpoint_by_regs(
 EXPORT_SYMBOL(of_graph_get_endpoint_by_regs);
 
 /**
+ * of_graph_get_port_parent() - get port's parent node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: device node associated with endpoint @node.
+ *	   Use of_node_put() on it when done.
+ */
+struct device_node *of_graph_get_port_parent(struct device_node *node)
+{
+	unsigned int depth;
+
+	/* Walk 3 levels up only if there is 'ports' node. */
+	for (depth = 3; depth && node; depth--) {
+		node = of_get_next_parent(node);
+		if (depth == 2 && of_node_cmp(node->name, "ports"))
+			break;
+	}
+	return node;
+}
+EXPORT_SYMBOL(of_graph_get_port_parent);
+
+/**
  * of_graph_get_remote_port_parent() - get remote port's parent node
  * @node: pointer to a local endpoint device_node
  *
@@ -2465,18 +2486,11 @@ struct device_node *of_graph_get_remote_port_parent(
 			       const struct device_node *node)
 {
 	struct device_node *np;
-	unsigned int depth;
 
 	/* Get remote endpoint node. */
 	np = of_parse_phandle(node, "remote-endpoint", 0);
 
-	/* Walk 3 levels up only if there is 'ports' node. */
-	for (depth = 3; depth && np; depth--) {
-		np = of_get_next_parent(np);
-		if (depth == 2 && of_node_cmp(np->name, "ports"))
-			break;
-	}
-	return np;
+	return of_graph_get_port_parent(np);
 }
 EXPORT_SYMBOL(of_graph_get_remote_port_parent);
 
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index abdb02eaef06..49bf34880ebc 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -48,6 +48,7 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_endpoint_by_regs(
 		const struct device_node *parent, int port_reg, int reg);
+struct device_node *of_graph_get_port_parent(struct device_node *node);
 struct device_node *of_graph_get_remote_port_parent(
 					const struct device_node *node);
 struct device_node *of_graph_get_remote_port(const struct device_node *node);
-- 
git-series 0.9.1
