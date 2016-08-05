Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbcHEKqp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 08/11] doc-rst: Add packed Bayer raw14 pixel formats
Date: Fri,  5 Aug 2016 13:45:38 +0300
Message-Id: <1470393941-26959-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These formats are compressed 14-bit raw bayer formats with four different
pixel orders. They are similar to 10-bit variants. The formats added by
this patch are

	V4L2_PIX_FMT_SBGGR14P
	V4L2_PIX_FMT_SGBRG14P
	V4L2_PIX_FMT_SGRBG14P
	V4L2_PIX_FMT_SRGGB14P

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-rgb.rst      |   1 +
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst | 127 +++++++++++++++++++++++
 include/uapi/linux/videodev2.h                   |   5 +
 3 files changed, 133 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 548551a..69f11ab 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -20,3 +20,4 @@ RGB Formats
     pixfmt-srggb12
     pixfmt-srggb12p
     pixfmt-srggb14
+    pixfmt-srggb14p
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
new file mode 100644
index 0000000..88d20c0
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
@@ -0,0 +1,127 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-SRGGB14P:
+.. _v4l2-pix-fmt-sbggr14p:
+.. _v4l2-pix-fmt-sgbrg14p:
+.. _v4l2-pix-fmt-sgrbg14p:
+
+*******************************************************************************************************************************
+V4L2_PIX_FMT_SRGGB14P ('pRCC'), V4L2_PIX_FMT_SGRBG14P ('pgCC'), V4L2_PIX_FMT_SGBRG14P ('pGCC'), V4L2_PIX_FMT_SBGGR14P ('pBCC'),
+*******************************************************************************************************************************
+
+*man V4L2_PIX_FMT_SRGGB14P(2)*
+
+V4L2_PIX_FMT_SGRBG14P
+V4L2_PIX_FMT_SGBRG14P
+V4L2_PIX_FMT_SBGGR14P
+14-bit packed Bayer formats
+
+
+Description
+===========
+
+These four pixel formats are packed raw sRGB / Bayer formats with 14
+bits per colour. Every four consecutive samples are packed into seven
+bytes. Each of the first four bytes contain the eight high order bits
+of the pixels, and the three following bytes contains the six least
+significants bits of each pixel, in the same order.
+
+Each n-pixel row contains n/2 green samples and n/2 blue or red samples,
+with alternating green-red and green-blue rows. They are conventionally
+described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
+of one of these formats:
+
+**Byte Order.**
+Each cell is one byte.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1 1 1 1
+
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  B\ :sub:`00high`
+
+       -  G\ :sub:`01high`
+
+       -  B\ :sub:`02high`
+
+       -  G\ :sub:`03high`
+
+       -  G\ :sub:`01low bits 1--0`\ (bits 7--6)
+	  B\ :sub:`00low bits 5--0`\ (bits 5--0)
+
+       -  R\ :sub:`02low bits 3--0`\ (bits 7--4)
+	  G\ :sub:`01low bits 5--2`\ (bits 3--0)
+
+       -  G\ :sub:`03low bits 5--0`\ (bits 7--2)
+	  R\ :sub:`02low bits 5--4`\ (bits 1--0)
+
+    -  .. row 2
+
+       -  start + 7:
+
+       -  G\ :sub:`00high`
+
+       -  R\ :sub:`01high`
+
+       -  G\ :sub:`02high`
+
+       -  R\ :sub:`03high`
+
+       -  R\ :sub:`01low bits 1--0`\ (bits 7--6)
+	  G\ :sub:`00low bits 5--0`\ (bits 5--0)
+
+       -  G\ :sub:`02low bits 3--0`\ (bits 7--4)
+	  R\ :sub:`01low bits 5--2`\ (bits 3--0)
+
+       -  R\ :sub:`03low bits 5--0`\ (bits 7--2)
+	  G\ :sub:`02low bits 5--4`\ (bits 1--0)
+
+    -  .. row 3
+
+       -  start + 14
+
+       -  B\ :sub:`20high`
+
+       -  G\ :sub:`21high`
+
+       -  B\ :sub:`22high`
+
+       -  G\ :sub:`23high`
+
+       -  G\ :sub:`21low bits 1--0`\ (bits 7--6)
+	  B\ :sub:`20low bits 5--0`\ (bits 5--0)
+
+       -  R\ :sub:`22low bits 3--0`\ (bits 7--4)
+	  G\ :sub:`21low bits 5--2`\ (bits 3--0)
+
+       -  G\ :sub:`23low bits 5--0`\ (bits 7--2)
+	  R\ :sub:`22low bits 5--4`\ (bits 1--0)
+
+    -  .. row 4
+
+       -  start + 21
+
+       -  G\ :sub:`30high`
+
+       -  R\ :sub:`31high`
+
+       -  G\ :sub:`32high`
+
+       -  R\ :sub:`33high`
+
+       -  R\ :sub:`31low bits 1--0`\ (bits 7--6)
+	  G\ :sub:`30low bits 5--0`\ (bits 5--0)
+
+       -  G\ :sub:`32low bits 3--0`\ (bits 7--4)
+	  R\ :sub:`31low bits 5--2`\ (bits 3--0)
+
+       -  R\ :sub:`33low bits 5--0`\ (bits 7--2)
+	  G\ :sub:`32low bits 5--4`\ (bits 1--0)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index dd7b29d..32e9e74 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -587,6 +587,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG14 v4l2_fourcc('G', 'B', '1', '4') /* 14  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG14 v4l2_fourcc('G', 'R', '1', '4') /* 14  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB14 v4l2_fourcc('R', 'G', '1', '4') /* 14  RGRG.. GBGB.. */
+	/* 14bit raw bayer packed, 7 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR14P v4l2_fourcc('p', 'B', 'E', 'E')
+#define V4L2_PIX_FMT_SGBRG14P v4l2_fourcc('p', 'G', 'E', 'E')
+#define V4L2_PIX_FMT_SGRBG14P v4l2_fourcc('p', 'g', 'E', 'E')
+#define V4L2_PIX_FMT_SRGGB14P v4l2_fourcc('p', 'R', 'E', 'E')
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
-- 
2.7.4

