Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:36051 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1C2IUD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 04:20:03 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v4 1/4] v4l: add V4L2_PIX_FMT_Y12 format
Date: Tue, 29 Mar 2011 10:19:06 +0200
Message-Id: <1301386749-17497-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1301386749-17497-1-git-send-email-michael.jones@matrix-vision.de>
References: <1301386749-17497-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-y12.xml  |   79 +++++++++++++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 include/linux/videodev2.h                 |    1 +
 4 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 157d147..fbd5b1b 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -287,6 +287,7 @@
 <!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
 <!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
 <!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
+<!ENTITY sub-y12 SYSTEM "v4l/pixfmt-y12.xml">
 <!ENTITY sub-pixfmt SYSTEM "v4l/pixfmt.xml">
 <!ENTITY sub-cropcap SYSTEM "v4l/vidioc-cropcap.xml">
 <!ENTITY sub-dbg-g-register SYSTEM "v4l/vidioc-dbg-g-register.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt-y12.xml b/Documentation/DocBook/v4l/pixfmt-y12.xml
new file mode 100644
index 0000000..ff417b8
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-y12.xml
@@ -0,0 +1,79 @@
+<refentry id="V4L2-PIX-FMT-Y12">
+  <refmeta>
+    <refentrytitle>V4L2_PIX_FMT_Y12 ('Y12 ')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_PIX_FMT_Y12</constant></refname>
+    <refpurpose>Grey-scale image</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This is a grey-scale image with a depth of 12 bits per pixel. Pixels
+are stored in 16-bit words with unused high bits padded with 0. The least
+significant byte is stored at lower memory addresses (little-endian).</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_Y12</constant> 4 &times; 4
+pixel image</title>
+
+      <formalpara>
+	<title>Byte Order.</title>
+	<para>Each cell is one byte.
+	  <informaltable frame="none">
+	    <tgroup cols="9" align="center">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>start&nbsp;+&nbsp;0:</entry>
+		  <entry>Y'<subscript>00low</subscript></entry>
+		  <entry>Y'<subscript>00high</subscript></entry>
+		  <entry>Y'<subscript>01low</subscript></entry>
+		  <entry>Y'<subscript>01high</subscript></entry>
+		  <entry>Y'<subscript>02low</subscript></entry>
+		  <entry>Y'<subscript>02high</subscript></entry>
+		  <entry>Y'<subscript>03low</subscript></entry>
+		  <entry>Y'<subscript>03high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;8:</entry>
+		  <entry>Y'<subscript>10low</subscript></entry>
+		  <entry>Y'<subscript>10high</subscript></entry>
+		  <entry>Y'<subscript>11low</subscript></entry>
+		  <entry>Y'<subscript>11high</subscript></entry>
+		  <entry>Y'<subscript>12low</subscript></entry>
+		  <entry>Y'<subscript>12high</subscript></entry>
+		  <entry>Y'<subscript>13low</subscript></entry>
+		  <entry>Y'<subscript>13high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;16:</entry>
+		  <entry>Y'<subscript>20low</subscript></entry>
+		  <entry>Y'<subscript>20high</subscript></entry>
+		  <entry>Y'<subscript>21low</subscript></entry>
+		  <entry>Y'<subscript>21high</subscript></entry>
+		  <entry>Y'<subscript>22low</subscript></entry>
+		  <entry>Y'<subscript>22high</subscript></entry>
+		  <entry>Y'<subscript>23low</subscript></entry>
+		  <entry>Y'<subscript>23high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;24:</entry>
+		  <entry>Y'<subscript>30low</subscript></entry>
+		  <entry>Y'<subscript>30high</subscript></entry>
+		  <entry>Y'<subscript>31low</subscript></entry>
+		  <entry>Y'<subscript>31high</subscript></entry>
+		  <entry>Y'<subscript>32low</subscript></entry>
+		  <entry>Y'<subscript>32high</subscript></entry>
+		  <entry>Y'<subscript>33low</subscript></entry>
+		  <entry>Y'<subscript>33high</subscript></entry>
+		</row>
+	      </tbody>
+	    </tgroup>
+	  </informaltable>
+	</para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index cfffc88..426bd27 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -592,6 +592,7 @@ information.</para>
     &sub-packed-yuv;
     &sub-grey;
     &sub-y10;
+    &sub-y12;
     &sub-y16;
     &sub-yuyv;
     &sub-uyvy;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 02da9e7..6fac463 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -288,6 +288,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
-- 
1.7.4.2


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
