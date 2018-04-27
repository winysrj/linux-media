Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:58139 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbeD0Lla (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 07:41:30 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hverkuil@xs4all.nl, sakari.ailus@iki.fi,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 1/2] media: v4l: Add new 2X8 10-bit grayscale media bus code
Date: Fri, 27 Apr 2018 14:40:38 +0300
Message-Id: <1524829239-4664-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1524829239-4664-1-git-send-email-todor.tomov@linaro.org>
References: <1524829239-4664-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code will be called MEDIA_BUS_FMT_Y10_2X8_PADHI_LE.
It is similar to MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE
but MEDIA_BUS_FMT_Y10_2X8_PADHI_LE describes grayscale
data.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 72 +++++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h           |  3 +-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 9fcabe7..c4fb0bf 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -4315,6 +4315,78 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-Y10-2X8-PADHI_LE:
+
+      - MEDIA_BUS_FMT_Y10_2X8_PADHI_LE
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
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - 0
+      - 0
+      - 0
+      - 0
+      - 0
+      - 0
+      - y\ :sub:`9`
+      - y\ :sub:`8`
     * .. _MEDIA-BUS-FMT-UYVY10-2X10:
 
       - MEDIA_BUS_FMT_UYVY10_2X10
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 9e35117..d6a5a3b 100644
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
@@ -74,6 +74,7 @@
 #define MEDIA_BUS_FMT_YUYV8_2X8			0x2008
 #define MEDIA_BUS_FMT_YVYU8_2X8			0x2009
 #define MEDIA_BUS_FMT_Y10_1X10			0x200a
+#define MEDIA_BUS_FMT_Y10_2X8_PADHI_LE		0x202c
 #define MEDIA_BUS_FMT_UYVY10_2X10		0x2018
 #define MEDIA_BUS_FMT_VYUY10_2X10		0x2019
 #define MEDIA_BUS_FMT_YUYV10_2X10		0x200b
-- 
2.7.4
