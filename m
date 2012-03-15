Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030493Ab2COQyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:43 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X00LQOQYX46@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:33 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X0018HQZ3UK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:39 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 01/23] V4L: Add camera auto focus controls
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add following auto focus controls and documentation:

 - V4L2_CID_AUTO_FOCUS_START - one-shot auto focus start
 - V4L2_CID_AUTO_FOCUS_STOP -  one-shot auto focus stop
 - V4L2_CID_AUTO_FOCUS_STATUS - auto focus status
 - V4L2_CID_AUTO_FOCUS_DISTANCE - auto focus scan range selection
 - V4L2_CID_AUTO_FOCUS_AREA - auto focus area selection
 - V4L2_CID_AUTO_FOCUS_FACE_PRIORITY - enable/disable face priority
                                       auto focus

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |  153 +++++++++++++++++++++++++-
 drivers/media/video/v4l2-ctrls.c             |   32 +++++-
 include/linux/videodev2.h                    |   24 ++++
 3 files changed, 206 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index ce05a4b..16742c0 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2857,13 +2857,162 @@ negative values towards infinity. This is a write-only control.</entry>
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
+	  </row><row><entry spanname="descr">Starts single auto focus process.
+The effect of setting this control when <constant>V4L2_CID_FOCUS_AUTO</constant>
+is set to <constant>TRUE</constant> (1) is undefined, drivers should ignore
+such requests.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_STOP</constant>&nbsp;</entry>
+	    <entry>button</entry>
+	  </row><row><entry spanname="descr">Aborts automatic focus process
+started with <constant>V4L2_CID_AUTO_FOCUS_START</constant> control. It is
+effective only when the continuous auto focus is disabled, that is when
+<constant>V4L2_CID_FOCUS_AUTO</constant> control is set to <constant>FALSE
+</constant> (0).</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row id="v4l2-auto-focus-status">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>&nbsp;</entry>
+	    <entry>bitmask</entry>
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
+		  <entry>Automatic focus has failed, a driver will not transition
+		    from this state until another action is performed by an
+		    application.</entry>
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
+	  <row><entry spanname="descr">Determines auto focus distance range
+for which lens may be adjusted. </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_DISTANCE_NORMAL</constant>&nbsp;</entry>
+		  <entry>The auto focus normal distance range. It is limited
+for best auto focus algorithm performance.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_DISTANCE_MACRO</constant>&nbsp;</entry>
+		  <entry>Macro (close-up) auto focus. The camera will
+use minimum possible distance that it is capable of for auto focus.</entry>
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
+	  <row id="v4l2-auto-focus-area">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_auto_focus_area</entry>
+	  </row>
+	  <row><entry spanname="descr">Determines the area of the frame that
+the camera will use for auto focus. It is applicable to one-shot and continuous
+auto focus. The effect of setting this control when <constant>
+V4L2_CID_AUTO_FOCUS_FACE_PRIORITY</constant> is set to <constant>TRUE</constant>
+(1) is undefined, drivers should ignore such requests.
+<para>
+The <link linkend="selection-api"> selection API</link> can be used to specify
+or query coordinates of the focus spot or rectangle. To change auto focus region
+of interest applications first select required mode of this control and then
+set the rectangle or spot coordinates by means of the &VIDIOC-SUBDEV-S-SELECTION;
+or &VIDIOC-S-SELECTION; ioctl. In order to trigger again an auto focus process
+with same coordinates applications should use the <constant>V4L2_CID_AUTO_FOCUS_START
+</constant> control or invoke &VIDIOC-SUBDEV-S-SELECTION; or &VIDIOC-S-SELECTION;
+ioctl with same parameters. The new coordinates are applied to hardware only when
+this controls is set to value different than <constant>V4L2_AUTO_FOCUS_AREA_ALL
+</constant>.</para></entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>&nbsp;</entry>
+		  <entry>Normal auto focus where data from an entire frame is
+used for the auto focus statistics calculation.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant>&nbsp;</entry>
+		  <entry>Automatic focus on a spot within a frame at position
+specified by the <constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> or
+<constant>V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> selection. When those
+selections are not supported by driver the default spot's position is center of
+the frame.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>&nbsp;</entry>
+		  <entry>Auto focus area is determined by <constant>
+V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> or <constant>
+V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> selection rectangle.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_FACE_PRIORITY
+	    </constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row><row><entry spanname="descr">Enable or disable face priority
+auto focus, where the camera focus is driven by face detection engine.
+When this control is set to <constant>TRUE</constant> (1) the <constant>
+V4L2_CID_AUTO_FOCUS_AREA</constant> control, if present, will be reset
+by drivers to <constant>V4L2_AUTO_FOCUS_AREA_NORMAL</constant>.
+</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
 	  </row><row><entry spanname="descr">Specify the objective lens
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 01c5d3e..65aa63c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -230,6 +230,19 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Aperture Priority Mode",
 		NULL
 	};
+	static const char * const camera_auto_focus_area[] = {
+		"All",
+		"Spot",
+		"Rectangle",
+		NULL
+	};
+	static const char * const camera_auto_focus_distance[] = {
+		"Normal",
+		"Macro",
+		"Infinity",
+		NULL
+	};
+
 	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
@@ -410,6 +423,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_power_line_frequency;
 	case V4L2_CID_EXPOSURE_AUTO:
 		return camera_exposure_auto;
+	case V4L2_CID_AUTO_FOCUS_AREA:
+		return camera_auto_focus_area;
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:
+		return camera_auto_focus_distance;
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
@@ -590,13 +607,19 @@ const char *v4l2_ctrl_get_name(u32 id)
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
+	case V4L2_CID_AUTO_FOCUS_AREA:		return "Auto Focus, Area";
+	case V4L2_CID_AUTO_FOCUS_FACE_PRIORITY:	return "Auto Focus, Face Priority";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -678,6 +701,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
 	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
 	case V4L2_CID_FOCUS_AUTO:
+	case V4L2_CID_AUTO_FOCUS_FACE_PRIORITY:
 	case V4L2_CID_PRIVACY:
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:
 	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
@@ -702,6 +726,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
 	case V4L2_CID_FLASH_STROBE_STOP:
+	case V4L2_CID_AUTO_FOCUS_START:
+	case V4L2_CID_AUTO_FOCUS_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		*min = *max = *step = *def = 0;
@@ -725,6 +751,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_AUTO_FOCUS_AREA:
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
 	case V4L2_CID_FLASH_LED_MODE:
@@ -766,6 +794,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_FLASH_FAULT:
 	case V4L2_CID_JPEG_ACTIVE_MARKER:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
@@ -824,6 +853,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
 	case V4L2_CID_FLASH_STROBE_STATUS:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_FLASH_READY:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index d48e954..615d939 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1694,6 +1694,30 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
 #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
 
+#define V4L2_CID_AUTO_FOCUS_START		(V4L2_CID_CAMERA_CLASS_BASE+19)
+#define V4L2_CID_AUTO_FOCUS_STOP		(V4L2_CID_CAMERA_CLASS_BASE+20)
+#define V4L2_CID_AUTO_FOCUS_STATUS		(V4L2_CID_CAMERA_CLASS_BASE+21)
+#define	V4L2_AUTO_FOCUS_STATUS_IDLE		(0 << 0)
+#define	V4L2_AUTO_FOCUS_STATUS_BUSY		(1 << 0)
+#define	V4L2_AUTO_FOCUS_STATUS_SUCCESS		(1 << 1)
+#define	V4L2_AUTO_FOCUS_STATUS_FAIL		(1 << 2)
+
+#define V4L2_CID_AUTO_FOCUS_DISTANCE		(V4L2_CID_CAMERA_CLASS_BASE+22)
+enum v4l2_auto_focus_distance {
+	V4L2_AUTO_FOCUS_DISTANCE_NORMAL		= 0,
+	V4L2_AUTO_FOCUS_DISTANCE_MACRO		= 1,
+	V4L2_AUTO_FOCUS_DISTANCE_INFINITY	= 2,
+};
+
+#define V4L2_CID_AUTO_FOCUS_AREA		(V4L2_CID_CAMERA_CLASS_BASE+23)
+enum v4l2_auto_focus_area {
+	V4L2_AUTO_FOCUS_AREA_ALL		= 0,
+	V4L2_AUTO_FOCUS_AREA_SPOT		= 1,
+	V4L2_AUTO_FOCUS_AREA_RECTANGLE		= 2,
+};
+
+#define V4L2_CID_AUTO_FOCUS_FACE_PRIORITY	(V4L2_CID_CAMERA_CLASS_BASE+24)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.9.2

