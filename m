Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43922 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752195AbdHNKbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 06:31:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/2] v4l: fwnode: Fix lane-polarities property parsing
Date: Mon, 14 Aug 2017 13:31:36 +0300
Message-Id: <20170814103137.17882-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
References: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fwnode_property_read_u32_array() only returns the number of array elements
if the array argument is NULL. The assumption that it always did so lead to
lane-polarities properties never being read.

Fixes: 4ee236219f6d ("media: v4l2-fwnode: suppress a warning at OF parsing logic")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d07c54efaa99..29e41312f04a 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -65,19 +65,23 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		}
 
 		rval = fwnode_property_read_u32_array(fwnode,
-						      "lane-polarities", array,
-						      1 + bus->num_data_lanes);
+						      "lane-polarities", NULL,
+						      0);
 		if (rval > 0) {
-			if (rval != 1 + bus->num_data_lanes /* clock + data */) {
+			if (rval != 1 + bus->num_data_lanes /* clock+data */) {
 				pr_warn("invalid number of lane-polarities entries (need %u, got %u)\n",
 					1 + bus->num_data_lanes, rval);
 				return -EINVAL;
 			}
 
+			fwnode_property_read_u32_array(fwnode,
+						       "lane-polarities", array,
+						       1 + bus->num_data_lanes);
 
 			for (i = 0; i < 1 + bus->num_data_lanes; i++)
 				bus->lane_polarities[i] = array[i];
 		}
+
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v)) {
-- 
2.11.0
