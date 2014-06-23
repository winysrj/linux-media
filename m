Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaFWXyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:11 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 17/23] v4l: vsp1: Switch to XRGB formats
Date: Tue, 24 Jun 2014 01:54:23 +0200
Message-Id: <1403567669-18539-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver ignores the alpha component on output video nodes and
hardcodes the alpha component to 0 on capture video nodes. Make this
explicit by exposing XRGB formats.

Compatibility with existing userspace applications is handled by
selecting the XRGB format corresponding to the requested old RGB format.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 885ec01..3dc7d84 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -51,11 +51,11 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 	  VI6_FMT_RGB_332, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 8, 0, 0 }, false, false, 1, 1 },
-	{ V4L2_PIX_FMT_RGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XRGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_XRGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1 },
-	{ V4L2_PIX_FMT_RGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XRGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_XRGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1 },
@@ -71,10 +71,10 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 24, 0, 0 }, false, false, 1, 1 },
-	{ V4L2_PIX_FMT_BGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XBGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
 	  1, { 32, 0, 0 }, false, false, 1, 1 },
-	{ V4L2_PIX_FMT_RGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XRGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 32, 0, 0 }, false, false, 1, 1 },
@@ -181,11 +181,29 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 				   struct v4l2_pix_format_mplane *pix,
 				   const struct vsp1_format_info **fmtinfo)
 {
+	static const u32 xrgb_formats[][2] = {
+		{ V4L2_PIX_FMT_RGB444, V4L2_PIX_FMT_XRGB444 },
+		{ V4L2_PIX_FMT_RGB555, V4L2_PIX_FMT_XRGB555 },
+		{ V4L2_PIX_FMT_BGR32, V4L2_PIX_FMT_XBGR32 },
+		{ V4L2_PIX_FMT_RGB32, V4L2_PIX_FMT_XRGB32 },
+	};
+
 	const struct vsp1_format_info *info;
 	unsigned int width = pix->width;
 	unsigned int height = pix->height;
 	unsigned int i;
 
+	/* Backward compatibility: replace deprecated RGB formats by their XRGB
+	 * equivalent. This selects the format older userspace applications want
+	 * while still exposing the new format.
+	 */
+	for (i = 0; i < ARRAY_SIZE(xrgb_formats); ++i) {
+		if (xrgb_formats[i][0] == pix->pixelformat) {
+			pix->pixelformat = xrgb_formats[i][1];
+			break;
+		}
+	}
+
 	/* Retrieve format information and select the default format if the
 	 * requested format isn't supported.
 	 */
-- 
1.8.5.5

