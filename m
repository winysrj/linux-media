Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35929 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751818AbeEFOUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 10:20:17 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v5 11/14] media: ov772x: use v4l2_ctrl to get current control value
Date: Sun,  6 May 2018 23:19:26 +0900
Message-Id: <1525616369-8843-12-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver provides three V4L2 controls and the current value of
each control is saved as a variable in the private data structure.

We don't need to keep track of the current value by ourself, if we use
v4l2_ctrl returned from v4l2_ctrl_new_std() instead.

This is a preparatory change to avoid accessing registers under power
saving mode.  This simplifies s_ctrl() by making it just return without
saving the current control value in private area when it is called under
power saving mode.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v5
- No changes

 drivers/media/i2c/ov772x.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 92ad13f..9292a18 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -419,10 +419,10 @@ struct ov772x_priv {
 	struct gpio_desc		 *rstb_gpio;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
-	unsigned short                    flag_vflip:1;
-	unsigned short                    flag_hflip:1;
+	struct v4l2_ctrl		 *vflip_ctrl;
+	struct v4l2_ctrl		 *hflip_ctrl;
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
-	unsigned short                    band_filter;
+	struct v4l2_ctrl		 *band_filter_ctrl;
 	unsigned int			  fps;
 	/* lock to protect power_count */
 	struct mutex			  lock;
@@ -768,13 +768,11 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		val = ctrl->val ? VFLIP_IMG : 0x00;
-		priv->flag_vflip = ctrl->val;
 		if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
 			val ^= VFLIP_IMG;
 		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
 	case V4L2_CID_HFLIP:
 		val = ctrl->val ? HFLIP_IMG : 0x00;
-		priv->flag_hflip = ctrl->val;
 		if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
 			val ^= HFLIP_IMG;
 		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
@@ -794,8 +792,7 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 				ret = ov772x_mask_set(client, BDBASE,
 						      0xff, val);
 		}
-		if (!ret)
-			priv->band_filter = ctrl->val;
+
 		return ret;
 	}
 
@@ -1075,9 +1072,9 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 		val |= VFLIP_IMG;
 	if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
 		val |= HFLIP_IMG;
-	if (priv->flag_vflip)
+	if (priv->vflip_ctrl->val)
 		val ^= VFLIP_IMG;
-	if (priv->flag_hflip)
+	if (priv->hflip_ctrl->val)
 		val ^= HFLIP_IMG;
 
 	ret = ov772x_mask_set(client,
@@ -1096,11 +1093,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 		goto ov772x_set_fmt_error;
 
 	/* Set COM8. */
-	if (priv->band_filter) {
+	if (priv->band_filter_ctrl->val) {
+		unsigned short band_filter = priv->band_filter_ctrl->val;
+
 		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, BNDF_ON_OFF);
 		if (!ret)
 			ret = ov772x_mask_set(client, BDBASE,
-					      0xff, 256 - priv->band_filter);
+					      0xff, 256 - band_filter);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
 	}
@@ -1341,12 +1340,13 @@ static int ov772x_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
-	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-			  V4L2_CID_VFLIP, 0, 1, 1, 0);
-	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-			  V4L2_CID_HFLIP, 0, 1, 1, 0);
-	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-			  V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
+	priv->vflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
+					     V4L2_CID_VFLIP, 0, 1, 1, 0);
+	priv->hflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
+					     V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->band_filter_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
+						   V4L2_CID_BAND_STOP_FILTER,
+						   0, 256, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
-- 
2.7.4
