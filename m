Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:11579 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933337AbeAXLXf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 06:23:35 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v7 03/12] [media] s5p-mfc: Use min scratch buffer size as
 provided by F/W
Date: Wed, 24 Jan 2018 16:29:35 +0530
Message-id: <1516791584-7980-4-git-send-email-smitha.t@samsung.com>
In-reply-to: <1516791584-7980-1-git-send-email-smitha.t@samsung.com>
References: <1516791584-7980-1-git-send-email-smitha.t@samsung.com>
        <CGME20180124112332epcas2p1dbc1ec3e76a21193c6524e614a448092@epcas2p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After MFC v8.0, mfc f/w lets the driver know how much scratch buffer
size is required for decoder. If mfc f/w has the functionality,
E_MIN_SCRATCH_BUFFER_SIZE, driver can know how much scratch buffer size
is required for encoder too.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h    |  2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  5 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  4 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 68 ++++++++++++++++++-------
 6 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
index 75f5f75..bd639ae 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
@@ -17,6 +17,7 @@
 
 /* Additional registers for v8 */
 #define S5P_FIMV_D_MVC_NUM_VIEWS_V8		0xf104
+#define S5P_FIMV_D_MIN_SCRATCH_BUFFER_SIZE_V8	0xf108
 #define S5P_FIMV_D_FIRST_PLANE_DPB_SIZE_V8	0xf144
 #define S5P_FIMV_D_SECOND_PLANE_DPB_SIZE_V8	0xf148
 #define S5P_FIMV_D_MV_BUFFER_SIZE_V8		0xf150
@@ -84,6 +85,7 @@
 
 #define S5P_FIMV_E_VBV_BUFFER_SIZE_V8		0xf78c
 #define S5P_FIMV_E_VBV_INIT_DELAY_V8		0xf790
+#define S5P_FIMV_E_MIN_SCRATCH_BUFFER_SIZE_V8   0xf894
 
 #define S5P_FIMV_E_ASPECT_RATIO_V8		0xfb4c
 #define S5P_FIMV_E_EXTENDED_SAR_V8		0xfb50
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index afa5ce5..461635c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -526,6 +526,8 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 				dev);
 		ctx->mv_count = s5p_mfc_hw_call(dev->mfc_ops, get_mv_count,
 				dev);
+		ctx->scratch_buf_size = s5p_mfc_hw_call(dev->mfc_ops,
+						get_min_scratch_buf_size, dev);
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
 		else
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index c4f0968..babc1cc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -716,6 +716,7 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 #define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
 #define IS_MFCV8_PLUS(dev)	(dev->variant->version >= 0x80 ? 1 : 0)
 #define IS_MFCV10(dev)		(dev->variant->version >= 0xA0 ? 1 : 0)
+#define FW_HAS_E_MIN_SCRATCH_BUF(dev) (IS_MFCV10(dev))
 
 #define MFC_V5_BIT	BIT(0)
 #define MFC_V6_BIT	BIT(1)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 9a21e8c..a846a4d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -813,6 +813,11 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 				get_enc_dpb_count, dev);
 		if (ctx->pb_count < enc_pb_count)
 			ctx->pb_count = enc_pb_count;
+		if (FW_HAS_E_MIN_SCRATCH_BUF(dev)) {
+			ctx->scratch_buf_size = s5p_mfc_hw_call(dev->mfc_ops,
+					get_e_min_scratch_buf_size, dev);
+			ctx->bank1.size += ctx->scratch_buf_size;
+		}
 		ctx->state = MFCINST_HEAD_PRODUCED;
 	}
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 16d553f..e7a2d46 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -169,6 +169,7 @@ struct s5p_mfc_regs {
 	void __iomem *d_decoded_third_addr;/* only v7 */
 	void __iomem *d_used_dpb_flag_upper;/* v7 and v8 */
 	void __iomem *d_used_dpb_flag_lower;/* v7 and v8 */
+	void __iomem *d_min_scratch_buffer_size; /* v10 */
 
 	/* encoder registers */
 	void __iomem *e_frame_width;
@@ -268,6 +269,7 @@ struct s5p_mfc_regs {
 	void __iomem *e_vp8_hierarchical_qp_layer0;/* v7 and v8 */
 	void __iomem *e_vp8_hierarchical_qp_layer1;/* v7 and v8 */
 	void __iomem *e_vp8_hierarchical_qp_layer2;/* v7 and v8 */
+	void __iomem *e_min_scratch_buffer_size; /* v10 */
 };
 
 struct s5p_mfc_hw_ops {
@@ -311,6 +313,8 @@ struct s5p_mfc_hw_ops {
 	unsigned int (*get_pic_type_bot)(struct s5p_mfc_ctx *ctx);
 	unsigned int (*get_crop_info_h)(struct s5p_mfc_ctx *ctx);
 	unsigned int (*get_crop_info_v)(struct s5p_mfc_ctx *ctx);
+	int (*get_min_scratch_buf_size)(struct s5p_mfc_dev *dev);
+	int (*get_e_min_scratch_buf_size)(struct s5p_mfc_dev *dev);
 };
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 2041d81..7f17857 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -110,7 +110,9 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 	switch (ctx->codec_mode) {
 	case S5P_MFC_CODEC_H264_DEC:
 	case S5P_MFC_CODEC_H264_MVC_DEC:
-		if (IS_MFCV8_PLUS(dev))
+		if (IS_MFCV10(dev))
+			mfc_debug(2, "Use min scratch buffer size\n");
+		else if (IS_MFCV8_PLUS(dev))
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V8(
 					mb_width,
@@ -127,7 +129,9 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 			(ctx->mv_count * ctx->mv_size);
 		break;
 	case S5P_MFC_CODEC_MPEG4_DEC:
-		if (IS_MFCV7_PLUS(dev)) {
+		if (IS_MFCV10(dev))
+			mfc_debug(2, "Use min scratch buffer size\n");
+		else if (IS_MFCV7_PLUS(dev)) {
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V7(
 						mb_width,
@@ -145,10 +149,14 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	case S5P_MFC_CODEC_VC1RCV_DEC:
 	case S5P_MFC_CODEC_VC1_DEC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(
-					mb_width,
-					mb_height);
+		if (IS_MFCV10(dev))
+			mfc_debug(2, "Use min scratch buffer size\n");
+		else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(
+						mb_width,
+						mb_height);
+
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size = ctx->scratch_buf_size;
@@ -158,16 +166,21 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_H263_DEC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(
-					mb_width,
-					mb_height);
+		if (IS_MFCV10(dev))
+			mfc_debug(2, "Use min scratch buffer size\n");
+		else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(
+						mb_width,
+						mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_VP8_DEC:
-		if (IS_MFCV8_PLUS(dev))
+		if (IS_MFCV10(dev))
+			mfc_debug(2, "Use min scratch buffer size\n");
+		else if (IS_MFCV8_PLUS(dev))
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V8(
 						mb_width,
@@ -182,7 +195,9 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_H264_ENC:
-		if (IS_MFCV8_PLUS(dev))
+		if (IS_MFCV10(dev)) {
+			mfc_debug(2, "Use min scratch buffer size\n");
+		} else if (IS_MFCV8_PLUS(dev))
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V8(
 					mb_width,
@@ -202,10 +217,13 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
 	case S5P_MFC_CODEC_H263_ENC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(
-					mb_width,
-					mb_height);
+		if (IS_MFCV10(dev)) {
+			mfc_debug(2, "Use min scratch buffer size\n");
+		} else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(
+						mb_width,
+						mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size =
@@ -215,7 +233,9 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_VP8_ENC:
-		if (IS_MFCV8_PLUS(dev))
+		if (IS_MFCV10(dev)) {
+			mfc_debug(2, "Use min scratch buffer size\n");
+		} else if (IS_MFCV8_PLUS(dev))
 			ctx->scratch_buf_size =
 				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V8(
 					mb_width,
@@ -1900,6 +1920,16 @@ static int s5p_mfc_get_mv_count_v6(struct s5p_mfc_dev *dev)
 	return readl(dev->mfc_regs->d_min_num_mv);
 }
 
+static int s5p_mfc_get_min_scratch_buf_size(struct s5p_mfc_dev *dev)
+{
+	return readl(dev->mfc_regs->d_min_scratch_buffer_size);
+}
+
+static int s5p_mfc_get_e_min_scratch_buf_size(struct s5p_mfc_dev *dev)
+{
+	return readl(dev->mfc_regs->e_min_scratch_buffer_size);
+}
+
 static int s5p_mfc_get_inst_no_v6(struct s5p_mfc_dev *dev)
 {
 	return readl(dev->mfc_regs->ret_instance_id);
@@ -2158,6 +2188,7 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(d_ret_picture_tag_bot, S5P_FIMV_D_RET_PICTURE_TAG_BOT_V8);
 	R(d_display_crop_info1, S5P_FIMV_D_DISPLAY_CROP_INFO1_V8);
 	R(d_display_crop_info2, S5P_FIMV_D_DISPLAY_CROP_INFO2_V8);
+	R(d_min_scratch_buffer_size, S5P_FIMV_D_MIN_SCRATCH_BUFFER_SIZE_V8);
 
 	/* encoder registers */
 	R(e_padding_ctrl, S5P_FIMV_E_PADDING_CTRL_V8);
@@ -2173,6 +2204,7 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	R(e_aspect_ratio, S5P_FIMV_E_ASPECT_RATIO_V8);
 	R(e_extended_sar, S5P_FIMV_E_EXTENDED_SAR_V8);
 	R(e_h264_options, S5P_FIMV_E_H264_OPTIONS_V8);
+	R(e_min_scratch_buffer_size, S5P_FIMV_E_MIN_SCRATCH_BUFFER_SIZE_V8);
 
 done:
 	return &mfc_regs;
@@ -2221,6 +2253,8 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
 	.get_pic_type_bot = s5p_mfc_get_pic_type_bot_v6,
 	.get_crop_info_h = s5p_mfc_get_crop_info_h_v6,
 	.get_crop_info_v = s5p_mfc_get_crop_info_v_v6,
+	.get_min_scratch_buf_size = s5p_mfc_get_min_scratch_buf_size,
+	.get_e_min_scratch_buf_size = s5p_mfc_get_e_min_scratch_buf_size,
 };
 
 struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void)
-- 
2.7.4
