Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37089 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdHBDUL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 23:20:11 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v5 1/6] v4l: add portduff blend modes
Date: Wed,  2 Aug 2017 11:19:42 +0800
Message-Id: <1501643987-27847-2-git-send-email-jacob-chen@iotwrt.com>
In-Reply-To: <1501643987-27847-1-git-send-email-jacob-chen@iotwrt.com>
References: <1501643987-27847-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At peresent, we don't have a control for Compositing and Blend.
All drivers are just doing copies while actually many hardwares
supports more functions.

So Adding V4L2 controls for Compositing and Blend, used for for
composting streams.

The values are based on porter duff operations.
Defined in below links.
https://developer.xamarin.com/api/type/Android.Graphics.PorterDuff+Mode/

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 20 +++++++++++++++++++-
 include/uapi/linux/v4l2-controls.h   | 20 +++++++++++++++++++-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b9e08e3..561d7d5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -478,7 +478,21 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Region Grid",
 		NULL,
 	};
-
+	static const char * const porter_duff_modes[] = {
+		"Source",
+		"Source Top",
+		"Source In",
+		"Source Out",
+		"Source Over",
+		"Destination",
+		"Destination Top",
+		"Destination In",
+		"Destination Out",
+		"Destination Over",
+		"Add",
+		"Clear",
+		NULL
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -564,6 +578,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return vpx_golden_frame_sel;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		return jpeg_chroma_subsampling;
+	case V4L2_CID_PORTER_DUFF_MODE:
+		return porter_duff_modes;
 	case V4L2_CID_DV_TX_MODE:
 		return dv_tx_mode;
 	case V4L2_CID_DV_TX_RGB_RANGE:
@@ -886,6 +902,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
 	case V4L2_CID_DEINTERLACING_MODE:	return "Deinterlacing Mode";
+	case V4L2_CID_PORTER_DUFF_MODE:		return "PorterDuff Blend Modes";
 
 	/* DV controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1060,6 +1077,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_DEINTERLACING_MODE:
+	case V4L2_CID_PORTER_DUFF_MODE:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_DETECT_MD_MODE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0d2e1e0..986a02b6 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -893,7 +893,25 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 #define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
-
+#define V4L2_CID_PORTER_DUFF_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 5)
+/*
+ * For details: see
+ * https://developer.android.com/reference/android/graphics/PorterDuff.Mode.html
+ */
+enum v4l2_porter_duff_mode {
+	V4L2_PORTER_DUFF_SRC			= 0,
+	V4L2_PORTER_DUFF_SRCATOP		= 1,
+	V4L2_PORTER_DUFF_SRCIN			= 2,
+	V4L2_PORTER_DUFF_SRCOUT			= 3,
+	V4L2_PORTER_DUFF_SRCOVER		= 4,
+	V4L2_PORTER_DUFF_DST			= 5,
+	V4L2_PORTER_DUFF_DSTATOP		= 6,
+	V4L2_PORTER_DUFF_DSTIN			= 7,
+	V4L2_PORTER_DUFF_DSTOUT			= 8,
+	V4L2_PORTER_DUFF_DSTOVER		= 9,
+	V4L2_PORTER_DUFF_ADD			= 10,
+	V4L2_PORTER_DUFF_CLEAR			= 11,
+};
 
 /*  DV-class control IDs defined by V4L2 */
 #define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
-- 
2.7.4
