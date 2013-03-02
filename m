Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45541 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3CBMAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 07:00:46 -0500
Received: by mail-pa0-f42.google.com with SMTP id kq12so2311914pab.15
        for <linux-media@vger.kernel.org>; Sat, 02 Mar 2013 04:00:45 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, sachin.kamat@linaro.org, patches@linaro.org,
	s.nawrocki@samsung.com
Subject: [PATCH 3/3] [media] s5p-mfc: Staticize symbols in s5p_mfc_opr_v5.c
Date: Sat,  2 Mar 2013 17:20:14 +0530
Message-Id: <1362225014-31760-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1362225014-31760-1-git-send-email-sachin.kamat@linaro.org>
References: <1362225014-31760-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some symbols are used only in this file. Make them static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  103 ++++++++++++-----------
 1 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index f61dba8..c7ad329 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -34,7 +34,7 @@
 #define OFFSETB(x)		(((x) - dev->bank2) >> MFC_OFFSET_SHIFT)
 
 /* Allocate temporary buffers for decoding */
-int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
@@ -55,13 +55,13 @@ int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 
 
 /* Release temporary buffers for decoding */
-void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->dsc);
 }
 
 /* Allocate codec buffers */
-int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int enc_ref_y_size = 0;
@@ -193,14 +193,14 @@ int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release buffers allocated for codec */
-void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_r, &ctx->bank2);
 }
 
 /* Allocate memory for instance data buffer */
-int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
@@ -241,20 +241,20 @@ int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release instance buffer */
-void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->ctx);
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->shm);
 }
 
-int s5p_mfc_alloc_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_alloc_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
 {
 	/* NOP */
 
 	return 0;
 }
 
-void s5p_mfc_release_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
+static void s5p_mfc_release_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
 {
 	/* NOP */
 }
@@ -273,7 +273,7 @@ static unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
 	return readl(ctx->shm.virt + ofs);
 }
 
-void s5p_mfc_dec_calc_dpb_size_v5(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_dec_calc_dpb_size_v5(struct s5p_mfc_ctx *ctx)
 {
 	unsigned int guard_width, guard_height;
 
@@ -315,7 +315,7 @@ void s5p_mfc_dec_calc_dpb_size_v5(struct s5p_mfc_ctx *ctx)
 	}
 }
 
-void s5p_mfc_enc_calc_src_size_v5(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_enc_calc_src_size_v5(struct s5p_mfc_ctx *ctx)
 {
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
 		ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN);
@@ -361,8 +361,9 @@ static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for decoding stream buffer */
-int s5p_mfc_set_dec_stream_buffer_v5(struct s5p_mfc_ctx *ctx, int buf_addr,
-		  unsigned int start_num_byte, unsigned int buf_size)
+static int s5p_mfc_set_dec_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
+		int buf_addr, unsigned int start_num_byte,
+		unsigned int buf_size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
@@ -374,7 +375,7 @@ int s5p_mfc_set_dec_stream_buffer_v5(struct s5p_mfc_ctx *ctx, int buf_addr,
 }
 
 /* Set decoding frame buffer */
-int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	unsigned int frame_size, i;
 	unsigned int frame_size_ch, frame_size_mv;
@@ -506,7 +507,7 @@ int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for encoding stream buffer */
-int s5p_mfc_set_enc_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
+static int s5p_mfc_set_enc_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
 		unsigned long addr, unsigned int size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -516,7 +517,7 @@ int s5p_mfc_set_enc_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
 	return 0;
 }
 
-void s5p_mfc_set_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
+static void s5p_mfc_set_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 		unsigned long y_addr, unsigned long c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -525,7 +526,7 @@ void s5p_mfc_set_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 	mfc_write(dev, OFFSETB(c_addr), S5P_FIMV_ENC_SI_CH0_CUR_C_ADR);
 }
 
-void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
+static void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 		unsigned long *y_addr, unsigned long *c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -537,7 +538,7 @@ void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 }
 
 /* Set encoding ref & codec buffer */
-int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	size_t buf_addr1, buf_addr2;
@@ -1041,7 +1042,7 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 }
 
 /* Initialize decoding */
-int s5p_mfc_init_decode_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_init_decode_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
@@ -1077,7 +1078,7 @@ static void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 }
 
 /* Decode a single frame */
-int s5p_mfc_decode_one_frame_v5(struct s5p_mfc_ctx *ctx,
+static int s5p_mfc_decode_one_frame_v5(struct s5p_mfc_ctx *ctx,
 					enum s5p_mfc_decode_arg last_frame)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -1106,7 +1107,7 @@ int s5p_mfc_decode_one_frame_v5(struct s5p_mfc_ctx *ctx,
 	return 0;
 }
 
-int s5p_mfc_init_encode_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_init_encode_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
@@ -1128,7 +1129,7 @@ int s5p_mfc_init_encode_v5(struct s5p_mfc_ctx *ctx)
 }
 
 /* Encode a single frame */
-int s5p_mfc_encode_one_frame_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_encode_one_frame_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	int cmd;
@@ -1353,7 +1354,7 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 }
 
 /* Try running an operation on hardware */
-void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
+static void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_ctx *ctx;
 	int new_ctx;
@@ -1469,7 +1470,7 @@ void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 }
 
 
-void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
+static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 {
 	struct s5p_mfc_buf *b;
 	int i;
@@ -1483,52 +1484,52 @@ void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 	}
 }
 
-void s5p_mfc_clear_int_flags_v5(struct s5p_mfc_dev *dev)
+static void s5p_mfc_clear_int_flags_v5(struct s5p_mfc_dev *dev)
 {
 	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
 	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
 	mfc_write(dev, 0xffff, S5P_FIMV_SI_RTN_CHID);
 }
 
-int s5p_mfc_get_dspl_y_adr_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dspl_y_adr_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_DISPLAY_Y_ADR) << MFC_OFFSET_SHIFT;
 }
 
-int s5p_mfc_get_dec_y_adr_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_y_adr_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_DECODE_Y_ADR) << MFC_OFFSET_SHIFT;
 }
 
-int s5p_mfc_get_dspl_status_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dspl_status_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_DISPLAY_STATUS);
 }
 
-int s5p_mfc_get_dec_status_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_status_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_DECODE_STATUS);
 }
 
-int s5p_mfc_get_dec_frame_type_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_frame_type_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_DECODE_FRAME_TYPE) &
 		S5P_FIMV_DECODE_FRAME_MASK;
 }
 
-int s5p_mfc_get_disp_frame_type_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_get_disp_frame_type_v5(struct s5p_mfc_ctx *ctx)
 {
 	return (s5p_mfc_read_info_v5(ctx, DISP_PIC_FRAME_TYPE) >>
 			S5P_FIMV_SHARED_DISP_FRAME_TYPE_SHIFT) &
 			S5P_FIMV_DECODE_FRAME_MASK;
 }
 
-int s5p_mfc_get_consumed_stream_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_consumed_stream_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_CONSUMED_BYTES);
 }
 
-int s5p_mfc_get_int_reason_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_int_reason_v5(struct s5p_mfc_dev *dev)
 {
 	int reason;
 	reason = mfc_read(dev, S5P_FIMV_RISC2HOST_CMD) &
@@ -1576,98 +1577,98 @@ int s5p_mfc_get_int_reason_v5(struct s5p_mfc_dev *dev)
 	return reason;
 }
 
-int s5p_mfc_get_int_err_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_int_err_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_RISC2HOST_ARG2);
 }
 
-int s5p_mfc_err_dec_v5(unsigned int err)
+static int s5p_mfc_err_dec_v5(unsigned int err)
 {
 	return (err & S5P_FIMV_ERR_DEC_MASK) >> S5P_FIMV_ERR_DEC_SHIFT;
 }
 
-int s5p_mfc_err_dspl_v5(unsigned int err)
+static int s5p_mfc_err_dspl_v5(unsigned int err)
 {
 	return (err & S5P_FIMV_ERR_DSPL_MASK) >> S5P_FIMV_ERR_DSPL_SHIFT;
 }
 
-int s5p_mfc_get_img_width_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_img_width_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_HRESOL);
 }
 
-int s5p_mfc_get_img_height_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_img_height_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_VRESOL);
 }
 
-int s5p_mfc_get_dpb_count_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dpb_count_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_BUF_NUMBER);
 }
 
-int s5p_mfc_get_mv_count_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_mv_count_v5(struct s5p_mfc_dev *dev)
 {
 	/* NOP */
 	return -1;
 }
 
-int s5p_mfc_get_inst_no_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_inst_no_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_RISC2HOST_ARG1);
 }
 
-int s5p_mfc_get_enc_strm_size_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_strm_size_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_ENC_SI_STRM_SIZE);
 }
 
-int s5p_mfc_get_enc_slice_type_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_slice_type_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_ENC_SI_SLICE_TYPE);
 }
 
-int s5p_mfc_get_enc_dpb_count_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_dpb_count_v5(struct s5p_mfc_dev *dev)
 {
 	return -1;
 }
 
-int s5p_mfc_get_enc_pic_count_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_pic_count_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT);
 }
 
-int s5p_mfc_get_sei_avail_status_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_get_sei_avail_status_v5(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v5(ctx, FRAME_PACK_SEI_AVAIL);
 }
 
-int s5p_mfc_get_mvc_num_views_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_mvc_num_views_v5(struct s5p_mfc_dev *dev)
 {
 	return -1;
 }
 
-int s5p_mfc_get_mvc_view_id_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_mvc_view_id_v5(struct s5p_mfc_dev *dev)
 {
 	return -1;
 }
 
-unsigned int s5p_mfc_get_pic_type_top_v5(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_pic_type_top_v5(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v5(ctx, PIC_TIME_TOP);
 }
 
-unsigned int s5p_mfc_get_pic_type_bot_v5(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_pic_type_bot_v5(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v5(ctx, PIC_TIME_BOT);
 }
 
-unsigned int s5p_mfc_get_crop_info_h_v5(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_crop_info_h_v5(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v5(ctx, CROP_INFO_H);
 }
 
-unsigned int s5p_mfc_get_crop_info_v_v5(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_crop_info_v_v5(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v5(ctx, CROP_INFO_V);
 }
-- 
1.7.4.1

