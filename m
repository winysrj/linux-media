Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35922 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1CIQXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 11:23:44 -0500
Date: Wed, 09 Mar 2011 17:23:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 7/7] s5p-fimc: Fix G_FMT ioctl handler
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1299687805-23525-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use pix_mp member of struct v4l2_format to return a format
description rather than pix. Also fill in the plane_fmt array.
This is a missing bit of conversion to the multiplanar API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b29937e..6c919b3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -804,15 +804,33 @@ int fimc_vidioc_g_fmt_mplane(struct file *file, void *priv,
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *frame;
+	struct v4l2_pix_format_mplane *pixm;
+	int i;
 
 	frame = ctx_get_frame(ctx, f->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	f->fmt.pix.width	= frame->width;
-	f->fmt.pix.height	= frame->height;
-	f->fmt.pix.field	= V4L2_FIELD_NONE;
-	f->fmt.pix.pixelformat	= frame->fmt->fourcc;
+	pixm = &f->fmt.pix_mp;
+
+	pixm->width		= frame->width;
+	pixm->height		= frame->height;
+	pixm->field		= V4L2_FIELD_NONE;
+	pixm->pixelformat	= frame->fmt->fourcc;
+	pixm->colorspace	= V4L2_COLORSPACE_JPEG;
+	pixm->num_planes	= frame->fmt->memplanes;
+
+	for (i = 0; i < pixm->num_planes; ++i) {
+		int bpl = frame->o_width;
+
+		if (frame->fmt->colplanes == 1) /* packed formats */
+			bpl = (bpl * frame->fmt->depth[0]) / 8;
+
+		pixm->plane_fmt[i].bytesperline = bpl;
+
+		pixm->plane_fmt[i].sizeimage = (frame->o_width *
+			frame->o_height * frame->fmt->depth[i]) / 8;
+	}
 
 	return 0;
 }
@@ -907,6 +925,7 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
 
 	pix->num_planes = fmt->memplanes;
+	pix->colorspace	= V4L2_COLORSPACE_JPEG;
 
 	for (i = 0; i < pix->num_planes; ++i) {
 		int bpl = pix->plane_fmt[i].bytesperline;
-- 
1.7.4.1
