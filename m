Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B07C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 15:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3480620811
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 15:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfCSP3n (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:29:43 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:56517 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfCSP3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 11:29:43 -0400
X-Originating-IP: 90.88.33.153
Received: from localhost (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id E54591BF211;
        Tue, 19 Mar 2019 15:29:33 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: [PATCH v6 1/2] media: uapi: Add H264 low-level decoder API compound controls.
Date:   Tue, 19 Mar 2019 16:29:27 +0100
Message-Id: <9d9fe5c2dc58f9398cb6b1e9bb208640d25ae816.1553009355.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.3917a1471bfc8cbdfdde8026566b3857caff5762.1553009355.git-series.maxime.ripard@bootlin.com>
References: <cover.3917a1471bfc8cbdfdde8026566b3857caff5762.1553009355.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Pawel Osciak <posciak@chromium.org>

Stateless video codecs will require both the H264 metadata and slices in
order to be able to decode frames.

This introduces the definitions for a new pixel format for H264 slices that
have been parsed, as well as the structures used to pass the metadata from
the userspace to the kernel.

Co-Developped-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/media/uapi/v4l/biblio.rst            |   9 +-
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst   | 569 ++++++++++++++-
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |  19 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  30 +-
 Documentation/media/videodev2.h.rst.exceptions     |   5 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  42 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +-
 include/media/h264-ctrls.h                         | 192 +++++-
 include/media/v4l2-ctrls.h                         |  13 +-
 include/uapi/linux/videodev2.h                     |   1 +-
 10 files changed, 880 insertions(+), 1 deletion(-)
 create mode 100644 include/media/h264-ctrls.h

diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
index ec33768c055e..8f4eb8823d82 100644
--- a/Documentation/media/uapi/v4l/biblio.rst
+++ b/Documentation/media/uapi/v4l/biblio.rst
@@ -122,6 +122,15 @@ ITU BT.1119
 
 :author:    International Telecommunication Union (http://www.itu.ch)
 
+.. _h264:
+
+ITU-T Rec. H.264 Specification (04/2017 Edition)
+================================================
+
+:title:     ITU-T Recommendation H.264 "Advanced Video Coding for Generic Audiovisual Services"
+
+:author:    International Telecommunication Union (http://www.itu.ch)
+
 .. _jfif:
 
 JFIF
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index c97fb7923be5..63659891671c 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -1343,6 +1343,575 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - Layer number
 
 
+.. _v4l2-mpeg-h264:
+
+``V4L2_CID_MPEG_VIDEO_H264_SPS (struct)``
+    Specifies the sequence parameter set (as extracted from the
+    bitstream) for the associated H264 slice data. This includes the
+    necessary parameters for configuring a stateless hardware decoding
+    pipeline for H264. The bitstream parameters are defined according
+    to :ref:`h264`, section 7.4.2.1.1 "Sequence Parameter Set Data
+    Semantics". For further documentation, refer to the above
+    specification, unless there is an explicit comment stating
+    otherwise.
+
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
+.. c:type:: v4l2_ctrl_h264_sps
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_h264_sps
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``profile_idc``
+      -
+    * - __u8
+      - ``constraint_set_flags``
+      - See :ref:`Sequence Parameter Set Constraints Set Flags <h264_sps_constraints_set_flags>`
+    * - __u8
+      - ``level_idc``
+      -
+    * - __u8
+      - ``seq_parameter_set_id``
+      -
+    * - __u8
+      - ``chroma_format_idc``
+      -
+    * - __u8
+      - ``bit_depth_luma_minus8``
+      -
+    * - __u8
+      - ``bit_depth_chroma_minus8``
+      -
+    * - __u8
+      - ``log2_max_frame_num_minus4``
+      -
+    * - __u8
+      - ``pic_order_cnt_type``
+      -
+    * - __u8
+      - ``log2_max_pic_order_cnt_lsb_minus4``
+      -
+    * - __u8
+      - ``max_num_ref_frames``
+      -
+    * - __u8
+      - ``num_ref_frames_in_pic_order_cnt_cycle``
+      -
+    * - __s32
+      - ``offset_for_ref_frame[255]``
+      -
+    * - __s32
+      - ``offset_for_non_ref_pic``
+      -
+    * - __s32
+      - ``offset_for_top_to_bottom_field``
+      -
+    * - __u16
+      - ``pic_width_in_mbs_minus1``
+      -
+    * - __u16
+      - ``pic_height_in_map_units_minus1``
+      -
+    * - __u32
+      - ``flags``
+      - See :ref:`Sequence Parameter Set Flags <h264_sps_flags>`
+
+.. _h264_sps_constraints_set_flags:
+
+``Sequence Parameter Set Constraints Set Flags``
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - ``V4L2_H264_SPS_CONSTRAINT_SET0_FLAG``
+      - 0x00000001
+      -
+    * - ``V4L2_H264_SPS_CONSTRAINT_SET1_FLAG``
+      - 0x00000002
+      -
+    * - ``V4L2_H264_SPS_CONSTRAINT_SET2_FLAG``
+      - 0x00000004
+      -
+    * - ``V4L2_H264_SPS_CONSTRAINT_SET3_FLAG``
+      - 0x00000008
+      -
+    * - ``V4L2_H264_SPS_CONSTRAINT_SET4_FLAG``
+      - 0x00000010
+      -
+    * - ``V4L2_H264_SPS_CONSTRAINT_SET5_FLAG``
+      - 0x00000020
+      -
+
+.. _h264_sps_flags:
+
+``Sequence Parameter Set Flags``
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - ``V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE``
+      - 0x00000001
+      -
+    * - ``V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS``
+      - 0x00000002
+      -
+    * - ``V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO``
+      - 0x00000004
+      -
+    * - ``V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED``
+      - 0x00000008
+      -
+    * - ``V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY``
+      - 0x00000010
+      -
+    * - ``V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD``
+      - 0x00000020
+      -
+    * - ``V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE``
+      - 0x00000040
+      -
+
+``V4L2_CID_MPEG_VIDEO_H264_PPS (struct)``
+    Specifies the picture parameter set (as extracted from the
+    bitstream) for the associated H264 slice data. This includes the
+    necessary parameters for configuring a stateless hardware decoding
+    pipeline for H264.  The bitstream parameters are defined according
+    to :ref:`h264`, section 7.4.2.2 "Picture Parameter Set RBSP
+    Semantics". For further documentation, refer to the above
+    specification, unless there is an explicit comment stating
+    otherwise.
+
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
+.. c:type:: v4l2_ctrl_h264_pps
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_h264_pps
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``pic_parameter_set_id``
+      -
+    * - __u8
+      - ``seq_parameter_set_id``
+      -
+    * - __u8
+      - ``num_slice_groups_minus1``
+      -
+    * - __u8
+      - ``num_ref_idx_l0_default_active_minus1``
+      -
+    * - __u8
+      - ``num_ref_idx_l1_default_active_minus1``
+      -
+    * - __u8
+      - ``weighted_bipred_idc``
+      -
+    * - __s8
+      - ``pic_init_qp_minus26``
+      -
+    * - __s8
+      - ``pic_init_qs_minus26``
+      -
+    * - __s8
+      - ``chroma_qp_index_offset``
+      -
+    * - __s8
+      - ``second_chroma_qp_index_offset``
+      -
+    * - __u16
+      - ``flags``
+      - See :ref:`Picture Parameter Set Flags <h264_pps_flags>`
+
+.. _h264_pps_flags:
+
+``Picture Parameter Set Flags``
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - ``V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE``
+      - 0x00000001
+      -
+    * - ``V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT``
+      - 0x00000002
+      -
+    * - ``V4L2_H264_PPS_FLAG_WEIGHTED_PRED``
+      - 0x00000004
+      -
+    * - ``V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT``
+      - 0x00000008
+      -
+    * - ``V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED``
+      - 0x00000010
+      -
+    * - ``V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT``
+      - 0x00000020
+      -
+    * - ``V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE``
+      - 0x00000040
+      -
+    * - ``V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT``
+      - 0x00000080
+      -
+
+``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX (struct)``
+    Specifies the scaling matrix (as extracted from the bitstream) for
+    the associated H264 slice data. The bitstream parameters are
+    defined according to :ref:`h264`, section 7.4.2.1.1.1 "Scaling
+    List Semantics".For further documentation, refer to the above
+    specification, unless there is an explicit comment stating
+    otherwise.
+
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
+.. c:type:: v4l2_ctrl_h264_scaling_matrix
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_h264_scaling_matrix
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``scaling_list_4x4[6][16]``
+      -
+    * - __u8
+      - ``scaling_list_8x8[6][64]``
+      -
+
+``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS (struct)``
+    Specifies the slice parameters (as extracted from the bitstream)
+    for the associated H264 slice data. This includes the necessary
+    parameters for configuring a stateless hardware decoding pipeline
+    for H264.  The bitstream parameters are defined according to
+    :ref:`h264`, section 7.4.3 "Slice Header Semantics". For further
+    documentation, refer to the above specification, unless there is
+    an explicit comment stating otherwise.
+
+    .. note::
+
+       This compound control is not yet part of the public kernel API
+       and it is expected to change.
+
+       This structure is expected to be passed as an array, with one
+       entry for each slice included in the bitstream buffer.
+
+.. c:type:: v4l2_ctrl_h264_slice_param
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_h264_slice_param
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``size``
+      -
+    * - __u32
+      - ``header_bit_size``
+      -
+    * - __u16
+      - ``first_mb_in_slice``
+      -
+    * - __u8
+      - ``slice_type``
+      -
+    * - __u8
+      - ``pic_parameter_set_id``
+      -
+    * - __u8
+      - ``colour_plane_id``
+      -
+    * - __u8
+      - ``redundant_pic_cnt``
+      -
+    * - __u16
+      - ``frame_num``
+      -
+    * - __u16
+      - ``idr_pic_id``
+      -
+    * - __u16
+      - ``pic_order_cnt_lsb``
+      -
+    * - __s32
+      - ``delta_pic_order_cnt_bottom``
+      -
+    * - __s32
+      - ``delta_pic_order_cnt0``
+      -
+    * - __s32
+      - ``delta_pic_order_cnt1``
+      -
+    * - struct :c:type:`v4l2_h264_pred_weight_table`
+      - ``pred_weight_table``
+      -
+    * - __u32
+      - ``dec_ref_pic_marking_bit_size``
+      -
+    * - __u32
+      - ``pic_order_cnt_bit_size``
+      -
+    * - __u8
+      - ``cabac_init_idc``
+      -
+    * - __s8
+      - ``slice_qp_delta``
+      -
+    * - __s8
+      - ``slice_qs_delta``
+      -
+    * - __u8
+      - ``disable_deblocking_filter_idc``
+      -
+    * - __s8
+      - ``slice_alpha_c0_offset_div2``
+      -
+    * - __s8
+      - ``slice_beta_offset_div2``
+      -
+    * - __u8
+      - ``num_ref_idx_l0_active_minus1``
+      -
+    * - __u8
+      - ``num_ref_idx_l1_active_minus1``
+      -
+    * - __u32
+      - ``slice_group_change_cycle``
+      -
+    * - __u8
+      - ``ref_pic_list0[32]``
+      - Reference picture list after applying the per-slice modifications
+    * - __u8
+      - ``ref_pic_list1[32]``
+      - Reference picture list after applying the per-slice modifications
+    * - __u32
+      - ``flags``
+      - See :ref:`Slice Parameter Flags <h264_slice_flags>`
+
+.. _h264_slice_flags:
+
+``Slice Parameter Set Flags``
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - ``V4L2_H264_SLICE_FLAG_FIELD_PIC``
+      - 0x00000001
+      -
+    * - ``V4L2_H264_SLICE_FLAG_BOTTOM_FIELD``
+      - 0x00000002
+      -
+    * - ``V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED``
+      - 0x00000004
+      -
+    * - ``V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH``
+      - 0x00000008
+      -
+
+``Prediction Weight Table``
+
+    The bitstream parameters are defined according to :ref:`h264`,
+    section 7.4.3.2 "Prediction Weight Table Semantics". For further
+    documentation, refer to the above specification, unless there is
+    an explicit comment stating otherwise.
+
+.. c:type:: v4l2_h264_pred_weight_table
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_h264_pred_weight_table
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u16
+      - ``luma_log2_weight_denom``
+      -
+    * - __u16
+      - ``chroma_log2_weight_denom``
+      -
+    * - struct :c:type:`v4l2_h264_weight_factors`
+      - ``weight_factors[2]``
+      - The weight factors at index 0 are the weight factors for the reference
+        list 0, the one at index 1 for the reference list 1.
+
+.. c:type:: v4l2_h264_weight_factors
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_h264_weight_factors
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __s16
+      - ``luma_weight[32]``
+      -
+    * - __s16
+      - ``luma_offset[32]``
+      -
+    * - __s16
+      - ``chroma_weight[32][2]``
+      -
+    * - __s16
+      - ``chroma_offset[32][2]``
+      -
+
+``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS (struct)``
+    Specifies the decode parameters (as extracted from the bitstream)
+    for the associated H264 slice data. This includes the necessary
+    parameters for configuring a stateless hardware decoding pipeline
+    for H264. The bitstream parameters are defined according to
+    :ref:`h264`. For further documentation, refer to the above
+    specification, unless there is an explicit comment stating
+    otherwise.
+
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
+.. c:type:: v4l2_ctrl_h264_decode_param
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_h264_decode_param
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``num_slices``
+      - Number of slices needed to decode the current frame
+    * - __u32
+      - ``nal_ref_idc``
+      - NAL reference ID value coming from the NAL Unit header
+    * - __u8
+      - ``ref_pic_list_p0[32]``
+      - Backward reference list used by P-frames in the original bitstream order
+    * - __u8
+      - ``ref_pic_list_b0[32]``
+      - Backward reference list used by B-frames in the original bitstream order
+    * - __u8
+      - ``ref_pic_list_b1[32]``
+      - Forward reference list used by B-frames in the original bitstream order
+    * - __s32
+      - ``top_field_order_cnt``
+      - Picture Order Count for the coded top field
+    * - __s32
+      - ``bottom_field_order_cnt``
+      - Picture Order Count for the coded bottom field
+    * - __u32
+      - ``flags``
+      - See :ref:`Decode Parameters Flags <h264_decode_params_flags>`
+    * - struct :c:type:`v4l2_h264_dpb_entry`
+      - ``dpb[16]``
+      -
+
+.. _h264_decode_params_flags:
+
+``Decode Parameters Flags``
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - ``V4L2_H264_DECODE_PARAM_FLAG_IDR_PIC``
+      - 0x00000001
+      - That picture is an IDR picture
+
+.. c:type:: v4l2_h264_dpb_entry
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_h264_dpb_entry
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``timestamp``
+      - Timestamp of the V4L2 capture buffer to use as reference, used
+        with B-coded and P-coded frames. The timestamp refers to the
+	``timestamp`` field in struct :c:type:`v4l2_buffer`. Use the
+	:c:func:`v4l2_timeval_to_ns()` function to convert the struct
+	:c:type:`timeval` in struct :c:type:`v4l2_buffer` to a __u64.
+    * - __u16
+      - ``frame_num``
+      -
+    * - __u16
+      - ``pic_num``
+      -
+    * - __s32
+      - ``top_field_order_cnt``
+      -
+    * - __s32
+      - ``bottom_field_order_cnt``
+      -
+    * - __u32
+      - ``flags``
+      - See :ref:`DPB Entry Flags <h264_dpb_flags>`
+
+.. _h264_dpb_flags:
+
+``DPB Entries Flags``
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - ``V4L2_H264_DPB_ENTRY_FLAG_VALID``
+      - 0x00000001
+      - The DPB entry is valid and should be considered
+    * - ``V4L2_H264_DPB_ENTRY_FLAG_ACTIVE``
+      - 0x00000002
+      - The DPB entry is currently being used as a reference frame
+    * - ``V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM``
+      - 0x00000004
+      - The DPB entry is a long term reference frame
 
 .. _v4l2-mpeg-mpeg2:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index 2675bef3eefe..8e5cc0b10b95 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -52,6 +52,25 @@ Compressed Formats
       - ``V4L2_PIX_FMT_H264_MVC``
       - 'M264'
       - H264 MVC video elementary stream.
+    * .. _V4L2-PIX-FMT-H264-SLICE:
+
+      - ``V4L2_PIX_FMT_H264_SLICE_RAW``
+      - 'S264'
+      - H264 parsed slice data, as extracted from the H264 bitstream.
+	This format is adapted for stateless video decoders that
+	implement an H264 pipeline (using the :ref:`codec` and
+	:ref:`media-request-api`).  Metadata associated with the frame
+	to decode are required to be passed through the
+	``V4L2_CID_MPEG_VIDEO_H264_SPS``,
+	``V4L2_CID_MPEG_VIDEO_H264_PPS``,
+	``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX``,
+	``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS`` and
+	``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS`` controls.  See the
+	:ref:`associated Codec Control IDs <v4l2-mpeg-h264>`.
+	Exactly one output and one capture buffer must be provided for
+	use with this pixel format. The output buffer must contain the
+	appropriate number of macroblocks to decode a full
+	corresponding frame to the matching capture buffer.
     * .. _V4L2-PIX-FMT-H263:
 
       - ``V4L2_PIX_FMT_H263``
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index f824162d0ea9..bf29dc5b9758 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -443,6 +443,36 @@ See also the examples in :ref:`control`.
       - n/a
       - A struct :c:type:`v4l2_ctrl_mpeg2_quantization`, containing MPEG-2
 	quantization matrices for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_H264_SPS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_h264_sps`, containing H264
+	sequence parameters for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_H264_PPS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_h264_pps`, containing H264
+	picture parameters for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_H264_SCALING_MATRIX``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_h264_scaling_matrix`, containing H264
+	scaling matrices for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_H264_SLICE_PARAMS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_h264_slice_param`, containing H264
+	slice parameters for stateless video decoders.
+    * - ``V4L2_CTRL_TYPE_H264_DECODE_PARAMS``
+      - n/a
+      - n/a
+      - n/a
+      - A struct :c:type:`v4l2_ctrl_h264_decode_param`, containing H264
+	decode parameters for stateless video decoders.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 64d348e67df9..55cbe324b9fc 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -136,6 +136,11 @@ replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_MPEG2_QUANTIZATION :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_H264_SPS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_H264_PPS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_H264_SCALING_MATRIX :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_H264_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_H264_DECODE_PARAMS :c:type:`v4l2_ctrl_type`
 
 # V4L2 capability defines
 replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..8afdf5e0d312 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -828,6 +828,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
 								return "H264 Constrained Intra Pred";
 	case V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET:	return "H264 Chroma QP Index Offset";
+	case V4L2_CID_MPEG_VIDEO_H264_SPS:			return "H264 Sequence Parameter Set";
+	case V4L2_CID_MPEG_VIDEO_H264_PPS:			return "H264 Picture Parameter Set";
+	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:		return "H264 Scaling Matrix";
+	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:		return "H264 Slice Parameters";
+	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:		return "H264 Decode Parameters";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
@@ -1303,6 +1308,21 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
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
+	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:
+		*type = V4L2_CTRL_TYPE_H264_SLICE_PARAMS;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
+		*type = V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1669,6 +1689,13 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		return 0;
 
+	case V4L2_CTRL_TYPE_H264_SPS:
+	case V4L2_CTRL_TYPE_H264_PPS:
+	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
+	case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
+	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2249,6 +2276,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
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
+	case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
+		elem_size = sizeof(struct v4l2_ctrl_h264_slice_param);
+		break;
+	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
+		elem_size = sizeof(struct v4l2_ctrl_h264_decode_param);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f6d663934648..43afa16b5757 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1325,6 +1325,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
 		case V4L2_PIX_FMT_H264_NO_SC:	descr = "H.264 (No Start Codes)"; break;
 		case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
+		case V4L2_PIX_FMT_H264_SLICE_RAW:	descr = "H.264 Parsed Slice Data"; break;
 		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
 		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
 		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
diff --git a/include/media/h264-ctrls.h b/include/media/h264-ctrls.h
new file mode 100644
index 000000000000..6de1b88f71c7
--- /dev/null
+++ b/include/media/h264-ctrls.h
@@ -0,0 +1,192 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * These are the H.264 state controls for use with stateless H.264
+ * codec drivers.
+ *
+ * It turns out that these structs are not stable yet and will undergo
+ * more changes. So keep them private until they are stable and ready to
+ * become part of the official public API.
+ */
+
+#ifndef _H264_CTRLS_H_
+#define _H264_CTRLS_H_
+
+/*
+ * This is put insanely high to avoid conflicting with controls that
+ * would be added during the phase where those controls are not
+ * stable. It should be fixed eventually.
+ */
+#define V4L2_CID_MPEG_VIDEO_H264_SPS		(V4L2_CID_MPEG_BASE+1000)
+#define V4L2_CID_MPEG_VIDEO_H264_PPS		(V4L2_CID_MPEG_BASE+1001)
+#define V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX	(V4L2_CID_MPEG_BASE+1002)
+#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+1003)
+#define V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS	(V4L2_CID_MPEG_BASE+1004)
+
+/* enum v4l2_ctrl_type type values */
+#define V4L2_CTRL_TYPE_H264_SPS 0x0105
+#define	V4L2_CTRL_TYPE_H264_PPS 0x0106
+#define	V4L2_CTRL_TYPE_H264_SCALING_MATRIX 0x0107
+#define	V4L2_CTRL_TYPE_H264_SLICE_PARAMS 0x0108
+#define	V4L2_CTRL_TYPE_H264_DECODE_PARAMS 0x0109
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
+
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
+	__u8 max_num_ref_frames;
+	__u8 num_ref_frames_in_pic_order_cnt_cycle;
+	__s32 offset_for_ref_frame[255];
+	__s32 offset_for_non_ref_pic;
+	__s32 offset_for_top_to_bottom_field;
+	__u16 pic_width_in_mbs_minus1;
+	__u16 pic_height_in_map_units_minus1;
+	__u32 flags;
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
+
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
+	__u16 flags;
+};
+
+struct v4l2_ctrl_h264_scaling_matrix {
+	__u8 scaling_list_4x4[6][16];
+	__u8 scaling_list_8x8[6][64];
+};
+
+struct v4l2_h264_weight_factors {
+	__s16 luma_weight[32];
+	__s16 luma_offset[32];
+	__s16 chroma_weight[32][2];
+	__s16 chroma_offset[32][2];
+};
+
+struct v4l2_h264_pred_weight_table {
+	__u16 luma_log2_weight_denom;
+	__u16 chroma_log2_weight_denom;
+	struct v4l2_h264_weight_factors weight_factors[2];
+};
+
+#define V4L2_H264_SLICE_TYPE_P				0
+#define V4L2_H264_SLICE_TYPE_B				1
+#define V4L2_H264_SLICE_TYPE_I				2
+#define V4L2_H264_SLICE_TYPE_SP				3
+#define V4L2_H264_SLICE_TYPE_SI				4
+
+#define V4L2_H264_SLICE_FLAG_FIELD_PIC			0x01
+#define V4L2_H264_SLICE_FLAG_BOTTOM_FIELD		0x02
+#define V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED	0x04
+#define V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH		0x08
+
+struct v4l2_ctrl_h264_slice_param {
+	/* Size in bytes, including header */
+	__u32 size;
+	/* Offset in bits to slice_data() from the beginning of this slice. */
+	__u32 header_bit_size;
+
+	__u16 first_mb_in_slice;
+	__u8 slice_type;
+	__u8 pic_parameter_set_id;
+	__u8 colour_plane_id;
+	__u8 redundant_pic_cnt;
+	__u16 frame_num;
+	__u16 idr_pic_id;
+	__u16 pic_order_cnt_lsb;
+	__s32 delta_pic_order_cnt_bottom;
+	__s32 delta_pic_order_cnt0;
+	__s32 delta_pic_order_cnt1;
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
+	__u8 num_ref_idx_l0_active_minus1;
+	__u8 num_ref_idx_l1_active_minus1;
+	__u32 slice_group_change_cycle;
+
+	/*
+	 * Entries on each list are indices into
+	 * v4l2_ctrl_h264_decode_param.dpb[].
+	 */
+	__u8 ref_pic_list0[32];
+	__u8 ref_pic_list1[32];
+
+	__u32 flags;
+};
+
+#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
+#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
+#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM	0x04
+
+struct v4l2_h264_dpb_entry {
+	__u64 timestamp;
+	__u16 frame_num;
+	__u16 pic_num;
+	/* Note that field is indicated by v4l2_buffer.field */
+	__s32 top_field_order_cnt;
+	__s32 bottom_field_order_cnt;
+	__u32 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
+};
+
+#define V4L2_H264_DECODE_PARAM_FLAG_IDR_PIC	0x01
+
+struct v4l2_ctrl_h264_decode_param {
+	__u32 num_slices;
+	__u32 nal_ref_idc;
+	__u8 ref_pic_list_p0[32];
+	__u8 ref_pic_list_b0[32];
+	__u8 ref_pic_list_b1[32];
+	__s32 top_field_order_cnt;
+	__s32 bottom_field_order_cnt;
+	__u32 flags; /* V4L2_H264_DECODE_PARAM_FLAG_* */
+	struct v4l2_h264_dpb_entry dpb[16];
+};
+
+#endif
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index e5cae37ced2d..88134951bd30 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -23,10 +23,11 @@
 #include <media/media-request.h>
 
 /*
- * Include the mpeg2 stateless codec compound control definitions.
+ * Include the stateless codec compound control definitions.
  * This will move to the public headers once this API is fully stable.
  */
 #include <media/mpeg2-ctrls.h>
+#include <media/h264-ctrls.h>
 
 /* forward references */
 struct file;
@@ -49,6 +50,11 @@ struct poll_table_struct;
  * @p_char:			Pointer to a string.
  * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
  * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
+ * @p_h264_sps:			Pointer to a struct v4l2_ctrl_h264_sps.
+ * @p_h264_pps:			Pointer to a struct v4l2_ctrl_h264_pps.
+ * @p_h264_scaling_matrix:	Pointer to a struct v4l2_ctrl_h264_scaling_matrix.
+ * @p_h264_slice_param:		Pointer to a struct v4l2_ctrl_h264_slice_param.
+ * @p_h264_decode_param:	Pointer to a struct v4l2_ctrl_h264_decode_param.
  * @p:				Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -60,6 +66,11 @@ union v4l2_ctrl_ptr {
 	char *p_char;
 	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
 	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
+	struct v4l2_ctrl_h264_sps *p_h264_sps;
+	struct v4l2_ctrl_h264_pps *p_h264_pps;
+	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
+	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
+	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
 	void *p;
 };
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1db220da3bcc..dd5da9802d2c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -657,6 +657,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
 #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
 #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
+#define V4L2_PIX_FMT_H264_SLICE_RAW v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
-- 
git-series 0.9.1
