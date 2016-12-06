Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33150 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbcLFQIQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 11:08:16 -0500
Received: by mail-pf0-f195.google.com with SMTP id 144so18946900pfv.0
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 08:08:16 -0800 (PST)
From: evgeni.raikhel@gmail.com
To: linux-media@vger.kernel.org
Cc: sergey.dorodnicov@intel.com, eliezer.tamir@intel.com,
        evgeni.raikhel@intel.com, laurent.pinchart@ideasonboard.com,
        Aviv Greenberg <avivgr@gmail.com>
Subject: [PATCH 1/2 v2] media: Adding 'INZI' Depth data format to V4L2_API.
Date: Tue,  6 Dec 2016 18:04:34 +0200
Message-Id: <1481040275-18392-2-git-send-email-evgeni.raikhel@intel.com>
In-Reply-To: <1481040275-18392-1-git-send-email-evgeni.raikhel@intel.com>
References: <1481040275-18392-1-git-send-email-evgeni.raikhel@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aviv Greenberg <avivgr@gmail.com>

This is a proprietary multi-plane format that provides
Infrared and Depth data.
The format is utilized by Intel SR300 depth camera.

The patch comprises of the format definition
to be introduced into V4L2_API via  include/uapi/linux/videodev2.h,
and the pixel format description to be added to
Documentation/media/uapi/v4l folder, under 'depth-formats' section

Signed-off-by: Aviv Greenberg <avivgr@gmail.com>
Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 83 ++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h                 |  1 +
 3 files changed, 85 insertions(+)
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
index 000000000000..5adc2b679be4
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
@@ -0,0 +1,83 @@
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
+
+
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

