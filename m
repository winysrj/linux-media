Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56344 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388299AbeGWOsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 10/21] v4l: fwnode: Only assign configuration if there is no error
Date: Mon, 23 Jul 2018 16:46:55 +0300
Message-Id: <20180723134706.15334-11-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only assign endpoint configuration if the endpoint is parsed successfully.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 3f30904c158c..7c6513625f13 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -47,7 +47,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					       enum v4l2_fwnode_bus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vep->bus.mipi_csi2;
-	bool have_clk_lane = false;
+	bool have_clk_lane = false, have_lane_polarities = false;
 	unsigned int flags = 0, lanes_used = 0;
 	u32 array[1 + V4L2_FWNODE_CSI2_MAX_DATA_LANES];
 	unsigned int num_data_lanes = 0;
@@ -73,7 +73,6 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					array[i]);
 			lanes_used |= BIT(array[i]);
 
-			bus->data_lanes[i] = array[i];
 			pr_debug("lane %u position %u\n", i, array[i]);
 		}
 	}
@@ -87,16 +86,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 			return -EINVAL;
 		}
 
-		fwnode_property_read_u32_array(fwnode, "lane-polarities", array,
-					       1 + num_data_lanes);
-
-		for (i = 0; i < 1 + num_data_lanes; i++) {
-			bus->lane_polarities[i] = array[i];
-			pr_debug("lane %u polarity %sinverted",
-				 i, array[i] ? "" : "not ");
-		}
-	} else {
-		pr_debug("no lane polarities defined, assuming not inverted\n");
+		have_lane_polarities = true;
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v)) {
@@ -121,6 +111,22 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		bus->flags = flags;
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
 		bus->num_data_lanes = num_data_lanes;
+		for (i = 0; i < num_data_lanes; i++)
+			bus->data_lanes[i] = array[i];
+
+		if (have_lane_polarities) {
+			fwnode_property_read_u32_array(fwnode,
+						       "lane-polarities", array,
+						       1 + num_data_lanes);
+
+			for (i = 0; i < 1 + num_data_lanes; i++) {
+				bus->lane_polarities[i] = array[i];
+				pr_debug("lane %u polarity %sinverted",
+					 i, array[i] ? "" : "not ");
+			}
+		} else {
+			pr_debug("no lane polarities defined, assuming not inverted\n");
+		}
 	}
 
 	return 0;
-- 
2.11.0
