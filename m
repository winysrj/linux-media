Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51021 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932939AbcIGAOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 20:14:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH] v4l: vsp1: Add support for capture and output in HSV formats
Date: Wed,  7 Sep 2016 03:14:33 +0300
Message-Id: <1473207273-16446-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support both the HSV24 and HSV32 formats. From a hardware point of view
pretend the formats are RGB, the RPF and WPF will just pass the data
through without performing any processing.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---

This patch is based on top of Ricardo's "[PATCH v5 00/12] Add HSV format"
series. I have tested it with the VSP test suite available at

	git://git.ideasonboard.com/renesas/vsp-tests.git hsv

 drivers/media/platform/vsp1/vsp1_pipe.c  | 8 ++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_video.c | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 052a6037b9cb..c0b8641d2158 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -80,6 +80,14 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 32, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_HSV24, MEDIA_BUS_FMT_AHSV8888_1X32,
+	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 24, 0, 0 }, false, false, 1, 1, false },
+	{ V4L2_PIX_FMT_HSV32, MEDIA_BUS_FMT_AHSV8888_1X32,
+	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
+	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
+	  1, { 32, 0, 0 }, false, false, 1, 1, false },
 	{ V4L2_PIX_FMT_UYVY, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 8d461b375e91..13e969ac1538 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -37,6 +37,7 @@ static int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 {
 	static const unsigned int codes[] = {
 		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AHSV8888_1X32,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 
@@ -74,6 +75,7 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 
 	/* Default to YUV if the requested format is not supported. */
 	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 7215e08eff6e..325377d7c444 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -126,6 +126,11 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	pix->pixelformat = info->fourcc;
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
 	pix->field = V4L2_FIELD_NONE;
+
+	if (info->fourcc == V4L2_PIX_FMT_HSV24 ||
+	    info->fourcc == V4L2_PIX_FMT_HSV32)
+		pix->hsv_enc = V4L2_HSV_ENC_256;
+
 	memset(pix->reserved, 0, sizeof(pix->reserved));
 
 	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
-- 
Regards,

Laurent Pinchart

