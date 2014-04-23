Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42784 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaDWM5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 08:57:54 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 1/3] [media] s5p-mfc: Add variants to access mfc registers
Date: Wed, 23 Apr 2014 18:27:42 +0530
Message-Id: <1398257864-12097-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1398257864-12097-1-git-send-email-arun.kk@samsung.com>
References: <1398257864-12097-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

This patch is needed in preparation to add MFC V8
where the register offsets are changed w.r.t MFC V6/V7.

This patch adds variants of MFC V6 and V7 while
accessing MFC registers. Registers are kept in mfc context
and are initialized to a particular MFC variant during probe,
which is used instead of macros.

This avoids duplication of the code for MFC variants
V6 & V7, and reduces the if_else checks while accessing
registers of different MFC variants.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  254 +++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  697 +++++++++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    7 +-
 6 files changed, 710 insertions(+), 256 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 4f9d37a..07ebac8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1223,6 +1223,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	/* Initialize HW ops and commands based on MFC version */
 	s5p_mfc_init_hw_ops(dev);
 	s5p_mfc_init_hw_cmds(dev);
+	s5p_mfc_init_regs(dev);
 
 	pr_debug("%s--\n", __func__);
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index f5404a6..48a14b5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -332,6 +332,7 @@ struct s5p_mfc_dev {
 	struct s5p_mfc_hw_ops *mfc_ops;
 	struct s5p_mfc_hw_cmds *mfc_cmds;
 	int ver;
+	const struct s5p_mfc_regs *mfc_regs;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 3c01c33..c9a2274 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -31,6 +31,12 @@ void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev)
 	dev->mfc_ops = s5p_mfc_ops;
 }
 
+void s5p_mfc_init_regs(struct s5p_mfc_dev *dev)
+{
+	if (IS_MFCV6_PLUS(dev))
+		dev->mfc_regs = s5p_mfc_init_regs_v6_plus(dev);
+}
+
 int s5p_mfc_alloc_priv_buf(struct device *dev,
 					struct s5p_mfc_priv_buf *b)
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 754c540..7a7ad32 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -17,6 +17,259 @@
 
 #include "s5p_mfc_common.h"
 
+struct s5p_mfc_regs {
+
+	/* codec common registers */
+	void *risc_on;
+	void *risc2host_int;
+	void *host2risc_int;
+	void *risc_base_address;
+	void *mfc_reset;
+	void *host2risc_command;
+	void *risc2host_command;
+	void *mfc_bus_reset_ctrl;
+	void *firmware_version;
+	void *instance_id;
+	void *codec_type;
+	void *context_mem_addr;
+	void *context_mem_size;
+	void *pixel_format;
+	void *metadata_enable;
+	void *mfc_version;
+	void *dbg_info_enable;
+	void *dbg_buffer_addr;
+	void *dbg_buffer_size;
+	void *hed_control;
+	void *mfc_timeout_value;
+	void *hed_shared_mem_addr;
+	void *dis_shared_mem_addr;/* only v7 */
+	void *ret_instance_id;
+	void *error_code;
+	void *dbg_buffer_output_size;
+	void *metadata_status;
+	void *metadata_addr_mb_info;
+	void *metadata_size_mb_info;
+	void *dbg_info_stage_counter;
+
+	/* decoder registers */
+	void *d_crc_ctrl;
+	void *d_dec_options;
+	void *d_display_delay;
+	void *d_set_frame_width;
+	void *d_set_frame_height;
+	void *d_sei_enable;
+	void *d_min_num_dpb;
+	void *d_min_first_plane_dpb_size;
+	void *d_min_second_plane_dpb_size;
+	void *d_min_third_plane_dpb_size;/* only v8 */
+	void *d_min_num_mv;
+	void *d_mvc_num_views;
+	void *d_min_num_dis;/* only v7 */
+	void *d_min_first_dis_size;/* only v7 */
+	void *d_min_second_dis_size;/* only v7 */
+	void *d_min_third_dis_size;/* only v7 */
+	void *d_post_filter_luma_dpb0;/*  v7 and v8 */
+	void *d_post_filter_luma_dpb1;/* v7 and v8 */
+	void *d_post_filter_luma_dpb2;/* only v7 */
+	void *d_post_filter_chroma_dpb0;/* v7 and v8 */
+	void *d_post_filter_chroma_dpb1;/* v7 and v8 */
+	void *d_post_filter_chroma_dpb2;/* only v7 */
+	void *d_num_dpb;
+	void *d_num_mv;
+	void *d_init_buffer_options;
+	void *d_first_plane_dpb_stride_size;/* only v8 */
+	void *d_second_plane_dpb_stride_size;/* only v8 */
+	void *d_third_plane_dpb_stride_size;/* only v8 */
+	void *d_first_plane_dpb_size;
+	void *d_second_plane_dpb_size;
+	void *d_third_plane_dpb_size;/* only v8 */
+	void *d_mv_buffer_size;
+	void *d_first_plane_dpb;
+	void *d_second_plane_dpb;
+	void *d_third_plane_dpb;
+	void *d_mv_buffer;
+	void *d_scratch_buffer_addr;
+	void *d_scratch_buffer_size;
+	void *d_metadata_buffer_addr;
+	void *d_metadata_buffer_size;
+	void *d_nal_start_options;/* v7 and v8 */
+	void *d_cpb_buffer_addr;
+	void *d_cpb_buffer_size;
+	void *d_available_dpb_flag_upper;
+	void *d_available_dpb_flag_lower;
+	void *d_cpb_buffer_offset;
+	void *d_slice_if_enable;
+	void *d_picture_tag;
+	void *d_stream_data_size;
+	void *d_dynamic_dpb_flag_upper;/* v7 and v8 */
+	void *d_dynamic_dpb_flag_lower;/* v7 and v8 */
+	void *d_display_frame_width;
+	void *d_display_frame_height;
+	void *d_display_status;
+	void *d_display_first_plane_addr;
+	void *d_display_second_plane_addr;
+	void *d_display_third_plane_addr;/* only v8 */
+	void *d_display_frame_type;
+	void *d_display_crop_info1;
+	void *d_display_crop_info2;
+	void *d_display_picture_profile;
+	void *d_display_luma_crc;/* v7 and v8 */
+	void *d_display_chroma0_crc;/* v7 and v8 */
+	void *d_display_chroma1_crc;/* only v8 */
+	void *d_display_luma_crc_top;/* only v6 */
+	void *d_display_chroma_crc_top;/* only v6 */
+	void *d_display_luma_crc_bot;/* only v6 */
+	void *d_display_chroma_crc_bot;/* only v6 */
+	void *d_display_aspect_ratio;
+	void *d_display_extended_ar;
+	void *d_decoded_frame_width;
+	void *d_decoded_frame_height;
+	void *d_decoded_status;
+	void *d_decoded_first_plane_addr;
+	void *d_decoded_second_plane_addr;
+	void *d_decoded_third_plane_addr;/* only v8 */
+	void *d_decoded_frame_type;
+	void *d_decoded_crop_info1;
+	void *d_decoded_crop_info2;
+	void *d_decoded_picture_profile;
+	void *d_decoded_nal_size;
+	void *d_decoded_luma_crc;
+	void *d_decoded_chroma0_crc;
+	void *d_decoded_chroma1_crc;/* only v8 */
+	void *d_ret_picture_tag_top;
+	void *d_ret_picture_tag_bot;
+	void *d_ret_picture_time_top;
+	void *d_ret_picture_time_bot;
+	void *d_chroma_format;
+	void *d_vc1_info;/* v7 and v8 */
+	void *d_mpeg4_info;
+	void *d_h264_info;
+	void *d_metadata_addr_concealed_mb;
+	void *d_metadata_size_concealed_mb;
+	void *d_metadata_addr_vc1_param;
+	void *d_metadata_size_vc1_param;
+	void *d_metadata_addr_sei_nal;
+	void *d_metadata_size_sei_nal;
+	void *d_metadata_addr_vui;
+	void *d_metadata_size_vui;
+	void *d_metadata_addr_mvcvui;/* v7 and v8 */
+	void *d_metadata_size_mvcvui;/* v7 and v8 */
+	void *d_mvc_view_id;
+	void *d_frame_pack_sei_avail;
+	void *d_frame_pack_arrgment_id;
+	void *d_frame_pack_sei_info;
+	void *d_frame_pack_grid_pos;
+	void *d_display_recovery_sei_info;/* v7 and v8 */
+	void *d_decoded_recovery_sei_info;/* v7 and v8 */
+	void *d_display_first_addr;/* only v7 */
+	void *d_display_second_addr;/* only v7 */
+	void *d_display_third_addr;/* only v7 */
+	void *d_decoded_first_addr;/* only v7 */
+	void *d_decoded_second_addr;/* only v7 */
+	void *d_decoded_third_addr;/* only v7 */
+	void *d_used_dpb_flag_upper;/* v7 and v8 */
+	void *d_used_dpb_flag_lower;/* v7 and v8 */
+
+	/* encoder registers */
+	void *e_frame_width;
+	void *e_frame_height;
+	void *e_cropped_frame_width;
+	void *e_cropped_frame_height;
+	void *e_frame_crop_offset;
+	void *e_enc_options;
+	void *e_picture_profile;
+	void *e_vbv_buffer_size;
+	void *e_vbv_init_delay;
+	void *e_fixed_picture_qp;
+	void *e_rc_config;
+	void *e_rc_qp_bound;
+	void *e_rc_qp_bound_pb;/* v7 and v8 */
+	void *e_rc_mode;
+	void *e_mb_rc_config;
+	void *e_padding_ctrl;
+	void *e_air_threshold;
+	void *e_mv_hor_range;
+	void *e_mv_ver_range;
+	void *e_num_dpb;
+	void *e_luma_dpb;
+	void *e_chroma_dpb;
+	void *e_me_buffer;
+	void *e_scratch_buffer_addr;
+	void *e_scratch_buffer_size;
+	void *e_tmv_buffer0;
+	void *e_tmv_buffer1;
+	void *e_ir_buffer_addr;/* v7 and v8 */
+	void *e_source_first_plane_addr;
+	void *e_source_second_plane_addr;
+	void *e_source_third_plane_addr;/* v7 and v8 */
+	void *e_source_first_plane_stride;/* v7 and v8 */
+	void *e_source_second_plane_stride;/* v7 and v8 */
+	void *e_source_third_plane_stride;/* v7 and v8 */
+	void *e_stream_buffer_addr;
+	void *e_stream_buffer_size;
+	void *e_roi_buffer_addr;
+	void *e_param_change;
+	void *e_ir_size;
+	void *e_gop_config;
+	void *e_mslice_mode;
+	void *e_mslice_size_mb;
+	void *e_mslice_size_bits;
+	void *e_frame_insertion;
+	void *e_rc_frame_rate;
+	void *e_rc_bit_rate;
+	void *e_rc_roi_ctrl;
+	void *e_picture_tag;
+	void *e_bit_count_enable;
+	void *e_max_bit_count;
+	void *e_min_bit_count;
+	void *e_metadata_buffer_addr;
+	void *e_metadata_buffer_size;
+	void *e_encoded_source_first_plane_addr;
+	void *e_encoded_source_second_plane_addr;
+	void *e_encoded_source_third_plane_addr;/* v7 and v8 */
+	void *e_stream_size;
+	void *e_slice_type;
+	void *e_picture_count;
+	void *e_ret_picture_tag;
+	void *e_stream_buffer_write_pointer; /*  only v6 */
+	void *e_recon_luma_dpb_addr;
+	void *e_recon_chroma_dpb_addr;
+	void *e_metadata_addr_enc_slice;
+	void *e_metadata_size_enc_slice;
+	void *e_mpeg4_options;
+	void *e_mpeg4_hec_period;
+	void *e_aspect_ratio;
+	void *e_extended_sar;
+	void *e_h264_options;
+	void *e_h264_options_2;/* v7 and v8 */
+	void *e_h264_lf_alpha_offset;
+	void *e_h264_lf_beta_offset;
+	void *e_h264_i_period;
+	void *e_h264_fmo_slice_grp_map_type;
+	void *e_h264_fmo_num_slice_grp_minus1;
+	void *e_h264_fmo_slice_grp_change_dir;
+	void *e_h264_fmo_slice_grp_change_rate_minus1;
+	void *e_h264_fmo_run_length_minus1_0;
+	void *e_h264_aso_slice_order_0;
+	void *e_h264_chroma_qp_offset;
+	void *e_h264_num_t_layer;
+	void *e_h264_hierarchical_qp_layer0;
+	void *e_h264_frame_packing_sei_info;
+	void *e_h264_nal_control;/* v7 and v8 */
+	void *e_mvc_frame_qp_view1;
+	void *e_mvc_rc_bit_rate_view1;
+	void *e_mvc_rc_qbound_view1;
+	void *e_mvc_rc_mode_view1;
+	void *e_mvc_inter_view_prediction_on;
+	void *e_vp8_options;/* v7 and v8 */
+	void *e_vp8_filter_options;/* v7 and v8 */
+	void *e_vp8_golden_frame_option;/* v7 and v8 */
+	void *e_vp8_num_t_layer;/* v7 and v8 */
+	void *e_vp8_hierarchical_qp_layer0;/* v7 and v8 */
+	void *e_vp8_hierarchical_qp_layer1;/* v7 and v8 */
+	void *e_vp8_hierarchical_qp_layer2;/* v7 and v8 */
+};
+
 struct s5p_mfc_hw_ops {
 	int (*alloc_dec_temp_buffers)(struct s5p_mfc_ctx *ctx);
 	void (*release_dec_desc_buffer)(struct s5p_mfc_ctx *ctx);
@@ -80,6 +333,7 @@ struct s5p_mfc_hw_ops {
 };
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
+void s5p_mfc_init_regs(struct s5p_mfc_dev *dev);
 int s5p_mfc_alloc_priv_buf(struct device *dev,
 					struct s5p_mfc_priv_buf *b);
 void s5p_mfc_release_priv_buf(struct device *dev,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 356cfe5..65b8d20 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -44,10 +44,10 @@
 	} while (0)
 #endif /* S5P_MFC_DEBUG_REGWRITE */
 
-#define READL(offset)		readl(dev->regs_base + (offset))
-#define WRITEL(data, offset)	writel((data), dev->regs_base + (offset))
-#define OFFSETA(x)		(((x) - dev->port_a) >> S5P_FIMV_MEM_OFFSET)
-#define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
+#define READL(reg) \
+	(WARN_ON_ONCE(!(reg)) ? 0 : readl(reg))
+#define WRITEL(data, reg) \
+	(WARN_ON_ONCE(!(reg)) ? 0 : writel((data), (reg)))
 
 /* Allocate temporary buffers for decoding */
 static int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
@@ -367,16 +367,17 @@ static int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 			unsigned int strm_size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
 
 	mfc_debug_enter();
 	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x,\n"
 		"buf_size: 0x%08x (%d)\n",
 		ctx->inst_no, buf_addr, strm_size, strm_size);
-	WRITEL(strm_size, S5P_FIMV_D_STREAM_DATA_SIZE_V6);
-	WRITEL(buf_addr, S5P_FIMV_D_CPB_BUFFER_ADDR_V6);
-	WRITEL(buf_size->cpb, S5P_FIMV_D_CPB_BUFFER_SIZE_V6);
-	WRITEL(start_num_byte, S5P_FIMV_D_CPB_BUFFER_OFFSET_V6);
+	WRITEL(strm_size, mfc_regs->d_stream_data_size);
+	WRITEL(buf_addr, mfc_regs->d_cpb_buffer_addr);
+	WRITEL(buf_size->cpb, mfc_regs->d_cpb_buffer_size);
+	WRITEL(start_num_byte, mfc_regs->d_cpb_buffer_offset);
 
 	mfc_debug_leave();
 	return 0;
@@ -388,6 +389,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 	unsigned int frame_size, i;
 	unsigned int frame_size_ch, frame_size_mv;
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	size_t buf_addr1;
 	int buf_size1;
 	int align_gap;
@@ -399,19 +401,19 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
 	mfc_debug(2, "Setting display delay to %d\n", ctx->display_delay);
 
-	WRITEL(ctx->total_dpb_count, S5P_FIMV_D_NUM_DPB_V6);
-	WRITEL(ctx->luma_size, S5P_FIMV_D_LUMA_DPB_SIZE_V6);
-	WRITEL(ctx->chroma_size, S5P_FIMV_D_CHROMA_DPB_SIZE_V6);
+	WRITEL(ctx->total_dpb_count, mfc_regs->d_num_dpb);
+	WRITEL(ctx->luma_size, mfc_regs->d_first_plane_dpb_size);
+	WRITEL(ctx->chroma_size, mfc_regs->d_second_plane_dpb_size);
 
-	WRITEL(buf_addr1, S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V6);
-	WRITEL(ctx->scratch_buf_size, S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V6);
+	WRITEL(buf_addr1, mfc_regs->d_scratch_buffer_addr);
+	WRITEL(ctx->scratch_buf_size, mfc_regs->d_scratch_buffer_size);
 	buf_addr1 += ctx->scratch_buf_size;
 	buf_size1 -= ctx->scratch_buf_size;
 
 	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
 			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC){
-		WRITEL(ctx->mv_size, S5P_FIMV_D_MV_BUFFER_SIZE_V6);
-		WRITEL(ctx->mv_count, S5P_FIMV_D_NUM_MV_V6);
+		WRITEL(ctx->mv_size, mfc_regs->d_mv_buffer_size);
+		WRITEL(ctx->mv_count, mfc_regs->d_num_mv);
 	}
 
 	frame_size = ctx->luma_size;
@@ -425,11 +427,11 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 		mfc_debug(2, "Luma %d: %x\n", i,
 					ctx->dst_bufs[i].cookie.raw.luma);
 		WRITEL(ctx->dst_bufs[i].cookie.raw.luma,
-				S5P_FIMV_D_LUMA_DPB_V6 + i * 4);
+				mfc_regs->d_first_plane_dpb + i * 4);
 		mfc_debug(2, "\tChroma %d: %x\n", i,
 					ctx->dst_bufs[i].cookie.raw.chroma);
 		WRITEL(ctx->dst_bufs[i].cookie.raw.chroma,
-				S5P_FIMV_D_CHROMA_DPB_V6 + i * 4);
+				mfc_regs->d_second_plane_dpb + i * 4);
 	}
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
 			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
@@ -442,7 +444,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 			mfc_debug(2, "\tBuf1: %x, size: %d\n",
 					buf_addr1, buf_size1);
-			WRITEL(buf_addr1, S5P_FIMV_D_MV_BUFFER_V6 + i * 4);
+			WRITEL(buf_addr1, mfc_regs->d_mv_buffer + i * 4);
 			buf_addr1 += frame_size_mv;
 			buf_size1 -= frame_size_mv;
 		}
@@ -455,7 +457,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 		return -ENOMEM;
 	}
 
-	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	WRITEL(ctx->inst_no, mfc_regs->instance_id);
 	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
 
@@ -468,9 +470,10 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 		unsigned long addr, unsigned int size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
-	WRITEL(addr, S5P_FIMV_E_STREAM_BUFFER_ADDR_V6); /* 16B align */
-	WRITEL(size, S5P_FIMV_E_STREAM_BUFFER_SIZE_V6);
+	WRITEL(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
+	WRITEL(size, mfc_regs->e_stream_buffer_size);
 
 	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
 		  addr, size);
@@ -482,14 +485,10 @@ static void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 		unsigned long y_addr, unsigned long c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
-	if (IS_MFCV7(dev)) {
-		WRITEL(y_addr, S5P_FIMV_E_SOURCE_FIRST_ADDR_V7);
-		WRITEL(c_addr, S5P_FIMV_E_SOURCE_SECOND_ADDR_V7);
-	} else {
-		WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6);
-		WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
-	}
+	WRITEL(y_addr, mfc_regs->e_source_first_plane_addr);
+	WRITEL(c_addr, mfc_regs->e_source_second_plane_addr);
 
 	mfc_debug(2, "enc src y buf addr: 0x%08lx\n", y_addr);
 	mfc_debug(2, "enc src c buf addr: 0x%08lx\n", c_addr);
@@ -499,18 +498,14 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 		unsigned long *y_addr, unsigned long *c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	unsigned long enc_recon_y_addr, enc_recon_c_addr;
 
-	if (IS_MFCV7(dev)) {
-		*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_FIRST_ADDR_V7);
-		*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_SECOND_ADDR_V7);
-	} else {
-		*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6);
-		*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6);
-	}
+	*y_addr = READL(mfc_regs->e_encoded_source_first_plane_addr);
+	*c_addr = READL(mfc_regs->e_encoded_source_second_plane_addr);
 
-	enc_recon_y_addr = READL(S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6);
-	enc_recon_c_addr = READL(S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6);
+	enc_recon_y_addr = READL(mfc_regs->e_recon_luma_dpb_addr);
+	enc_recon_c_addr = READL(mfc_regs->e_recon_chroma_dpb_addr);
 
 	mfc_debug(2, "recon y addr: 0x%08lx\n", enc_recon_y_addr);
 	mfc_debug(2, "recon c addr: 0x%08lx\n", enc_recon_c_addr);
@@ -520,6 +515,7 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	size_t buf_addr1;
 	int i, buf_size1;
 
@@ -531,24 +527,24 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
 
 	for (i = 0; i < ctx->pb_count; i++) {
-		WRITEL(buf_addr1, S5P_FIMV_E_LUMA_DPB_V6 + (4 * i));
+		WRITEL(buf_addr1, mfc_regs->e_luma_dpb + (4 * i));
 		buf_addr1 += ctx->luma_dpb_size;
-		WRITEL(buf_addr1, S5P_FIMV_E_CHROMA_DPB_V6 + (4 * i));
+		WRITEL(buf_addr1, mfc_regs->e_chroma_dpb + (4 * i));
 		buf_addr1 += ctx->chroma_dpb_size;
-		WRITEL(buf_addr1, S5P_FIMV_E_ME_BUFFER_V6 + (4 * i));
+		WRITEL(buf_addr1, mfc_regs->e_me_buffer + (4 * i));
 		buf_addr1 += ctx->me_buffer_size;
 		buf_size1 -= (ctx->luma_dpb_size + ctx->chroma_dpb_size +
 			ctx->me_buffer_size);
 	}
 
-	WRITEL(buf_addr1, S5P_FIMV_E_SCRATCH_BUFFER_ADDR_V6);
-	WRITEL(ctx->scratch_buf_size, S5P_FIMV_E_SCRATCH_BUFFER_SIZE_V6);
+	WRITEL(buf_addr1, mfc_regs->e_scratch_buffer_addr);
+	WRITEL(ctx->scratch_buf_size, mfc_regs->e_scratch_buffer_size);
 	buf_addr1 += ctx->scratch_buf_size;
 	buf_size1 -= ctx->scratch_buf_size;
 
-	WRITEL(buf_addr1, S5P_FIMV_E_TMV_BUFFER0_V6);
+	WRITEL(buf_addr1, mfc_regs->e_tmv_buffer0);
 	buf_addr1 += ctx->tmv_buffer_size >> 1;
-	WRITEL(buf_addr1, S5P_FIMV_E_TMV_BUFFER1_V6);
+	WRITEL(buf_addr1, mfc_regs->e_tmv_buffer1);
 	buf_addr1 += ctx->tmv_buffer_size >> 1;
 	buf_size1 -= ctx->tmv_buffer_size;
 
@@ -559,7 +555,7 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 		return -ENOMEM;
 	}
 
-	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	WRITEL(ctx->inst_no, mfc_regs->instance_id);
 	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
 
@@ -571,18 +567,19 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_set_slice_mode(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
 	/* multi-slice control */
 	/* multi-slice MB number or bit size */
-	WRITEL(ctx->slice_mode, S5P_FIMV_E_MSLICE_MODE_V6);
+	WRITEL(ctx->slice_mode, mfc_regs->e_mslice_mode);
 	if (ctx->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
-		WRITEL(ctx->slice_size.mb, S5P_FIMV_E_MSLICE_SIZE_MB_V6);
+		WRITEL(ctx->slice_size.mb, mfc_regs->e_mslice_size_mb);
 	} else if (ctx->slice_mode ==
 			V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
-		WRITEL(ctx->slice_size.bits, S5P_FIMV_E_MSLICE_SIZE_BITS_V6);
+		WRITEL(ctx->slice_size.bits, mfc_regs->e_mslice_size_bits);
 	} else {
-		WRITEL(0x0, S5P_FIMV_E_MSLICE_SIZE_MB_V6);
-		WRITEL(0x0, S5P_FIMV_E_MSLICE_SIZE_BITS_V6);
+		WRITEL(0x0, mfc_regs->e_mslice_size_mb);
+		WRITEL(0x0, mfc_regs->e_mslice_size_bits);
 	}
 
 	return 0;
@@ -591,27 +588,28 @@ static int s5p_mfc_set_slice_mode(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	unsigned int reg = 0;
 
 	mfc_debug_enter();
 
 	/* width */
-	WRITEL(ctx->img_width, S5P_FIMV_E_FRAME_WIDTH_V6); /* 16 align */
+	WRITEL(ctx->img_width, mfc_regs->e_frame_width); /* 16 align */
 	/* height */
-	WRITEL(ctx->img_height, S5P_FIMV_E_FRAME_HEIGHT_V6); /* 16 align */
+	WRITEL(ctx->img_height, mfc_regs->e_frame_height); /* 16 align */
 
 	/* cropped width */
-	WRITEL(ctx->img_width, S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6);
+	WRITEL(ctx->img_width, mfc_regs->e_cropped_frame_width);
 	/* cropped height */
-	WRITEL(ctx->img_height, S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
+	WRITEL(ctx->img_height, mfc_regs->e_cropped_frame_height);
 	/* cropped offset */
-	WRITEL(0x0, S5P_FIMV_E_FRAME_CROP_OFFSET_V6);
+	WRITEL(0x0, mfc_regs->e_frame_crop_offset);
 
 	/* pictype : IDR period */
 	reg = 0;
 	reg |= p->gop_size & 0xFFFF;
-	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_gop_config);
 
 	/* multi-slice control */
 	/* multi-slice MB number or bit size */
@@ -619,65 +617,65 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	reg = 0;
 	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
 		reg |= (0x1 << 3);
-		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->e_enc_options);
 		ctx->slice_size.mb = p->slice_mb;
 	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
 		reg |= (0x1 << 3);
-		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->e_enc_options);
 		ctx->slice_size.bits = p->slice_bit;
 	} else {
 		reg &= ~(0x1 << 3);
-		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->e_enc_options);
 	}
 
 	s5p_mfc_set_slice_mode(ctx);
 
 	/* cyclic intra refresh */
-	WRITEL(p->intra_refresh_mb, S5P_FIMV_E_IR_SIZE_V6);
-	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	WRITEL(p->intra_refresh_mb, mfc_regs->e_ir_size);
+	reg = READL(mfc_regs->e_enc_options);
 	if (p->intra_refresh_mb == 0)
 		reg &= ~(0x1 << 4);
 	else
 		reg |= (0x1 << 4);
-	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_enc_options);
 
 	/* 'NON_REFERENCE_STORE_ENABLE' for debugging */
-	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	reg = READL(mfc_regs->e_enc_options);
 	reg &= ~(0x1 << 9);
-	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_enc_options);
 
 	/* memory structure cur. frame */
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
 		/* 0: Linear, 1: 2D tiled*/
-		reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+		reg = READL(mfc_regs->e_enc_options);
 		reg &= ~(0x1 << 7);
-		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->e_enc_options);
 		/* 0: NV12(CbCr), 1: NV21(CrCb) */
-		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
+		WRITEL(0x0, mfc_regs->pixel_format);
 	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV21M) {
 		/* 0: Linear, 1: 2D tiled*/
-		reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+		reg = READL(mfc_regs->e_enc_options);
 		reg &= ~(0x1 << 7);
-		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->e_enc_options);
 		/* 0: NV12(CbCr), 1: NV21(CrCb) */
-		WRITEL(0x1, S5P_FIMV_PIXEL_FORMAT_V6);
+		WRITEL(0x1, mfc_regs->pixel_format);
 	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
 		/* 0: Linear, 1: 2D tiled*/
-		reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+		reg = READL(mfc_regs->e_enc_options);
 		reg |= (0x1 << 7);
-		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->e_enc_options);
 		/* 0: NV12(CbCr), 1: NV21(CrCb) */
-		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
+		WRITEL(0x0, mfc_regs->pixel_format);
 	}
 
 	/* memory structure recon. frame */
 	/* 0: Linear, 1: 2D tiled */
-	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	reg = READL(mfc_regs->e_enc_options);
 	reg |= (0x1 << 8);
-	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_enc_options);
 
 	/* padding control & value */
-	WRITEL(0x0, S5P_FIMV_E_PADDING_CTRL_V6);
+	WRITEL(0x0, mfc_regs->e_padding_ctrl);
 	if (p->pad) {
 		reg = 0;
 		/** enable */
@@ -688,64 +686,64 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 		reg |= ((p->pad_cb & 0xFF) << 8);
 		/** y value */
 		reg |= p->pad_luma & 0xFF;
-		WRITEL(reg, S5P_FIMV_E_PADDING_CTRL_V6);
+		WRITEL(reg, mfc_regs->e_padding_ctrl);
 	}
 
 	/* rate control config. */
 	reg = 0;
 	/* frame-level rate control */
 	reg |= ((p->rc_frame & 0x1) << 9);
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* bit rate */
 	if (p->rc_frame)
 		WRITEL(p->rc_bitrate,
-			S5P_FIMV_E_RC_BIT_RATE_V6);
+			mfc_regs->e_rc_bit_rate);
 	else
-		WRITEL(1, S5P_FIMV_E_RC_BIT_RATE_V6);
+		WRITEL(1, mfc_regs->e_rc_bit_rate);
 
 	/* reaction coefficient */
 	if (p->rc_frame) {
 		if (p->rc_reaction_coeff < TIGHT_CBR_MAX) /* tight CBR */
-			WRITEL(1, S5P_FIMV_E_RC_RPARAM_V6);
+			WRITEL(1, mfc_regs->e_rc_mode);
 		else					  /* loose CBR */
-			WRITEL(2, S5P_FIMV_E_RC_RPARAM_V6);
+			WRITEL(2, mfc_regs->e_rc_mode);
 	}
 
 	/* seq header ctrl */
-	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	reg = READL(mfc_regs->e_enc_options);
 	reg &= ~(0x1 << 2);
 	reg |= ((p->seq_hdr_mode & 0x1) << 2);
 
 	/* frame skip mode */
 	reg &= ~(0x3);
 	reg |= (p->frame_skip_mode & 0x3);
-	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_enc_options);
 
 	/* 'DROP_CONTROL_ENABLE', disable */
-	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	reg = READL(mfc_regs->e_rc_config);
 	reg &= ~(0x1 << 10);
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* setting for MV range [16, 256] */
 	reg = (p->mv_h_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
-	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);
+	WRITEL(reg, mfc_regs->e_mv_hor_range);
 
 	reg = (p->mv_v_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
-	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
+	WRITEL(reg, mfc_regs->e_mv_ver_range);
 
-	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
-	WRITEL(0x0, S5P_FIMV_E_ROI_BUFFER_ADDR_V6);
-	WRITEL(0x0, S5P_FIMV_E_PARAM_CHANGE_V6);
-	WRITEL(0x0, S5P_FIMV_E_RC_ROI_CTRL_V6);
-	WRITEL(0x0, S5P_FIMV_E_PICTURE_TAG_V6);
+	WRITEL(0x0, mfc_regs->e_frame_insertion);
+	WRITEL(0x0, mfc_regs->e_roi_buffer_addr);
+	WRITEL(0x0, mfc_regs->e_param_change);
+	WRITEL(0x0, mfc_regs->e_rc_roi_ctrl);
+	WRITEL(0x0, mfc_regs->e_picture_tag);
 
-	WRITEL(0x0, S5P_FIMV_E_BIT_COUNT_ENABLE_V6);
-	WRITEL(0x0, S5P_FIMV_E_MAX_BIT_COUNT_V6);
-	WRITEL(0x0, S5P_FIMV_E_MIN_BIT_COUNT_V6);
+	WRITEL(0x0, mfc_regs->e_bit_count_enable);
+	WRITEL(0x0, mfc_regs->e_max_bit_count);
+	WRITEL(0x0, mfc_regs->e_min_bit_count);
 
-	WRITEL(0x0, S5P_FIMV_E_METADATA_BUFFER_ADDR_V6);
-	WRITEL(0x0, S5P_FIMV_E_METADATA_BUFFER_SIZE_V6);
+	WRITEL(0x0, mfc_regs->e_metadata_buffer_addr);
+	WRITEL(0x0, mfc_regs->e_metadata_buffer_size);
 
 	mfc_debug_leave();
 
@@ -755,6 +753,7 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_h264_enc_params *p_h264 = &p->codec.h264;
 	unsigned int reg = 0;
@@ -765,10 +764,10 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 
 	/* pictype : number of B */
-	reg = READL(S5P_FIMV_E_GOP_CONFIG_V6);
+	reg = READL(mfc_regs->e_gop_config);
 	reg &= ~(0x3 << 16);
 	reg |= ((p->num_b_frame & 0x3) << 16);
-	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_gop_config);
 
 	/* profile & level */
 	reg = 0;
@@ -776,18 +775,19 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_h264->level & 0xFF) << 8);
 	/** profile - 0 ~ 3 */
 	reg |= p_h264->profile & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+	WRITEL(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	reg = READL(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
+
 	/** frame QP */
 	reg &= ~(0x3F);
 	reg |= p_h264->rc_frame_qp & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* max & min value of QP */
 	reg = 0;
@@ -795,16 +795,16 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_h264->rc_max_qp & 0x3F) << 8);
 	/** min QP */
 	reg |= p_h264->rc_min_qp & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+	WRITEL(reg, mfc_regs->e_rc_qp_bound);
 
 	/* other QPs */
-	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_h264->rc_b_frame_qp & 0x3F) << 16);
 		reg |= ((p_h264->rc_p_frame_qp & 0x3F) << 8);
 		reg |= p_h264->rc_frame_qp & 0x3F;
-		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* frame rate */
@@ -812,38 +812,38 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+		WRITEL(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
 		WRITEL(p_h264->cpb_size & 0xFFFF,
-				S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+				mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	/* interlace */
 	reg = 0;
 	reg |= ((p_h264->interlace & 0x1) << 3);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* height */
 	if (p_h264->interlace) {
 		WRITEL(ctx->img_height >> 1,
-				S5P_FIMV_E_FRAME_HEIGHT_V6); /* 32 align */
+				mfc_regs->e_frame_height); /* 32 align */
 		/* cropped height */
 		WRITEL(ctx->img_height >> 1,
-				S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
+				mfc_regs->e_cropped_frame_height);
 	}
 
 	/* loop filter ctrl */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg = READL(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 1);
 	reg |= ((p_h264->loop_filter_mode & 0x3) << 1);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* loopfilter alpha offset */
 	if (p_h264->loop_filter_alpha < 0) {
@@ -853,7 +853,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg = 0x00;
 		reg |= (p_h264->loop_filter_alpha & 0xF);
 	}
-	WRITEL(reg, S5P_FIMV_E_H264_LF_ALPHA_OFFSET_V6);
+	WRITEL(reg, mfc_regs->e_h264_lf_alpha_offset);
 
 	/* loopfilter beta offset */
 	if (p_h264->loop_filter_beta < 0) {
@@ -863,28 +863,28 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg = 0x00;
 		reg |= (p_h264->loop_filter_beta & 0xF);
 	}
-	WRITEL(reg, S5P_FIMV_E_H264_LF_BETA_OFFSET_V6);
+	WRITEL(reg, mfc_regs->e_h264_lf_beta_offset);
 
 	/* entropy coding mode */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg = READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1);
 	reg |= p_h264->entropy_mode & 0x1;
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* number of ref. picture */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg = READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 7);
 	reg |= (((p_h264->num_ref_pic_4p - 1) & 0x1) << 7);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* 8x8 transform enable */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg = READL(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 12);
 	reg |= ((p_h264->_8x8_transform & 0x3) << 12);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* macroblock adaptive scaling features */
-	WRITEL(0x0, S5P_FIMV_E_MB_RC_CONFIG_V6);
+	WRITEL(0x0, mfc_regs->e_mb_rc_config);
 	if (p->rc_mb) {
 		reg = 0;
 		/** dark region */
@@ -895,92 +895,95 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg |= ((p_h264->rc_mb_static & 0x1) << 1);
 		/** high activity region */
 		reg |= p_h264->rc_mb_activity & 0x1;
-		WRITEL(reg, S5P_FIMV_E_MB_RC_CONFIG_V6);
+		WRITEL(reg, mfc_regs->e_mb_rc_config);
 	}
 
 	/* aspect ratio VUI */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
-	WRITEL(0x0, S5P_FIMV_E_ASPECT_RATIO_V6);
-	WRITEL(0x0, S5P_FIMV_E_EXTENDED_SAR_V6);
+	WRITEL(0x0, mfc_regs->e_aspect_ratio);
+	WRITEL(0x0, mfc_regs->e_extended_sar);
 	if (p_h264->vui_sar) {
 		/* aspect ration IDC */
 		reg = 0;
 		reg |= p_h264->vui_sar_idc & 0xFF;
-		WRITEL(reg, S5P_FIMV_E_ASPECT_RATIO_V6);
+		WRITEL(reg, mfc_regs->e_aspect_ratio);
 		if (p_h264->vui_sar_idc == 0xFF) {
 			/* extended SAR */
 			reg = 0;
 			reg |= (p_h264->vui_ext_sar_width & 0xFFFF) << 16;
 			reg |= p_h264->vui_ext_sar_height & 0xFFFF;
-			WRITEL(reg, S5P_FIMV_E_EXTENDED_SAR_V6);
+			WRITEL(reg, mfc_regs->e_extended_sar);
 		}
 	}
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
+
 	/* value */
-	WRITEL(0x0, S5P_FIMV_E_H264_I_PERIOD_V6);
+	WRITEL(0x0, mfc_regs->e_h264_i_period);
 	if (p_h264->open_gop) {
 		reg = 0;
 		reg |= p_h264->open_gop_size & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_H264_I_PERIOD_V6);
+		WRITEL(reg, mfc_regs->e_h264_i_period);
 	}
 
 	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 9);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 14);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* ASO */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 6);
 	reg |= ((p_h264->aso & 0x1) << 6);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 
 	/* hier qp enable */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 8);
 	reg |= ((p_h264->open_gop & 0x1) << 8);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 	reg = 0;
 	if (p_h264->hier_qp && p_h264->hier_qp_layer) {
 		reg |= (p_h264->hier_qp_type & 0x1) << 0x3;
 		reg |= p_h264->hier_qp_layer & 0x7;
-		WRITEL(reg, S5P_FIMV_E_H264_NUM_T_LAYER_V6);
+		WRITEL(reg, mfc_regs->e_h264_num_t_layer);
 		/* QP value for each layer */
-		for (i = 0; i < (p_h264->hier_qp_layer & 0x7); i++)
+		for (i = 0; i < p_h264->hier_qp_layer &&
+				i < ARRAY_SIZE(p_h264->hier_qp_layer_qp); i++) {
 			WRITEL(p_h264->hier_qp_layer_qp[i],
-				S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0_V6 +
-				i * 4);
+				mfc_regs->e_h264_hierarchical_qp_layer0
+				+ i * 4);
+		}
 	}
 	/* number of coding layer should be zero when hierarchical is disable */
-	WRITEL(reg, S5P_FIMV_E_H264_NUM_T_LAYER_V6);
+	WRITEL(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	READL(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
-	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	WRITEL(reg, mfc_regs->e_h264_options);
 	if (p_h264->sei_frame_packing) {
 		reg = 0;
 		/** current frame0 flag */
 		reg |= ((p_h264->sei_fp_curr_frame_0 & 0x1) << 2);
 		/** arrangement type */
 		reg |= p_h264->sei_fp_arrangement_type & 0x3;
-		WRITEL(reg, S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6);
+		WRITEL(reg, mfc_regs->e_h264_frame_packing_sei_info);
 	}
 
 	if (p_h264->fmo) {
@@ -988,10 +991,12 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES:
 			if (p_h264->fmo_slice_grp > 4)
 				p_h264->fmo_slice_grp = 4;
-			for (i = 0; i < (p_h264->fmo_slice_grp & 0xF); i++)
+			for (i = 0; i < ARRAY_SIZE(p_h264->fmo_run_len)
+					&& i < p_h264->fmo_slice_grp; i++) {
 				WRITEL(p_h264->fmo_run_len[i] - 1,
-				S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0_V6 +
-				i * 4);
+					mfc_regs->e_h264_fmo_run_length_minus1_0
+					+ i * 4);
+			}
 			break;
 		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES:
 			if (p_h264->fmo_slice_grp > 4)
@@ -1002,10 +1007,10 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 			if (p_h264->fmo_slice_grp > 2)
 				p_h264->fmo_slice_grp = 2;
 			WRITEL(p_h264->fmo_chg_dir & 0x1,
-				S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR_V6);
+				mfc_regs->e_h264_fmo_slice_grp_change_dir);
 			/* the valid range is 0 ~ number of macroblocks -1 */
 			WRITEL(p_h264->fmo_chg_rate,
-				S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1_V6);
+			mfc_regs->e_h264_fmo_slice_grp_change_rate_minus1);
 			break;
 		default:
 			mfc_err("Unsupported map type for FMO: %d\n",
@@ -1016,11 +1021,11 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		}
 
 		WRITEL(p_h264->fmo_map_type,
-				S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE_V6);
+				mfc_regs->e_h264_fmo_slice_grp_map_type);
 		WRITEL(p_h264->fmo_slice_grp - 1,
-				S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6);
+				mfc_regs->e_h264_fmo_num_slice_grp_minus1);
 	} else {
-		WRITEL(0, S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6);
+		WRITEL(0, mfc_regs->e_h264_fmo_num_slice_grp_minus1);
 	}
 
 	mfc_debug_leave();
@@ -1031,6 +1036,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_mpeg4_enc_params *p_mpeg4 = &p->codec.mpeg4;
 	unsigned int reg = 0;
@@ -1040,10 +1046,10 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 
 	/* pictype : number of B */
-	reg = READL(S5P_FIMV_E_GOP_CONFIG_V6);
+	reg = READL(mfc_regs->e_gop_config);
 	reg &= ~(0x3 << 16);
 	reg |= ((p->num_b_frame & 0x3) << 16);
-	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_gop_config);
 
 	/* profile & level */
 	reg = 0;
@@ -1051,18 +1057,19 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_mpeg4->level & 0xFF) << 8);
 	/** profile - 0 ~ 1 */
 	reg |= p_mpeg4->profile & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+	WRITEL(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	reg = READL(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
+
 	/** frame QP */
 	reg &= ~(0x3F);
 	reg |= p_mpeg4->rc_frame_qp & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* max & min value of QP */
 	reg = 0;
@@ -1070,16 +1077,16 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_mpeg4->rc_max_qp & 0x3F) << 8);
 	/** min QP */
 	reg |= p_mpeg4->rc_min_qp & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+	WRITEL(reg, mfc_regs->e_rc_qp_bound);
 
 	/* other QPs */
-	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 16);
 		reg |= ((p_mpeg4->rc_p_frame_qp & 0x3F) << 8);
 		reg |= p_mpeg4->rc_frame_qp & 0x3F;
-		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* frame rate */
@@ -1087,21 +1094,21 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+		WRITEL(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+		WRITEL(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	/* Disable HEC */
-	WRITEL(0x0, S5P_FIMV_E_MPEG4_OPTIONS_V6);
-	WRITEL(0x0, S5P_FIMV_E_MPEG4_HEC_PERIOD_V6);
+	WRITEL(0x0, mfc_regs->e_mpeg4_options);
+	WRITEL(0x0, mfc_regs->e_mpeg4_hec_period);
 
 	mfc_debug_leave();
 
@@ -1111,6 +1118,7 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_mpeg4_enc_params *p_h263 = &p->codec.mpeg4;
 	unsigned int reg = 0;
@@ -1123,18 +1131,19 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	reg = 0;
 	/** profile */
 	reg |= (0x1 << 4);
-	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+	WRITEL(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	reg = READL(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
+
 	/** frame QP */
 	reg &= ~(0x3F);
 	reg |= p_h263->rc_frame_qp & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* max & min value of QP */
 	reg = 0;
@@ -1142,16 +1151,16 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_h263->rc_max_qp & 0x3F) << 8);
 	/** min QP */
 	reg |= p_h263->rc_min_qp & 0x3F;
-	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+	WRITEL(reg, mfc_regs->e_rc_qp_bound);
 
 	/* other QPs */
-	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_h263->rc_b_frame_qp & 0x3F) << 16);
 		reg |= ((p_h263->rc_p_frame_qp & 0x3F) << 8);
 		reg |= p_h263->rc_frame_qp & 0x3F;
-		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* frame rate */
@@ -1159,16 +1168,16 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+		WRITEL(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+		WRITEL(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	mfc_debug_leave();
@@ -1179,6 +1188,7 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_vp8_enc_params *p_vp8 = &p->codec.vp8;
 	unsigned int reg = 0;
@@ -1189,57 +1199,57 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 
 	/* pictype : number of B */
-	reg = READL(S5P_FIMV_E_GOP_CONFIG_V6);
+	reg = READL(mfc_regs->e_gop_config);
 	reg &= ~(0x3 << 16);
 	reg |= ((p->num_b_frame & 0x3) << 16);
-	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_gop_config);
 
 	/* profile - 0 ~ 3 */
 	reg = p_vp8->profile & 0x3;
-	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+	WRITEL(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	reg = READL(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* frame rate */
 	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+		WRITEL(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* frame QP */
 	reg &= ~(0x7F);
 	reg |= p_vp8->rc_frame_qp & 0x7F;
-	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	WRITEL(reg, mfc_regs->e_rc_config);
 
 	/* other QPs */
-	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_vp8->rc_p_frame_qp & 0x7F) << 8);
 		reg |= p_vp8->rc_frame_qp & 0x7F;
-		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* max QP */
 	reg = ((p_vp8->rc_max_qp & 0x7F) << 8);
 	/* min QP */
 	reg |= p_vp8->rc_min_qp & 0x7F;
-	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+	WRITEL(reg, mfc_regs->e_rc_qp_bound);
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+		WRITEL(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	/* VP8 specific params */
@@ -1263,7 +1273,7 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	}
 	reg |= (val & 0xF) << 3;
 	reg |= (p_vp8->num_ref & 0x2);
-	WRITEL(reg, S5P_FIMV_E_VP8_OPTIONS_V7);
+	WRITEL(reg, mfc_regs->e_vp8_options);
 
 	mfc_debug_leave();
 
@@ -1297,6 +1307,7 @@ static bool s5p_mfc_is_v6_new(struct s5p_mfc_dev *dev)
 static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	unsigned int reg = 0;
 	int fmo_aso_ctrl = 0;
 
@@ -1304,9 +1315,9 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "InstNo: %d/%d\n", ctx->inst_no,
 			S5P_FIMV_CH_SEQ_HEADER_V6);
 	mfc_debug(2, "BUFs: %08x %08x %08x\n",
-		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR_V6),
-		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR_V6),
-		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR_V6));
+		  READL(mfc_regs->d_cpb_buffer_addr),
+		  READL(mfc_regs->d_cpb_buffer_addr),
+		  READL(mfc_regs->d_cpb_buffer_addr));
 
 	/* FMO_ASO_CTRL - 0: Enable, 1: Disable */
 	reg |= (fmo_aso_ctrl << S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6);
@@ -1317,11 +1328,11 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	 * set to negative value. */
 	if (ctx->display_delay >= 0) {
 		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6);
-		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
+		WRITEL(ctx->display_delay, mfc_regs->d_display_delay);
 	}
 
 	if (IS_MFCV7(dev) || s5p_mfc_is_v6_new(dev)) {
-		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->d_dec_options);
 		reg = 0;
 	}
 
@@ -1336,21 +1347,21 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
 	if (IS_MFCV7(dev) || s5p_mfc_is_v6_new(dev))
-		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->d_init_buffer_options);
 	else
-		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+		WRITEL(reg, mfc_regs->d_dec_options);
 
 	/* 0: NV12(CbCr), 1: NV21(CrCb) */
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
-		WRITEL(0x1, S5P_FIMV_PIXEL_FORMAT_V6);
+		WRITEL(0x1, mfc_regs->pixel_format);
 	else
-		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
+		WRITEL(0x0, mfc_regs->pixel_format);
 
 
 	/* sei parse */
-	WRITEL(ctx->sei_fp_parse & 0x1, S5P_FIMV_D_SEI_ENABLE_V6);
+	WRITEL(ctx->sei_fp_parse & 0x1, mfc_regs->d_sei_enable);
 
-	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	WRITEL(ctx->inst_no, mfc_regs->instance_id);
 	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
 
@@ -1361,11 +1372,12 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
 	if (flush) {
 		dev->curr_ctx = ctx->num;
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+		WRITEL(ctx->inst_no, mfc_regs->instance_id);
 		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_H2R_CMD_FLUSH_V6, NULL);
 	}
@@ -1376,11 +1388,12 @@ static int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
 			enum s5p_mfc_decode_arg last_frame)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
-	WRITEL(ctx->dec_dst_flag, S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V6);
-	WRITEL(ctx->slice_interface & 0x1, S5P_FIMV_D_SLICE_IF_ENABLE_V6);
+	WRITEL(ctx->dec_dst_flag, mfc_regs->d_available_dpb_flag_lower);
+	WRITEL(ctx->slice_interface & 0x1, mfc_regs->d_slice_if_enable);
 
-	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	WRITEL(ctx->inst_no, mfc_regs->instance_id);
 	/* Issue different commands to instance basing on whether it
 	 * is the last frame or not. */
 	switch (last_frame) {
@@ -1404,6 +1417,7 @@ static int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
 static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
 		s5p_mfc_set_enc_params_h264(ctx);
@@ -1419,13 +1433,13 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 		return -EINVAL;
 	}
 
-	/* Set stride lengths */
+	/* Set stride lengths for v7 & above */
 	if (IS_MFCV7(dev)) {
-		WRITEL(ctx->img_width, S5P_FIMV_E_SOURCE_FIRST_STRIDE_V7);
-		WRITEL(ctx->img_width, S5P_FIMV_E_SOURCE_SECOND_STRIDE_V7);
+		WRITEL(ctx->img_width, mfc_regs->e_source_first_plane_stride);
+		WRITEL(ctx->img_width, mfc_regs->e_source_second_plane_stride);
 	}
 
-	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	WRITEL(ctx->inst_no, mfc_regs->instance_id);
 	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
 
@@ -1435,14 +1449,16 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_h264_enc_params *p_h264 = &p->codec.h264;
 	int i;
 
 	if (p_h264->aso) {
-		for (i = 0; i < 8; i++)
+		for (i = 0; i < ARRAY_SIZE(p_h264->aso_slice_order); i++) {
 			WRITEL(p_h264->aso_slice_order[i],
-				S5P_FIMV_E_H264_ASO_SLICE_ORDER_0_V6 + i * 4);
+				mfc_regs->e_h264_aso_slice_order_0 + i * 4);
+		}
 	}
 	return 0;
 }
@@ -1451,6 +1467,7 @@ static int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
 	mfc_debug(2, "++\n");
 
@@ -1461,7 +1478,7 @@ static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_set_slice_mode(ctx);
 
-	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	WRITEL(ctx->inst_no, mfc_regs->instance_id);
 	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_FRAME_START_V6, NULL);
 
@@ -1836,28 +1853,26 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 
 static void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
 {
-	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD_V6);
-	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_INT_V6);
+	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
+	WRITEL(0, mfc_regs->risc2host_command);
+	WRITEL(0, mfc_regs->risc2host_int);
 }
 
 static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 		unsigned int ofs)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-
 	s5p_mfc_clock_on();
-	WRITEL(data, ofs);
+	WRITEL(data, (void *)ofs);
 	s5p_mfc_clock_off();
 }
 
 static unsigned int
 s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
 	int ret;
 
 	s5p_mfc_clock_on();
-	ret = READL(ofs);
+	ret = READL((void *)ofs);
 	s5p_mfc_clock_off();
 
 	return ret;
@@ -1865,50 +1880,51 @@ s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 
 static int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
+	return READL(dev->mfc_regs->d_display_first_plane_addr);
 }
 
 static int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DECODED_LUMA_ADDR_V6);
+	return READL(dev->mfc_regs->d_decoded_first_plane_addr);
 }
 
 static int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DISPLAY_STATUS_V6);
+	return READL(dev->mfc_regs->d_display_status);
 }
 
 static int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DECODED_STATUS_V6);
+	return READL(dev->mfc_regs->d_decoded_status);
 }
 
 static int s5p_mfc_get_dec_frame_type_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DECODED_FRAME_TYPE_V6) &
+	return READL(dev->mfc_regs->d_decoded_frame_type) &
 		S5P_FIMV_DECODE_FRAME_MASK_V6;
 }
 
 static int s5p_mfc_get_disp_frame_type_v6(struct s5p_mfc_ctx *ctx)
 {
-	return mfc_read(ctx->dev, S5P_FIMV_D_DISPLAY_FRAME_TYPE_V6) &
+	struct s5p_mfc_dev *dev = ctx->dev;
+	return READL(dev->mfc_regs->d_display_frame_type) &
 		S5P_FIMV_DECODE_FRAME_MASK_V6;
 }
 
 static int s5p_mfc_get_consumed_stream_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DECODED_NAL_SIZE_V6);
+	return READL(dev->mfc_regs->d_decoded_nal_size);
 }
 
 static int s5p_mfc_get_int_reason_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_RISC2HOST_CMD_V6) &
+	return READL(dev->mfc_regs->risc2host_command) &
 		S5P_FIMV_RISC2HOST_CMD_MASK;
 }
 
 static int s5p_mfc_get_int_err_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_ERROR_CODE_V6);
+	return READL(dev->mfc_regs->error_code);
 }
 
 static int s5p_mfc_err_dec_v6(unsigned int err)
@@ -1923,82 +1939,263 @@ static int s5p_mfc_err_dspl_v6(unsigned int err)
 
 static int s5p_mfc_get_img_width_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6);
+	return READL(dev->mfc_regs->d_display_frame_width);
 }
 
 static int s5p_mfc_get_img_height_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V6);
+	return READL(dev->mfc_regs->d_display_frame_height);
 }
 
 static int s5p_mfc_get_dpb_count_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_MIN_NUM_DPB_V6);
+	return READL(dev->mfc_regs->d_min_num_dpb);
 }
 
 static int s5p_mfc_get_mv_count_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_MIN_NUM_MV_V6);
+	return READL(dev->mfc_regs->d_min_num_mv);
 }
 
 static int s5p_mfc_get_inst_no_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_RET_INSTANCE_ID_V6);
+	return READL(dev->mfc_regs->ret_instance_id);
 }
 
 static int s5p_mfc_get_enc_dpb_count_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_E_NUM_DPB_V6);
+	return READL(dev->mfc_regs->e_num_dpb);
 }
 
 static int s5p_mfc_get_enc_strm_size_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_E_STREAM_SIZE_V6);
+	return READL(dev->mfc_regs->e_stream_size);
 }
 
 static int s5p_mfc_get_enc_slice_type_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_E_SLICE_TYPE_V6);
+	return READL(dev->mfc_regs->e_slice_type);
 }
 
 static int s5p_mfc_get_enc_pic_count_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_E_PICTURE_COUNT_V6);
+	return READL(dev->mfc_regs->e_picture_count);
 }
 
 static int s5p_mfc_get_sei_avail_status_v6(struct s5p_mfc_ctx *ctx)
 {
-	return mfc_read(ctx->dev, S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	return READL(dev->mfc_regs->d_frame_pack_sei_avail);
 }
 
 static int s5p_mfc_get_mvc_num_views_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_MVC_NUM_VIEWS_V6);
+	return READL(dev->mfc_regs->d_mvc_num_views);
 }
 
 static int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_MVC_VIEW_ID_V6);
+	return READL(dev->mfc_regs->d_mvc_view_id);
 }
 
 static unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
 {
-	return s5p_mfc_read_info_v6(ctx, PIC_TIME_TOP_V6);
+	return s5p_mfc_read_info_v6(ctx,
+		(unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_top);
 }
 
 static unsigned int s5p_mfc_get_pic_type_bot_v6(struct s5p_mfc_ctx *ctx)
 {
-	return s5p_mfc_read_info_v6(ctx, PIC_TIME_BOT_V6);
+	return s5p_mfc_read_info_v6(ctx,
+		(unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
 }
 
 static unsigned int s5p_mfc_get_crop_info_h_v6(struct s5p_mfc_ctx *ctx)
 {
-	return s5p_mfc_read_info_v6(ctx, CROP_INFO_H_V6);
+	return s5p_mfc_read_info_v6(ctx,
+		(unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
 }
 
 static unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
 {
-	return s5p_mfc_read_info_v6(ctx, CROP_INFO_V_V6);
+	return s5p_mfc_read_info_v6(ctx,
+		(unsigned int) ctx->dev->mfc_regs->d_display_crop_info2);
+}
+
+static struct s5p_mfc_regs mfc_regs;
+
+/* Initialize registers for MFC v6 onwards */
+const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
+{
+	memset(&mfc_regs, 0, sizeof(mfc_regs));
+
+#define S5P_MFC_REG_ADDR(dev, reg) ((dev)->regs_base + (reg))
+#define R(m, r) mfc_regs.m = S5P_MFC_REG_ADDR(dev, r)
+	/* codec common registers */
+	R(risc_on, S5P_FIMV_RISC_ON_V6);
+	R(risc2host_int, S5P_FIMV_RISC2HOST_INT_V6);
+	R(host2risc_int, S5P_FIMV_HOST2RISC_INT_V6);
+	R(risc_base_address, S5P_FIMV_RISC_BASE_ADDRESS_V6);
+	R(mfc_reset, S5P_FIMV_MFC_RESET_V6);
+	R(host2risc_command, S5P_FIMV_HOST2RISC_CMD_V6);
+	R(risc2host_command, S5P_FIMV_RISC2HOST_CMD_V6);
+	R(firmware_version, S5P_FIMV_FW_VERSION_V6);
+	R(instance_id, S5P_FIMV_INSTANCE_ID_V6);
+	R(codec_type, S5P_FIMV_CODEC_TYPE_V6);
+	R(context_mem_addr, S5P_FIMV_CONTEXT_MEM_ADDR_V6);
+	R(context_mem_size, S5P_FIMV_CONTEXT_MEM_SIZE_V6);
+	R(pixel_format, S5P_FIMV_PIXEL_FORMAT_V6);
+	R(ret_instance_id, S5P_FIMV_RET_INSTANCE_ID_V6);
+	R(error_code, S5P_FIMV_ERROR_CODE_V6);
+
+	/* decoder registers */
+	R(d_crc_ctrl, S5P_FIMV_D_CRC_CTRL_V6);
+	R(d_dec_options, S5P_FIMV_D_DEC_OPTIONS_V6);
+	R(d_display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
+	R(d_sei_enable, S5P_FIMV_D_SEI_ENABLE_V6);
+	R(d_min_num_dpb, S5P_FIMV_D_MIN_NUM_DPB_V6);
+	R(d_min_num_mv, S5P_FIMV_D_MIN_NUM_MV_V6);
+	R(d_mvc_num_views, S5P_FIMV_D_MVC_NUM_VIEWS_V6);
+	R(d_num_dpb, S5P_FIMV_D_NUM_DPB_V6);
+	R(d_num_mv, S5P_FIMV_D_NUM_MV_V6);
+	R(d_init_buffer_options, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6);
+	R(d_first_plane_dpb_size, S5P_FIMV_D_LUMA_DPB_SIZE_V6);
+	R(d_second_plane_dpb_size, S5P_FIMV_D_CHROMA_DPB_SIZE_V6);
+	R(d_mv_buffer_size, S5P_FIMV_D_MV_BUFFER_SIZE_V6);
+	R(d_first_plane_dpb, S5P_FIMV_D_LUMA_DPB_V6);
+	R(d_second_plane_dpb, S5P_FIMV_D_CHROMA_DPB_V6);
+	R(d_mv_buffer, S5P_FIMV_D_MV_BUFFER_V6);
+	R(d_scratch_buffer_addr, S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V6);
+	R(d_scratch_buffer_size, S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V6);
+	R(d_cpb_buffer_addr, S5P_FIMV_D_CPB_BUFFER_ADDR_V6);
+	R(d_cpb_buffer_size, S5P_FIMV_D_CPB_BUFFER_SIZE_V6);
+	R(d_available_dpb_flag_lower, S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V6);
+	R(d_cpb_buffer_offset, S5P_FIMV_D_CPB_BUFFER_OFFSET_V6);
+	R(d_slice_if_enable, S5P_FIMV_D_SLICE_IF_ENABLE_V6);
+	R(d_stream_data_size, S5P_FIMV_D_STREAM_DATA_SIZE_V6);
+	R(d_display_frame_width, S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6);
+	R(d_display_frame_height, S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V6);
+	R(d_display_status, S5P_FIMV_D_DISPLAY_STATUS_V6);
+	R(d_display_first_plane_addr, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
+	R(d_display_second_plane_addr, S5P_FIMV_D_DISPLAY_CHROMA_ADDR_V6);
+	R(d_display_frame_type, S5P_FIMV_D_DISPLAY_FRAME_TYPE_V6);
+	R(d_display_crop_info1, S5P_FIMV_D_DISPLAY_CROP_INFO1_V6);
+	R(d_display_crop_info2, S5P_FIMV_D_DISPLAY_CROP_INFO2_V6);
+	R(d_display_aspect_ratio, S5P_FIMV_D_DISPLAY_ASPECT_RATIO_V6);
+	R(d_display_extended_ar, S5P_FIMV_D_DISPLAY_EXTENDED_AR_V6);
+	R(d_decoded_status, S5P_FIMV_D_DECODED_STATUS_V6);
+	R(d_decoded_first_plane_addr, S5P_FIMV_D_DECODED_LUMA_ADDR_V6);
+	R(d_decoded_second_plane_addr, S5P_FIMV_D_DECODED_CHROMA_ADDR_V6);
+	R(d_decoded_frame_type, S5P_FIMV_D_DECODED_FRAME_TYPE_V6);
+	R(d_decoded_nal_size, S5P_FIMV_D_DECODED_NAL_SIZE_V6);
+	R(d_ret_picture_tag_top, S5P_FIMV_D_RET_PICTURE_TAG_TOP_V6);
+	R(d_ret_picture_tag_bot, S5P_FIMV_D_RET_PICTURE_TAG_BOT_V6);
+	R(d_h264_info, S5P_FIMV_D_H264_INFO_V6);
+	R(d_mvc_view_id, S5P_FIMV_D_MVC_VIEW_ID_V6);
+	R(d_frame_pack_sei_avail, S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6);
+
+	/* encoder registers */
+	R(e_frame_width, S5P_FIMV_E_FRAME_WIDTH_V6);
+	R(e_frame_height, S5P_FIMV_E_FRAME_HEIGHT_V6);
+	R(e_cropped_frame_width, S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6);
+	R(e_cropped_frame_height, S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
+	R(e_frame_crop_offset, S5P_FIMV_E_FRAME_CROP_OFFSET_V6);
+	R(e_enc_options, S5P_FIMV_E_ENC_OPTIONS_V6);
+	R(e_picture_profile, S5P_FIMV_E_PICTURE_PROFILE_V6);
+	R(e_vbv_buffer_size, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+	R(e_vbv_init_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+	R(e_fixed_picture_qp, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	R(e_rc_config, S5P_FIMV_E_RC_CONFIG_V6);
+	R(e_rc_qp_bound, S5P_FIMV_E_RC_QP_BOUND_V6);
+	R(e_rc_mode, S5P_FIMV_E_RC_RPARAM_V6);
+	R(e_mb_rc_config, S5P_FIMV_E_MB_RC_CONFIG_V6);
+	R(e_padding_ctrl, S5P_FIMV_E_PADDING_CTRL_V6);
+	R(e_mv_hor_range, S5P_FIMV_E_MV_HOR_RANGE_V6);
+	R(e_mv_ver_range, S5P_FIMV_E_MV_VER_RANGE_V6);
+	R(e_num_dpb, S5P_FIMV_E_NUM_DPB_V6);
+	R(e_luma_dpb, S5P_FIMV_E_LUMA_DPB_V6);
+	R(e_chroma_dpb, S5P_FIMV_E_CHROMA_DPB_V6);
+	R(e_me_buffer, S5P_FIMV_E_ME_BUFFER_V6);
+	R(e_scratch_buffer_addr, S5P_FIMV_E_SCRATCH_BUFFER_ADDR_V6);
+	R(e_scratch_buffer_size, S5P_FIMV_E_SCRATCH_BUFFER_SIZE_V6);
+	R(e_tmv_buffer0, S5P_FIMV_E_TMV_BUFFER0_V6);
+	R(e_tmv_buffer1, S5P_FIMV_E_TMV_BUFFER1_V6);
+	R(e_source_first_plane_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6);
+	R(e_source_second_plane_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
+	R(e_stream_buffer_addr, S5P_FIMV_E_STREAM_BUFFER_ADDR_V6);
+	R(e_stream_buffer_size, S5P_FIMV_E_STREAM_BUFFER_SIZE_V6);
+	R(e_roi_buffer_addr, S5P_FIMV_E_ROI_BUFFER_ADDR_V6);
+	R(e_param_change, S5P_FIMV_E_PARAM_CHANGE_V6);
+	R(e_ir_size, S5P_FIMV_E_IR_SIZE_V6);
+	R(e_gop_config, S5P_FIMV_E_GOP_CONFIG_V6);
+	R(e_mslice_mode, S5P_FIMV_E_MSLICE_MODE_V6);
+	R(e_mslice_size_mb, S5P_FIMV_E_MSLICE_SIZE_MB_V6);
+	R(e_mslice_size_bits, S5P_FIMV_E_MSLICE_SIZE_BITS_V6);
+	R(e_frame_insertion, S5P_FIMV_E_FRAME_INSERTION_V6);
+	R(e_rc_frame_rate, S5P_FIMV_E_RC_FRAME_RATE_V6);
+	R(e_rc_bit_rate, S5P_FIMV_E_RC_BIT_RATE_V6);
+	R(e_rc_roi_ctrl, S5P_FIMV_E_RC_ROI_CTRL_V6);
+	R(e_picture_tag, S5P_FIMV_E_PICTURE_TAG_V6);
+	R(e_bit_count_enable, S5P_FIMV_E_BIT_COUNT_ENABLE_V6);
+	R(e_max_bit_count, S5P_FIMV_E_MAX_BIT_COUNT_V6);
+	R(e_min_bit_count, S5P_FIMV_E_MIN_BIT_COUNT_V6);
+	R(e_metadata_buffer_addr, S5P_FIMV_E_METADATA_BUFFER_ADDR_V6);
+	R(e_metadata_buffer_size, S5P_FIMV_E_METADATA_BUFFER_SIZE_V6);
+	R(e_encoded_source_first_plane_addr,
+			S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6);
+	R(e_encoded_source_second_plane_addr,
+			S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6);
+	R(e_stream_size, S5P_FIMV_E_STREAM_SIZE_V6);
+	R(e_slice_type, S5P_FIMV_E_SLICE_TYPE_V6);
+	R(e_picture_count, S5P_FIMV_E_PICTURE_COUNT_V6);
+	R(e_ret_picture_tag, S5P_FIMV_E_RET_PICTURE_TAG_V6);
+	R(e_recon_luma_dpb_addr, S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6);
+	R(e_recon_chroma_dpb_addr, S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6);
+	R(e_mpeg4_options, S5P_FIMV_E_MPEG4_OPTIONS_V6);
+	R(e_mpeg4_hec_period, S5P_FIMV_E_MPEG4_HEC_PERIOD_V6);
+	R(e_aspect_ratio, S5P_FIMV_E_ASPECT_RATIO_V6);
+	R(e_extended_sar, S5P_FIMV_E_EXTENDED_SAR_V6);
+	R(e_h264_options, S5P_FIMV_E_H264_OPTIONS_V6);
+	R(e_h264_lf_alpha_offset, S5P_FIMV_E_H264_LF_ALPHA_OFFSET_V6);
+	R(e_h264_lf_beta_offset, S5P_FIMV_E_H264_LF_BETA_OFFSET_V6);
+	R(e_h264_i_period, S5P_FIMV_E_H264_I_PERIOD_V6);
+	R(e_h264_fmo_slice_grp_map_type,
+			S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE_V6);
+	R(e_h264_fmo_num_slice_grp_minus1,
+			S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6);
+	R(e_h264_fmo_slice_grp_change_dir,
+			S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR_V6);
+	R(e_h264_fmo_slice_grp_change_rate_minus1,
+			S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1_V6);
+	R(e_h264_fmo_run_length_minus1_0,
+			S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0_V6);
+	R(e_h264_aso_slice_order_0, S5P_FIMV_E_H264_ASO_SLICE_ORDER_0_V6);
+	R(e_h264_num_t_layer, S5P_FIMV_E_H264_NUM_T_LAYER_V6);
+	R(e_h264_hierarchical_qp_layer0,
+			S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0_V6);
+	R(e_h264_frame_packing_sei_info,
+			S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6);
+
+	if (!IS_MFCV7(dev))
+		goto done;
+
+	/* Initialize registers used in MFC v7 */
+	R(e_source_first_plane_addr, S5P_FIMV_E_SOURCE_FIRST_ADDR_V7);
+	R(e_source_second_plane_addr, S5P_FIMV_E_SOURCE_SECOND_ADDR_V7);
+	R(e_source_third_plane_addr, S5P_FIMV_E_SOURCE_THIRD_ADDR_V7);
+	R(e_source_first_plane_stride, S5P_FIMV_E_SOURCE_FIRST_STRIDE_V7);
+	R(e_source_second_plane_stride, S5P_FIMV_E_SOURCE_SECOND_STRIDE_V7);
+	R(e_source_third_plane_stride, S5P_FIMV_E_SOURCE_THIRD_STRIDE_V7);
+	R(e_encoded_source_first_plane_addr,
+			S5P_FIMV_E_ENCODED_SOURCE_FIRST_ADDR_V7);
+	R(e_encoded_source_second_plane_addr,
+			S5P_FIMV_E_ENCODED_SOURCE_SECOND_ADDR_V7);
+	R(e_vp8_options, S5P_FIMV_E_VP8_OPTIONS_V7);
+
+done:
+	return &mfc_regs;
+#undef S5P_MFC_REG_ADDR
+#undef R
 }
 
 /* Initialize opr function pointers for MFC v6 */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
index ab164ef..8055848 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -40,11 +40,6 @@
 #define FRAME_DELTA_H264_H263		1
 #define TIGHT_CBR_MAX			10
 
-/* Definitions for shared memory compatibility */
-#define PIC_TIME_TOP_V6		S5P_FIMV_D_RET_PICTURE_TAG_TOP_V6
-#define PIC_TIME_BOT_V6		S5P_FIMV_D_RET_PICTURE_TAG_BOT_V6
-#define CROP_INFO_H_V6		S5P_FIMV_D_DISPLAY_CROP_INFO1_V6
-#define CROP_INFO_V_V6		S5P_FIMV_D_DISPLAY_CROP_INFO2_V6
-
 struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void);
+const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev);
 #endif /* S5P_MFC_OPR_V6_H_ */
-- 
1.7.9.5

