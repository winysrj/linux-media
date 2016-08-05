Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbcHEKqi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 11/11] doc-rst: Add 16-bit raw bayer pixel format definitions
Date: Fri,  5 Aug 2016 13:45:41 +0300
Message-Id: <1470393941-26959-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:

	V4L2_PIX_FMT_SBGGR16
	V4L2_PIX_FMT_SGBRG16
	V4L2_PIX_FMT_SGRBG16

V4L2_PIX_FMT_SRGGB16 already existed before the patch. Rework the
documentation to match that of the other sample depths.

Also align the description of V4L2_PIX_FMT_SRGGB16 to match with other
similar formats.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Documentation/media/uapi/v4l/pixfmt-rgb.rst     |   2 +-
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst | 111 ----------------------
 Documentation/media/uapi/v4l/pixfmt-srggb16.rst | 120 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c            |   5 +-
 include/uapi/linux/videodev2.h                  |   3 +
 5 files changed, 128 insertions(+), 113 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb16.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 69f11ab..ed0ac1b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -12,7 +12,6 @@ RGB Formats
 
     pixfmt-packed-rgb
     pixfmt-srggb8
-    pixfmt-sbggr16
     pixfmt-srggb10
     pixfmt-srggb10p
     pixfmt-srggb10alaw8
@@ -21,3 +20,4 @@ RGB Formats
     pixfmt-srggb12p
     pixfmt-srggb14
     pixfmt-srggb14p
+    pixfmt-srggb16
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
deleted file mode 100644
index 7844dc3..0000000
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ /dev/null
@@ -1,111 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _V4L2-PIX-FMT-SBGGR16:
-
-*****************************
-V4L2_PIX_FMT_SBGGR16 ('BYR2')
-*****************************
-
-*man V4L2_PIX_FMT_SBGGR16(2)*
-
-Bayer RGB format
-
-
-Description
-===========
-
-This format is similar to
-:ref:`V4L2_PIX_FMT_SBGGR8 <V4L2-PIX-FMT-SBGGR8>`, except each pixel
-has a depth of 16 bits. The least significant byte is stored at lower
-memory addresses (little-endian).
-
-**Byte Order.**
-Each cell is one byte.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
-
-
-    -  .. row 1
-
-       -  start + 0:
-
-       -  B\ :sub:`00low`
-
-       -  B\ :sub:`00high`
-
-       -  G\ :sub:`01low`
-
-       -  G\ :sub:`01high`
-
-       -  B\ :sub:`02low`
-
-       -  B\ :sub:`02high`
-
-       -  G\ :sub:`03low`
-
-       -  G\ :sub:`03high`
-
-    -  .. row 2
-
-       -  start + 8:
-
-       -  G\ :sub:`10low`
-
-       -  G\ :sub:`10high`
-
-       -  R\ :sub:`11low`
-
-       -  R\ :sub:`11high`
-
-       -  G\ :sub:`12low`
-
-       -  G\ :sub:`12high`
-
-       -  R\ :sub:`13low`
-
-       -  R\ :sub:`13high`
-
-    -  .. row 3
-
-       -  start + 16:
-
-       -  B\ :sub:`20low`
-
-       -  B\ :sub:`20high`
-
-       -  G\ :sub:`21low`
-
-       -  G\ :sub:`21high`
-
-       -  B\ :sub:`22low`
-
-       -  B\ :sub:`22high`
-
-       -  G\ :sub:`23low`
-
-       -  G\ :sub:`23high`
-
-    -  .. row 4
-
-       -  start + 24:
-
-       -  G\ :sub:`30low`
-
-       -  G\ :sub:`30high`
-
-       -  R\ :sub:`31low`
-
-       -  R\ :sub:`31high`
-
-       -  G\ :sub:`32low`
-
-       -  G\ :sub:`32high`
-
-       -  R\ :sub:`33low`
-
-       -  R\ :sub:`33high`
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
new file mode 100644
index 0000000..4a3e6f9
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
@@ -0,0 +1,120 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-SRGGB16:
+.. _v4l2-pix-fmt-sbggr16:
+.. _v4l2-pix-fmt-sgbrg16:
+.. _v4l2-pix-fmt-sgrbg16:
+
+
+***************************************************************************************************************************
+V4L2_PIX_FMT_SRGGB16 ('RG16'), V4L2_PIX_FMT_SGRBG16 ('GR16'), V4L2_PIX_FMT_SGBRG16 ('GB16'), V4L2_PIX_FMT_SBGGR16 ('BYR2'),
+***************************************************************************************************************************
+
+*man V4L2_PIX_FMT_SRGGB16(2)*
+
+V4L2_PIX_FMT_SGRBG16
+V4L2_PIX_FMT_SGBRG16
+V4L2_PIX_FMT_SBGGR16
+16-bit Bayer formats expanded to 16 bits
+
+
+Description
+===========
+
+These four pixel formats are raw sRGB / Bayer formats with 16 bits per
+sample. Each sample is stored in a 16-bit word. Each n-pixel row contains
+n/2 green samples and n/2 blue or red samples, with alternating red and blue
+rows. Bytes are stored in memory in little endian order. They are
+conventionally described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is
+an example of one of these formats:
+
+**Byte Order.**
+Each cell is one byte.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1 1 1 1 1
+
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  B\ :sub:`00low`
+
+       -  B\ :sub:`00high`
+
+       -  G\ :sub:`01low`
+
+       -  G\ :sub:`01high`
+
+       -  B\ :sub:`02low`
+
+       -  B\ :sub:`02high`
+
+       -  G\ :sub:`03low`
+
+       -  G\ :sub:`03high`
+
+    -  .. row 2
+
+       -  start + 8:
+
+       -  G\ :sub:`10low`
+
+       -  G\ :sub:`10high`
+
+       -  R\ :sub:`11low`
+
+       -  R\ :sub:`11high`
+
+       -  G\ :sub:`12low`
+
+       -  G\ :sub:`12high`
+
+       -  R\ :sub:`13low`
+
+       -  R\ :sub:`13high`
+
+    -  .. row 3
+
+       -  start + 16:
+
+       -  B\ :sub:`20low`
+
+       -  B\ :sub:`20high`
+
+       -  G\ :sub:`21low`
+
+       -  G\ :sub:`21high`
+
+       -  B\ :sub:`22low`
+
+       -  B\ :sub:`22high`
+
+       -  G\ :sub:`23low`
+
+       -  G\ :sub:`23high`
+
+    -  .. row 4
+
+       -  start + 24:
+
+       -  G\ :sub:`30low`
+
+       -  G\ :sub:`30high`
+
+       -  R\ :sub:`31low`
+
+       -  R\ :sub:`31high`
+
+       -  G\ :sub:`32low`
+
+       -  G\ :sub:`32high`
+
+       -  R\ :sub:`33low`
+
+       -  R\ :sub:`33high`
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 29d9f8f..cc10118 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1237,7 +1237,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_SGBRG14:	descr = "14-bit Bayer GBGB/RGRG"; break;
 	case V4L2_PIX_FMT_SGRBG14:	descr = "14-bit Bayer GRGR/BGBG"; break;
 	case V4L2_PIX_FMT_SRGGB14:	descr = "14-bit Bayer RGRG/GBGB"; break;
-	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR (Exp.)"; break;
+	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR"; break;
+	case V4L2_PIX_FMT_SGBRG16:	descr = "16-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG16:	descr = "16-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB16:	descr = "16-bit Bayer RGRG/GBGB"; break;
 	case V4L2_PIX_FMT_SN9C20X_I420:	descr = "GSPCA SN9C20X I420"; break;
 	case V4L2_PIX_FMT_SPCA501:	descr = "GSPCA SPCA501"; break;
 	case V4L2_PIX_FMT_SPCA505:	descr = "GSPCA SPCA505"; break;
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

