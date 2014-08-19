Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51136 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaHSNC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 09:02:58 -0400
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
Subject: [PATCH 4/8] of: Add for_each_endpoint_of_node helper macro
Date: Tue, 19 Aug 2014 15:02:42 +0200
Message-Id: <1408453366-1366-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
References: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note that while of_graph_get_next_endpoint decrements the reference count
of the child node passed to it, of_node_put(child) still has to be called
manually when breaking out of the loop.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/linux/of_graph.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index befef42..2890a4c 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -26,6 +26,10 @@ struct of_endpoint {
 	const struct device_node *local_node;
 };
 
+#define for_each_endpoint_of_node(parent, child) \
+	for (child = of_graph_get_next_endpoint(parent, NULL); child != NULL; \
+	     child = of_graph_get_next_endpoint(parent, child))
+
 #ifdef CONFIG_OF
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
-- 
2.1.0.rc1

