Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48485 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2CIKqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 05:46:34 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0M007XG5XKGX60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Mar 2012 10:46:32 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0M00K7I5XJJ6@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Mar 2012 10:46:32 +0000 (GMT)
Date: Fri, 09 Mar 2012 11:46:28 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] V4L: Improve the selection API documentation
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1331289988-13708-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the VIDIOC_G/S_SELECTION ioctls documentation more consistent
with the rest of media Docbook, use capital letters where necessary
and correct few minor errors.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/selection-api.xml  |    8 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  106 ++++++++++----------
 include/linux/videodev2.h                          |   30 +++---
 3 files changed, 76 insertions(+), 68 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index 2f0bdb4..b299e47 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -52,6 +52,10 @@ cropping and composing rectangles have the same size.</para>
 	  </textobject>
 	</mediaobject>
       </figure>
+
+For complete list of the available selection targets see table <xref
+linkend="v4l2-sel-target"/>
+
     </section>
 
   <section>
@@ -186,7 +190,7 @@ V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.</para>
 
    <section>
 
-     <title>Scaling control.</title>
+     <title>Scaling control</title>
 
 <para>An application can detect if scaling is performed by comparing the width
 and the height of rectangles obtained using <constant> V4L2_SEL_TGT_CROP_ACTIVE
@@ -200,7 +204,7 @@ the scaling ratios using these values.</para>
 
   <section>
 
-    <title>Comparison with old cropping API.</title>
+    <title>Comparison with old cropping API</title>
 
 <para>The selection API was introduced to cope with deficiencies of previous
 <link linkend="crop"> API </link>, that was designed to control simple capture
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index a9d36e0..bb04eff 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -58,43 +58,43 @@
 
     <para>The ioctls are used to query and configure selection rectangles.</para>
 
-<para> To query the cropping (composing) rectangle set <structfield>
-&v4l2-selection;::type </structfield> to the respective buffer type.  Do not
-use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
+<para> To query the cropping (composing) rectangle set &v4l2-selection;
+<structfield> type </structfield> field to the respective buffer type.
+Do not use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 </constant> instead of <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
 </constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
 <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
-setting <structfield> &v4l2-selection;::target </structfield> to value
-<constant> V4L2_SEL_TGT_CROP_ACTIVE </constant> (<constant>
+setting the value of &v4l2-selection; <structfield>target</structfield> field
+to <constant> V4L2_SEL_TGT_CROP_ACTIVE </constant> (<constant>
 V4L2_SEL_TGT_COMPOSE_ACTIVE </constant>).  Please refer to table <xref
 linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
-targets.  Fields <structfield> &v4l2-selection;::flags </structfield> and
-<structfield> &v4l2-selection;::reserved </structfield> are ignored and they
-must be filled with zeros.  The driver fills the rest of the structure or
+targets.  The <structfield>flags</structfield> and <structfield>reserved
+</structfield> fields of &v4l2-selection; are ignored and they must be filled
+with zeros.  The driver fills the rest of the structure or
 returns &EINVAL; if incorrect buffer type or target was used. If cropping
 (composing) is not supported then the active rectangle is not mutable and it is
-always equal to the bounds rectangle.  Finally, structure <structfield>
-&v4l2-selection;::r </structfield> is filled with the current cropping
+always equal to the bounds rectangle.  Finally, the &v4l2-rect;
+<structfield>r</structfield> rectangle is filled with the current cropping
 (composing) coordinates. The coordinates are expressed in driver-dependent
 units. The only exception are rectangles for images in raw formats, whose
 coordinates are always expressed in pixels.  </para>
 
-<para> To change the cropping (composing) rectangle set <structfield>
-&v4l2-selection;::type </structfield> to the respective buffer type.  Do not
+<para> To change the cropping (composing) rectangle set the &v4l2-selection;
+<structfield>type</structfield> field to the respective buffer type.  Do not
 use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 </constant> instead of <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
 </constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
 <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
-setting <structfield> &v4l2-selection;::target </structfield> to value
-<constant> V4L2_SEL_TGT_CROP_ACTIVE </constant> (<constant>
+setting the value of &v4l2-selection; <structfield>target</structfield> to
+<constant>V4L2_SEL_TGT_CROP_ACTIVE</constant> (<constant>
 V4L2_SEL_TGT_COMPOSE_ACTIVE </constant>). Please refer to table <xref
 linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
-targets.  Set desired active area into the field <structfield>
-&v4l2-selection;::r </structfield>.  Field <structfield>
-&v4l2-selection;::reserved </structfield> is ignored and must be filled with
-zeros.  The driver may adjust the rectangle coordinates. An application may
-introduce constraints to control rounding behaviour. Set the field
-<structfield> &v4l2-selection;::flags </structfield> to one of values:
+targets.  The &v4l2-rect; <structfield>r</structfield> rectangle need to be
+set to the desired active area. Field &v4l2-selection; <structfield> reserved
+</structfield> is ignored and must be filled with zeros.  The driver may adjust
+coordinates of the requested rectangle. An application may
+introduce constraints to control rounding behaviour. The &v4l2-selection;
+<structfield>flags</structfield> field must be set to one of the following:
 
 <itemizedlist>
   <listitem>
@@ -129,7 +129,7 @@ and vertical offset and sizes are chosen according to following priority:
 
 <orderedlist>
   <listitem>
-    <para>Satisfy constraints from <structfield>&v4l2-selection;::flags</structfield>.</para>
+    <para>Satisfy constraints from &v4l2-selection; <structfield>flags</structfield>.</para>
   </listitem>
   <listitem>
     <para>Adjust width, height, left, and top to hardware limits and alignments.</para>
@@ -145,7 +145,7 @@ and vertical offset and sizes are chosen according to following priority:
   </listitem>
 </orderedlist>
 
-On success the field <structfield> &v4l2-selection;::r </structfield> contains
+On success the &v4l2-rect; <structfield>r</structfield> field contains
 the adjusted rectangle. When the parameters are unsuitable the application may
 modify the cropping (composing) or image parameters and repeat the cycle until
 satisfactory parameters have been negotiated. If constraints flags have to be
@@ -162,38 +162,38 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	<tbody valign="top">
 	  <row>
             <entry><constant>V4L2_SEL_TGT_CROP_ACTIVE</constant></entry>
-            <entry>0</entry>
-            <entry>area that is currently cropped by hardware</entry>
+            <entry>0x0000</entry>
+            <entry>The area that is currently cropped by hardware.</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_CROP_DEFAULT</constant></entry>
-            <entry>1</entry>
-            <entry>suggested cropping rectangle that covers the "whole picture"</entry>
+            <entry>0x0001</entry>
+            <entry>Suggested cropping rectangle that covers the "whole picture".</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_CROP_BOUNDS</constant></entry>
-            <entry>2</entry>
-            <entry>limits for the cropping rectangle</entry>
+            <entry>0x0002</entry>
+            <entry>Limits for the cropping rectangle.</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
-            <entry>256</entry>
-            <entry>area to which data are composed by hardware</entry>
+            <entry>0x0100</entry>
+            <entry>The area to which data is composed by hardware.</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant></entry>
-            <entry>257</entry>
-            <entry>suggested composing rectangle that covers the "whole picture"</entry>
+            <entry>0x0101</entry>
+            <entry>Suggested composing rectangle that covers the "whole picture".</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
-            <entry>258</entry>
-            <entry>limits for the composing rectangle</entry>
+            <entry>0x0102</entry>
+            <entry>Limits for the composing rectangle.</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant></entry>
-            <entry>259</entry>
-            <entry>the active area and all padding pixels that are inserted or modified by the hardware</entry>
+            <entry>0x0103</entry>
+            <entry>The active area and all padding pixels that are inserted or modified by hardware.</entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -209,12 +209,14 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	  <row>
             <entry><constant>V4L2_SEL_FLAG_GE</constant></entry>
             <entry>0x00000001</entry>
-            <entry>indicate that adjusted rectangle must contain a rectangle from <structfield>&v4l2-selection;::r</structfield></entry>
+            <entry>Indicates that the adjusted rectangle must contain the original
+	    &v4l2-selection; <structfield>r</structfield> rectangle.</entry>
 	  </row>
 	  <row>
             <entry><constant>V4L2_SEL_FLAG_LE</constant></entry>
             <entry>0x00000002</entry>
-            <entry>indicate that adjusted rectangle must be inside a rectangle from <structfield>&v4l2-selection;::r</structfield></entry>
+            <entry>Indicates that the adjusted rectangle must be inside the original
+	    &v4l2-rect; <structfield>r</structfield> rectangle.</entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -245,27 +247,29 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>type</structfield></entry>
-	    <entry>Type of the buffer (from &v4l2-buf-type;)</entry>
+	    <entry>Type of the buffer (from &v4l2-buf-type;).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>target</structfield></entry>
-            <entry>used to select between <link linkend="v4l2-sel-target"> cropping and composing rectangles </link></entry>
+            <entry>Used to select between <link linkend="v4l2-sel-target"> cropping
+	    and composing rectangles</link>.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>flags</structfield></entry>
-            <entry>control over coordinates adjustments, refer to <link linkend="v4l2-sel-flags">selection flags</link></entry>
+            <entry>Flags controlling the selection rectangle adjustments, refer to
+	    <link linkend="v4l2-sel-flags">selection flags</link>.</entry>
 	  </row>
 	  <row>
 	    <entry>&v4l2-rect;</entry>
 	    <entry><structfield>r</structfield></entry>
-	    <entry>selection rectangle</entry>
+	    <entry>The selection rectangle.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved[9]</structfield></entry>
-	    <entry>Reserved fields for future use</entry>
+	    <entry>Reserved fields for future use.</entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -278,24 +282,24 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The buffer <structfield> &v4l2-selection;::type </structfield>
-or <structfield> &v4l2-selection;::target </structfield> is not supported, or
-the <structfield> &v4l2-selection;::flags </structfield> are invalid.</para>
+	  <para>Given buffer type <structfield>type</structfield> or
+the selection target <structfield>target</structfield> is not supported,
+or the <structfield>flags</structfield> argument is not valid.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
 	<term><errorcode>ERANGE</errorcode></term>
 	<listitem>
-	  <para>it is not possible to adjust a rectangle <structfield>
-&v4l2-selection;::r </structfield> that satisfies all contraints from
-<structfield> &v4l2-selection;::flags </structfield>.</para>
+	  <para>It is not possible to adjust &v4l2-rect; <structfield>
+r</structfield> rectangle to satisfy all contraints given in the
+<structfield>flags</structfield> argument.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
 	<term><errorcode>EBUSY</errorcode></term>
 	<listitem>
-	  <para>it is not possible to apply change of selection rectangle at the moment.
-Usually because streaming is in progress.</para>
+	  <para>It is not possible to apply change of the selection rectangle
+at the moment. Usually because streaming is in progress.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3fab6ca..c9c9a46 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -762,20 +762,20 @@ struct v4l2_crop {
 
 /* Selection targets */
 
-/* current cropping area */
-#define V4L2_SEL_TGT_CROP_ACTIVE	0
-/* default cropping area */
-#define V4L2_SEL_TGT_CROP_DEFAULT	1
-/* cropping bounds */
-#define V4L2_SEL_TGT_CROP_BOUNDS	2
-/* current composing area */
-#define V4L2_SEL_TGT_COMPOSE_ACTIVE	256
-/* default composing area */
-#define V4L2_SEL_TGT_COMPOSE_DEFAULT	257
-/* composing bounds */
-#define V4L2_SEL_TGT_COMPOSE_BOUNDS	258
-/* current composing area plus all padding pixels */
-#define V4L2_SEL_TGT_COMPOSE_PADDED	259
+/* Current cropping area */
+#define V4L2_SEL_TGT_CROP_ACTIVE	0x0000
+/* Default cropping area */
+#define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
+/* Cropping bounds */
+#define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
+/* Current composing area */
+#define V4L2_SEL_TGT_COMPOSE_ACTIVE	0x0100
+/* Default composing area */
+#define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
+/* Composing bounds */
+#define V4L2_SEL_TGT_COMPOSE_BOUNDS	0x0102
+/* Current composing area plus all padding pixels */
+#define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
 
 /**
  * struct v4l2_selection - selection info
@@ -785,7 +785,7 @@ struct v4l2_crop {
  * @r:		coordinates of selection window
  * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
  *
- * Hardware may use multiple helper window to process a video stream.
+ * Hardware may use multiple helper windows to process a video stream.
  * The structure is used to exchange this selection areas between
  * an application and a driver.
  */
-- 
1.7.9

