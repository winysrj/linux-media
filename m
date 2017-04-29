Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:43999 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936774AbdD2XfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 19:35:11 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 2/3] [media] doc-rst: add IPU3 raw10 bayer pixel format definitions
Date: Sat, 29 Apr 2017 18:34:35 -0500
Message-Id: <edf6dbb7b690a363558e8b70b22eacd3854bae38.1493479141.git.yong.zhi@intel.com>
In-Reply-To: <cover.1493479141.git.yong.zhi@intel.com>
References: <cover.1493479141.git.yong.zhi@intel.com>
In-Reply-To: <cover.1493479141.git.yong.zhi@intel.com>
References: <cover.1493479141.git.yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:

    V4L2_PIX_FMT_IPU3_SBGGR10
    V4L2_PIX_FMT_IPU3_SGBRG10
    V4L2_PIX_FMT_IPU3_SGRBG10
    V4L2_PIX_FMT_IPU3_SRGGB10

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |  1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         | 61 ++++++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index b0f3513..6900d5c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -16,5 +16,6 @@ RGB Formats
     pixfmt-srggb10p
     pixfmt-srggb10alaw8
     pixfmt-srggb10dpcm8
+    pixfmt-srggb10-ipu3
     pixfmt-srggb12
     pixfmt-srggb16
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
new file mode 100644
index 0000000..8a82f30
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
@@ -0,0 +1,61 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2_PIX_FMT_IPU3_SBGGR10:
+.. _V4L2_PIX_FMT_IPU3_SGBRG10:
+.. _V4L2_PIX_FMT_IPU3_SGRBG10:
+.. _V4L2_PIX_FMT_IPU3_SRGGB10:
+
+**********************************************************************************************************************************************
+V4L2_PIX_FMT_IPU3_SBGGR10 ('ip3b'), V4L2_PIX_FMT_IPU3_SGBRG10 ('ip3g'), V4L2_PIX_FMT_IPU3_SGRBG10 ('ip3G'), V4L2_PIX_FMT_IPU3_SRGGB10 ('ip3r')
+**********************************************************************************************************************************************
+
+10-bit Bayer formats
+
+Description
+===========
+
+These four pixel formats are raw sRGB / Bayer formats with 10 bits per
+sample with every 25 pixels packed to 32 bytes leaving 6 most significant 
+bits padding in the last byte. The format is little endian.
+
+In other respects this format is similar to :ref:`V4L2-PIX-FMT-SRGGB10`.
+
+**Byte Order.**
+Each cell is one byte.
+
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{1.3cm}|p{1.0cm}|p{10.9cm}|p{10.9cm}|p{10.9cm}|p{1.0cm}|
+
+.. flat-table::
+
+    * - start + 0:
+      - B\ :sub:`00low`
+      - G\ :sub:`01low` \ (bits 7--2) B\ :sub:`00high`\ (bits 1--0)
+      - B\ :sub:`02low` \ (bits 7--4) G\ :sub:`01high`\ (bits 3--0)
+      - G\ :sub:`03low` \ (bits 7--6) B\ :sub:`02high`\ (bits 5--0)
+      - G\ :sub:`03high`
+    * - start + 5:
+      - G\ :sub:`10low`
+      - R\ :sub:`11low` \ (bits 7--2) G\ :sub:`10high`\ (bits 1--0)
+      - G\ :sub:`12low` \ (bits 7--4) R\ :sub:`11high`\ (bits 3--0)
+      - R\ :sub:`13low` \ (bits 7--6) G\ :sub:`12high`\ (bits 5--0)
+      - R\ :sub:`13high`
+    * - start + 10:
+      - B\ :sub:`20low`
+      - G\ :sub:`21low` \ (bits 7--2) B\ :sub:`20high`\ (bits 1--0)
+      - B\ :sub:`22low` \ (bits 7--4) G\ :sub:`21high`\ (bits 3--0)
+      - G\ :sub:`23low` \ (bits 7--6) B\ :sub:`22high`\ (bits 5--0)
+      - G\ :sub:`23high`
+    * - start + 15:
+      - G\ :sub:`30low`
+      - R\ :sub:`31low` \ (bits 7--2) G\ :sub:`30high`\ (bits 1--0)
+      - G\ :sub:`32low` \ (bits 7--4) R\ :sub:`31high`\ (bits 3--0)
+      - R\ :sub:`33low` \ (bits 7--6) G\ :sub:`32high`\ (bits 5--0)
+      - R\ :sub:`33high`
+
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
-- 
2.7.4
