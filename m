Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39210 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752006AbeCYW4s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 18:56:48 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
To: mchehab@kernel.org
Cc: p.zabel@pengutronix.de, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, bparrot@ti.com, garsilva@embeddedor.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nasser Afshin <Afshin.Nasser@gmail.com>
Subject: [PATCH] media: i2c: tvp5150: fix color burst lock instability on some hardware
Date: Mon, 26 Mar 2018 03:26:33 +0430
Message-Id: <20180325225633.5899-1-Afshin.Nasser@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the datasheet, INTREQ/GPCL/VBLK should have a pull-up/down
resistor if it's been disabled. On hardware that does not have such
resistor, we should use the default output enable value.
This prevents the color burst lock instability problem.

Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
---
 drivers/media/i2c/tvp5150.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 2476d812f669..0e9713814816 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -328,7 +328,7 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 		TVP5150_OP_MODE_CTL,0x00
 	},
 	{ /* 0x03 */
-		TVP5150_MISC_CTL,0x01
+		TVP5150_MISC_CTL,0x21
 	},
 	{ /* 0x06 */
 		TVP5150_COLOR_KIL_THSH_CTL,0x10
@@ -1072,7 +1072,8 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 		 * Enable the YCbCr and clock outputs. In discrete sync mode
 		 * (non-BT.656) additionally enable the the sync outputs.
 		 */
-		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
+		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE |
+			TVP5150_MISC_CTL_INTREQ_OE;
 		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 			val |= TVP5150_MISC_CTL_SYNC_OE;
 	}
-- 
2.15.0
