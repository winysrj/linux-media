Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:41187 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab2FJTfI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 15:35:08 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: snjw23@gmail.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH 4/4] v4l: Common documentation for selection targets
Date: Sun, 10 Jun 2012 22:34:38 +0300
Message-Id: <1339356878-2179-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FD4F6B6.1070605@iki.fi>
References: <4FD4F6B6.1070605@iki.fi>
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
 Documentation/DocBook/media/v4l/dev-subdev.xml     |    2 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |    3 +-
 .../DocBook/media/v4l/selection-targets.xml        |   93 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   54 +----------
 .../media/v4l/vidioc-subdev-g-selection.xml        |    3 +
 6 files changed, 108 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/selection-targets.xml

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
index ac715dd..dd2d78e 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -276,7 +276,7 @@
       </para>
     </section>
 
-    <section>
+    <section id="subdev-selections">
       <title>Selections: cropping, scaling and composition</title>
 
       <para>Many sub-devices support cropping frames on their input or output
diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index ac013e5..23cc966 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -53,8 +53,7 @@ cropping and composing rectangles have the same size.</para>
 	</mediaobject>
       </figure>
 
-For complete list of the available selection targets see table <xref
-linkend="v4l2-sel-target"/>
+      &sub-selection-targets;
 
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/selection-targets.xml b/Documentation/DocBook/media/v4l/selection-targets.xml
new file mode 100644
index 0000000..4fa69fe
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/selection-targets.xml
@@ -0,0 +1,93 @@
+<section id="selection-targets">
+
+  <title>V4L2 and V4L2 sub-device interfaces and selection targets</title>
+
+  <para>While the V4L2 <xref linkend="selection-api"/> and V4L2
+  subdev <xref linkend="subdev-selections"/> selection APIs are very
+  similar, there's one fundamental difference between the two. On
+  sub-device API, the selection rectangle is refers to the media bus
+  format, and is bound to a sub-device and a pad. On the V4L2
+  interface the selection rectangles refer to the in-memory pixel
+  format and a video device's buffer queue.</para>
+
+  <para>The meaning of the selection targets may thus be affected on
+  which of the two interfaces they are used.</para>
+
+
+  <table pgwide="1" frame="none" id="selection-targets-table">
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
+	  rectangles fid inside the compose bounds rectangle.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index 6376e57..6362971 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -67,7 +67,7 @@ Do not use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 setting the value of &v4l2-selection; <structfield>target</structfield> field
 to <constant> V4L2_SEL_TGT_CROP </constant> (<constant>
 V4L2_SEL_TGT_COMPOSE </constant>).  Please refer to table <xref
-linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
+linkend="selection-targets" /> or <xref linkend="selection-api" /> for additional
 targets.  The <structfield>flags</structfield> and <structfield>reserved
 </structfield> fields of &v4l2-selection; are ignored and they must be filled
 with zeros.  The driver fills the rest of the structure or
@@ -88,7 +88,7 @@ use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 setting the value of &v4l2-selection; <structfield>target</structfield> to
 <constant>V4L2_SEL_TGT_CROP</constant> (<constant>
 V4L2_SEL_TGT_COMPOSE </constant>). Please refer to table <xref
-linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
+linkend="selection-targets" /> or <xref linkend="selection-api" /> for additional
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
+  linkend="selection-targets"/>.</para>
 
   <refsect1>
     <table frame="none" pgwide="1" id="v4l2-sel-flags">
@@ -253,7 +209,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>target</structfield></entry>
-            <entry>Used to select between <link linkend="v4l2-sel-target"> cropping
+            <entry>Used to select between <link linkend="selection-targets"> cropping
 	    and composing rectangles</link>.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index 96ab51e..17f2e22 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -87,6 +87,9 @@
       <constant>EINVAL</constant>.</para>
     </section>
 
+    <para>Selection targets are documented in <xref
+    linkend="selection-targets"/>.</para>
+
     <table pgwide="1" frame="none" id="v4l2-subdev-selection-targets">
       <title>V4L2 subdev selection targets</title>
       <tgroup cols="3">
-- 
1.7.2.5

