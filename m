Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:58249 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729276AbeJ3HRw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:17:52 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v7 05/16] intel-ipu3: abi: Add structs
Date: Mon, 29 Oct 2018 15:22:59 -0700
Message-Id: <1540851790-1777-6-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This add all the structs of IPU3 firmware ABI.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-abi.h | 1350 +++++++++++++++++++++++++++++++
 1 file changed, 1350 insertions(+)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-abi.h b/drivers/media/pci/intel/ipu3/ipu3-abi.h
index ac08ad3..21703da 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-abi.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-abi.h
@@ -658,4 +658,1354 @@ enum imgu_abi_stage_type {
 	IMGU_ABI_STAGE_TYPE_ISP,
 };
 
+struct imgu_abi_acc_operation {
+	/*
+	 * zero means on init,
+	 * others mean upon receiving an ack signal from the BC acc.
+	 */
+	u8 op_indicator;
+	u8 op_type;
+} __packed;
+
+struct imgu_abi_acc_process_lines_cmd_data {
+	u16 lines;
+	u8 cfg_set;
+	u8 __reserved;		/* Align to 4 bytes */
+} __packed;
+
+/* Bayer shading definitions */
+
+struct imgu_abi_shd_transfer_luts_set_data {
+	u8 set_number;
+	u8 padding[3];
+	imgu_addr_t rg_lut_ddr_addr;
+	imgu_addr_t bg_lut_ddr_addr;
+	u32 align_dummy;
+} __packed;
+
+struct imgu_abi_shd_grid_config {
+	/* reg 0 */
+	u32 grid_width:8;
+	u32 grid_height:8;
+	u32 block_width:3;
+	u32 __reserved0:1;
+	u32 block_height:3;
+	u32 __reserved1:1;
+	u32 grid_height_per_slice:8;
+	/* reg 1 */
+	s32 x_start:13;
+	s32 __reserved2:3;
+	s32 y_start:13;
+	s32 __reserved3:3;
+} __packed;
+
+struct imgu_abi_shd_general_config {
+	u32 init_set_vrt_offst_ul:8;
+	u32 shd_enable:1;
+	/* aka 'gf' */
+	u32 gain_factor:2;
+	u32 __reserved:21;
+} __packed;
+
+struct imgu_abi_shd_black_level_config {
+	/* reg 0 */
+	s32 bl_r:12;
+	s32 __reserved0:4;
+	s32 bl_gr:12;
+	u32 __reserved1:1;
+	/* aka 'nf' */
+	u32 normalization_shift:3;
+	/* reg 1 */
+	s32 bl_gb:12;
+	s32 __reserved2:4;
+	s32 bl_b:12;
+	s32 __reserved3:4;
+} __packed;
+
+struct imgu_abi_shd_intra_frame_operations_data {
+	struct imgu_abi_acc_operation
+		operation_list[IMGU_ABI_SHD_MAX_OPERATIONS] __attribute__((aligned(32)));
+	struct imgu_abi_acc_process_lines_cmd_data
+		process_lines_data[IMGU_ABI_SHD_MAX_PROCESS_LINES] __attribute__((aligned(32)));
+	struct imgu_abi_shd_transfer_luts_set_data
+		transfer_data[IMGU_ABI_SHD_MAX_TRANSFERS] __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_shd_config {
+	struct ipu3_uapi_shd_config_static shd __attribute__((aligned(32)));
+	struct imgu_abi_shd_intra_frame_operations_data shd_ops __attribute__((aligned(32)));
+	struct ipu3_uapi_shd_lut shd_lut __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_stripe_input_frame_resolution {
+	u16 width;
+	u16 height;
+	u32 bayer_order;		/* enum ipu3_uapi_bayer_order */
+	u32 raw_bit_depth;
+} __packed;
+
+/* Stripe-based processing */
+
+struct imgu_abi_stripes {
+	/* offset from start of frame - measured in pixels */
+	u16 offset;
+	/* stripe width - measured in pixels */
+	u16 width;
+	/* stripe width - measured in pixels */
+	u16 height;
+} __packed;
+
+struct imgu_abi_stripe_data {
+	/*
+	 * number of stripes for current processing source
+	 * - VLIW binary parameter we currently support 1 or 2 stripes
+	 */
+	u16 num_of_stripes;
+
+	u8 padding[2];
+
+	/*
+	 * the following data is derived from resolution-related
+	 * pipe config and from num_of_stripes
+	 */
+
+	/*
+	 *'input-stripes' - before input cropping
+	 * used by input feeder
+	 */
+	struct imgu_abi_stripe_input_frame_resolution input_frame;
+
+	/*'effective-stripes' - after input cropping used dpc, bds */
+	struct imgu_abi_stripes effective_stripes[IPU3_UAPI_MAX_STRIPES];
+
+	/* 'down-scaled-stripes' - after down-scaling ONLY. used by BDS */
+	struct imgu_abi_stripes down_scaled_stripes[IPU3_UAPI_MAX_STRIPES];
+
+	/*
+	 *'bds-out-stripes' - after bayer down-scaling and padding.
+	 * used by all algos starting with norm up to the ref-frame for GDC
+	 * (currently up to the output kernel)
+	 */
+	struct imgu_abi_stripes bds_out_stripes[IPU3_UAPI_MAX_STRIPES];
+
+	/* 'bds-out-stripes (no overlap)' - used for ref kernel */
+	struct imgu_abi_stripes
+			bds_out_stripes_no_overlap[IPU3_UAPI_MAX_STRIPES];
+
+	/*
+	 * input resolution for output system (equal to bds_out - envelope)
+	 * output-system input frame width as configured by user
+	 */
+	u16 output_system_in_frame_width;
+	/* output-system input frame height as configured by user */
+	u16 output_system_in_frame_height;
+
+	/*
+	 * 'output-stripes' - accounts for stiching on the output (no overlap)
+	 * used by the output kernel
+	 */
+	struct imgu_abi_stripes output_stripes[IPU3_UAPI_MAX_STRIPES];
+
+	/*
+	 * 'block-stripes' - accounts for stiching by the output system
+	 * (1 or more blocks overlap)
+	 * used by DVS, TNR and the output system kernel
+	 */
+	struct imgu_abi_stripes block_stripes[IPU3_UAPI_MAX_STRIPES];
+
+	u16 effective_frame_width;	/* Needed for vertical cropping */
+	u16 bds_frame_width;
+	u16 out_frame_width;	/* Output frame width as configured by user */
+	u16 out_frame_height;	/* Output frame height as configured by user */
+
+	/* GDC in buffer (A.K.A delay frame,ref buffer) info */
+	u16 gdc_in_buffer_width;	/* GDC in buffer width  */
+	u16 gdc_in_buffer_height;	/* GDC in buffer height */
+	/* GDC in buffer first valid pixel x offset */
+	u16 gdc_in_buffer_offset_x;
+	/* GDC in buffer first valid pixel y offset */
+	u16 gdc_in_buffer_offset_y;
+
+	/* Display frame width as configured by user */
+	u16 display_frame_width;
+	/* Display frame height as configured by user */
+	u16 display_frame_height;
+	u16 bds_aligned_frame_width;
+	/* Number of vectors to left-crop when writing stripes (not stripe 0) */
+	u16 half_overlap_vectors;
+	/* Decimate ISP and fixed func resolutions after BDS (ir_extraction) */
+	u16 ir_ext_decimation;
+	u8 padding1[2];
+} __packed;
+
+/* Input feeder related structs */
+
+struct imgu_abi_input_feeder_data {
+	u32 row_stride;			/* row stride */
+	u32 start_row_address;		/* start row address */
+	u32 start_pixel;		/* start pixel */
+} __packed;
+
+struct imgu_abi_input_feeder_data_aligned {
+	struct imgu_abi_input_feeder_data data __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_input_feeder_data_per_stripe {
+	struct imgu_abi_input_feeder_data_aligned
+		input_feeder_data[IPU3_UAPI_MAX_STRIPES];
+} __packed;
+
+struct imgu_abi_input_feeder_config {
+	struct imgu_abi_input_feeder_data data;
+	struct imgu_abi_input_feeder_data_per_stripe data_per_stripe
+		__attribute__((aligned(32)));
+} __packed;
+
+/* DVS related definitions */
+
+struct imgu_abi_dvs_stat_grd_config {
+	u8 grid_width;
+	u8 grid_height;
+	u8 block_width;
+	u8 block_height;
+	u16 x_start;
+	u16 y_start;
+	u16 enable;
+	u16 x_end;
+	u16 y_end;
+} __packed;
+
+struct imgu_abi_dvs_stat_cfg {
+	u8 __reserved0[4];
+	struct imgu_abi_dvs_stat_grd_config
+					grd_config[IMGU_ABI_DVS_STAT_LEVELS];
+	u8 __reserved1[18];
+} __packed;
+
+struct imgu_abi_dvs_stat_transfer_op_data {
+	u8 set_number;
+} __packed;
+
+struct imgu_abi_dvs_stat_intra_frame_operations_data {
+	struct imgu_abi_acc_operation
+		ops[IMGU_ABI_DVS_STAT_MAX_OPERATIONS] __attribute__((aligned(32)));
+	struct imgu_abi_acc_process_lines_cmd_data
+		process_lines_data[IMGU_ABI_DVS_STAT_MAX_PROCESS_LINES]
+		__attribute__((aligned(32)));
+	struct imgu_abi_dvs_stat_transfer_op_data
+		transfer_data[IMGU_ABI_DVS_STAT_MAX_TRANSFERS] __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_dvs_stat_config {
+	struct imgu_abi_dvs_stat_cfg cfg __attribute__((aligned(32)));
+	u8 __reserved0[128];
+	struct imgu_abi_dvs_stat_intra_frame_operations_data operations_data;
+	u8 __reserved1[64];
+} __packed;
+
+/* Y-tone Mapping */
+
+struct imgu_abi_yuvp2_y_tm_lut_static_config {
+	u16 entries[IMGU_ABI_YUVP2_YTM_LUT_ENTRIES];
+	u32 enable;
+} __packed;
+
+/* Output formatter related structs */
+
+struct imgu_abi_osys_formatter_params {
+	u32 format;
+	u32 flip;
+	u32 mirror;
+	u32 tiling;
+	u32 reduce_range;
+	u32 alpha_blending;
+	u32 release_inp_addr;
+	u32 release_inp_en;
+	u32 process_out_buf_addr;
+	u32 image_width_vecs;
+	u32 image_height_lines;
+	u32 inp_buff_y_st_addr;
+	u32 inp_buff_y_line_stride;
+	u32 inp_buff_y_buffer_stride;
+	u32 int_buff_u_st_addr;
+	u32 int_buff_v_st_addr;
+	u32 inp_buff_uv_line_stride;
+	u32 inp_buff_uv_buffer_stride;
+	u32 out_buff_level;
+	u32 out_buff_nr_y_lines;
+	u32 out_buff_u_st_offset;
+	u32 out_buff_v_st_offset;
+	u32 out_buff_y_line_stride;
+	u32 out_buff_uv_line_stride;
+	u32 hist_buff_st_addr;
+	u32 hist_buff_line_stride;
+	u32 hist_buff_nr_lines;
+} __packed;
+
+struct imgu_abi_osys_formatter {
+	struct imgu_abi_osys_formatter_params param __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_osys_scaler_params {
+	u32 inp_buf_y_st_addr;
+	u32 inp_buf_y_line_stride;
+	u32 inp_buf_y_buffer_stride;
+	u32 inp_buf_u_st_addr;
+	u32 inp_buf_v_st_addr;
+	u32 inp_buf_uv_line_stride;
+	u32 inp_buf_uv_buffer_stride;
+	u32 inp_buf_chunk_width;
+	u32 inp_buf_nr_buffers;
+	/* Output buffers */
+	u32 out_buf_y_st_addr;
+	u32 out_buf_y_line_stride;
+	u32 out_buf_y_buffer_stride;
+	u32 out_buf_u_st_addr;
+	u32 out_buf_v_st_addr;
+	u32 out_buf_uv_line_stride;
+	u32 out_buf_uv_buffer_stride;
+	u32 out_buf_nr_buffers;
+	/* Intermediate buffers */
+	u32 int_buf_y_st_addr;
+	u32 int_buf_y_line_stride;
+	u32 int_buf_u_st_addr;
+	u32 int_buf_v_st_addr;
+	u32 int_buf_uv_line_stride;
+	u32 int_buf_height;
+	u32 int_buf_chunk_width;
+	u32 int_buf_chunk_height;
+	/* Context buffers */
+	u32 ctx_buf_hor_y_st_addr;
+	u32 ctx_buf_hor_u_st_addr;
+	u32 ctx_buf_hor_v_st_addr;
+	u32 ctx_buf_ver_y_st_addr;
+	u32 ctx_buf_ver_u_st_addr;
+	u32 ctx_buf_ver_v_st_addr;
+	/* Addresses for release-input and process-output tokens */
+	u32 release_inp_buf_addr;
+	u32 release_inp_buf_en;
+	u32 release_out_buf_en;
+	u32 process_out_buf_addr;
+	/* Settings dimensions, padding, cropping */
+	u32 input_image_y_width;
+	u32 input_image_y_height;
+	u32 input_image_y_start_column;
+	u32 input_image_uv_start_column;
+	u32 input_image_y_left_pad;
+	u32 input_image_uv_left_pad;
+	u32 input_image_y_right_pad;
+	u32 input_image_uv_right_pad;
+	u32 input_image_y_top_pad;
+	u32 input_image_uv_top_pad;
+	u32 input_image_y_bottom_pad;
+	u32 input_image_uv_bottom_pad;
+	u32 processing_mode;	/* enum imgu_abi_osys_procmode */
+	u32 scaling_ratio;
+	u32 y_left_phase_init;
+	u32 uv_left_phase_init;
+	u32 y_top_phase_init;
+	u32 uv_top_phase_init;
+	u32 coeffs_exp_shift;
+	u32 out_y_left_crop;
+	u32 out_uv_left_crop;
+	u32 out_y_top_crop;
+	u32 out_uv_top_crop;
+} __packed;
+
+struct imgu_abi_osys_scaler {
+	struct imgu_abi_osys_scaler_params param __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_osys_frame_params {
+	/* Output pins */
+	u32 enable;
+	u32 format;		/* enum imgu_abi_osys_format */
+	u32 flip;
+	u32 mirror;
+	u32 tiling;		/* enum imgu_abi_osys_tiling */
+	u32 width;
+	u32 height;
+	u32 stride;
+	u32 scaled;
+} __packed;
+
+struct imgu_abi_osys_frame {
+	struct imgu_abi_osys_frame_params param __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_osys_stripe {
+	/* Input resolution */
+	u32 input_width;
+	u32 input_height;
+	/* Output Stripe */
+	u32 output_width[IMGU_ABI_OSYS_PINS];
+	u32 output_height[IMGU_ABI_OSYS_PINS];
+	u32 output_offset[IMGU_ABI_OSYS_PINS];
+	u32 buf_stride[IMGU_ABI_OSYS_PINS];
+	/* Scaler params */
+	u32 block_width;
+	u32 block_height;
+	/* Output Crop factor */
+	u32 crop_top[IMGU_ABI_OSYS_PINS];
+	u32 crop_left[IMGU_ABI_OSYS_PINS];
+} __packed;
+
+struct imgu_abi_osys_config {
+	struct imgu_abi_osys_formatter
+		formatter[IPU3_UAPI_MAX_STRIPES][IMGU_ABI_OSYS_PINS];
+	struct imgu_abi_osys_scaler scaler[IPU3_UAPI_MAX_STRIPES];
+	struct imgu_abi_osys_frame frame[IMGU_ABI_OSYS_PINS];
+	struct imgu_abi_osys_stripe stripe[IPU3_UAPI_MAX_STRIPES];
+	/* 32 packed coefficients for luma and chroma */
+	s8 scaler_coeffs_chroma[128];
+	s8 scaler_coeffs_luma[128];
+} __packed;
+
+/* BDS */
+
+struct imgu_abi_bds_hor_ctrl0 {
+	u32 sample_patrn_length:9;
+	u32 __reserved0:3;
+	u32 hor_ds_en:1;
+	u32 min_clip_val:1;
+	u32 max_clip_val:2;
+	u32 out_frame_width:13;
+	u32 __reserved1:3;
+} __packed;
+
+struct imgu_abi_bds_ptrn_arr {
+	u32 elems[IMGU_ABI_BDS_SAMPLE_PATTERN_ARRAY_SIZE];
+} __packed;
+
+struct imgu_abi_bds_phase_entry {
+	s8 coeff_min2;
+	s8 coeff_min1;
+	s8 coeff_0;
+	s8 nf;
+	s8 coeff_pls1;
+	s8 coeff_pls2;
+	s8 coeff_pls3;
+	u8 __reserved;
+} __packed;
+
+struct imgu_abi_bds_phase_arr {
+	struct imgu_abi_bds_phase_entry
+		even[IMGU_ABI_BDS_PHASE_COEFFS_ARRAY_SIZE];
+	struct imgu_abi_bds_phase_entry
+		odd[IMGU_ABI_BDS_PHASE_COEFFS_ARRAY_SIZE];
+} __packed;
+
+struct imgu_abi_bds_hor_ctrl1 {
+	u32 hor_crop_start:13;
+	u32 __reserved0:3;
+	u32 hor_crop_end:13;
+	u32 __reserved1:1;
+	u32 hor_crop_en:1;
+	u32 __reserved2:1;
+} __packed;
+
+struct imgu_abi_bds_hor_ctrl2 {
+	u32 input_frame_height:13;
+	u32 __reserved0:19;
+} __packed;
+
+struct imgu_abi_bds_hor {
+	struct imgu_abi_bds_hor_ctrl0 hor_ctrl0;
+	struct imgu_abi_bds_ptrn_arr hor_ptrn_arr;
+	struct imgu_abi_bds_phase_arr hor_phase_arr;
+	struct imgu_abi_bds_hor_ctrl1 hor_ctrl1;
+	struct imgu_abi_bds_hor_ctrl2 hor_ctrl2;
+} __packed;
+
+struct imgu_abi_bds_ver_ctrl0 {
+	u32 sample_patrn_length:9;
+	u32 __reserved0:3;
+	u32 ver_ds_en:1;
+	u32 min_clip_val:1;
+	u32 max_clip_val:2;
+	u32 __reserved1:16;
+} __packed;
+
+struct imgu_abi_bds_ver_ctrl1 {
+	u32 out_frame_width:13;
+	u32 __reserved0:3;
+	u32 out_frame_height:13;
+	u32 __reserved1:3;
+} __packed;
+
+struct imgu_abi_bds_ver {
+	struct imgu_abi_bds_ver_ctrl0 ver_ctrl0;
+	struct imgu_abi_bds_ptrn_arr ver_ptrn_arr;
+	struct imgu_abi_bds_phase_arr ver_phase_arr;
+	struct imgu_abi_bds_ver_ctrl1 ver_ctrl1;
+} __packed;
+
+struct imgu_abi_bds_per_stripe_data {
+	struct imgu_abi_bds_hor_ctrl0 hor_ctrl0;
+	struct imgu_abi_bds_ver_ctrl1 ver_ctrl1;
+	struct imgu_abi_bds_hor_ctrl1 crop;
+} __packed;
+
+struct imgu_abi_bds_per_stripe_data_aligned {
+	struct imgu_abi_bds_per_stripe_data data __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_bds_per_stripe {
+	struct imgu_abi_bds_per_stripe_data_aligned
+		aligned_data[IPU3_UAPI_MAX_STRIPES];
+} __packed;
+
+struct imgu_abi_bds_config {
+	struct imgu_abi_bds_hor hor __attribute__((aligned(32)));
+	struct imgu_abi_bds_ver ver __attribute__((aligned(32)));
+	struct imgu_abi_bds_per_stripe per_stripe __attribute__((aligned(32)));
+	u32 enabled;
+} __packed;
+
+/* ANR */
+
+struct imgu_abi_anr_search_config {
+	u32 enable;
+	u16 frame_width;
+	u16 frame_height;
+} __packed;
+
+struct imgu_abi_anr_stitch_config {
+	u32 anr_stitch_en;
+	u16 frame_width;
+	u16 frame_height;
+	u8 __reserved[40];
+	struct ipu3_uapi_anr_stitch_pyramid pyramid[IPU3_UAPI_ANR_PYRAMID_SIZE];
+} __packed;
+
+struct imgu_abi_anr_tile2strm_config {
+	u32 enable;
+	u16 frame_width;
+	u16 frame_height;
+} __packed;
+
+struct imgu_abi_anr_config {
+	struct imgu_abi_anr_search_config search __attribute__((aligned(32)));
+	struct ipu3_uapi_anr_transform_config transform __attribute__((aligned(32)));
+	struct imgu_abi_anr_stitch_config stitch __attribute__((aligned(32)));
+	struct imgu_abi_anr_tile2strm_config tile2strm __attribute__((aligned(32)));
+} __packed;
+
+/* AF */
+
+struct imgu_abi_af_frame_size {
+	u16 width;
+	u16 height;
+} __packed;
+
+struct imgu_abi_af_config_s {
+	struct ipu3_uapi_af_filter_config filter_config __attribute__((aligned(32)));
+	struct imgu_abi_af_frame_size frame_size;
+	struct ipu3_uapi_grid_config grid_cfg __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_af_intra_frame_operations_data {
+	struct imgu_abi_acc_operation ops[IMGU_ABI_AF_MAX_OPERATIONS]
+		__attribute__((aligned(32)));
+	struct imgu_abi_acc_process_lines_cmd_data
+		process_lines_data[IMGU_ABI_AF_MAX_PROCESS_LINES] __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_af_stripe_config {
+	struct imgu_abi_af_frame_size frame_size __attribute__((aligned(32)));
+	struct ipu3_uapi_grid_config grid_cfg __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_af_config {
+	struct imgu_abi_af_config_s config;
+	struct imgu_abi_af_intra_frame_operations_data operations_data;
+	struct imgu_abi_af_stripe_config stripes[IPU3_UAPI_MAX_STRIPES];
+} __packed;
+
+/* AE */
+
+struct imgu_abi_ae_config {
+	struct ipu3_uapi_ae_grid_config grid_cfg __attribute__((aligned(32)));
+	struct ipu3_uapi_ae_weight_elem weights[IPU3_UAPI_AE_WEIGHTS]
+								__attribute__((aligned(32)));
+	struct ipu3_uapi_ae_ccm ae_ccm __attribute__((aligned(32)));
+	struct {
+		struct ipu3_uapi_ae_grid_config grid __attribute__((aligned(32)));
+	} stripes[IPU3_UAPI_MAX_STRIPES];
+} __packed;
+
+/* AWB_FR */
+
+struct imgu_abi_awb_fr_intra_frame_operations_data {
+	struct imgu_abi_acc_operation ops[IMGU_ABI_AWB_FR_MAX_OPERATIONS]
+								__attribute__((aligned(32)));
+	struct imgu_abi_acc_process_lines_cmd_data
+	      process_lines_data[IMGU_ABI_AWB_FR_MAX_PROCESS_LINES] __attribute__((aligned(32)));
+} __packed;
+
+struct imgu_abi_awb_fr_config {
+	struct ipu3_uapi_awb_fr_config_s config;
+	struct imgu_abi_awb_fr_intra_frame_operations_data operations_data;
+	struct ipu3_uapi_awb_fr_config_s stripes[IPU3_UAPI_MAX_STRIPES];
+} __packed;
+
+struct imgu_abi_acc_transfer_op_data {
+	u8 set_number;
+} __packed;
+
+struct imgu_abi_awb_intra_frame_operations_data {
+	struct imgu_abi_acc_operation ops[IMGU_ABI_AWB_MAX_OPERATIONS]
+		__attribute__((aligned(32)));
+	struct imgu_abi_acc_process_lines_cmd_data
+		process_lines_data[IMGU_ABI_AWB_MAX_PROCESS_LINES] __attribute__((aligned(32)));
+	struct imgu_abi_acc_transfer_op_data
+		transfer_data[IMGU_ABI_AWB_MAX_TRANSFERS] __attribute__((aligned(32)));
+} __attribute__((aligned(32))) __packed;
+
+struct imgu_abi_awb_config {
+	struct ipu3_uapi_awb_config_s config __attribute__((aligned(32)));
+	struct imgu_abi_awb_intra_frame_operations_data operations_data;
+	struct ipu3_uapi_awb_config_s stripes[IPU3_UAPI_MAX_STRIPES];
+} __packed;
+
+struct imgu_abi_acc_param {
+	struct imgu_abi_stripe_data stripe;
+	u8 padding[8];
+	struct imgu_abi_input_feeder_config input_feeder;
+	struct ipu3_uapi_bnr_static_config bnr;
+	struct ipu3_uapi_bnr_static_config_green_disparity green_disparity
+		__attribute__((aligned(32)));
+	struct ipu3_uapi_dm_config dm __attribute__((aligned(32)));
+	struct ipu3_uapi_ccm_mat_config ccm __attribute__((aligned(32)));
+	struct ipu3_uapi_gamma_config gamma __attribute__((aligned(32)));
+	struct ipu3_uapi_csc_mat_config csc __attribute__((aligned(32)));
+	struct ipu3_uapi_cds_params cds __attribute__((aligned(32)));
+	struct imgu_abi_shd_config shd __attribute__((aligned(32)));
+	struct imgu_abi_dvs_stat_config dvs_stat;
+	u8 padding1[224];	/* reserved for lace_stat */
+	struct ipu3_uapi_yuvp1_iefd_config iefd __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp1_yds_config yds_c0 __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp1_chnr_config chnr_c0 __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp1_y_ee_nr_config y_ee_nr __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp1_yds_config yds __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp1_chnr_config chnr __attribute__((aligned(32)));
+	struct imgu_abi_yuvp2_y_tm_lut_static_config ytm __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp1_yds_config yds2 __attribute__((aligned(32)));
+	struct ipu3_uapi_yuvp2_tcc_static_config tcc __attribute__((aligned(32)));
+	/* reserved for defect pixel correction */
+	u8 dpc[240832] __attribute__((aligned(32)));
+	struct imgu_abi_bds_config bds;
+	struct imgu_abi_anr_config anr;
+	struct imgu_abi_awb_fr_config awb_fr;
+	struct imgu_abi_ae_config ae;
+	struct imgu_abi_af_config af;
+	struct imgu_abi_awb_config awb;
+	struct imgu_abi_osys_config osys;
+} __packed;
+
+/***** Morphing table entry *****/
+
+struct imgu_abi_gdc_warp_param {
+	u32 origin_x;
+	u32 origin_y;
+	u32 in_addr_offset;
+	u32 in_block_width;
+	u32 in_block_height;
+	u32 p0_x;
+	u32 p0_y;
+	u32 p1_x;
+	u32 p1_y;
+	u32 p2_x;
+	u32 p2_y;
+	u32 p3_x;
+	u32 p3_y;
+	u32 in_block_width_a;
+	u32 in_block_width_b;
+	u32 padding;		/* struct size multiple of DDR word */
+} __packed;
+
+/******************* Firmware ABI definitions *******************/
+
+/***** struct imgu_abi_sp_stage *****/
+
+struct imgu_abi_crop_pos {
+	u16 x;
+	u16 y;
+} __packed;
+
+struct imgu_abi_sp_resolution {
+	u16 width;			/* Width of valid data in pixels */
+	u16 height;			/* Height of valid data in lines */
+} __packed;
+
+/*
+ * Frame info struct. This describes the contents of an image frame buffer.
+ */
+struct imgu_abi_frame_sp_info {
+	struct imgu_abi_sp_resolution res;
+	u16 padded_width;		/* stride of line in memory
+					 * (in pixels)
+					 */
+	u8 format;			/* format of the frame data */
+	u8 raw_bit_depth;		/* number of valid bits per pixel,
+					 * only valid for RAW bayer frames
+					 */
+	u8 raw_bayer_order;		/* bayer order, only valid
+					 * for RAW bayer frames
+					 */
+	u8 raw_type;		/* To choose the proper raw frame type. for
+				 * Legacy SKC pipes/Default is set to
+				 * IMGU_ABI_RAW_TYPE_BAYER. For RGB IR sensor -
+				 * driver should set it to:
+				 * IronGr case - IMGU_ABI_RAW_TYPE_IR_ON_GR
+				 * IronGb case - IMGU_ABI_RAW_TYPE_IR_ON_GB
+				 */
+	u8 padding[2];			/* Extend to 32 bit multiple */
+} __packed;
+
+struct imgu_abi_buffer_sp {
+	union {
+		imgu_addr_t xmem_addr;
+		s32 queue_id;	/* enum imgu_abi_queue_id */
+	} buf_src;
+	s32 buf_type;	/* enum imgu_abi_buffer_type */
+} __packed;
+
+struct imgu_abi_frame_sp_plane {
+	u32 offset;		/* offset in bytes to start of frame data */
+				/* offset is wrt data in imgu_abi_sp_sp_frame */
+} __packed;
+
+struct imgu_abi_frame_sp_rgb_planes {
+	struct imgu_abi_frame_sp_plane r;
+	struct imgu_abi_frame_sp_plane g;
+	struct imgu_abi_frame_sp_plane b;
+} __packed;
+
+struct imgu_abi_frame_sp_yuv_planes {
+	struct imgu_abi_frame_sp_plane y;
+	struct imgu_abi_frame_sp_plane u;
+	struct imgu_abi_frame_sp_plane v;
+} __packed;
+
+struct imgu_abi_frame_sp_nv_planes {
+	struct imgu_abi_frame_sp_plane y;
+	struct imgu_abi_frame_sp_plane uv;
+} __packed;
+
+struct imgu_abi_frame_sp_plane6 {
+	struct imgu_abi_frame_sp_plane r;
+	struct imgu_abi_frame_sp_plane r_at_b;
+	struct imgu_abi_frame_sp_plane gr;
+	struct imgu_abi_frame_sp_plane gb;
+	struct imgu_abi_frame_sp_plane b;
+	struct imgu_abi_frame_sp_plane b_at_r;
+} __packed;
+
+struct imgu_abi_frame_sp_binary_plane {
+	u32 size;
+	struct imgu_abi_frame_sp_plane data;
+} __packed;
+
+struct imgu_abi_frame_sp {
+	struct imgu_abi_frame_sp_info info;
+	struct imgu_abi_buffer_sp buf_attr;
+	union {
+		struct imgu_abi_frame_sp_plane raw;
+		struct imgu_abi_frame_sp_plane rgb;
+		struct imgu_abi_frame_sp_rgb_planes planar_rgb;
+		struct imgu_abi_frame_sp_plane yuyv;
+		struct imgu_abi_frame_sp_yuv_planes yuv;
+		struct imgu_abi_frame_sp_nv_planes nv;
+		struct imgu_abi_frame_sp_plane6 plane6;
+		struct imgu_abi_frame_sp_binary_plane binary;
+	} planes;
+} __packed;
+
+struct imgu_abi_resolution {
+	u32 width;
+	u32 height;
+} __packed;
+
+struct imgu_abi_frames_sp {
+	struct imgu_abi_frame_sp in;
+	struct imgu_abi_frame_sp out[IMGU_ABI_BINARY_MAX_OUTPUT_PORTS];
+	struct imgu_abi_resolution effective_in_res;
+	struct imgu_abi_frame_sp out_vf;
+	struct imgu_abi_frame_sp_info internal_frame_info;
+	struct imgu_abi_buffer_sp s3a_buf;
+	struct imgu_abi_buffer_sp dvs_buf;
+	struct imgu_abi_buffer_sp lace_buf;
+} __packed;
+
+struct imgu_abi_uds_info {
+	u16 curr_dx;
+	u16 curr_dy;
+	u16 xc;
+	u16 yc;
+} __packed;
+
+/* Information for a single pipeline stage */
+struct imgu_abi_sp_stage {
+	/* Multiple boolean flags can be stored in an integer */
+	u8 num;			/* Stage number */
+	u8 isp_online;
+	u8 isp_copy_vf;
+	u8 isp_copy_output;
+	u8 sp_enable_xnr;
+	u8 isp_deci_log_factor;
+	u8 isp_vf_downscale_bits;
+	u8 deinterleaved;
+	/*
+	 * NOTE: Programming the input circuit can only be done at the
+	 * start of a session. It is illegal to program it during execution
+	 * The input circuit defines the connectivity
+	 */
+	u8 program_input_circuit;
+	u8 func;
+	u8 stage_type;		/* enum imgu_abi_stage_type */
+	u8 num_stripes;
+	u8 isp_pipe_version;
+	struct {
+		u8 vf_output;
+		u8 s3a;
+		u8 sdis;
+		u8 dvs_stats;
+		u8 lace_stats;
+	} enable;
+
+	struct imgu_abi_crop_pos sp_out_crop_pos;
+	u8 padding[2];
+	struct imgu_abi_frames_sp frames;
+	struct imgu_abi_resolution dvs_envelope;
+	struct imgu_abi_uds_info uds;
+	imgu_addr_t isp_stage_addr;
+	imgu_addr_t xmem_bin_addr;
+	imgu_addr_t xmem_map_addr;
+
+	u16 top_cropping;
+	u16 row_stripes_height;
+	u16 row_stripes_overlap_lines;
+	u8 if_config_index;	/* Which should be applied by this stage. */
+	u8 padding2;
+} __packed;
+
+/***** struct imgu_abi_isp_stage *****/
+
+struct imgu_abi_isp_param_memory_offsets {
+	u32 offsets[IMGU_ABI_PARAM_CLASS_NUM];	/* offset wrt hdr in bytes */
+} __packed;
+
+/*
+ * Blob descriptor.
+ * This structure describes an SP or ISP blob.
+ * It describes the test, data and bss sections as well as position in a
+ * firmware file.
+ * For convenience, it contains dynamic data after loading.
+ */
+struct imgu_abi_blob_info {
+	/* Static blob data */
+	u32 offset;			/* Blob offset in fw file */
+	struct imgu_abi_isp_param_memory_offsets memory_offsets;
+					/* offset wrt hdr in bytes */
+	u32 prog_name_offset;		/* offset wrt hdr in bytes */
+	u32 size;			/* Size of blob */
+	u32 padding_size;		/* total cummulative of bytes added
+					 * due to section alignment
+					 */
+	u32 icache_source;		/* Position of icache in blob */
+	u32 icache_size;		/* Size of icache section */
+	u32 icache_padding;	/* added due to icache section alignment */
+	u32 text_source;		/* Position of text in blob */
+	u32 text_size;			/* Size of text section */
+	u32 text_padding;	/* bytes added due to text section alignment */
+	u32 data_source;		/* Position of data in blob */
+	u32 data_target;		/* Start of data in SP dmem */
+	u32 data_size;			/* Size of text section */
+	u32 data_padding;	/* bytes added due to data section alignment */
+	u32 bss_target;		/* Start position of bss in SP dmem */
+	u32 bss_size;			/* Size of bss section
+					 * Dynamic data filled by loader
+					 */
+	u64 code __attribute__((aligned(8)));	/* Code section absolute pointer */
+					/* within fw, code = icache + text */
+	u64 data __attribute__((aligned(8)));	/* Data section absolute pointer */
+					/* within fw, data = data + bss */
+} __packed;
+
+struct imgu_abi_binary_pipeline_info {
+	u32 mode;
+	u32 isp_pipe_version;
+	u32 pipelining;
+	u32 c_subsampling;
+	u32 top_cropping;
+	u32 left_cropping;
+	u32 variable_resolution;
+} __packed;
+
+struct imgu_abi_binary_input_info {
+	u32 min_width;
+	u32 min_height;
+	u32 max_width;
+	u32 max_height;
+	u32 source;	/* enum imgu_abi_bin_input_src */
+} __packed;
+
+struct imgu_abi_binary_output_info {
+	u32 min_width;
+	u32 min_height;
+	u32 max_width;
+	u32 max_height;
+	u32 num_chunks;
+	u32 variable_format;
+} __packed;
+
+struct imgu_abi_binary_internal_info {
+	u32 max_width;
+	u32 max_height;
+} __packed;
+
+struct imgu_abi_binary_bds_info {
+	u32 supported_bds_factors;
+} __packed;
+
+struct imgu_abi_binary_dvs_info {
+	u32 max_envelope_width;
+	u32 max_envelope_height;
+} __packed;
+
+struct imgu_abi_binary_vf_dec_info {
+	u32 is_variable;
+	u32 max_log_downscale;
+} __packed;
+
+struct imgu_abi_binary_s3a_info {
+	u32 s3atbl_use_dmem;
+	u32 fixed_s3a_deci_log;
+} __packed;
+
+struct imgu_abi_binary_dpc_info {
+	u32 bnr_lite;			/* bnr lite enable flag */
+} __packed;
+
+struct imgu_abi_binary_iterator_info {
+	u32 num_stripes;
+	u32 row_stripes_height;
+	u32 row_stripes_overlap_lines;
+} __packed;
+
+struct imgu_abi_binary_address_info {
+	u32 isp_addresses;		/* Address in ISP dmem */
+	u32 main_entry;			/* Address of entry fct */
+	u32 in_frame;			/* Address in ISP dmem */
+	u32 out_frame;			/* Address in ISP dmem */
+	u32 in_data;			/* Address in ISP dmem */
+	u32 out_data;			/* Address in ISP dmem */
+	u32 sh_dma_cmd_ptr;		/* In ISP dmem */
+} __packed;
+
+struct imgu_abi_binary_uds_info {
+	u16 bpp;
+	u16 use_bci;
+	u16 use_str;
+	u16 woix;
+	u16 woiy;
+	u16 extra_out_vecs;
+	u16 vectors_per_line_in;
+	u16 vectors_per_line_out;
+	u16 vectors_c_per_line_in;
+	u16 vectors_c_per_line_out;
+	u16 vmem_gdc_in_block_height_y;
+	u16 vmem_gdc_in_block_height_c;
+} __packed;
+
+struct imgu_abi_binary_block_info {
+	u32 block_width;
+	u32 block_height;
+	u32 output_block_height;
+} __packed;
+
+struct imgu_abi_isp_data {
+	imgu_addr_t address;		/* ISP address */
+	u32 size;			/* Disabled if 0 */
+} __packed;
+
+struct imgu_abi_isp_param_segments {
+	struct imgu_abi_isp_data
+			params[IMGU_ABI_PARAM_CLASS_NUM][IMGU_ABI_NUM_MEMORIES];
+} __packed;
+
+struct imgu_abi_binary_info {
+	u32 id __attribute__((aligned(8)));		/* IMGU_ABI_BINARY_ID_* */
+	struct imgu_abi_binary_pipeline_info pipeline;
+	struct imgu_abi_binary_input_info input;
+	struct imgu_abi_binary_output_info output;
+	struct imgu_abi_binary_internal_info internal;
+	struct imgu_abi_binary_bds_info bds;
+	struct imgu_abi_binary_dvs_info dvs;
+	struct imgu_abi_binary_vf_dec_info vf_dec;
+	struct imgu_abi_binary_s3a_info s3a;
+	struct imgu_abi_binary_dpc_info dpc_bnr; /* DPC related binary info */
+	struct imgu_abi_binary_iterator_info iterator;
+	struct imgu_abi_binary_address_info addresses;
+	struct imgu_abi_binary_uds_info uds;
+	struct imgu_abi_binary_block_info block;
+	struct imgu_abi_isp_param_segments mem_initializers;
+	struct {
+		u8 input_feeder;
+		u8 output_system;
+		u8 obgrid;
+		u8 lin;
+		u8 dpc_acc;
+		u8 bds_acc;
+		u8 shd_acc;
+		u8 shd_ff;
+		u8 stats_3a_raw_buffer;
+		u8 acc_bayer_denoise;
+		u8 bnr_ff;
+		u8 awb_acc;
+		u8 awb_fr_acc;
+		u8 anr_acc;
+		u8 rgbpp_acc;
+		u8 rgbpp_ff;
+		u8 demosaic_acc;
+		u8 demosaic_ff;
+		u8 dvs_stats;
+		u8 lace_stats;
+		u8 yuvp1_b0_acc;
+		u8 yuvp1_c0_acc;
+		u8 yuvp2_acc;
+		u8 ae;
+		u8 af;
+		u8 dergb;
+		u8 rgb2yuv;
+		u8 high_quality;
+		u8 kerneltest;
+		u8 routing_shd_to_bnr;		/* connect SHD with BNR ACCs */
+		u8 routing_bnr_to_anr;		/* connect BNR with ANR ACCs */
+		u8 routing_anr_to_de;		/* connect ANR with DE ACCs */
+		u8 routing_rgb_to_yuvp1;	/* connect RGB with YUVP1 */
+		u8 routing_yuvp1_to_yuvp2;	/* connect YUVP1 with YUVP2 */
+		u8 luma_only;
+		u8 input_yuv;
+		u8 input_raw;
+		u8 reduced_pipe;
+		u8 vf_veceven;
+		u8 dis;
+		u8 dvs_envelope;
+		u8 uds;
+		u8 dvs_6axis;
+		u8 block_output;
+		u8 streaming_dma;
+		u8 ds;
+		u8 bayer_fir_6db;
+		u8 raw_binning;
+		u8 continuous;
+		u8 s3a;
+		u8 fpnr;
+		u8 sc;
+		u8 macc;
+		u8 output;
+		u8 ref_frame;
+		u8 tnr;
+		u8 xnr;
+		u8 params;
+		u8 ca_gdc;
+		u8 isp_addresses;
+		u8 in_frame;
+		u8 out_frame;
+		u8 high_speed;
+		u8 dpc;
+		u8 padding[2];
+		u8 rgbir;
+	} enable;
+	struct {
+		u8 ref_y_channel;
+		u8 ref_c_channel;
+		u8 tnr_channel;
+		u8 tnr_out_channel;
+		u8 dvs_coords_channel;
+		u8 output_channel;
+		u8 c_channel;
+		u8 vfout_channel;
+		u8 vfout_c_channel;
+		u8 vfdec_bits_per_pixel;
+		u8 claimed_by_isp;
+		u8 padding[2];
+	} dma;
+} __packed;
+
+struct imgu_abi_isp_stage {
+	struct imgu_abi_blob_info blob_info;
+	struct imgu_abi_binary_info binary_info;
+	char binary_name[IMGU_ABI_MAX_BINARY_NAME];
+	struct imgu_abi_isp_param_segments mem_initializers;
+} __packed;
+
+/***** struct imgu_abi_ddr_address_map and parameter set *****/
+
+/* xmem address map allocation */
+struct imgu_abi_ddr_address_map {
+	imgu_addr_t isp_mem_param[IMGU_ABI_MAX_STAGES][IMGU_ABI_NUM_MEMORIES];
+	imgu_addr_t obgrid_tbl[IPU3_UAPI_MAX_STRIPES];
+	imgu_addr_t acc_cluster_params_for_sp;
+	imgu_addr_t dvs_6axis_params_y;
+} __packed;
+
+struct imgu_abi_parameter_set_info {
+	/* Pointers to Parameters in ISP format IMPT */
+	struct imgu_abi_ddr_address_map mem_map;
+	/* Unique ID to track per-frame configurations */
+	u32 isp_parameters_id;
+	/* Output frame to which this config has to be applied (optional) */
+	imgu_addr_t output_frame_ptr;
+} __packed;
+
+/***** struct imgu_abi_sp_group *****/
+
+/* SP configuration information */
+struct imgu_abi_sp_config {
+	u8 no_isp_sync;		/* Signal host immediately after start */
+	u8 enable_raw_pool_locking;    /* Enable Raw Buffer Locking for HALv3 */
+	u8 lock_all;
+	u8 disable_cont_vf;
+	u8 disable_preview_on_capture;
+	u8 padding[3];
+} __packed;
+
+/* Information for a pipeline */
+struct imgu_abi_sp_pipeline {
+	u32 pipe_id;			/* the pipe ID */
+	u32 pipe_num;			/* the dynamic pipe number */
+	u32 thread_id;			/* the sp thread ID */
+	u32 pipe_config;		/* the pipe config */
+	u32 pipe_qos_config;		/* Bitmap of multiple QOS extension fw
+					 * state, 0xffffffff indicates non
+					 * QOS pipe.
+					 */
+	u32 inout_port_config;
+	u32 required_bds_factor;
+	u32 dvs_frame_delay;
+	u32 num_stages;		/* the pipe config */
+	u32 running;			/* needed for pipe termination */
+	imgu_addr_t sp_stage_addr[IMGU_ABI_MAX_STAGES];
+	imgu_addr_t scaler_pp_lut;	/* Early bound LUT */
+	u32 stage;			/* stage ptr is only used on sp */
+	s32 num_execs;			/* number of times to run if this is
+					 * an acceleration pipe.
+					 */
+	union {
+		struct {
+			u32 bytes_available;
+		} bin;
+		struct {
+			u32 height;
+			u32 width;
+			u32 padded_width;
+			u32 max_input_width;
+			u32 raw_bit_depth;
+		} raw;
+	} copy;
+
+	/* Parameters passed to Shading Correction kernel. */
+	struct {
+		/* Origin X (bqs) of internal frame on shading table */
+		u32 internal_frame_origin_x_bqs_on_sctbl;
+		/* Origin Y (bqs) of internal frame on shading table */
+		u32 internal_frame_origin_y_bqs_on_sctbl;
+	} shading;
+} __packed;
+
+struct imgu_abi_sp_debug_command {
+	/*
+	 * The DMA software-mask,
+	 *      Bit 31...24: unused.
+	 *      Bit 23...16: unused.
+	 *      Bit 15...08: reading-request enabling bits for DMA channel 7..0
+	 *      Bit 07...00: writing-request enabling bits for DMA channel 7..0
+	 *
+	 * For example, "0...0 0...0 11111011 11111101" indicates that the
+	 * writing request through DMA Channel 1 and the reading request
+	 * through DMA channel 2 are both disabled. The others are enabled.
+	 */
+	u32 dma_sw_reg;
+} __packed;
+
+/*
+ * Group all host initialized SP variables into this struct.
+ * This is initialized every stage through dma.
+ * The stage part itself is transferred through imgu_abi_sp_stage.
+ */
+struct imgu_abi_sp_group {
+	struct imgu_abi_sp_config config;
+	struct imgu_abi_sp_pipeline pipe[IMGU_ABI_MAX_SP_THREADS];
+	struct imgu_abi_sp_debug_command debug;
+} __packed;
+
+/***** parameter and state class binary configurations *****/
+
+struct imgu_abi_isp_iterator_config {
+	struct imgu_abi_frame_sp_info input_info;
+	struct imgu_abi_frame_sp_info internal_info;
+	struct imgu_abi_frame_sp_info output_info;
+	struct imgu_abi_frame_sp_info vf_info;
+	struct imgu_abi_sp_resolution dvs_envelope;
+} __packed;
+
+struct imgu_abi_dma_port_config {
+	u8 crop, elems;
+	u16 width;
+	u32 stride;
+} __packed;
+
+struct imgu_abi_isp_ref_config {
+	u32 width_a_over_b;
+	struct imgu_abi_dma_port_config port_b;
+	u32 ref_frame_addr_y[IMGU_ABI_FRAMES_REF];
+	u32 ref_frame_addr_c[IMGU_ABI_FRAMES_REF];
+	u32 dvs_frame_delay;
+} __packed;
+
+struct imgu_abi_isp_ref_dmem_state {
+	u32 ref_in_buf_idx;
+	u32 ref_out_buf_idx;
+} __packed;
+
+struct imgu_abi_isp_dvs_config {
+	u32 num_horizontal_blocks;
+	u32 num_vertical_blocks;
+} __packed;
+
+struct imgu_abi_isp_tnr3_config {
+	u32 width_a_over_b;
+	u32 frame_height;
+	struct imgu_abi_dma_port_config port_b;
+	u32 delay_frame;
+	u32 frame_addr[IMGU_ABI_FRAMES_TNR];
+} __packed;
+
+struct imgu_abi_isp_tnr3_dmem_state {
+	u32 in_bufidx;
+	u32 out_bufidx;
+	u32 total_frame_counter;
+	u32 buffer_frame_counter[IMGU_ABI_BUF_SETS_TNR];
+	u32 bypass_filter;
+} __packed;
+
+/***** Queues *****/
+
+struct imgu_abi_queue_info {
+	u8 size;		/* the maximum number of elements*/
+	u8 step;		/* number of bytes per element */
+	u8 start;		/* index of the oldest element */
+	u8 end;			/* index at which to write the new element */
+} __packed;
+
+struct imgu_abi_queues {
+	/*
+	 * Queues for the dynamic frame information,
+	 * i.e. the "in_frame" buffer, the "out_frame"
+	 * buffer and the "vf_out_frame" buffer.
+	 */
+	struct imgu_abi_queue_info host2sp_bufq_info
+			[IMGU_ABI_MAX_SP_THREADS][IMGU_ABI_QUEUE_NUM];
+	u32 host2sp_bufq[IMGU_ABI_MAX_SP_THREADS][IMGU_ABI_QUEUE_NUM]
+			[IMGU_ABI_HOST2SP_BUFQ_SIZE];
+	struct imgu_abi_queue_info sp2host_bufq_info[IMGU_ABI_QUEUE_NUM];
+	u32 sp2host_bufq[IMGU_ABI_QUEUE_NUM][IMGU_ABI_SP2HOST_BUFQ_SIZE];
+
+	/*
+	 * The queues for the events.
+	 */
+	struct imgu_abi_queue_info host2sp_evtq_info;
+	u32 host2sp_evtq[IMGU_ABI_HOST2SP_EVTQ_SIZE];
+	struct imgu_abi_queue_info sp2host_evtq_info;
+	u32 sp2host_evtq[IMGU_ABI_SP2HOST_EVTQ_SIZE];
+} __packed;
+
+/***** Buffer descriptor *****/
+
+struct imgu_abi_metadata_info {
+	struct imgu_abi_resolution resolution;	/* Resolution */
+	u32 stride;				/* Stride in bytes */
+	u32 size;				/* Total size in bytes */
+} __packed;
+
+struct imgu_abi_isp_3a_statistics {
+	union {
+		struct {
+			imgu_addr_t s3a_tbl;
+		} dmem;
+		struct {
+			imgu_addr_t s3a_tbl_hi;
+			imgu_addr_t s3a_tbl_lo;
+		} vmem;
+	} data;
+	struct {
+		imgu_addr_t rgby_tbl;
+	} data_hmem;
+	u32 exp_id;	/* exposure id, to match statistics to a frame, */
+	u32 isp_config_id;		/* Tracks per-frame configs */
+	imgu_addr_t data_ptr;		/* pointer to base of all data */
+	u32 size;			/* total size of all data */
+	u32 dmem_size;
+	u32 vmem_size;			/* both lo and hi have this size */
+	u32 hmem_size;
+} __packed;
+
+struct imgu_abi_metadata {
+	struct imgu_abi_metadata_info info;	/* Layout info */
+	imgu_addr_t address;		/* CSS virtual address */
+	u32 exp_id;			/* Exposure ID */
+} __packed;
+
+struct imgu_abi_time_meas {
+	u32 start_timer_value;		/* measured time in ticks */
+	u32 end_timer_value;		/* measured time in ticks */
+} __packed;
+
+struct imgu_abi_buffer {
+	union {
+		struct imgu_abi_isp_3a_statistics s3a;
+		u8 __reserved[28];
+		imgu_addr_t skc_dvs_statistics;
+		imgu_addr_t lace_stat;
+		struct imgu_abi_metadata metadata;
+		struct {
+			imgu_addr_t frame_data;
+			u32 flashed;
+			u32 exp_id;
+			u32 isp_parameters_id;   /* Tracks per-frame configs */
+			u32 padded_width;
+		} frame;
+		imgu_addr_t ddr_ptrs;
+	} payload;
+	/*
+	 * kernel_ptr is present for host administration purposes only.
+	 * type is uint64_t in order to be 64-bit host compatible.
+	 * uint64_t does not exist on SP/ISP.
+	 * Size of the struct is checked by sp.hive.c.
+	 */
+	u64 cookie_ptr __attribute__((aligned(8)));
+	u64 kernel_ptr;
+	struct imgu_abi_time_meas timing_data;
+	u32 isys_eof_clock_tick;
+} __packed;
+
+struct imgu_abi_bl_dma_cmd_entry {
+	u32 src_addr;			/* virtual DDR address */
+	u32 size;			/* number of bytes to transferred */
+	u32 dst_type;
+	u32 dst_addr;			/* hmm address of xMEM or MMIO */
+} __packed;
+
+struct imgu_abi_sp_init_dmem_cfg {
+	u32 ddr_data_addr;		/* data segment address in ddr  */
+	u32 dmem_data_addr;		/* data segment address in dmem */
+	u32 dmem_bss_addr;		/* bss segment address in dmem  */
+	u32 data_size;			/* data segment size            */
+	u32 bss_size;			/* bss segment size             */
+	u32 sp_id;			/* sp id */
+} __packed;
+
 #endif
-- 
2.7.4
