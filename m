Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:41757 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbeDGPs5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 11:48:57 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 6/6] media: ov772x: support device tree probing
Date: Sun,  8 Apr 2018 00:48:10 +0900
Message-Id: <1523116090-13101-7-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver currently only supports legacy platform data probe.
This change enables device tree probing.

Note that the platform data probe can select auto or manual edge control
mode, but the device tree probling can only select auto edge control mode
for now.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov772x.c | 60 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 5e91fa1..e67ec37 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -763,13 +763,13 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_VFLIP:
 		val = ctrl->val ? VFLIP_IMG : 0x00;
 		priv->flag_vflip = ctrl->val;
-		if (priv->info->flags & OV772X_FLAG_VFLIP)
+		if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
 			val ^= VFLIP_IMG;
 		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
 	case V4L2_CID_HFLIP:
 		val = ctrl->val ? HFLIP_IMG : 0x00;
 		priv->flag_hflip = ctrl->val;
-		if (priv->info->flags & OV772X_FLAG_HFLIP)
+		if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
 			val ^= HFLIP_IMG;
 		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
 	case V4L2_CID_BAND_STOP_FILTER:
@@ -928,19 +928,14 @@ static void ov772x_select_params(const struct v4l2_mbus_framefmt *mf,
 	*win = ov772x_select_win(mf->width, mf->height);
 }
 
-static int ov772x_set_params(struct ov772x_priv *priv,
-			     const struct ov772x_color_format *cfmt,
-			     const struct ov772x_win_size *win)
+static int ov772x_edgectrl(struct ov772x_priv *priv)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
-	struct v4l2_fract tpf;
 	int ret;
-	u8  val;
 
-	/* Reset hardware. */
-	ov772x_reset(client);
+	if (!priv->info)
+		return 0;
 
-	/* Edge Ctrl. */
 	if (priv->info->edgectrl.strength & OV772X_MANUAL_EDGE_CTRL) {
 		/*
 		 * Manual Edge Control Mode.
@@ -951,19 +946,19 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 
 		ret = ov772x_mask_set(client, DSPAUTO, EDGE_ACTRL, 0x00);
 		if (ret < 0)
-			goto ov772x_set_fmt_error;
+			return ret;
 
 		ret = ov772x_mask_set(client,
 				      EDGE_TRSHLD, OV772X_EDGE_THRESHOLD_MASK,
 				      priv->info->edgectrl.threshold);
 		if (ret < 0)
-			goto ov772x_set_fmt_error;
+			return ret;
 
 		ret = ov772x_mask_set(client,
 				      EDGE_STRNGT, OV772X_EDGE_STRENGTH_MASK,
 				      priv->info->edgectrl.strength);
 		if (ret < 0)
-			goto ov772x_set_fmt_error;
+			return ret;
 
 	} else if (priv->info->edgectrl.upper > priv->info->edgectrl.lower) {
 		/*
@@ -975,15 +970,35 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 				      EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
 				      priv->info->edgectrl.upper);
 		if (ret < 0)
-			goto ov772x_set_fmt_error;
+			return ret;
 
 		ret = ov772x_mask_set(client,
 				      EDGE_LOWER, OV772X_EDGE_LOWER_MASK,
 				      priv->info->edgectrl.lower);
 		if (ret < 0)
-			goto ov772x_set_fmt_error;
+			return ret;
 	}
 
+	return 0;
+}
+
+static int ov772x_set_params(struct ov772x_priv *priv,
+			     const struct ov772x_color_format *cfmt,
+			     const struct ov772x_win_size *win)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	struct v4l2_fract tpf;
+	int ret;
+	u8  val;
+
+	/* Reset hardware. */
+	ov772x_reset(client);
+
+	/* Edge Ctrl. */
+	ret =  ov772x_edgectrl(priv);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+
 	/* Format and window size. */
 	ret = ov772x_write(client, HSTART, win->rect.left >> 2);
 	if (ret < 0)
@@ -1284,11 +1299,6 @@ static int ov772x_probe(struct i2c_client *client,
 	struct i2c_adapter	*adapter = client->adapter;
 	int			ret;
 
-	if (!client->dev.platform_data) {
-		dev_err(&client->dev, "Missing ov772x platform data\n");
-		return -EINVAL;
-	}
-
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -1390,9 +1400,19 @@ static const struct i2c_device_id ov772x_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ov772x_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ov772x_of_match[] = {
+	{ .compatible = "ovti,ov7725", },
+	{ .compatible = "ovti,ov7720", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, ov772x_of_match);
+#endif
+
 static struct i2c_driver ov772x_i2c_driver = {
 	.driver = {
 		.name = "ov772x",
+		.of_match_table = of_match_ptr(ov772x_of_match),
 	},
 	.probe    = ov772x_probe,
 	.remove   = ov772x_remove,
-- 
2.7.4
