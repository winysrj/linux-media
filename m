Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53768 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3FJNCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 09:02:24 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MO6008YPHJD1PP0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 22:02:23 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 4/6] [media] s5p-mfc: Update driver for v7 firmware
Date: Mon, 10 Jun 2013 18:53:04 +0530
Message-id: <1370870586-24141-5-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware version v7 is mostly similar to v6 in terms
of hardware specific controls and commands. So the hardware
specific opr_v6 and cmd_v6 are re-used for v7 also. This patch
updates the v6 files to handle v7 version also.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   12 ++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   53 +++++++++++++++++++----
 2 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2549967..13799a8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1662,8 +1662,16 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			*buf_count = 1;
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
-		psize[0] = ctx->luma_size;
-		psize[1] = ctx->chroma_size;
+
+		if (IS_MFCV7(dev)) {
+			/* MFCv7 needs pad bytes for input YUV */
+			psize[0] = ctx->luma_size + 256;
+			psize[1] = ctx->chroma_size + 128;
+		} else {
+			psize[0] = ctx->luma_size;
+			psize[1] = ctx->chroma_size;
+		}
+
 		if (IS_MFCV6(dev)) {
 			allocators[0] =
 				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 7d4c5e1..7145ae5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -80,6 +80,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
 			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V6(mb_width, mb_height),
 			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
+
 		ctx->luma_dpb_size = ALIGN((mb_width * mb_height) *
 				S5P_FIMV_LUMA_MB_TO_PIXEL_V6,
 				S5P_FIMV_LUMA_DPB_BUFFER_ALIGN_V6);
@@ -112,10 +113,18 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			(ctx->mv_count * ctx->mv_size);
 		break;
 	case S5P_MFC_CODEC_MPEG4_DEC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(
-					mb_width,
-					mb_height);
+		if (IS_MFCV7(dev)) {
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V7(
+						mb_width,
+						mb_height);
+		} else {
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(
+						mb_width,
+						mb_height);
+		}
+
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size = ctx->scratch_buf_size;
@@ -453,8 +462,13 @@ static void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6); /* 256B align */
-	WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
+	if (IS_MFCV7(dev)) {
+		WRITEL(y_addr, S5P_FIMV_E_SOURCE_FIRST_ADDR_V7);
+		WRITEL(c_addr, S5P_FIMV_E_SOURCE_SECOND_ADDR_V7);
+	} else {
+		WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6);
+		WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
+	}
 
 	mfc_debug(2, "enc src y buf addr: 0x%08lx\n", y_addr);
 	mfc_debug(2, "enc src c buf addr: 0x%08lx\n", c_addr);
@@ -466,8 +480,13 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long enc_recon_y_addr, enc_recon_c_addr;
 
-	*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6);
-	*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6);
+	if (IS_MFCV7(dev)) {
+		*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_FIRST_ADDR_V7);
+		*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_SECOND_ADDR_V7);
+	} else {
+		*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6);
+		*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6);
+	}
 
 	enc_recon_y_addr = READL(S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6);
 	enc_recon_c_addr = READL(S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6);
@@ -1166,6 +1185,12 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6);
 		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
 	}
+
+	if (IS_MFCV7(dev)) {
+		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+		reg = 0;
+	}
+
 	/* Setup loop filter, for decoding this is only valid for MPEG4 */
 	if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC) {
 		mfc_debug(2, "Set loop filter to: %d\n",
@@ -1176,7 +1201,10 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+	if (IS_MFCV7(dev))
+		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7);
+	else
+		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
 
 	/* 0: NV12(CbCr), 1: NV21(CrCb) */
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
@@ -1184,6 +1212,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	else
 		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
 
+
 	/* sei parse */
 	WRITEL(ctx->sei_fp_parse & 0x1, S5P_FIMV_D_SEI_ENABLE_V6);
 
@@ -1254,6 +1283,12 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 		return -EINVAL;
 	}
 
+	/* Set stride lengths */
+	if (IS_MFCV7(dev)) {
+		WRITEL(ctx->img_width, S5P_FIMV_E_SOURCE_FIRST_STRIDE_V7);
+		WRITEL(ctx->img_width, S5P_FIMV_E_SOURCE_SECOND_STRIDE_V7);
+	}
+
 	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
 	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
-- 
1.7.9.5

