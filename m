Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37007 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754168AbdBGOGp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 09:06:45 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 1/3] v4l-utils: sync with kernel (parsed MPEG-2 support)
Date: Tue, 7 Feb 2017 15:06:25 +0100
Message-ID: <1486476387-8069-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486476387-8069-1-git-send-email-hugues.fruchet@st.com>
References: <1486476387-8069-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add "parsed MPEG-2" pixel format & related controls
needed by stateless video decoders.
In order to decode the video bitstream chunk provided
by user on OUTPUT queue, stateless decoders require
also some extra data resulting from this video bitstream
chunk parsing.
Those parsed extra data have to be set by user through
control framework using the dedicated mpeg video extended
controls introduced in this patchset.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 include/linux/v4l2-controls.h | 86 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/videodev2.h     |  8 ++++
 2 files changed, 94 insertions(+)

diff --git a/include/linux/v4l2-controls.h b/include/linux/v4l2-controls.h
index 0d2e1e0..deff646 100644
--- a/include/linux/v4l2-controls.h
+++ b/include/linux/v4l2-controls.h
@@ -547,6 +547,92 @@ enum v4l2_mpeg_video_mpeg4_profile {
 };
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
+/* parsed MPEG-2 controls
+ * (needed by stateless video decoders)
+ * Those controls have been defined based on MPEG-2 standard ISO/IEC 13818-2,
+ * and so derive directly from the MPEG-2 video bitstream syntax including
+ * how it is coded inside bitstream (enumeration values for ex.).
+ */
+#define MPEG2_QUANTISER_MATRIX_SIZE	64
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR		(V4L2_CID_MPEG_BASE+450)
+struct v4l2_mpeg_video_mpeg2_seq_hdr {
+	__u16	width, height;
+	__u8	aspect_ratio_info;
+	__u8	frame_rate_code;
+	__u32	bitrate_value;
+	__u16	vbv_buffer_size;
+	__u8	constrained_parameters_flag;
+	__u8	load_intra_quantiser_matrix, load_non_intra_quantiser_matrix;
+	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u32	par_w, par_h;
+	__u32	fps_n, fps_d;
+	__u32	bitrate;
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT		(V4L2_CID_MPEG_BASE+451)
+struct v4l2_mpeg_video_mpeg2_seq_ext {
+	__u8	profile;
+	__u8	level;
+	__u8	progressive;
+	__u8	chroma_format;
+	__u8	horiz_size_ext, vert_size_ext;
+	__u16	bitrate_ext;
+	__u8	vbv_buffer_size_ext;
+	__u8	low_delay;
+	__u8	fps_n_ext, fps_d_ext;
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT	(V4L2_CID_MPEG_BASE+452)
+struct v4l2_mpeg_video_mpeg2_seq_display_ext {
+	__u8	video_format;
+	__u8	colour_description_flag;
+	__u8	colour_primaries;
+	__u8	transfer_characteristics;
+	__u8	matrix_coefficients;
+	__u16	display_horizontal_size;
+	__u16	display_vertical_size;
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT	(V4L2_CID_MPEG_BASE+453)
+struct v4l2_mpeg_video_mpeg2_seq_matrix_ext {
+	__u8	load_intra_quantiser_matrix;
+	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	load_non_intra_quantiser_matrix;
+	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	load_chroma_intra_quantiser_matrix;
+	__u8	chroma_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	load_chroma_non_intra_quantiser_matrix;
+	__u8	chroma_non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR		(V4L2_CID_MPEG_BASE+454)
+struct v4l2_mpeg_video_mpeg2_pic_hdr {
+	__u32	offset;
+	__u16	tsn;
+	__u8	pic_type;
+	__u16	vbv_delay;
+	__u8	full_pel_forward_vector, full_pel_backward_vector;
+	__u8	f_code[2][2];
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT		(V4L2_CID_MPEG_BASE+455)
+struct v4l2_mpeg_video_mpeg2_pic_ext {
+	__u8	f_code[2][2];
+	__u8	intra_dc_precision;
+	__u8	picture_structure;
+	__u8	top_field_first;
+	__u8	frame_pred_frame_dct;
+	__u8	concealment_motion_vectors;
+	__u8	q_scale_type;
+	__u8	intra_vlc_format;
+	__u8	alternate_scan;
+	__u8	repeat_first_field;
+	__u8	chroma_420_type;
+	__u8	progressive_frame;
+	__u8	composite_display;
+	__u8	v_axis;
+	__u8	field_sequence;
+	__u8	sub_carrier;
+	__u8	burst_amplitude;
+	__u8	sub_carrier_phase;
+};
+
 /*  Control IDs for VP8 streams
  *  Although VP8 is not part of MPEG we add these controls to the MPEG class
  *  as that class is already handling other video compression standards
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3fadc42..846fc1f 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -619,7 +619,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
+#define V4L2_PIX_FMT_MPEG1_PARSED v4l2_fourcc('M', 'G', '1', 'P') /* MPEG1 with parsing metadata given through controls */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
+#define V4L2_PIX_FMT_MPEG2_PARSED v4l2_fourcc('M', 'G', '2', 'P') /* MPEG2 with parsing metadata given through controls */
 #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
@@ -1593,6 +1595,12 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_HDR  = 0x0109,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_EXT  = 0x010A,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT  = 0x010B,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT  = 0x010C,
+	V4L2_CTRL_TYPE_MPEG2_PIC_HDR  = 0x010D,
+	V4L2_CTRL_TYPE_MPEG2_PIC_EXT  = 0x010E,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.9.1

