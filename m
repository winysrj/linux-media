Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42197 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbdARKMm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 05:12:42 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 11/11] Documention: v4l: Documentation for HEVC CIDs
Date: Wed, 18 Jan 2017 15:32:09 +0530
Message-id: <1484733729-25371-12-git-send-email-smitha.t@samsung.com>
In-reply-to: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100827epcas5p16023525ba778b58b8e9a31b8a764b382@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added V4l2 controls for HEVC encoder

CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst |  190 ++++++++++++++++++++
 1 files changed, 190 insertions(+), 0 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index abb1057..fe23919 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1960,6 +1960,196 @@ enum v4l2_vp8_golden_frame_sel -
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
+    Enable the QP values for temporal layer.
+
+.. _v4l2-mpeg-video-hevc-hier-coding-type:
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
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER``
+    Indicates the hierarchical coding layer.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP``
+    Indicates the hierarchical coding layer quantization parameter.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_PROFILE``
+    Select the desired profile for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LEVEL``
+    Selects the desired level for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE``
+    Selects the RC filter frame rate for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG``
+    By default selects HEVC tier_flag as Main.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH``
+    Selects HEVC Maximum coding unit depth.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES``
+    Selects number of P reference picture required for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE``
+    Disables HEVC filter.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY``
+    Selects across or not slice boundary for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2``
+    Selects HEVC loop filter beta offset.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2``
+    Selects HEVC loop filter tc offset.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
+    Selects refresh type for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD``
+    Selects the refresh period for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE``
+    Selects HEVC lossless encoding.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE``
+    Enables constant intra prediction for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE``
+    Enables wavefront for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE``
+    Enables long term reference for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_USER_REF``
+    Selects user long term reference frame.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF``
+    Stores long term reference frame.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING``
+    Enable sign data hiding for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE``
+    Enable general picture buffers for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE``
+    Enable temporal ID for HEVC encoder.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG``
+    Enable HEVC Strong intra smoothing.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1``
+    Indicates max number of candidate motion vectors.
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
+    Enabling HEVC encoding without a startcode.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CR``
+    Indicates the quantization parameter CR index.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CB``
+    Indicates the quantization parameter CB index.
+
+``V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD``
+    Indicates size of length field for HEVC encoder.
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

