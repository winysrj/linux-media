Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36239 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933015AbdBHIia (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 03:38:30 -0500
Received: by mail-pf0-f196.google.com with SMTP id 19so11191907pfo.3
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2017 00:38:29 -0800 (PST)
From: evgeni.raikhel@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, guennadi.liakhovetski@intel.com,
        eliezer.tamir@intel.com, sergey.dorodnicov@intel.com,
        eraikhel <evgeni.raikhel@intel.com>
Subject: [PATCH v2 1/2] Documentation: Intel SR300 Depth camera INZI format
Date: Wed,  8 Feb 2017 10:34:23 +0200
Message-Id: <1486542864-5832-1-git-send-email-evgeni.raikhel@intel.com>
In-Reply-To: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: eraikhel <evgeni.raikhel@intel.com>

Provide the frame structure and data layout of V4L2-PIX-FMT-INZI
format utilized by Intel SR300 Depth camera.

Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 ++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h                 |  1 +
 3 files changed, 83 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst

diff --git a/Documentation/media/uapi/v4l/depth-formats.rst b/Documentation/media/uapi/v4l/depth-formats.rst
index 82f183870aae..c755be0e4d2a 100644
--- a/Documentation/media/uapi/v4l/depth-formats.rst
+++ b/Documentation/media/uapi/v4l/depth-formats.rst
@@ -13,3 +13,4 @@ Depth data provides distance to points, mapped onto the image plane
     :maxdepth: 1
 
     pixfmt-z16
+    pixfmt-inzi
diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
new file mode 100644
index 000000000000..9849e799f205
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
@@ -0,0 +1,81 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-INZI:
+
+**************************
+V4L2_PIX_FMT_INZI ('INZI')
+**************************
+
+Infrared 10-bit linked with Depth 16-bit images
+
+
+Description
+===========
+
+Proprietary multi-planar format used by Intel SR300 Depth cameras, comprise of
+Infrared image followed by Depth data. The pixel definition is 32-bpp,
+with the Depth and Infrared Data split into separate continuous planes of
+identical dimensions.
+
+
+
+The first plane - Infrared data - is stored according to
+:ref:`V4L2_PIX_FMT_Y10 <V4L2-PIX-FMT-Y10>` greyscale format.
+Each pixel is 16-bit cell, with actual data stored in the 10 LSBs
+with values in range 0 to 1023.
+The six remaining MSBs are padded with zeros.
+
+
+The second plane provides 16-bit per-pixel Depth data arranged in
+:ref:`V4L2-PIX-FMT-Z16 <V4L2-PIX-FMT-Z16>` format.
+
+
+**Frame Structure.**
+Each cell is a 16-bit word with more significant data stored at higher
+memory address (byte order is little-endian).
+
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 1
+    :widths:    1 1 1 1 1 1
+
+    * - Ir\ :sub:`0,0`
+      - Ir\ :sub:`0,1`
+      - Ir\ :sub:`0,2`
+      - ...
+      - ...
+      - ...
+    * - :cspan:`5` ...
+    * - :cspan:`5` Infrared Data
+    * - :cspan:`5` ...
+    * - ...
+      - ...
+      - ...
+      - Ir\ :sub:`n-1,n-3`
+      - Ir\ :sub:`n-1,n-2`
+      - Ir\ :sub:`n-1,n-1`
+    * - Depth\ :sub:`0,0`
+      - Depth\ :sub:`0,1`
+      - Depth\ :sub:`0,2`
+      - ...
+      - ...
+      - ...
+    * - :cspan:`5` ...
+    * - :cspan:`5` Depth Data
+    * - :cspan:`5` ...
+    * - ...
+      - ...
+      - ...
+      - Depth\ :sub:`n-1,n-3`
+      - Depth\ :sub:`n-1,n-2`
+      - Depth\ :sub:`n-1,n-1`
+
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 46e8a2e369f9..04263c59b93f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -662,6 +662,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
+#define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Infrared 10-bit linked with Depth 16-bit */
 
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
-- 
2.7.4

