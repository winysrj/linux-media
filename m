Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbbIMU50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:26 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 23/32] v4l: vsp1: Move format info to vsp1_pipe.c
Date: Sun, 13 Sep 2015 23:57:01 +0300
Message-Id: <1442177830-24536-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Format information and the related helper function are not specific to
the V4L2 API, move them from vsp1_video.c to vsp1_pipe.c.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c  | 110 +++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.h  |  29 ++++++++
 drivers/media/platform/vsp1/vsp1_video.c | 107 ------------------------------
 drivers/media/platform/vsp1/vsp1_video.h |  27 --------
 4 files changed, 139 insertions(+), 134 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 524420ed6333..df11259dcc0a 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -25,6 +25,116 @@
 #include "vsp1_uds.h"
 
 /* -----------------------------------------------------------------------------
+ * Helper Functions
+ */
+
+static const struct vsp1_format_info vsp1_video_formats[] = {
+	{ V4L2_PIX_FMT_RGB332, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_RGB_332, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 8, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_ARGB444, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, true },
+	{ V4L2_PIX_FMT_XRGB444, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_XRGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, true },
+	{ V4L2_PIX_FMT_ARGB555, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, true },
+	{ V4L2_PIX_FMT_XRGB555, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_XRGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_RGB_565, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_BGR24, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_BGR_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 24, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_RGB24, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 24, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_ABGR32, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, true },
+	{ V4L2_PIX_FMT_XBGR32, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_ARGB32, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, true },
+	{ V4L2_PIX_FMT_XRGB32, MEDIA_BUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_UYVY, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, false, false, 2, 1, false },
+	{ V4L2_PIX_FMT_VYUY, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, false, true, 2, 1, false },
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, true, false, 2, 1, false },
+	{ V4L2_PIX_FMT_YVYU, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 16, 0, 0 }, true, true, 2, 1, false },
+	{ V4L2_PIX_FMT_NV12M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, false, 2, 2, false },
+	{ V4L2_PIX_FMT_NV21M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, true, 2, 2, false },
+	{ V4L2_PIX_FMT_NV16M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, false, 2, 1, false },
+	{ V4L2_PIX_FMT_NV61M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  2, { 8, 16, 0 }, false, true, 2, 1, false },
+	{ V4L2_PIX_FMT_YUV420M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, false, 2, 2, false },
+};
+
+/*
+ * vsp1_get_format_info - Retrieve format information for a 4CC
+ * @fourcc: the format 4CC
+ *
+ * Return a pointer to the format information structure corresponding to the
+ * given V4L2 format 4CC, or NULL if no corresponding format can be found.
+ */
+const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vsp1_video_formats); ++i) {
+		const struct vsp1_format_info *info = &vsp1_video_formats[i];
+
+		if (info->fourcc == fourcc)
+			return info;
+	}
+
+	return NULL;
+}
+
+/* -----------------------------------------------------------------------------
  * Pipeline Management
  */
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 9c8ded1c29f6..f9035c739e9a 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -21,6 +21,33 @@
 
 struct vsp1_rwpf;
 
+/*
+ * struct vsp1_format_info - VSP1 video format description
+ * @mbus: media bus format code
+ * @fourcc: V4L2 pixel format FCC identifier
+ * @planes: number of planes
+ * @bpp: bits per pixel
+ * @hwfmt: VSP1 hardware format
+ * @swap_yc: the Y and C components are swapped (Y comes before C)
+ * @swap_uv: the U and V components are swapped (V comes before U)
+ * @hsub: horizontal subsampling factor
+ * @vsub: vertical subsampling factor
+ * @alpha: has an alpha channel
+ */
+struct vsp1_format_info {
+	u32 fourcc;
+	unsigned int mbus;
+	unsigned int hwfmt;
+	unsigned int swap;
+	unsigned int planes;
+	unsigned int bpp[3];
+	bool swap_yc;
+	bool swap_uv;
+	unsigned int hsub;
+	unsigned int vsub;
+	bool alpha;
+};
+
 enum vsp1_pipeline_state {
 	VSP1_PIPELINE_STOPPED,
 	VSP1_PIPELINE_RUNNING,
@@ -97,4 +124,6 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
 void vsp1_pipelines_resume(struct vsp1_device *vsp1);
 
+const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc);
+
 #endif /* __VSP1_PIPE_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 589ce49e8688..e0d4f84bc26d 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -48,113 +48,6 @@
  * Helper functions
  */
 
-static const struct vsp1_format_info vsp1_video_formats[] = {
-	{ V4L2_PIX_FMT_RGB332, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_RGB_332, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 8, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_ARGB444, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_ARGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XRGB444, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_XRGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_ARGB555, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_ARGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XRGB555, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_XRGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_RGB_565, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_BGR24, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_BGR_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 24, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_RGB24, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 24, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_ABGR32, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
-	  1, { 32, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XBGR32, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
-	  1, { 32, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_ARGB32, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 32, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XRGB32, MEDIA_BUS_FMT_ARGB8888_1X32,
-	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 32, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_UYVY, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, false, false, 2, 1, false },
-	{ V4L2_PIX_FMT_VYUY, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, false, true, 2, 1, false },
-	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, true, false, 2, 1, false },
-	{ V4L2_PIX_FMT_YVYU, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, true, true, 2, 1, false },
-	{ V4L2_PIX_FMT_NV12M, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, false, 2, 2, false },
-	{ V4L2_PIX_FMT_NV21M, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, true, 2, 2, false },
-	{ V4L2_PIX_FMT_NV16M, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, false, 2, 1, false },
-	{ V4L2_PIX_FMT_NV61M, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, true, 2, 1, false },
-	{ V4L2_PIX_FMT_YUV420M, MEDIA_BUS_FMT_AYUV8_1X32,
-	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
-	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  3, { 8, 8, 8 }, false, false, 2, 2, false },
-};
-
-/*
- * vsp1_get_format_info - Retrieve format information for a 4CC
- * @fourcc: the format 4CC
- *
- * Return a pointer to the format information structure corresponding to the
- * given V4L2 format 4CC, or NULL if no corresponding format can be found.
- */
-static const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(vsp1_video_formats); ++i) {
-		const struct vsp1_format_info *info = &vsp1_video_formats[i];
-
-		if (info->fourcc == fourcc)
-			return info;
-	}
-
-	return NULL;
-}
-
-
 static struct v4l2_subdev *
 vsp1_video_remote_subdev(struct media_pad *local, u32 *pad)
 {
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index f89590b83080..9624f952e095 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -21,33 +21,6 @@
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 
-/*
- * struct vsp1_format_info - VSP1 video format description
- * @mbus: media bus format code
- * @fourcc: V4L2 pixel format FCC identifier
- * @planes: number of planes
- * @bpp: bits per pixel
- * @hwfmt: VSP1 hardware format
- * @swap_yc: the Y and C components are swapped (Y comes before C)
- * @swap_uv: the U and V components are swapped (V comes before U)
- * @hsub: horizontal subsampling factor
- * @vsub: vertical subsampling factor
- * @alpha: has an alpha channel
- */
-struct vsp1_format_info {
-	u32 fourcc;
-	unsigned int mbus;
-	unsigned int hwfmt;
-	unsigned int swap;
-	unsigned int planes;
-	unsigned int bpp[3];
-	bool swap_yc;
-	bool swap_uv;
-	unsigned int hsub;
-	unsigned int vsub;
-	bool alpha;
-};
-
 struct vsp1_vb2_buffer {
 	struct vb2_buffer buf;
 	struct list_head queue;
-- 
2.4.6

