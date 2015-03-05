Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36200 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbCELD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 06:03:29 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKQ0040LK1QCLB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Mar 2015 20:03:26 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: remove non necessary volatile modifiers and  __iomem
 annotations
Date: Thu, 05 Mar 2015 12:03:15 +0100
Message-id: <1425553395-12675-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes non necessary volatile modifiers and __iomem
annotations from the s5p_mfc_regs structure.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h |  488 +++++++++++++-------------
 1 file changed, 244 insertions(+), 244 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index de2b8c6..7a7ad32 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -20,254 +20,254 @@
 struct s5p_mfc_regs {
 
 	/* codec common registers */
-	volatile void __iomem *risc_on;
-	volatile void __iomem *risc2host_int;
-	volatile void __iomem *host2risc_int;
-	volatile void __iomem *risc_base_address;
-	volatile void __iomem *mfc_reset;
-	volatile void __iomem *host2risc_command;
-	volatile void __iomem *risc2host_command;
-	volatile void __iomem *mfc_bus_reset_ctrl;
-	volatile void __iomem *firmware_version;
-	volatile void __iomem *instance_id;
-	volatile void __iomem *codec_type;
-	volatile void __iomem *context_mem_addr;
-	volatile void __iomem *context_mem_size;
-	volatile void __iomem *pixel_format;
-	volatile void __iomem *metadata_enable;
-	volatile void __iomem *mfc_version;
-	volatile void __iomem *dbg_info_enable;
-	volatile void __iomem *dbg_buffer_addr;
-	volatile void __iomem *dbg_buffer_size;
-	volatile void __iomem *hed_control;
-	volatile void __iomem *mfc_timeout_value;
-	volatile void __iomem *hed_shared_mem_addr;
-	volatile void __iomem *dis_shared_mem_addr;/* only v7 */
-	volatile void __iomem *ret_instance_id;
-	volatile void __iomem *error_code;
-	volatile void __iomem *dbg_buffer_output_size;
-	volatile void __iomem *metadata_status;
-	volatile void __iomem *metadata_addr_mb_info;
-	volatile void __iomem *metadata_size_mb_info;
-	volatile void __iomem *dbg_info_stage_counter;
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
 
 	/* decoder registers */
-	volatile void __iomem *d_crc_ctrl;
-	volatile void __iomem *d_dec_options;
-	volatile void __iomem *d_display_delay;
-	volatile void __iomem *d_set_frame_width;
-	volatile void __iomem *d_set_frame_height;
-	volatile void __iomem *d_sei_enable;
-	volatile void __iomem *d_min_num_dpb;
-	volatile void __iomem *d_min_first_plane_dpb_size;
-	volatile void __iomem *d_min_second_plane_dpb_size;
-	volatile void __iomem *d_min_third_plane_dpb_size;/* only v8 */
-	volatile void __iomem *d_min_num_mv;
-	volatile void __iomem *d_mvc_num_views;
-	volatile void __iomem *d_min_num_dis;/* only v7 */
-	volatile void __iomem *d_min_first_dis_size;/* only v7 */
-	volatile void __iomem *d_min_second_dis_size;/* only v7 */
-	volatile void __iomem *d_min_third_dis_size;/* only v7 */
-	volatile void __iomem *d_post_filter_luma_dpb0;/*  v7 and v8 */
-	volatile void __iomem *d_post_filter_luma_dpb1;/* v7 and v8 */
-	volatile void __iomem *d_post_filter_luma_dpb2;/* only v7 */
-	volatile void __iomem *d_post_filter_chroma_dpb0;/* v7 and v8 */
-	volatile void __iomem *d_post_filter_chroma_dpb1;/* v7 and v8 */
-	volatile void __iomem *d_post_filter_chroma_dpb2;/* only v7 */
-	volatile void __iomem *d_num_dpb;
-	volatile void __iomem *d_num_mv;
-	volatile void __iomem *d_init_buffer_options;
-	volatile void __iomem *d_first_plane_dpb_stride_size;/* only v8 */
-	volatile void __iomem *d_second_plane_dpb_stride_size;/* only v8 */
-	volatile void __iomem *d_third_plane_dpb_stride_size;/* only v8 */
-	volatile void __iomem *d_first_plane_dpb_size;
-	volatile void __iomem *d_second_plane_dpb_size;
-	volatile void __iomem *d_third_plane_dpb_size;/* only v8 */
-	volatile void __iomem *d_mv_buffer_size;
-	volatile void __iomem *d_first_plane_dpb;
-	volatile void __iomem *d_second_plane_dpb;
-	volatile void __iomem *d_third_plane_dpb;
-	volatile void __iomem *d_mv_buffer;
-	volatile void __iomem *d_scratch_buffer_addr;
-	volatile void __iomem *d_scratch_buffer_size;
-	volatile void __iomem *d_metadata_buffer_addr;
-	volatile void __iomem *d_metadata_buffer_size;
-	volatile void __iomem *d_nal_start_options;/* v7 and v8 */
-	volatile void __iomem *d_cpb_buffer_addr;
-	volatile void __iomem *d_cpb_buffer_size;
-	volatile void __iomem *d_available_dpb_flag_upper;
-	volatile void __iomem *d_available_dpb_flag_lower;
-	volatile void __iomem *d_cpb_buffer_offset;
-	volatile void __iomem *d_slice_if_enable;
-	volatile void __iomem *d_picture_tag;
-	volatile void __iomem *d_stream_data_size;
-	volatile void __iomem *d_dynamic_dpb_flag_upper;/* v7 and v8 */
-	volatile void __iomem *d_dynamic_dpb_flag_lower;/* v7 and v8 */
-	volatile void __iomem *d_display_frame_width;
-	volatile void __iomem *d_display_frame_height;
-	volatile void __iomem *d_display_status;
-	volatile void __iomem *d_display_first_plane_addr;
-	volatile void __iomem *d_display_second_plane_addr;
-	volatile void __iomem *d_display_third_plane_addr;/* only v8 */
-	volatile void __iomem *d_display_frame_type;
-	volatile void __iomem *d_display_crop_info1;
-	volatile void __iomem *d_display_crop_info2;
-	volatile void __iomem *d_display_picture_profile;
-	volatile void __iomem *d_display_luma_crc;/* v7 and v8 */
-	volatile void __iomem *d_display_chroma0_crc;/* v7 and v8 */
-	volatile void __iomem *d_display_chroma1_crc;/* only v8 */
-	volatile void __iomem *d_display_luma_crc_top;/* only v6 */
-	volatile void __iomem *d_display_chroma_crc_top;/* only v6 */
-	volatile void __iomem *d_display_luma_crc_bot;/* only v6 */
-	volatile void __iomem *d_display_chroma_crc_bot;/* only v6 */
-	volatile void __iomem *d_display_aspect_ratio;
-	volatile void __iomem *d_display_extended_ar;
-	volatile void __iomem *d_decoded_frame_width;
-	volatile void __iomem *d_decoded_frame_height;
-	volatile void __iomem *d_decoded_status;
-	volatile void __iomem *d_decoded_first_plane_addr;
-	volatile void __iomem *d_decoded_second_plane_addr;
-	volatile void __iomem *d_decoded_third_plane_addr;/* only v8 */
-	volatile void __iomem *d_decoded_frame_type;
-	volatile void __iomem *d_decoded_crop_info1;
-	volatile void __iomem *d_decoded_crop_info2;
-	volatile void __iomem *d_decoded_picture_profile;
-	volatile void __iomem *d_decoded_nal_size;
-	volatile void __iomem *d_decoded_luma_crc;
-	volatile void __iomem *d_decoded_chroma0_crc;
-	volatile void __iomem *d_decoded_chroma1_crc;/* only v8 */
-	volatile void __iomem *d_ret_picture_tag_top;
-	volatile void __iomem *d_ret_picture_tag_bot;
-	volatile void __iomem *d_ret_picture_time_top;
-	volatile void __iomem *d_ret_picture_time_bot;
-	volatile void __iomem *d_chroma_format;
-	volatile void __iomem *d_vc1_info;/* v7 and v8 */
-	volatile void __iomem *d_mpeg4_info;
-	volatile void __iomem *d_h264_info;
-	volatile void __iomem *d_metadata_addr_concealed_mb;
-	volatile void __iomem *d_metadata_size_concealed_mb;
-	volatile void __iomem *d_metadata_addr_vc1_param;
-	volatile void __iomem *d_metadata_size_vc1_param;
-	volatile void __iomem *d_metadata_addr_sei_nal;
-	volatile void __iomem *d_metadata_size_sei_nal;
-	volatile void __iomem *d_metadata_addr_vui;
-	volatile void __iomem *d_metadata_size_vui;
-	volatile void __iomem *d_metadata_addr_mvcvui;/* v7 and v8 */
-	volatile void __iomem *d_metadata_size_mvcvui;/* v7 and v8 */
-	volatile void __iomem *d_mvc_view_id;
-	volatile void __iomem *d_frame_pack_sei_avail;
-	volatile void __iomem *d_frame_pack_arrgment_id;
-	volatile void __iomem *d_frame_pack_sei_info;
-	volatile void __iomem *d_frame_pack_grid_pos;
-	volatile void __iomem *d_display_recovery_sei_info;/* v7 and v8 */
-	volatile void __iomem *d_decoded_recovery_sei_info;/* v7 and v8 */
-	volatile void __iomem *d_display_first_addr;/* only v7 */
-	volatile void __iomem *d_display_second_addr;/* only v7 */
-	volatile void __iomem *d_display_third_addr;/* only v7 */
-	volatile void __iomem *d_decoded_first_addr;/* only v7 */
-	volatile void __iomem *d_decoded_second_addr;/* only v7 */
-	volatile void __iomem *d_decoded_third_addr;/* only v7 */
-	volatile void __iomem *d_used_dpb_flag_upper;/* v7 and v8 */
-	volatile void __iomem *d_used_dpb_flag_lower;/* v7 and v8 */
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
 
 	/* encoder registers */
-	volatile void __iomem *e_frame_width;
-	volatile void __iomem *e_frame_height;
-	volatile void __iomem *e_cropped_frame_width;
-	volatile void __iomem *e_cropped_frame_height;
-	volatile void __iomem *e_frame_crop_offset;
-	volatile void __iomem *e_enc_options;
-	volatile void __iomem *e_picture_profile;
-	volatile void __iomem *e_vbv_buffer_size;
-	volatile void __iomem *e_vbv_init_delay;
-	volatile void __iomem *e_fixed_picture_qp;
-	volatile void __iomem *e_rc_config;
-	volatile void __iomem *e_rc_qp_bound;
-	volatile void __iomem *e_rc_qp_bound_pb;/* v7 and v8 */
-	volatile void __iomem *e_rc_mode;
-	volatile void __iomem *e_mb_rc_config;
-	volatile void __iomem *e_padding_ctrl;
-	volatile void __iomem *e_air_threshold;
-	volatile void __iomem *e_mv_hor_range;
-	volatile void __iomem *e_mv_ver_range;
-	volatile void __iomem *e_num_dpb;
-	volatile void __iomem *e_luma_dpb;
-	volatile void __iomem *e_chroma_dpb;
-	volatile void __iomem *e_me_buffer;
-	volatile void __iomem *e_scratch_buffer_addr;
-	volatile void __iomem *e_scratch_buffer_size;
-	volatile void __iomem *e_tmv_buffer0;
-	volatile void __iomem *e_tmv_buffer1;
-	volatile void __iomem *e_ir_buffer_addr;/* v7 and v8 */
-	volatile void __iomem *e_source_first_plane_addr;
-	volatile void __iomem *e_source_second_plane_addr;
-	volatile void __iomem *e_source_third_plane_addr;/* v7 and v8 */
-	volatile void __iomem *e_source_first_plane_stride;/* v7 and v8 */
-	volatile void __iomem *e_source_second_plane_stride;/* v7 and v8 */
-	volatile void __iomem *e_source_third_plane_stride;/* v7 and v8 */
-	volatile void __iomem *e_stream_buffer_addr;
-	volatile void __iomem *e_stream_buffer_size;
-	volatile void __iomem *e_roi_buffer_addr;
-	volatile void __iomem *e_param_change;
-	volatile void __iomem *e_ir_size;
-	volatile void __iomem *e_gop_config;
-	volatile void __iomem *e_mslice_mode;
-	volatile void __iomem *e_mslice_size_mb;
-	volatile void __iomem *e_mslice_size_bits;
-	volatile void __iomem *e_frame_insertion;
-	volatile void __iomem *e_rc_frame_rate;
-	volatile void __iomem *e_rc_bit_rate;
-	volatile void __iomem *e_rc_roi_ctrl;
-	volatile void __iomem *e_picture_tag;
-	volatile void __iomem *e_bit_count_enable;
-	volatile void __iomem *e_max_bit_count;
-	volatile void __iomem *e_min_bit_count;
-	volatile void __iomem *e_metadata_buffer_addr;
-	volatile void __iomem *e_metadata_buffer_size;
-	volatile void __iomem *e_encoded_source_first_plane_addr;
-	volatile void __iomem *e_encoded_source_second_plane_addr;
-	volatile void __iomem *e_encoded_source_third_plane_addr;/* v7 and v8 */
-	volatile void __iomem *e_stream_size;
-	volatile void __iomem *e_slice_type;
-	volatile void __iomem *e_picture_count;
-	volatile void __iomem *e_ret_picture_tag;
-	volatile void __iomem *e_stream_buffer_write_pointer; /*  only v6 */
-	volatile void __iomem *e_recon_luma_dpb_addr;
-	volatile void __iomem *e_recon_chroma_dpb_addr;
-	volatile void __iomem *e_metadata_addr_enc_slice;
-	volatile void __iomem *e_metadata_size_enc_slice;
-	volatile void __iomem *e_mpeg4_options;
-	volatile void __iomem *e_mpeg4_hec_period;
-	volatile void __iomem *e_aspect_ratio;
-	volatile void __iomem *e_extended_sar;
-	volatile void __iomem *e_h264_options;
-	volatile void __iomem *e_h264_options_2;/* v7 and v8 */
-	volatile void __iomem *e_h264_lf_alpha_offset;
-	volatile void __iomem *e_h264_lf_beta_offset;
-	volatile void __iomem *e_h264_i_period;
-	volatile void __iomem *e_h264_fmo_slice_grp_map_type;
-	volatile void __iomem *e_h264_fmo_num_slice_grp_minus1;
-	volatile void __iomem *e_h264_fmo_slice_grp_change_dir;
-	volatile void __iomem *e_h264_fmo_slice_grp_change_rate_minus1;
-	volatile void __iomem *e_h264_fmo_run_length_minus1_0;
-	volatile void __iomem *e_h264_aso_slice_order_0;
-	volatile void __iomem *e_h264_chroma_qp_offset;
-	volatile void __iomem *e_h264_num_t_layer;
-	volatile void __iomem *e_h264_hierarchical_qp_layer0;
-	volatile void __iomem *e_h264_frame_packing_sei_info;
-	volatile void __iomem *e_h264_nal_control;/* v7 and v8 */
-	volatile void __iomem *e_mvc_frame_qp_view1;
-	volatile void __iomem *e_mvc_rc_bit_rate_view1;
-	volatile void __iomem *e_mvc_rc_qbound_view1;
-	volatile void __iomem *e_mvc_rc_mode_view1;
-	volatile void __iomem *e_mvc_inter_view_prediction_on;
-	volatile void __iomem *e_vp8_options;/* v7 and v8 */
-	volatile void __iomem *e_vp8_filter_options;/* v7 and v8 */
-	volatile void __iomem *e_vp8_golden_frame_option;/* v7 and v8 */
-	volatile void __iomem *e_vp8_num_t_layer;/* v7 and v8 */
-	volatile void __iomem *e_vp8_hierarchical_qp_layer0;/* v7 and v8 */
-	volatile void __iomem *e_vp8_hierarchical_qp_layer1;/* v7 and v8 */
-	volatile void __iomem *e_vp8_hierarchical_qp_layer2;/* v7 and v8 */
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
 };
 
 struct s5p_mfc_hw_ops {
-- 
1.7.9.5

