Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:20238 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab2FMWms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:42:48 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	snjw23@gmail.com, t.stanislaws@samsung.com
Subject: [PATCH v3 4/6] v4l: Common documentation for selection targets
Date: Thu, 14 Jun 2012 01:39:39 +0300
Message-Id: <1339627181-8563-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FD91697.9050100@iki.fi>
References: <4FD91697.9050100@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both V4L2 and V4L2 subdev interface have very similar selection APIs with
differences foremost related to in-memory and media bus formats. However,
the selection targets are the same for both. Most targets are and in the
future will likely continue to be more the same than with any differences.
Thus it makes sense to unify the documentation of the targets.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml         |    9 +-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   10 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |    6 +-
 .../DocBook/media/v4l/selections-common.xml        |   93 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    5 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   54 +----------
 .../media/v4l/vidioc-subdev-g-selection.xml        |   34 +-------
 7 files changed, 119 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/selections-common.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index ea42ef8..162a0ba 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2377,10 +2377,11 @@ that used it. It was originally scheduled for removal in 2.6.35.
 	  <para>V4L2_CTRL_FLAG_VOLATILE was added to signal volatile controls to userspace.</para>
         </listitem>
         <listitem>
-	  <para>Add selection API for extended control over cropping and
-composing. Does not affect the compatibility of current drivers and
-applications.  See <link linkend="selection-api"> selection API </link> for
-details.</para>
+	  <para>Add selection API for extended control over cropping
+	  and composing. Does not affect the compatibility of current
+	  drivers and applications. See <link
+	  linkend="selection-api"> selection API </link> for
+	  details.</para>
         </listitem>
       </orderedlist>
     </section>
diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index ac715dd..76c4307 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -276,7 +276,7 @@
       </para>
     </section>
 
-    <section>
+    <section id="v4l2-subdev-selections">
       <title>Selections: cropping, scaling and composition</title>
 
       <para>Many sub-devices support cropping frames on their input or output
@@ -289,9 +289,9 @@
       &v4l2-rect; by the coordinates of the top left corner and the rectangle
       size. Both the coordinates and sizes are expressed in pixels.</para>
 
-      <para>As for pad formats, drivers store try and active rectangles for
-      the selection targets <xref
-      linkend="v4l2-subdev-selection-targets">.</xref></para>
+      <para>As for pad formats, drivers store try and active
+      rectangles for the selection targets <xref
+      linkend="v4l2-selections-common">.</xref></para>
 
       <para>On sink pads, cropping is applied relative to the
       current pad format. The pad format represents the image size as
@@ -308,7 +308,7 @@
       <para>Scaling support is optional. When supported by a subdev,
       the crop rectangle on the subdev's sink pad is scaled to the
       size configured using the &VIDIOC-SUBDEV-S-SELECTION; IOCTL
-      using <constant>V4L2_SUBDEV_SEL_TGT_COMPOSE</constant>
+      using <constant>V4L2_SEL_TGT_COMPOSE</constant>
       selection target on the same pad. If the subdev supports scaling
       but not composing, the top and left values are not used and must
       always be set to zero.</para>
diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index ac013e5..24dec10 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -53,11 +53,11 @@ cropping and composing rectangles have the same size.</para>
 	</mediaobject>
       </figure>
 
-For complete list of the available selection targets see table <xref
-linkend="v4l2-sel-target"/>
-
     </section>
 
+    See <xref linkend="v4l2-selection-targets-table" /> for more
+    information.
+
   <section>
 
   <title>Configuration</title>
diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
new file mode 100644
index 0000000..eef2b43
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -0,0 +1,93 @@
+<section id="v4l2-selections-common">
+
+  <title>Selection targets</title>
+
+  <para>While the <link linkend="selection-api">V4L2 selection
+  API</link> and <link linkend="v4l2-subdev-selections">V4L2 subdev
+  selection APIs</link> are very similar, there's one fundamental
+  difference between the two. On sub-device API, the selection
+  rectangle is refers to the media bus format, and is bound to a
+  sub-device and a pad. On the V4L2 interface the selection rectangles
+  refer to the in-memory pixel format and a video device's buffer
+  queue.</para>
+
+  <para>The meaning of the selection targets may thus be affected on
+  which of the two interfaces they are used.</para>
+
+  <table pgwide="1" frame="none" id="v4l2-selection-targets-table">
+  <title>Selection target definitions</title>
+    <tgroup cols="4">
+      <colspec colname="c1" />
+      <colspec colname="c2" />
+      <colspec colname="c3" />
+      <colspec colname="c4" />
+      <colspec colname="c5" />
+      &cs-def;
+      <thead>
+	<row rowsep="1">
+	  <entry align="left">Target name</entry>
+	  <entry align="left">id</entry>
+	  <entry align="left">Definition</entry>
+	  <entry align="left">Valid for V4L2</entry>
+	  <entry align="left">Valid for V4L2 subdev</entry>
+	</row>
+      </thead>
+      <tbody valign="top">
+	<row>
+	  <entry><constant>V4L2_SEL_TGT_CROP</constant></entry>
+	  <entry>0x0000</entry>
+	  <entry>Crop rectangle. Defines the cropped area.</entry>
+	  <entry>X</entry>
+	  <entry>X</entry>
+	</row>
+	<row>
+          <entry><constant>V4L2_SEL_TGT_CROP_DEFAULT</constant></entry>
+          <entry>0x0001</entry>
+          <entry>Suggested cropping rectangle that covers the "whole picture".</entry>
+	  <entry>X</entry>
+	  <entry>O</entry>
+	</row>
+	<row>
+	  <entry><constant>V4L2_SEL_TGT_CROP_BOUNDS</constant></entry>
+	  <entry>0x0002</entry>
+	  <entry>Bounds of the crop rectangle. All valid crop
+	  rectangles fit inside the crop bounds rectangle.
+	  </entry>
+	  <entry>X</entry>
+	  <entry>X</entry>
+	</row>
+	<row>
+	  <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
+	  <entry>0x0100</entry>
+	  <entry>Compose rectangle. Used to configure scaling
+	  and composition.</entry>
+	  <entry>X</entry>
+	  <entry>X</entry>
+	</row>
+	<row>
+          <entry><constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant></entry>
+          <entry>0x0101</entry>
+          <entry>Suggested composition rectangle that covers the "whole picture".</entry>
+	  <entry>X</entry>
+	  <entry>O</entry>
+	</row>
+	<row>
+	  <entry><constant>V4L2_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
+	  <entry>0x0102</entry>
+	  <entry>Bounds of the compose rectangle. All valid compose
+	  rectangles fit inside the compose bounds rectangle.</entry>
+	  <entry>X</entry>
+	  <entry>X</entry>
+	</row>
+	<row>
+          <entry><constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant></entry>
+          <entry>0x0103</entry>
+          <entry>The active area and all padding pixels that are inserted or
+	    modified by hardware.</entry>
+	  <entry>X</entry>
+	  <entry>O</entry>
+	</row>
+      </tbody>
+    </tgroup>
+  </table>
+</section>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 015c561..87d0f4f 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -589,6 +589,11 @@ and discussions on the V4L mailing list.</revremark>
     &sub-write;
   </appendix>
 
+  <appendix>
+    <title>Common definitions for V4L2 and V4L2 subdev interfaces</title>
+      &sub-selections-common;
+  </appendix>
+
   <appendix id="videodev">
     <title>Video For Linux Two Header File</title>
     &sub-videodev2-h;
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index 6376e57..c6f8325 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -67,7 +67,7 @@ Do not use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 setting the value of &v4l2-selection; <structfield>target</structfield> field
 to <constant> V4L2_SEL_TGT_CROP </constant> (<constant>
 V4L2_SEL_TGT_COMPOSE </constant>).  Please refer to table <xref
-linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
+linkend="v4l2-selections-common" /> or <xref linkend="selection-api" /> for additional
 targets.  The <structfield>flags</structfield> and <structfield>reserved
 </structfield> fields of &v4l2-selection; are ignored and they must be filled
 with zeros.  The driver fills the rest of the structure or
@@ -88,7 +88,7 @@ use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 setting the value of &v4l2-selection; <structfield>target</structfield> to
 <constant>V4L2_SEL_TGT_CROP</constant> (<constant>
 V4L2_SEL_TGT_COMPOSE </constant>). Please refer to table <xref
-linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
+linkend="v4l2-selections-common" /> or <xref linkend="selection-api" /> for additional
 targets.  The &v4l2-rect; <structfield>r</structfield> rectangle need to be
 set to the desired active area. Field &v4l2-selection; <structfield> reserved
 </structfield> is ignored and must be filled with zeros.  The driver may adjust
@@ -154,52 +154,8 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 
   </refsect1>
 
-  <refsect1>
-    <table frame="none" pgwide="1" id="v4l2-sel-target">
-      <title>Selection targets.</title>
-      <tgroup cols="3">
-	&cs-def;
-	<tbody valign="top">
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_CROP</constant></entry>
-            <entry>0x0000</entry>
-            <entry>The area that is currently cropped by hardware.</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_CROP_DEFAULT</constant></entry>
-            <entry>0x0001</entry>
-            <entry>Suggested cropping rectangle that covers the "whole picture".</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_CROP_BOUNDS</constant></entry>
-            <entry>0x0002</entry>
-            <entry>Limits for the cropping rectangle.</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
-            <entry>0x0100</entry>
-            <entry>The area to which data is composed by hardware.</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant></entry>
-            <entry>0x0101</entry>
-            <entry>Suggested composing rectangle that covers the "whole picture".</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
-            <entry>0x0102</entry>
-            <entry>Limits for the composing rectangle.</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant></entry>
-            <entry>0x0103</entry>
-            <entry>The active area and all padding pixels that are inserted or
-	      modified by hardware.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
+  <para>Selection targets are documented in <xref
+  linkend="v4l2-selections-common"/>.</para>
 
   <refsect1>
     <table frame="none" pgwide="1" id="v4l2-sel-flags">
@@ -253,7 +209,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>target</structfield></entry>
-            <entry>Used to select between <link linkend="v4l2-sel-target"> cropping
+            <entry>Used to select between <link linkend="v4l2-selections-common"> cropping
 	    and composing rectangles</link>.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index 96ab51e..fa4063a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -87,36 +87,8 @@
       <constant>EINVAL</constant>.</para>
     </section>
 
-    <table pgwide="1" frame="none" id="v4l2-subdev-selection-targets">
-      <title>V4L2 subdev selection targets</title>
-      <tgroup cols="3">
-        &cs-def;
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP</constant></entry>
-	    <entry>0x0000</entry>
-	    <entry>Actual crop. Defines the cropping
-	    performed by the processing step.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS</constant></entry>
-	    <entry>0x0002</entry>
-	    <entry>Bounds of the crop rectangle.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE</constant></entry>
-	    <entry>0x0100</entry>
-	    <entry>Actual compose rectangle. Used to configure scaling
-	    on sink pads and composition on source pads.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
-	    <entry>0x0102</entry>
-	    <entry>Bounds of the compose rectangle.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
+    <para>Selection targets are documented in <xref
+    linkend="v4l2-selections-common"/>.</para>
 
     <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
       <title>V4L2 subdev selection flags</title>
@@ -173,7 +145,7 @@
 	    <entry>__u32</entry>
 	    <entry><structfield>target</structfield></entry>
 	    <entry>Target selection rectangle. See
-	    <xref linkend="v4l2-subdev-selection-targets">.</xref>.</entry>
+	    <xref linkend="v4l2-selections-common">.</xref>.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.2.5

