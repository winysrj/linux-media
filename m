Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43559 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753468AbdFSFZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 01:25:19 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v5 08/12] [media] s5p-mfc: Add support for HEVC decoder
Date: Mon, 19 Jun 2017 10:40:51 +0530
Message-id: <1497849055-26583-9-git-send-email-smitha.t@samsung.com>
In-reply-to: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052511epcas1p4e79efd3c9f0f8062eeac1ab4884b709e@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for codec definition and corresponding buffer
requirements for HEVC decoder.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  7 +++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 17 +++++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |  3 +++
 6 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
index 3f0dab3..953a073 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
@@ -33,6 +33,7 @@
 #define MFC_NUM_PORTS_V10	1
 
 /* MFCv10 codec defines*/
+#define S5P_FIMV_CODEC_HEVC_DEC		17
 #define S5P_FIMV_CODEC_HEVC_ENC         26
 
 /* Encoder buffer size for MFC v10.0 */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index b1b1491..76eca67 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -101,6 +101,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_VP8_DEC:
 		codec_type = S5P_FIMV_CODEC_VP8_DEC_V6;
 		break;
+	case S5P_MFC_CODEC_HEVC_DEC:
+		codec_type = S5P_FIMV_CODEC_HEVC_DEC;
+		break;
 	case S5P_MFC_CODEC_H264_ENC:
 		codec_type = S5P_FIMV_CODEC_H264_ENC_V6;
 		break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index e65e1c3..828e07e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -72,6 +72,7 @@
 #define S5P_MFC_CODEC_H263_DEC		5
 #define S5P_MFC_CODEC_VC1RCV_DEC	6
 #define S5P_MFC_CODEC_VP8_DEC		7
+#define S5P_MFC_CODEC_HEVC_DEC		17
 
 #define S5P_MFC_CODEC_H264_ENC		20
 #define S5P_MFC_CODEC_H264_MVC_ENC	21
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 81de3029..4749355 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -144,6 +144,13 @@ static struct s5p_mfc_fmt formats[] = {
 		.num_planes	= 1,
 		.versions	= MFC_V6PLUS_BITS,
 	},
+	{
+		.fourcc		= V4L2_PIX_FMT_HEVC,
+		.codec_mode	= S5P_FIMV_CODEC_HEVC_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
+		.versions	= MFC_V10_BIT,
+	},
 };
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 83ea733..ed725db 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -220,6 +220,12 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
+	case S5P_MFC_CODEC_HEVC_DEC:
+		mfc_debug(2, "Use min scratch buffer size\n");
+		ctx->bank1.size =
+			ctx->scratch_buf_size +
+			(ctx->mv_count * ctx->mv_size);
+		break;
 	case S5P_MFC_CODEC_H264_ENC:
 		if (IS_MFCV10(dev)) {
 			mfc_debug(2, "Use min scratch buffer size\n");
@@ -321,6 +327,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 	switch (ctx->codec_mode) {
 	case S5P_MFC_CODEC_H264_DEC:
 	case S5P_MFC_CODEC_H264_MVC_DEC:
+	case S5P_MFC_CODEC_HEVC_DEC:
 		ctx->ctx.size = buf_size->h264_dec_ctx;
 		break;
 	case S5P_MFC_CODEC_MPEG4_DEC:
@@ -434,6 +441,10 @@ static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 			ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V6(ctx->img_width,
 					ctx->img_height);
 		}
+	} else if (ctx->codec_mode == S5P_MFC_CODEC_HEVC_DEC) {
+		ctx->mv_size = s5p_mfc_dec_hevc_mv_size(ctx->img_width,
+				ctx->img_height);
+		ctx->mv_size = ALIGN(ctx->mv_size, 32);
 	} else {
 		ctx->mv_size = 0;
 	}
@@ -515,7 +526,8 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 	buf_size1 -= ctx->scratch_buf_size;
 
 	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
-			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC){
+			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC ||
+			ctx->codec_mode == S5P_FIMV_CODEC_HEVC_DEC) {
 		writel(ctx->mv_size, mfc_regs->d_mv_buffer_size);
 		writel(ctx->mv_count, mfc_regs->d_num_mv);
 	}
@@ -538,7 +550,8 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 				mfc_regs->d_second_plane_dpb + i * 4);
 	}
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
-			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
+			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC ||
+			ctx->codec_mode == S5P_MFC_CODEC_HEVC_DEC) {
 		for (i = 0; i < ctx->mv_count; i++) {
 			/* To test alignment */
 			align_gap = buf_addr1;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
index 975bbc5..2290f7e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -29,6 +29,9 @@
 #define enc_lcu_width(x_size)		DIV_ROUND_UP(x_size, 32)
 #define enc_lcu_height(y_size)		DIV_ROUND_UP(y_size, 32)
 
+#define s5p_mfc_dec_hevc_mv_size(x, y) \
+	(DIV_ROUND_UP(x, 64) * DIV_ROUND_UP(y, 64) * 256 + 512)
+
 /* Definition */
 #define ENC_MULTI_SLICE_MB_MAX		((1 << 30) - 1)
 #define ENC_MULTI_SLICE_BIT_MIN		2800
-- 
2.7.4
