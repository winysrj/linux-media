Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52785 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbbECJyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:54:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/9] mt9m001: avoid calling mt9m001_find_datafmt() twice
Date: Sun,  3 May 2015 11:54:29 +0200
Message-Id: <1430646876-19594-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify mt9m001_s_fmt and mt9m001_set_fmt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9m001.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 4fbdd1e..1f49140 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -271,6 +271,7 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int mt9m001_s_fmt(struct v4l2_subdev *sd,
+			 const struct mt9m001_datafmt *fmt,
 			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -290,9 +291,8 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
 	if (!ret) {
 		mf->width	= mt9m001->rect.width;
 		mf->height	= mt9m001->rect.height;
-		mt9m001->fmt	= mt9m001_find_datafmt(mf->code,
-					mt9m001->fmts, mt9m001->num_fmts);
-		mf->colorspace	= mt9m001->fmt->colorspace;
+		mt9m001->fmt	= fmt;
+		mf->colorspace	= fmt->colorspace;
 	}
 
 	return ret;
@@ -328,7 +328,7 @@ static int mt9m001_set_fmt(struct v4l2_subdev *sd,
 	mf->colorspace	= fmt->colorspace;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		return mt9m001_s_fmt(sd, mf);
+		return mt9m001_s_fmt(sd, fmt, mf);
 	cfg->try_fmt = *mf;
 	return 0;
 }
-- 
2.1.4

