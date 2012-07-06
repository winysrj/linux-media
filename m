Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60066 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2GFOez (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 01/10] ov772x: Reorganize the code in sections
Date: Fri,  6 Jul 2012 16:34:52 +0200
Message-Id: <1341585301-1003-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Functions are only moved around without any other code change.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |  503 +++++++++++++++++++++---------------------
 1 files changed, 256 insertions(+), 247 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 641f6f4..7c645dd 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -439,8 +439,55 @@ static const struct regval_list ov772x_vga_regs[] = {
 };
 
 /*
- * supported color format list
+ * general function
  */
+
+static struct ov772x_priv *to_ov772x(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct ov772x_priv,
+			    subdev);
+}
+
+static int ov772x_write_array(struct i2c_client        *client,
+			      const struct regval_list *vals)
+{
+	while (vals->reg_num != 0xff) {
+		int ret = i2c_smbus_write_byte_data(client,
+						    vals->reg_num,
+						    vals->value);
+		if (ret < 0)
+			return ret;
+		vals++;
+	}
+	return 0;
+}
+
+static int ov772x_mask_set(struct i2c_client *client,
+					  u8  command,
+					  u8  mask,
+					  u8  set)
+{
+	s32 val = i2c_smbus_read_byte_data(client, command);
+	if (val < 0)
+		return val;
+
+	val &= ~mask;
+	val |= set & mask;
+
+	return i2c_smbus_write_byte_data(client, command, val);
+}
+
+static int ov772x_reset(struct i2c_client *client)
+{
+	int ret = i2c_smbus_write_byte_data(client, COM7, SCCB_RESET);
+	msleep(1);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Formats and hardware configuration
+ */
+
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
 		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
@@ -493,10 +540,6 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 	},
 };
 
-
-/*
- * window size list
- */
 #define VGA_WIDTH   640
 #define VGA_HEIGHT  480
 #define QVGA_WIDTH  320
@@ -520,177 +563,6 @@ static const struct ov772x_win_size ov772x_win_qvga = {
 	.regs     = ov772x_qvga_regs,
 };
 
-/*
- * general function
- */
-
-static struct ov772x_priv *to_ov772x(const struct i2c_client *client)
-{
-	return container_of(i2c_get_clientdata(client), struct ov772x_priv,
-			    subdev);
-}
-
-static int ov772x_write_array(struct i2c_client        *client,
-			      const struct regval_list *vals)
-{
-	while (vals->reg_num != 0xff) {
-		int ret = i2c_smbus_write_byte_data(client,
-						    vals->reg_num,
-						    vals->value);
-		if (ret < 0)
-			return ret;
-		vals++;
-	}
-	return 0;
-}
-
-static int ov772x_mask_set(struct i2c_client *client,
-					  u8  command,
-					  u8  mask,
-					  u8  set)
-{
-	s32 val = i2c_smbus_read_byte_data(client, command);
-	if (val < 0)
-		return val;
-
-	val &= ~mask;
-	val |= set & mask;
-
-	return i2c_smbus_write_byte_data(client, command, val);
-}
-
-static int ov772x_reset(struct i2c_client *client)
-{
-	int ret = i2c_smbus_write_byte_data(client, COM7, SCCB_RESET);
-	msleep(1);
-	return ret;
-}
-
-/*
- * soc_camera_ops function
- */
-
-static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
-
-	if (!enable) {
-		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
-		return 0;
-	}
-
-	if (!priv->win || !priv->cfmt) {
-		dev_err(&client->dev, "norm or win select error\n");
-		return -EPERM;
-	}
-
-	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
-
-	dev_dbg(&client->dev, "format %d, win %s\n",
-		priv->cfmt->code, priv->win->name);
-
-	return 0;
-}
-
-static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct ov772x_priv *priv = container_of(ctrl->handler,
-						struct ov772x_priv, hdl);
-	struct v4l2_subdev *sd = &priv->subdev;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret = 0;
-	u8 val;
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		val = ctrl->val ? VFLIP_IMG : 0x00;
-		priv->flag_vflip = ctrl->val;
-		if (priv->info->flags & OV772X_FLAG_VFLIP)
-			val ^= VFLIP_IMG;
-		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
-	case V4L2_CID_HFLIP:
-		val = ctrl->val ? HFLIP_IMG : 0x00;
-		priv->flag_hflip = ctrl->val;
-		if (priv->info->flags & OV772X_FLAG_HFLIP)
-			val ^= HFLIP_IMG;
-		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
-	case V4L2_CID_BAND_STOP_FILTER:
-		if (!ctrl->val) {
-			/* Switch the filter off, it is on now */
-			ret = ov772x_mask_set(client, BDBASE, 0xff, 0xff);
-			if (!ret)
-				ret = ov772x_mask_set(client, COM8,
-						      BNDF_ON_OFF, 0);
-		} else {
-			/* Switch the filter on, set AEC low limit */
-			val = 256 - ctrl->val;
-			ret = ov772x_mask_set(client, COM8,
-					      BNDF_ON_OFF, BNDF_ON_OFF);
-			if (!ret)
-				ret = ov772x_mask_set(client, BDBASE,
-						      0xff, val);
-		}
-		if (!ret)
-			priv->band_filter = ctrl->val;
-		return ret;
-	}
-
-	return -EINVAL;
-}
-
-static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
-
-	id->ident    = priv->model;
-	id->revision = 0;
-
-	return 0;
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int ov772x_g_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret;
-
-	reg->size = 1;
-	if (reg->reg > 0xff)
-		return -EINVAL;
-
-	ret = i2c_smbus_read_byte_data(client, reg->reg);
-	if (ret < 0)
-		return ret;
-
-	reg->val = (__u64)ret;
-
-	return 0;
-}
-
-static int ov772x_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (reg->reg > 0xff ||
-	    reg->val > 0xff)
-		return -EINVAL;
-
-	return i2c_smbus_write_byte_data(client, reg->reg, reg->val);
-}
-#endif
-
-static int ov772x_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
-
-	return soc_camera_set_power(&client->dev, icl, on);
-}
-
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 {
 	__u32 diff;
@@ -860,27 +732,139 @@ ov772x_set_fmt_error:
 	return ret;
 }
 
-static int ov772x_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	a->c.left	= 0;
-	a->c.top	= 0;
-	a->c.width	= VGA_WIDTH;
-	a->c.height	= VGA_HEIGHT;
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct ov772x_priv *priv = container_of(ctrl->handler,
+						struct ov772x_priv, hdl);
+	struct v4l2_subdev *sd = &priv->subdev;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+	u8 val;
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		val = ctrl->val ? VFLIP_IMG : 0x00;
+		priv->flag_vflip = ctrl->val;
+		if (priv->info->flags & OV772X_FLAG_VFLIP)
+			val ^= VFLIP_IMG;
+		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
+	case V4L2_CID_HFLIP:
+		val = ctrl->val ? HFLIP_IMG : 0x00;
+		priv->flag_hflip = ctrl->val;
+		if (priv->info->flags & OV772X_FLAG_HFLIP)
+			val ^= HFLIP_IMG;
+		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
+	case V4L2_CID_BAND_STOP_FILTER:
+		if (!ctrl->val) {
+			/* Switch the filter off, it is on now */
+			ret = ov772x_mask_set(client, BDBASE, 0xff, 0xff);
+			if (!ret)
+				ret = ov772x_mask_set(client, COM8,
+						      BNDF_ON_OFF, 0);
+		} else {
+			/* Switch the filter on, set AEC low limit */
+			val = 256 - ctrl->val;
+			ret = ov772x_mask_set(client, COM8,
+					      BNDF_ON_OFF, BNDF_ON_OFF);
+			if (!ret)
+				ret = ov772x_mask_set(client, BDBASE,
+						      0xff, val);
+		}
+		if (!ret)
+			priv->band_filter = ctrl->val;
+		return ret;
+	}
+
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
+	.s_ctrl = ov772x_s_ctrl,
+};
+
+/* -----------------------------------------------------------------------------
+ * Core operations
+ */
+
+static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_chip_ident *id)
+{
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+
+	id->ident    = priv->model;
+	id->revision = 0;
 
 	return 0;
 }
 
-static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov772x_g_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
 {
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= VGA_WIDTH;
-	a->bounds.height		= VGA_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	reg->size = 1;
+	if (reg->reg > 0xff)
+		return -EINVAL;
+
+	ret = i2c_smbus_read_byte_data(client, reg->reg);
+	if (ret < 0)
+		return ret;
+
+	reg->val = (__u64)ret;
+
+	return 0;
+}
+
+static int ov772x_s_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (reg->reg > 0xff ||
+	    reg->val > 0xff)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(client, reg->reg, reg->val);
+}
+#endif
+
+static int ov772x_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
+/* -----------------------------------------------------------------------------
+ * Video operations
+ */
+
+static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+
+	if (!enable) {
+		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
+		return 0;
+	}
+
+	if (!priv->win || !priv->cfmt) {
+		dev_err(&client->dev, "norm or win select error\n");
+		return -EPERM;
+	}
+
+	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
+
+	dev_dbg(&client->dev, "format %d, win %s\n",
+		priv->cfmt->code, priv->win->name);
 
 	return 0;
 }
@@ -957,65 +941,30 @@ static int ov772x_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov772x_video_probe(struct i2c_client *client)
+static int ov772x_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct ov772x_priv *priv = to_ov772x(client);
-	u8                  pid, ver;
-	const char         *devname;
-	int		    ret;
-
-	ret = ov772x_s_power(&priv->subdev, 1);
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * check and show product ID and manufacturer ID
-	 */
-	pid = i2c_smbus_read_byte_data(client, PID);
-	ver = i2c_smbus_read_byte_data(client, VER);
-
-	switch (VERSION(pid, ver)) {
-	case OV7720:
-		devname     = "ov7720";
-		priv->model = V4L2_IDENT_OV7720;
-		break;
-	case OV7725:
-		devname     = "ov7725";
-		priv->model = V4L2_IDENT_OV7725;
-		break;
-	default:
-		dev_err(&client->dev,
-			"Product ID error %x:%x\n", pid, ver);
-		ret = -ENODEV;
-		goto done;
-	}
-
-	dev_info(&client->dev,
-		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
-		 devname,
-		 pid,
-		 ver,
-		 i2c_smbus_read_byte_data(client, MIDH),
-		 i2c_smbus_read_byte_data(client, MIDL));
-	ret = v4l2_ctrl_handler_setup(&priv->hdl);
+	a->c.left	= 0;
+	a->c.top	= 0;
+	a->c.width	= VGA_WIDTH;
+	a->c.height	= VGA_HEIGHT;
+	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-done:
-	ov772x_s_power(&priv->subdev, 0);
-	return ret;
+	return 0;
 }
 
-static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
-	.s_ctrl = ov772x_s_ctrl,
-};
+static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= 0;
+	a->bounds.top			= 0;
+	a->bounds.width			= VGA_WIDTH;
+	a->bounds.height		= VGA_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
 
-static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
-	.g_chip_ident	= ov772x_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.g_register	= ov772x_g_register,
-	.s_register	= ov772x_s_register,
-#endif
-	.s_power	= ov772x_s_power,
-};
+	return 0;
+}
 
 static int ov772x_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 			   enum v4l2_mbus_pixelcode *code)
@@ -1042,6 +991,19 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/* -----------------------------------------------------------------------------
+ * Subdev operations
+ */
+
+static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
+	.g_chip_ident	= ov772x_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= ov772x_g_register,
+	.s_register	= ov772x_s_register,
+#endif
+	.s_power	= ov772x_s_power,
+};
+
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
 	.g_mbus_fmt	= ov772x_g_fmt,
@@ -1058,10 +1020,57 @@ static struct v4l2_subdev_ops ov772x_subdev_ops = {
 	.video	= &ov772x_subdev_video_ops,
 };
 
-/*
- * i2c_driver function
+/* -----------------------------------------------------------------------------
+ * Initialization and cleanup
  */
 
+static int ov772x_video_probe(struct i2c_client *client)
+{
+	struct ov772x_priv *priv = to_ov772x(client);
+	u8                  pid, ver;
+	const char         *devname;
+	int		    ret;
+
+	ret = ov772x_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * check and show product ID and manufacturer ID
+	 */
+	pid = i2c_smbus_read_byte_data(client, PID);
+	ver = i2c_smbus_read_byte_data(client, VER);
+
+	switch (VERSION(pid, ver)) {
+	case OV7720:
+		devname     = "ov7720";
+		priv->model = V4L2_IDENT_OV7720;
+		break;
+	case OV7725:
+		devname     = "ov7725";
+		priv->model = V4L2_IDENT_OV7725;
+		break;
+	default:
+		dev_err(&client->dev,
+			"Product ID error %x:%x\n", pid, ver);
+		ret = -ENODEV;
+		goto done;
+	}
+
+	dev_info(&client->dev,
+		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 devname,
+		 pid,
+		 ver,
+		 i2c_smbus_read_byte_data(client, MIDH),
+		 i2c_smbus_read_byte_data(client, MIDL));
+	ret = v4l2_ctrl_handler_setup(&priv->hdl);
+
+done:
+	ov772x_s_power(&priv->subdev, 0);
+	return ret;
+}
+
 static int ov772x_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
-- 
1.7.8.6

