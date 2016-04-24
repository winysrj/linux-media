Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33171 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcDXVKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:24 -0400
Received: by mail-wm0-f65.google.com with SMTP id r12so17688381wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:23 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 10/24] v4l: of: Separate lane parsing from CSI-2 bus parameter parsing
Date: Mon, 25 Apr 2016 00:08:10 +0300
Message-Id: <1461532104-24032-11-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

The CSI-1 will need these as well, separate them into a different function.

have_clk_lane and num_data_lanes arguments may be NULL; the CSI-1 bus will
have no use for them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c | 60 +++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 5304137..60bbc5f 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -25,53 +25,83 @@ enum v4l2_of_bus_type {
 	V4L2_OF_BUS_TYPE_PARALLEL,
 };
 
-static int v4l2_of_parse_csi2_bus(const struct device_node *node,
-				 struct v4l2_of_endpoint *endpoint)
+static int v4l2_of_parse_lanes(const struct device_node *node,
+			       unsigned char *clock_lane,
+			       bool *have_clk_lane,
+			       unsigned char *data_lanes,
+			       bool *lane_polarities,
+			       unsigned short *__num_data_lanes,
+			       unsigned int max_data_lanes)
 {
-	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
 	struct property *prop;
-	bool have_clk_lane = false;
-	unsigned int flags = 0;
+	unsigned short num_data_lanes = 0;
 	u32 v;
 
 	prop = of_find_property(node, "data-lanes", NULL);
 	if (prop) {
 		const __be32 *lane = NULL;
-		unsigned int i;
 
-		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
+		for (num_data_lanes = 0; num_data_lanes < max_data_lanes;
+		     num_data_lanes++) {
 			lane = of_prop_next_u32(prop, lane, &v);
 			if (!lane)
 				break;
-			bus->data_lanes[i] = v;
+			data_lanes[num_data_lanes] = v;
 		}
-		bus->num_data_lanes = i;
 	}
+	if (__num_data_lanes)
+		*__num_data_lanes = num_data_lanes;
 
 	prop = of_find_property(node, "lane-polarities", NULL);
 	if (prop) {
 		const __be32 *polarity = NULL;
 		unsigned int i;
 
-		for (i = 0; i < ARRAY_SIZE(bus->lane_polarities); i++) {
+		for (i = 0; i < 1 + max_data_lanes; i++) {
 			polarity = of_prop_next_u32(prop, polarity, &v);
 			if (!polarity)
 				break;
-			bus->lane_polarities[i] = v;
+			lane_polarities[i] = v;
 		}
 
-		if (i < 1 + bus->num_data_lanes /* clock + data */) {
+		if (i < 1 + num_data_lanes /* clock + data */) {
 			pr_warn("%s: too few lane-polarities entries (need %u, got %u)\n",
-				node->full_name, 1 + bus->num_data_lanes, i);
+				node->full_name, 1 + num_data_lanes, i);
 			return -EINVAL;
 		}
 	}
 
+	if (have_clk_lane)
+		*have_clk_lane = false;
+
 	if (!of_property_read_u32(node, "clock-lanes", &v)) {
-		bus->clock_lane = v;
-		have_clk_lane = true;
+		*clock_lane = v;
+		if (have_clk_lane)
+			*have_clk_lane = true;
 	}
 
+	return 0;
+}
+
+static int v4l2_of_parse_csi2_bus(const struct device_node *node,
+				 struct v4l2_of_endpoint *endpoint)
+{
+	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
+	bool have_clk_lane = false;
+	unsigned int flags = 0;
+	int rval;
+	u32 v;
+
+	rval = v4l2_of_parse_lanes(node, &bus->clock_lane, &have_clk_lane,
+				   bus->data_lanes, bus->lane_polarities,
+				   &bus->num_data_lanes,
+				   ARRAY_SIZE(bus->data_lanes));
+	if (rval)
+		return rval;
+
+	BUILD_BUG_ON(1 + ARRAY_SIZE(bus->data_lanes)
+		       != ARRAY_SIZE(bus->lane_polarities));
+
 	if (of_get_property(node, "clock-noncontinuous", &v))
 		flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
 	else if (have_clk_lane || bus->num_data_lanes > 0)
-- 
1.9.1

