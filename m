Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45339 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933357AbeFRIAw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 04:00:52 -0400
Received: by mail-pf0-f196.google.com with SMTP id a22-v6so7749311pfo.12
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 01:00:51 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 2/3] media: v4l2-ctrl: Add control for VP9 profile
Date: Mon, 18 Jun 2018 16:58:53 +0900
Message-Id: <20180618075854.12881-3-keiichiw@chromium.org>
In-Reply-To: <20180618075854.12881-1-keiichiw@chromium.org>
References: <20180618075854.12881-1-keiichiw@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE for VP9 profiles. This control
allows selecting the desired profile for VP9 encoder and querying for supported
profiles by VP9 encoder/decoder.

Though this control is similar to V4L2_CID_MPEG_VIDEO_VP8_PROFILE, we need to
separate this control from it because supported profiles usually differ between
VP8 and VP9.

Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
---
 .../media/uapi/v4l/extended-controls.rst      | 23 +++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c          | 11 +++++++++
 include/uapi/linux/v4l2-controls.h            |  7 ++++++
 3 files changed, 41 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 01ef31a934b4..9f7312bf3365 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1978,6 +1978,29 @@ enum v4l2_mpeg_video_vp8_profile -
     * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_3``
       - Profile 3

+.. _v4l2-mpeg-video-vp9-profile:
+
+``V4L2_CID_MPEG_VIDEO_VP9_PROFILE``
+    (enum)
+
+enum v4l2_mpeg_video_vp9_profile -
+    This control allows selecting the profile for VP9 encoder.
+    This is also used to enumerate supported profiles by VP9 encoder or decoder.
+    Possible values are:
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

 High Efficiency Video Coding (HEVC/H.265) Control Reference
 -----------------------------------------------------------
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e7e6340b395e..eacfab7574dc 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -438,6 +438,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"3",
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
@@ -623,6 +630,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return vpx_golden_frame_sel;
 	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
 		return vp8_profile;
+	case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:
+		return vp9_profile;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		return jpeg_chroma_subsampling;
 	case V4L2_CID_DV_TX_MODE:
@@ -849,6 +858,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		return "VPX I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:			return "VP8 Profile";
+	case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:			return "VP9 Profile";

 	/* HEVC controls */
 	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I-Frame QP Value";
@@ -1190,6 +1200,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:
 	case V4L2_CID_DETECT_MD_MODE:
 	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
 	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2001823c3072..f03d3214eec2 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -597,6 +597,13 @@ enum v4l2_mpeg_video_vp8_profile {
 };
 /* Deprecated alias for compatibility reasons. */
 #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE	V4L2_CID_MPEG_VIDEO_VP8_PROFILE
+#define V4L2_CID_MPEG_VIDEO_VP9_PROFILE			(V4L2_CID_MPEG_BASE+512)
+enum v4l2_mpeg_video_vp9_profile {
+	V4L2_MPEG_VIDEO_VP9_PROFILE_0				= 0,
+	V4L2_MPEG_VIDEO_VP9_PROFILE_1				= 1,
+	V4L2_MPEG_VIDEO_VP9_PROFILE_2				= 2,
+	V4L2_MPEG_VIDEO_VP9_PROFILE_3				= 3,
+};

 /* CIDs for HEVC encoding. */

--
2.18.0.rc1.244.gcf134e6275-goog
