Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56356 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388304AbeGWOsb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 12/21] v4l: fwnode: Support default CSI-2 lane mapping for drivers
Date: Mon, 23 Jul 2018 16:46:57 +0300
Message-Id: <20180723134706.15334-13-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most hardware doesn't support re-mapping of the CSI-2 lanes. Especially
sensor drivers have a default number of lanes. Instead of requiring the
caller (the driver) to provide such a unit mapping, provide one if no
mapping is configured.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 60 +++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index ed147b6fd315..19f4e331c7d8 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -47,20 +47,35 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					       enum v4l2_fwnode_bus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vep->bus.mipi_csi2;
-	bool have_clk_lane = false, have_lane_polarities = false;
+	bool have_clk_lane = false, have_data_lanes = false,
+		have_lane_polarities = false;
 	unsigned int flags = 0, lanes_used = 0;
 	u32 array[1 + V4L2_FWNODE_CSI2_MAX_DATA_LANES];
+	u32 clock_lane = 0;
 	unsigned int num_data_lanes = 0;
+	bool use_default_lane_mapping = false;
 	unsigned int i;
 	u32 v;
 	int rval;
 
 	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY) {
+		use_default_lane_mapping = true;
+
 		num_data_lanes = min_t(u32, bus->num_data_lanes,
 				       V4L2_FWNODE_CSI2_MAX_DATA_LANES);
 
-		for (i = 0; i < num_data_lanes; i++)
+		clock_lane = bus->clock_lane;
+		if (clock_lane)
+			use_default_lane_mapping = false;
+
+		for (i = 0; i < num_data_lanes; i++) {
 			array[i] = bus->data_lanes[i];
+			if (array[i])
+				use_default_lane_mapping = false;
+		}
+
+		if (use_default_lane_mapping)
+			pr_debug("using default lane mapping\n");
 	}
 
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
@@ -70,15 +85,21 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 
 		fwnode_property_read_u32_array(fwnode, "data-lanes", array,
 					       num_data_lanes);
+
+		have_data_lanes = true;
 	}
 
 	for (i = 0; i < num_data_lanes; i++) {
-		if (lanes_used & BIT(array[i]))
-			pr_warn("duplicated lane %u in data-lanes\n",
-				array[i]);
+		if (lanes_used & BIT(array[i])) {
+			if (have_data_lanes || !use_default_lane_mapping)
+				pr_warn("duplicated lane %u in data-lanes, using defaults\n",
+					array[i]);
+			use_default_lane_mapping = true;
+		}
 		lanes_used |= BIT(array[i]);
 
-		pr_debug("lane %u position %u\n", i, array[i]);
+		if (have_data_lanes)
+			pr_debug("lane %u position %u\n", i, array[i]);
 	}
 
 	rval = fwnode_property_read_u32_array(fwnode, "lane-polarities", NULL,
@@ -94,13 +115,16 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v)) {
-		if (lanes_used & BIT(v))
-			pr_warn("duplicated lane %u in clock-lanes\n", v);
-		lanes_used |= BIT(v);
-
-		bus->clock_lane = v;
-		have_clk_lane = true;
+		clock_lane = v;
 		pr_debug("clock lane position %u\n", v);
+		have_clk_lane = true;
+	}
+
+	if (lanes_used & BIT(clock_lane)) {
+		if (have_clk_lane || !use_default_lane_mapping)
+			pr_warn("duplicated lane %u in clock-lanes, using defaults\n",
+			v);
+		use_default_lane_mapping = true;
 	}
 
 	if (fwnode_property_present(fwnode, "clock-noncontinuous")) {
@@ -115,8 +139,16 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		bus->flags = flags;
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
 		bus->num_data_lanes = num_data_lanes;
-		for (i = 0; i < num_data_lanes; i++)
-			bus->data_lanes[i] = array[i];
+
+		if (use_default_lane_mapping) {
+			bus->clock_lane = 0;
+			for (i = 0; i < num_data_lanes; i++)
+				bus->data_lanes[i] = 1 + i;
+		} else {
+			bus->clock_lane = clock_lane;
+			for (i = 0; i < num_data_lanes; i++)
+				bus->data_lanes[i] = array[i];
+		}
 
 		if (have_lane_polarities) {
 			fwnode_property_read_u32_array(fwnode,
-- 
2.11.0
