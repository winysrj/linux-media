Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44407 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbeBBMuS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 07:50:18 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v8 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
Date: Fri, 02 Feb 2018 17:55:46 +0530
Message-id: <1517574348-22111-11-git-send-email-smitha.t@samsung.com>
In-reply-to: <1517574348-22111-1-git-send-email-smitha.t@samsung.com>
References: <1517574348-22111-1-git-send-email-smitha.t@samsung.com>
        <CGME20180202125016epcas1p2520700ff715e471eb949509d80f00211@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2 controls for HEVC encoder

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 119 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/v4l2-controls.h   |  93 ++++++++++++++++++++++++++-
 2 files changed, 211 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index cbb2ef4..e312f11 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -480,6 +480,57 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		NULL,
 	};
 
+	static const char * const hevc_profile[] = {
+		"Main",
+		"Main Still Picture",
+		"Main 10",
+		NULL,
+	};
+	static const char * const hevc_level[] = {
+		"1",
+		"2",
+		"2.1",
+		"3",
+		"3.1",
+		"4",
+		"4.1",
+		"5",
+		"5.1",
+		"5.2",
+		"6",
+		"6.1",
+		"6.2",
+		NULL,
+	};
+	static const char * const hevc_hierarchial_coding_type[] = {
+		"B",
+		"P",
+		NULL,
+	};
+	static const char * const hevc_refresh_type[] = {
+		"None",
+		"CRA",
+		"IDR",
+		NULL,
+	};
+	static const char * const hevc_size_of_length_field[] = {
+		"0",
+		"1",
+		"2",
+		"4",
+		NULL,
+	};
+	static const char * const hevc_tier[] = {
+		"Main",
+		"High",
+		NULL,
+	};
+	static const char * const hevc_loop_filter_mode[] = {
+		"Disabled",
+		"Enabled",
+		"Disabled at slice boundary",
+		"NULL",
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -575,6 +626,20 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return dv_it_content_type;
 	case V4L2_CID_DETECT_MD_MODE:
 		return detect_md_mode;
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
+		return hevc_profile;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
+		return hevc_level;
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
+		return hevc_hierarchial_coding_type;
+	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
+		return hevc_refresh_type;
+	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
+		return hevc_size_of_length_field;
+	case V4L2_CID_MPEG_VIDEO_HEVC_TIER:
+		return hevc_tier;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:
+		return hevc_loop_filter_mode;
 
 	default:
 		return NULL;
@@ -776,6 +841,53 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
 
+	/* HEVC controls */
+	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:		return "HEVC P-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:		return "HEVC B-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:			return "HEVC Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:			return "HEVC Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:			return "HEVC Profile";
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:			return "HEVC Level";
+	case V4L2_CID_MPEG_VIDEO_HEVC_TIER:			return "HEVC Tier";
+	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:	return "HEVC Frame Rate Resolution";
+	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:	return "HEVC Maximum Coding Unit Depth";
+	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:		return "HEVC Refresh Type";
+	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED:		return "HEVC Constant Intra Prediction";
+	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU:		return "HEVC Lossless Encoding";
+	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT:		return "HEVC Wavefront";
+	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:		return "HEVC Loop Filter";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP:			return "HEVC QP Values";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:		return "HEVC Hierarchical Coding Type";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER:	return "HEVC Hierarchical Coding Layer";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP:	return "HEVC Hierarchical Layer 0 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP:	return "HEVC Hierarchical Layer 1 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP:	return "HEVC Hierarchical Layer 2 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP:	return "HEVC Hierarchical Layer 3 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP:	return "HEVC Hierarchical Layer 4 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP:	return "HEVC Hierarchical Layer 5 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP:	return "HEVC Hierarchical Layer 6 QP";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR:	return "HEVC Hierarchical Lay 0 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR:	return "HEVC Hierarchical Lay 1 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR:	return "HEVC Hierarchical Lay 2 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR:	return "HEVC Hierarchical Lay 3 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR:	return "HEVC Hierarchical Lay 4 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR:	return "HEVC Hierarchical Lay 5 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR:	return "HEVC Hierarchical Lay 6 BitRate";
+	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:		return "HEVC General PB";
+	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:		return "HEVC Temporal ID";
+	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:		return "HEVC Strong Intra Smoothing";
+	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:		return "HEVC Intra PU Split";
+	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:		return "HEVC TMV Prediction";
+	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "HEVC Max Num of Candidate MVs";
+	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:	return "HEVC ENC Without Startcode";
+	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Num of I-Frame b/w 2 IDR";
+	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop Filter Beta Offset";
+	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop Filter TC Offset";
+	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of Length Field";
+	case V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES:	return "Reference Frames for a P-Frame";
+	case V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR:		return "Prepend SPS and PPS to IDR";
+
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
@@ -1069,6 +1181,13 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_DETECT_MD_MODE:
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
+	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
+	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
+	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
+	case V4L2_CID_MPEG_VIDEO_HEVC_TIER:
+	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index a692623..7b01621 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -589,6 +589,98 @@ enum v4l2_vp8_golden_frame_sel {
 #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
 #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
 
+/* CIDs for HEVC encoding. */
+
+#define V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP		(V4L2_CID_MPEG_BASE + 600)
+#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP		(V4L2_CID_MPEG_BASE + 601)
+#define V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP	(V4L2_CID_MPEG_BASE + 602)
+#define V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP	(V4L2_CID_MPEG_BASE + 603)
+#define V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP	(V4L2_CID_MPEG_BASE + 604)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP	(V4L2_CID_MPEG_BASE + 605)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE (V4L2_CID_MPEG_BASE + 606)
+enum v4l2_mpeg_video_hevc_hier_coding_type {
+	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B	= 0,
+	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P	= 1,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER	(V4L2_CID_MPEG_BASE + 607)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP	(V4L2_CID_MPEG_BASE + 608)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP	(V4L2_CID_MPEG_BASE + 609)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP	(V4L2_CID_MPEG_BASE + 610)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP	(V4L2_CID_MPEG_BASE + 611)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP	(V4L2_CID_MPEG_BASE + 612)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP	(V4L2_CID_MPEG_BASE + 613)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP	(V4L2_CID_MPEG_BASE + 614)
+#define V4L2_CID_MPEG_VIDEO_HEVC_PROFILE	(V4L2_CID_MPEG_BASE + 615)
+enum v4l2_mpeg_video_hevc_profile {
+	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN = 0,
+	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE = 1,
+	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10 = 2,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_LEVEL		(V4L2_CID_MPEG_BASE + 616)
+enum v4l2_mpeg_video_hevc_level {
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_1	= 0,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_2	= 1,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1	= 2,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_3	= 3,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1	= 4,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_4	= 5,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1	= 6,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_5	= 7,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1	= 8,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2	= 9,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_6	= 10,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1	= 11,
+	V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2	= 12,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION	(V4L2_CID_MPEG_BASE + 617)
+#define V4L2_CID_MPEG_VIDEO_HEVC_TIER			(V4L2_CID_MPEG_BASE + 618)
+enum v4l2_mpeg_video_hevc_tier {
+	V4L2_MPEG_VIDEO_HEVC_TIER_MAIN = 0,
+	V4L2_MPEG_VIDEO_HEVC_TIER_HIGH = 1,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH	(V4L2_CID_MPEG_BASE + 619)
+#define V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE	(V4L2_CID_MPEG_BASE + 620)
+enum v4l2_cid_mpeg_video_hevc_loop_filter_mode {
+	V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED			 = 0,
+	V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_ENABLED			 = 1,
+	V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY = 2,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2	(V4L2_CID_MPEG_BASE + 621)
+#define V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2	(V4L2_CID_MPEG_BASE + 622)
+#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE		(V4L2_CID_MPEG_BASE + 623)
+enum v4l2_cid_mpeg_video_hevc_refresh_type {
+	V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE		= 0,
+	V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA		= 1,
+	V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR		= 2,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD		(V4L2_CID_MPEG_BASE + 624)
+#define V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU		(V4L2_CID_MPEG_BASE + 625)
+#define V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED	(V4L2_CID_MPEG_BASE + 626)
+#define V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT		(V4L2_CID_MPEG_BASE + 627)
+#define V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB		(V4L2_CID_MPEG_BASE + 628)
+#define V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID		(V4L2_CID_MPEG_BASE + 629)
+#define V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING	(V4L2_CID_MPEG_BASE + 630)
+#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1	(V4L2_CID_MPEG_BASE + 631)
+#define V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT		(V4L2_CID_MPEG_BASE + 632)
+#define V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION		(V4L2_CID_MPEG_BASE + 633)
+#define V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE	(V4L2_CID_MPEG_BASE + 634)
+#define V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD	(V4L2_CID_MPEG_BASE + 635)
+enum v4l2_cid_mpeg_video_hevc_size_of_length_field {
+	V4L2_MPEG_VIDEO_HEVC_SIZE_0		= 0,
+	V4L2_MPEG_VIDEO_HEVC_SIZE_1		= 1,
+	V4L2_MPEG_VIDEO_HEVC_SIZE_2		= 2,
+	V4L2_MPEG_VIDEO_HEVC_SIZE_4		= 3,
+};
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR	(V4L2_CID_MPEG_BASE + 636)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR	(V4L2_CID_MPEG_BASE + 637)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR	(V4L2_CID_MPEG_BASE + 638)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR	(V4L2_CID_MPEG_BASE + 639)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR	(V4L2_CID_MPEG_BASE + 640)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR	(V4L2_CID_MPEG_BASE + 641)
+#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR	(V4L2_CID_MPEG_BASE + 642)
+#define V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES	(V4L2_CID_MPEG_BASE + 643)
+#define V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR	(V4L2_CID_MPEG_BASE + 644)
+
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
 #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
@@ -657,7 +749,6 @@ enum v4l2_mpeg_mfc51_video_force_frame_type {
 #define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+53)
 #define V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P		(V4L2_CID_MPEG_MFC51_BASE+54)
 
-
 /*  Camera class control IDs */
 
 #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
-- 
2.7.4
