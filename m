Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2GFOe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 07/10] ov772x: Add ov772x_read() and ov772x_write() functions
Date: Fri,  6 Jul 2012 16:34:58 +0200
Message-Id: <1341585301-1003-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And use them instead of calling SMBus access functions directly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 9055ba4..67c385b 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -447,13 +447,21 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
 	return container_of(sd, struct ov772x_priv, subdev);
 }
 
+static inline int ov772x_read(struct i2c_client *client, u8 addr)
+{
+	return i2c_smbus_read_byte_data(client, addr);
+}
+
+static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, addr, value);
+}
+
 static int ov772x_write_array(struct i2c_client        *client,
 			      const struct regval_list *vals)
 {
 	while (vals->reg_num != 0xff) {
-		int ret = i2c_smbus_write_byte_data(client,
-						    vals->reg_num,
-						    vals->value);
+		int ret = ov772x_write(client, vals->reg_num, vals->value);
 		if (ret < 0)
 			return ret;
 		vals++;
@@ -461,24 +469,22 @@ static int ov772x_write_array(struct i2c_client        *client,
 	return 0;
 }
 
-static int ov772x_mask_set(struct i2c_client *client,
-					  u8  command,
-					  u8  mask,
-					  u8  set)
+static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
+			   u8  set)
 {
-	s32 val = i2c_smbus_read_byte_data(client, command);
+	s32 val = ov772x_read(client, command);
 	if (val < 0)
 		return val;
 
 	val &= ~mask;
 	val |= set & mask;
 
-	return i2c_smbus_write_byte_data(client, command, val);
+	return ov772x_write(client, command, val);
 }
 
 static int ov772x_reset(struct i2c_client *client)
 {
-	int ret = i2c_smbus_write_byte_data(client, COM7, SCCB_RESET);
+	int ret = ov772x_write(client, COM7, SCCB_RESET);
 	msleep(1);
 	return ret;
 }
@@ -807,7 +813,7 @@ static int ov772x_g_register(struct v4l2_subdev *sd,
 	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	ret = i2c_smbus_read_byte_data(client, reg->reg);
+	ret = ov772x_write(client, reg->reg);
 	if (ret < 0)
 		return ret;
 
@@ -825,7 +831,7 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
 	    reg->val > 0xff)
 		return -EINVAL;
 
-	return i2c_smbus_write_byte_data(client, reg->reg, reg->val);
+	return ov772x_write(client, reg->reg, reg->val);
 }
 #endif
 
@@ -1012,8 +1018,8 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
-	pid = i2c_smbus_read_byte_data(client, PID);
-	ver = i2c_smbus_read_byte_data(client, VER);
+	pid = ov772x_read(client, PID);
+	ver = ov772x_read(client, VER);
 
 	switch (VERSION(pid, ver)) {
 	case OV7720:
@@ -1036,8 +1042,8 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 		 devname,
 		 pid,
 		 ver,
-		 i2c_smbus_read_byte_data(client, MIDH),
-		 i2c_smbus_read_byte_data(client, MIDL));
+		 ov772x_read(client, MIDH),
+		 ov772x_read(client, MIDL));
 	ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
 done:
-- 
1.7.8.6

