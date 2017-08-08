Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40232 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752074AbdHHNay (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:30:54 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v4 01/21] v4l: Add packed Bayer raw12 pixel formats
Date: Tue,  8 Aug 2017 16:29:58 +0300
Message-Id: <1502199018-28250-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

These formats are compressed 12-bit raw bayer formats with four different
pixel orders. They are similar to 10-bit variants. The formats added by
this patch are

	V4L2_PIX_FMT_SBGGR12P
	V4L2_PIX_FMT_SGBRG12P
	V4L2_PIX_FMT_SGRBG12P
	V4L2_PIX_FMT_SRGGB12P

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-rgb.rst      |   1 +
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst | 104 +++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c             |  12 ++-
 include/uapi/linux/videodev2.h                   |   5 ++
 4 files changed, 118 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index b0f3513..4cc2719 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -17,4 +17,5 @@ RGB Formats
     pixfmt-srggb10alaw8
     pixfmt-srggb10dpcm8
     pixfmt-srggb12
+    pixfmt-srggb12p
     pixfmt-srggb16
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
new file mode 100644
index 0000000..c3c19f9e
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
@@ -0,0 +1,104 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-SRGGB12P:
+.. _v4l2-pix-fmt-sbggr12p:
+.. _v4l2-pix-fmt-sgbrg12p:
+.. _v4l2-pix-fmt-sgrbg12p:
+
+*******************************************************************************************************************************
+V4L2_PIX_FMT_SRGGB12P ('pRAA'), V4L2_PIX_FMT_SGRBG12P ('pgAA'), V4L2_PIX_FMT_SGBRG12P ('pGAA'), V4L2_PIX_FMT_SBGGR12P ('pBAA'),
+*******************************************************************************************************************************
+
+
+12-bit packed Bayer formats
+
+
+Description
+===========
+
+These four pixel formats are packed raw sRGB / Bayer formats with 12
+bits per colour. Every two consecutive samples are packed into three
+bytes. Each of the first two bytes contain the 8 high order bits of
+the pixels, and the third byte contains the four least significants
+bits of each pixel, in the same order.
+
+Each n-pixel row contains n/2 green samples and n/2 blue or red
+samples, with alternating green-red and green-blue rows. They are
+conventionally described as GRGR... BGBG..., RGRG... GBGB..., etc.
+Below is an example of a small V4L2_PIX_FMT_SBGGR12P image:
+
+**Byte Order.**
+Each cell is one byte.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1 1 1
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
+       -  G\ :sub:`01low`\ (bits 7--4) B\ :sub:`00low`\ (bits 3--0)
+
+       -  B\ :sub:`02high`
+
+       -  G\ :sub:`03high`
+
+       -  G\ :sub:`03low`\ (bits 7--4) B\ :sub:`02low`\ (bits 3--0)
+
+    -  .. row 2
+
+       -  start + 6:
+
+       -  G\ :sub:`10high`
+
+       -  R\ :sub:`11high`
+
+       -  R\ :sub:`11low`\ (bits 7--4) G\ :sub:`10low`\ (bits 3--0)
+
+       -  G\ :sub:`12high`
+
+       -  R\ :sub:`13high`
+
+       -  R\ :sub:`13low`\ (bits 3--2) G\ :sub:`12low`\ (bits 3--0)
+
+    -  .. row 3
+
+       -  start + 12:
+
+       -  B\ :sub:`20high`
+
+       -  G\ :sub:`21high`
+
+       -  G\ :sub:`21low`\ (bits 7--4) B\ :sub:`20low`\ (bits 3--0)
+
+       -  B\ :sub:`22high`
+
+       -  G\ :sub:`23high`
+
+       -  G\ :sub:`23low`\ (bits 7--4) B\ :sub:`22low`\ (bits 3--0)
+
+    -  .. row 4
+
+       -  start + 18:
+
+       -  G\ :sub:`30high`
+
+       -  R\ :sub:`31high`
+
+       -  R\ :sub:`31low`\ (bits 7--4) G\ :sub:`30low`\ (bits 3--0)
+
+       -  G\ :sub:`32high`
+
+       -  R\ :sub:`33high`
+
+       -  R\ :sub:`33low`\ (bits 3--2) G\ :sub:`32low`\ (bits 3--0)
+
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index cab63bb..b60a6b0 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1195,10 +1195,6 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_SGBRG10:	descr = "10-bit Bayer GBGB/RGRG"; break;
 	case V4L2_PIX_FMT_SGRBG10:	descr = "10-bit Bayer GRGR/BGBG"; break;
 	case V4L2_PIX_FMT_SRGGB10:	descr = "10-bit Bayer RGRG/GBGB"; break;
-	case V4L2_PIX_FMT_SBGGR12:	descr = "12-bit Bayer BGBG/GRGR"; break;
-	case V4L2_PIX_FMT_SGBRG12:	descr = "12-bit Bayer GBGB/RGRG"; break;
-	case V4L2_PIX_FMT_SGRBG12:	descr = "12-bit Bayer GRGR/BGBG"; break;
-	case V4L2_PIX_FMT_SRGGB12:	descr = "12-bit Bayer RGRG/GBGB"; break;
 	case V4L2_PIX_FMT_SBGGR10P:	descr = "10-bit Bayer BGBG/GRGR Packed"; break;
 	case V4L2_PIX_FMT_SGBRG10P:	descr = "10-bit Bayer GBGB/RGRG Packed"; break;
 	case V4L2_PIX_FMT_SGRBG10P:	descr = "10-bit Bayer GRGR/BGBG Packed"; break;
@@ -1211,6 +1207,14 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_SGBRG10DPCM8:	descr = "8-bit Bayer GBGB/RGRG (DPCM)"; break;
 	case V4L2_PIX_FMT_SGRBG10DPCM8:	descr = "8-bit Bayer GRGR/BGBG (DPCM)"; break;
 	case V4L2_PIX_FMT_SRGGB10DPCM8:	descr = "8-bit Bayer RGRG/GBGB (DPCM)"; break;
+	case V4L2_PIX_FMT_SBGGR12:	descr = "12-bit Bayer BGBG/GRGR"; break;
+	case V4L2_PIX_FMT_SGBRG12:	descr = "12-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG12:	descr = "12-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB12:	descr = "12-bit Bayer RGRG/GBGB"; break;
+	case V4L2_PIX_FMT_SBGGR12P:	descr = "12-bit Bayer BGBG/GRGR Packed"; break;
+	case V4L2_PIX_FMT_SGBRG12P:	descr = "12-bit Bayer GBGB/RGRG Packed"; break;
+	case V4L2_PIX_FMT_SGRBG12P:	descr = "12-bit Bayer GRGR/BGBG Packed"; break;
+	case V4L2_PIX_FMT_SRGGB12P:	descr = "12-bit Bayer RGRG/GBGB Packed"; break;
 	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR"; break;
 	case V4L2_PIX_FMT_SGBRG16:	descr = "16-bit Bayer GBGB/RGRG"; break;
 	case V4L2_PIX_FMT_SGRBG16:	descr = "16-bit Bayer GRGR/BGBG"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45cf735..185d6a0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -603,6 +603,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
+	/* 12bit raw bayer packed, 6 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR12P v4l2_fourcc('p', 'B', 'C', 'C')
+#define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
+#define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
+#define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGBRG16 v4l2_fourcc('G', 'B', '1', '6') /* 16  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG16 v4l2_fourcc('G', 'R', '1', '6') /* 16  GRGR.. BGBG.. */
-- 
2.7.4
