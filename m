Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:21093 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753379AbdLHJhV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:37:21 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v6 09/12] [media] s5p-mfc: Add VP9 decoder support
Date: Fri, 08 Dec 2017 14:38:22 +0530
Message-id: <1512724105-1778-10-git-send-email-smitha.t@samsung.com>
In-reply-to: <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
References: <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
        <CGME20171208093659epcas2p1bef86171c1a76fba22dd93ee202fb2b6@epcas2p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for codec definition and corresponding buffer
requirements for VP9 decoder.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |  6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  7 +++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 26 +++++++++++++++++++++++++
 6 files changed, 45 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
index 953a073..6754477 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
@@ -18,6 +18,8 @@
 /* MFCv10 register definitions*/
 #define S5P_FIMV_MFC_CLOCK_OFF_V10			0x7120
 #define S5P_FIMV_MFC_STATE_V10				0x7124
+#define S5P_FIMV_D_STATIC_BUFFER_ADDR_V10		0xF570
+#define S5P_FIMV_D_STATIC_BUFFER_SIZE_V10		0xF574
 
 /* MFCv10 Context buffer sizes */
 #define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)
@@ -34,8 +36,12 @@
 
 /* MFCv10 codec defines*/
 #define S5P_FIMV_CODEC_HEVC_DEC		17
+#define S5P_FIMV_CODEC_VP9_DEC		18
 #define S5P_FIMV_CODEC_HEVC_ENC         26
 
+/* Decoder buffer size for MFC v10 */
+#define DEC_VP9_STATIC_BUFFER_SIZE	20480
+
 /* Encoder buffer size for MFC v10.0 */
 #define ENC_V100_BASE_SIZE(x, y) \
 	(((x + 3) * (y + 3) * 8) \
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index 76eca67..102b47e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -104,6 +104,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_HEVC_DEC:
 		codec_type = S5P_FIMV_CODEC_HEVC_DEC;
 		break;
+	case S5P_MFC_CODEC_VP9_DEC:
+		codec_type = S5P_FIMV_CODEC_VP9_DEC;
+		break;
 	case S5P_MFC_CODEC_H264_ENC:
 		codec_type = S5P_FIMV_CODEC_H264_ENC_V6;
 		break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 828e07e..b49f220 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -73,6 +73,7 @@
 #define S5P_MFC_CODEC_VC1RCV_DEC	6
 #define S5P_MFC_CODEC_VP8_DEC		7
 #define S5P_MFC_CODEC_HEVC_DEC		17
+#define S5P_MFC_CODEC_VP9_DEC		18
 
 #define S5P_MFC_CODEC_H264_ENC		20
 #define S5P_MFC_CODEC_H264_MVC_ENC	21
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4749355..5cf4d99 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -151,6 +151,13 @@ static struct s5p_mfc_fmt formats[] = {
 		.num_planes	= 1,
 		.versions	= MFC_V10_BIT,
 	},
+	{
+		.fourcc		= V4L2_PIX_FMT_VP9,
+		.codec_mode	= S5P_FIMV_CODEC_VP9_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
+		.versions	= MFC_V10_BIT,
+	},
 };
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index e7a2d46..57f4560 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -170,6 +170,8 @@ struct s5p_mfc_regs {
 	void __iomem *d_used_dpb_flag_upper;/* v7 and v8 */
 	void __iomem *d_used_dpb_flag_lower;/* v7 and v8 */
 	void __iomem *d_min_scratch_buffer_size; /* v10 */
+	void __iomem *d_static_buffer_addr; /* v10 */
+	void __iomem *d_static_buffer_size; /* v10 */
 
 	/* encoder registers */
 	void __iomem *e_frame_width;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 8c47294..f47612c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -226,6 +226,12 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			ctx->scratch_buf_size +
 			(ctx->mv_count * ctx->mv_size);
 		break;
+	case S5P_MFC_CODEC_VP9_DEC:
+		mfc_debug(2, "Use min scratch buffer size\n");
+		ctx->bank1.size =
+			ctx->scratch_buf_size +
+			DEC_VP9_STATIC_BUFFER_SIZE;
+		break;
 	case S5P_MFC_CODEC_H264_ENC:
 		if (IS_MFCV10(dev)) {
 			mfc_debug(2, "Use min scratch buffer size\n");
@@ -336,6 +342,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 	case S5P_MFC_CODEC_VC1_DEC:
 	case S5P_MFC_CODEC_MPEG2_DEC:
 	case S5P_MFC_CODEC_VP8_DEC:
+	case S5P_MFC_CODEC_VP9_DEC:
 		ctx->ctx.size = buf_size->other_dec_ctx;
 		break;
 	case S5P_MFC_CODEC_H264_ENC:
@@ -566,6 +573,13 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 			buf_size1 -= frame_size_mv;
 		}
 	}
+	if (ctx->codec_mode == S5P_FIMV_CODEC_VP9_DEC) {
+		writel(buf_addr1, mfc_regs->d_static_buffer_addr);
+		writel(DEC_VP9_STATIC_BUFFER_SIZE,
+				mfc_regs->d_static_buffer_size);
+		buf_addr1 += DEC_VP9_STATIC_BUFFER_SIZE;
+		buf_size1 -= DEC_VP9_STATIC_BUFFER_SIZE;
+	}
 
 	mfc_debug(2, "Buf1: %zx, buf_size1: %d (frames %d)\n",
 			buf_addr1, buf_size1, ctx->total_dpb_count);
@@ -2272,6 +2286,18 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(e_h264_options, S5P_FIMV_E_H264_OPTIONS_V8);
 	R(e_min_scratch_buffer_size, S5P_FIMV_E_MIN_SCRATCH_BUFFER_SIZE_V8);
 
+	if (!IS_MFCV10(dev))
+		goto done;
+
+	/* Initialize registers used in MFC v10 only.
+	 * Also, over-write the registers which have
+	 * a different offset for MFC v10.
+	 */
+
+	/* decoder registers */
+	R(d_static_buffer_addr, S5P_FIMV_D_STATIC_BUFFER_ADDR_V10);
+	R(d_static_buffer_size, S5P_FIMV_D_STATIC_BUFFER_SIZE_V10);
+
 done:
 	return &mfc_regs;
 #undef S5P_MFC_REG_ADDR
-- 
2.7.4
