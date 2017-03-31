Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:36246 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754961AbdCaJEo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:04:44 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v3 04/11] [media] s5p-mfc: Support MFCv10.10 buffer requirements
Date: Fri, 31 Mar 2017 14:36:33 +0530
Message-id: <1490951200-32070-5-git-send-email-smitha.t@samsung.com>
In-reply-to: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
 <CGME20170331090435epcas5p4a17ab56c983cea2bc4754ceafe3e1362@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aligning the luma_dpb_size, chroma_dpb_size, mv_size and me_buffer_size
for MFCv10.10.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h   | 19 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 95 +++++++++++++++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |  2 +
 3 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
index 1ca09d6..3f0dab3 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
@@ -32,5 +32,24 @@
 #define MFC_VERSION_V10		0xA0
 #define MFC_NUM_PORTS_V10	1
 
+/* MFCv10 codec defines*/
+#define S5P_FIMV_CODEC_HEVC_ENC         26
+
+/* Encoder buffer size for MFC v10.0 */
+#define ENC_V100_BASE_SIZE(x, y) \
+	(((x + 3) * (y + 3) * 8) \
+	+  ((y * 64) + 1280) * DIV_ROUND_UP(x, 8))
+
+#define ENC_V100_H264_ME_SIZE(x, y) \
+	(ENC_V100_BASE_SIZE(x, y) \
+	+ (DIV_ROUND_UP(x * y, 64) * 32))
+
+#define ENC_V100_MPEG4_ME_SIZE(x, y) \
+	(ENC_V100_BASE_SIZE(x, y) \
+	+ (DIV_ROUND_UP(x * y, 128) * 16))
+
+#define ENC_V100_VP8_ME_SIZE(x, y) \
+	ENC_V100_BASE_SIZE(x, y)
+
 #endif /*_REGS_MFC_V10_H*/
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 5f0da0b..cb39484 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -64,6 +64,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int mb_width, mb_height;
+	unsigned int lcu_width = 0, lcu_height = 0;
 	int ret;
 
 	mb_width = MB_WIDTH(ctx->img_width);
@@ -74,7 +75,9 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
 		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
 	} else if (ctx->type == MFCINST_ENCODER) {
-		if (IS_MFCV8_PLUS(dev))
+		if (IS_MFCV10(dev)) {
+			ctx->tmv_buffer_size = 0;
+		} else if (IS_MFCV8_PLUS(dev))
 			ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
 			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V8(mb_width, mb_height),
 			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
@@ -82,13 +85,36 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
 			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V6(mb_width, mb_height),
 			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
-
-		ctx->luma_dpb_size = ALIGN((mb_width * mb_height) *
-				S5P_FIMV_LUMA_MB_TO_PIXEL_V6,
-				S5P_FIMV_LUMA_DPB_BUFFER_ALIGN_V6);
-		ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) *
-				S5P_FIMV_CHROMA_MB_TO_PIXEL_V6,
-				S5P_FIMV_CHROMA_DPB_BUFFER_ALIGN_V6);
+		if (IS_MFCV10(dev)) {
+			lcu_width = enc_lcu_width(ctx->img_width);
+			lcu_height = enc_lcu_height(ctx->img_height);
+			if (ctx->codec_mode != S5P_FIMV_CODEC_HEVC_ENC) {
+				ctx->luma_dpb_size =
+					ALIGN((mb_width * 16), 64)
+					* ALIGN((mb_height * 16), 32)
+						+ 64;
+				ctx->chroma_dpb_size =
+					ALIGN((mb_width * 16), 64)
+							* (mb_height * 8)
+							+ 64;
+			} else {
+				ctx->luma_dpb_size =
+					ALIGN((lcu_width * 32), 64)
+					* ALIGN((lcu_height * 32), 32)
+						+ 64;
+				ctx->chroma_dpb_size =
+					ALIGN((lcu_width * 32), 64)
+							* (lcu_height * 16)
+							+ 64;
+			}
+		} else {
+			ctx->luma_dpb_size = ALIGN((mb_width * mb_height) *
+					S5P_FIMV_LUMA_MB_TO_PIXEL_V6,
+					S5P_FIMV_LUMA_DPB_BUFFER_ALIGN_V6);
+			ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) *
+					S5P_FIMV_CHROMA_MB_TO_PIXEL_V6,
+					S5P_FIMV_CHROMA_DPB_BUFFER_ALIGN_V6);
+		}
 		if (IS_MFCV8_PLUS(dev))
 			ctx->me_buffer_size = ALIGN(S5P_FIMV_ME_BUFFER_SIZE_V8(
 						ctx->img_width, ctx->img_height,
@@ -197,6 +223,8 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_H264_ENC:
 		if (IS_MFCV10(dev)) {
 			mfc_debug(2, "Use min scratch buffer size\n");
+			ctx->me_buffer_size =
+			ALIGN(ENC_V100_H264_ME_SIZE(mb_width, mb_height), 16);
 		} else if (IS_MFCV8_PLUS(dev))
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V8(
@@ -219,6 +247,9 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_H263_ENC:
 		if (IS_MFCV10(dev)) {
 			mfc_debug(2, "Use min scratch buffer size\n");
+			ctx->me_buffer_size =
+				ALIGN(ENC_V100_MPEG4_ME_SIZE(mb_width,
+							mb_height), 16);
 		} else
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(
@@ -235,7 +266,10 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_VP8_ENC:
 		if (IS_MFCV10(dev)) {
 			mfc_debug(2, "Use min scratch buffer size\n");
-			} else if (IS_MFCV8_PLUS(dev))
+			ctx->me_buffer_size =
+				ALIGN(ENC_V100_VP8_ME_SIZE(mb_width, mb_height),
+						16);
+		} else if (IS_MFCV8_PLUS(dev))
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V8(
 					mb_width,
@@ -395,13 +429,13 @@ static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
 			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
-		if (IS_MFCV10(dev))
+		if (IS_MFCV10(dev)) {
 			ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V10(ctx->img_width,
 					ctx->img_height);
-		else
+		} else {
 			ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V6(ctx->img_width,
 					ctx->img_height);
-		ctx->mv_size = ALIGN(ctx->mv_size, 16);
+		}
 	} else {
 		ctx->mv_size = 0;
 	}
@@ -598,15 +632,34 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
 
-	for (i = 0; i < ctx->pb_count; i++) {
-		writel(buf_addr1, mfc_regs->e_luma_dpb + (4 * i));
-		buf_addr1 += ctx->luma_dpb_size;
-		writel(buf_addr1, mfc_regs->e_chroma_dpb + (4 * i));
-		buf_addr1 += ctx->chroma_dpb_size;
-		writel(buf_addr1, mfc_regs->e_me_buffer + (4 * i));
-		buf_addr1 += ctx->me_buffer_size;
-		buf_size1 -= (ctx->luma_dpb_size + ctx->chroma_dpb_size +
-			ctx->me_buffer_size);
+	if (IS_MFCV10(dev)) {
+		/* start address of per buffer is aligned */
+		for (i = 0; i < ctx->pb_count; i++) {
+			writel(buf_addr1, mfc_regs->e_luma_dpb + (4 * i));
+			buf_addr1 += ctx->luma_dpb_size;
+			buf_size1 -= ctx->luma_dpb_size;
+		}
+		for (i = 0; i < ctx->pb_count; i++) {
+			writel(buf_addr1, mfc_regs->e_chroma_dpb + (4 * i));
+			buf_addr1 += ctx->chroma_dpb_size;
+			buf_size1 -= ctx->chroma_dpb_size;
+		}
+		for (i = 0; i < ctx->pb_count; i++) {
+			writel(buf_addr1, mfc_regs->e_me_buffer + (4 * i));
+			buf_addr1 += ctx->me_buffer_size;
+			buf_size1 -= ctx->me_buffer_size;
+		}
+	} else {
+		for (i = 0; i < ctx->pb_count; i++) {
+			writel(buf_addr1, mfc_regs->e_luma_dpb + (4 * i));
+			buf_addr1 += ctx->luma_dpb_size;
+			writel(buf_addr1, mfc_regs->e_chroma_dpb + (4 * i));
+			buf_addr1 += ctx->chroma_dpb_size;
+			writel(buf_addr1, mfc_regs->e_me_buffer + (4 * i));
+			buf_addr1 += ctx->me_buffer_size;
+			buf_size1 -= (ctx->luma_dpb_size + ctx->chroma_dpb_size
+					+ ctx->me_buffer_size);
+		}
 	}
 
 	writel(buf_addr1, mfc_regs->e_scratch_buffer_addr);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
index 021b8db..975bbc5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -26,6 +26,8 @@
 					(((MB_HEIGHT(y)+1)/2)*2) * 64 + 128)
 #define S5P_MFC_DEC_MV_SIZE_V10(x, y)	(MB_WIDTH(x) * \
 					(((MB_HEIGHT(y)+1)/2)*2) * 64 + 512)
+#define enc_lcu_width(x_size)		DIV_ROUND_UP(x_size, 32)
+#define enc_lcu_height(y_size)		DIV_ROUND_UP(y_size, 32)
 
 /* Definition */
 #define ENC_MULTI_SLICE_MB_MAX		((1 << 30) - 1)
-- 
2.7.4
