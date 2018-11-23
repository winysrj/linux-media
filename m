Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59752 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394808AbeKWXqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 18:46:21 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 1/2] media: v4l: Add definitions for the HEVC slice format and controls
Date: Fri, 23 Nov 2018 14:02:08 +0100
Message-Id: <20181123130209.11696-2-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces the required definitions for HEVC decoding support with
stateless VPUs. The controls associated to the HEVC slice format provide
the required meta-data for decoding slices extracted from the bitstream.

This interface comes with the following limitations:
* No custom quantization matrices (scaling lists);
* Support for a single temporal layer only;
* No slice entry point offsets support;
* No conformance window support;
* No VUI parameters support;
* No support for SPS extensions: range, multilayer, 3d, scc, 4 bits;
* No support for PPS extensions: range, multilayer, 3d, scc, 4 bits.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 Documentation/media/uapi/v4l/biblio.rst       |   9 +
 .../media/uapi/v4l/extended-controls.rst      | 417 ++++++++++++++++++
 .../media/uapi/v4l/pixfmt-compressed.rst      |  15 +
 .../media/uapi/v4l/vidioc-queryctrl.rst       |  18 +
 .../media/videodev2.h.rst.exceptions          |   3 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |  26 ++
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 include/media/v4l2-ctrls.h                    |   6 +
 include/uapi/linux/v4l2-controls.h            | 155 +++++++
 include/uapi/linux/v4l2-controls.h.rej        | 187 --------
 include/uapi/linux/videodev2.h                |   7 +
 11 files changed, 657 insertions(+), 187 deletions(-)
 delete mode 100644 include/uapi/linux/v4l2-controls.h.rej

diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
index 73aeb7ce47d2..59a98feca3a1 100644
--- a/Documentation/media/uapi/v4l/biblio.rst
+++ b/Documentation/media/uapi/v4l/biblio.rst
@@ -124,6 +124,15 @@ ITU H.264
 
 :author:    International Telecommunication Union (http://www.itu.ch)
 
+.. _hevc:
+
+ITU H.265/HEVC
+==============
+
+:title:     ITU-T Rec. H.265 | ISO/IEC 23008-2 "High Efficiency Video Coding"
+
+:author:    International Telecommunication Union (http://www.itu.ch), International Organisation for Standardisation (http://www.iso.ch)
+
 .. _jfif:
 
 JFIF
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 87c0d151577f..906ff4f32634 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -2038,6 +2038,423 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - ``flags``
       -
 
+.. _v4l2-mpeg-hevc:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_SPS (struct)``
+    Specifies the Sequence Parameter Set fields (as extracted from the
+    bitstream) for the associated HEVC slice data.
+    These bitstream parameters are defined according to :ref:`hevc`.
+    Refer to the specification for the documentation of these fields.
+
+.. c:type:: v4l2_ctrl_hevc_sps
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_hevc_sps
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``chroma_format_idc``
+      -
+    * - __u8
+      - ``separate_colour_plane_flag``
+      -
+    * - __u16
+      - ``pic_width_in_luma_samples``
+      -
+    * - __u16
+      - ``pic_height_in_luma_samples``
+      -
+    * - __u8
+      - ``bit_depth_luma_minus8``
+      -
+    * - __u8
+      - ``bit_depth_chroma_minus8``
+      -
+    * - __u8
+      - ``log2_max_pic_order_cnt_lsb_minus4``
+      -
+    * - __u8
+      - ``sps_max_dec_pic_buffering_minus1``
+      -
+    * - __u8
+      - ``sps_max_num_reorder_pics``
+      -
+    * - __u8
+      - ``sps_max_latency_increase_plus1``
+      -
+    * - __u8
+      - ``log2_min_luma_coding_block_size_minus3``
+      -
+    * - __u8
+      - ``log2_diff_max_min_luma_coding_block_size``
+      -
+    * - __u8
+      - ``log2_min_luma_transform_block_size_minus2``
+      -
+    * - __u8
+      - ``log2_diff_max_min_luma_transform_block_size``
+      -
+    * - __u8
+      - ``max_transform_hierarchy_depth_inter``
+      -
+    * - __u8
+      - ``max_transform_hierarchy_depth_intra``
+      -
+    * - __u8
+      - ``scaling_list_enabled_flag``
+      -
+    * - __u8
+      - ``amp_enabled_flag``
+      -
+    * - __u8
+      - ``sample_adaptive_offset_enabled_flag``
+      -
+    * - __u8
+      - ``pcm_enabled_flag``
+      -
+    * - __u8
+      - ``pcm_sample_bit_depth_luma_minus1``
+      -
+    * - __u8
+      - ``pcm_sample_bit_depth_chroma_minus1``
+      -
+    * - __u8
+      - ``log2_min_pcm_luma_coding_block_size_minus3``
+      -
+    * - __u8
+      - ``log2_diff_max_min_pcm_luma_coding_block_size``
+      -
+    * - __u8
+      - ``pcm_loop_filter_disabled_flag``
+      -
+    * - __u8
+      - ``num_short_term_ref_pic_sets``
+      -
+    * - __u8
+      - ``long_term_ref_pics_present_flag``
+      -
+    * - __u8
+      - ``num_long_term_ref_pics_sps``
+      -
+    * - __u8
+      - ``sps_temporal_mvp_enabled_flag``
+      -
+    * - __u8
+      - ``strong_intra_smoothing_enabled_flag``
+      -
+
+``V4L2_CID_MPEG_VIDEO_HEVC_PPS (struct)``
+    Specifies the Picture Parameter Set fields (as extracted from the
+    bitstream) for the associated HEVC slice data.
+    These bitstream parameters are defined according to :ref:`hevc`.
+    Refer to the specification for the documentation of these fields.
+
+.. c:type:: v4l2_ctrl_hevc_pps
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_hevc_pps
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``dependent_slice_segment_flag``
+      -
+    * - __u8
+      - ``output_flag_present_flag``
+      -
+    * - __u8
+      - ``num_extra_slice_header_bits``
+      -
+    * - __u8
+      - ``sign_data_hiding_enabled_flag``
+      -
+    * - __u8
+      - ``cabac_init_present_flag``
+      -
+    * - __s8
+      - ``init_qp_minus26``
+      -
+    * - __u8
+      - ``constrained_intra_pred_flag``
+      -
+    * - __u8
+      - ``transform_skip_enabled_flag``
+      -
+    * - __u8
+      - ``cu_qp_delta_enabled_flag``
+      -
+    * - __u8
+      - ``diff_cu_qp_delta_depth``
+      -
+    * - __s8
+      - ``pps_cb_qp_offset``
+      -
+    * - __s8
+      - ``pps_cr_qp_offset``
+      -
+    * - __u8
+      - ``pps_slice_chroma_qp_offsets_present_flag``
+      -
+    * - __u8
+      - ``weighted_pred_flag``
+      -
+    * - __u8
+      - ``weighted_bipred_flag``
+      -
+    * - __u8
+      - ``transquant_bypass_enabled_flag``
+      -
+    * - __u8
+      - ``tiles_enabled_flag``
+      -
+    * - __u8
+      - ``entropy_coding_sync_enabled_flag``
+      -
+    * - __u8
+      - ``num_tile_columns_minus1``
+      -
+    * - __u8
+      - ``num_tile_rows_minus1``
+      -
+    * - __u8
+      - ``column_width_minus1[20]``
+      -
+    * - __u8
+      - ``row_height_minus1[22]``
+      -
+    * - __u8
+      - ``loop_filter_across_tiles_enabled_flag``
+      -
+    * - __u8
+      - ``pps_loop_filter_across_slices_enabled_flag``
+      -
+    * - __u8
+      - ``deblocking_filter_override_enabled_flag``
+      -
+    * - __u8
+      - ``pps_disable_deblocking_filter_flag``
+      -
+    * - __s8
+      - ``pps_beta_offset_div2``
+      -
+    * - __s8
+      - ``pps_tc_offset_div2``
+      -
+    * - __u8
+      - ``lists_modification_present_flag``
+      -
+    * - __u8
+      - ``log2_parallel_merge_level_minus2``
+      -
+    * - __u8
+      - ``slice_segment_header_extension_present_flag``
+      -
+
+``V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS (struct)``
+    Specifies various slice-specific parameters, especially from the NAL unit
+    header, general slice segment header and weighted prediction parameter
+    parts of the bitstream.
+    These bitstream parameters are defined according to :ref:`hevc`.
+    Refer to the specification for the documentation of these fields.
+
+.. c:type:: v4l2_ctrl_hevc_slice_params
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_hevc_slice_params
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
+    * - __u8
+      - ``nal_unit_type``
+      -
+    * - __u8
+      - ``nuh_temporal_id_plus1``
+      -
+    * - __u8
+      - ``slice_type``
+      -
+	(V4L2_HEVC_SLICE_TYPE_I, V4L2_HEVC_SLICE_TYPE_P or
+	V4L2_HEVC_SLICE_TYPE_B).
+    * - __u8
+      - ``colour_plane_id``
+      -
+    * - __u16
+      - ``slice_pic_order_cnt``
+      -
+    * - __u8
+      - ``slice_sao_luma_flag``
+      -
+    * - __u8
+      - ``slice_sao_chroma_flag``
+      -
+    * - __u8
+      - ``slice_temporal_mvp_enabled_flag``
+      -
+    * - __u8
+      - ``num_ref_idx_l0_active_minus1``
+      -
+    * - __u8
+      - ``num_ref_idx_l1_active_minus1``
+      -
+    * - __u8
+      - ``mvd_l1_zero_flag``
+      -
+    * - __u8
+      - ``cabac_init_flag``
+      -
+    * - __u8
+      - ``collocated_from_l0_flag``
+      -
+    * - __u8
+      - ``collocated_ref_idx``
+      -
+    * - __u8
+      - ``five_minus_max_num_merge_cand``
+      -
+    * - __u8
+      - ``use_integer_mv_flag``
+      -
+    * - __s8
+      - ``slice_qp_delta``
+      -
+    * - __s8
+      - ``slice_cb_qp_offset``
+      -
+    * - __s8
+      - ``slice_cr_qp_offset``
+      -
+    * - __s8
+      - ``slice_act_y_qp_offset``
+      -
+    * - __s8
+      - ``slice_act_cb_qp_offset``
+      -
+    * - __s8
+      - ``slice_act_cr_qp_offset``
+      -
+    * - __u8
+      - ``slice_deblocking_filter_disabled_flag``
+      -
+    * - __s8
+      - ``slice_beta_offset_div2``
+      -
+    * - __s8
+      - ``slice_tc_offset_div2``
+      -
+    * - __u8
+      - ``slice_loop_filter_across_slices_enabled_flag``
+      -
+    * - __u8
+      - ``pic_struct``
+      -
+    * - struct :c:type:`v4l2_hevc_dpb_entry`
+      - ``dpb[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      - The decoded picture buffer, for meta-data about reference frames.
+    * - __u8
+      - ``num_active_dpb_entries``
+      - The number of entries in ``dpb``.
+    * - __u8
+      - ``ref_idx_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      - The list of L0 reference elements as indices in the DPB.
+    * - __u8
+      - ``ref_idx_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      - The list of L1 reference elements as indices in the DPB.
+    * - __u8
+      - ``num_rps_poc_st_curr_before``
+      - The number of reference pictures in the short-term set that come before
+        the current frame.
+    * - __u8
+      - ``num_rps_poc_st_curr_after``
+      - The number of reference pictures in the short-term set that come after
+        the current frame.
+    * - __u8
+      - ``num_rps_poc_lt_curr``
+      - The number of reference pictures in the long-term set.
+    * - struct :c:type:`v4l2_hevc_pred_weight_table`
+      - ``pred_weight_table``
+      - The prediction weight coefficients for inter-picture prediction.
+
+.. c:type:: v4l2_hevc_dpb_entry
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_hevc_dpb_entry
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``buffer_tag``
+      - The V4L2 buffer tag that matches the associated reference picture.
+    * - __u8
+      - ``rps``
+      - The reference set for the reference frame
+        (V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_BEFORE,
+        V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_AFTER or
+        V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR)
+    * - __u8
+      - ``field_pic``
+      - Whether the reference is a field picture or a frame.
+    * - __u16
+      - ``pic_order_cnt[2]``
+      - The picture order count of the reference. Only the first element of the
+        array is used for frame pictures, while the first element identifies the
+        top field and the second the bottom field in field-coded pictures.
+
+.. c:type:: v4l2_hevc_pred_weight_table
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_hevc_pred_weight_table
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``luma_log2_weight_denom``
+      -
+    * - __s8
+      - ``delta_chroma_log2_weight_denom``
+      -
+    * - __s8
+      - ``delta_luma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      -
+    * - __s8
+      - ``luma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      -
+    * - __s8
+      - ``delta_chroma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
+      -
+    * - __s8
+      - ``chroma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
+      -
+    * - __s8
+      - ``delta_luma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      -
+    * - __s8
+      - ``luma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
+      -
+    * - __s8
+      - ``delta_chroma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
+      -
+    * - __s8
+      - ``chroma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
+      -
+
+
 MFC 5.1 MPEG Controls
 ---------------------
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index f15fc1c8d479..572a43bfe9c9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -131,6 +131,21 @@ Compressed Formats
       - ``V4L2_PIX_FMT_HEVC``
       - 'HEVC'
       - HEVC/H.265 video elementary stream.
+    * .. _V4L2-PIX-FMT-HEVC-SLICE:
+
+      - ``V4L2_PIX_FMT_HEVC_SLICE``
+      - 'S265'
+      - HEVC parsed slice data, as extracted from the HEVC bitstream.
+	This format is adapted for stateless video decoders that implement a
+	HEVC pipeline (using the :ref:`codec` and :ref:`media-request-api`).
+	Metadata associated with the frame to decode is required to be passed
+	through the following controls :
+        * ``V4L2_CID_MPEG_VIDEO_HEVC_SPS``
+        * ``V4L2_CID_MPEG_VIDEO_HEVC_PPS``
+        * ``V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS``
+	See the :ref:`associated Codec Control IDs <v4l2-mpeg-hevc>`.
+	Buffers associated with this pixel format must contain the appropriate
+	number of macroblocks to decode a full corresponding frame.
     * .. _V4L2-PIX-FMT-FWHT:
 
       - ``V4L2_PIX_FMT_FWHT``
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 38a9c988124c..8e0cc836058d 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -466,6 +466,24 @@ See also the examples in :ref:`control`.
       - n/a
       - A struct :c:type:`v4l2_ctrl_h264_decode_param`, containing H264
 	decode parameters for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_HEVC_SPS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_hevc_sps`, containing HEVC Sequence
+	Parameter Set for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_HEVC_PPS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_hevc_pps`, containing HEVC Picture
+	Parameter Set for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_hevc_slice_params`, containing HEVC
+	slice parameters for stateless video decoders.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 99f1bd2bc44c..27978d8b18f5 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -138,6 +138,9 @@ replace symbol V4L2_CTRL_TYPE_H264_PPS :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_H264_SCALING_MATRIX :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_H264_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_H264_DECODE_PARAMS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_HEVC_SPS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_HEVC_PPS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
 
 # V4L2 capability defines
 replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e96c453208e8..9af17815ecc3 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -913,6 +913,9 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of Length Field";
 	case V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES:	return "Reference Frames for a P-Frame";
 	case V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR:		return "Prepend SPS and PPS to IDR";
+	case V4L2_CID_MPEG_VIDEO_HEVC_SPS:			return "HEVC Sequence Parameter Set";
+	case V4L2_CID_MPEG_VIDEO_HEVC_PPS:			return "HEVC Picture Parameter Set";
+	case V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS:		return "HEVC Slice Parameters";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1320,6 +1323,15 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
 		*type = V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_SPS:
+		*type = V4L2_CTRL_TYPE_HEVC_SPS;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_PPS:
+		*type = V4L2_CTRL_TYPE_HEVC_PPS;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS:
+		*type = V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1692,6 +1704,11 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
 		return 0;
 
+	case V4L2_CTRL_TYPE_HEVC_SPS:
+	case V4L2_CTRL_TYPE_HEVC_PPS:
+	case V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2287,6 +2304,15 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
 		elem_size = sizeof(struct v4l2_ctrl_h264_decode_param);
 		break;
+	case V4L2_CTRL_TYPE_HEVC_SPS:
+		elem_size = sizeof(struct v4l2_ctrl_hevc_sps);
+		break;
+	case V4L2_CTRL_TYPE_HEVC_PPS:
+		elem_size = sizeof(struct v4l2_ctrl_hevc_pps);
+		break;
+	case V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS:
+		elem_size = sizeof(struct v4l2_ctrl_hevc_slice_params);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa63f1794272..7bec91c6effe 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1321,6 +1321,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
 		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
 		case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break; /* aka H.265 */
+		case V4L2_PIX_FMT_HEVC_SLICE:	descr = "HEVC Parsed Slice Data"; break;
 		case V4L2_PIX_FMT_FWHT:		descr = "FWHT"; break; /* used in vicodec */
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index b4ca95710d2d..11664c5c3706 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -48,6 +48,9 @@ struct poll_table_struct;
  * @p_h264_scal_mtrx:		Pointer to a struct v4l2_ctrl_h264_scaling_matrix.
  * @p_h264_slice_param:		Pointer to a struct v4l2_ctrl_h264_slice_param.
  * @p_h264_decode_param:	Pointer to a struct v4l2_ctrl_h264_decode_param.
+ * @p_hevc_sps:			Pointer to an HEVC sequence parameter set structure.
+ * @p_hevc_pps:			Pointer to an HEVC picture parameter set structure.
+ * @p_hevc_slice_params		Pointer to an HEVC slice parameters structure.
  * @p:				Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -64,6 +67,9 @@ union v4l2_ctrl_ptr {
 	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scal_mtrx;
 	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
 	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
+	struct v4l2_ctrl_hevc_sps *p_hevc_sps;
+	struct v4l2_ctrl_hevc_pps *p_hevc_pps;
+	struct v4l2_ctrl_hevc_slice_params *p_hevc_slice_params;
 	void *p;
 };
 
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 628c0cdb51d9..5bbf63b2dad1 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -709,6 +709,9 @@ enum v4l2_cid_mpeg_video_hevc_size_of_length_field {
 #define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR	(V4L2_CID_MPEG_BASE + 642)
 #define V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES	(V4L2_CID_MPEG_BASE + 643)
 #define V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR	(V4L2_CID_MPEG_BASE + 644)
+#define V4L2_CID_MPEG_VIDEO_HEVC_SPS			(V4L2_CID_MPEG_BASE + 645)
+#define V4L2_CID_MPEG_VIDEO_HEVC_PPS			(V4L2_CID_MPEG_BASE + 646)
+#define V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS		(V4L2_CID_MPEG_BASE + 647)
 
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE				(V4L2_CTRL_CLASS_MPEG | 0x1000)
@@ -1324,4 +1327,156 @@ struct v4l2_ctrl_h264_decode_param {
 	struct v4l2_h264_dpb_entry dpb[16];
 };
 
+#define V4L2_HEVC_SLICE_TYPE_B	0
+#define V4L2_HEVC_SLICE_TYPE_P	1
+#define V4L2_HEVC_SLICE_TYPE_I	2
+
+struct v4l2_ctrl_hevc_sps {
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Sequence parameter set */
+	__u8	chroma_format_idc;
+	__u8	separate_colour_plane_flag;
+	__u16	pic_width_in_luma_samples;
+	__u16	pic_height_in_luma_samples;
+	__u8	bit_depth_luma_minus8;
+	__u8	bit_depth_chroma_minus8;
+	__u8	log2_max_pic_order_cnt_lsb_minus4;
+	__u8	sps_max_dec_pic_buffering_minus1;
+	__u8	sps_max_num_reorder_pics;
+	__u8	sps_max_latency_increase_plus1;
+	__u8	log2_min_luma_coding_block_size_minus3;
+	__u8	log2_diff_max_min_luma_coding_block_size;
+	__u8	log2_min_luma_transform_block_size_minus2;
+	__u8	log2_diff_max_min_luma_transform_block_size;
+	__u8	max_transform_hierarchy_depth_inter;
+	__u8	max_transform_hierarchy_depth_intra;
+	__u8	scaling_list_enabled_flag;
+	__u8	amp_enabled_flag;
+	__u8	sample_adaptive_offset_enabled_flag;
+	__u8	pcm_enabled_flag;
+	__u8	pcm_sample_bit_depth_luma_minus1;
+	__u8	pcm_sample_bit_depth_chroma_minus1;
+	__u8	log2_min_pcm_luma_coding_block_size_minus3;
+	__u8	log2_diff_max_min_pcm_luma_coding_block_size;
+	__u8	pcm_loop_filter_disabled_flag;
+	__u8	num_short_term_ref_pic_sets;
+	__u8	long_term_ref_pics_present_flag;
+	__u8	num_long_term_ref_pics_sps;
+	__u8	sps_temporal_mvp_enabled_flag;
+	__u8	strong_intra_smoothing_enabled_flag;
+};
+
+struct v4l2_ctrl_hevc_pps {
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Picture parameter set */
+	__u8	dependent_slice_segment_flag;
+	__u8	output_flag_present_flag;
+	__u8	num_extra_slice_header_bits;
+	__u8	sign_data_hiding_enabled_flag;
+	__u8	cabac_init_present_flag;
+	__s8	init_qp_minus26;
+	__u8	constrained_intra_pred_flag;
+	__u8	transform_skip_enabled_flag;
+	__u8	cu_qp_delta_enabled_flag;
+	__u8	diff_cu_qp_delta_depth;
+	__s8	pps_cb_qp_offset;
+	__s8	pps_cr_qp_offset;
+	__u8	pps_slice_chroma_qp_offsets_present_flag;
+	__u8	weighted_pred_flag;
+	__u8	weighted_bipred_flag;
+	__u8	transquant_bypass_enabled_flag;
+	__u8	tiles_enabled_flag;
+	__u8	entropy_coding_sync_enabled_flag;
+	__u8	num_tile_columns_minus1;
+	__u8	num_tile_rows_minus1;
+	__u8	column_width_minus1[20];
+	__u8	row_height_minus1[22];
+	__u8	loop_filter_across_tiles_enabled_flag;
+	__u8	pps_loop_filter_across_slices_enabled_flag;
+	__u8	deblocking_filter_override_enabled_flag;
+	__u8	pps_disable_deblocking_filter_flag;
+	__s8	pps_beta_offset_div2;
+	__s8	pps_tc_offset_div2;
+	__u8	lists_modification_present_flag;
+	__u8	log2_parallel_merge_level_minus2;
+	__u8	slice_segment_header_extension_present_flag;
+};
+
+#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_BEFORE	0x01
+#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_AFTER	0x02
+#define V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR		0x03
+
+#define V4L2_HEVC_DPB_ENTRIES_NUM_MAX		16
+
+struct v4l2_hevc_dpb_entry {
+	__u32	buffer_tag;
+	__u8	rps;
+	__u8	field_pic;
+	__u16	pic_order_cnt[2];
+};
+
+struct v4l2_hevc_pred_weight_table {
+	__u8	luma_log2_weight_denom;
+	__s8	delta_chroma_log2_weight_denom;
+
+	__s8	delta_luma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+	__s8	luma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+	__s8	delta_chroma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
+	__s8	chroma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
+
+	__s8	delta_luma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+	__s8	luma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+	__s8	delta_chroma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
+	__s8	chroma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
+};
+
+struct v4l2_ctrl_hevc_slice_params {
+	__u32	bit_size;
+	__u32	data_bit_offset;
+
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: NAL unit header */
+	__u8	nal_unit_type;
+	__u8	nuh_temporal_id_plus1;
+
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
+	__u8	slice_type;
+	__u8	colour_plane_id;
+	__u16	slice_pic_order_cnt;
+	__u8	slice_sao_luma_flag;
+	__u8	slice_sao_chroma_flag;
+	__u8	slice_temporal_mvp_enabled_flag;
+	__u8	num_ref_idx_l0_active_minus1;
+	__u8	num_ref_idx_l1_active_minus1;
+	__u8	mvd_l1_zero_flag;
+	__u8	cabac_init_flag;
+	__u8	collocated_from_l0_flag;
+	__u8	collocated_ref_idx;
+	__u8	five_minus_max_num_merge_cand;
+	__u8	use_integer_mv_flag;
+	__s8	slice_qp_delta;
+	__s8	slice_cb_qp_offset;
+	__s8	slice_cr_qp_offset;
+	__s8	slice_act_y_qp_offset;
+	__s8	slice_act_cb_qp_offset;
+	__s8	slice_act_cr_qp_offset;
+	__u8	slice_deblocking_filter_disabled_flag;
+	__s8	slice_beta_offset_div2;
+	__s8	slice_tc_offset_div2;
+	__u8	slice_loop_filter_across_slices_enabled_flag;
+
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Picture timing SEI message */
+	__u8	pic_struct;
+
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
+	struct v4l2_hevc_dpb_entry dpb[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+	__u8	num_active_dpb_entries;
+	__u8	ref_idx_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+	__u8	ref_idx_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
+
+	__u8	num_rps_poc_st_curr_before;
+	__u8	num_rps_poc_st_curr_after;
+	__u8	num_rps_poc_lt_curr;
+
+	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Weighted prediction parameter */
+	struct v4l2_hevc_pred_weight_table pred_weight_table;
+};
+
 #endif
diff --git a/include/uapi/linux/v4l2-controls.h.rej b/include/uapi/linux/v4l2-controls.h.rej
deleted file mode 100644
index 1fbb7bf8daa7..000000000000
--- a/include/uapi/linux/v4l2-controls.h.rej
+++ /dev/null
@@ -1,187 +0,0 @@
---- include/uapi/linux/v4l2-controls.h
-+++ include/uapi/linux/v4l2-controls.h
-@@ -50,6 +50,8 @@
- #ifndef __LINUX_V4L2_CONTROLS_H
- #define __LINUX_V4L2_CONTROLS_H
- 
-+#include <linux/types.h>
-+
- /* Control classes */
- #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
- #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
-@@ -534,6 +536,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
- };
- #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
- #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
-+#define V4L2_CID_MPEG_VIDEO_H264_SPS		(V4L2_CID_MPEG_BASE+383)
-+#define V4L2_CID_MPEG_VIDEO_H264_PPS		(V4L2_CID_MPEG_BASE+384)
-+#define V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX	(V4L2_CID_MPEG_BASE+385)
-+#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+386)
-+#define V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS	(V4L2_CID_MPEG_BASE+387)
-+
- #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
- #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
- #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
-@@ -1156,4 +1164,162 @@ struct v4l2_ctrl_mpeg2_quantization {
- 	__u8	chroma_non_intra_quantiser_matrix[64];
- };
- 
-+/* Compounds controls */
-+
-+#define V4L2_H264_SPS_CONSTRAINT_SET0_FLAG			0x01
-+#define V4L2_H264_SPS_CONSTRAINT_SET1_FLAG			0x02
-+#define V4L2_H264_SPS_CONSTRAINT_SET2_FLAG			0x04
-+#define V4L2_H264_SPS_CONSTRAINT_SET3_FLAG			0x08
-+#define V4L2_H264_SPS_CONSTRAINT_SET4_FLAG			0x10
-+#define V4L2_H264_SPS_CONSTRAINT_SET5_FLAG			0x20
-+
-+#define V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE		0x01
-+#define V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS	0x02
-+#define V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO		0x04
-+#define V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED	0x08
-+#define V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY			0x10
-+#define V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD		0x20
-+#define V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE			0x40
-+
-+struct v4l2_ctrl_h264_sps {
-+	__u8 profile_idc;
-+	__u8 constraint_set_flags;
-+	__u8 level_idc;
-+	__u8 seq_parameter_set_id;
-+	__u8 chroma_format_idc;
-+	__u8 bit_depth_luma_minus8;
-+	__u8 bit_depth_chroma_minus8;
-+	__u8 log2_max_frame_num_minus4;
-+	__u8 pic_order_cnt_type;
-+	__u8 log2_max_pic_order_cnt_lsb_minus4;
-+	__u8 max_num_ref_frames;
-+	__u8 num_ref_frames_in_pic_order_cnt_cycle;
-+	__s32 offset_for_ref_frame[255];
-+	__s32 offset_for_non_ref_pic;
-+	__s32 offset_for_top_to_bottom_field;
-+	__u16 pic_width_in_mbs_minus1;
-+	__u16 pic_height_in_map_units_minus1;
-+	__u8 flags;
-+};
-+
-+#define V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE				0x0001
-+#define V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT	0x0002
-+#define V4L2_H264_PPS_FLAG_WEIGHTED_PRED				0x0004
-+#define V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT		0x0008
-+#define V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED			0x0010
-+#define V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT			0x0020
-+#define V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE				0x0040
-+#define V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT			0x0080
-+
-+struct v4l2_ctrl_h264_pps {
-+	__u8 pic_parameter_set_id;
-+	__u8 seq_parameter_set_id;
-+	__u8 num_slice_groups_minus1;
-+	__u8 num_ref_idx_l0_default_active_minus1;
-+	__u8 num_ref_idx_l1_default_active_minus1;
-+	__u8 weighted_bipred_idc;
-+	__s8 pic_init_qp_minus26;
-+	__s8 pic_init_qs_minus26;
-+	__s8 chroma_qp_index_offset;
-+	__s8 second_chroma_qp_index_offset;
-+	__u8 flags;
-+};
-+
-+struct v4l2_ctrl_h264_scaling_matrix {
-+	__u8 scaling_list_4x4[6][16];
-+	__u8 scaling_list_8x8[6][64];
-+};
-+
-+struct v4l2_h264_weight_factors {
-+	__s8 luma_weight[32];
-+	__s8 luma_offset[32];
-+	__s8 chroma_weight[32][2];
-+	__s8 chroma_offset[32][2];
-+};
-+
-+struct v4l2_h264_pred_weight_table {
-+	__u8 luma_log2_weight_denom;
-+	__u8 chroma_log2_weight_denom;
-+	struct v4l2_h264_weight_factors weight_factors[2];
-+};
-+
-+#define V4L2_H264_SLICE_TYPE_P				0
-+#define V4L2_H264_SLICE_TYPE_B				1
-+#define V4L2_H264_SLICE_TYPE_I				2
-+#define V4L2_H264_SLICE_TYPE_SP				3
-+#define V4L2_H264_SLICE_TYPE_SI				4
-+
-+#define V4L2_H264_SLICE_FLAG_FIELD_PIC			0x01
-+#define V4L2_H264_SLICE_FLAG_BOTTOM_FIELD		0x02
-+#define V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED	0x04
-+#define V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH		0x08
-+
-+struct v4l2_ctrl_h264_slice_param {
-+	/* Size in bytes, including header */
-+	__u32 size;
-+	/* Offset in bits to slice_data() from the beginning of this slice. */
-+	__u32 header_bit_size;
-+
-+	__u16 first_mb_in_slice;
-+	__u8 slice_type;
-+	__u8 pic_parameter_set_id;
-+	__u8 colour_plane_id;
-+	__u16 frame_num;
-+	__u16 idr_pic_id;
-+	__u16 pic_order_cnt_lsb;
-+	__s32 delta_pic_order_cnt_bottom;
-+	__s32 delta_pic_order_cnt0;
-+	__s32 delta_pic_order_cnt1;
-+	__u8 redundant_pic_cnt;
-+
-+	struct v4l2_h264_pred_weight_table pred_weight_table;
-+	/* Size in bits of dec_ref_pic_marking() syntax element. */
-+	__u32 dec_ref_pic_marking_bit_size;
-+	/* Size in bits of pic order count syntax. */
-+	__u32 pic_order_cnt_bit_size;
-+
-+	__u8 cabac_init_idc;
-+	__s8 slice_qp_delta;
-+	__s8 slice_qs_delta;
-+	__u8 disable_deblocking_filter_idc;
-+	__s8 slice_alpha_c0_offset_div2;
-+	__s8 slice_beta_offset_div2;
-+	__u32 slice_group_change_cycle;
-+
-+	__u8 num_ref_idx_l0_active_minus1;
-+	__u8 num_ref_idx_l1_active_minus1;
-+	/*  Entries on each list are indices
-+	 *  into v4l2_ctrl_h264_decode_param.dpb[]. */
-+	__u8 ref_pic_list0[32];
-+	__u8 ref_pic_list1[32];
-+
-+	__u8 flags;
-+};
-+
-+#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
-+#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
-+#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM	0x04
-+
-+struct v4l2_h264_dpb_entry {
-+	__u32 tag;
-+	__u16 frame_num;
-+	__u16 pic_num;
-+	/* Note that field is indicated by v4l2_buffer.field */
-+	__s32 top_field_order_cnt;
-+	__s32 bottom_field_order_cnt;
-+	__u8 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
-+};
-+
-+struct v4l2_ctrl_h264_decode_param {
-+	__u32 num_slices;
-+	__u8 idr_pic_flag;
-+	__u8 nal_ref_idc;
-+	__s32 top_field_order_cnt;
-+	__s32 bottom_field_order_cnt;
-+	__u8 ref_pic_list_p0[32];
-+	__u8 ref_pic_list_b0[32];
-+	__u8 ref_pic_list_b1[32];
-+	struct v4l2_h264_dpb_entry dpb[16];
-+};
-+
- #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index dd028e0bf306..26f5bec9e988 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -655,6 +655,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
 #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC aka H.265 */
+#define V4L2_PIX_FMT_HEVC_SLICE v4l2_fourcc('S', '2', '6', '5') /* HEVC parsed slices */
 #define V4L2_PIX_FMT_FWHT     v4l2_fourcc('F', 'W', 'H', 'T') /* Fast Walsh Hadamard Transform (vicodec) */
 
 /*  Vendor-specific formats   */
@@ -1637,6 +1638,9 @@ struct v4l2_ext_control {
 		struct v4l2_ctrl_h264_scaling_matrix __user *p_h264_scal_mtrx;
 		struct v4l2_ctrl_h264_slice_param __user *p_h264_slice_param;
 		struct v4l2_ctrl_h264_decode_param __user *p_h264_decode_param;
+		struct v4l2_ctrl_hevc_sps __user *p_hevc_sps;
+		struct v4l2_ctrl_hevc_pps __user *p_hevc_pps;
+		struct v4l2_ctrl_hevc_slice_params __user *p_hevc_slice_params;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1689,6 +1693,9 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_H264_SCALING_MATRIX = 0x0107,
 	V4L2_CTRL_TYPE_H264_SLICE_PARAMS = 0x0108,
 	V4L2_CTRL_TYPE_H264_DECODE_PARAMS = 0x0109,
+	V4L2_CTRL_TYPE_HEVC_SPS = 0x0110,
+	V4L2_CTRL_TYPE_HEVC_PPS = 0x0111,
+	V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS = 0x0112,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.19.1
