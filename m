Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55630 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3KSO2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:28:04 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00H7TLIMVM60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:28:04 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 12/16] s5p-jpeg: Ensure correct capture format for Exynos4x12
Date: Tue, 19 Nov 2013 15:27:04 +0100
Message-id: <1384871228-6648-13-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust capture format to the Exynos4x12 device limitations,
according to the subsampling value parsed from the source
JPEG image header. If the capture format was set to YUV with
subsampling lower than the one of the source JPEG image
the decoding process would not succeed.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   78 +++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e09b03a..15b2dea 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -941,6 +941,7 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct s5p_jpeg_fmt *fmt;
 
 	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
@@ -952,6 +953,83 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
+	/*
+	 * The exynos4x12 device requires resulting YUV image
+	 * subsampling not to be lower than the input jpeg subsampling.
+	 * If this requirement is not met then downgrade the requested
+	 * output format to the one with subsampling equal to the input jpeg.
+	 */
+	if ((ctx->jpeg->variant->version != SJPEG_S5P) &&
+	    (ctx->mode == S5P_JPEG_DECODE) &&
+	    (fmt->flags & SJPEG_FMT_NON_RGB) &&
+	    (fmt->subsampling < ctx->subsampling)) {
+		switch (fmt->fourcc) {
+		case V4L2_PIX_FMT_NV24:
+			switch (ctx->subsampling) {
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_422:
+				pix->pixelformat = V4L2_PIX_FMT_NV16;
+				break;
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+				pix->pixelformat = V4L2_PIX_FMT_NV12;
+				break;
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
+				pix->pixelformat = V4L2_PIX_FMT_GREY;
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case V4L2_PIX_FMT_NV42:
+			switch (ctx->subsampling) {
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_422:
+				pix->pixelformat = V4L2_PIX_FMT_NV61;
+				break;
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+				pix->pixelformat = V4L2_PIX_FMT_NV21;
+				break;
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
+				pix->pixelformat = V4L2_PIX_FMT_GREY;
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case V4L2_PIX_FMT_YUYV:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_YUV420:
+			switch (ctx->subsampling) {
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+				pix->pixelformat = V4L2_PIX_FMT_NV12;
+				break;
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
+				pix->pixelformat = V4L2_PIX_FMT_GREY;
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case V4L2_PIX_FMT_YVYU:
+		case V4L2_PIX_FMT_NV61:
+			switch (ctx->subsampling) {
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+				pix->pixelformat = V4L2_PIX_FMT_NV21;
+				break;
+			case  V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
+				pix->pixelformat = V4L2_PIX_FMT_GREY;
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+			pix->pixelformat = V4L2_PIX_FMT_GREY;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_CAPTURE);
 }
 
-- 
1.7.9.5

