Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:48128 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab2FMVbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:31:01 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	snjw23@gmail.com, t.stanislaws@samsung.com
Subject: [PATCH v2 6/6] v4l: Unify selection flags documentation
Date: Thu, 14 Jun 2012 00:30:25 +0300
Message-Id: <1339623025-6227-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FD9065B.2030703@iki.fi>
References: <4FD9065B.2030703@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As for the selection targets, the selection flags are now the same on V4L2
and V4L2 subdev interfaces. Also document them so.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |    6 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |    4 +-
 .../DocBook/media/v4l/selections-common.xml        |  221 +++++++++++++-------
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   27 +---
 .../media/v4l/vidioc-subdev-g-selection.xml        |   39 +----
 5 files changed, 155 insertions(+), 142 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 76c4307..8c44b3f 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -323,10 +323,10 @@
       <para>The drivers should always use the closest possible
       rectangle the user requests on all selection targets, unless
       specifically told otherwise.
-      <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant> and
-      <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant> flags may be
+      <constant>V4L2_SEL_FLAG_GE</constant> and
+      <constant>V4L2_SEL_FLAG_LE</constant> flags may be
       used to round the image size either up or down. <xref
-      linkend="v4l2-subdev-selection-flags"></xref></para>
+      linkend="v4l2-selection-flags"></xref></para>
     </section>
 
     <section>
diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index d652a12..2de8b01 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -71,7 +71,7 @@ cropping/composing rectangles may have to be aligned, and both the source and
 the sink may have arbitrary upper and lower size limits. Therefore, as usual,
 drivers are expected to adjust the requested parameters and return the actual
 values selected. An application can control the rounding behaviour using <link
-linkend="v4l2-sel-flags"> constraint flags </link>.</para>
+linkend="v4l2-selection-flags"> constraint flags </link>.</para>
 
    <section>
 
@@ -114,7 +114,7 @@ the bounds rectangle. The composing rectangle must lie completely inside bounds
 rectangle. The driver must adjust the composing rectangle to fit to the
 bounding limits. Moreover, the driver can perform other adjustments according
 to hardware limitations. The application can control rounding behaviour using
-<link linkend="v4l2-sel-flags"> constraint flags </link>.</para>
+<link linkend="v4l2-selection-flags"> constraint flags </link>.</para>
 
 <para>For capture devices the default composing rectangle is queried using
 <constant> V4L2_SEL_TGT_COMPOSE_DEFAULT </constant>. It is usually equal to the
diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
index e8f0b02..ad78866 100644
--- a/Documentation/DocBook/media/v4l/selections-common.xml
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -1,6 +1,6 @@
 <section id="v4l2-selections-common">
 
-  <title>Selection targets</title>
+  <title>Common selection definitions</title>
 
   <para>While the V4L2 <xref linkend="selection-api"/> and V4L2
   subdev <xref linkend="v4l2-subdev-selections"/> selection APIs are very
@@ -10,83 +10,154 @@
   interface the selection rectangles refer to the in-memory pixel
   format and a video device's buffer queue.</para>
 
-  <para>The meaning of the selection targets may thus be affected on
-  which of the two interfaces they are used.</para>
+  <para>This section defines the common parts of the two APIs.</para>
 
-  <table pgwide="1" frame="none" id="v4l2-selection-targets-table">
-  <title>Selection target definitions</title>
-    <tgroup cols="4">
-      <colspec colname="c1" />
-      <colspec colname="c2" />
-      <colspec colname="c3" />
-      <colspec colname="c4" />
-      <colspec colname="c5" />
-      &cs-def;
-      <thead>
+  <section id="v4l2-selection-targets">
+
+    <title>Selection targets</title>
+
+    <para>The meaning of the selection targets may thus be affected on
+    which of the two interfaces they are used.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-selection-targets-table">
+    <title>Selection target definitions</title>
+      <tgroup cols="4">
+	<colspec colname="c1" />
+	<colspec colname="c2" />
+	<colspec colname="c3" />
+	<colspec colname="c4" />
+	<colspec colname="c5" />
+	&cs-def;
+	<thead>
 	<row rowsep="1">
-	  <entry align="left">Target name</entry>
-	  <entry align="left">id</entry>
-	  <entry align="left">Definition</entry>
-	  <entry align="left">Valid for V4L2</entry>
-	  <entry align="left">Valid for V4L2 subdev</entry>
-	</row>
-      </thead>
-      <tbody valign="top">
-	<row>
-	  <entry><constant>V4L2_SEL_TGT_CROP</constant></entry>
-	  <entry>0x0000</entry>
-	  <entry>Crop rectangle. Defines the cropped area.</entry>
-	  <entry>X</entry>
-	  <entry>X</entry>
-	</row>
-	<row>
-          <entry><constant>V4L2_SEL_TGT_CROP_DEFAULT</constant></entry>
-          <entry>0x0001</entry>
-          <entry>Suggested cropping rectangle that covers the "whole picture".</entry>
-	  <entry>X</entry>
-	  <entry>O</entry>
-	</row>
-	<row>
-	  <entry><constant>V4L2_SEL_TGT_CROP_BOUNDS</constant></entry>
-	  <entry>0x0002</entry>
-	  <entry>Bounds of the crop rectangle. All valid crop
-	  rectangles fit inside the crop bounds rectangle.
-	  </entry>
-	  <entry>X</entry>
-	  <entry>X</entry>
-	</row>
-	<row>
-	  <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
-	  <entry>0x0100</entry>
-	  <entry>Compose rectangle. Used to configure scaling
-	  and composition.</entry>
-	  <entry>X</entry>
-	  <entry>X</entry>
-	</row>
-	<row>
-          <entry><constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant></entry>
-          <entry>0x0101</entry>
-          <entry>Suggested composition rectangle that covers the "whole picture".</entry>
-	  <entry>X</entry>
-	  <entry>O</entry>
+	    <entry align="left">Target name</entry>
+	    <entry align="left">id</entry>
+	    <entry align="left">Definition</entry>
+	    <entry align="left">Valid for V4L2</entry>
+	    <entry align="left">Valid for V4L2 subdev</entry>
 	</row>
-	<row>
-	  <entry><constant>V4L2_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
-	  <entry>0x0102</entry>
-	  <entry>Bounds of the compose rectangle. All valid compose
-	  rectangles fid inside the compose bounds rectangle.</entry>
-	  <entry>X</entry>
-	  <entry>X</entry>
-	</row>
-	<row>
-          <entry><constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant></entry>
-          <entry>0x0103</entry>
-          <entry>The active area and all padding pixels that are inserted or
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_CROP</constant></entry>
+	    <entry>0x0000</entry>
+	    <entry>Crop rectangle. Defines the cropped area.</entry>
+	    <entry>X</entry>
+	    <entry>X</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_CROP_DEFAULT</constant></entry>
+	    <entry>0x0001</entry>
+	    <entry>Suggested cropping rectangle that covers the "whole picture".</entry>
+	    <entry>X</entry>
+	    <entry>O</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_CROP_BOUNDS</constant></entry>
+	    <entry>0x0002</entry>
+	    <entry>Bounds of the crop rectangle. All valid crop
+	    rectangles fit inside the crop bounds rectangle.
+	    </entry>
+	    <entry>X</entry>
+	    <entry>X</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
+	    <entry>0x0100</entry>
+	    <entry>Compose rectangle. Used to configure scaling
+	    and composition.</entry>
+	    <entry>X</entry>
+	    <entry>X</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant></entry>
+	    <entry>0x0101</entry>
+	    <entry>Suggested composition rectangle that covers the "whole picture".</entry>
+	    <entry>X</entry>
+	    <entry>O</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
+	    <entry>0x0102</entry>
+	    <entry>Bounds of the compose rectangle. All valid compose
+	    rectangles fid inside the compose bounds rectangle.</entry>
+	    <entry>X</entry>
+	    <entry>X</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant></entry>
+	    <entry>0x0103</entry>
+	    <entry>The active area and all padding pixels that are inserted or
 	    modified by hardware.</entry>
-	  <entry>X</entry>
-	  <entry>O</entry>
+	    <entry>X</entry>
+	    <entry>O</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </section>
+
+  <section id="v4l2-selection-flags">
+
+    <title>Selection flags</title>
+
+    <table pgwide="1" frame="none" id="v4l2-selection-flags-table">
+    <title>Selection flag definitions</title>
+      <tgroup cols="4">
+	<colspec colname="c1" />
+	<colspec colname="c2" />
+	<colspec colname="c3" />
+	<colspec colname="c4" />
+	<colspec colname="c5" />
+	&cs-def;
+	<thead>
+	<row rowsep="1">
+	    <entry align="left">Flag name</entry>
+	    <entry align="left">id</entry>
+	    <entry align="left">Definition</entry>
+	    <entry align="left">Valid for V4L2</entry>
+	    <entry align="left">Valid for V4L2 subdev</entry>
 	</row>
-      </tbody>
-    </tgroup>
-  </table>
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_SEL_FLAG_GE</constant></entry>
+	    <entry>(1 &lt;&lt; 0)</entry>
+	    <entry>Suggest the driver it should choose greater or
+	    equal rectangle (in size) than was requested. Albeit the
+	    driver may choose a lesser size, it will only do so due to
+	    hardware limitations. Without this flag (and
+	    <constant>V4L2_SEL_FLAG_LE</constant>) the
+	    behaviour is to choose the closest possible
+	    rectangle.</entry>
+	    <entry>X</entry>
+            <entry>X</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_FLAG_LE</constant></entry>
+	    <entry>(1 &lt;&lt; 1)</entry>
+	    <entry>Suggest the driver it
+	    should choose lesser or equal rectangle (in size) than was
+	    requested. Albeit the driver may choose a greater size, it
+	    will only do so due to hardware limitations.</entry>
+	    <entry>X</entry>
+            <entry>X</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SEL_FLAG_KEEP_CONFIG</constant></entry>
+	    <entry>(1 &lt;&lt; 2)</entry>
+	    <entry>The configuration should not be propagated to any
+	    further processing steps. If this flag is not given, the
+	    configuration is propagated inside the subdevice to all
+	    further processing steps.</entry>
+	    <entry>O</entry>
+            <entry>X</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </section>
+
 </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index c6f8325..f76d8a6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -154,32 +154,9 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 
   </refsect1>
 
-  <para>Selection targets are documented in <xref
+  <para>Selection targets and flags are documented in <xref
   linkend="v4l2-selections-common"/>.</para>
 
-  <refsect1>
-    <table frame="none" pgwide="1" id="v4l2-sel-flags">
-      <title>Selection constraint flags</title>
-      <tgroup cols="3">
-	&cs-def;
-	<tbody valign="top">
-	  <row>
-            <entry><constant>V4L2_SEL_FLAG_GE</constant></entry>
-            <entry>0x00000001</entry>
-            <entry>Indicates that the adjusted rectangle must contain the original
-	    &v4l2-selection; <structfield>r</structfield> rectangle.</entry>
-	  </row>
-	  <row>
-            <entry><constant>V4L2_SEL_FLAG_LE</constant></entry>
-            <entry>0x00000002</entry>
-            <entry>Indicates that the adjusted rectangle must be inside the original
-	    &v4l2-rect; <structfield>r</structfield> rectangle.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
-
     <section>
       <figure id="sel-const-adjust">
 	<title>Size adjustments with constraint flags.</title>
@@ -216,7 +193,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	    <entry>__u32</entry>
 	    <entry><structfield>flags</structfield></entry>
             <entry>Flags controlling the selection rectangle adjustments, refer to
-	    <link linkend="v4l2-sel-flags">selection flags</link>.</entry>
+	    <link linkend="v4l2-selection-flags">selection flags</link>.</entry>
 	  </row>
 	  <row>
 	    <entry>&v4l2-rect;</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index fa4063a..9bc691e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -87,44 +87,9 @@
       <constant>EINVAL</constant>.</para>
     </section>
 
-    <para>Selection targets are documented in <xref
+    <para>Selection targets and flags are documented in <xref
     linkend="v4l2-selections-common"/>.</para>
 
-    <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
-      <title>V4L2 subdev selection flags</title>
-      <tgroup cols="3">
-        &cs-def;
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant></entry>
-	    <entry>(1 &lt;&lt; 0)</entry> <entry>Suggest the driver it
-	    should choose greater or equal rectangle (in size) than
-	    was requested. Albeit the driver may choose a lesser size,
-	    it will only do so due to hardware limitations. Without
-	    this flag (and
-	    <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>) the
-	    behaviour is to choose the closest possible
-	    rectangle.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
-	    <entry>(1 &lt;&lt; 1)</entry> <entry>Suggest the driver it
-	    should choose lesser or equal rectangle (in size) than was
-	    requested. Albeit the driver may choose a greater size, it
-	    will only do so due to hardware limitations.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant></entry>
-	    <entry>(1 &lt;&lt; 2)</entry>
-	    <entry>The configuration should not be propagated to any
-	    further processing steps. If this flag is not given, the
-	    configuration is propagated inside the subdevice to all
-	    further processing steps.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
     <table pgwide="1" frame="none" id="v4l2-subdev-selection">
       <title>struct <structname>v4l2_subdev_selection</structname></title>
       <tgroup cols="3">
@@ -151,7 +116,7 @@
 	    <entry>__u32</entry>
 	    <entry><structfield>flags</structfield></entry>
 	    <entry>Flags. See
-	    <xref linkend="v4l2-subdev-selection-flags">.</xref></entry>
+	    <xref linkend="v4l2-selection-flags">.</xref></entry>
 	  </row>
 	  <row>
 	    <entry>&v4l2-rect;</entry>
-- 
1.7.2.5

