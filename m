Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:35006 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965168AbaDJHch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 03:32:37 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3T00I0U0YCAMA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Apr 2014 16:32:37 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 6/8] s5p-jpeg: Fix sysmmu page fault
Date: Thu, 10 Apr 2014 09:32:16 +0200
Message-id: <1397115138-1095-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
References: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes jpeg sysmmu page fault on Exynos4x12 SoCs.
During encoding Exynos4x12 SoCs access wider memory area
than it results from Image_x and Image_y values written to
the JPEG_IMAGE_SIZE register. In order to avoid sysmmu page
fault apply proper output buffer size alignment.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   46 +++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 541f03e..393f3fd 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1106,6 +1106,32 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
 	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_OUTPUT);
 }
 
+static int exynos4_jpeg_get_output_buffer_size(struct s5p_jpeg_ctx *ctx,
+						struct v4l2_format *f,
+						int fmt_depth)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 pix_fmt = f->fmt.pix.pixelformat;
+	int w = pix->width, h = pix->height, wh_align;
+
+	if (pix_fmt == V4L2_PIX_FMT_RGB32 ||
+	    pix_fmt == V4L2_PIX_FMT_NV24 ||
+	    pix_fmt == V4L2_PIX_FMT_NV42 ||
+	    pix_fmt == V4L2_PIX_FMT_NV12 ||
+	    pix_fmt == V4L2_PIX_FMT_NV21 ||
+	    pix_fmt == V4L2_PIX_FMT_YUV420)
+		wh_align = 4;
+	else
+		wh_align = 1;
+
+	jpeg_bound_align_image(&w, S5P_JPEG_MIN_WIDTH,
+			       S5P_JPEG_MAX_WIDTH, wh_align,
+			       &h, S5P_JPEG_MIN_HEIGHT,
+			       S5P_JPEG_MAX_HEIGHT, wh_align);
+
+	return w * h * fmt_depth >> 3;
+}
+
 static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 {
 	struct vb2_queue *vq;
@@ -1132,10 +1158,24 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 	q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
 	q_data->w = pix->width;
 	q_data->h = pix->height;
-	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG)
-		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
-	else
+	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
+		/*
+		 * During encoding Exynos4x12 SoCs access wider memory area
+		 * than it results from Image_x and Image_y values written to
+		 * the JPEG_IMAGE_SIZE register. In order to avoid sysmmu
+		 * page fault calculate proper buffer size in such a case.
+		 */
+		if (ct->jpeg->variant->version == SJPEG_EXYNOS4 &&
+		    f_type == FMT_TYPE_OUTPUT && ct->mode == S5P_JPEG_ENCODE)
+			q_data->size = exynos4_jpeg_get_output_buffer_size(ct,
+							f,
+							q_data->fmt->depth);
+		else
+			q_data->size = q_data->w * q_data->h *
+						q_data->fmt->depth >> 3;
+	} else {
 		q_data->size = pix->sizeimage;
+	}
 
 	if (f_type == FMT_TYPE_OUTPUT) {
 		ctrl_subs = v4l2_ctrl_find(&ct->ctrl_handler,
-- 
1.7.9.5

