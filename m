Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:49833 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbcF0PCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 11:02:24 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v2.1 9/9] v4l: Add 16-bit raw bayer pixel format definitions
Date: Mon, 27 Jun 2016 17:57:51 +0300
Message-Id: <1467039471-19416-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1467039471-19416-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1466439608-22890-1-git-send-email-sakari.ailus@linux.intel.com>
 <1467039471-19416-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:

	V4L2_PIX_FMT_SBGGR16
	V4L2_PIX_FMT_SGBRG16
	V4L2_PIX_FMT_SGRBG16

V4L2_PIX_FMT_SRGGB16 already existed before the patch. Rework the
documentation to match that of the other sample depths.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../v4l/{pixfmt-sbggr16.xml => pixfmt-srggb16.xml} | 49 ++++++++++++++--------
 Documentation/DocBook/media/v4l/pixfmt.xml         |  2 +-
 include/uapi/linux/videodev2.h                     |  3 ++
 3 files changed, 35 insertions(+), 19 deletions(-)
 rename Documentation/DocBook/media/v4l/{pixfmt-sbggr16.xml => pixfmt-srggb16.xml} (62%)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb16.xml
similarity index 62%
rename from Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
rename to Documentation/DocBook/media/v4l/pixfmt-srggb16.xml
index 6494b05..517dd4d 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb16.xml
@@ -1,22 +1,29 @@
-<refentry id="V4L2-PIX-FMT-SBGGR16">
-  <refmeta>
-    <refentrytitle>V4L2_PIX_FMT_SBGGR16 ('BYR2')</refentrytitle>
-    &manvol;
-  </refmeta>
-  <refnamediv>
-    <refname><constant>V4L2_PIX_FMT_SBGGR16</constant></refname>
-    <refpurpose>Bayer RGB format</refpurpose>
-  </refnamediv>
-  <refsect1>
-    <title>Description</title>
+    <refentry>
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_SRGGB16 ('RG16'),
+	 V4L2_PIX_FMT_SGRBG16 ('GR16'),
+	 V4L2_PIX_FMT_SGBRG16 ('GB16'),
+	 V4L2_PIX_FMT_SBGGR16 ('BYR2')
+	 </refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-SRGGB16"><constant>V4L2_PIX_FMT_SRGGB16</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGRBG16"><constant>V4L2_PIX_FMT_SGRBG16</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGBRG16"><constant>V4L2_PIX_FMT_SGBRG16</constant></refname>
+	<refname id="V4L2-PIX-FMT-SBGGR16"><constant>V4L2_PIX_FMT_SBGGR16</constant></refname>
+	<refpurpose>16-bit Bayer formats</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
 
-    <para>This format is similar to <link
-linkend="V4L2-PIX-FMT-SBGGR8">
-<constant>V4L2_PIX_FMT_SBGGR8</constant></link>, except each pixel has
-a depth of 16 bits. The least significant byte is stored at lower
-memory addresses (little-endian). Note the actual sampling precision
-may be lower than 16 bits, for example 10 bits per pixel with values
-in range 0 to 1023.</para>
+	<para>These four pixel formats are raw sRGB / Bayer formats with
+16 bits per colour. Each colour component is stored in a 16-bit word.
+Each n-pixel row contains n/2 green samples and n/2 blue or red
+samples, with alternating red and blue rows. Bytes are stored in
+memory in little endian order. They are conventionally described
+as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
+formats:</para>
 
     <example>
       <title><constant>V4L2_PIX_FMT_SBGGR16</constant> 4 &times; 4
@@ -79,5 +86,11 @@ pixel image</title>
 	</para>
       </formalpara>
     </example>
+
+    <para>Note the actual sampling precision for format
+    <constant>V4L2_PIX_FMT_SBGGR16</constant> may be lower than 16
+    bits, for example 10 bits per pixel with values in range 0 to
+    1023.</para>
+
   </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 296a50a..2c22098 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1587,7 +1587,6 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-sgbrg8;
     &sub-sgrbg8;
     &sub-srggb8;
-    &sub-sbggr16;
     &sub-srggb10;
     &sub-srggb10p;
     &sub-srggb10alaw8;
@@ -1596,6 +1595,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-srggb12p;
     &sub-srggb14;
     &sub-srggb14p;
+    &sub-srggb16;
   </section>
 
   <section id="yuv-formats">
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c34d467..d201857 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -591,6 +591,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGRBG14P v4l2_fourcc('p', 'g', 'E', 'E')
 #define V4L2_PIX_FMT_SRGGB14P v4l2_fourcc('p', 'R', 'E', 'E')
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG16 v4l2_fourcc('G', 'B', '1', '6') /* 16  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG16 v4l2_fourcc('G', 'R', '1', '6') /* 16  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB16 v4l2_fourcc('R', 'G', '1', '6') /* 16  RGRG.. GBGB.. */
 
 /* compressed formats */
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
-- 
2.7.4

