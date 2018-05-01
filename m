Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0056.outbound.protection.outlook.com ([104.47.34.56]:43232
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753576AbeEABf1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 21:35:27 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Jeffrey Mouroux <jmouroux@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v4 04/10] Documentation: uapi: media: v4l: New pixel format
Date: Mon, 30 Apr 2018 18:35:07 -0700
Message-ID: <d2989772ba37bd4d788342ed3f659c4689cebcb5.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeffrey Mouroux <jmouroux@xilinx.com>

These descriptions are for YUV 420 and YUV 422 10 bit
formats.

Signed-off-by: Jeffrey Mouroux <jmouroux@xilinx.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
 Documentation/media/uapi/v4l/pixfmt-xv15.rst | 135 ++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-xv20.rst | 136 +++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/yuv-formats.rst |   2 +
 3 files changed, 273 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv15.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv20.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-xv15.rst b/Documentation/media/uapi/v4l/pixfmt-xv15.rst
new file mode 100644
index 0000000..313d056
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-xv15.rst
@@ -0,0 +1,135 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-XV15:
+.. _V4L2-PIX-FMT-XV15M:
+
+*******************************************************
+V4L2_PIX_FMT_XV15 ('XV15'), V4L2_PIX_FMT_XV15 ('XV15M')
+*******************************************************
+
+Semi-planar YUV 420 10-bit
+
+
+Description
+===========
+
+This is the 10-bit version of YUV 420 semi-planar format.
+XV15M differs from XV15 insofar as the chroma plane is not contiguous with the
+luma plane in memory.
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
diff --git a/Documentation/media/uapi/v4l/pixfmt-xv20.rst b/Documentation/media/uapi/v4l/pixfmt-xv20.rst
new file mode 100644
index 0000000..fe9dac2
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-xv20.rst
@@ -0,0 +1,136 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-XV20:
+.. _V4L2-PIX-FMT-XV20M:
+
+*******************************************************
+V4L2_PIX_FMT_XV20 ('XV20'), V4L2_PIX_FMT_XV20 ('XV20M')
+*******************************************************
+
+Semi-planar YUV422 10-bit
+
+
+Description
+===========
+
+This is the 10-bit version of YUV 422 semi-planar format.
+XV20M differs from XV20 insofar as the chroma plane is not contiquous with the
+luma plane in memory.
+
+
+Each pixel of YUV 422 contains a single luma component of 10-bits in length.
+Three luma components are stored per word with the remaining two bits serving
+as padding.
+
+The chroma plane is subsampled in and is the size of the luma plane.  A single
+chroma component (U or V) serves two pixels on a given row.
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
index 3334ea4..0e6b44f 100644
--- a/Documentation/media/uapi/v4l/yuv-formats.rst
+++ b/Documentation/media/uapi/v4l/yuv-formats.rst
@@ -49,7 +49,9 @@ to brightness information.
     pixfmt-nv12
     pixfmt-nv12m
     pixfmt-nv12mt
+    pixfmt-xv15
     pixfmt-nv16
     pixfmt-nv16m
+    pixfmt-xv20
     pixfmt-nv24
     pixfmt-m420
-- 
2.1.1
