Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52785 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbbECJy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:54:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/9] ov9640: avoid calling ov9640_res_roundup() twice
Date: Sun,  3 May 2015 11:54:34 +0200
Message-Id: <1430646876-19594-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify ov9640_s_fmt and ov9640_set_fmt

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/ov9640.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 8caae1c..c8ac41e 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -486,11 +486,8 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov9640_reg_alt alts = {0};
-	enum v4l2_colorspace cspace;
-	u32 code = mf->code;
 	int ret;
 
-	ov9640_res_roundup(&mf->width, &mf->height);
 	ov9640_alter_regs(mf->code, &alts);
 
 	ov9640_reset(client);
@@ -499,24 +496,7 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
 	if (ret)
 		return ret;
 
-	switch (code) {
-	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
-	case MEDIA_BUS_FMT_RGB565_2X8_LE:
-		cspace = V4L2_COLORSPACE_SRGB;
-		break;
-	default:
-		code = MEDIA_BUS_FMT_UYVY8_2X8;
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		cspace = V4L2_COLORSPACE_JPEG;
-	}
-
-	ret = ov9640_write_regs(client, mf->width, code, &alts);
-	if (!ret) {
-		mf->code	= code;
-		mf->colorspace	= cspace;
-	}
-
-	return ret;
+	return ov9640_write_regs(client, mf->width, mf->code, &alts);
 }
 
 static int ov9640_set_fmt(struct v4l2_subdev *sd,
@@ -539,8 +519,10 @@ static int ov9640_set_fmt(struct v4l2_subdev *sd,
 		break;
 	default:
 		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
+		/* fall through */
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
 	}
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-- 
2.1.4

