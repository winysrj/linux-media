Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38491 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751679AbdIUKYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 06:24:32 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] tc358743: fix connected/active CSI-2 lane reporting
Date: Thu, 21 Sep 2017 12:24:28 +0200
Message-Id: <20170921102428.30709-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

g_mbus_config was supposed to indicate all supported lane numbers, not
only the number of those currently in active use. Since the tc358743
can dynamically reduce the number of active lanes if the required
bandwidth allows for it, report all lane numbers up to the connected
number of lanes as supported.
To allow communicating the number of currently active lanes, add a new
bitfield to the v4l2_mbus_config flags. This is a temporary fix, until
a better solution is found.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c  | 22 ++++++++++++----------
 include/media/v4l2-mediabus.h |  8 ++++++++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c363ccab5..e2a9e6a18a49d 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1464,21 +1464,22 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 	/* Support for non-continuous CSI-2 clock is missing in the driver */
 	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
-	switch (state->csi_lanes_in_use) {
-	case 1:
+	if (state->bus.num_data_lanes > 0)
 		cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
-		break;
-	case 2:
+	if (state->bus.num_data_lanes > 1)
 		cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
-		break;
-	case 3:
+	if (state->bus.num_data_lanes > 2)
 		cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
-		break;
-	case 4:
+	if (state->bus.num_data_lanes > 3)
 		cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
-		break;
-	default:
+
+	if (state->csi_lanes_in_use > 4)
 		return -EINVAL;
+
+	if (state->csi_lanes_in_use < state->bus.num_data_lanes) {
+		const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
+
+		cfg->flags |= (state->csi_lanes_in_use << __ffs(mask)) & mask;
 	}
 
 	return 0;
@@ -1885,6 +1886,7 @@ static int tc358743_probe(struct i2c_client *client,
 	if (pdata) {
 		state->pdata = *pdata;
 		state->bus.flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+		state->bus.num_data_lanes = 4;
 	} else {
 		err = tc358743_probe_of(state);
 		if (err == -ENODEV)
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 93f8afcb7a220..3467d97be5f5b 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -63,6 +63,14 @@
 					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
 #define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
 					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
+/*
+ * Number of lanes in use, 0 == use all available lanes (default)
+ *
+ * This is a temporary fix for devices that need to reduce the number of active
+ * lanes for certain modes, until g_mbus_config() can be replaced with a better
+ * solution.
+ */
+#define V4L2_MBUS_CSI2_LANE_MASK                (3 << 10)
 
 /**
  * enum v4l2_mbus_type - media bus type
-- 
2.11.0
