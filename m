Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48509 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbeB0Pkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:52 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/13] media: tw9910: Re-organize in-code comments
Date: Tue, 27 Feb 2018 16:40:22 +0100
Message-Id: <1519746030-15407-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A lot of comments that would fit a single line were spread on two or
more lines. Also fix capitalization and punctuation where appropriate.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 44 +++++++++++++-------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index f88cc93..f082f6d 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -388,7 +388,7 @@ static int tw9910_set_hsync(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
-	/* So far only revisions 0 and 1 have been seen */
+	/* So far only revisions 0 and 1 have been seen. */
 	/* bit 2 - 0 */
 	if (priv->revision == 1)
 		ret = tw9910_mask_set(client, HSLOWCTL, 0x77,
@@ -653,21 +653,15 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 	int ret = -EINVAL;
 	u8 val;
 
-	/*
-	 * select suitable norm
-	 */
+	/* Select suitable norm. */
 	priv->scale = tw9910_select_norm(priv->norm, *width, *height);
 	if (!priv->scale)
 		goto tw9910_set_fmt_error;
 
-	/*
-	 * reset hardware
-	 */
+	/* Reset hardware. */
 	tw9910_reset(client);
 
-	/*
-	 * set bus width
-	 */
+	/* Set bus width. */
 	val = 0x00;
 	if (priv->info->buswidth == 16)
 		val = LEN;
@@ -676,9 +670,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
-	/*
-	 * select MPOUT behavior
-	 */
+	/* Select MPOUT behavior. */
 	switch (priv->info->mpout) {
 	case TW9910_MPO_VLOSS:
 		val = RTSEL_VLOSS; break;
@@ -704,16 +696,12 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
-	/*
-	 * set scale
-	 */
+	/* Set scale. */
 	ret = tw9910_set_scale(client, priv->scale);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
-	/*
-	 * set hsync
-	 */
+	/* Set hsync. */
 	ret = tw9910_set_hsync(client);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
@@ -740,7 +728,7 @@ static int tw9910_get_selection(struct v4l2_subdev *sd,
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
-	/* Only CROP, CROP_DEFAULT and CROP_BOUNDS are supported */
+	/* Only CROP, CROP_DEFAULT and CROP_BOUNDS are supported. */
 	if (sel->target > V4L2_SEL_TGT_CROP_BOUNDS)
 		return -EINVAL;
 
@@ -792,9 +780,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 	WARN_ON(mf->field != V4L2_FIELD_ANY &&
 		mf->field != V4L2_FIELD_INTERLACED_BT);
 
-	/*
-	 * check color format
-	 */
+	/* Check color format. */
 	if (mf->code != MEDIA_BUS_FMT_UYVY8_2X8)
 		return -EINVAL;
 
@@ -831,9 +817,7 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
 	mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	mf->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-	/*
-	 * select suitable norm
-	 */
+	/* Select suitable norm. */
 	scale = tw9910_select_norm(priv->norm, mf->width, mf->height);
 	if (!scale)
 		return -EINVAL;
@@ -854,9 +838,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 	int ret;
 	s32 id;
 
-	/*
-	 * tw9910 only use 8 or 16 bit bus width
-	 */
+	/* TW9910 only use 8 or 16 bit bus width. */
 	if (priv->info->buswidth != 16 && priv->info->buswidth != 8) {
 		dev_err(&client->dev, "bus width error\n");
 		return -ENODEV;
@@ -867,8 +849,8 @@ static int tw9910_video_probe(struct i2c_client *client)
 		return ret;
 
 	/*
-	 * check and show Product ID
-	 * So far only revisions 0 and 1 have been seen
+	 * Check and show Product ID.
+	 * So far only revisions 0 and 1 have been seen.
 	 */
 	id = i2c_smbus_read_byte_data(client, ID);
 	priv->revision = GET_REV(id);
-- 
2.7.4
