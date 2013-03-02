Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48681 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3CBMAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 07:00:43 -0500
Received: by mail-pb0-f44.google.com with SMTP id wz12so2235163pbc.31
        for <linux-media@vger.kernel.org>; Sat, 02 Mar 2013 04:00:42 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, sachin.kamat@linaro.org, patches@linaro.org,
	s.nawrocki@samsung.com
Subject: [PATCH 2/3] [media] s5p-mfc: Staticize symbols in s5p_mfc_opr_v6.c
Date: Sat,  2 Mar 2013 17:20:13 +0530
Message-Id: <1362225014-31760-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1362225014-31760-1-git-send-email-sachin.kamat@linaro.org>
References: <1362225014-31760-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Symbols used only in this file should be made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  112 ++++++++++++-----------
 1 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index beb6dba..33de88b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -49,7 +49,7 @@
 #define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
 
 /* Allocate temporary buffers for decoding */
-int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
 	/* NOP */
 
@@ -57,19 +57,19 @@ int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release temproary buffers for decoding */
-void s5p_mfc_release_dec_desc_buffer_v6(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_release_dec_desc_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	/* NOP */
 }
 
-int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
 {
 	/* NOP */
 	return -1;
 }
 
 /* Allocate codec buffers */
-int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int mb_width, mb_height;
@@ -203,13 +203,13 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release buffers allocated for codec */
-void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
 }
 
 /* Allocate memory for instance data buffer */
-int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
@@ -258,13 +258,13 @@ int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release instance buffer */
-void s5p_mfc_release_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_release_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->ctx);
 }
 
 /* Allocate context buffers for SYS_INIT */
-int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
 	int ret;
@@ -287,7 +287,7 @@ int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 }
 
 /* Release context buffers for SYS_INIT */
-void s5p_mfc_release_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
+static void s5p_mfc_release_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 {
 	s5p_mfc_release_priv_buf(dev->mem_dev_l, &dev->ctx_buf);
 }
@@ -306,7 +306,7 @@ static int calc_plane(int width, int height)
 		(mbY * S5P_FIMV_NUM_PIXELS_IN_MB_ROW_V6);
 }
 
-void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 {
 	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN_V6);
 	ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN_V6);
@@ -326,7 +326,7 @@ void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 	}
 }
 
-void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
 {
 	unsigned int mb_width, mb_height;
 
@@ -339,8 +339,9 @@ void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for decoding stream buffer */
-int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx, int buf_addr,
-		  unsigned int start_num_byte, unsigned int strm_size)
+static int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
+			int buf_addr, unsigned int start_num_byte,
+			unsigned int strm_size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
@@ -359,7 +360,7 @@ int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx, int buf_addr,
 }
 
 /* Set decoding frame buffer */
-int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	unsigned int frame_size, i;
 	unsigned int frame_size_ch, frame_size_mv;
@@ -440,7 +441,7 @@ int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for encoding stream buffer */
-int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
+static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 		unsigned long addr, unsigned int size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -454,7 +455,7 @@ int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	return 0;
 }
 
-void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
+static void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 		unsigned long y_addr, unsigned long c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -466,7 +467,7 @@ void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	mfc_debug(2, "enc src c buf addr: 0x%08lx", c_addr);
 }
 
-void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
+static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 		unsigned long *y_addr, unsigned long *c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -483,7 +484,7 @@ void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 }
 
 /* Set encoding ref & codec buffer */
-int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	size_t buf_addr1;
@@ -1147,7 +1148,7 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 }
 
 /* Initialize decoding */
-int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int reg = 0;
@@ -1215,7 +1216,7 @@ static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 }
 
 /* Decode a single frame */
-int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
+static int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
 			enum s5p_mfc_decode_arg last_frame)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -1244,7 +1245,7 @@ int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
 	return 0;
 }
 
-int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
@@ -1267,7 +1268,7 @@ int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
-int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
@@ -1283,7 +1284,7 @@ int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Encode a single frame */
-int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
@@ -1540,7 +1541,7 @@ static inline int s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
 }
 
 /* Try running an operation on hardware */
-void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
+static void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_ctx *ctx;
 	int new_ctx;
@@ -1663,7 +1664,7 @@ void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 }
 
 
-void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
+static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 {
 	struct s5p_mfc_buf *b;
 	int i;
@@ -1677,13 +1678,13 @@ void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 	}
 }
 
-void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
+static void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
 {
 	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD_V6);
 	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_INT_V6);
 }
 
-void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
+static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 		unsigned int ofs)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -1693,7 +1694,8 @@ void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 	s5p_mfc_clock_off();
 }
 
-unsigned int s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
+static unsigned int
+s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	int ret;
@@ -1705,140 +1707,140 @@ unsigned int s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 	return ret;
 }
 
-int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
 }
 
-int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DECODED_LUMA_ADDR_V6);
 }
 
-int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DISPLAY_STATUS_V6);
 }
 
-int s5p_mfc_get_decoded_status_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_decoded_status_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DECODED_STATUS_V6);
 }
 
-int s5p_mfc_get_dec_frame_type_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_frame_type_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DECODED_FRAME_TYPE_V6) &
 		S5P_FIMV_DECODE_FRAME_MASK_V6;
 }
 
-int s5p_mfc_get_disp_frame_type_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_get_disp_frame_type_v6(struct s5p_mfc_ctx *ctx)
 {
 	return mfc_read(ctx->dev, S5P_FIMV_D_DISPLAY_FRAME_TYPE_V6) &
 		S5P_FIMV_DECODE_FRAME_MASK_V6;
 }
 
-int s5p_mfc_get_consumed_stream_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_consumed_stream_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DECODED_NAL_SIZE_V6);
 }
 
-int s5p_mfc_get_int_reason_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_int_reason_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_RISC2HOST_CMD_V6) &
 		S5P_FIMV_RISC2HOST_CMD_MASK;
 }
 
-int s5p_mfc_get_int_err_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_int_err_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_ERROR_CODE_V6);
 }
 
-int s5p_mfc_err_dec_v6(unsigned int err)
+static int s5p_mfc_err_dec_v6(unsigned int err)
 {
 	return (err & S5P_FIMV_ERR_DEC_MASK_V6) >> S5P_FIMV_ERR_DEC_SHIFT_V6;
 }
 
-int s5p_mfc_err_dspl_v6(unsigned int err)
+static int s5p_mfc_err_dspl_v6(unsigned int err)
 {
 	return (err & S5P_FIMV_ERR_DSPL_MASK_V6) >> S5P_FIMV_ERR_DSPL_SHIFT_V6;
 }
 
-int s5p_mfc_get_img_width_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_img_width_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6);
 }
 
-int s5p_mfc_get_img_height_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_img_height_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V6);
 }
 
-int s5p_mfc_get_dpb_count_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dpb_count_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_MIN_NUM_DPB_V6);
 }
 
-int s5p_mfc_get_mv_count_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_mv_count_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_MIN_NUM_MV_V6);
 }
 
-int s5p_mfc_get_inst_no_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_inst_no_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_RET_INSTANCE_ID_V6);
 }
 
-int s5p_mfc_get_enc_dpb_count_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_dpb_count_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_E_NUM_DPB_V6);
 }
 
-int s5p_mfc_get_enc_strm_size_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_strm_size_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_E_STREAM_SIZE_V6);
 }
 
-int s5p_mfc_get_enc_slice_type_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_slice_type_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_E_SLICE_TYPE_V6);
 }
 
-int s5p_mfc_get_enc_pic_count_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_enc_pic_count_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_E_PICTURE_COUNT_V6);
 }
 
-int s5p_mfc_get_sei_avail_status_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_get_sei_avail_status_v6(struct s5p_mfc_ctx *ctx)
 {
 	return mfc_read(ctx->dev, S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6);
 }
 
-int s5p_mfc_get_mvc_num_views_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_mvc_num_views_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_MVC_NUM_VIEWS_V6);
 }
 
-int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_MVC_VIEW_ID_V6);
 }
 
-unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx, PIC_TIME_TOP_V6);
 }
 
-unsigned int s5p_mfc_get_pic_type_bot_v6(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_pic_type_bot_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx, PIC_TIME_BOT_V6);
 }
 
-unsigned int s5p_mfc_get_crop_info_h_v6(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_crop_info_h_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx, CROP_INFO_H_V6);
 }
 
-unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
+static unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx, CROP_INFO_V_V6);
 }
-- 
1.7.4.1

