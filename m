Return-path: <mchehab@gaivota>
Received: from smtp208.alice.it ([82.57.200.104]:39731 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0LPLad (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 06:30:33 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	openkinect@googlegroups.com, Steven Toth <stoth@kernellabs.com>
Subject: [RFC, PATCH] Add 10 bit packed greyscale format.
Date: Thu, 16 Dec 2010 12:29:44 +0100
Message-Id: <1292498984-9198-1-git-send-email-ospite@studenti.unina.it>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

A 10 bits per pixel greyscale format in a packed array representation is
supplied for instance by Kinect sensor device.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Hi,

This is the first attempt to add v4l support for the 10bpp packed array format
used by the Kinect sensor device for depth data and for IR mode (in this mode
the device streams the image as seen by the monochrome sensor).

This version is mainly to start the discussion about the format and how it
should be seen by v4l, the doubts I still have are about:

  1. The name of the format: is Y10P OK? Moreover, "packed" here is used in a
     _stronger_ meaning compared to the other packed formats, and I also saw the
     name "compact array" used somewhere for these kind of objects.

  2. The actual order of the bits, please check the documentation below to see
     if I got it right.
     And maybe I should not mention the unpacked version of the data as this
     depends on the unpacking algorithm, what do you think?
  
  3. The way to illustrate the packed array concept in the documentation: I
     used a bit-field syntax like in hardware registers docs, does this look
     meaningful to you? Or should I find a way to clearly show the difference
     between _byte_alignment_ and _element_alignment_.

If you could point to some literature about packed array representations I'd be
happy to take a look at it.

After these issues are addressed, I am going to submit changes to libv4l as
well.

Thanks,
  Antonio Ospite
  http://ao2.it

 include/linux/videodev2.h                 |    1 +
 Documentation/DocBook/v4l/videodev2.h.xml |    1 +
 Documentation/DocBook/v4l/pixfmt-y10p.xml |   47 +++++++++++++++++++++++++++++
 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 5 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10p.xml

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5f6f470..7682581 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -288,6 +288,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define V4L2_PIX_FMT_Y10P    v4l2_fourcc('Y', '1', '0', 'P') /* 10  Greyscale as a packed array */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 325b23b..773496c 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -289,6 +289,7 @@ struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
 #define <link linkend="V4L2-PIX-FMT-Y4">V4L2_PIX_FMT_Y4</link>      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define <link linkend="V4L2-PIX-FMT-Y6">V4L2_PIX_FMT_Y6</link>      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define <link linkend="V4L2-PIX-FMT-Y10">V4L2_PIX_FMT_Y10</link>     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define <link linkend="V4L2-PIX-FMT-Y10P">V4L2_PIX_FMT_Y10P</link>    v4l2_fourcc('Y', '1', '0', 'P') /* 10  Greyscale as a packed array */ 
 #define <link linkend="V4L2-PIX-FMT-Y16">V4L2_PIX_FMT_Y16</link>     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
diff --git a/Documentation/DocBook/v4l/pixfmt-y10p.xml b/Documentation/DocBook/v4l/pixfmt-y10p.xml
new file mode 100644
index 0000000..363f1e5
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-y10p.xml
@@ -0,0 +1,47 @@
+<refentry id="V4L2-PIX-FMT-Y10P">
+  <refmeta>
+    <refentrytitle>V4L2_PIX_FMT_Y10P ('Y10P')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_PIX_FMT_Y10P</constant></refname>
+    <refpurpose>Grey-scale image as a packed array</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This is a packed grey-scale image with a depth of 10 bits per pixel. Pixels
+      are stored in a packed array of 10bit bits per pixel, thus with no padding
+      between them. When unpacked to a Y10 format the least significant byte is
+      stored at lower memory addresses (little-endian).</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_Y10P</constant> 4 pixel data stream taking 5 bytes</title>
+
+      <formalpara>
+	<title>Packed representation</title>
+	<para>pixels cross the byte boundary and have a ratio of 5 bytes for each 4
+          pixels.
+	  <informaltable frame="none">
+	    <tgroup cols="9" align="center">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>start:</entry>
+		  <entry>Y'<subscript>00[1:0]</subscript></entry>
+		  <entry>Y'<subscript>00[9:2]</subscript></entry>
+		  <entry>Y'<subscript>01[1:0]</subscript></entry>
+		  <entry>Y'<subscript>01[9:2]</subscript></entry>
+		  <entry>Y'<subscript>02[1:0]</subscript></entry>
+		  <entry>Y'<subscript>02[9:2]</subscript></entry>
+		  <entry>Y'<subscript>03[1:0]</subscript></entry>
+		  <entry>Y'<subscript>03[9:2]</subscript></entry>
+		</row>
+	      </tbody>
+	    </tgroup>
+	  </informaltable>
+	</para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index be34dcb..2b18de5 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -253,6 +253,7 @@
 <!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
 <!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
 <!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
+<!ENTITY sub-y10p SYSTEM "v4l/pixfmt-y10p.xml">
 <!ENTITY sub-pixfmt SYSTEM "v4l/pixfmt.xml">
 <!ENTITY sub-cropcap SYSTEM "v4l/vidioc-cropcap.xml">
 <!ENTITY sub-dbg-g-register SYSTEM "v4l/vidioc-dbg-g-register.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index d7c4671..3682701 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -592,6 +592,7 @@ information.</para>
     &sub-packed-yuv;
     &sub-grey;
     &sub-y10;
+    &sub-y10p;
     &sub-y16;
     &sub-yuyv;
     &sub-uyvy;
-- 
1.7.2.3

