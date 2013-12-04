Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab3LDT3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:29:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] v4l: of: Return an int in v4l2_of_parse_endpoint()
Date: Wed,  4 Dec 2013 20:29:06 +0100
Message-Id: <1386185348-2655-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_OF is not defined the v4l2_of_parse_endpoint() function is
defined as a stub that returns -ENOSYS. Make the real function return an
integer as well to be able to differentiate between the two cases.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-of.c | 8 ++++++--
 include/media/v4l2-of.h           | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index a6478dc..66a0e23 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -121,9 +121,11 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
  * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
  * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
  * The caller should hold a reference to @node.
+ *
+ * Return: 0.
  */
-void v4l2_of_parse_endpoint(const struct device_node *node,
-			    struct v4l2_of_endpoint *endpoint)
+int v4l2_of_parse_endpoint(const struct device_node *node,
+			   struct v4l2_of_endpoint *endpoint)
 {
 	struct device_node *port_node = of_get_parent(node);
 
@@ -146,6 +148,8 @@ void v4l2_of_parse_endpoint(const struct device_node *node,
 		v4l2_of_parse_parallel_bus(node, endpoint);
 
 	of_node_put(port_node);
+
+	return 0;
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
 
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 3a8a841..3480cd0 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -72,8 +72,8 @@ struct v4l2_of_endpoint {
 };
 
 #ifdef CONFIG_OF
-void v4l2_of_parse_endpoint(const struct device_node *node,
-				struct v4l2_of_endpoint *link);
+int v4l2_of_parse_endpoint(const struct device_node *node,
+			   struct v4l2_of_endpoint *endpoint);
 struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *v4l2_of_get_remote_port_parent(
-- 
1.8.3.2

