Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40435 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab2APVeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 16:34:00 -0500
Received: by eaac11 with SMTP id c11so348726eaa.19
        for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 13:33:59 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC][DRAFT] V4L: Add camera auto focus controls
Date: Mon, 16 Jan 2012 22:33:42 +0100
Message-Id: <1326749622-11446-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following auto focus controls are added:

 - V4L2_CID_AUTO_FOCUS_START - one-shot auto focus start
 - V4L2_CID_AUTO_FOCUS_STOP -  one-shot auto focus start
 - V4L2_CID_AUTO_FOCUS_STATUS - auto focus status
 - V4L2_CID_AUTO_FOCUS_DISTANCE - auto focus scan reange selection
 - V4L2_CID_AUTO_FOCUS_SELECTION - auto focus area selection
 - V4L2_CID_AUTO_FOCUS_X_POSITION - horizontal AF spot position
 - V4L2_CID_AUTO_FOCUS_Y_POSITION - vertical AF spot position
 - V4L2_CID_AUTO_FOCUS_RECTANGLE_COUNT - number of AF statistics
                                         rectangles
 - V4L2_CID_AUTO_FOCUS_FACE_PRIORITY - enable/disable face priority
                                       auto focus

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
Hello,

This is a draft of new Auto Focus controls, it incorporates comments
from the previous discussions.

I decided to drop the idea of of new pixel point control type for AF spot
configuration, as the benefits from having it are minor comparing to the
implementation efforts.

Thanks,
Sylwester
---
 Documentation/DocBook/media/v4l/controls.xml |  172 +++++++++++++++++++++++++-
 drivers/media/video/v4l2-ctrls.c             |   44 +++++++-
 include/linux/videodev2.h                    |   28 ++++
 3 files changed, 241 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a1be378..1a5e90f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2798,13 +2798,181 @@ negative values towards infinity. This is a write-only control.</entry>
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
-	  </row><row><entry spanname="descr">Enables automatic focus
-adjustments. The effect of manual focus adjustments while this feature
+	  </row><row><entry spanname="descr">Enables continuous automatic
+focus adjustments. The effect of manual focus adjustments while this feature
 is enabled is undefined, drivers should ignore such requests.</entry>
 	  </row>
 	  <row><entry></entry></row>

 	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_START</constant>&nbsp;</entry>
+	    <entry>button</entry>
+	  </row><row><entry spanname="descr">Start single auto focus action.
+The effect of setting this control when <constant>V4L2_CID_FOCUS_AUTO</constant>
+is set to <constant>TRUE</constant> (1) is undefined, drivers should ignore
+such requests.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_STOP</constant>&nbsp;</entry>
+	    <entry>button</entry>
+	  </row><row><entry spanname="descr">Abort automatic focus started with
+<constant>V4L2_CID_AUTO_FOCUS_START</constant>. This control is effective only
+when the continuous automatic focus is disabled, i.e. <constant>
+V4L2_CID_FOCUS_AUTO</constant> control is set to <constant>FALSE</constant>
+(0).</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row id="v4l2-auto-focus-status">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_auto_focus_status</entry>
+	  </row>
+	  <row><entry spanname="descr">The automatic focus status. This is a read-only
+	  control.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_IDLE</constant>&nbsp;</entry>
+		  <entry>Automatic focus is inactive.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_BUSY</constant>&nbsp;</entry>
+		  <entry>Automatic focusing is in progress and the focus is changing.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_SUCCESS</constant>&nbsp;</entry>
+		  <entry>Automatic focus has completed or is continued successfully.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_FAIL</constant>&nbsp;</entry>
+		  <entry>Automatic focus has failed.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row id="v4l2-auto-focus-distance">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_DISTANCE</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_auto_focus_distance</entry>
+	  </row>
+	  <row><entry spanname="descr">The automatic focus distance range
+for which lens may be adjusted. </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_DISTANCE_NORMAL</constant>&nbsp;</entry>
+		  <entry>The normal distance range of the camera. It is limited
+in order to achieve best auto focus performance.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_DISTANCE_MACRO</constant>&nbsp;</entry>
+		  <entry>Macro (close-up) auto focus distance range. The camera
+uses minimum possible distance, that it is capable of, for automatic focus.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_DISTANCE_INFINITY</constant>&nbsp;</entry>
+		  <entry>The camera is focused permanently at its farthest
+possible distance. This option is only supported by drivers that do not expose
+<constant>V4L2_CID_FOCUS_ABSOLUTE</constant> control.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row id="v4l2-auto-focus-selection">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_SELECTION</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_auto_focus_selection</entry>
+	  </row>
+	  <row><entry spanname="descr">This control determines which parts
+of an image frame are used for the auto focus statistics computation. It is
+valid for one-shot and continuous automatic focus. The effect of setting
+this control when <constant>V4L2_CID_AUTO_FOCUS_FACE_PRIORITY</constant>
+is set to <constant>TRUE</constant>(1) is undefined, drivers should ignore
+such requests.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_SELECTION_NORMAL</constant>&nbsp;</entry>
+		  <entry>Normal auto focus where an entire frame is used for
+the statistics computation.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_SELECTION_SPOT</constant>&nbsp;</entry>
+		  <entry>Focus on object within a frame specified by coordinates
+passed with <constant>V4L2_CID_AUTO_FOCUS_X_POSITION</constant> and <constant>
+V4L2_CID_AUTO_FOCUS_Y_POSITION</constant> controls. When these controls are not
+available the default point position is the center of a frame.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_SELECTION_RECTANGLE</constant>&nbsp;</entry>
+		  <entry>The focus area is determined by one or more rectangles
+specified by means of the selection API. For more details on the windows selection
+see the <constant>V4L2_SELECTION_STAT_AF</constant> and <constant>
+V4L2_SUBDEV_SELECTION_STAT_AF</constant> selection targets description. The
+<constant>V4L2_CID_AUTO_FOCUS_RECTANGLE_COUNT</constant> control allows to
+determine an overall number of the selection rectangles.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_X_POSITION
+	    </constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">Determine position of the spot
+in horizontal direction for <constant>V4L2_AUTO_FOCUS_SELECTION_SPOT</constant>
+auto focus. The unit is 1 pixel.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_Y_POSITION
+	    </constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">Determine position of the spot
+in verical direction for <constant>V4L2_AUTO_FOCUS_SELECTION_SPOT</constant>
+auto focus. The unit is 1 pixel.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_RECTANGLE_COUNT
+	    </constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">Specify number of the automatic
+focus statistics rectangles.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_FACE_PRIORITY
+	    </constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row><row><entry spanname="descr">Enable or disable face priority
+auto focus where the camera focus is driven by a face detection engine.
+When this control is set to <constant>TRUE</constant> (1) the <constant>
+V4L2_CID_AUTO_FOCUS_SELECTION</constant> control, if present, will be reset
+to <constant>V4L2_AUTO_FOCUS_SELECTION_NORMAL</constant> by the driver.
+</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
 	  </row><row><entry spanname="descr">Specify the objective lens
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index da1f4c2..59afd60 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -221,6 +221,26 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Aperture Priority Mode",
 		NULL
 	};
+	static const char * const camera_auto_focus_mode[] = {
+		"Auto Focus, Selection Normal",
+		"Auto Focus, Selection Spot",
+		"Auto Focus, Selection Rectangle",
+		NULL
+	};
+	static const char * const camera_auto_focus_status[] = {
+		"Auto Focus Status, Idle",
+		"Auto Focus Status, Busy",
+		"Auto Focus Status, Success",
+		"Auto Focus Status, Fail",
+		NULL
+	};
+	static const char * const camera_auto_focus_distance[] = {
+		"Auto Focus Distance, Normal",
+		"Auto Focus Distance, Macro",
+		"Auto Focus Distance, Infinity",
+		NULL
+	};
+
 	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
@@ -388,6 +408,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_power_line_frequency;
 	case V4L2_CID_EXPOSURE_AUTO:
 		return camera_exposure_auto;
+	case V4L2_CID_AUTO_FOCUS_MODE:
+		return camera_auto_focus_mode;
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:
+		return camera_auto_focus_distance;
+	case V4L2_CID_AUTO_FOCUS_STATUS:
+		return camera_auto_focus_status;
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
@@ -561,13 +587,22 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
 	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
 	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
-	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
+	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic Continuous";
 	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
 	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
 	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
 	case V4L2_CID_PRIVACY:			return "Privacy";
 	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
+	case V4L2_CID_AUTO_FOCUS_START:		return "Auto Focus, Start";
+	case V4L2_CID_AUTO_FOCUS_STOP:		return "Auto Focus, Stop";
+	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:	return "Auto Focus, Distance";
+	case V4L2_CID_AUTO_FOCUS_SELECTION:	return "Auto Focus, Selection";
+	case V4L2_CID_AUTO_FOCUS_X_POSITION:	return "Auto Focus, Position X";
+	case V4L2_CID_AUTO_FOCUS_Y_POSITION:	return "Auto Focus, Position Y";
+	case V4L2_CID_AUTO_FOCUS_RECTANGLE_COUNT: return "Auto Focus, Rectangles Count";
+	case V4L2_CID_AUTO_FOCUS_FACE_PRIORITY:	return "Auto Focus, Face Priority";

 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -635,6 +670,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
 	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
 	case V4L2_CID_FOCUS_AUTO:
+	case V4L2_CID_AUTO_FOCUS_FACE_PRIORITY:
 	case V4L2_CID_PRIVACY:
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:
 	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
@@ -659,6 +695,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
 	case V4L2_CID_FLASH_STROBE_STOP:
+	case V4L2_CID_AUTO_FOCUS_START:
+	case V4L2_CID_AUTO_FOCUS_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		*min = *max = *step = *def = 0;
@@ -680,6 +718,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_AUTO_FOCUS_MODE:
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
 	case V4L2_CID_FLASH_LED_MODE:
@@ -770,6 +811,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
 	case V4L2_CID_FLASH_STROBE_STATUS:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_FLASH_READY:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 012a296..0808b12 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1662,6 +1662,34 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
 #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)

+#define V4L2_CID_AUTO_FOCUS_START		(V4L2_CID_CAMERA_CLASS_BASE+19)
+#define V4L2_CID_AUTO_FOCUS_STOP		(V4L2_CID_CAMERA_CLASS_BASE+20)
+#define V4L2_CID_AUTO_FOCUS_STATUS		(V4L2_CID_CAMERA_CLASS_BASE+21)
+enum v4l2_auto_focus_status {
+	V4L2_AUTO_FOCUS_STATUS_IDLE		= 0,
+	V4L2_AUTO_FOCUS_STATUS_BUSY		= 1,
+	V4L2_AUTO_FOCUS_STATUS_SUCCESS		= 2,
+	V4L2_AUTO_FOCUS_STATUS_FAIL		= 3,
+};
+
+#define V4L2_CID_AUTO_FOCUS_DISTANCE		(V4L2_CID_CAMERA_CLASS_BASE+22)
+enum v4l2_auto_focus_distance {
+	V4L2_AUTO_FOCUS_DISTANCE_NORMAL		= 0,
+	V4L2_AUTO_FOCUS_DISTANCE_MACRO		= 1,
+	V4L2_AUTO_FOCUS_DISTANCE_INFINITY	= 2,
+};
+
+#define V4L2_CID_AUTO_FOCUS_SELECTION		(V4L2_CID_CAMERA_CLASS_BASE+23)
+enum v4l2_auto_focus_selection {
+	V4L2_AUTO_FOCUS_SELECTION_NORMAL	= 0,
+	V4L2_AUTO_FOCUS_SELECTION_SPOT		= 1,
+	V4L2_AUTO_FOCUS_SELECTION_RECTANGLE	= 2,
+};
+#define V4L2_CID_AUTO_FOCUS_X_POSITION		(V4L2_CID_CAMERA_CLASS_BASE+24)
+#define V4L2_CID_AUTO_FOCUS_Y_POSITION		(V4L2_CID_CAMERA_CLASS_BASE+25)
+#define V4L2_CID_AUTO_FOCUS_RECTANGLE_COUNT	(V4L2_CID_CAMERA_CLASS_BASE+26)
+#define V4L2_CID_AUTO_FOCUS_FACE_PRIORITY	(V4L2_CID_CAMERA_CLASS_BASE+27)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
--
1.7.4.1

