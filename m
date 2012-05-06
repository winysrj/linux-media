Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46828 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2EFS6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 14:58:55 -0400
Received: by wibhj6 with SMTP id hj6so2820826wib.1
        for <linux-media@vger.kernel.org>; Sun, 06 May 2012 11:58:54 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v5 12/12] V4L: Add camera auto focus controls
Date: Sun,  6 May 2012 20:58:45 +0200
Message-Id: <1336330725-10318-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1336156337-10935-13-git-send-email-s.nawrocki@samsung.com>
References: <1336156337-10935-13-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add following auto focus controls:

 - V4L2_CID_AUTO_FOCUS_START - single-shot auto focus start
 - V4L2_CID_AUTO_FOCUS_STOP -  single-shot auto focus stop
 - V4L2_CID_AUTO_FOCUS_STATUS - automatic focus status
 - V4L2_CID_AUTO_FOCUS_AREA - automatic focus area selection
 - V4L2_CID_AUTO_FOCUS_RANGE - automatic focus scan range selection

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Chnages since v4:
 - V4L2_CID_AUTO_FOCUS_RANGE marked as experimental and done minor
   changes at the description of this control;

 Documentation/DocBook/media/v4l/compat.xml   |   20 ++++
 Documentation/DocBook/media/v4l/controls.xml |  151 +++++++++++++++++++++++++-
 Documentation/DocBook/media/v4l/v4l2.xml     |    9 ++-
 drivers/media/video/v4l2-ctrls.c             |   31 +++++-
 include/linux/videodev2.h                    |   25 +++++
 5 files changed, 232 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index d9bd3b1..be4a8c2 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2435,6 +2435,22 @@ details.</para>
         <listitem>
 	  <para> Added <constant>V4L2_CID_COLORFX_CBCR</constant> control.</para>
         </listitem>
+        <listitem>
+	  <para> Added camera controls <constant>V4L2_CID_AUTO_EXPOSURE_BIAS</constant>,
+	  <constant>V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE</constant>,
+	  <constant>V4L2_CID_IMAGE_STABILIZATION</constant>,
+	  <constant>V4L2_CID_ISO_SENSITIVITY</constant>,
+	  <constant>V4L2_CID_ISO_SENSITIVITY_AUTO</constant>,
+	  <constant>V4L2_CID_EXPOSURE_METERING</constant>,
+	  <constant>V4L2_CID_SCENE_MODE</constant>,
+	  <constant>V4L2_CID_3A_LOCK</constant>,
+	  <constant>V4L2_CID_AUTO_FOCUS_START</constant>,
+	  <constant>V4L2_CID_AUTO_FOCUS_STOP</constant>,
+	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>,
+	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant> and
+	  <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>.
+	  </para>
+        </listitem>
       </orderedlist>
     </section>

@@ -2559,6 +2575,10 @@ ioctls.</para>
 	  <para>Importing DMABUF file descriptors as a new IO method described
 	  in <xref linkend="dmabuf" />.</para>
         </listitem>
+        <listitem>
+	  <para><link linkend="v4l2-auto-focus-area"><constant>
+	  V4L2_CID_AUTO_FOCUS_AREA</constant></link> control.</para>
+        </listitem>
       </itemizedlist>
     </section>

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 054cdba..b7b5c0c 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2976,13 +2976,160 @@ negative values towards infinity. This is a write-only control.</entry>
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
+		  <entry>Automatic focus is not active.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_BUSY</constant>&nbsp;</entry>
+		  <entry>Automatic focusing is in progress.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_REACHED</constant>&nbsp;</entry>
+		  <entry>Focus has been reached.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_LOST</constant>&nbsp;</entry>
+		  <entry>Focus has been lost.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_FAILED</constant>&nbsp;</entry>
+		  <entry>Automatic focus has failed, the driver will not
+		  transition from this state until another action is
+		  performed by an  application.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row id="v4l2-auto-focus-range">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_auto_focus_range</entry>
+	  </row>
+	  <row><entry spanname="descr">Determines auto focus distance range
+for which lens may be adjusted. </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_AUTO</constant>&nbsp;</entry>
+		  <entry>The camera automatically selects the focus range.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_NORMAL</constant>&nbsp;</entry>
+		  <entry>Normal distance range, limited for best automatic focus
+performance.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_MACRO</constant>&nbsp;</entry>
+		  <entry>Macro (close-up) auto focus. The camera will
+use its minimum possible distance for auto focus.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_INFINITY</constant>&nbsp;</entry>
+		  <entry>The lens is set to focus on an object at infinite distance.</entry>
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
+trigger again a one shot auto focus with same coordinates applications should
+use the <constant>V4L2_CID_AUTO_FOCUS_START </constant> control. Or alternatively
+invoke a &VIDIOC-SUBDEV-S-SELECTION; or a &VIDIOC-S-SELECTION; ioctl again.
+In the latter case the new pixel coordinates are applied to hardware only when
+the focus area control was set to <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant>
+or <constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>.</entry>
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
+	  <row><entry spanname="descr">
+	    This is an <link linkend="experimental">experimental</link>
+control and may change in the future.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
 	  </row><row><entry spanname="descr">Specify the objective lens
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 63242e2..e24ac68 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -140,11 +140,18 @@ applications. -->

       <revision>
 	<revnumber>3.5</revnumber>
-	<date>2012-04-02</date>
+	<date>2012-05-07</date>
 	<authorinitials>sa, sn</authorinitials>
 	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU and V4L2 subdev
 	    selections API. Improved the description of V4L2_CID_COLORFX
 	    control, added V4L2_CID_COLORFX_CBCR control.
+	    Added camera controls V4L2_CID_AUTO_EXPOSURE_BIAS,
+	    V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE, V4L2_CID_IMAGE_STABILIZATION,
+	    V4L2_CID_ISO_SENSITIVITY, V4L2_CID_ISO_SENSITIVITY_AUTO,
+	    V4L2_CID_EXPOSURE_METERING, V4L2_CID_SCENE_MODE,
+	    V4L2_CID_3A_LOCK, V4L2_CID_AUTO_FOCUS_START,
+	    V4L2_CID_AUTO_FOCUS_STOP, V4L2_CID_AUTO_FOCUS_STATUS,
+	    V4L2_CID_AUTO_FOCUS_RANGE and V4L2_CID_AUTO_FOCUS_AREA.
 	</revremark>
       </revision>

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8f14aba..d306dae 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -236,6 +236,20 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
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
+	static const char * const camera_auto_focus_range[] = {
+		"Auto",
+		"Normal",
+		"Macro",
+		"Infinity",
+		NULL
+	};
 	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
@@ -459,6 +473,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_exposure_auto;
 	case V4L2_CID_EXPOSURE_METERING:
 		return camera_exposure_metering;
+	case V4L2_CID_AUTO_FOCUS_AREA:
+		return camera_auto_focus_area;
+	case V4L2_CID_AUTO_FOCUS_RANGE:
+		return camera_auto_focus_range;
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
@@ -646,7 +664,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
 	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
 	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
-	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
+	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic Continuous";
 	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
 	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
 	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
@@ -662,6 +680,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 	case V4L2_CID_SCENE_MODE:		return "Scene Mode";
 	case V4L2_CID_3A_LOCK:			return "3A Lock";
+	case V4L2_CID_AUTO_FOCUS_START:		return "Auto Focus, Start";
+	case V4L2_CID_AUTO_FOCUS_STOP:		return "Auto Focus, Stop";
+	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
+	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
+	case V4L2_CID_AUTO_FOCUS_AREA:		return "Auto Focus, Area";

 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -763,6 +786,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
 	case V4L2_CID_FLASH_STROBE_STOP:
+	case V4L2_CID_AUTO_FOCUS_START:
+	case V4L2_CID_AUTO_FOCUS_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		*min = *max = *step = *def = 0;
@@ -786,6 +811,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_AUTO_FOCUS_AREA:
+	case V4L2_CID_AUTO_FOCUS_RANGE:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
 	case V4L2_CID_TUNE_PREEMPHASIS:
@@ -835,6 +862,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_FAULT:
 	case V4L2_CID_JPEG_ACTIVE_MARKER:
 	case V4L2_CID_3A_LOCK:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
@@ -893,6 +921,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 		break;
 	case V4L2_CID_FLASH_STROBE_STATUS:
+	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_FLASH_READY:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 793345d..dcc5243 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1768,6 +1768,31 @@ enum v4l2_scene_mode {
 #define V4L2_LOCK_WHITE_BALANCE			(1 << 1)
 #define V4L2_LOCK_FOCUS				(1 << 2)

+#define V4L2_CID_AUTO_FOCUS_START		(V4L2_CID_CAMERA_CLASS_BASE+28)
+#define V4L2_CID_AUTO_FOCUS_STOP		(V4L2_CID_CAMERA_CLASS_BASE+29)
+#define V4L2_CID_AUTO_FOCUS_STATUS		(V4L2_CID_CAMERA_CLASS_BASE+30)
+#define V4L2_AUTO_FOCUS_STATUS_IDLE		(0 << 0)
+#define V4L2_AUTO_FOCUS_STATUS_BUSY		(1 << 0)
+#define V4L2_AUTO_FOCUS_STATUS_REACHED		(1 << 1)
+#define V4L2_AUTO_FOCUS_STATUS_LOST		(1 << 2)
+#define V4L2_AUTO_FOCUS_STATUS_FAILED		(1 << 3)
+
+#define V4L2_CID_AUTO_FOCUS_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+31)
+enum v4l2_auto_focus_range {
+	V4L2_AUTO_FOCUS_RANGE_AUTO		= 0,
+	V4L2_AUTO_FOCUS_RANGE_NORMAL		= 1,
+	V4L2_AUTO_FOCUS_RANGE_MACRO		= 2,
+	V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
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
1.7.4.1

