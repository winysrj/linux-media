Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58576 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3KYJ7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:59:11 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00J0XD2MKU40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:59:10 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 12/16] s5p-jpeg: Ensure correct capture format for Exynos4x12
Date: Mon, 25 Nov 2013 10:58:19 +0100
Message-id: <1385373503-1657-13-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
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
 drivers/media/platform/s5p-jpeg/jpeg-core.c |  113 +++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index cb55f67..76d8c12 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -358,6 +358,99 @@ static const unsigned char hactblg0[162] = {
 	0xf9, 0xfa
 };
 
+/*
+ * Fourcc downgrade schema lookup tables for 422 and 420
+ * chroma subsampling - fourcc on each position maps on the
+ * fourcc from the table fourcc_to_dwngrd_schema_id which allows
+ * to get the most suitable fourcc counterpart for the given
+ * downgraded subsampling property.
+ */
+static const u32 subs422_fourcc_dwngrd_schema[] = {
+	V4L2_PIX_FMT_NV16,
+	V4L2_PIX_FMT_NV61,
+};
+
+static const u32 subs420_fourcc_dwngrd_schema[] = {
+	V4L2_PIX_FMT_NV12,
+	V4L2_PIX_FMT_NV21,
+	V4L2_PIX_FMT_NV12,
+	V4L2_PIX_FMT_NV21,
+	V4L2_PIX_FMT_NV12,
+	V4L2_PIX_FMT_NV21,
+	V4L2_PIX_FMT_GREY,
+	V4L2_PIX_FMT_GREY,
+	V4L2_PIX_FMT_GREY,
+	V4L2_PIX_FMT_GREY,
+};
+
+/*
+ * Lookup table for translation of a fourcc to the position
+ * of its downgraded counterpart in the *fourcc_dwngrd_schema
+ * tables.
+ */
+static const u32 fourcc_to_dwngrd_schema_id[] = {
+	V4L2_PIX_FMT_NV24,
+	V4L2_PIX_FMT_NV42,
+	V4L2_PIX_FMT_NV16,
+	V4L2_PIX_FMT_NV61,
+	V4L2_PIX_FMT_YUYV,
+	V4L2_PIX_FMT_YVYU,
+	V4L2_PIX_FMT_NV12,
+	V4L2_PIX_FMT_NV21,
+	V4L2_PIX_FMT_YUV420,
+	V4L2_PIX_FMT_GREY,
+};
+
+static int s5p_jpeg_get_dwngrd_sch_id_by_fourcc(u32 fourcc)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(fourcc_to_dwngrd_schema_id); ++i) {
+		if (fourcc_to_dwngrd_schema_id[i] == fourcc)
+			return i;
+	}
+
+	return -EINVAL;
+}
+
+static int s5p_jpeg_adjust_fourcc_to_subsampling(
+					enum v4l2_jpeg_chroma_subsampling subs,
+					u32 in_fourcc,
+					u32 *out_fourcc,
+					struct s5p_jpeg_ctx *ctx)
+{
+	int dwngrd_sch_id;
+
+	if (ctx->subsampling != V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY) {
+		dwngrd_sch_id =
+			s5p_jpeg_get_dwngrd_sch_id_by_fourcc(in_fourcc);
+		if (dwngrd_sch_id < 0)
+			return -EINVAL;
+	}
+
+	switch (ctx->subsampling) {
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
+		*out_fourcc = V4L2_PIX_FMT_GREY;
+		break;
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_420:
+		if (dwngrd_sch_id >
+				ARRAY_SIZE(subs420_fourcc_dwngrd_schema) - 1)
+			return -EINVAL;
+		*out_fourcc = subs420_fourcc_dwngrd_schema[dwngrd_sch_id];
+		break;
+	case V4L2_JPEG_CHROMA_SUBSAMPLING_422:
+		if (dwngrd_sch_id >
+				ARRAY_SIZE(subs422_fourcc_dwngrd_schema) - 1)
+			return -EINVAL;
+		*out_fourcc = subs422_fourcc_dwngrd_schema[dwngrd_sch_id];
+		break;
+	default:
+		*out_fourcc = V4L2_PIX_FMT_GREY;
+		break;
+	}
+
+	return 0;
+}
+
 static inline struct s5p_jpeg_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
 {
 	return container_of(c->handler, struct s5p_jpeg_ctx, ctrl_handler);
@@ -941,7 +1034,9 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct s5p_jpeg_fmt *fmt;
+	int ret;
 
 	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
 						FMT_TYPE_CAPTURE);
@@ -952,6 +1047,24 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
+	/*
+	 * The exynos4x12 device requires resulting YUV image
+	 * subsampling not to be lower than the input jpeg subsampling.
+	 * If this requirement is not met then downgrade the requested
+	 * capture format to the one with subsampling equal to the input jpeg.
+	 */
+	if ((ctx->jpeg->variant->version != SJPEG_S5P) &&
+	    (ctx->mode == S5P_JPEG_DECODE) &&
+	    (fmt->flags & SJPEG_FMT_NON_RGB) &&
+	    (fmt->subsampling < ctx->subsampling)) {
+		ret = s5p_jpeg_adjust_fourcc_to_subsampling(ctx->subsampling,
+							    fmt->fourcc,
+							    &pix->pixelformat,
+							    ctx);
+		if (ret < 0)
+			pix->pixelformat = V4L2_PIX_FMT_GREY;
+	}
+
 	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_CAPTURE);
 }
 
-- 
1.7.9.5

