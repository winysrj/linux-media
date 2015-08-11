Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbbHKPUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:20:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH 1/4] tc358743: don't use variable length array for I2C writes
Date: Tue, 11 Aug 2015 12:18:30 -0300
Message-Id: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/tc358743.c:148:19: warning: Variable length array is used.

As the maximum size is 1026, we can't use dynamic var, as it
would otherwise spend 1056 bytes of the stack at i2c_wr() function.

So, allocate a buffer with the allowed maximum size together with
the state var.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 2e926317d7e9..fe42c9a1cb78 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -59,6 +59,9 @@ MODULE_LICENSE("GPL");
 #define EDID_NUM_BLOCKS_MAX 8
 #define EDID_BLOCK_SIZE 128
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  (EDID_NUM_BLOCKS_MAX * EDID_BLOCK_SIZE + 2)
+
 static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
@@ -94,6 +97,9 @@ struct tc358743_state {
 	/* edid  */
 	u8 edid_blocks_written;
 
+	/* used by i2c_wr() */
+	u8 wr_data[MAX_XFER_SIZE];
+
 	struct v4l2_dv_timings timings;
 	u32 mbus_fmt_code;
 
@@ -143,9 +149,13 @@ static void i2c_wr(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
 {
 	struct tc358743_state *state = to_state(sd);
 	struct i2c_client *client = state->i2c_client;
+	u8 *data = state->wr_data;
 	int err, i;
 	struct i2c_msg msg;
-	u8 data[2 + n];
+
+	if ((2 + n) > sizeof(state->wr_data))
+		v4l2_warn(sd, "i2c wr reg=%04x: len=%d is too big!\n",
+			  reg, 2 + n);
 
 	msg.addr = client->addr;
 	msg.buf = data;
-- 
2.4.3

