Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727010AbeIMCgK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 12/23] v4l: fwnode: Support driver-defined lane mapping defaults
Date: Thu, 13 Sep 2018 00:29:31 +0300
Message-Id: <20180912212942.19641-13-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of the default CSI-2 lane mapping from caller-passed
configuration.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 1ec7590b18bd..64c23cbf6f0b 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -55,10 +55,14 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	u32 v;
 	int rval;
 
-	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY)
+	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY) {
 		num_data_lanes = min_t(u32, bus->num_data_lanes,
 				       V4L2_FWNODE_CSI2_MAX_DATA_LANES);
 
+		for (i = 0; i < num_data_lanes; i++)
+			array[i] = bus->data_lanes[i];
+	}
+
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
 	if (rval > 0) {
 		num_data_lanes =
@@ -66,15 +70,15 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 
 		fwnode_property_read_u32_array(fwnode, "data-lanes", array,
 					       num_data_lanes);
+	}
 
-		for (i = 0; i < num_data_lanes; i++) {
-			if (lanes_used & BIT(array[i]))
-				pr_warn("duplicated lane %u in data-lanes\n",
-					array[i]);
-			lanes_used |= BIT(array[i]);
+	for (i = 0; i < num_data_lanes; i++) {
+		if (lanes_used & BIT(array[i]))
+			pr_warn("duplicated lane %u in data-lanes\n",
+				array[i]);
+		lanes_used |= BIT(array[i]);
 
-			pr_debug("lane %u position %u\n", i, array[i]);
-		}
+		pr_debug("lane %u position %u\n", i, array[i]);
 	}
 
 	rval = fwnode_property_read_u32_array(fwnode, "lane-polarities", NULL,
-- 
2.11.0
