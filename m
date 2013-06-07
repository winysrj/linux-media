Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62953 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3FGLZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 07:25:55 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO000L8LT2XZ5A0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Jun 2013 12:25:53 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	HyungJun Choi <hj210.choi@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/2] V4L: Add auto focus selection targets
Date: Fri, 07 Jun 2013 13:25:21 +0200
Message-id: <1370604322-15476-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1370604322-15476-1-git-send-email-a.hajda@samsung.com>
References: <1370604322-15476-1-git-send-email-a.hajda@samsung.com>
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
v2:
    - corrected description of the selection API,
    - selection changes are applied only by (re-)starting AF,
    - changed V4L2_SEL_TGT_AUTO_FOCUS* to 0x100*
---
 Documentation/DocBook/media/v4l/selection-api.xml  | 31 +++++++++++++++++-
 .../DocBook/media/v4l/selections-common.xml        | 37 ++++++++++++++++++++++
 .../media/v4l/vidioc-subdev-g-selection.xml        |  9 +++---
 include/uapi/linux/v4l2-common.h                   |  5 +++
 4 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index 4c238ce..9c19a03 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -1,6 +1,6 @@
 <section id="selection-api">
 
-  <title>Experimental API for cropping, composing and scaling</title>
+  <title>Selection API</title>
 
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
 
@@ -321,5 +325,30 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
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
+bounds for a single spot or rectangle. These selections are only effective when
+the <constant>V4L2_CID_AUTO_FOCUS_AREA</constant> control is set to
+<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>. The new coordinates shall
+be applied to the hardware only by (re-)starting autofocus process
+(<constant>V4L2_CID_AUTO_FOCUS_START</constant>) or starting continuous
+autofocus (<constant>V4L2_CID_FOCUS_AUTO</constant>). </para>
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
index 1ba9e99..efbdb3f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -55,10 +55,11 @@
       interface and may change in the future.</para>
     </note>
 
-    <para>The selections are used to configure various image
-    processing functionality performed by the subdevs which affect the
-    image size. This currently includes cropping, scaling and
-    composition.</para>
+    <para>The selections are used to configure various image processing
+    functionality performed by the subdevs which requires passing image
+    area coordinates between a driver and an application.
+    This currently includes cropping, scaling, composition
+    and automatic focus regions of interest.</para>
 
     <para>The selection API replaces <link
     linkend="vidioc-subdev-g-crop">the old subdev crop API</link>. All
diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 4f0667e..6db81a2 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -50,6 +50,11 @@
 /* Current composing area plus all padding pixels */
 #define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
 
+/* Auto focus region of interest */
+#define V4L2_SEL_TGT_AUTO_FOCUS		0x1001
+/* Auto focus region bounds */
+#define V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS	0x1002
+
 /* Backward compatibility target definitions --- to be removed. */
 #define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
 #define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
-- 
1.8.1.2

