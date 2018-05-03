Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:63695
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751969AbeECCnQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:16 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 4/8] media-bus: uapi: Add YCrCb 420 media bus format and rst
Date: Wed, 2 May 2018 19:42:49 -0700
Message-ID: <b6b590908656b4e96be76950aa7fb9054d97a6d5.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds YUV 420 media bus format. VYYUYY8_1X24
is an approximate way to descrive the pixels sent over
the bus.

This patch also contain rst documentation for media bus format.

Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
Changes in v3:
 - Fixed table alignment issue in rst file. Ensured the output is proper uisng
   'make pdfdocs'

Changes in v2:
 - Added rst documentation for MEDIA_BUS_FMT_VYYUYY8_1X24

 Documentation/media/uapi/v4l/subdev-formats.rst | 38 ++++++++++++++++++++++++-
 include/uapi/linux/media-bus-format.h           |  3 +-
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 9fcabe7..904c52b 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -6640,6 +6640,43 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-VYYUYY8-1X24:
+
+      - MEDIA_BUS_FMT_VYYUYY8_1X24
+      - 0x202c
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
     * .. _MEDIA-BUS-FMT-YUV10-1X30:
 
       - MEDIA_BUS_FMT_YUV10_1X30
@@ -7287,7 +7324,6 @@ The following table list existing packed 48bit wide YUV formats.
       - y\ :sub:`1`
       - y\ :sub:`0`
 
-
 .. raw:: latex
 
 	\endgroup
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 9e35117..ade7e9d 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -62,7 +62,7 @@
 #define MEDIA_BUS_FMT_RGB121212_1X36		0x1019
 #define MEDIA_BUS_FMT_RGB161616_1X48		0x101a
 
-/* YUV (including grey) - next is	0x202c */
+/* YUV (including grey) - next is	0x202d */
 #define MEDIA_BUS_FMT_Y8_1X8			0x2001
 #define MEDIA_BUS_FMT_UV8_1X8			0x2015
 #define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
@@ -106,6 +106,7 @@
 #define MEDIA_BUS_FMT_YUV12_1X36		0x2029
 #define MEDIA_BUS_FMT_YUV16_1X48		0x202a
 #define MEDIA_BUS_FMT_UYYVYY16_0_5X48		0x202b
+#define MEDIA_BUS_FMT_VYYUYY8_1X24		0x202c
 
 /* Bayer - next is	0x3021 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
-- 
2.7.4
