Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759614AbcHEKqi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 04/11] doc-rst: Unify documentation of the 8-bit bayer formats
Date: Fri,  5 Aug 2016 13:45:34 +0300
Message-Id: <1470393941-26959-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The other raw bayer formats had a single sample depth dependent definition
whereas the 8-bit formats had one page for each. Unify the documentation
of the 8-bit formats.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/pixfmt-rgb.rst    |  3 -
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst | 81 --------------------------
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst | 81 --------------------------
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst | 81 --------------------------
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst | 41 +++++++------
 5 files changed, 23 insertions(+), 264 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 4b3651c..9cc9808 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -11,9 +11,6 @@ RGB Formats
     :maxdepth: 1
 
     pixfmt-packed-rgb
-    pixfmt-sbggr8
-    pixfmt-sgbrg8
-    pixfmt-sgrbg8
     pixfmt-srggb8
     pixfmt-sbggr16
     pixfmt-srggb10
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
deleted file mode 100644
index db4c523..0000000
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
+++ /dev/null
@@ -1,81 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _V4L2-PIX-FMT-SBGGR8:
-
-****************************
-V4L2_PIX_FMT_SBGGR8 ('BA81')
-****************************
-
-*man V4L2_PIX_FMT_SBGGR8(2)*
-
-Bayer RGB format
-
-
-Description
-===========
-
-This is commonly the native format of digital cameras, reflecting the
-arrangement of sensors on the CCD device. Only one red, green or blue
-value is given for each pixel. Missing components must be interpolated
-from neighbouring pixels. From left to right the first row consists of a
-blue and green value, the second row of a green and red value. This
-scheme repeats to the right and down for every two columns and rows.
-
-**Byte Order.**
-Each cell is one byte.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       2 1 1 1 1
-
-
-    -  .. row 1
-
-       -  start + 0:
-
-       -  B\ :sub:`00`
-
-       -  G\ :sub:`01`
-
-       -  B\ :sub:`02`
-
-       -  G\ :sub:`03`
-
-    -  .. row 2
-
-       -  start + 4:
-
-       -  G\ :sub:`10`
-
-       -  R\ :sub:`11`
-
-       -  G\ :sub:`12`
-
-       -  R\ :sub:`13`
-
-    -  .. row 3
-
-       -  start + 8:
-
-       -  B\ :sub:`20`
-
-       -  G\ :sub:`21`
-
-       -  B\ :sub:`22`
-
-       -  G\ :sub:`23`
-
-    -  .. row 4
-
-       -  start + 12:
-
-       -  G\ :sub:`30`
-
-       -  R\ :sub:`31`
-
-       -  G\ :sub:`32`
-
-       -  R\ :sub:`33`
diff --git a/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
deleted file mode 100644
index 6345c24..0000000
--- a/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
+++ /dev/null
@@ -1,81 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _V4L2-PIX-FMT-SGBRG8:
-
-****************************
-V4L2_PIX_FMT_SGBRG8 ('GBRG')
-****************************
-
-*man V4L2_PIX_FMT_SGBRG8(2)*
-
-Bayer RGB format
-
-
-Description
-===========
-
-This is commonly the native format of digital cameras, reflecting the
-arrangement of sensors on the CCD device. Only one red, green or blue
-value is given for each pixel. Missing components must be interpolated
-from neighbouring pixels. From left to right the first row consists of a
-green and blue value, the second row of a red and green value. This
-scheme repeats to the right and down for every two columns and rows.
-
-**Byte Order.**
-Each cell is one byte.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       2 1 1 1 1
-
-
-    -  .. row 1
-
-       -  start + 0:
-
-       -  G\ :sub:`00`
-
-       -  B\ :sub:`01`
-
-       -  G\ :sub:`02`
-
-       -  B\ :sub:`03`
-
-    -  .. row 2
-
-       -  start + 4:
-
-       -  R\ :sub:`10`
-
-       -  G\ :sub:`11`
-
-       -  R\ :sub:`12`
-
-       -  G\ :sub:`13`
-
-    -  .. row 3
-
-       -  start + 8:
-
-       -  G\ :sub:`20`
-
-       -  B\ :sub:`21`
-
-       -  G\ :sub:`22`
-
-       -  B\ :sub:`23`
-
-    -  .. row 4
-
-       -  start + 12:
-
-       -  R\ :sub:`30`
-
-       -  G\ :sub:`31`
-
-       -  R\ :sub:`32`
-
-       -  G\ :sub:`33`
diff --git a/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
deleted file mode 100644
index 51b7b8e..0000000
--- a/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
+++ /dev/null
@@ -1,81 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _V4L2-PIX-FMT-SGRBG8:
-
-****************************
-V4L2_PIX_FMT_SGRBG8 ('GRBG')
-****************************
-
-*man V4L2_PIX_FMT_SGRBG8(2)*
-
-Bayer RGB format
-
-
-Description
-===========
-
-This is commonly the native format of digital cameras, reflecting the
-arrangement of sensors on the CCD device. Only one red, green or blue
-value is given for each pixel. Missing components must be interpolated
-from neighbouring pixels. From left to right the first row consists of a
-green and blue value, the second row of a red and green value. This
-scheme repeats to the right and down for every two columns and rows.
-
-**Byte Order.**
-Each cell is one byte.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       2 1 1 1 1
-
-
-    -  .. row 1
-
-       -  start + 0:
-
-       -  G\ :sub:`00`
-
-       -  R\ :sub:`01`
-
-       -  G\ :sub:`02`
-
-       -  R\ :sub:`03`
-
-    -  .. row 2
-
-       -  start + 4:
-
-       -  B\ :sub:`10`
-
-       -  G\ :sub:`11`
-
-       -  B\ :sub:`12`
-
-       -  G\ :sub:`13`
-
-    -  .. row 3
-
-       -  start + 8:
-
-       -  G\ :sub:`20`
-
-       -  R\ :sub:`21`
-
-       -  G\ :sub:`22`
-
-       -  R\ :sub:`23`
-
-    -  .. row 4
-
-       -  start + 12:
-
-       -  B\ :sub:`30`
-
-       -  G\ :sub:`31`
-
-       -  B\ :sub:`32`
-
-       -  G\ :sub:`33`
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
index e88de4c..ec58ac5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
@@ -1,25 +1,30 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-SRGGB8:
+.. _v4l2-pix-fmt-sbggr8:
+.. _v4l2-pix-fmt-sgbrg8:
+.. _v4l2-pix-fmt-sgrbg8:
 
-****************************
-V4L2_PIX_FMT_SRGGB8 ('RGGB')
-****************************
+***************************************************************************************************************************
+V4L2_PIX_FMT_SRGGB8 ('RGGB'), V4L2_PIX_FMT_SGRBG8 ('GRBG'), V4L2_PIX_FMT_SGBRG8 ('GBRG'), V4L2_PIX_FMT_SBGGR8 ('BA81'),
+***************************************************************************************************************************
 
 *man V4L2_PIX_FMT_SRGGB8(2)*
 
-Bayer RGB format
+V4L2_PIX_FMT_SGRBG8
+V4L2_PIX_FMT_SGBRG8
+V4L2_PIX_FMT_SBGGR8
+8-bit Bayer formats
 
 
 Description
 ===========
 
-This is commonly the native format of digital cameras, reflecting the
-arrangement of sensors on the CCD device. Only one red, green or blue
-value is given for each pixel. Missing components must be interpolated
-from neighbouring pixels. From left to right the first row consists of a
-red and green value, the second row of a green and blue value. This
-scheme repeats to the right and down for every two columns and rows.
+These four pixel formats are raw sRGB / Bayer formats with 8 bits per
+sample. Each sample is stored in a byte. Each n-pixel row contains n/2
+green samples and n/2 blue or red samples, with alternating red and
+blue rows. They are conventionally described as GRGR... BGBG...,
+RGRG... GBGB..., etc. Below is an example of one of these formats:
 
 **Byte Order.**
 Each cell is one byte.
@@ -36,11 +41,11 @@ Each cell is one byte.
 
        -  start + 0:
 
-       -  R\ :sub:`00`
+       -  B\ :sub:`00`
 
        -  G\ :sub:`01`
 
-       -  R\ :sub:`02`
+       -  B\ :sub:`02`
 
        -  G\ :sub:`03`
 
@@ -50,21 +55,21 @@ Each cell is one byte.
 
        -  G\ :sub:`10`
 
-       -  B\ :sub:`11`
+       -  R\ :sub:`11`
 
        -  G\ :sub:`12`
 
-       -  B\ :sub:`13`
+       -  R\ :sub:`13`
 
     -  .. row 3
 
        -  start + 8:
 
-       -  R\ :sub:`20`
+       -  B\ :sub:`20`
 
        -  G\ :sub:`21`
 
-       -  R\ :sub:`22`
+       -  B\ :sub:`22`
 
        -  G\ :sub:`23`
 
@@ -74,8 +79,8 @@ Each cell is one byte.
 
        -  G\ :sub:`30`
 
-       -  B\ :sub:`31`
+       -  R\ :sub:`31`
 
        -  G\ :sub:`32`
 
-       -  B\ :sub:`33`
+       -  R\ :sub:`33`
-- 
2.7.4

