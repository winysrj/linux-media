Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59653 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbaFADja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 14/18] v4l: vsp1: Add alpha channel support to the memory ports
Date: Sun,  1 Jun 2014 05:39:33 +0200
Message-Id: <1401593977-30660-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support ARGB formats on the RPF side by reading the alpha component from
memory and on the WPF side by writing it to memory.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   |  8 ++++--
 drivers/media/platform/vsp1/vsp1_video.c | 49 +++++++++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_video.h |  2 ++
 drivers/media/platform/vsp1/vsp1_wpf.c   |  2 ++
 4 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 9b3fc70..2824f53 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -101,10 +101,12 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		       (rpf->location.left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (rpf->location.top << VI6_RPF_LOC_VCOORD_SHIFT));
 
-	/* Disable alpha, mask and color key. Set the alpha channel to a fixed
-	 * value of 255.
+	/* Use the alpha channel (extended to 8 bits) when available or a
+	 * hardcoded 255 value otherwise. Disable color keying.
 	 */
-	vsp1_rpf_write(rpf, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_ASEL_FIXED);
+	vsp1_rpf_write(rpf, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
+		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
+				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
 		       255 << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 415989c..cc22264 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -50,70 +50,85 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 	{ V4L2_PIX_FMT_RGB332, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_RGB_332, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 8, 0, 0 }, false, false, 1, 1 },
+	  1, { 8, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_ARGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, true },
 	{ V4L2_PIX_FMT_XRGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_XRGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1 },
+	  1, { 16, 0, 0 }, false, false, 1, 1, true },
+	{ V4L2_PIX_FMT_ARGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS,
+	  1, { 16, 0, 0 }, false, false, 1, 1, true },
 	{ V4L2_PIX_FMT_XRGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_XRGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1 },
+	  1, { 16, 0, 0 }, false, false, 1, 1, false },
 	{ V4L2_PIX_FMT_RGB565, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_RGB_565, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
-	  1, { 16, 0, 0 }, false, false, 1, 1 },
+	  1, { 16, 0, 0 }, false, false, 1, 1, false },
 	{ V4L2_PIX_FMT_BGR24, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_BGR_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 24, 0, 0 }, false, false, 1, 1 },
+	  1, { 24, 0, 0 }, false, false, 1, 1, false },
 	{ V4L2_PIX_FMT_RGB24, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 24, 0, 0 }, false, false, 1, 1 },
+	  1, { 24, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_ABGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, true },
 	{ V4L2_PIX_FMT_XBGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
-	  1, { 32, 0, 0 }, false, false, 1, 1 },
+	  1, { 32, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_ARGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, true },
 	{ V4L2_PIX_FMT_XRGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 32, 0, 0 }, false, false, 1, 1 },
+	  1, { 32, 0, 0 }, false, false, 1, 1, false },
 	{ V4L2_PIX_FMT_UYVY, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, false, false, 2, 1 },
+	  1, { 16, 0, 0 }, false, false, 2, 1, false },
 	{ V4L2_PIX_FMT_VYUY, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, false, true, 2, 1 },
+	  1, { 16, 0, 0 }, false, true, 2, 1, false },
 	{ V4L2_PIX_FMT_YUYV, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, true, false, 2, 1 },
+	  1, { 16, 0, 0 }, true, false, 2, 1, false },
 	{ V4L2_PIX_FMT_YVYU, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  1, { 16, 0, 0 }, true, true, 2, 1 },
+	  1, { 16, 0, 0 }, true, true, 2, 1, false },
 	{ V4L2_PIX_FMT_NV12M, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, false, 2, 2 },
+	  2, { 8, 16, 0 }, false, false, 2, 2, false },
 	{ V4L2_PIX_FMT_NV21M, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, true, 2, 2 },
+	  2, { 8, 16, 0 }, false, true, 2, 2, false },
 	{ V4L2_PIX_FMT_NV16M, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, false, 2, 1 },
+	  2, { 8, 16, 0 }, false, false, 2, 1, false },
 	{ V4L2_PIX_FMT_NV61M, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  2, { 8, 16, 0 }, false, true, 2, 1 },
+	  2, { 8, 16, 0 }, false, true, 2, 1, false },
 	{ V4L2_PIX_FMT_YUV420M, V4L2_MBUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
-	  3, { 8, 8, 8 }, false, false, 2, 2 },
+	  3, { 8, 8, 8 }, false, false, 2, 2, false },
 };
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index cb5d9ef..4dad110 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -33,6 +33,7 @@ struct vsp1_video;
  * @swap_uv: the U and V components are swapped (V comes before U)
  * @hsub: horizontal subsampling factor
  * @vsub: vertical subsampling factor
+ * @alpha: has an alpha channel
  */
 struct vsp1_format_info {
 	u32 fourcc;
@@ -45,6 +46,7 @@ struct vsp1_format_info {
 	bool swap_uv;
 	unsigned int hsub;
 	unsigned int vsub;
+	bool alpha;
 };
 
 enum vsp1_pipeline_state {
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d330865..a2ba107 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -99,6 +99,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 		outfmt = fmtinfo->hwfmt << VI6_WPF_OUTFMT_WRFMT_SHIFT;
 
+		if (fmtinfo->alpha)
+			outfmt |= VI6_WPF_OUTFMT_PXA;
 		if (fmtinfo->swap_yc)
 			outfmt |= VI6_WPF_OUTFMT_SPYCS;
 		if (fmtinfo->swap_uv)
-- 
1.8.5.5

