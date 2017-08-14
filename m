Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44102 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752822AbdHNKq2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 06:46:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/3] v4l: fwnode: Use a less clash-prone name for MAX_DATA_LANES macro
Date: Mon, 14 Aug 2017 13:46:26 +0300
Message-Id: <20170814104626.5013-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
References: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid using a generic name such as MAX_DATA_LANES in a header file widely
included in drivers. Instead, call it V4L2_FWNODE_CSI2_MAX_DATA_LANES.

Fixes: 4ee236219f6d ("media: v4l2-fwnode: suppress a warning at OF parsing logic")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 5 +++--
 include/media/v4l2-fwnode.h           | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index df7169b5ed8c..40b2fbfe8865 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -48,9 +48,10 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
 	if (rval > 0) {
-		u32 array[1 + MAX_DATA_LANES];
+		u32 array[1 + V4L2_FWNODE_CSI2_MAX_DATA_LANES];
 
-		bus->num_data_lanes = min_t(int, MAX_DATA_LANES, rval);
+		bus->num_data_lanes =
+			min_t(int, V4L2_FWNODE_CSI2_MAX_DATA_LANES, rval);
 
 		fwnode_property_read_u32_array(fwnode, "data-lanes", array,
 					       bus->num_data_lanes);
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 08e743fb7944..7adec9851d9e 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -26,7 +26,7 @@
 
 struct fwnode_handle;
 
-#define MAX_DATA_LANES	4
+#define V4L2_FWNODE_CSI2_MAX_DATA_LANES	4
 
 /**
  * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
@@ -39,10 +39,10 @@ struct fwnode_handle;
  */
 struct v4l2_fwnode_bus_mipi_csi2 {
 	unsigned int flags;
-	unsigned char data_lanes[MAX_DATA_LANES];
+	unsigned char data_lanes[V4L2_FWNODE_CSI2_MAX_DATA_LANES];
 	unsigned char clock_lane;
 	unsigned short num_data_lanes;
-	bool lane_polarities[1 + MAX_DATA_LANES];
+	bool lane_polarities[1 + V4L2_FWNODE_CSI2_MAX_DATA_LANES];
 };
 
 /**
-- 
2.11.0
