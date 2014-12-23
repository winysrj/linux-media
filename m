Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42068 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbaLWNJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 08:09:26 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v7 2/3] of: Add for_each_endpoint_of_node helper macro
Date: Tue, 23 Dec 2014 14:09:17 +0100
Message-Id: <1419340158-20567-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de>
References: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note that while of_graph_get_next_endpoint decrements the reference count
of the child node passed to it, of_node_put(child) still has to be called
manually when breaking out of the loop.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/of_graph.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index befef42..e43442e 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -26,6 +26,17 @@ struct of_endpoint {
 	const struct device_node *local_node;
 };
 
+/**
+ * for_each_endpoint_of_node - iterate over every endpoint in a device node
+ * @parent: parent device node containing ports and endpoints
+ * @child: loop variable pointing to the current endpoint node
+ *
+ * When breaking out of the loop, of_node_put(child) has to be called manually.
+ */
+#define for_each_endpoint_of_node(parent, child) \
+	for (child = of_graph_get_next_endpoint(parent, NULL); child != NULL; \
+	     child = of_graph_get_next_endpoint(parent, child))
+
 #ifdef CONFIG_OF
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
-- 
2.1.4

