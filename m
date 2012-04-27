Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63374 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760234Ab2D0OXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M35009NK6NLJP30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M35001WS6NALZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:34 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 12/14] V4L: Add camera auto focus controls
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-13-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add following auto focus controls:

 - V4L2_CID_AUTO_FOCUS_START - single-shot auto focus start
 - V4L2_CID_AUTO_FOCUS_STOP -  single-shot auto focus stop
 - V4L2_CID_AUTO_FOCUS_STATUS - automatic focus status
 - V4L2_CID_AUTO_FOCUS_AREA - automatic focus area selection
 - V4L2_CID_AUTO_FOCUS_DISTANCE - automatic focus scan range selection

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |  140 +++++++++++++++++++++++++-
 drivers/media/video/v4l2-ctrls.c             |   26 ++++-
 include/linux/videodev2.h                    |   23 +++++
 3 files changed, 186 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 51509f4..e974a03 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2902,13 +2902,149 @@ negative values towards infinity. This is a write-only control.</entry>
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
+	  </row><row><entry spanname="descr">Aborts automatic focusing
+started with <constant>V4L2_CID_AUTO_FOCUS_START</constant> control. It is
+effective only when the continuous autofocus is disabled, that is when
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
+		  <entry>Automatic focus has failed, the driver will not transition
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
+possible distance.</entry>
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
+the camera uses for automatic focus. The corresponding coordinates of the
+focusing spot or rectangle can be specified and queried using the selection API.
+To change the auto focus region of interest applications first select required
+mode of this control and then set the rectangle or spot coordinates by means
+of the &VIDIOC-SUBDEV-S-SELECTION; or &VIDIOC-S-SELECTION; ioctl. In order to
+trigger again an auto focus process with same coordinates applications should
+use the <constant>V4L2_CID_AUTO_FOCUS_START </constant> control. Or alternatively
+invoke a &VIDIOC-SUBDEV-S-SELECTION; or a &VIDIOC-S-SELECTION; ioctl again.
+In the latter case the new pixel coordinates are applied to hardware only when
+the focus area control is set to a value other than
+<constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>&nbsp;</entry>
+		  <entry>Normal auto focus, the focusing area extends over the
+entire frame.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant>&nbsp;</entry>
+		  <entry>Automatic focus on a spot within the frame at position
+specified by the <constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> or
+<constant>V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> selection. When these
+selections are not supported by driver the default spot's position is center of
+the frame.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>&nbsp;</entry>
+		  <entry>The auto focus area is determined by the <constant>
+V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> or <constant>
+V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> selection rectangle.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_FACE_DETECTION</constant>&nbsp;</entry>
+		  <entry>The camera automatically focuses on a detected face
+area.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
 	  </row><row><entry spanname="descr">Specify the objective lens
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index d45f00c..da9272c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -236,6 +236,19 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Spot",
 		NULL
 	};
+	static const char * const camera_auto_focus_area[] = {
+		"All",
+		"Spot",
+		"Rectangle",
+		"Face Detection",
+		NULL
+	};
+	static const char * const camera_auto_focus_distance[] = {
+		"Normal",
+		"Macro",
+		"Infinity",
+		NULL
+	};
 	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
@@ -656,7 +669,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
 	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
 	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
-	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
+	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic Continuous";
 	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
 	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
 	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
@@ -672,6 +685,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 	case V4L2_CID_SCENE_MODE:		return "Scene Mode";
 	case V4L2_CID_3A_LOCK:			return "3A Lock";
+	case V4L2_CID_AUTO_FOCUS_START:		return "Auto Focus, Start";
+	case V4L2_CID_AUTO_FOCUS_STOP:		return "Auto Focus, Stop";
+	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:	return "Auto Focus, Distance";
+	case V4L2_CID_AUTO_FOCUS_AREA:		return "Auto Focus, Area";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -771,6 +789,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
 	case V4L2_CID_FLASH_STROBE_STOP:
+	case V4L2_CID_AUTO_FOCUS_START:
+	case V4L2_CID_AUTO_FOCUS_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		*min = *max = *step = *def = 0;
@@ -794,6 +814,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_AUTO_FOCUS_AREA:
+	case V4L2_CID_AUTO_FOCUS_DISTANCE:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
 	case V4L2_CID_TUNE_PREEMPHASIS:
@@ -845,6 +867,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_FAULT:
 	case V4L2_CID_JPEG_ACTIVE_MARKER:
 	case V4L2_CID_3A_LOCK:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
@@ -904,6 +927,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
 	case V4L2_CID_FLASH_STROBE_STATUS:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_FLASH_READY:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 29b84ae..3b7e995 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1762,6 +1762,29 @@ enum v4l2_scene_mode {
 #define V4L2_3A_LOCK_WHITE_BALANCE		(1 << 1)
 #define V4L2_3A_LOCK_FOCUS			(1 << 2)
 
+#define V4L2_CID_AUTO_FOCUS_START		(V4L2_CID_CAMERA_CLASS_BASE+28)
+#define V4L2_CID_AUTO_FOCUS_STOP		(V4L2_CID_CAMERA_CLASS_BASE+29)
+#define V4L2_CID_AUTO_FOCUS_STATUS		(V4L2_CID_CAMERA_CLASS_BASE+30)
+#define V4L2_AUTO_FOCUS_STATUS_IDLE		(0 << 0)
+#define V4L2_AUTO_FOCUS_STATUS_BUSY		(1 << 0)
+#define V4L2_AUTO_FOCUS_STATUS_SUCCESS		(1 << 1)
+#define V4L2_AUTO_FOCUS_STATUS_FAIL		(1 << 2)
+
+#define V4L2_CID_AUTO_FOCUS_DISTANCE		(V4L2_CID_CAMERA_CLASS_BASE+31)
+enum v4l2_auto_focus_distance {
+	V4L2_AUTO_FOCUS_DISTANCE_NORMAL		= 0,
+	V4L2_AUTO_FOCUS_DISTANCE_MACRO		= 1,
+	V4L2_AUTO_FOCUS_DISTANCE_INFINITY	= 2,
+};
+
+#define V4L2_CID_AUTO_FOCUS_AREA		(V4L2_CID_CAMERA_CLASS_BASE+32)
+enum v4l2_auto_focus_area {
+	V4L2_AUTO_FOCUS_AREA_ALL		= 0,
+	V4L2_AUTO_FOCUS_AREA_SPOT		= 1,
+	V4L2_AUTO_FOCUS_AREA_RECTANGLE		= 2,
+	V4L2_AUTO_FOCUS_AREA_FACE_DETECTION	= 3,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

