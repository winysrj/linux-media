Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42827 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751675AbdIUPac (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:30:32 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/2] [media] tc358743: fix connected/active CSI-2 lane reporting
Date: Thu, 21 Sep 2017 17:30:24 +0200
Message-Id: <20170921153024.15788-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

g_mbus_config was supposed to indicate all supported lane numbers, not
only the number of those currently in active use. Since the TC358743
can dynamically reduce the number of active lanes if the required
bandwidth allows for it, report all lane numbers up to the connected
number of lanes as supported in pdata mode.
In device tree mode, do not report lane count and clock mode at all, as
the receiver driver can determine these from the device tree.

To allow communicating the number of currently active lanes, add a new
bitfield to the v4l2_mbus_config flags. This is a temporary fix, to be
used only until a better solution is found.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Check csi_lanes_in_use <= num_data_lanes before writing to cfg.
 - Increase size of lane mask to 4 bits and always explicitly report
   number of lanes in use.
 - Clear clock and connected lane flags in DT mode.
---
 drivers/media/i2c/tc358743.c  | 30 ++++++++++++++++--------------
 include/media/v4l2-mediabus.h |  8 ++++++++
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c363ccab5..a35043cefe128 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1458,28 +1458,29 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 			     struct v4l2_mbus_config *cfg)
 {
 	struct tc358743_state *state = to_state(sd);
+	const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
+
+	if (state->csi_lanes_in_use > state->bus.num_data_lanes)
+		return -EINVAL;
 
 	cfg->type = V4L2_MBUS_CSI2;
+	cfg->flags = (state->csi_lanes_in_use << __ffs(mask)) & mask;
 
-	/* Support for non-continuous CSI-2 clock is missing in the driver */
-	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	/* In DT mode, only report the number of active lanes */
+	if (sd->dev->of_node)
+		return 0;
 
-	switch (state->csi_lanes_in_use) {
-	case 1:
+	/* Support for non-continuous CSI-2 clock is missing in pdata mode */
+	cfg->flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+
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
-		return -EINVAL;
-	}
 
 	return 0;
 }
@@ -1885,6 +1886,7 @@ static int tc358743_probe(struct i2c_client *client,
 	if (pdata) {
 		state->pdata = *pdata;
 		state->bus.flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+		state->bus.num_data_lanes = 4;
 	} else {
 		err = tc358743_probe_of(state);
 		if (err == -ENODEV)
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 93f8afcb7a220..fc106c902bf47 100644
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
+#define V4L2_MBUS_CSI2_LANE_MASK                (0xf << 10)
 
 /**
  * enum v4l2_mbus_type - media bus type
-- 
2.11.0
