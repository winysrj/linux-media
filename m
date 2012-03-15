Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33702 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031663Ab2COQyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X0060ZQZ4I810@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:40 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X00FNPQZ3XT@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:40 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:21 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 07/23] V4L: Add camera exposure metering mode control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-8-git-send-email-s.nawrocki@samsung.com>
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_EXPOSURE_METERING control allows to determine what
method is used by the camera to measure amount of light available
for automatic exposure control.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   29 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   10 +++++++++
 include/linux/videodev2.h                    |    7 +++++++
 3 files changed, 46 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b92c85a..aa3b2db 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2790,6 +2790,35 @@ by adjusting absolute exposure time and/or aperture.</para></entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-exposure-metering-mode">
+	    <entry spanname="id"><constant>V4L2_CID_EXPOSURE_METERING</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_exposure_metering_mode</entry>
+	  </row><row><entry spanname="descr">Determines how the camera measures
+the amount of light available to expose a frame. Possible values are:</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_AVERAGE</constant>&nbsp;</entry>
+		  <entry>Use the light information coming from the entire frame
+and average giving no weighting to any particular portion of metered area.
+		  </entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_CENTER_WEIGHTED</constant>&nbsp;</entry>
+		  <entry>Average the light information coming from the entire frame
+giving priority to the center of metered area.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_SPOT</constant>&nbsp;</entry>
+		  <entry>Measure only very small area at the centre of the frame.</entry>
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
index 58c7849..3ffd037 100644
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
 	static const char * const camera_auto_focus_area[] = {
 		"All",
 		"Spot",
@@ -432,6 +438,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_power_line_frequency;
 	case V4L2_CID_EXPOSURE_AUTO:
 		return camera_exposure_auto;
+	case V4L2_CID_EXPOSURE_METERING:
+		return camera_exposure_metering;
 	case V4L2_CID_AUTO_FOCUS_AREA:
 		return camera_auto_focus_area;
 	case V4L2_CID_AUTO_FOCUS_DISTANCE:
@@ -638,6 +646,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
+	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -789,6 +798,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
+	case V4L2_CID_EXPOSURE_METERING:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 440d59c99..05438a5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1734,6 +1734,13 @@ enum v4l2_white_balance_preset {
 #define V4L2_CID_ISO_SENSITIVITY		(V4L2_CID_CAMERA_CLASS_BASE+34)
 #define V4L2_CID_ISO_SENSITIVITY_AUTO		(V4L2_CID_CAMERA_CLASS_BASE+35)
 
+#define V4L2_CID_EXPOSURE_METERING		(V4L2_CID_CAMERA_CLASS_BASE+36)
+enum v4l2_exposure_metering_mode {
+	V4L2_EXPOSURE_METERING_AVERAGE,
+	V4L2_EXPOSURE_METERING_CENTER_WEIGHTED,
+	V4L2_EXPOSURE_METERING_SPOT,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.9.2

