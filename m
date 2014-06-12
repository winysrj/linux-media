Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2515 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbaFLL7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:59:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 25/34] v4l2-ctrls: fix comments
Date: Thu, 12 Jun 2014 13:52:57 +0200
Message-Id: <5244cc5d15a7d92b17b5e1dd5b86c248993695c9.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various comments referred to videodev2.h, but the control definitions have
been moved to v4l2-controls.h.

Also add the same reminder message to each class of controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index adf5485..5aaf15e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -592,7 +592,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 {
 	switch (id) {
 	/* USER controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_USER_CLASS:		return "User Controls";
 	case V4L2_CID_BRIGHTNESS:		return "Brightness";
 	case V4L2_CID_CONTRAST:			return "Contrast";
@@ -754,7 +754,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
 
 	/* CAMERA controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
 	case V4L2_CID_EXPOSURE_AUTO:		return "Auto Exposure";
 	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
@@ -788,8 +788,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
 	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
 
-	/* FM Radio Modulator control */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* FM Radio Modulator controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
 	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
 	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
@@ -812,6 +812,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
 	/* Flash controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_FLASH_CLASS:		return "Flash Controls";
 	case V4L2_CID_FLASH_LED_MODE:		return "LED Mode";
 	case V4L2_CID_FLASH_STROBE_SOURCE:	return "Strobe Source";
@@ -827,7 +828,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
 
 	/* JPEG encoder controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_JPEG_CLASS:		return "JPEG Compression Controls";
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:	return "Chroma Subsampling";
 	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
@@ -835,18 +836,21 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
 
 	/* Image source controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image Source Controls";
 	case V4L2_CID_VBLANK:			return "Vertical Blanking";
 	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
 	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
 
 	/* Image processing controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
 
 	/* DV controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_DV_CLASS:			return "Digital Video Controls";
 	case V4L2_CID_DV_TX_HOTPLUG:		return "Hotplug Present";
 	case V4L2_CID_DV_TX_RXSENSE:		return "RxSense Present";
-- 
2.0.0.rc0

