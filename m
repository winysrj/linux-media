Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2291 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaAaJ5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 04:57:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 25/32] v4l2-ctrls: fix comments
Date: Fri, 31 Jan 2014 10:56:23 +0100
Message-Id: <1391162190-8620-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
References: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
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
index 4e3b70d..47b552d 100644
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
@@ -752,7 +752,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
 
 	/* CAMERA controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
 	case V4L2_CID_EXPOSURE_AUTO:		return "Auto Exposure";
 	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
@@ -786,8 +786,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
 	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
 
-	/* FM Radio Modulator control */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* FM Radio Modulator controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
 	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
 	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
@@ -810,6 +810,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
 
 	/* Flash controls */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_FLASH_CLASS:		return "Flash Controls";
 	case V4L2_CID_FLASH_LED_MODE:		return "LED Mode";
 	case V4L2_CID_FLASH_STROBE_SOURCE:	return "Strobe Source";
@@ -825,7 +826,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
 
 	/* JPEG encoder controls */
-	/* Keep the order of the 'case's the same as in videodev2.h! */
+	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_JPEG_CLASS:		return "JPEG Compression Controls";
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:	return "Chroma Subsampling";
 	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
@@ -833,18 +834,21 @@ const char *v4l2_ctrl_get_name(u32 id)
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
1.8.5.2

