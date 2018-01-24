Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:10922 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933203AbeAXLYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 06:24:10 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v7 12/12] Documention: v4l: Documentation for HEVC CIDs
Date: Wed, 24 Jan 2018 16:29:44 +0530
Message-id: <1516791584-7980-13-git-send-email-smitha.t@samsung.com>
In-reply-to: <1516791584-7980-1-git-send-email-smitha.t@samsung.com>
References: <1516791584-7980-1-git-send-email-smitha.t@samsung.com>
        <CGME20180124112406epcas2p3820cea581731825c7ad72ebbb1ca060c@epcas2p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added V4l2 controls for HEVC encoder

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 400 +++++++++++++++++++++
 1 file changed, 400 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index dfe49ae..46ee2bf 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1960,6 +1960,406 @@ enum v4l2_vp8_golden_frame_sel -
     1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
 
 
+High Efficiency Video Coding (HEVC/H.265) Control Reference
+-----------------------------------------------------------
+
+The HEVC/H.265 controls include controls for encoding parameters of HEVC/H.265
+video codec.
+
+
+.. _hevc-control-id:
+
+HEVC/H.265 Control IDs
+^^^^^^^^^^^^^^^^^^^^^^
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP (integer)``
+    Minimum quantization parameter for HEVC.
+    Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP (integer)``
+    Maximum quantization parameter for HEVC.
+    Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP (integer)``
+    Quantization parameter for an I frame for HEVC.
+    Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP (integer)``
+    Quantization parameter for a P frame for HEVC.
+    Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP (integer)``
+    Quantization parameter for a B frame for HEVC.
+    Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP (boolean)``
+    HIERARCHICAL_QP allows the host to specify the quantization parameter
+    values for each temporal layer through HIERARCHICAL_QP_LAYER. This is
+    valid only if HIERARCHICAL_CODING_LAYER is greater than 1. Setting the
+    control value to 1 enables setting of the QP values for the layers.
+
+.. _v4l2-hevc-hier-coding-type:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_hier_coding_type -
+    Selects the hierarchical coding type for encoding. Possible values are:
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B``
+      - Use the B frame for hierarchical coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P``
+      - Use the P frame for hierarchical coding.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER (integer)``
+    Selects the hierarchical coding layer. In normal encoding
+    (non-hierarchial coding), it should be zero. Possible values are [0, 6].
+    0 indicates HIERARCHICAL CODING LAYER 0, 1 indicates HIERARCHICAL CODING
+    LAYER 1 and so on.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 0.
+    For HEVC it can have a value of 0-51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 1.
+    For HEVC it can have a value of 0-51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 2.
+    For HEVC it can have a value of 0-51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 3.
+    For HEVC it can have a value of 0-51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 4.
+    For HEVC it can have a value of 0-51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 5.
+    For HEVC it can have a value of 0-51.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP (integer)``
+    Indicates quantization parameter for hierarchical coding layer 6.
+    For HEVC it can have a value of 0-51.
+
+.. _v4l2-hevc-profile:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_PROFILE``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_profile -
+    Select the desired profile for HEVC encoder.
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN``
+      - Main profile.
+    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE``
+      - Main still picture profile.
+    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN10``
+      - Main 10 profile.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+.. _v4l2-hevc-level:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LEVEL``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_level -
+    Selects the desired level for HEVC encoder.
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_1``
+      - Level 1.0
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_2``
+      - Level 2.0
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1``
+      - Level 2.1
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_3``
+      - Level 3.0
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1``
+      - Level 3.1
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_4``
+      - Level 4.0
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1``
+      - Level 4.1
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5``
+      - Level 5.0
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1``
+      - Level 5.1
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2``
+      - Level 5.2
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6``
+      - Level 6.0
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1``
+      - Level 6.1
+    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2``
+      - Level 6.2
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION (integer)``
+    Indicates the number of evenly spaced subintervals, called ticks, within
+    one second. This is a 16 bit unsigned integer and has a maximum value up to
+    0xffff and a minimum value of 1.
+
+.. _v4l2-hevc-tier:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TIER``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_tier -
+    TIER_FLAG specifies tiers information of the HEVC encoded picture. Tier
+    were made to deal with applications that differ in terms of maximum bit
+    rate. Setting the flag to 0 selects HEVC tier as Main tier and setting
+    this flag to 1 indicates High tier. High tier is for applications requiring
+    high bit rates.
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_TIER_MAIN``
+      - Main tier.
+    * - ``V4L2_MPEG_VIDEO_HEVC_TIER_HIGH``
+      - High tier.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH (integer)``
+    Selects HEVC maximum coding unit depth.
+
+.. _v4l2-hevc-loop-filter-mode:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_loop_filter_mode -
+    Loop filter mode for HEVC encoder. Possible values are:
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED``
+      - Loop filter is disabled.
+    * - ``V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_ENABLED``
+      - Loop filter is enabled.
+    * - ``V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY``
+      - Loop filter is disabled at the slice boundary.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2 (integer)``
+    Selects HEVC loop filter beta offset. The valid range is [-6, +6].
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2 (integer)``
+    Selects HEVC loop filter tc offset. The valid range is [-6, +6].
+
+.. _v4l2-hevc-refresh-type:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_hier_refresh_type -
+    Selects refresh type for HEVC encoder.
+    Host has to specify the period into
+    V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD.
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE``
+      - Use the B frame for hierarchical coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA``
+      - Use CRA (Clean Random Access Unit) picture encoding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR``
+      - Use IDR (Instantaneous Decoding Refresh) picture encoding.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD (integer)``
+    Selects the refresh period for HEVC encoder.
+    This specifies the number of I pictures between two CRA/IDR pictures.
+    This is valid only if REFRESH_TYPE is not 0.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU (boolean)``
+    Indicates HEVC lossless encoding. Setting it to 0 disables lossless
+    encoding. Setting it to 1 enables lossless encoding.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED (boolean)``
+    Indicates constant intra prediction for HEVC encoder. Specifies the
+    constrained intra prediction in which intra largest coding unit (LCU)
+    prediction is performed by using residual data and decoded samples of
+    neighboring intra LCU only. Setting the value to 1 enables constant intra
+    prediction and setting the value to 0 disables constant intra prediction.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT (boolean)``
+    Indicates wavefront parallel processing for HEVC encoder. Setting it to 0
+    disables the feature and setting it to 1 enables the wavefront parallel
+    processing.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB (boolean)``
+    Setting the value to 1 enables combination of P and B frame for HEVC
+    encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID (boolean)``
+    Indicates temporal identifier for HEVC encoder which is enabled by
+    setting the value to 1.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING (boolean)``
+    Indicates bi-linear interpolation is conditionally used in the intra
+    prediction filtering process in the CVS when set to 1. Indicates bi-linear
+    interpolation is not used in the CVS when set to 0.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1 (integer)``
+    Indicates maximum number of merge candidate motion vectors.
+    Values are from 0 to 4.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION (boolean)``
+    Indicates temporal motion vector prediction for HEVC encoder. Setting it to
+    1 enables the prediction. Setting it to 0 disables the prediction.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE (boolean)``
+    Specifies if HEVC generates a stream with a size of the length field
+    instead of start code pattern. The size of the length field is configurable
+    through the V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD control. Setting
+    the value to 0 disables encoding without startcode pattern. Setting the
+    value to 1 will enables encoding without startcode pattern.
+
+.. _v4l2-hevc-size-of-length-field:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD``
+(enum)
+
+enum v4l2_mpeg_video_hevc_size_of_length_field -
+    Indicates the size of length field.
+    This is valid when encoding WITHOUT_STARTCODE_ENABLE is enabled.
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_0``
+      - Generate start code pattern (Normal).
+    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_1``
+      - Generate size of length field instead of start code pattern and length is 1.
+    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_2``
+      - Generate size of length field instead of start code pattern and length is 2.
+    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_4``
+      - Generate size of length field instead of start code pattern and length is 4.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 0 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 1 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 2 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 3 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 4 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 5 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR (integer)``
+    Indicates bit rate for hierarchical coding layer 6 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES (integer)``
+    Selects number of P reference pictures required for HEVC encoder.
+    P-Frame can use 1 or 2 frames for reference.
+
+``V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR (integer)``
+    Indicates whether to generate SPS and PPS at every IDR. Setting it to 0
+    disables generating SPS and PPS at every IDR. Setting it to one enables
+    generating SPS and PPS at every IDR.
+
+
 .. _camera-controls:
 
 Camera Control Reference
-- 
2.7.4
