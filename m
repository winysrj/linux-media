Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32920 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaESMuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:50:14 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 2/2] [media] s5p-mfc: Core support for v8 encoder
Date: Mon, 19 May 2014 18:20:02 +0530
Message-Id: <1400503802-5543-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400503802-5543-1-git-send-email-arun.kk@samsung.com>
References: <1400503802-5543-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

This patch adds core support for v8 encoder. This
patch also adds register definitions and buffer size
requirements for H264 & VP8 encoding, needed for new
firmware version v8 for MFC

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h    |   30 ++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   12 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   56 +++++++++++++++++++----
 4 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
index c84d120..cc7cbec 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
@@ -72,16 +72,46 @@
 /* SEI related information */
 #define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V8	0xf6dc
 
+/* Encoder Registers */
+#define S5P_FIMV_E_FIXED_PICTURE_QP_V8		0xf794
+#define S5P_FIMV_E_RC_CONFIG_V8			0xf798
+#define S5P_FIMV_E_RC_QP_BOUND_V8		0xf79c
+#define S5P_FIMV_E_RC_RPARAM_V8			0xf7a4
+#define S5P_FIMV_E_MB_RC_CONFIG_V8		0xf7a8
+#define S5P_FIMV_E_PADDING_CTRL_V8		0xf7ac
+#define S5P_FIMV_E_MV_HOR_RANGE_V8		0xf7b4
+#define S5P_FIMV_E_MV_VER_RANGE_V8		0xf7b8
+
+#define S5P_FIMV_E_VBV_BUFFER_SIZE_V8		0xf78c
+#define S5P_FIMV_E_VBV_INIT_DELAY_V8		0xf790
+
+#define S5P_FIMV_E_ASPECT_RATIO_V8		0xfb4c
+#define S5P_FIMV_E_EXTENDED_SAR_V8		0xfb50
+#define S5P_FIMV_E_H264_OPTIONS_V8		0xfb54
+
 /* MFCv8 Context buffer sizes */
 #define MFC_CTX_BUF_SIZE_V8		(30 * SZ_1K)	/*  30KB */
 #define MFC_H264_DEC_CTX_BUF_SIZE_V8	(2 * SZ_1M)	/*  2MB */
 #define MFC_OTHER_DEC_CTX_BUF_SIZE_V8	(20 * SZ_1K)	/*  20KB */
+#define MFC_H264_ENC_CTX_BUF_SIZE_V8	(100 * SZ_1K)	/* 100KB */
+#define MFC_OTHER_ENC_CTX_BUF_SIZE_V8	(10 * SZ_1K)	/*  10KB */
 
 /* Buffer size defines */
+#define S5P_FIMV_TMV_BUFFER_SIZE_V8(w, h)	(((w) + 1) * ((h) + 1) * 8)
+
 #define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V8(w, h)	(((w) * 704) + 2176)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V8(w, h) \
 		(((w) * 576 + (h) * 128)  + 4128)
 
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V8(w, h) \
+			(((w) * 592) + 2336)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V8(w, h) \
+			(((w) * 576) + 10512 + \
+			((((((w) * 16) * ((h) * 16)) * 3) / 2) * 4))
+#define S5P_FIMV_ME_BUFFER_SIZE_V8(imw, imh, mbw, mbh) \
+	((DIV_ROUND_UP((mbw * 16), 64) *  DIV_ROUND_UP((mbh * 16), 64) * 256) \
+	 + (DIV_ROUND_UP((mbw) * (mbh), 32) * 16))
+
 /* BUffer alignment defines */
 #define S5P_FIMV_D_ALIGN_PLANE_SIZE_V8	64
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 6c466a3..9ed0985 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1404,6 +1404,8 @@ struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
 	.dev_ctx	= MFC_CTX_BUF_SIZE_V8,
 	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V8,
 	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V8,
+	.h264_enc_ctx	= MFC_H264_ENC_CTX_BUF_SIZE_V8,
+	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V8,
 };
 
 struct s5p_mfc_buf_size buf_size_v8 = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index ad759b9..56d1edd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -58,7 +58,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CrCb",
@@ -66,7 +66,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "H264 Encoded Stream",
@@ -74,7 +74,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "MPEG4 Encoded Stream",
@@ -82,7 +82,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "H263 Encoded Stream",
@@ -90,7 +90,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H263_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "VP8 Encoded Stream",
@@ -98,7 +98,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VP8_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V7,
+		.versions	= MFC_V7 | MFC_V8,
 	},
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index f365f7d..4f5e0ea 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -77,7 +77,12 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
 		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
 	} else if (ctx->type == MFCINST_ENCODER) {
-		ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
+		if (IS_MFCV8(dev))
+			ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
+			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V8(mb_width, mb_height),
+			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
+		else
+			ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
 			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V6(mb_width, mb_height),
 			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
 
@@ -87,10 +92,16 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) *
 				S5P_FIMV_CHROMA_MB_TO_PIXEL_V6,
 				S5P_FIMV_CHROMA_DPB_BUFFER_ALIGN_V6);
-		ctx->me_buffer_size = ALIGN(S5P_FIMV_ME_BUFFER_SIZE_V6(
-					ctx->img_width, ctx->img_height,
-					mb_width, mb_height),
-					S5P_FIMV_ME_BUFFER_ALIGN_V6);
+		if (IS_MFCV8(dev))
+			ctx->me_buffer_size = ALIGN(S5P_FIMV_ME_BUFFER_SIZE_V8(
+						ctx->img_width, ctx->img_height,
+						mb_width, mb_height),
+						S5P_FIMV_ME_BUFFER_ALIGN_V6);
+		else
+			ctx->me_buffer_size = ALIGN(S5P_FIMV_ME_BUFFER_SIZE_V6(
+						ctx->img_width, ctx->img_height,
+						mb_width, mb_height),
+						S5P_FIMV_ME_BUFFER_ALIGN_V6);
 
 		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
 			  ctx->luma_dpb_size, ctx->chroma_dpb_size);
@@ -174,10 +185,16 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_H264_ENC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(
+		if (IS_MFCV8(dev))
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V8(
 					mb_width,
 					mb_height);
+		else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(
+						mb_width,
+						mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size =
@@ -201,10 +218,16 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_VP8_ENC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V7(
+		if (IS_MFCV8(dev))
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V8(
 					mb_width,
 					mb_height);
+		else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V7(
+						mb_width,
+						mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size =
@@ -2235,6 +2258,21 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(d_display_crop_info1, S5P_FIMV_D_DISPLAY_CROP_INFO1_V8);
 	R(d_display_crop_info2, S5P_FIMV_D_DISPLAY_CROP_INFO2_V8);
 
+	/* encoder registers */
+	R(e_padding_ctrl, S5P_FIMV_E_PADDING_CTRL_V8);
+	R(e_rc_config, S5P_FIMV_E_RC_CONFIG_V8);
+	R(e_rc_mode, S5P_FIMV_E_RC_RPARAM_V8);
+	R(e_mv_hor_range, S5P_FIMV_E_MV_HOR_RANGE_V8);
+	R(e_mv_ver_range, S5P_FIMV_E_MV_VER_RANGE_V8);
+	R(e_rc_qp_bound, S5P_FIMV_E_RC_QP_BOUND_V8);
+	R(e_fixed_picture_qp, S5P_FIMV_E_FIXED_PICTURE_QP_V8);
+	R(e_vbv_buffer_size, S5P_FIMV_E_VBV_BUFFER_SIZE_V8);
+	R(e_vbv_init_delay, S5P_FIMV_E_VBV_INIT_DELAY_V8);
+	R(e_mb_rc_config, S5P_FIMV_E_MB_RC_CONFIG_V8);
+	R(e_aspect_ratio, S5P_FIMV_E_ASPECT_RATIO_V8);
+	R(e_extended_sar, S5P_FIMV_E_EXTENDED_SAR_V8);
+	R(e_h264_options, S5P_FIMV_E_H264_OPTIONS_V8);
+
 done:
 	return &mfc_regs;
 #undef S5P_MFC_REG_ADDR
-- 
1.7.9.5

