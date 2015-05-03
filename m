Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47334 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbbECJzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:55:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/9] ov9740: avoid calling ov9740_res_roundup() twice
Date: Sun,  3 May 2015 11:54:35 +0200
Message-Id: <1430646876-19594-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify ov9740_s_fmt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/ov9740.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 03a7fc7..61a8e18 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -673,20 +673,8 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov9740_priv *priv = to_ov9740(sd);
-	enum v4l2_colorspace cspace;
-	u32 code = mf->code;
 	int ret;
 
-	ov9740_res_roundup(&mf->width, &mf->height);
-
-	switch (code) {
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-		cspace = V4L2_COLORSPACE_SRGB;
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	ret = ov9740_reg_write_array(client, ov9740_defaults,
 				     ARRAY_SIZE(ov9740_defaults));
 	if (ret < 0)
@@ -696,11 +684,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
 
-	mf->code	= code;
-	mf->colorspace	= cspace;
-
-	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
-
+	priv->current_mf = *mf;
 	return ret;
 }
 
-- 
2.1.4

