Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41606
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751393AbdFZSIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 14:08:44 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3] media: v4l2-fwnode: suppress a warning at OF parsing logic
Date: Mon, 26 Jun 2017 15:07:54 -0300
Message-Id: <00e156a29353d934b42d4fb6a7fab753322518ee.1498500467.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch produce this warning:
	drivers/media/v4l2-core/v4l2-fwnode.c:76 v4l2_fwnode_endpoint_parse_csi_bus() error: buffer overflow 'array' 5 <= u16max

That's because, in thesis, the routine might have called with
some value at bus->num_data_lanes. That's not the current
case.

Yet, better to shut up this warning, and make the code more
reliable if some future changes might cause a bug.

While here, simplify the code a little bit by reading only
once from lanes-properties array.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 32 ++++++++++++++------------------
 include/media/v4l2-fwnode.h           |  6 ++++--
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 153c53ca3925..042eb67fa7b1 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -40,10 +40,9 @@ static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwnode,
 
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
 	if (rval > 0) {
-		u32 array[ARRAY_SIZE(bus->data_lanes)];
+		u32 array[MAX_DATA_LANES + 1];
 
-		bus->num_data_lanes =
-			min_t(int, ARRAY_SIZE(bus->data_lanes), rval);
+		bus->num_data_lanes = min_t(int, MAX_DATA_LANES, rval);
 
 		fwnode_property_read_u32_array(fwnode, "data-lanes", array,
 					       bus->num_data_lanes);
@@ -56,24 +55,21 @@ static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwnode,
 
 			bus->data_lanes[i] = array[i];
 		}
-	}
 
-	rval = fwnode_property_read_u32_array(fwnode, "lane-polarities", NULL,
-					      0);
-	if (rval > 0) {
-		u32 array[ARRAY_SIZE(bus->lane_polarities)];
+		rval = fwnode_property_read_u32_array(fwnode,
+						      "lane-polarities", array,
+						      1 + bus->num_data_lanes);
+		if (rval > 0) {
+			if (rval != 1 + bus->num_data_lanes /* clock + data */) {
+				pr_warn("invalid number of lane-polarities entries (need %u, got %u)\n",
+					1 + bus->num_data_lanes, rval);
+				return -EINVAL;
+			}
 
-		if (rval < 1 + bus->num_data_lanes /* clock + data */) {
-			pr_warn("too few lane-polarities entries (need %u, got %u)\n",
-				1 + bus->num_data_lanes, rval);
-			return -EINVAL;
+
+			for (i = 0; i < 1 + bus->num_data_lanes; i++)
+				bus->lane_polarities[i] = array[i];
 		}
-
-		fwnode_property_read_u32_array(fwnode, "lane-polarities", array,
-					       1 + bus->num_data_lanes);
-
-		for (i = 0; i < 1 + bus->num_data_lanes; i++)
-			bus->lane_polarities[i] = array[i];
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v)) {
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index ecc1233a873e..767099f38df6 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -26,6 +26,8 @@
 
 struct fwnode_handle;
 
+#define MAX_DATA_LANES	4
+
 /**
  * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
  * @flags: media bus (V4L2_MBUS_*) flags
@@ -37,10 +39,10 @@ struct fwnode_handle;
  */
 struct v4l2_fwnode_bus_mipi_csi2 {
 	unsigned int flags;
-	unsigned char data_lanes[4];
+	unsigned char data_lanes[MAX_DATA_LANES];
 	unsigned char clock_lane;
 	unsigned short num_data_lanes;
-	bool lane_polarities[5];
+	bool lane_polarities[MAX_DATA_LANES + 1];
 };
 
 /**
-- 
2.9.4
