Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54456 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S938894AbcJGQ70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:59:26 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1] [media] v4l2-ctrls: add mpeg2 parser metadata
Date: Fri, 7 Oct 2016 18:59:05 +0200
Message-ID: <1475859545-654-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1475859545-654-1-git-send-email-hugues.fruchet@st.com>
References: <1475859545-654-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/v4l2-core/v4l2-ctrls.c |   2 +-
 include/uapi/linux/v4l2-controls.h   | 163 +++++++++++++++++++++++++++++------
 2 files changed, 140 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c8bc4d4..6187dfc 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2115,7 +2115,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		elem_size = sizeof(u32);
 		break;
 	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
-		elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr);
+		elem_size = sizeof(struct v4l2_ctrl_mpeg2_meta);
 		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index cdf9497..cb685a7 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -549,6 +549,145 @@ enum v4l2_mpeg_video_mpeg4_profile {
 
 #define V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR     (V4L2_CID_MPEG_BASE+450)
 
+/* MPEG2 frame API metadata */
+#define MPEG2_QUANTISER_MATRIX_SIZE           64
+
+struct mpeg_video_sequence_hdr {
+	unsigned short width, height;
+	unsigned char aspect_ratio_info;
+	unsigned char frame_rate_code;
+	unsigned int bitrate_value;
+	unsigned short vbv_buffer_size_value;
+	unsigned char constrained_parameters_flag;
+	unsigned char load_intra_flag, load_non_intra_flag;
+	unsigned char intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	unsigned char non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	unsigned int par_w, par_h;
+	unsigned int fps_n, fps_d;
+	unsigned int bitrate;
+};
+
+struct mpeg_video_sequence_ext {
+	unsigned char profile_and_level;
+	unsigned char progressive;
+	unsigned char chroma_format;
+	unsigned char horiz_size_ext, vert_size_ext;
+	unsigned short bitrate_ext;
+	unsigned char vbv_buffer_size_extension;
+	unsigned char low_delay;
+	unsigned char fps_n_ext, fps_d_ext;
+};
+
+struct mpeg_video_sequence_display_ext {
+	unsigned char video_format;
+	unsigned char colour_description_flag;
+	unsigned char colour_primaries;
+	unsigned char transfer_characteristics;
+	unsigned char matrix_coefficients;
+	unsigned short display_horizontal_size;
+	unsigned short display_vertical_size;
+};
+
+struct mpeg_video_sequence_scalable_ext {
+	unsigned char scalable_mode;
+	unsigned char layer_id;
+	unsigned short lower_layer_prediction_horizontal_size;
+	unsigned short lower_layer_prediction_vertical_size;
+	unsigned char horizontal_subsampling_factor_m;
+	unsigned char horizontal_subsampling_factor_n;
+	unsigned char vertical_subsampling_factor_m;
+	unsigned char vertical_subsampling_factor_n;
+	unsigned char picture_mux_enable;
+	unsigned char mux_to_progressive_sequence;
+	unsigned char picture_mux_order;
+	unsigned char picture_mux_factor;
+};
+
+struct mpeg_video_gop {
+	unsigned char drop_frame_flag;
+	unsigned char hour, minute, second, frame;
+	unsigned char closed_gop;
+	unsigned char broken_link;
+};
+
+struct mpeg_video_picture_hdr {
+	unsigned short tsn;
+	unsigned char pic_type;
+	unsigned short vbv_delay;
+	unsigned char full_pel_forward_vector, full_pel_backward_vector;
+	unsigned char f_f_code;
+	unsigned char b_f_code;
+};
+
+struct mpeg_video_picture_ext {
+	unsigned char f_code[2][2];
+	unsigned char intra_dc_precision;
+	unsigned char picture_structure;
+	unsigned char top_field_first;
+	unsigned char frame_pred_frame_dct;
+	unsigned char concealment_motion_vectors;
+	unsigned char q_scale_type;
+	unsigned char intra_vlc_format;
+	unsigned char alternate_scan;
+	unsigned char repeat_first_field;
+	unsigned char chroma_420_type;
+	unsigned char progressive_frame;
+	unsigned char composite_display_flag;
+	unsigned char v_axis;
+	unsigned char field_sequence;
+	unsigned char sub_carrier;
+	unsigned char burst_amplitude;
+	unsigned char sub_carrier_phase;
+};
+
+struct mpeg_video_quant_matrix_ext {
+	unsigned char load_intra_quantiser_matrix;
+	unsigned char intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	unsigned char load_non_intra_quantiser_matrix;
+	unsigned char non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	unsigned char load_chroma_intra_quantiser_matrix;
+	unsigned char chroma_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	unsigned char load_chroma_non_intra_quantiser_matrix;
+	unsigned char chroma_non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+};
+
+struct mpeg2_meta_seq {
+	struct mpeg_video_sequence_hdr seq_h;
+	struct mpeg_video_sequence_ext seq_e;
+	struct mpeg_video_sequence_display_ext seq_d;
+	struct mpeg_video_sequence_scalable_ext seq_s;
+	struct mpeg_video_quant_matrix_ext qua_m;
+	__u32 flags;
+};
+
+#define MPEG2_META_SEQ_FLAG_HDR			0x00000001
+#define MPEG2_META_SEQ_FLAG_EXT			0x00000002
+#define MPEG2_META_SEQ_FLAG_DISPLAY_EXT		0x00000004
+#define MPEG2_META_SEQ_FLAG_SCALABLE_EXT	0x00000008
+#define MPEG2_META_SEQ_FLAG_MATRIX_EXT		0x00000010
+
+struct mpeg2_meta_pic {
+	struct mpeg_video_picture_hdr pic_h;
+	struct mpeg_video_gop g_o_p;
+	struct mpeg_video_picture_ext pic_e;
+	unsigned long offset;
+	__u32 flags;
+};
+
+#define MPEG2_META_PIC_FLAG_HDR		0x00000001
+#define MPEG2_META_PIC_FLAG_GOP		0x00000002
+#define MPEG2_META_PIC_FLAG_EXT		0x00000004
+
+struct v4l2_ctrl_mpeg2_meta {
+	unsigned int struct_size;
+	struct mpeg2_meta_seq	seq;
+	struct mpeg2_meta_pic	pic[2];
+	__u32 flags;
+};
+
+#define V4L2_CTRL_MPEG2_FLAG_SEQ	0x00000001
+#define V4L2_CTRL_MPEG2_FLAG_PIC	0x00000002
+
 /*  Control IDs for VP8 streams
  *  Although VP8 is not part of MPEG we add these controls to the MPEG class
  *  as that class is already handling other video compression standards
@@ -976,28 +1115,4 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
-struct v4l2_ctrl_mpeg2_frame_hdr {
-	__u32 slice_len;
-	__u32 slice_pos;
-	enum { MPEG1, MPEG2 } type;
-
-	__u16 width;
-	__u16 height;
-
-	enum { PCT_I = 1, PCT_P, PCT_B, PCT_D } picture_coding_type;
-	__u8 f_code[2][2];
-
-	__u8 intra_dc_precision;
-	__u8 picture_structure;
-	__u8 top_field_first;
-	__u8 frame_pred_frame_dct;
-	__u8 concealment_motion_vectors;
-	__u8 q_scale_type;
-	__u8 intra_vlc_format;
-	__u8 alternate_scan;
-
-	__u8 backward_index;
-	__u8 forward_index;
-};
-
 #endif
-- 
1.9.1

