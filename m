Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:58126 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbeIKWHH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 18:07:07 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-media@vger.kernel.org, slongerbeam@gmail.com
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH v3 2/2] media: imx: capture: use 'v4l2_fill_frmivalenum_from_subdev'
Date: Tue, 11 Sep 2018 19:06:33 +0200
Message-Id: <1536685593-27512-3-git-send-email-phdm@macqel.be>
In-Reply-To: <1536685593-27512-1-git-send-email-phdm@macqel.be>
References: <linux-media@vger.kernel.org.slongerbeam@gmail.com>
 <1536685593-27512-1-git-send-email-phdm@macqel.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/media/imx/imx-media-capture.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 256039c..688dd7a 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -126,28 +126,12 @@ static int capture_enum_frameintervals(struct file *file, void *fh,
 {
 	struct capture_priv *priv = video_drvdata(file);
 	const struct imx_media_pixfmt *cc;
-	struct v4l2_subdev_frame_interval_enum fie = {
-		.index = fival->index,
-		.pad = priv->src_sd_pad,
-		.width = fival->width,
-		.height = fival->height,
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	int ret;
 
 	cc = imx_media_find_format(fival->pixel_format, CS_SEL_ANY, true);
 	if (!cc)
 		return -EINVAL;
 
-	fie.code = cc->codes[0];
-
-	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_interval,
-			       NULL, &fie);
-	if (ret)
-		return ret;
-
-	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-	fival->discrete = fie.interval;
+	return v4l2_fill_frmivalenum_from_subdev(priv->src_sd, fival, cc->codes[0]);
 
 	return 0;
 }
-- 
1.8.4
