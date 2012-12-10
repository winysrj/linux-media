Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31574 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2LJNnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 08:43:53 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MET00B4GI832T80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Dec 2012 13:46:27 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MET00JXCI4V1O40@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Dec 2012 13:43:50 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 1/2] V4L: Add auto focus selection targets
Date: Mon, 10 Dec 2012 14:43:38 +0100
Message-id: <1355147019-25375-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
References: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

The camera automatic focus algorithms may require setting up
a spot or rectangle coordinates.

The automatic focus selection targets are introduced in order
to allow applications to query and set such coordinates. Those
selections are intended to be used together with the automatic
focus controls available in the camera control class.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/selection-api.xml  |   32 ++++++++++++++++-
 .../DocBook/media/v4l/selections-common.xml        |   37 ++++++++++++++++++++
 .../media/v4l/vidioc-subdev-g-selection.xml        |    4 +--
 include/uapi/linux/v4l2-common.h                   |    5 +++
 4 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index 4c238ce..8caf67b 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -1,6 +1,6 @@
 <section id="selection-api">
 
-  <title>Experimental API for cropping, composing and scaling</title>
+  <title>Experimental selections API</title>
 
       <note>
 	<title>Experimental</title>
@@ -9,6 +9,10 @@
 interface and may change in the future.</para>
       </note>
 
+ <section>
+
+ <title>Image cropping, composing and scaling</title>
+
   <section>
     <title>Introduction</title>
 
@@ -321,5 +325,31 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
       </example>
 
    </section>
+ </section>
+
+ <section>
+     <title>Automatic focus regions of interest</title>
+
+<para>The camera automatic focus algorithms may require configuration of
+regions of interest in form of rectangle or spot coordinates. The automatic
+focus selection targets allow applications to query and set such coordinates.
+Those selections are intended to be used together with the
+<constant>V4L2_CID_AUTO_FOCUS_AREA</constant> <link linkend="camera-controls">
+camera class</link> control. The <constant>V4L2_SEL_TGT_AUTO_FOCUS</constant>
+target is used for querying or setting actual spot or rectangle coordinates,
+while <constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant> target determines
+bounds for a single spot or rectangle.
+These selections are only effective when the <constant>V4L2_CID_AUTO_FOCUS_AREA
+</constant>control is set to
+<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>. The new coordinates shall
+be accepted and applied to hardware when the focus area control value is
+changed and also during a &VIDIOC-S-SELECTION; ioctl call, only when the focus
+area control is already set to required value.</para>
+
+<para>When the <structfield>width</structfield> and
+<structfield>height</structfield> of the selection rectangle are set to 0 the
+selection determines spot coordinates, rather than a rectangle.</para>
+
+ </section>
 
 </section>
diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
index 7502f78..9f0c477 100644
--- a/Documentation/DocBook/media/v4l/selections-common.xml
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -93,6 +93,22 @@
 	    <entry>Yes</entry>
 	    <entry>No</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS</constant></entry>
+	    <entry>0x1001</entry>
+	    <entry>Actual automatic focus rectangle.</entry>
+	    <entry>Yes</entry>
+	    <entry>Yes</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant></entry>
+	    <entry>0x1002</entry>
+	    <entry>Bounds of the automatic focus region of interest. All valid
+	    automatic focus rectangles fit inside the automatic focus bounds
+	    rectangle.</entry>
+	    <entry>Yes</entry>
+	    <entry>Yes</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -158,7 +174,28 @@
 	</tbody>
       </tgroup>
     </table>
+  </section>
+
+  <section>
+      <title>Automatic focus regions of interest</title>
+
+      <para>The camera automatic focus algorithms may require configuration
+      of a region or multiple regions of interest in form of rectangle or spot
+      coordinates.</para>
+
+      <para>A single rectangle of interest is represented in &v4l2-rect;
+      by the coordinates of the top left corner and the rectangle size. Both
+      the coordinates and sizes are expressed in pixels. When the <structfield>
+      width</structfield> and <structfield>height</structfield> fields of
+      &v4l2-rect; are set to 0 the selection determines spot coordinates,
+      rather than a rectangle.</para>
 
+      <para>Auto focus rectangles are reset to their default values when the
+      output image format is modified. Drivers should use the output image size
+      as the auto focus rectangle default value, but hardware requirements may
+      prevent this.
+      </para>
+      <para>The auto focus selections on input pads are not defined.</para>
   </section>
 
 </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index 1ba9e99..95e759f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -57,8 +57,8 @@
 
     <para>The selections are used to configure various image
     processing functionality performed by the subdevs which affect the
-    image size. This currently includes cropping, scaling and
-    composition.</para>
+    image size. This currently includes cropping, scaling, composition
+    and automatic focus regions of interest.</para>
 
     <para>The selection API replaces <link
     linkend="vidioc-subdev-g-crop">the old subdev crop API</link>. All
diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 4f0667e..0372ccb 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -50,6 +50,11 @@
 /* Current composing area plus all padding pixels */
 #define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
 
+/* Auto focus region of interest */
+#define V4L2_SEL_TGT_AUTO_FOCUS		0x0200
+/* Auto focus region bounds */
+#define V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS	0x0201
+
 /* Backward compatibility target definitions --- to be removed. */
 #define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
 #define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
-- 
1.7.10.4

