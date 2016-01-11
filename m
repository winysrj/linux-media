Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43416 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203AbcAKEHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 23:07:48 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 3/3] v4l: vsp1: Add tri-planar memory formats support
Date: Mon, 11 Jan 2016 06:07:44 +0200
Message-Id: <1452485264-11328-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1452485264-11328-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1452485264-11328-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 96f0e7d4c400..c96b47a882de 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -113,6 +113,26 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  3, { 8, 8, 8 }, false, false, 2, 2, false },
+	{ V4L2_PIX_FMT_YVU420M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, true, 2, 2, false },
+	{ V4L2_PIX_FMT_YUV422M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, false, 2, 1, false },
+	{ V4L2_PIX_FMT_YVU422M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, true, 2, 1, false },
+	{ V4L2_PIX_FMT_YUV444M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_YVU444M, MEDIA_BUS_FMT_AYUV8_1X32,
+	  VI6_FMT_Y_U_V_444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  3, { 8, 8, 8 }, false, true, 1, 1, false },
 };
 
 /*
-- 
2.4.10

