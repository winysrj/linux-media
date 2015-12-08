Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19710 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbbLHOjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 09:39:23 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH] media: s5p-jpeg: Adjust buffer size for Exynos 4412
Date: Tue, 08 Dec 2015 15:39:08 +0100
Message-id: <1449585548-17113-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

Eliminate iommu fault during encoding by adjusting image size
used for buffer size computation and ensuring that the buffer is not
overrun.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 4a608cb..49556e2 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1548,8 +1548,10 @@ static int exynos4_jpeg_get_output_buffer_size(struct s5p_jpeg_ctx *ctx,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	u32 pix_fmt = f->fmt.pix.pixelformat;
 	int w = pix->width, h = pix->height, wh_align;
+	int padding = 0;
 
 	if (pix_fmt == V4L2_PIX_FMT_RGB32 ||
+	    pix_fmt == V4L2_PIX_FMT_RGB565 ||
 	    pix_fmt == V4L2_PIX_FMT_NV24 ||
 	    pix_fmt == V4L2_PIX_FMT_NV42 ||
 	    pix_fmt == V4L2_PIX_FMT_NV12 ||
@@ -1564,7 +1566,10 @@ static int exynos4_jpeg_get_output_buffer_size(struct s5p_jpeg_ctx *ctx,
 			       &h, S5P_JPEG_MIN_HEIGHT,
 			       S5P_JPEG_MAX_HEIGHT, wh_align);
 
-	return w * h * fmt_depth >> 3;
+	if (ctx->jpeg->variant->version == SJPEG_EXYNOS4)
+		padding = PAGE_SIZE;
+
+	return (w * h * fmt_depth >> 3) + padding;
 }
 
 static int exynos3250_jpeg_try_downscale(struct s5p_jpeg_ctx *ctx,
-- 
1.9.2

