Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45111 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752713AbbCPA1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:27:01 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 13/15] v4l: of: Read lane-polarity endpoint property
Date: Mon, 16 Mar 2015 02:26:08 +0200
Message-Id: <1426465570-30295-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lane_polarity field to struct v4l2_of_bus_mipi_csi2 and write the
contents of the lane polarity property to it. The field tells the polarity
of the physical lanes starting from the first one. Any unused lanes are
ignored, i.e. only the polarity of the used lanes is specified.

Also rework reading the "data-lanes" property a little.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c |   41 +++++++++++++++++++++++++++++--------
 include/media/v4l2-of.h           |    3 +++
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index b4ed9a9..e44cc15 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -19,11 +19,10 @@
 
 #include <media/v4l2-of.h>
 
-static void v4l2_of_parse_csi_bus(const struct device_node *node,
-				  struct v4l2_of_endpoint *endpoint)
+static int v4l2_of_parse_csi_bus(const struct device_node *node,
+				 struct v4l2_of_endpoint *endpoint)
 {
 	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
-	u32 data_lanes[ARRAY_SIZE(bus->data_lanes)];
 	struct property *prop;
 	bool have_clk_lane = false;
 	unsigned int flags = 0;
@@ -32,16 +31,34 @@ static void v4l2_of_parse_csi_bus(const struct device_node *node,
 	prop = of_find_property(node, "data-lanes", NULL);
 	if (prop) {
 		const __be32 *lane = NULL;
-		int i;
+		unsigned int i;
 
-		for (i = 0; i < ARRAY_SIZE(data_lanes); i++) {
-			lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
+		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
+			lane = of_prop_next_u32(prop, lane, &v);
 			if (!lane)
 				break;
+			bus->data_lanes[i] = v;
 		}
 		bus->num_data_lanes = i;
-		while (i--)
-			bus->data_lanes[i] = data_lanes[i];
+	}
+
+	prop = of_find_property(node, "lane-polarity", NULL);
+	if (prop) {
+		const __be32 *polarity = NULL;
+		unsigned int i;
+
+		for (i = 0; i < ARRAY_SIZE(bus->lane_polarity); i++) {
+			polarity = of_prop_next_u32(prop, polarity, &v);
+			if (!polarity)
+				break;
+			bus->lane_polarity[i] = v;
+		}
+
+		if (i < 1 + bus->num_data_lanes /* clock + data */) {
+			pr_warn("bad size of lane-polarity array in node %s, was %u, should be %u\n",
+				node->full_name, i, 1 + bus->num_data_lanes);
+			return -EINVAL;
+		}
 	}
 
 	if (!of_property_read_u32(node, "clock-lanes", &v)) {
@@ -56,6 +73,8 @@ static void v4l2_of_parse_csi_bus(const struct device_node *node,
 
 	bus->flags = flags;
 	endpoint->bus_type = V4L2_MBUS_CSI2;
+
+	return 0;
 }
 
 static void v4l2_of_parse_parallel_bus(const struct device_node *node,
@@ -127,11 +146,15 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
 {
+	int rval;
+
 	of_graph_parse_endpoint(node, &endpoint->base);
 	endpoint->bus_type = 0;
 	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
 
-	v4l2_of_parse_csi_bus(node, endpoint);
+	rval = v4l2_of_parse_csi_bus(node, endpoint);
+	if (rval)
+		return rval;
 	/*
 	 * Parse the parallel video bus properties only if none
 	 * of the MIPI CSI-2 specific properties were found.
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 70fa7b7..a70eb52 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -29,12 +29,15 @@ struct device_node;
  * @data_lanes: an array of physical data lane indexes
  * @clock_lane: physical lane index of the clock lane
  * @num_data_lanes: number of data lanes
+ * @lane_polarity: polarity of the lanes. The order is the same of
+ *		   the physical lanes.
  */
 struct v4l2_of_bus_mipi_csi2 {
 	unsigned int flags;
 	unsigned char data_lanes[4];
 	unsigned char clock_lane;
 	unsigned short num_data_lanes;
+	bool lane_polarity[5];
 };
 
 /**
-- 
1.7.10.4

