Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37698 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752784AbbDFW7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 18:59:01 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v3 2/4] v4l: of: Instead of zeroing bus_type and bus field separately, unify this
Date: Tue,  7 Apr 2015 01:57:30 +0300
Message-Id: <1428361053-20411-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clean the entire struct starting from bus_type. As more fields are added, no
changes will be needed in the function to reset their value explicitly.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
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
index f66b92c..5bbdfbf 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -60,6 +60,7 @@ struct v4l2_of_bus_parallel {
  */
 struct v4l2_of_endpoint {
 	struct of_endpoint base;
+	/* Fields below this line will be cleaned by v4l2_of_parse_endpoint() */
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
-- 
1.7.10.4

