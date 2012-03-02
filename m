Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:60752 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab2CBRcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:55 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 14/34] v4l: Add DPCM compressed formats
Date: Fri,  2 Mar 2012 19:30:22 +0200
Message-Id: <1330709442-16654-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add three other colour orders for 10-bit to 8-bit DPCM compressed formats.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 include/linux/videodev2.h                          |    3 ++
 4 files changed, 34 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
index 7b27409..c1c62a9 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
@@ -1,4 +1,4 @@
-    <refentry>
+    <refentry id="pixfmt-srggb10">
       <refmeta>
 	<refentrytitle>V4L2_PIX_FMT_SRGGB10 ('RG10'),
 	 V4L2_PIX_FMT_SGRBG10 ('BA10'),
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
new file mode 100644
index 0000000..40455f1
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
@@ -0,0 +1,29 @@
+    <refentry>
+      <refmeta>
+	<refentrytitle>
+	 V4L2_PIX_FMT_SRGGB10DPCM8 ('bBA8'),
+	 V4L2_PIX_FMT_SGBRG10DPCM8 ('bGA8'),
+	 V4L2_PIX_FMT_SGRBG10DPCM8 ('BD10'),
+	 V4L2_PIX_FMT_SBGGR10DPCM8 ('bRA8'),
+	 </refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-SRGGB10DPCM8"><constant>V4L2_PIX_FMT_SRGGB10DPCM8</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGRBG10DPCM8"><constant>V4L2_PIX_FMT_SGRBG10DPCM8</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGBRG10DPCM8"><constant>V4L2_PIX_FMT_SGBRG10DPCM8</constant></refname>
+	<refname id="V4L2-PIX-FMT-SBGGR10DPCM8"><constant>V4L2_PIX_FMT_SBGGR10DPCM8</constant></refname>
+	<refpurpose>10-bit Bayer formats compressed to 8 bits</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>The following four pixel formats are raw sRGB / Bayer formats
+	with 10 bits per colour compressed to 8 bits each, using DPCM
+	compression. DPCM, differential pulse-code modulation, is lossy.
+	Each colour component consumes 8 bits of memory. In other respects
+	this format is similar to <xref
+	linkend="pixfmt-srggb10">.</xref></para>
+
+      </refsect1>
+    </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 31eaae2..74d4fcd 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -673,6 +673,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-srggb8;
     &sub-sbggr16;
     &sub-srggb10;
+    &sub-srggb10dpcm8;
     &sub-srggb12;
   </section>
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f46350e..76f3153 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -378,7 +378,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
 	/* 10bit raw bayer DPCM compressed to 8 bits */
+#define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('b', 'B', 'A', '8')
+#define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
+#define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
 	/*
 	 * 10bit raw bayer, expanded to 16 bits
 	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
-- 
1.7.2.5

