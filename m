Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:24562 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752867AbcLFKiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 05:38:51 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH 1/3] tc358743: Do not read number of CSI lanes in use from chip
Date: Tue,  6 Dec 2016 11:24:27 +0100
Message-Id: <1481019869-20093-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

The number of CSI lanes that should be used is set to the CSI_CONTROL
register by indirectly writing to the CSI_CONFW register. When the
number of lanes is read back from the CSI_CONTROL register the value
is usually correct, but we have seen that it suddenly is 1 for a short
moment before the correct value is restored again.

Toshiba have not figured out why that happen, but we have found it
safer to store the value in the driver.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
---
 drivers/media/i2c/tc358743.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 1e3a0dd2..a35aaf8 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -96,6 +96,7 @@ struct tc358743_state {
 
 	struct v4l2_dv_timings timings;
 	u32 mbus_fmt_code;
+	u8 csi_lanes_in_use;
 
 	struct gpio_desc *reset_gpio;
 };
@@ -287,11 +288,6 @@ static int get_audio_sampling_rate(struct v4l2_subdev *sd)
 	return code_to_rate[i2c_rd8(sd, FS_SET) & MASK_FS];
 }
 
-static unsigned tc358743_num_csi_lanes_in_use(struct v4l2_subdev *sd)
-{
-	return ((i2c_rd32(sd, CSI_CONTROL) & MASK_NOL) >> 1) + 1;
-}
-
 /* --------------- TIMINGS --------------- */
 
 static inline unsigned fps(const struct v4l2_bt_timings *t)
@@ -683,6 +679,8 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
 
 	v4l2_dbg(3, debug, sd, "%s:\n", __func__);
 
+	state->csi_lanes_in_use = lanes;
+
 	tc358743_reset(sd, MASK_CTXRST);
 
 	if (lanes < 1)
@@ -1155,7 +1153,7 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Lanes needed: %d\n",
 			tc358743_num_csi_lanes_needed(sd));
 	v4l2_info(sd, "Lanes in use: %d\n",
-			tc358743_num_csi_lanes_in_use(sd));
+			state->csi_lanes_in_use);
 	v4l2_info(sd, "Waiting for particular sync signal: %s\n",
 			(i2c_rd16(sd, CSI_STATUS) & MASK_S_WSYNC) ?
 			"yes" : "no");
@@ -1438,12 +1436,14 @@ static int tc358743_dv_timings_cap(struct v4l2_subdev *sd,
 static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 			     struct v4l2_mbus_config *cfg)
 {
+	struct tc358743_state *state = to_state(sd);
+
 	cfg->type = V4L2_MBUS_CSI2;
 
 	/* Support for non-continuous CSI-2 clock is missing in the driver */
 	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
-	switch (tc358743_num_csi_lanes_in_use(sd)) {
+	switch (state->csi_lanes_in_use) {
 	case 1:
 		cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
 		break;
-- 
2.7.4

