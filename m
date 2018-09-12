Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40960 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728232AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 21/23] v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
Date: Thu, 13 Sep 2018 00:29:40 +0300
Message-Id: <20180912212942.19641-22-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 fwnode framework only parsed CSI-2 D-PHY endpoints while C-PHY
support wasn't there. Also parse endpoints for media bus type
V4L2_MBUS_CSI2_CPHY.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index e3780fe624bd..1af9f6ef12b8 100644
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
@@ -468,6 +471,7 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 
 		break;
 	case V4L2_MBUS_CSI2_DPHY:
+	case V4L2_MBUS_CSI2_CPHY:
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
 							   vep->bus_type);
 		if (rval)
-- 
2.11.0
