Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3GIFBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 01:01:45 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MPN00HAEKLEDNI0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Jul 2013 14:01:38 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v5 5/8] [media] s5p-mfc: Update driver for v7 firmware
Date: Tue, 09 Jul 2013 10:54:39 +0530
Message-id: <1373347482-9264-6-git-send-email-arun.kk@samsung.com>
In-reply-to: <1373347482-9264-1-git-send-email-arun.kk@samsung.com>
References: <1373347482-9264-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware version v7 is mostly similar to v6 in terms
of hardware specific controls and commands. So the hardware
specific opr_v6 and cmd_v6 are re-used for v7 also. This patch
updates the v6 files to handle v7 version also.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |    3 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   59 +++++++++++++++++++----
 3 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
index 24dba69..ea5ec2a 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
@@ -41,6 +41,9 @@
 #define MFC_VERSION_V7			0x72
 #define MFC_NUM_PORTS_V7		1
 
+#define MFC_LUMA_PAD_BYTES_V7		256
+#define MFC_CHROMA_PAD_BYTES_V7		128
+
 /* MFCv7 Context buffer sizes */
 #define MFC_CTX_BUF_SIZE_V7		(30 * SZ_1K)	/*  30KB */
 #define MFC_H264_DEC_CTX_BUF_SIZE_V7	(2 * SZ_1M)	/*  2MB */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index f734ccc..6dafe96 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1665,6 +1665,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
+
 		if (IS_MFCV6_PLUS(dev)) {
 			allocators[0] =
 				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 7d4c5e1..3440317 100644
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
@@ -329,6 +338,12 @@ static void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
 	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN_V6);
 	ctx->luma_size = ALIGN((mb_width * mb_height) * 256, 256);
 	ctx->chroma_size = ALIGN((mb_width * mb_height) * 128, 256);
+
+	/* MFCv7 needs pad bytes for Luma and Chroma */
+	if (IS_MFCV7(ctx->dev)) {
+		ctx->luma_size += MFC_LUMA_PAD_BYTES_V7;
+		ctx->chroma_size += MFC_CHROMA_PAD_BYTES_V7;
+	}
 }
 
 /* Set registers for decoding stream buffer */
@@ -453,8 +468,13 @@ static void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
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
@@ -466,8 +486,13 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
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
@@ -1166,6 +1191,12 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
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
@@ -1176,7 +1207,10 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+	if (IS_MFCV7(dev))
+		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7);
+	else
+		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
 
 	/* 0: NV12(CbCr), 1: NV21(CrCb) */
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
@@ -1184,6 +1218,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	else
 		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
 
+
 	/* sei parse */
 	WRITEL(ctx->sei_fp_parse & 0x1, S5P_FIMV_D_SEI_ENABLE_V6);
 
@@ -1254,6 +1289,12 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
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

