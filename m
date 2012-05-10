Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab2EJKbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:10 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S003FPYJKYO@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:56 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DAQYJQ3L@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:02 +0100 (BST)
Date: Thu, 10 May 2012 12:30:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/23] V4L: Add camera exposure metering control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_EXPOSURE_METERING control allows to determine
a method used by the camera for measuring the amount of light
available for automatic exposure.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   29 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   10 +++++++++
 include/linux/videodev2.h                    |    7 +++++++
 3 files changed, 46 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b1646b9..9571c96 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2864,6 +2864,35 @@ exposure time and/or aperture.</para></entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-exposure-metering">
+	    <entry spanname="id"><constant>V4L2_CID_EXPOSURE_METERING</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_exposure_metering</entry>
+	  </row><row><entry spanname="descr">Determines how the camera measures
+the amount of light available for the frame exposure. Possible values are:</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_AVERAGE</constant>&nbsp;</entry>
+		  <entry>Use the light information coming from the entire frame
+and average giving no weighting to any particular portion of the metered area.
+		  </entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_CENTER_WEIGHTED</constant>&nbsp;</entry>
+		  <entry>Average the light information coming from the entire frame
+giving priority to the center of the metered area.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_SPOT</constant>&nbsp;</entry>
+		  <entry>Measure only very small area at the center of the frame.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_PAN_RELATIVE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index f4c4072..33a4b8a 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -230,6 +230,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Aperture Priority Mode",
 		NULL
 	};
+	static const char * const camera_exposure_metering[] = {
+		"Average",
+		"Center Weighted",
+		"Spot",
+		NULL
+	};
 	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
@@ -434,6 +440,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_power_line_frequency;
 	case V4L2_CID_EXPOSURE_AUTO:
 		return camera_exposure_auto;
+	case V4L2_CID_EXPOSURE_METERING:
+		return camera_exposure_metering;
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
@@ -632,6 +640,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
 	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
+	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -772,6 +781,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+	case V4L2_CID_EXPOSURE_METERING:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index fe5592e..215b7df 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1726,6 +1726,13 @@ enum v4l2_iso_sensitivity_auto_type {
 	V4L2_ISO_SENSITIVITY_AUTO		= 1,
 };
 
+#define V4L2_CID_EXPOSURE_METERING		(V4L2_CID_CAMERA_CLASS_BASE+25)
+enum v4l2_exposure_metering {
+	V4L2_EXPOSURE_METERING_AVERAGE		= 0,
+	V4L2_EXPOSURE_METERING_CENTER_WEIGHTED	= 1,
+	V4L2_EXPOSURE_METERING_SPOT		= 2,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

