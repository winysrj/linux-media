Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:62905 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbdBHVPT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 16:15:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] tc358743: fix register i2c_rd/wr functions
Date: Wed,  8 Feb 2017 22:14:13 +0100
Message-Id: <20170208211436.2771166-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing with CONFIG_UBSAN, I got this warning:

drivers/media/i2c/tc358743.c: In function 'tc358743_probe':
drivers/media/i2c/tc358743.c:1930:1: error: the frame size of 2480 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

The problem is that the i2c_rd8/wr8/rd16/... functions in this driver pass
a pointer to a local variable into a common function, and each call to one
of them adds another variable plus redzone to the stack.

I also noticed that the way this is done is broken on big-endian machines,
as we copy the registers in CPU byte order.

To address both those problems, I'm adding two helper functions for reading
a register of up to 32 bits with correct endianess and change all other
functions to use that instead. Just to be sure we don't get the problem
back with changed optimizations in gcc, I'm also marking the new functions
as 'noinline', although my tests with gcc-7 don't require that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/tc358743.c | 46 ++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 5eb5e951f86f..8fb10a54f745 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -194,57 +194,61 @@ static void i2c_wr(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
 	}
 }
 
-static u8 i2c_rd8(struct v4l2_subdev *sd, u16 reg)
+static noinline u32 i2c_rdreg(struct v4l2_subdev *sd, u16 reg, u32 n)
 {
-	u8 val;
+	__le32 val = 0;
 
-	i2c_rd(sd, reg, &val, 1);
+	i2c_rd(sd, reg, (u8 __force *)&val, n);
 
-	return val;
+	return le32_to_cpu(val);
+}
+
+static noinline void i2c_wrreg(struct v4l2_subdev *sd, u16 reg, u32 val, u32 n)
+{
+	__le32 raw = cpu_to_le32(val);
+
+	i2c_wr(sd, reg, (u8 __force *)&raw, n);
+}
+
+static u8 i2c_rd8(struct v4l2_subdev *sd, u16 reg)
+{
+	return i2c_rdreg(sd, reg, 1);
 }
 
 static void i2c_wr8(struct v4l2_subdev *sd, u16 reg, u8 val)
 {
-	i2c_wr(sd, reg, &val, 1);
+	i2c_wrreg(sd, reg, val, 1);
 }
 
 static void i2c_wr8_and_or(struct v4l2_subdev *sd, u16 reg,
 		u8 mask, u8 val)
 {
-	i2c_wr8(sd, reg, (i2c_rd8(sd, reg) & mask) | val);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
 }
 
 static u16 i2c_rd16(struct v4l2_subdev *sd, u16 reg)
 {
-	u16 val;
-
-	i2c_rd(sd, reg, (u8 *)&val, 2);
-
-	return val;
+	return i2c_rdreg(sd, reg, 2);
 }
 
 static void i2c_wr16(struct v4l2_subdev *sd, u16 reg, u16 val)
 {
-	i2c_wr(sd, reg, (u8 *)&val, 2);
+	i2c_wrreg(sd, reg, val, 2);
 }
 
 static void i2c_wr16_and_or(struct v4l2_subdev *sd, u16 reg, u16 mask, u16 val)
 {
-	i2c_wr16(sd, reg, (i2c_rd16(sd, reg) & mask) | val);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
 }
 
 static u32 i2c_rd32(struct v4l2_subdev *sd, u16 reg)
 {
-	u32 val;
-
-	i2c_rd(sd, reg, (u8 *)&val, 4);
-
-	return val;
+	return i2c_rdreg(sd, reg, 4);
 }
 
 static void i2c_wr32(struct v4l2_subdev *sd, u16 reg, u32 val)
 {
-	i2c_wr(sd, reg, (u8 *)&val, 4);
+	i2c_wrreg(sd, reg, val, 4);
 }
 
 /* --------------- STATUS --------------- */
@@ -1227,7 +1231,7 @@ static int tc358743_g_register(struct v4l2_subdev *sd,
 
 	reg->size = tc358743_get_reg_size(reg->reg);
 
-	i2c_rd(sd, reg->reg, (u8 *)&reg->val, reg->size);
+	reg->val = i2c_rdreg(sd, reg->reg, reg->size);
 
 	return 0;
 }
@@ -1253,7 +1257,7 @@ static int tc358743_s_register(struct v4l2_subdev *sd,
 	    reg->reg == BCAPS)
 		return 0;
 
-	i2c_wr(sd, (u16)reg->reg, (u8 *)&reg->val,
+	i2c_wrreg(sd, (u16)reg->reg, reg->val,
 			tc358743_get_reg_size(reg->reg));
 
 	return 0;
-- 
2.9.0

