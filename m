Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37431 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaENGqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 02:46:22 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v2 2/4] [media] s5p-mfc: Rename IS_MFCV7 macro
Date: Wed, 14 May 2014 12:16:03 +0530
Message-Id: <1400049965-1022-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400049965-1022-1-git-send-email-arun.kk@samsung.com>
References: <1400049965-1022-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renaming the IS_MFCV7 macro to IS_MFCV7_PLUS for the
addition of MFCv8 support which reuses the v7 code.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 8d85590..7b7053d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -706,6 +706,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 				(dev->variant->port_num ? 1 : 0) : 0) : 0)
 #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
 #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
-#define IS_MFCV7(dev)		(dev->variant->version >= 0x70 ? 1 : 0)
+#define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
 
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 0c8d593e..e7dddb0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1049,7 +1049,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
-		if (!IS_MFCV7(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+		if (!IS_MFCV7_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
 			mfc_err("VP8 is supported only in MFC v7\n");
 			return -EINVAL;
 		}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 47890e8..9a503ca 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -116,7 +116,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			(ctx->mv_count * ctx->mv_size);
 		break;
 	case S5P_MFC_CODEC_MPEG4_DEC:
-		if (IS_MFCV7(dev)) {
+		if (IS_MFCV7_PLUS(dev)) {
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V7(
 						mb_width,
@@ -357,7 +357,7 @@ static void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
 	ctx->chroma_size = ALIGN((mb_width * mb_height) * 128, 256);
 
 	/* MFCv7 needs pad bytes for Luma and Chroma */
-	if (IS_MFCV7(ctx->dev)) {
+	if (IS_MFCV7_PLUS(ctx->dev)) {
 		ctx->luma_size += MFC_LUMA_PAD_BYTES_V7;
 		ctx->chroma_size += MFC_CHROMA_PAD_BYTES_V7;
 	}
@@ -1283,7 +1283,7 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 /* Check if newer v6 firmware with changed init buffer interface */
 static bool s5p_mfc_is_v6_fw_v2(struct s5p_mfc_dev *dev)
 {
-	if (IS_MFCV7(dev))
+	if (IS_MFCV7_PLUS(dev))
 		return false;
 	/*
 	 * FW date is in BCD format xx120629. So checking for
@@ -1320,7 +1320,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		WRITEL(ctx->display_delay, mfc_regs->d_display_delay);
 	}
 
-	if (IS_MFCV7(dev) || s5p_mfc_is_v6_fw_v2(dev)) {
+	if (IS_MFCV7_PLUS(dev) || s5p_mfc_is_v6_fw_v2(dev)) {
 		WRITEL(reg, mfc_regs->d_dec_options);
 		reg = 0;
 	}
@@ -1335,7 +1335,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	if (IS_MFCV7(dev) || s5p_mfc_is_v6_fw_v2(dev))
+	if (IS_MFCV7_PLUS(dev) || s5p_mfc_is_v6_fw_v2(dev))
 		WRITEL(reg, mfc_regs->d_init_buffer_options);
 	else
 		WRITEL(reg, mfc_regs->d_dec_options);
@@ -1423,7 +1423,7 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* Set stride lengths for v7 & above */
-	if (IS_MFCV7(dev)) {
+	if (IS_MFCV7_PLUS(dev)) {
 		WRITEL(ctx->img_width, mfc_regs->e_source_first_plane_stride);
 		WRITEL(ctx->img_width, mfc_regs->e_source_second_plane_stride);
 	}
@@ -2165,7 +2165,7 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(e_h264_frame_packing_sei_info,
 			S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6);
 
-	if (!IS_MFCV7(dev))
+	if (!IS_MFCV7_PLUS(dev))
 		goto done;
 
 	/* Initialize registers used in MFC v7 */
-- 
1.7.9.5

