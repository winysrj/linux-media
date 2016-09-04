Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:56859 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932109AbcIDUS4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 16:18:56 -0400
From: Randy Li <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: posciak@chromium.org, hverkuil@xs4all.nl,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, Randy Li <ayaka@soulik.info>
Subject: [PATCH 2/2] v4l2-ctrls: add generic H.264 decoder codec settings structure
Date: Mon,  5 Sep 2016 04:18:36 +0800
Message-Id: <1473020316-7325-3-git-send-email-ayaka@soulik.info>
In-Reply-To: <1473020316-7325-1-git-send-email-ayaka@soulik.info>
References: <1473020316-7325-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The generic decoder settings for H.264. It is modified from
the VA-API. Adding the extra data required by the Rockchip.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 include/uapi/linux/videodev2.h | 103 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 904c44c..3dacccc 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2214,6 +2214,109 @@ struct v4l2_request_cmd {
 		} raw;
 	};
 };
+
+/* H.264 Codec settings */
+struct v4l2_mpeg_video_h264_picture {
+	__u32 frame_idx;
+	__u32 flags;
+	__s32 top_field_order_cnt;
+	__s32 bottom_field_order_cnt;
+};
+
+struct v4l2_mpeg_video_h264_picture_param {
+	struct v4l2_mpeg_video_h264_picture curr_pic;
+	struct v4l2_mpeg_video_h264_picture reference_frames[16];
+	__u16 picture_width_in_mbs_minus1;
+	__u16 picture_height_in_mbs_minus1;
+	__u8 bit_depth_luma_minus8;
+	__u8 bit_depth_chroma_minus8;
+	__u8 num_ref_frames;
+	union {
+		struct {
+			__u32 chroma_format_idc:2;
+			__u32 residual_colour_transform_flag:1;
+			__u32 gaps_in_frame_num_value_allowed_flag:1;
+			__u32 frame_mbs_only_flag:1;
+			__u32 mb_adaptive_frame_field_flag:1;
+			__u32 direct_8x8_inference_flag:1;
+			__u32 min_luma_bi_pred_size8x8:1;
+			__u32 log2_max_frame_num_minus4:4;
+			__u32 pic_order_cnt_type:2;
+			__u32 log2_max_pic_order_cnt_lsb_minus4:4;
+			__u32 delta_pic_order_always_zero_flag:1;
+		} bits;
+		__u32 value;	
+	} seq_fields;
+	__u8 num_slice_groups_minus1;
+	__u8 slice_group_map_type;
+	__u16 slice_group_change_rate_minus1;
+	__s8 pic_init_qp_minus26;
+	__s8 pic_init_qs_minus26;
+	__s8 chroma_qp_index_offset;
+	__s8 second_chroma_qp_index_offset;
+	union {
+		struct {
+			__u32 entropy_coding_mode_flag:1;
+			__u32 weighted_pred_flag:1
+			__u32 weighted_bipred_idc:2;
+			__u32 transform_8x8_mode_flag:1;
+			__u32 field_pic_flag:1;
+			__u32 constrained_intra_pred_flag:1;
+			__u32 pic_order_present_flag:1;
+			__u32 deblocking_filter_control_present_flag:1;
+			__u32 redundant_pic_cnt_present_flag:1;
+			__u32 reference_pic_flag:1;
+		} bits;
+		__u32 value;	
+	} pic_fields;
+	__u16 frame_num;
+	/* 
+	 * Some extra data required by Rockchip, the decoder in RK serial
+	 * chip would omit some part of data
+	 */
+	struct {
+		__u8 profile;
+		__u8 constraint_set_flags;
+		__u32 pic_order_cnt_bit_size;
+		__u32 dec_ref_pic_marking_bit_size;
+		__u16 idr_pic_id;
+	} extra;
+};
+
+struct v4l2_mpeg_video_h264_slice_param {
+{
+	__u32 slice_data_size;
+	__u32 slice_data_offset;
+	__u32 slice_data_flag;
+	__u16 slice_data_bit_offset;
+	__u16 first_mb_in_slice;
+	__u8 slice_type;
+	__u8 direct_spatial_mv_pred_flag;
+	__u8 num_ref_idx_l0_active_minus1;
+	__u8 num_ref_idx_l1_active_minus1;
+	__u8 cabac_init_idc;
+	__s8 slice_qp_delta;
+	__u8 disable_deblocking_filter_idc;
+	__s8 slice_alpha_c0_offset_div2;
+	__s8 slice_beta_offset_div2;
+	struct v4l2_mpeg_video_h264_picture ref_pic_list0[32];
+	struct v4l2_mpeg_video_h264_picture ref_pic_list1[32];
+	__u8 luma_log2_weight_denom;
+	__u8 chroma_log2_weight_denom;
+	__u8 luma_weight_l0_flag;
+	__s16 luma_weight_l0 [32];
+	__s16 luma_offset_l0 [32];
+	__u8 chroma_weight_l0_flag;
+	__s16 chroma_weight_l0 [32][2];
+	__s16 chroma_offset_l0 [32][2];
+	__u8 luma_weight_l1_flag;
+	__s16 luma_weight_l1 [32];
+	__s16 luma_offset_l1 [32];
+	__u8 chroma_weight_l1_flag;
+	__s16 chroma_weight_l1 [32][2];
+	__s16 chroma_offset_l1 [32][2];
+};
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
-- 
2.7.4

