Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0066.outbound.protection.outlook.com ([104.47.41.66]:36233
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751990AbeECCnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:12 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Jeffrey Mouroux <jmouroux@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 7/8] uapi: media: New fourcc code and rst for 10 bit format
Date: Wed, 2 May 2018 19:42:52 -0700
Message-ID: <dda2d5a5b611ac5ee2a7b475d0a5fbfb9cd55c98.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeffrey Mouroux <jmouroux@xilinx.com>

This patch adds new fourcc code and rst documentation for
YUV420 10 bit format.

Signed-off-by: Jeffrey Mouroux <jmouroux@xilinx.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
Changes in v5:
 - Squashed rst documentation and new pixel format of YUV420 10 bit into single patch

Changes in v4:
 - Added rst documentation for YUV420 10 bit format

 Documentation/media/uapi/v4l/pixfmt-xv15.rst | 134 +++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/yuv-formats.rst |   1 +
 include/uapi/linux/videodev2.h               |   1 +
 3 files changed, 136 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv15.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-xv15.rst b/Documentation/media/uapi/v4l/pixfmt-xv15.rst
new file mode 100644
index 0000000..fc829c3
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-xv15.rst
@@ -0,0 +1,134 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-XV15:
+
+**************************
+V4L2_PIX_FMT_XV15 ('XV15')
+**************************
+
+
+Semi-planar YUV 420 10-bit
+
+
+Description
+===========
+
+This is the 10-bit version of YUV 420 semi-planar format. XV15 is the one
+where chroma plane is contiguous with the luma plane in memory.
+
+Each pixel of YUV 420 contains a single luma component of 10-bits in length.
+Three luma components are stored per word with the remaining two bits serving
+as padding.
+
+The chroma plane is subsampled and is only 1/2 the size of the luma plane.  A
+single chroma component serves two pixels on a given row and is re-used on the
+adjacent row of luma data.
+
+**Data Layout of Luma Plane**
+Each cell is one 32-bit word.
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - word + 0:
+      - X'\ :sub:`[31:30]`
+      - Y'\ :sub:`02 [29:20]`
+      - Y'\ :sub:`01 [19:10]`
+      - Y'\ :sub:`00 [09:00]`
+      -
+    * - word + 1:
+      - X'\ :sub:`[31:30]`
+      - Y'\ :sub:`05 [29:20]`
+      - Y'\ :sub:`04 [19:10]`
+      - Y'\ :sub:`03 [09:00]`
+      -
+    * - word + 2:
+      - X'\ :sub:`[31:30]`
+      - Y'\ :sub:`08 [29:20]`
+      - Y'\ :sub:`07 [19:10]`
+      - Y'\ :sub:`06 [09:00]`
+      -
+
+
+**Data Layout of Chroma Plane**
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - word + 0:
+      - X'\ :sub:`[31:30]`
+      - U'\ :sub:`02 [29:20]`
+      - V'\ :sub:`01 [19:10]`
+      - U'\ :sub:`00 [09:00]`
+      -
+    * - word + 1:
+      - X'\ :sub:`[31:30]`
+      - V'\ :sub:`05 [29:20]`
+      - U'\ :sub:`04 [19:10]`
+      - V'\ :sub:`03 [09:00]`
+      -
+    * - word + 2:
+      - X'\ :sub:`[31:30]`
+      - U'\ :sub:`08 [29:20]`
+      - V'\ :sub:`07 [19:10]`
+      - U'\ :sub:`06 [09:00]`
+      -
+
+**Color Sample Location**
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * -
+      - 0
+      -
+      - 1
+      - 2
+      -
+      - 3
+    * - 0
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 1
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+    * - 2
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 3
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
diff --git a/Documentation/media/uapi/v4l/yuv-formats.rst b/Documentation/media/uapi/v4l/yuv-formats.rst
index 3334ea4..c500bc1 100644
--- a/Documentation/media/uapi/v4l/yuv-formats.rst
+++ b/Documentation/media/uapi/v4l/yuv-formats.rst
@@ -49,6 +49,7 @@ to brightness information.
     pixfmt-nv12
     pixfmt-nv12m
     pixfmt-nv12mt
+    pixfmt-xv15
     pixfmt-nv16
     pixfmt-nv16m
     pixfmt-nv24
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877b..873bafa 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -551,6 +551,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
 #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
+#define V4L2_PIX_FMT_XV15    v4l2_fourcc('X', 'V', '1', '5') /* 32  XY/UV 4:2:0 10-bit */
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
-- 
2.7.4
