Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbcGGGtJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2016 02:49:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, bparrot@ti.com, nsekhar@ti.com,
	prabhakar.csengg@gmail.com
Subject: [PATCH v2.2 10/10] v4l: Add 16-bit raw bayer pixel format definitions
Date: Thu,  7 Jul 2016 09:48:22 +0300
Message-Id: <1467874102-28365-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1467874102-28365-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1467039471-19416-2-git-send-email-sakari.ailus@linux.intel.com>
 <1467874102-28365-1-git-send-email-sakari.ailus@linux.intel.com>
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
 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml | 81 -------------------
 Documentation/DocBook/media/v4l/pixfmt-srggb16.xml | 91 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |  2 +-
 include/uapi/linux/videodev2.h                     |  3 +
 4 files changed, 95 insertions(+), 82 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb16.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
deleted file mode 100644
index 789160565..0000000
--- a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
+++ /dev/null
@@ -1,81 +0,0 @@
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
-
-    <para>This format is similar to <link
-linkend="V4L2-PIX-FMT-SBGGR8">
-<constant>V4L2_PIX_FMT_SBGGR8</constant></link>, except each pixel has
-a depth of 16 bits. The least significant byte is stored at lower
-memory addresses (little-endian).</para>
-
-    <example>
-      <title><constant>V4L2_PIX_FMT_SBGGR16</constant> 4 &times; 4
-pixel image</title>
-
-      <formalpara>
-	<title>Byte Order.</title>
-	<para>Each cell is one byte.
-	  <informaltable frame="none">
-	    <tgroup cols="5" align="center">
-	      <colspec align="left" colwidth="2*" />
-	      <tbody valign="top">
-		<row>
-		  <entry>start&nbsp;+&nbsp;0:</entry>
-		  <entry>B<subscript>00low</subscript></entry>
-		  <entry>B<subscript>00high</subscript></entry>
-		  <entry>G<subscript>01low</subscript></entry>
-		  <entry>G<subscript>01high</subscript></entry>
-		  <entry>B<subscript>02low</subscript></entry>
-		  <entry>B<subscript>02high</subscript></entry>
-		  <entry>G<subscript>03low</subscript></entry>
-		  <entry>G<subscript>03high</subscript></entry>
-		</row>
-		<row>
-		  <entry>start&nbsp;+&nbsp;8:</entry>
-		  <entry>G<subscript>10low</subscript></entry>
-		  <entry>G<subscript>10high</subscript></entry>
-		  <entry>R<subscript>11low</subscript></entry>
-		  <entry>R<subscript>11high</subscript></entry>
-		  <entry>G<subscript>12low</subscript></entry>
-		  <entry>G<subscript>12high</subscript></entry>
-		  <entry>R<subscript>13low</subscript></entry>
-		  <entry>R<subscript>13high</subscript></entry>
-		</row>
-		<row>
-		  <entry>start&nbsp;+&nbsp;16:</entry>
-		  <entry>B<subscript>20low</subscript></entry>
-		  <entry>B<subscript>20high</subscript></entry>
-		  <entry>G<subscript>21low</subscript></entry>
-		  <entry>G<subscript>21high</subscript></entry>
-		  <entry>B<subscript>22low</subscript></entry>
-		  <entry>B<subscript>22high</subscript></entry>
-		  <entry>G<subscript>23low</subscript></entry>
-		  <entry>G<subscript>23high</subscript></entry>
-		</row>
-		<row>
-		  <entry>start&nbsp;+&nbsp;24:</entry>
-		  <entry>G<subscript>30low</subscript></entry>
-		  <entry>G<subscript>30high</subscript></entry>
-		  <entry>R<subscript>31low</subscript></entry>
-		  <entry>R<subscript>31high</subscript></entry>
-		  <entry>G<subscript>32low</subscript></entry>
-		  <entry>G<subscript>32high</subscript></entry>
-		  <entry>R<subscript>33low</subscript></entry>
-		  <entry>R<subscript>33high</subscript></entry>
-		</row>
-	      </tbody>
-	    </tgroup>
-	  </informaltable>
-	</para>
-      </formalpara>
-    </example>
-  </refsect1>
-</refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb16.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb16.xml
new file mode 100644
index 0000000..590266f
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb16.xml
@@ -0,0 +1,91 @@
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
+
+	<para>These four pixel formats are raw sRGB / Bayer formats with
+16 bits per colour. Each colour component is stored in a 16-bit word.
+Each n-pixel row contains n/2 green samples and n/2 blue or red
+samples, with alternating red and blue rows. Bytes are stored in
+memory in little endian order. They are conventionally described
+as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
+formats:</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_SBGGR16</constant> 4 &times; 4
+pixel image</title>
+
+      <formalpara>
+	<title>Byte Order.</title>
+	<para>Each cell is one byte.
+	  <informaltable frame="none">
+	    <tgroup cols="5" align="center">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>start&nbsp;+&nbsp;0:</entry>
+		  <entry>B<subscript>00low</subscript></entry>
+		  <entry>B<subscript>00high</subscript></entry>
+		  <entry>G<subscript>01low</subscript></entry>
+		  <entry>G<subscript>01high</subscript></entry>
+		  <entry>B<subscript>02low</subscript></entry>
+		  <entry>B<subscript>02high</subscript></entry>
+		  <entry>G<subscript>03low</subscript></entry>
+		  <entry>G<subscript>03high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;8:</entry>
+		  <entry>G<subscript>10low</subscript></entry>
+		  <entry>G<subscript>10high</subscript></entry>
+		  <entry>R<subscript>11low</subscript></entry>
+		  <entry>R<subscript>11high</subscript></entry>
+		  <entry>G<subscript>12low</subscript></entry>
+		  <entry>G<subscript>12high</subscript></entry>
+		  <entry>R<subscript>13low</subscript></entry>
+		  <entry>R<subscript>13high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;16:</entry>
+		  <entry>B<subscript>20low</subscript></entry>
+		  <entry>B<subscript>20high</subscript></entry>
+		  <entry>G<subscript>21low</subscript></entry>
+		  <entry>G<subscript>21high</subscript></entry>
+		  <entry>B<subscript>22low</subscript></entry>
+		  <entry>B<subscript>22high</subscript></entry>
+		  <entry>G<subscript>23low</subscript></entry>
+		  <entry>G<subscript>23high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;24:</entry>
+		  <entry>G<subscript>30low</subscript></entry>
+		  <entry>G<subscript>30high</subscript></entry>
+		  <entry>R<subscript>31low</subscript></entry>
+		  <entry>R<subscript>31high</subscript></entry>
+		  <entry>G<subscript>32low</subscript></entry>
+		  <entry>G<subscript>32high</subscript></entry>
+		  <entry>R<subscript>33low</subscript></entry>
+		  <entry>R<subscript>33high</subscript></entry>
+		</row>
+	      </tbody>
+	    </tgroup>
+	  </informaltable>
+	</para>
+      </formalpara>
+    </example>
+
+  </refsect1>
+</refentry>
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
index 32e9e74..c62c85b 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -593,6 +593,9 @@ struct v4l2_pix_format {
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

