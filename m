Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48865 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbdCCJHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 04:07:25 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v2 11/11] Documention: v4l: Documentation for HEVC CIDs
Date: Fri, 03 Mar 2017 14:37:16 +0530
Message-id: <1488532036-13044-12-git-send-email-smitha.t@samsung.com>
In-reply-to: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090518epcas5p4d50e0bbaae69e93dc931c29ffaaa658b@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added V4l2 controls for HEVC encoder

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst |  314 ++++++++++++++++++++
 1 files changed, 314 insertions(+), 0 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index abb1057..5799876 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1960,6 +1960,320 @@ enum v4l2_vp8_golden_frame_sel -
     1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
 
 
+HEVC Control Reference
+---------------------
+
+The HEVC controls include controls for encoding parameters of HEVC video
+codec.
+
+
+.. _hevc-control-id:
+
+HEVC Control IDs
+^^^^^^^^^^^^^^^
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP``
+    Minimum quantization parameter for HEVC.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP``
+    Maximum quantization parameter for HEVC.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP``
+    Quantization parameter for an I frame for HEVC.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP``
+    Quantization parameter for a P frame for HEVC.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP``
+    Quantization parameter for a B frame for HEVC.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE``
+    HIERARCHICAL_QP_ENABLE allows host to specify the QP values for each
+    temporal layer through HIERARCHICAL_QP_LAYER. This is valid only if
+    HIERARCHICAL_CODING_LAYER is greater than 1.
+
+.. _v4l2-hevc-hierarchical-coding-type:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE``
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
+.. _v4l2-hevc-hierarchical-coding-layer:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_hierarchial_coding_layer -
+    Selects the hierarchical coding layer. In normal encoding
+    (non-hierarchial coding), it should be zero. Possible values are:
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
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER0``
+      - Use the Layer 0 for hierarchial coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER1``
+      - Use the Layer 1 for hierarchial coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER2``
+      - Use the Layer 2 for hierarchial coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER3``
+      - Use the Layer 3 for hierarchial coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER4``
+      - Use the Layer 4 for hierarchial coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER5``
+      - Use the Layer 5 for hierarchial coding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER6``
+      - Use the Layer 6 for hierarchial coding.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP``
+    Indicates the hierarchical coding layer quantization parameter.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_PROFILE``
+    Select the desired profile for HEVC encoder.
+    Zero indicates the main profile. One indicates the main still
+    picture profile.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LEVEL``
+    Selects the desired level for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE``
+    Selects the RC filter frame rate for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG``
+    TIER_FLAG specifies tier information of the HEVC encoded picture.
+    By default selects HEVC tier_flag as Main and setting this flag to one
+    indicates High tier.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH``
+    Selects HEVC Maximum coding unit depth.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES``
+    Selects number of P reference picture required for HEVC encoder.
+    P-Frame can use 1 or 2 frames for reference.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE``
+    Disables HEVC loop filter.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY``
+    Selects whether to apply the loop filter across the slice boundary or not.
+    If the value is 0, loop filter will not be applied across the slice boundary.
+    If the value is 1, loop filter will be applied across the slice boundary.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2``
+    Selects HEVC loop filter beta offset. The valid range is [-6, +6].
+    This could be a negative value in the 2's complement expression.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2``
+    Selects HEVC loop filter tc offset. The valid range is [-6, +6].
+    This could be a negative value in the 2's complement expression.
+
+.. _v4l2-hevc-refresh-type:
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
+    (enum)
+
+enum v4l2_mpeg_video_hevc_hier_refresh_type -
+    Selects refresh type for HEVC encoder.
+    Host has to specify the period into
+    HEVC_REFRESH_PERIOD.
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
+      - Use CRA(Clean Random Access Unit) picture encoding.
+    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR``
+      - Use IDR picture encoding.
+
+.. raw:: latex
+
+    \end{adjustbox}
+
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD``
+    Selects the refresh period for HEVC encoder.
+    This specifies the number of I picture between two CRA/IDR pictures.
+    This is valid only if REFRESH_TYPE is not 0.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE``
+    Selects HEVC lossless encoding.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE``
+    Enables constant intra prediction for HEVC encoder.
+    Specifies the constrained intra prediction in which intra LCU prediction is performed.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE``
+    Enables wavefront for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE``
+    Specifies which encoded frame use short term or long term as reference.
+    Zero indicates use only short term reference. One indicates use short term
+    reference and long term reference.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_USE_REF``
+    Specifies which current frame is encoded by referencing as long term
+    reference frame. Zero indicates short term reference frame is used.
+    One indicates long term reference idx 0 is used. Two indicates long term
+    reference idx 1 is used. Three indicates use the nearest longest term
+    reference from current frame. It is valid only when LTR_ENABLE is enabled.
+    Both long term references bits can be selected simulatenously and MFC will
+    select the best long term refernece among them based on the POC which is
+    nearest the current frame.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF``
+    Specifies whether the current frame needs to be stored as long term
+    reference frame. Zero indicates store in short term reference frame.
+    One indicates store in long_term_reference_frame_idx 0. Two indicates
+    store in long_term_frame_idx 1. It is valid only when LTR_ENABLE is enabled.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING``
+    Enable sign data hiding for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE``
+    Enable general picture buffers for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE``
+    Enable temporal identifier for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG``
+    Enable HEVC Strong intra smoothing.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1``
+    Indicates max number of merge candidate motion vectors.
+    Values is from zero to four.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK``
+    Indicates HEVC dark region adaptive.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH``
+    Indicates HEVC smooth region adaptive.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC``
+    Indicates HEVC static region adaptive.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY``
+    Indicates HEVC activity adaptive.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_INTRA_PU_SPLIT``
+    Disables intra pu split for HEVC Encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_TMV_PREDICTION``
+    Disables tmv prediction for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE_ENABLE``
+    Specifies if MFC generates a stream with a size of length field instead of
+    start code pattern. The size of the length field is configurable among 1,2
+    or 4 thorugh the SIZE_OF_LENGHT_FIELD. It is not applied at SEQ_START.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CR``
+    Indicates the quantization parameter CR index.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CB``
+    Indicates the quantization parameter CB index.
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
+       :header-rows:  0
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
+``V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR``
+    Indicates prepend SPS/PPS to every IDR.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH``
+    Indicates hierarchical coding layer change for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT0``
+    Indicates hierarchical coding layer BIT0 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT1``
+    Indicates hierarchical coding layer BIT1 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT2``
+    Indicates hierarchical coding layer BIT2 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT3``
+    Indicates hierarchical coding layer BIT3 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT4``
+    Indicates hierarchical coding layer BIT4 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT5``
+    Indicates hierarchical coding layer BIT5 for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT6``
+    Indicates hierarchical coding layer BIT6 for HEVC encoder.
+
+
 .. _camera-controls:
 
 Camera Control Reference
-- 
1.7.2.3
