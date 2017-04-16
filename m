Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34516 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756550AbdDPRgD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:36:03 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so18048475wrc.1
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:36:02 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/7] ov2640: fix duplicate width+height returning from ov2640_select_win()
Date: Sun, 16 Apr 2017 19:35:44 +0200
Message-Id: <20170416173546.4317-6-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov2640_select_win() returns height and width values as part of struct
ov2640_win_size, so there is no point in modifying the passed height and
width parameters, too.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ov2640.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 6f0cc722477d..123767c58e83 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -775,21 +775,16 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 }
 
 /* Select the nearest higher resolution for capture */
-static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
+static const struct ov2640_win_size *ov2640_select_win(u32 width, u32 height)
 {
 	int i, default_size = ARRAY_SIZE(ov2640_supported_win_sizes) - 1;
 
 	for (i = 0; i < ARRAY_SIZE(ov2640_supported_win_sizes); i++) {
-		if (ov2640_supported_win_sizes[i].width  >= *width &&
-		    ov2640_supported_win_sizes[i].height >= *height) {
-			*width = ov2640_supported_win_sizes[i].width;
-			*height = ov2640_supported_win_sizes[i].height;
+		if (ov2640_supported_win_sizes[i].width  >= width &&
+		    ov2640_supported_win_sizes[i].height >= height)
 			return &ov2640_supported_win_sizes[i];
-		}
 	}
 
-	*width = ov2640_supported_win_sizes[default_size].width;
-	*height = ov2640_supported_win_sizes[default_size].height;
 	return &ov2640_supported_win_sizes[default_size];
 }
 
@@ -880,8 +875,7 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	if (!priv->win) {
-		u32 width = SVGA_WIDTH, height = SVGA_HEIGHT;
-		priv->win = ov2640_select_win(&width, &height);
+		priv->win = ov2640_select_win(SVGA_WIDTH, SVGA_HEIGHT);
 		priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
 	}
 
@@ -906,7 +900,9 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	/* select suitable win */
-	win = ov2640_select_win(&mf->width, &mf->height);
+	win = ov2640_select_win(mf->width, mf->height);
+	mf->width	= win->width;
+	mf->height	= win->height;
 
 	mf->field	= V4L2_FIELD_NONE;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
-- 
2.12.2
