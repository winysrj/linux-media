Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44352 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3FGL0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 07:26:03 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO000JGPT2W81A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Jun 2013 12:26:01 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	HyungJun Choi <hj210.choi@samsung.com>
Subject: [PATCH 2/2] V4L: Add V4L2_CID_AUTO_FOCUS_AREA control
Date: Fri, 07 Jun 2013 13:25:22 +0200
Message-id: <1370604322-15476-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1370604322-15476-1-git-send-email-a.hajda@samsung.com>
References: <1370604322-15476-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add control for automatic focus area selection.
This control determines the area of the frame that the camera uses
for automatic focus.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
    - V4L2_CID_AUTO_FOCUS_START also applies AF changes in case
    of continuous AF,
    - AF range and AF area are applied only by (re-)starting AF,
    - V4L2_AUTO_FOCUS_AREA_ALL replaced with V4L2_AUTO_FOCUS_AREA_AUTO
    with modified description,
    - indendation fixes,
    - enums V4L2_AUTO_FOCUS_AREA_* replaced by macros
---
 Documentation/DocBook/media/v4l/compat.xml   |  9 +++-
 Documentation/DocBook/media/v4l/controls.xml | 62 ++++++++++++++++++++++++----
 Documentation/DocBook/media/v4l/v4l2.xml     |  7 ++++
 drivers/media/v4l2-core/v4l2-ctrls.c         | 10 +++++
 include/uapi/linux/v4l2-controls.h           |  4 ++
 5 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index f43542a..d041573 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2455,8 +2455,9 @@ that used it. It was originally scheduled for removal in 2.6.35.
 	  <constant>V4L2_CID_3A_LOCK</constant>,
 	  <constant>V4L2_CID_AUTO_FOCUS_START</constant>,
 	  <constant>V4L2_CID_AUTO_FOCUS_STOP</constant>,
-	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant> and
-	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant>.
+	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>,
+	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant> and
+	  <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>.
 	  </para>
         </listitem>
       </orderedlist>
@@ -2629,6 +2630,10 @@ ioctls.</para>
         <listitem>
 	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
         </listitem>
+        <listitem>
+	  <para><link linkend="v4l2-auto-focus-area"><constant>
+	  V4L2_CID_AUTO_FOCUS_AREA</constant></link> control.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8d7a779..384d323 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3246,10 +3246,11 @@ is enabled is undefined, drivers should ignore such requests.</entry>
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_START</constant>&nbsp;</entry>
 	    <entry>button</entry>
-	  </row><row><entry spanname="descr">Starts single auto focus process.
-The effect of setting this control when <constant>V4L2_CID_FOCUS_AUTO</constant>
-is set to <constant>TRUE</constant> (1) is undefined, drivers should ignore
-such requests.</entry>
+	  </row><row><entry spanname="descr">Starts single autofocus process or
+	  restarts continuous autofocus with current settings. In case
+	  continuous autofocus is enabled the control is used to apply to the
+	  hardware changes of other autofocus controls and related selection
+	  rectangles.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
@@ -3308,8 +3309,13 @@ control value.</entry>
 	      <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant>&nbsp;</entry>
 	    <entry>enum&nbsp;v4l2_auto_focus_range</entry>
 	  </row>
-	  <row><entry spanname="descr">Determines auto focus distance range
-for which lens may be adjusted. </entry>
+	  <row><entry spanname="descr">Determines auto focus distance range for
+	  which lens may be adjusted.
+	  The change shall be applied to the hardware only by (re-)starting
+	  autofocus process (<constant>V4L2_CID_AUTO_FOCUS_START</constant>)
+	  or by starting continuous autofocus
+	  (<constant>V4L2_CID_FOCUS_AUTO</constant>).
+	  </entry>
 	  </row>
 	  <row>
 	    <entrytbl spanname="descr" cols="2">
@@ -3337,6 +3343,48 @@ use its minimum possible distance for auto focus.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-auto-focus-area">
+	    <entry spanname="id">
+	      <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_auto_focus_area</entry>
+	  </row>
+	  <row><entry spanname="descr">Determines the area of the frame that
+	  the camera uses for automatic focus. The corresponding coordinates of
+	  the focusing spot or rectangle can be specified using the selection
+	  API - &VIDIOC-SUBDEV-S-SELECTION; or &VIDIOC-S-SELECTION; ioctl.
+	  The change shall be applied to the hardware only by (re-)starting
+	  autofocus process (<constant>V4L2_CID_AUTO_FOCUS_START</constant>)
+	  or by starting continuous autofocus
+	  (<constant>V4L2_CID_FOCUS_AUTO</constant>).
+	  </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_AUTO</constant>&nbsp;</entry>
+		  <entry>The camera automatically selects the focus area.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>&nbsp;</entry>
+		  <entry>The auto focus region of interest is determined by the
+		  <constant>V4L2_SEL_TGT_AUTO_FOCUS</constant> selection
+                  rectangle.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION</constant>&nbsp;</entry>
+		  <entry>The auto focus region of interest is determined
+		  by an object (e.g. face) detection engine.</entry>
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
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
@@ -3976,7 +4024,7 @@ interface and may change in the future.</para>
 
           <table pgwide="1" frame="none" id="flash-control-id">
           <title>Flash Control IDs</title>
-    
+
           <tgroup cols="4">
     	<colspec colname="c1" colwidth="1*" />
     	<colspec colname="c2" colwidth="6*" />
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index bfc93cd..02c454a 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -141,6 +141,13 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.11</revnumber>
+	<date>2013-04-30</date>
+	<authorinitials>sn, ah</authorinitials>
+	<revremark>Added V4L2_CID_AUTO_FOCUS_AREA control.</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.10</revnumber>
 	<date>2013-03-25</date>
 	<authorinitials>hv</authorinitials>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ebb8e48..e2b3cd2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -237,6 +237,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Matrix",
 		NULL
 	};
+	static const char * const camera_auto_focus_area[] = {
+		"Auto",
+		"Rectangle",
+		"Object Detection",
+		NULL
+	};
 	static const char * const camera_auto_focus_range[] = {
 		"Auto",
 		"Normal",
@@ -498,6 +504,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_exposure_auto;
 	case V4L2_CID_EXPOSURE_METERING:
 		return camera_exposure_metering;
+	case V4L2_CID_AUTO_FOCUS_AREA:
+		return camera_auto_focus_area;
 	case V4L2_CID_AUTO_FOCUS_RANGE:
 		return camera_auto_focus_range;
 	case V4L2_CID_COLORFX:
@@ -734,6 +742,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_FOCUS_STOP:		return "Auto Focus, Stop";
 	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
 	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
+	case V4L2_CID_AUTO_FOCUS_AREA:		return "Auto Focus, Area";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -888,6 +897,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
 	case V4L2_CID_EXPOSURE_AUTO:
+	case V4L2_CID_AUTO_FOCUS_AREA:
 	case V4L2_CID_AUTO_FOCUS_RANGE:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 69bd5bb..3581e91 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -700,6 +700,10 @@ enum v4l2_auto_focus_range {
 	V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
 };
 
+#define V4L2_CID_AUTO_FOCUS_AREA		(V4L2_CID_CAMERA_CLASS_BASE+32)
+#define V4L2_AUTO_FOCUS_AREA_AUTO		0
+#define V4L2_AUTO_FOCUS_AREA_RECTANGLE		1
+#define V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION	2
 
 /* FM Modulator class control IDs */
 
-- 
1.8.1.2

