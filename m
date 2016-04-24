Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34175 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbcDXVKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:22 -0400
Received: by mail-wm0-f67.google.com with SMTP id n3so20028028wmn.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:21 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 08/24] v4l: of: Obtain data bus type from bus-type property
Date: Mon, 25 Apr 2016 00:08:08 +0300
Message-Id: <1461532104-24032-9-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Only try parsing bus specific properties in this case.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c | 42 +++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index f2618fd..5304137 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -20,6 +20,11 @@
 
 #include <media/v4l2-of.h>
 
+enum v4l2_of_bus_type {
+	V4L2_OF_BUS_TYPE_CSI2 = 0,
+	V4L2_OF_BUS_TYPE_PARALLEL,
+};
+
 static int v4l2_of_parse_csi2_bus(const struct device_node *node,
 				 struct v4l2_of_endpoint *endpoint)
 {
@@ -151,6 +156,7 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
 {
+	u32 bus_type;
 	int rval;
 
 	of_graph_parse_endpoint(node, &endpoint->base);
@@ -158,17 +164,33 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
 	       offsetof(typeof(*endpoint), bus_type));
 
-	rval = v4l2_of_parse_csi2_bus(node, endpoint);
-	if (rval)
-		return rval;
-	/*
-	 * Parse the parallel video bus properties only if none
-	 * of the MIPI CSI-2 specific properties were found.
-	 */
-	if (endpoint->bus.mipi_csi2.flags == 0)
-		v4l2_of_parse_parallel_bus(node, endpoint);
+	rval = of_property_read_u32(node, "bus-type", &bus_type);
+	if (rval < 0) {
+		endpoint->bus_type = 0;
+		rval = v4l2_of_parse_csi2_bus(node, endpoint);
+		if (rval)
+			return rval;
+		/*
+		 * Parse the parallel video bus properties only if none
+		 * of the MIPI CSI-2 specific properties were found.
+		 */
+		if (endpoint->bus.mipi_csi2.flags == 0)
+			v4l2_of_parse_parallel_bus(node, endpoint);
+
+		return 0;
+	}
 
-	return 0;
+	switch (bus_type) {
+	case V4L2_OF_BUS_TYPE_CSI2:
+		return v4l2_of_parse_csi2_bus(node, endpoint);
+	case V4L2_OF_BUS_TYPE_PARALLEL:
+		v4l2_of_parse_parallel_bus(node, endpoint);
+		return 0;
+	default:
+		pr_warn("bad bus-type %u, device_node \"%s\"\n",
+			bus_type, node->full_name);
+		return -EINVAL;
+	}
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
 
-- 
1.9.1

