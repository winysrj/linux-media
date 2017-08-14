Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43932 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752782AbdHNKbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 06:31:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/2] v4l: fwnode: The clock lane is the first lane in lane_polarities
Date: Mon, 14 Aug 2017 13:31:37 +0300
Message-Id: <20170814103137.17882-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
References: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock lane is the first lane in the lane_polarities array. Reflect this
consistently by putting the number of data lanes after the number of clock
lanes.

Fixes: 4ee236219f6d ("media: v4l2-fwnode: suppress a warning at OF parsing logic")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 2 +-
 include/media/v4l2-fwnode.h           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 29e41312f04a..c9147ec398b3 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -48,7 +48,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
 	if (rval > 0) {
-		u32 array[MAX_DATA_LANES + 1];
+		u32 array[1 + MAX_DATA_LANES];
 
 		bus->num_data_lanes = min_t(int, MAX_DATA_LANES, rval);
 
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index b373c43f65e8..8da716a6a1b8 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -42,7 +42,7 @@ struct v4l2_fwnode_bus_mipi_csi2 {
 	unsigned char data_lanes[MAX_DATA_LANES];
 	unsigned char clock_lane;
 	unsigned short num_data_lanes;
-	bool lane_polarities[MAX_DATA_LANES + 1];
+	bool lane_polarities[1 + MAX_DATA_LANES];
 };
 
 /**
-- 
2.11.0
