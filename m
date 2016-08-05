Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38693 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759612AbcHEKqh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 07/11] doc-rst: Add 14-bit raw bayer pixel format definitions
Date: Fri,  5 Aug 2016 13:45:37 +0300
Message-Id: <1470393941-26959-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:

	V4L2_PIX_FMT_SBGGR14
	V4L2_PIX_FMT_SGBRG14
	V4L2_PIX_FMT_SGRBG14
	V4L2_PIX_FMT_SRGGB14

Signed-off-by: Jouni Ukkonen <jouni.ukkonen@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-rgb.rst     |   1 +
 Documentation/media/uapi/v4l/pixfmt-srggb14.rst | 122 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c            |   4 +
 include/uapi/linux/videodev2.h                  |   4 +
 4 files changed, 131 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 81412f7..548551a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -19,3 +19,4 @@ RGB Formats
     pixfmt-srggb10dpcm8
     pixfmt-srggb12
     pixfmt-srggb12p
+    pixfmt-srggb14
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb14.rst b/Documentation/media/uapi/v4l/pixfmt-srggb14.rst
new file mode 100644
index 0000000..829ce97
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb14.rst
@@ -0,0 +1,122 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-SRGGB14:
+.. _v4l2-pix-fmt-sbggr14:
+.. _v4l2-pix-fmt-sgbrg14:
+.. _v4l2-pix-fmt-sgrbg14:
+
+
+***************************************************************************************************************************
+V4L2_PIX_FMT_SRGGB14 ('RG14'), V4L2_PIX_FMT_SGRBG14 ('GR14'), V4L2_PIX_FMT_SGBRG14 ('GB14'), V4L2_PIX_FMT_SBGGR14 ('BG14'),
+***************************************************************************************************************************
+
+*man V4L2_PIX_FMT_SRGGB14(2)*
+
+V4L2_PIX_FMT_SGRBG14
+V4L2_PIX_FMT_SGBRG14
+V4L2_PIX_FMT_SBGGR14
+14-bit Bayer formats expanded to 16 bits
+
+
+Description
+===========
+
+These four pixel formats are raw sRGB / Bayer formats with 14 bits per
+colour. Each sample is stored in a 16-bit word, with two unused high
+bits filled with zeros. Each n-pixel row contains n/2 green samples
+and n/2 blue or red samples, with alternating red and blue rows. Bytes
+are stored in memory in little endian order. They are conventionally
+described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an
+example of one of these formats:
+
+**Byte Order.**
+Each cell is one byte, the two most significant bits in the high bytes are
+zero.
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
index ebce910..29d9f8f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1233,6 +1233,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_SGBRG12P:	descr = "12-bit Bayer GBGB/RGRG Packed"; break;
 	case V4L2_PIX_FMT_SGRBG12P:	descr = "12-bit Bayer GRGR/BGBG Packed"; break;
 	case V4L2_PIX_FMT_SRGGB12P:	descr = "12-bit Bayer RGRG/GBGB Packed"; break;
+	case V4L2_PIX_FMT_SBGGR14:	descr = "14-bit Bayer BGBG/GRGR"; break;
+	case V4L2_PIX_FMT_SGBRG14:	descr = "14-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG14:	descr = "14-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB14:	descr = "14-bit Bayer RGRG/GBGB"; break;
 	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR (Exp.)"; break;
 	case V4L2_PIX_FMT_SN9C20X_I420:	descr = "GSPCA SN9C20X I420"; break;
 	case V4L2_PIX_FMT_SPCA501:	descr = "GSPCA SPCA501"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c9b0055..dd7b29d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -583,6 +583,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
 #define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
 #define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
+#define V4L2_PIX_FMT_SBGGR14 v4l2_fourcc('B', 'G', '1', '4') /* 14  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG14 v4l2_fourcc('G', 'B', '1', '4') /* 14  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG14 v4l2_fourcc('G', 'R', '1', '4') /* 14  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB14 v4l2_fourcc('R', 'G', '1', '4') /* 14  RGRG.. GBGB.. */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
-- 
2.7.4

