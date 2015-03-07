Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33319 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752882AbbCGVmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 13/18] v4l: of: Read lane-polarity endpoint property
Date: Sat,  7 Mar 2015 23:41:10 +0200
Message-Id: <1425764475-27691-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lane_polarity field to struct v4l2_of_bus_mipi_csi2 and write the
contents of the lane polarity property to it. The field tells the polarity
of the physical lanes starting from the first one. Any unused lanes are
ignored, i.e. only the polarity of the used lanes is specified.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c |   21 ++++++++++++++++-----
 include/media/v4l2-of.h           |    3 +++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index b4ed9a9..a7a855e 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -23,7 +23,6 @@ static void v4l2_of_parse_csi_bus(const struct device_node *node,
 				  struct v4l2_of_endpoint *endpoint)
 {
 	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
-	u32 data_lanes[ARRAY_SIZE(bus->data_lanes)];
 	struct property *prop;
 	bool have_clk_lane = false;
 	unsigned int flags = 0;
@@ -34,14 +33,26 @@ static void v4l2_of_parse_csi_bus(const struct device_node *node,
 		const __be32 *lane = NULL;
 		int i;
 
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
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(bus->lane_polarity); i++) {
+			polarity = of_prop_next_u32(prop, polarity, &v);
+			if (!polarity)
+				break;
+			bus->lane_polarity[i] = v;
+		}
 	}
 
 	if (!of_property_read_u32(node, "clock-lanes", &v)) {
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

