Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:43070 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbcGNUB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 16:01:59 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: andrzej.p@samsung.com, j.anaszewski@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p-jpeg add missing blank lines after declarations
Date: Thu, 14 Jul 2016 14:01:56 -0600
Message-Id: <1468526516-8892-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Missing blank lines after declarations are making it hard to read the
code. Fix them and also fix other checkpatch warnings at the same time.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 17bc94092..fe5554f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -537,6 +537,7 @@ static const u32 fourcc_to_dwngrd_schema_id[] = {
 static int s5p_jpeg_get_dwngrd_sch_id_by_fourcc(u32 fourcc)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(fourcc_to_dwngrd_schema_id); ++i) {
 		if (fourcc_to_dwngrd_schema_id[i] == fourcc)
 			return i;
@@ -1273,7 +1274,8 @@ static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
 			if (num == f->index)
 				break;
 			/* Correct type but haven't reached our index yet,
-			 * just increment per-type index */
+			 * just increment per-type index
+			*/
 			++num;
 		}
 	}
@@ -1349,6 +1351,7 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	pix->bytesperline = 0;
 	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
 		u32 bpl = q_data->w;
+
 		if (q_data->fmt->colplanes == 1)
 			bpl = (bpl * q_data->fmt->depth) >> 3;
 		pix->bytesperline = bpl;
@@ -1374,6 +1377,7 @@ static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
 
 	for (k = 0; k < ARRAY_SIZE(sjpeg_formats); k++) {
 		struct s5p_jpeg_fmt *fmt = &sjpeg_formats[k];
+
 		if (fmt->fourcc == pixelformat &&
 		    fmt->flags & fmt_flag &&
 		    fmt->flags & ctx->jpeg->variant->fmt_ver_flag) {
@@ -1431,7 +1435,8 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
 		return -EINVAL;
 
 	/* V4L2 specification suggests the driver corrects the format struct
-	 * if any of the dimensions is unsupported */
+	 * if any of the dimensions is unsupported
+	*/
 	if (q_type == FMT_TYPE_OUTPUT)
 		jpeg_bound_align_image(ctx, &pix->width, S5P_JPEG_MIN_WIDTH,
 				       S5P_JPEG_MAX_WIDTH, 0,
@@ -2490,6 +2495,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 	if (ctx->mode == S5P_JPEG_DECODE &&
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		struct s5p_jpeg_q_data tmp, *q_data;
+
 		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
 		     (unsigned long)vb2_plane_vaddr(vb, 0),
 		     min((unsigned long)ctx->out_q.size,
@@ -3025,7 +3031,8 @@ static int s5p_jpeg_resume(struct device *dev)
 
 static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(s5p_jpeg_suspend, s5p_jpeg_resume)
-	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume, NULL)
+	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume,
+			   NULL)
 };
 
 static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
-- 
2.7.4

