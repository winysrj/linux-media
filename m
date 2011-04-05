Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1DEH5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:16 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0C06335994
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:12 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/14] v4l: add V4L2_PIX_FMT_Y12 format
Date: Tue,  5 Apr 2011 09:57:32 +0200
Message-Id: <1301990256-6963-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Michael Jones <michael.jones@matrix-vision.de>

Y12 is a grey-scale format with a depth of 12 bits per pixel stored in
16-bit words.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-y12.xml  |   79 +++++++++++++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 include/linux/videodev2.h                 |    1 +
 4 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 5d259c6..fea63b4 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -294,6 +294,7 @@
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
index c6fdcbb..40af4be 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -696,6 +696,7 @@ information.</para>
     &sub-packed-yuv;
     &sub-grey;
     &sub-y10;
+    &sub-y12;
     &sub-y16;
     &sub-yuyv;
     &sub-uyvy;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aa6c393..be82c8e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -308,6 +308,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
-- 
1.7.3.4

