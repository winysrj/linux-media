Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:35006 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199AbaDJHci (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 03:32:38 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3T00JAT0YD8480@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Apr 2014 16:32:37 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 7/8] s5p_jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0 decompression
Date: Thu, 10 Apr 2014 09:32:17 +0200
Message-id: <1397115138-1095-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
References: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent decompression of a JPEG 4:2:0 with odd width to
the YUV 4:2:0 compliant formats for Exynos4x12 SoCs and
adjust capture format to RGB565 in such a case. This is
required because the configuration would produce a raw
image with broken luma component.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 393f3fd..24545bd 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1064,15 +1064,17 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
+	if ((ctx->jpeg->variant->version != SJPEG_EXYNOS4) ||
+	    (ctx->mode != S5P_JPEG_DECODE))
+		goto exit;
+
 	/*
 	 * The exynos4x12 device requires resulting YUV image
 	 * subsampling not to be lower than the input jpeg subsampling.
 	 * If this requirement is not met then downgrade the requested
 	 * capture format to the one with subsampling equal to the input jpeg.
 	 */
-	if ((ctx->jpeg->variant->version == SJPEG_EXYNOS4) &&
-	    (ctx->mode == S5P_JPEG_DECODE) &&
-	    (fmt->flags & SJPEG_FMT_NON_RGB) &&
+	if ((fmt->flags & SJPEG_FMT_NON_RGB) &&
 	    (fmt->subsampling < ctx->subsampling)) {
 		ret = s5p_jpeg_adjust_fourcc_to_subsampling(ctx->subsampling,
 							    fmt->fourcc,
@@ -1085,6 +1087,23 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 							FMT_TYPE_CAPTURE);
 	}
 
+	/*
+	 * Decompression of a JPEG file with 4:2:0 subsampling and odd
+	 * width to the YUV 4:2:0 compliant formats produces a raw image
+	 * with broken luma component. Adjust capture format to RGB565
+	 * in such a case.
+	 */
+	if (ctx->subsampling == V4L2_JPEG_CHROMA_SUBSAMPLING_420 &&
+	    (ctx->out_q.w & 1) &&
+	    (pix->pixelformat == V4L2_PIX_FMT_NV12 ||
+	     pix->pixelformat == V4L2_PIX_FMT_NV21 ||
+	     pix->pixelformat == V4L2_PIX_FMT_YUV420)) {
+		pix->pixelformat = V4L2_PIX_FMT_RGB565;
+		fmt = s5p_jpeg_find_format(ctx, pix->pixelformat,
+							FMT_TYPE_CAPTURE);
+	}
+
+exit:
 	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_CAPTURE);
 }
 
-- 
1.7.9.5

