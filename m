Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63374 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972Ab2D0OXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3500BIX6NKP530@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M35001WQ6NALZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:34 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 07/14] V4L: Add camera exposure metering control
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-8-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
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
index 557daae..8f4fdf8 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2790,6 +2790,35 @@ exposure time and/or aperture.</para></entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-exposure-metering-mode">
+	    <entry spanname="id"><constant>V4L2_CID_EXPOSURE_METERING</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_exposure_metering_type</entry>
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
index 3d8af91..dcf6b2b 100644
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
@@ -437,6 +443,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
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
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
@@ -638,6 +650,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
 	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
+	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -778,6 +791,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+	case V4L2_CID_EXPOSURE_METERING:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 12cc16d..a8588fc 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1727,6 +1727,13 @@ enum v4l2_iso_sensitivity_auto_type {
 	V4L2_ISO_SENSITIVITY_AUTO		= 1,
 };
 
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

