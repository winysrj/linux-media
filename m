Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40199 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753396AbbDIV0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 17:26:04 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v4 2/4] v4l: of: Instead of zeroing bus_type and bus field separately, unify this
Date: Fri, 10 Apr 2015 00:25:04 +0300
Message-Id: <1428614706-8367-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zero the entire struct starting from bus_type. As more fields are added, no
changes will be needed in the function to reset their value explicitly.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-of.c |    5 +++--
 include/media/v4l2-of.h           |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 83143d3..3ac6348 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -149,8 +149,9 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	int rval;
 
 	of_graph_parse_endpoint(node, &endpoint->base);
-	endpoint->bus_type = 0;
-	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
+	/* Zero fields from bus_type to until the end */
+	memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
+	       offsetof(typeof(*endpoint), bus_type));
 
 	rval = v4l2_of_parse_csi_bus(node, endpoint);
 	if (rval)
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index f66b92c..6c85c07 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -60,6 +60,7 @@ struct v4l2_of_bus_parallel {
  */
 struct v4l2_of_endpoint {
 	struct of_endpoint base;
+	/* Fields below this line will be zeroed by v4l2_of_parse_endpoint() */
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
-- 
1.7.10.4

