Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52420 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935813AbeFMOHW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:22 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API compound controls.
Date: Wed, 13 Jun 2018 16:07:06 +0200
Message-Id: <20180613140714.1686-2-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
Tested-by: Tomasz Figa <tfiga@chromium.org>
[rebase44(groeck): include linux/types.h in v4l2-controls.h]
Signed-off-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |  42 +++++++
 include/media/v4l2-ctrls.h           |  10 ++
 include/uapi/linux/v4l2-controls.h   | 164 +++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h       |  11 ++
 4 files changed, 227 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index cdf860c8e3d8..1f63c725bad1 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -807,6 +807,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
 	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
 								return "H264 Set QP Value for HC Layers";
+	case V4L2_CID_MPEG_VIDEO_H264_SPS:			return "H264 SPS";
+	case V4L2_CID_MPEG_VIDEO_H264_PPS:			return "H264 PPS";
+	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:		return "H264 Scaling Matrix";
+	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM:		return "H264 Slice Parameters";
+	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM:		return "H264 Decode Parameters";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
@@ -1272,6 +1277,21 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_SPS:
+		*type = V4L2_CTRL_TYPE_H264_SPS;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_PPS:
+		*type = V4L2_CTRL_TYPE_H264_PPS;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:
+		*type = V4L2_CTRL_TYPE_H264_SCALING_MATRIX;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM:
+		*type = V4L2_CTRL_TYPE_H264_SLICE_PARAM;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM:
+		*type = V4L2_CTRL_TYPE_H264_DECODE_PARAM;
+		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
 		*type = V4L2_CTRL_TYPE_MPEG2_FRAME_HDR;
 		break;
@@ -1598,6 +1618,13 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
 		return 0;
 
+	case V4L2_CTRL_TYPE_H264_SPS:
+	case V4L2_CTRL_TYPE_H264_PPS:
+	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
+	case V4L2_CTRL_TYPE_H264_SLICE_PARAM:
+	case V4L2_CTRL_TYPE_H264_DECODE_PARAM:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2172,6 +2199,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_H264_SPS:
+		elem_size = sizeof(struct v4l2_ctrl_h264_sps);
+		break;
+	case V4L2_CTRL_TYPE_H264_PPS:
+		elem_size = sizeof(struct v4l2_ctrl_h264_pps);
+		break;
+	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
+		elem_size = sizeof(struct v4l2_ctrl_h264_scaling_matrix);
+		break;
+	case V4L2_CTRL_TYPE_H264_SLICE_PARAM:
+		elem_size = sizeof(struct v4l2_ctrl_h264_slice_param);
+		break;
+	case V4L2_CTRL_TYPE_H264_DECODE_PARAM:
+		elem_size = sizeof(struct v4l2_ctrl_h264_decode_param);
+		break;
 	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
 		elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr);
 		break;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 963c37b02363..9c223793a16a 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -41,6 +41,11 @@ struct poll_table_struct;
  * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_u32:	Pointer to a 32-bit unsigned value.
  * @p_char:	Pointer to a string.
+ * @p_h264_sps:	Pointer to a struct v4l2_ctrl_h264_sps.
+ * @p_h264_pps:	Pointer to a struct v4l2_ctrl_h264_pps.
+ * @p_h264_scal_mtrx:	Pointer to a struct v4l2_ctrl_h264_scaling_matrix.
+ * @p_h264_slice_param:	Pointer to a struct v4l2_ctrl_h264_slice_param.
+ * @p_h264_decode_param: Pointer to a struct v4l2_ctrl_h264_decode_param.
  * @p:		Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -50,6 +55,11 @@ union v4l2_ctrl_ptr {
 	u16 *p_u16;
 	u32 *p_u32;
 	char *p_char;
+	struct v4l2_ctrl_h264_sps *p_h264_sps;
+	struct v4l2_ctrl_h264_pps *p_h264_pps;
+	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scal_mtrx;
+	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
+	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
 	void *p;
 };
 
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 23da8bfa7e6f..ac307c59683c 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -50,6 +50,8 @@
 #ifndef __LINUX_V4L2_CONTROLS_H
 #define __LINUX_V4L2_CONTROLS_H
 
+#include <linux/types.h>
+
 /* Control classes */
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
@@ -531,6 +533,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
 };
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
+#define V4L2_CID_MPEG_VIDEO_H264_SPS		(V4L2_CID_MPEG_BASE+383)
+#define V4L2_CID_MPEG_VIDEO_H264_PPS		(V4L2_CID_MPEG_BASE+384)
+#define V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX	(V4L2_CID_MPEG_BASE+385)
+#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM	(V4L2_CID_MPEG_BASE+386)
+#define V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM	(V4L2_CID_MPEG_BASE+387)
+
 #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
@@ -1078,6 +1086,162 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+/* Complex controls */
+
+#define V4L2_H264_SPS_CONSTRAINT_SET0_FLAG			0x01
+#define V4L2_H264_SPS_CONSTRAINT_SET1_FLAG			0x02
+#define V4L2_H264_SPS_CONSTRAINT_SET2_FLAG			0x04
+#define V4L2_H264_SPS_CONSTRAINT_SET3_FLAG			0x08
+#define V4L2_H264_SPS_CONSTRAINT_SET4_FLAG			0x10
+#define V4L2_H264_SPS_CONSTRAINT_SET5_FLAG			0x20
+
+#define V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE		0x01
+#define V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS	0x02
+#define V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO		0x04
+#define V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED	0x08
+#define V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY			0x10
+#define V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD		0x20
+#define V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE			0x40
+struct v4l2_ctrl_h264_sps {
+	__u8 profile_idc;
+	__u8 constraint_set_flags;
+	__u8 level_idc;
+	__u8 seq_parameter_set_id;
+	__u8 chroma_format_idc;
+	__u8 bit_depth_luma_minus8;
+	__u8 bit_depth_chroma_minus8;
+	__u8 log2_max_frame_num_minus4;
+	__u8 pic_order_cnt_type;
+	__u8 log2_max_pic_order_cnt_lsb_minus4;
+	__s32 offset_for_non_ref_pic;
+	__s32 offset_for_top_to_bottom_field;
+	__u8 num_ref_frames_in_pic_order_cnt_cycle;
+	__s32 offset_for_ref_frame[255];
+	__u8 max_num_ref_frames;
+	__u16 pic_width_in_mbs_minus1;
+	__u16 pic_height_in_map_units_minus1;
+	__u8 flags;
+};
+
+#define V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE				0x0001
+#define V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT	0x0002
+#define V4L2_H264_PPS_FLAG_WEIGHTED_PRED				0x0004
+#define V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT		0x0008
+#define V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED			0x0010
+#define V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT			0x0020
+#define V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE				0x0040
+#define V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT			0x0080
+struct v4l2_ctrl_h264_pps {
+	__u8 pic_parameter_set_id;
+	__u8 seq_parameter_set_id;
+	__u8 num_slice_groups_minus1;
+	__u8 num_ref_idx_l0_default_active_minus1;
+	__u8 num_ref_idx_l1_default_active_minus1;
+	__u8 weighted_bipred_idc;
+	__s8 pic_init_qp_minus26;
+	__s8 pic_init_qs_minus26;
+	__s8 chroma_qp_index_offset;
+	__s8 second_chroma_qp_index_offset;
+	__u8 flags;
+};
+
+struct v4l2_ctrl_h264_scaling_matrix {
+	__u8 scaling_list_4x4[6][16];
+	__u8 scaling_list_8x8[6][64];
+};
+
+struct v4l2_h264_weight_factors {
+	__s8 luma_weight[32];
+	__s8 luma_offset[32];
+	__s8 chroma_weight[32][2];
+	__s8 chroma_offset[32][2];
+};
+
+struct v4l2_h264_pred_weight_table {
+	__u8 luma_log2_weight_denom;
+	__u8 chroma_log2_weight_denom;
+	struct v4l2_h264_weight_factors weight_factors[2];
+};
+
+enum v4l2_h264_slice_type {
+	V4L2_H264_SLICE_TYPE_P			= 0,
+	V4L2_H264_SLICE_TYPE_B			= 1,
+	V4L2_H264_SLICE_TYPE_I			= 2,
+	V4L2_H264_SLICE_TYPE_SP			= 3,
+	V4L2_H264_SLICE_TYPE_SI			= 4,
+};
+
+#define V4L2_SLICE_FLAG_FIELD_PIC		0x01
+#define V4L2_SLICE_FLAG_BOTTOM_FIELD		0x02
+#define V4L2_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED	0x04
+#define V4L2_SLICE_FLAG_SP_FOR_SWITCH		0x08
+struct v4l2_ctrl_h264_slice_param {
+	/* Size in bytes, including header */
+	__u32 size;
+	/* Offset in bits to slice_data() from the beginning of this slice. */
+	__u32 header_bit_size;
+
+	__u16 first_mb_in_slice;
+	enum v4l2_h264_slice_type slice_type;
+	__u8 pic_parameter_set_id;
+	__u8 colour_plane_id;
+	__u16 frame_num;
+	__u16 idr_pic_id;
+	__u16 pic_order_cnt_lsb;
+	__s32 delta_pic_order_cnt_bottom;
+	__s32 delta_pic_order_cnt0;
+	__s32 delta_pic_order_cnt1;
+	__u8 redundant_pic_cnt;
+
+	struct v4l2_h264_pred_weight_table pred_weight_table;
+	/* Size in bits of dec_ref_pic_marking() syntax element. */
+	__u32 dec_ref_pic_marking_bit_size;
+	/* Size in bits of pic order count syntax. */
+	__u32 pic_order_cnt_bit_size;
+
+	__u8 cabac_init_idc;
+	__s8 slice_qp_delta;
+	__s8 slice_qs_delta;
+	__u8 disable_deblocking_filter_idc;
+	__s8 slice_alpha_c0_offset_div2;
+	__s8 slice_beta_offset_div2;
+	__u32 slice_group_change_cycle;
+
+	__u8 num_ref_idx_l0_active_minus1;
+	__u8 num_ref_idx_l1_active_minus1;
+	/*  Entries on each list are indices
+	 *  into v4l2_ctrl_h264_decode_param.dpb[]. */
+	__u8 ref_pic_list0[32];
+	__u8 ref_pic_list1[32];
+
+	__u8 flags;
+};
+
+/* If not set, this entry is unused for reference. */
+#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x01
+#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM	0x02
+struct v4l2_h264_dpb_entry {
+	__u32 buf_index; /* v4l2_buffer index */
+	__u16 frame_num;
+	__u16 pic_num;
+	/* Note that field is indicated by v4l2_buffer.field */
+	__s32 top_field_order_cnt;
+	__s32 bottom_field_order_cnt;
+	__u8 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
+};
+
+struct v4l2_ctrl_h264_decode_param {
+	__u32 num_slices;
+	__u8 idr_pic_flag;
+	__u8 nal_ref_idc;
+	__s32 top_field_order_cnt;
+	__s32 bottom_field_order_cnt;
+	__u8 ref_pic_list_p0[32];
+	__u8 ref_pic_list_b0[32];
+	__u8 ref_pic_list_b1[32];
+	struct v4l2_h264_dpb_entry dpb[16];
+};
+
 struct v4l2_ctrl_mpeg2_frame_hdr {
 	__u32 slice_len;
 	__u32 slice_pos;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 242a6bfa1440..4b4a1b25a0db 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -626,6 +626,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
 #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
 #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
+#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
@@ -1589,6 +1590,11 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_h264_sps __user *p_h264_sps;
+		struct v4l2_ctrl_h264_pps __user *p_h264_pps;
+		struct v4l2_ctrl_h264_scaling_matrix __user *p_h264_scal_mtrx;
+		struct v4l2_ctrl_h264_slice_param __user *p_h264_slice_param;
+		struct v4l2_ctrl_h264_decode_param __user *p_h264_decode_param;
 		struct v4l2_ctrl_mpeg2_frame_hdr __user *p_mpeg2_frame_hdr;
 		void __user *ptr;
 	};
@@ -1635,6 +1641,11 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_H264_SPS      = 0x0103,
+	V4L2_CTRL_TYPE_H264_PPS      = 0x0104,
+	V4L2_CTRL_TYPE_H264_SCALING_MATRIX = 0x0105,
+	V4L2_CTRL_TYPE_H264_SLICE_PARAM = 0x0106,
+	V4L2_CTRL_TYPE_H264_DECODE_PARAM = 0x0107,
 	V4L2_CTRL_TYPE_MPEG2_FRAME_HDR = 0x0109,
 };
 
-- 
2.17.0
