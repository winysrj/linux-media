Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:19975 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbLJNij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 08:38:39 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH] tc358743: Use local array with fixed size in i2c write
Date: Thu, 10 Dec 2015 14:38:07 +0100
Message-Id: <1449754687-23261-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

i2c_wr() is called from ops and the interrupt service routine, while
state->wr_data is shared and unprotected, and could be overwritten.

This shared buffer is therefore replaced with a local array with fixed
size. The array has the size of one EDID block (128 bytes) + 2 bytes
i2c address, and the EDID is written block by block (up to 8 blocks).

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
---
 drivers/media/i2c/tc358743.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 77b8011..cc38896 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -59,8 +59,7 @@ MODULE_LICENSE("GPL");
 #define EDID_NUM_BLOCKS_MAX 8
 #define EDID_BLOCK_SIZE 128
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  (EDID_NUM_BLOCKS_MAX * EDID_BLOCK_SIZE + 2)
+#define I2C_MAX_XFER_SIZE  (EDID_BLOCK_SIZE + 2)
 
 static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
@@ -97,9 +96,6 @@ struct tc358743_state {
 	/* edid  */
 	u8 edid_blocks_written;
 
-	/* used by i2c_wr() */
-	u8 wr_data[MAX_XFER_SIZE];
-
 	struct v4l2_dv_timings timings;
 	u32 mbus_fmt_code;
 
@@ -149,13 +145,15 @@ static void i2c_wr(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
 {
 	struct tc358743_state *state = to_state(sd);
 	struct i2c_client *client = state->i2c_client;
-	u8 *data = state->wr_data;
 	int err, i;
 	struct i2c_msg msg;
+	u8 data[I2C_MAX_XFER_SIZE];
 
-	if ((2 + n) > sizeof(state->wr_data))
+	if ((2 + n) > I2C_MAX_XFER_SIZE) {
+		n = I2C_MAX_XFER_SIZE - 2;
 		v4l2_warn(sd, "i2c wr reg=%04x: len=%d is too big!\n",
 			  reg, 2 + n);
+	}
 
 	msg.addr = client->addr;
 	msg.buf = data;
@@ -1581,6 +1579,7 @@ static int tc358743_s_edid(struct v4l2_subdev *sd,
 {
 	struct tc358743_state *state = to_state(sd);
 	u16 edid_len = edid->blocks * EDID_BLOCK_SIZE;
+	int i;
 
 	v4l2_dbg(2, debug, sd, "%s, pad %d, start block %d, blocks %d\n",
 		 __func__, edid->pad, edid->start_block, edid->blocks);
@@ -1606,7 +1605,8 @@ static int tc358743_s_edid(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	i2c_wr(sd, EDID_RAM, edid->edid, edid_len);
+	for (i = 0; i < edid_len; i += EDID_BLOCK_SIZE)
+		i2c_wr(sd, EDID_RAM + i, edid->edid + i, EDID_BLOCK_SIZE);
 
 	state->edid_blocks_written = edid->blocks;
 
-- 
2.5.0

