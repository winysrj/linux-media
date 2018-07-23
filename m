Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56340 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388334AbeGWOsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 19/21] v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
Date: Mon, 23 Jul 2018 16:47:04 +0300
Message-Id: <20180723134706.15334-20-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 fwnode framework only parsed CSI-2 D-PHY endpoints while C-PHY
support wasn't there. Also parse endpoints for media bus type
V4L2_MBUS_CSI2_CPHY.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 56e3b6395171..04ddac86aec2 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -145,7 +145,8 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	u32 v;
 	int rval;
 
-	if (bus_type == V4L2_MBUS_CSI2_DPHY) {
+	if (bus_type == V4L2_MBUS_CSI2_DPHY ||
+	    bus_type == V4L2_MBUS_CSI2_CPHY) {
 		use_default_lane_mapping = true;
 
 		num_data_lanes = min_t(u32, bus->num_data_lanes,
@@ -221,10 +222,12 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	}
 
-	if (bus_type == V4L2_MBUS_CSI2_DPHY || lanes_used ||
+	if (bus_type == V4L2_MBUS_CSI2_DPHY ||
+	    bus_type == V4L2_MBUS_CSI2_CPHY || lanes_used ||
 	    have_clk_lane || (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
 		bus->flags = flags;
-		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
+		if (bus_type == V4L2_MBUS_UNKNOWN)
+			vep->bus_type = V4L2_MBUS_CSI2_DPHY;
 		bus->num_data_lanes = num_data_lanes;
 
 		if (use_default_lane_mapping) {
@@ -472,6 +475,7 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		break;
 
 	case V4L2_MBUS_CSI2_DPHY:
+	case V4L2_MBUS_CSI2_CPHY:
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
 							   vep->bus_type);
 		if (rval)
-- 
2.11.0
