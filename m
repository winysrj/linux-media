Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54763 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaESMdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:44 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 10/10] [media] s5p-mfc: Rename IS_MFCV7 macro
Date: Mon, 19 May 2014 18:03:06 +0530
Message-Id: <1400502786-4826-11-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
References: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renaming the IS_MFCV7 macro to IS_MFCV7_PLUS for the
addition of MFCv8 support which reuses the v7 code.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 662fcef..993c993 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -701,6 +701,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 				(dev->variant->port_num ? 1 : 0) : 0) : 0)
 #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
 #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
-#define IS_MFCV7(dev)		(dev->variant->version >= 0x70 ? 1 : 0)
+#define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
 
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 1a55487..d09c2e1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1039,7 +1039,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
-		if (!IS_MFCV7(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+		if (!IS_MFCV7_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
 			mfc_err("VP8 is supported only in MFC v7\n");
 			return -EINVAL;
 		}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 37a054a..cbea828 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -113,7 +113,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			(ctx->mv_count * ctx->mv_size);
 		break;
 	case S5P_MFC_CODEC_MPEG4_DEC:
-		if (IS_MFCV7(dev)) {
+		if (IS_MFCV7_PLUS(dev)) {
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V7(
 						mb_width,
@@ -354,7 +354,7 @@ static void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
 	ctx->chroma_size = ALIGN((mb_width * mb_height) * 128, 256);
 
 	/* MFCv7 needs pad bytes for Luma and Chroma */
-	if (IS_MFCV7(ctx->dev)) {
+	if (IS_MFCV7_PLUS(ctx->dev)) {
 		ctx->luma_size += MFC_LUMA_PAD_BYTES_V7;
 		ctx->chroma_size += MFC_CHROMA_PAD_BYTES_V7;
 	}
@@ -1303,7 +1303,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		WRITEL(ctx->display_delay, mfc_regs->d_display_delay);
 	}
 
-	if (IS_MFCV7(dev)) {
+	if (IS_MFCV7_PLUS(dev)) {
 		WRITEL(reg, mfc_regs->d_dec_options);
 		reg = 0;
 	}
@@ -1318,7 +1318,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	if (IS_MFCV7(dev))
+	if (IS_MFCV7_PLUS(dev))
 		WRITEL(reg, mfc_regs->d_init_buffer_options);
 	else
 		WRITEL(reg, mfc_regs->d_dec_options);
@@ -1406,7 +1406,7 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* Set stride lengths for v7 & above */
-	if (IS_MFCV7(dev)) {
+	if (IS_MFCV7_PLUS(dev)) {
 		WRITEL(ctx->img_width, mfc_regs->e_source_first_plane_stride);
 		WRITEL(ctx->img_width, mfc_regs->e_source_second_plane_stride);
 	}
@@ -2148,7 +2148,7 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(e_h264_frame_packing_sei_info,
 			S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6);
 
-	if (!IS_MFCV7(dev))
+	if (!IS_MFCV7_PLUS(dev))
 		goto done;
 
 	/* Initialize registers used in MFC v7 */
-- 
1.7.9.5

