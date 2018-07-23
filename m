Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56342 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388293AbeGWOsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 09/21] v4l: fwnode: Read lane inversion information despite lane numbering
Date: Mon, 23 Jul 2018 16:46:54 +0300
Message-Id: <20180723134706.15334-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Read the lane inversion independently of whether the "data-lanes" property
exists. This makes sense since the caller may pass the number of lanes as
the default configuration while the lane inversion configuration may still
be available in firmware.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 65 +++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index e62a1fcabd8f..3f30904c158c 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -43,26 +43,31 @@ enum v4l2_fwnode_bus_type {
 };
 
 static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
-					       struct v4l2_fwnode_endpoint *vep)
+					       struct v4l2_fwnode_endpoint *vep,
+					       enum v4l2_fwnode_bus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vep->bus.mipi_csi2;
 	bool have_clk_lane = false;
 	unsigned int flags = 0, lanes_used = 0;
+	u32 array[1 + V4L2_FWNODE_CSI2_MAX_DATA_LANES];
+	unsigned int num_data_lanes = 0;
 	unsigned int i;
 	u32 v;
 	int rval;
 
+	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY)
+		num_data_lanes = min_t(u32, bus->num_data_lanes,
+				       V4L2_FWNODE_CSI2_MAX_DATA_LANES);
+
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
 	if (rval > 0) {
-		u32 array[1 + V4L2_FWNODE_CSI2_MAX_DATA_LANES];
-
-		bus->num_data_lanes =
+		num_data_lanes =
 			min_t(int, V4L2_FWNODE_CSI2_MAX_DATA_LANES, rval);
 
 		fwnode_property_read_u32_array(fwnode, "data-lanes", array,
-					       bus->num_data_lanes);
+					       num_data_lanes);
 
-		for (i = 0; i < bus->num_data_lanes; i++) {
+		for (i = 0; i < num_data_lanes; i++) {
 			if (lanes_used & BIT(array[i]))
 				pr_warn("duplicated lane %u in data-lanes\n",
 					array[i]);
@@ -71,30 +76,27 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 			bus->data_lanes[i] = array[i];
 			pr_debug("lane %u position %u\n", i, array[i]);
 		}
+	}
 
-		rval = fwnode_property_read_u32_array(fwnode,
-						      "lane-polarities", NULL,
-						      0);
-		if (rval > 0) {
-			if (rval != 1 + bus->num_data_lanes /* clock+data */) {
-				pr_warn("invalid number of lane-polarities entries (need %u, got %u)\n",
-					1 + bus->num_data_lanes, rval);
-				return -EINVAL;
-			}
+	rval = fwnode_property_read_u32_array(fwnode, "lane-polarities", NULL,
+					      0);
+	if (rval > 0) {
+		if (rval != 1 + num_data_lanes /* clock+data */) {
+			pr_warn("invalid number of lane-polarities entries (need %u, got %u)\n",
+				1 + num_data_lanes, rval);
+			return -EINVAL;
+		}
 
-			fwnode_property_read_u32_array(fwnode,
-						       "lane-polarities", array,
-						       1 + bus->num_data_lanes);
+		fwnode_property_read_u32_array(fwnode, "lane-polarities", array,
+					       1 + num_data_lanes);
 
-			for (i = 0; i < 1 + bus->num_data_lanes; i++) {
-				bus->lane_polarities[i] = array[i];
-				pr_debug("lane %u polarity %sinverted",
-					 i, array[i] ? "" : "not ");
-			}
-		} else {
-			pr_debug("no lane polarities defined, assuming not inverted\n");
+		for (i = 0; i < 1 + num_data_lanes; i++) {
+			bus->lane_polarities[i] = array[i];
+			pr_debug("lane %u polarity %sinverted",
+				 i, array[i] ? "" : "not ");
 		}
-
+	} else {
+		pr_debug("no lane polarities defined, assuming not inverted\n");
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v)) {
@@ -114,10 +116,11 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	}
 
-	if (lanes_used || have_clk_lane ||
-	    (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
+	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY || lanes_used ||
+	    have_clk_lane || (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
 		bus->flags = flags;
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
+		bus->num_data_lanes = num_data_lanes;
 	}
 
 	return 0;
@@ -273,7 +276,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 
 	switch (bus_type) {
 	case V4L2_FWNODE_BUS_TYPE_GUESS:
-		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
+		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
+							   bus_type);
 		if (rval)
 			return rval;
 
@@ -289,7 +293,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		return 0;
 	case V4L2_FWNODE_BUS_TYPE_CSI2_DPHY:
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
-		return v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
+		return v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
+							   bus_type);
 	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
 	case V4L2_FWNODE_BUS_TYPE_BT656:
 		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, bus_type);
-- 
2.11.0
