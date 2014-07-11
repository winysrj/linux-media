Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34021 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaGKPUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:20:07 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00EA6ZXIQGA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:20:06 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 6/9] s5p-jpeg: Prevent erroneous downscaling for Exynos3250
 SoC
Date: Fri, 11 Jul 2014 17:19:47 +0200
Message-id: <1405091990-28567-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

JPEG codec on Exynos3250 SoC produces broken raw image if
a JPEG is decoded to YUV420 format and downscaling by
more then 2 is applied. Prevent this by asserting downscale
ratio to 2.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 2491ef8..1ef004b 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1317,12 +1317,16 @@ static int exynos4_jpeg_get_output_buffer_size(struct s5p_jpeg_ctx *ctx,
 	return w * h * fmt_depth >> 3;
 }
 
+static int exynos3250_jpeg_try_downscale(struct s5p_jpeg_ctx *ctx,
+				   struct v4l2_rect *r);
+
 static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 {
 	struct vb2_queue *vq;
 	struct s5p_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_ctrl *ctrl_subs;
+	struct v4l2_rect scale_rect;
 	unsigned int f_type;
 
 	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
@@ -1382,6 +1386,20 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 		ct->crop_rect.width = pix->width;
 		ct->crop_rect.height = pix->height;
 	}
+
+	/*
+	 * Prevent downscaling to YUV420 format by more than 2
+	 * for Exynos3250 SoC as it produces broken raw image
+	 * in such cases.
+	 */
+	if (ct->mode == S5P_JPEG_DECODE &&
+	    f_type == FMT_TYPE_CAPTURE &&
+	    ct->jpeg->variant->version == SJPEG_EXYNOS3250 &&
+	    pix->pixelformat == V4L2_PIX_FMT_YUV420 &&
+	    ct->scale_factor > 2) {
+		scale_rect.width = ct->out_q.w / 2;
+		scale_rect.height = ct->out_q.h / 2;
+		exynos3250_jpeg_try_downscale(ct, &scale_rect);
 	}
 
 	return 0;
-- 
1.7.9.5

