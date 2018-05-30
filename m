Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36238 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937148AbeE3HQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 03:16:44 -0400
Received: by mail-pg0-f67.google.com with SMTP id m5-v6so3353848pgd.3
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 00:16:44 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 1/2] media: v4l2-ctrl: Add control for VP9 profile
Date: Wed, 30 May 2018 16:16:12 +0900
Message-Id: <20180530071613.125768-2-keiichiw@chromium.org>
In-Reply-To: <20180530071613.125768-1-keiichiw@chromium.org>
References: <20180530071613.125768-1-keiichiw@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE for selecting desired
profile for VP9 encoder and querying for supported profiles by VP9 encoder
or decoder.

An existing control V4L2_CID_MPEG_VIDEO_VPX_PROFILE cannot be
used for querying since it is not a menu control but an integer
control, which cannot return an arbitrary set of supported profiles.

The new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE is a menu control as
with controls for other codec profiles. (e.g. H264)

Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
---
 .../media/uapi/v4l/extended-controls.rst      | 26 +++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c          | 12 +++++++++
 include/uapi/linux/v4l2-controls.h            |  8 ++++++
 3 files changed, 46 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 03931f9b1285..4f7f128a4998 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1959,6 +1959,32 @@ enum v4l2_vp8_golden_frame_sel -
     Select the desired profile for VPx encoder. Acceptable values are 0,
     1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.

+.. _v4l2-mpeg-video-vp9-profile:
+
+``V4L2_CID_MPEG_VIDEO_VP9_PROFILE``
+    (enum)
+
+enum v4l2_mpeg_video_vp9_profile -
+    This control allows to select the profile for VP9 encoder.
+    This is also used to enumerate supported profiles by VP9 encoder or decoder.
+    Possible values are:
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_0``
+      - Profile 0
+    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_1``
+      - Profile 1
+    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_2``
+      - Profile 2
+    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_3``
+      - Profile 3
+
+

 High Efficiency Video Coding (HEVC/H.265) Control Reference
 -----------------------------------------------------------
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d29e45516eb7..401ce21c2e63 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -431,6 +431,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Use Previous Specific Frame",
 		NULL,
 	};
+	static const char * const vp9_profile[] = {
+		"0",
+		"1",
+		"2",
+		"3",
+		NULL,
+	};

 	static const char * const flash_led_mode[] = {
 		"Off",
@@ -614,6 +621,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg4_profile;
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 		return vpx_golden_frame_sel;
+	case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:
+		return vp9_profile;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		return jpeg_chroma_subsampling;
 	case V4L2_CID_DV_TX_MODE:
@@ -841,6 +850,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";

+	case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:			return "VP9 Profile";
+
 	/* HEVC controls */
 	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:		return "HEVC P-Frame QP Value";
@@ -1180,6 +1191,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DEINTERLACING_MODE:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
+	case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:
 	case V4L2_CID_DETECT_MD_MODE:
 	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
 	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 8d473c979b61..56203b7b715c 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -589,6 +589,14 @@ enum v4l2_vp8_golden_frame_sel {
 #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
 #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)

+#define V4L2_CID_MPEG_VIDEO_VP9_PROFILE			(V4L2_CID_MPEG_BASE+512)
+enum v4l2_mpeg_video_vp9_profile {
+	V4L2_MPEG_VIDEO_VP9_PROFILE_0				= 0,
+	V4L2_MPEG_VIDEO_VP9_PROFILE_1				= 1,
+	V4L2_MPEG_VIDEO_VP9_PROFILE_2				= 2,
+	V4L2_MPEG_VIDEO_VP9_PROFILE_3				= 3,
+};
+
 /* CIDs for HEVC encoding. */

 #define V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP		(V4L2_CID_MPEG_BASE + 600)
--
2.17.0.921.gf22659ad46-goog
