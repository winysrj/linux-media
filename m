Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46189 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752380AbdATOAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 09:00:41 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v4 7/7] [media] coda: support YUYV output if VDOA is used
Date: Fri, 20 Jan 2017 15:00:25 +0100
Message-Id: <20170120140025.3338-8-m.tretter@pengutronix.de>
In-Reply-To: <20170120140025.3338-1-m.tretter@pengutronix.de>
References: <20170120140025.3338-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VDOA is able to transform the NV12 custom macroblock tiled format of
the CODA to YUYV format. If and only if the VDOA is available, the
driver can also provide YUYV support.

While the driver is configured to produce YUYV output, the CODA must be
configured to produce NV12 macroblock tiled frames and the VDOA must
transform the intermediate result into the final YUYV output.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    |  7 +++++--
 drivers/media/platform/coda/coda-common.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index f608de4c52ac..466a44e4549e 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -759,7 +759,7 @@ static void coda9_set_frame_cache(struct coda_ctx *ctx, u32 fourcc)
 		cache_config = 1 << CODA9_CACHE_PAGEMERGE_OFFSET;
 	}
 	coda_write(ctx->dev, cache_size, CODA9_CMD_SET_FRAME_CACHE_SIZE);
-	if (fourcc == V4L2_PIX_FMT_NV12) {
+	if (fourcc == V4L2_PIX_FMT_NV12 || fourcc == V4L2_PIX_FMT_YUYV) {
 		cache_config |= 32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
 				16 << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET |
 				0 << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET;
@@ -1537,7 +1537,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 
 	ctx->frame_mem_ctrl &= ~(CODA_FRAME_CHROMA_INTERLEAVE | (0x3 << 9) |
 				 CODA9_FRAME_TILED2LINEAR);
-	if (dst_fourcc == V4L2_PIX_FMT_NV12)
+	if (dst_fourcc == V4L2_PIX_FMT_NV12 || dst_fourcc == V4L2_PIX_FMT_YUYV)
 		ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
 	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
 		ctx->frame_mem_ctrl |= (0x3 << 9) |
@@ -2079,6 +2079,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		trace_coda_dec_rot_done(ctx, dst_buf, meta);
 
 		switch (q_data_dst->fourcc) {
+		case V4L2_PIX_FMT_YUYV:
+			payload = width * height * 2;
+			break;
 		case V4L2_PIX_FMT_YUV420:
 		case V4L2_PIX_FMT_YVU420:
 		case V4L2_PIX_FMT_NV12:
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 13ee6cba6847..a918b294adef 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -95,6 +95,8 @@ void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
 	u32 base_cb, base_cr;
 
 	switch (q_data->fourcc) {
+	case V4L2_PIX_FMT_YUYV:
+		/* Fallthrough: IN -H264-> CODA -NV12 MB-> VDOA -YUYV-> OUT */
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_YUV420:
 	default:
@@ -201,6 +203,11 @@ static const struct coda_video_device coda_bit_decoder = {
 		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV420,
 		V4L2_PIX_FMT_YVU420,
+		/*
+		 * If V4L2_PIX_FMT_YUYV should be default,
+		 * set_default_params() must be adjusted.
+		 */
+		V4L2_PIX_FMT_YUYV,
 	},
 };
 
@@ -246,6 +253,7 @@ static u32 coda_format_normalize_yuv(u32 fourcc)
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_YUYV:
 		return V4L2_PIX_FMT_YUV420;
 	default:
 		return fourcc;
@@ -434,6 +442,11 @@ static int coda_try_pixelformat(struct coda_ctx *ctx, struct v4l2_format *f)
 		return -EINVAL;
 
 	for (i = 0; i < CODA_MAX_FORMATS; i++) {
+		/* Skip YUYV if the vdoa is not available */
+		if (!ctx->vdoa && f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+		    formats[i] == V4L2_PIX_FMT_YUYV)
+			continue;
+
 		if (formats[i] == f->fmt.pix.pixelformat) {
 			f->fmt.pix.pixelformat = formats[i];
 			return 0;
@@ -520,6 +533,11 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 3 / 2;
 		break;
+	case V4L2_PIX_FMT_YUYV:
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16) * 2;
+		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
+					f->fmt.pix.height;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
@@ -593,6 +611,15 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 		ret = coda_try_fmt_vdoa(ctx, f, &use_vdoa);
 		if (ret < 0)
 			return ret;
+
+		if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV) {
+			if (!use_vdoa)
+				return -EINVAL;
+
+			f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16) * 2;
+			f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
+				f->fmt.pix.height;
+		}
 	}
 
 	return 0;
@@ -662,6 +689,9 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 	}
 
 	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+		ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
+		break;
 	case V4L2_PIX_FMT_NV12:
 		ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
 		if (!disable_tiling)
-- 
2.11.0

