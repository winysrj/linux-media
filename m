Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40136
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751776AbdFZMRN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 08:17:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2] media: v4l2-fwnode: don't risk go out of array bounds
Date: Mon, 26 Jun 2017 09:16:17 -0300
Message-Id: <b150777f4831580d0312d436a5faac9b185547cd.1498479370.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by gcc:
	drivers/media/v4l2-core/v4l2-fwnode.c:76 v4l2_fwnode_endpoint_parse_csi_bus() error: buffer overflow 'array' 5 <= u16max

That's because, in thesis, the routine might have called with
some value at bus->num_data_lanes.

While this doesn't happen, in practice, some code change could
cause crashes, so, better to fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 153c53ca3925..dadffde1c729 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -56,24 +56,26 @@ static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwnode,
 
 			bus->data_lanes[i] = array[i];
 		}
-	}
 
-	rval = fwnode_property_read_u32_array(fwnode, "lane-polarities", NULL,
-					      0);
-	if (rval > 0) {
-		u32 array[ARRAY_SIZE(bus->lane_polarities)];
+		rval = fwnode_property_read_u32_array(fwnode,
+						      "lane-polarities",
+						      NULL, 0);
+		if (rval > 0) {
+			u32 array[ARRAY_SIZE(bus->lane_polarities)];
 
-		if (rval < 1 + bus->num_data_lanes /* clock + data */) {
-			pr_warn("too few lane-polarities entries (need %u, got %u)\n",
-				1 + bus->num_data_lanes, rval);
-			return -EINVAL;
+			if (rval < 1 + bus->num_data_lanes /* clock + data */) {
+				pr_warn("too few lane-polarities entries (need %u, got %u)\n",
+					1 + bus->num_data_lanes, rval);
+				return -EINVAL;
+			}
+
+			fwnode_property_read_u32_array(fwnode,
+						       "lane-polarities", array,
+						       1 + bus->num_data_lanes);
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
-- 
2.9.4
