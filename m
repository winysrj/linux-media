Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25742 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbdFGBey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 21:34:54 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hverkuil@xs4all.nl, hyungwoo.yang@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v2 2/3] [media] doc-rst: add IPU3 raw10 bayer pixel format definitions
Date: Tue,  6 Jun 2017 20:34:38 -0500
Message-Id: <1496799279-8774-3-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
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
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         | 62 ++++++++++++++++++++++
 2 files changed, 63 insertions(+)
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
index 0000000..618e24a
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
@@ -0,0 +1,62 @@
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
+These four pixel formats are used by Intel IPU3 driver, they are raw
+sRGB / Bayer formats with 10 bits per sample with every 25 pixels packed
+to 32 bytes leaving 6 most significant bits padding in the last byte.
+The format is little endian.
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
