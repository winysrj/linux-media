Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58921 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbeHIL3I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Aug 2018 07:29:08 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v7 1/8] media: v4l: Add definitions for MPEG2 slice format and metadata
Date: Thu,  9 Aug 2018 11:04:28 +0200
Message-Id: <20180809090435.17248-2-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180809090435.17248-1-paul.kocialkowski@bootlin.com>
References: <20180809090435.17248-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stateless video decoding engines require both the MPEG slices and
associated metadata from the video stream in order to decode frames.

This introduces definitions for a new pixel format, describing buffers
with MPEG2 slice data, as well as a control structure for passing the
frame metadata to drivers.

This is based on work from both Florent Revest and Hugues Fruchet.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 .../media/uapi/v4l/extended-controls.rst      | 177 ++++++++++++++++++
 .../media/uapi/v4l/pixfmt-compressed.rst      |  14 ++
 .../media/uapi/v4l/vidioc-queryctrl.rst       |  14 +-
 .../media/videodev2.h.rst.exceptions          |   2 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |  63 +++++++
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 include/media/v4l2-ctrls.h                    |  18 +-
 include/uapi/linux/v4l2-controls.h            |  65 +++++++
 include/uapi/linux/videodev2.h                |   5 +
 9 files changed, 350 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 9f7312bf3365..a9252225b63e 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1497,6 +1497,183 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
 
 
 
+.. _v4l2-mpeg-mpeg2:
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS (struct)``
+    Specifies the slice parameters (as extracted from the bitstream) for the
+    associated MPEG-2 slice data. This includes the necessary parameters for
+    configuring a stateless hardware decoding pipeline for MPEG-2.
+    The bitstream parameters are defined according to the ISO/IEC 13818-2 and
+    ITU-T Rec. H.262 specifications.
+
+.. c:type:: v4l2_ctrl_mpeg2_slice_params
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``bit_size``
+      - Size (in bits) of the current slice data.
+    * - __u32
+      - ``data_bit_offset``
+      - Offset (in bits) to the video data in the current slice data.
+    * - struct :c:type:`v4l2_mpeg2_sequence`
+      - ``sequence``
+      - Structure with MPEG-2 sequence metadata, merging relevant fields from
+	the sequence header and sequence extension parts of the bitstream.
+    * - struct :c:type:`v4l2_mpeg2_picture`
+      - ``picture``
+      - Structure with MPEG-2 picture metadata, merging relevant fields from
+	the picture header and picture coding extension parts of the bitstream.
+    * - __u8
+      - ``quantiser_scale_code``
+      - Code used to determine the quantization scale to use for the IDCT.
+    * - __u8
+      - ``backward_ref_index``
+      - Index for the V4L2 buffer to use as backward reference, used with
+	B-coded and P-coded frames.
+    * - __u8
+      - ``forward_ref_index``
+      - Index for the V4L2 buffer to use as forward reference, used with
+	P-coded frames.
+
+.. c:type:: v4l2_mpeg2_sequence
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg2_sequence
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u16
+      - ``horizontal_size``
+      - The width of the displayable part of the frame's luminance component.
+    * - __u16
+      - ``vertical_size``
+      - The height of the displayable part of the frame's luminance component.
+    * - __u32
+      - ``vbv_buffer_size``
+      - Used to calculate the required size of the video buffering verifier,
+	defined (in bits) as: 16 * 1024 * vbv_buffer_size.
+    * - __u8
+      - ``profile_and_level_indication``
+      - The current profile and level indication as extracted from the
+	bitstream.
+    * - __u8
+      - ``progressive_sequence``
+      - Indication that all the frames for the sequence are progressive instead
+	of interlaced.
+    * - __u8
+      - ``chroma_format``
+      - The chrominance sub-sampling format (1: 4:2:0, 2: 4:2:2, 3: 4:4:4).
+
+.. c:type:: v4l2_mpeg2_picture
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg2_picture
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``picture_coding_type``
+      - Picture coding type for the frame covered by the current slice
+	(V4L2_MPEG2_PICTURE_CODING_TYPE_I, V4L2_MPEG2_PICTURE_CODING_TYPE_P or
+	V4L2_MPEG2_PICTURE_CODING_TYPE_B).
+    * - __u8
+      - ``f_code[2][2]``
+      - Motion vector codes.
+    * - __u8
+      - ``intra_dc_precision``
+      - Precision of Discrete Cosine transform (0: 8 bits precision,
+	1: 9 bits precision, 2: 10 bits precision, 3: 11 bits precision).
+    * - __u8
+      - ``picture_structure``
+      - Picture structure (1: interlaced top field, 2: interlaced bottom field,
+	3: progressive frame).
+    * - __u8
+      - ``top_field_first``
+      - If set to 1 and interlaced stream, top field is output first.
+    * - __u8
+      - ``frame_pred_frame_dct``
+      - If set to 1, only frame-DCT and frame prediction are used.
+    * - __u8
+      - ``concealment_motion_vectors``
+      -  If set to 1, motion vectors are coded for intra macroblocks.
+    * - __u8
+      - ``q_scale_type``
+      - This flag affects the inverse quantization process.
+    * - __u8
+      - ``intra_vlc_format``
+      - This flag affects the decoding of transform coefficient data.
+    * - __u8
+      - ``alternate_scan``
+      - This flag affects the decoding of transform coefficient data.
+    * - __u8
+      - ``repeat_first_field``
+      - This flag affects the decoding process of progressive frames.
+    * - __u8
+      - ``progressive_frame``
+      - Indicates whether the current frame is progressive.
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION (struct)``
+    Specifies quantization matrices (as extracted from the bitstream) for the
+    associated MPEG-2 slice data.
+
+.. c:type:: v4l2_ctrl_mpeg2_quantization
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_mpeg2_quantization
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``load_intra_quantiser_matrix``
+      - One bit to indicate whether to load the ``intra_quantiser_matrix`` data.
+    * - __u8
+      - ``load_non_intra_quantiser_matrix``
+      - One bit to indicate whether to load the ``non_intra_quantiser_matrix``
+	data.
+    * - __u8
+      - ``load_chroma_intra_quantiser_matrix``
+      - One bit to indicate whether to load the
+	``chroma_intra_quantiser_matrix`` data, only relevant for non-4:2:0 YUV
+	formats.
+    * - __u8
+      - ``load_chroma_non_intra_quantiser_matrix``
+      - One bit to indicate whether to load the
+	``chroma_non_intra_quantiser_matrix`` data, only relevant for non-4:2:0
+	YUV formats.
+    * - __u8
+      - ``intra_quantiser_matrix[64]``
+      - The quantization matrix coefficients for intra-coded frames, in zigzag
+	scanning order. It is relevant for both luma and chroma components,
+	although it can be superseded by the chroma-specific matrix for
+	non-4:2:0 YUV formats.
+    * - __u8
+      - ``non_intra_quantiser_matrix[64]``
+      - The quantization matrix coefficients for non-intra-coded frames, in
+	zigzag scanning order. It is relevant for both luma and chroma
+	components, although it can be superseded by the chroma-specific matrix
+	for non-4:2:0 YUV formats.
+    * - __u8
+      - ``chroma_intra_quantiser_matrix[64]``
+      - The quantization matrix coefficients for the chominance component of
+	intra-coded frames, in zigzag scanning order. Only relevant for
+	non-4:2:0 YUV formats.
+    * - __u8
+      - ``chroma_non_intra_quantiser_matrix[64]``
+      - The quantization matrix coefficients for the chrominance component of
+	non-intra-coded frames, in zigzag scanning order. Only relevant for
+	non-4:2:0 YUV formats.
 
 MFC 5.1 MPEG Controls
 ---------------------
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index d382e7a5c38e..a86b59f770dd 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -60,6 +60,20 @@ Compressed Formats
       - ``V4L2_PIX_FMT_MPEG2``
       - 'MPG2'
       - MPEG2 video elementary stream.
+    * .. _V4L2-PIX-FMT-MPEG2-SLICE:
+
+      - ``V4L2_PIX_FMT_MPEG2_SLICE``
+      - 'MG2S'
+      - MPEG-2 parsed slice data, as extracted from the MPEG-2 bitstream.
+	This format is adapted for stateless video decoders that implement a
+	MPEG-2 pipeline (using the Memory to Memory and Media Request APIs).
+	Metadata associated with the frame to decode is required to be passed
+	through the ``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS`` control and
+	quantization matrices can optionally be specified through the
+	``V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION`` control.
+	See the :ref:`associated Codec Control IDs <v4l2-mpeg-mpeg2>`.
+	Buffers associated with this pixel format must contain the appropriate
+	number of macroblocks to decode a full corresponding frame.
     * .. _V4L2-PIX-FMT-MPEG4:
 
       - ``V4L2_PIX_FMT_MPEG4``
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 5bd26e8c9a1a..258f5813f281 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -424,8 +424,18 @@ See also the examples in :ref:`control`.
       - any
       - An unsigned 32-bit valued control ranging from minimum to maximum
 	inclusive. The step value indicates the increment between values.
-
-
+    * - ``V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_mpeg2_slice_params`, containing MPEG-2
+	slice parameters for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_MPEG2_QUANTIZATION``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_mpeg2_quantization`, containing MPEG-2
+	quantization matrices for stateless video decoders.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 99256a2c003e..30ba0d6f546f 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -129,6 +129,8 @@ replace symbol V4L2_CTRL_TYPE_STRING :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_U16 :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_MPEG2_QUANTIZATION :c:type:`v4l2_ctrl_type`
 
 # V4L2 capability defines
 replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 2a30be824491..50e5b65fb505 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -844,6 +844,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG-2 Slice Parameters";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG-2 Quantization Matrices";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1292,6 +1294,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:
+		*type = V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
+		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1550,6 +1558,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			union v4l2_ctrl_ptr ptr)
 {
+	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
 	size_t len;
 	u64 offset;
 	s64 val;
@@ -1612,6 +1621,54 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	case V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS:
+		p_mpeg2_slice_params = ptr.p;
+
+		switch (p_mpeg2_slice_params->sequence.chroma_format) {
+		case 1: /* 4:2:0 */
+		case 2: /* 4:2:2 */
+		case 3: /* 4:4:4 */
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		switch (p_mpeg2_slice_params->picture.intra_dc_precision) {
+		case 0: /* 8 bits */
+		case 1: /* 9 bits */
+		case 11: /* 11 bits */
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		switch (p_mpeg2_slice_params->picture.picture_structure) {
+		case 1: /* interlaced top field */
+		case 2: /* interlaced bottom field */
+		case 3: /* progressive */
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		switch (p_mpeg2_slice_params->picture.picture_coding_type) {
+		case V4L2_MPEG2_PICTURE_CODING_TYPE_I:
+		case V4L2_MPEG2_PICTURE_CODING_TYPE_P:
+		case V4L2_MPEG2_PICTURE_CODING_TYPE_B:
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (p_mpeg2_slice_params->backward_ref_index >= VIDEO_MAX_FRAME ||
+		    p_mpeg2_slice_params->forward_ref_index >= VIDEO_MAX_FRAME)
+			return -EINVAL;
+
+		return 0;
+
+	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2186,6 +2243,12 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS:
+		elem_size = sizeof(struct v4l2_ctrl_mpeg2_slice_params);
+		break;
+	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
+		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2a84ca9e328a..192481afa09f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1309,6 +1309,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
 		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
 		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
+		case V4L2_PIX_FMT_MPEG2_SLICE:	descr = "MPEG-2 Parsed Slice Data"; break;
 		case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
 		case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 29e9d94e230c..222e84864bb7 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -35,13 +35,15 @@ struct poll_table_struct;
 
 /**
  * union v4l2_ctrl_ptr - A pointer to a control value.
- * @p_s32:	Pointer to a 32-bit signed value.
- * @p_s64:	Pointer to a 64-bit signed value.
- * @p_u8:	Pointer to a 8-bit unsigned value.
- * @p_u16:	Pointer to a 16-bit unsigned value.
- * @p_u32:	Pointer to a 32-bit unsigned value.
- * @p_char:	Pointer to a string.
- * @p:		Pointer to a compound value.
+ * @p_s32:			Pointer to a 32-bit signed value.
+ * @p_s64:			Pointer to a 64-bit signed value.
+ * @p_u8:			Pointer to a 8-bit unsigned value.
+ * @p_u16:			Pointer to a 16-bit unsigned value.
+ * @p_u32:			Pointer to a 32-bit unsigned value.
+ * @p_char:			Pointer to a string.
+ * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
+ * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
+ * @p:				Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
 	s32 *p_s32;
@@ -50,6 +52,8 @@ union v4l2_ctrl_ptr {
 	u16 *p_u16;
 	u32 *p_u32;
 	char *p_char;
+	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
+	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
 	void *p;
 };
 
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index e4ee10ee917d..51b095898f4b 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -402,6 +402,9 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 #define V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME		(V4L2_CID_MPEG_BASE+229)
 
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS		(V4L2_CID_MPEG_BASE+250)
+#define V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION		(V4L2_CID_MPEG_BASE+251)
+
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
 #define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP		(V4L2_CID_MPEG_BASE+302)
@@ -1092,4 +1095,66 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_I	1
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_P	2
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_B	3
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_D	4
+
+struct v4l2_mpeg2_sequence {
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence header */
+	__u16	horizontal_size;
+	__u16	vertical_size;
+	__u32	vbv_buffer_size;
+
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence extension */
+	__u8	profile_and_level_indication;
+	__u8	progressive_sequence;
+	__u8	chroma_format;
+};
+
+struct v4l2_mpeg2_picture {
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Picture header */
+	__u8	picture_coding_type;
+
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Picture coding extension */
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
+	__u8	progressive_frame;
+};
+
+struct v4l2_ctrl_mpeg2_slice_params {
+	__u32	bit_size;
+	__u32	data_bit_offset;
+
+	struct v4l2_mpeg2_sequence sequence;
+	struct v4l2_mpeg2_picture picture;
+
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Slice */
+	__u8	quantiser_scale_code;
+
+	__u8	backward_ref_index;
+	__u8	forward_ref_index;
+};
+
+struct v4l2_ctrl_mpeg2_quantization {
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Quant matrix extension */
+	__u8	load_intra_quantiser_matrix;
+	__u8	load_non_intra_quantiser_matrix;
+	__u8	load_chroma_intra_quantiser_matrix;
+	__u8	load_chroma_non_intra_quantiser_matrix;
+
+	__u8	intra_quantiser_matrix[64];
+	__u8	non_intra_quantiser_matrix[64];
+	__u8	chroma_intra_quantiser_matrix[64];
+	__u8	chroma_non_intra_quantiser_matrix[64];
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 91126b7312f8..08d2af1bae0b 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -635,6 +635,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
+#define V4L2_PIX_FMT_MPEG2_SLICE v4l2_fourcc('M', 'G', '2', 'S') /* MPEG-2 parsed slice data */
 #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
@@ -1594,6 +1595,8 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_mpeg2_slice_params __user *p_mpeg2_slice_params;
+		struct v4l2_ctrl_mpeg2_quantization __user *p_mpeg2_quantization;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1639,6 +1642,8 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS = 0x0103,
+	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION = 0x0104,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.18.0
