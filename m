Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40532 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbbEDK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 06:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/8] mt9v022: avoid calling mt9v022_find_datafmt() twice
Date: Mon,  4 May 2015 12:25:50 +0200
Message-Id: <1430735155-24110-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430735155-24110-1-git-send-email-hverkuil@xs4all.nl>
References: <1430735155-24110-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify mt9v022_s_fmt and mt9v022_set_fmt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9v022.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index f313774..00516bf 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -396,6 +396,7 @@ static int mt9v022_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int mt9v022_s_fmt(struct v4l2_subdev *sd,
+			 const struct mt9v022_datafmt *fmt,
 			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -434,9 +435,8 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 	if (!ret) {
 		mf->width	= mt9v022->rect.width;
 		mf->height	= mt9v022->rect.height;
-		mt9v022->fmt	= mt9v022_find_datafmt(mf->code,
-					mt9v022->fmts, mt9v022->num_fmts);
-		mf->colorspace	= mt9v022->fmt->colorspace;
+		mt9v022->fmt	= fmt;
+		mf->colorspace	= fmt->colorspace;
 	}
 
 	return ret;
@@ -471,7 +471,7 @@ static int mt9v022_set_fmt(struct v4l2_subdev *sd,
 	mf->colorspace	= fmt->colorspace;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		return mt9v022_s_fmt(sd, mf);
+		return mt9v022_s_fmt(sd, fmt, mf);
 	cfg->try_fmt = *mf;
 	return 0;
 }
-- 
2.1.4

