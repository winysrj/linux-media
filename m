Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2DQKKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:14 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M005QQC8MZN@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M0021TC8OKD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:00 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/15] V4L: Add camera exposure metering control
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-9-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_EXPOSURE_METERING control allows to determine
a method used by the camera for measuring the amount of light
available for automatic exposure.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   29 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   14 +++++++++++++
 include/linux/videodev2.h                    |    7 +++++++
 3 files changed, 50 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index c50941e..fc05f9d 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2855,6 +2855,35 @@ exposure time and/or aperture.</para></entry>
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
index aa3d111..e037601 100644
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
@@ -427,6 +433,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_power_line_frequency;
 	case V4L2_CID_EXPOSURE_AUTO:
 		return camera_exposure_auto;
+	case V4L2_CID_EXPOSURE_METERING:
+		return camera_exposure_metering;
+	case V4L2_CID_AUTO_FOCUS_AREA:
+		return camera_auto_focus_area;
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:
+		return camera_auto_focus_distance;
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_WHITE_BALANCE_PRESET:
@@ -622,6 +634,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
 	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
+	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -762,6 +775,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
+	case V4L2_CID_EXPOSURE_METERING:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 1c6d342..37ecd6a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1747,6 +1747,13 @@ enum v4l2_white_balance_preset {
 #define V4L2_CID_ISO_SENSITIVITY		(V4L2_CID_CAMERA_CLASS_BASE+23)
 #define V4L2_CID_ISO_SENSITIVITY_AUTO		(V4L2_CID_CAMERA_CLASS_BASE+24)
 
+#define V4L2_CID_EXPOSURE_METERING		(V4L2_CID_CAMERA_CLASS_BASE+25)
+enum v4l2_exposure_metering_mode {
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

