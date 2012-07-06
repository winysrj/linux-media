Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2GFOe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 04/10] ov772x: Don't fail in s_fmt if the requested format isn't supported
Date: Fri,  6 Jul 2012 16:34:55 +0200
Message-Id: <1341585301-1003-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Select a default format instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   83 ++++++++++++++++++++++--------------------
 1 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 576780a..fcb338a 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -581,31 +581,33 @@ static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
-			     enum v4l2_mbus_pixelcode code)
+static void ov772x_select_params(const struct v4l2_mbus_framefmt *mf,
+				 const struct ov772x_color_format **cfmt,
+				 const struct ov772x_win_size **win)
 {
-	struct ov772x_priv *priv = to_ov772x(client);
-	int ret = -EINVAL;
-	u8  val;
-	int i;
+	unsigned int i;
+
+	/* Select the format format. */
+	*cfmt = &ov772x_cfmts[0];
 
-	/*
-	 * select format
-	 */
-	priv->cfmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
-		if (code == ov772x_cfmts[i].code) {
-			priv->cfmt = ov772x_cfmts + i;
+		if (mf->code == ov772x_cfmts[i].code) {
+			*cfmt = &ov772x_cfmts[i];
 			break;
 		}
 	}
-	if (!priv->cfmt)
-		goto ov772x_set_fmt_error;
 
-	/*
-	 * select win
-	 */
-	priv->win = ov772x_select_win(*width, *height);
+	/* Select the window size. */
+	*win = ov772x_select_win(mf->width, mf->height);
+}
+
+static int ov772x_set_params(struct ov772x_priv *priv,
+			     const struct ov772x_color_format *cfmt,
+			     const struct ov772x_win_size *win)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	int ret;
+	u8  val;
 
 	/*
 	 * reset hardware
@@ -662,14 +664,14 @@ static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
 	/*
 	 * set size format
 	 */
-	ret = ov772x_write_array(client, priv->win->regs);
+	ret = ov772x_write_array(client, win->regs);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
 	/*
 	 * set DSP_CTRL3
 	 */
-	val = priv->cfmt->dsp3;
+	val = cfmt->dsp3;
 	if (val) {
 		ret = ov772x_mask_set(client,
 				      DSP_CTRL3, UV_MASK, val);
@@ -680,7 +682,7 @@ static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
 	/*
 	 * set COM3
 	 */
-	val = priv->cfmt->com3;
+	val = cfmt->com3;
 	if (priv->info->flags & OV772X_FLAG_VFLIP)
 		val |= VFLIP_IMG;
 	if (priv->info->flags & OV772X_FLAG_HFLIP)
@@ -698,7 +700,7 @@ static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
 	/*
 	 * set COM7
 	 */
-	val = priv->win->com7_bit | priv->cfmt->com7;
+	val = win->com7_bit | cfmt->com7;
 	ret = ov772x_mask_set(client,
 			      COM7, SLCT_MASK | FMT_MASK | OFMT_MASK,
 			      val);
@@ -717,16 +719,11 @@ static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
 			goto ov772x_set_fmt_error;
 	}
 
-	*width = priv->win->width;
-	*height = priv->win->height;
-
 	return ret;
 
 ov772x_set_fmt_error:
 
 	ov772x_reset(client);
-	priv->win = NULL;
-	priv->cfmt = NULL;
 
 	return ret;
 }
@@ -855,11 +852,6 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 		return 0;
 	}
 
-	if (!priv->win || !priv->cfmt) {
-		dev_err(&client->dev, "norm or win select error\n");
-		return -EPERM;
-	}
-
 	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
 	dev_dbg(&client->dev, "format %d, win %s\n",
@@ -882,18 +874,29 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov772x_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
-	int ret = ov772x_set_params(client, &mf->width, &mf->height,
-				    mf->code);
+	const struct ov772x_color_format *cfmt;
+	const struct ov772x_win_size *win;
+	int ret;
 
-	if (!ret)
-		mf->colorspace = priv->cfmt->colorspace;
+	ov772x_select_params(mf, &cfmt, &win);
 
-	return ret;
+	ret = ov772x_set_params(priv, cfmt, win);
+	if (ret < 0)
+		return ret;
+
+	priv->win = win;
+	priv->cfmt = cfmt;
+
+	mf->code = cfmt->code;
+	mf->width = win->width;
+	mf->height = win->height;
+	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = cfmt->colorspace;
+
+	return 0;
 }
 
 static int ov772x_try_fmt(struct v4l2_subdev *sd,
-- 
1.7.8.6

