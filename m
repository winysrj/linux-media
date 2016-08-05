Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759581AbcHEKqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:44 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 09/11] media: Add 1X16 16-bit raw bayer media bus code definitions
Date: Fri,  5 Aug 2016 13:45:39 +0300
Message-Id: <1470393941-26959-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The codes will be called:

	MEDIA_BUS_FMT_SBGGR16_1X16
	MEDIA_BUS_FMT_SGBRG16_1X16
	MEDIA_BUS_FMT_SGRBG16_1X16
	MEDIA_BUS_FMT_SRGGB16_1X16

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 290 +++++++++++++++++++++++-
 include/uapi/linux/media-bus-format.h           |   6 +-
 2 files changed, 294 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 238ecfc..6c1c5af 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -2782,7 +2782,7 @@ organization is given as an example for the first pixel only.
        -  Code
 
        -
-       -  :cspan:`13` Data organization
+       -  :cspan:`15` Data organization
 
     -  .. row 2
 
@@ -2790,6 +2790,10 @@ organization is given as an example for the first pixel only.
        -
        -  Bit
 
+       -  15
+
+       -  14
+
        -  13
 
        -  12
@@ -2837,6 +2841,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -2872,6 +2880,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2907,6 +2919,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2942,6 +2958,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -2977,6 +2997,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3012,6 +3036,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3047,6 +3075,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3082,6 +3114,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3117,6 +3153,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3152,6 +3192,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3187,6 +3231,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3222,6 +3270,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3257,6 +3309,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3290,6 +3346,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3325,6 +3385,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3358,6 +3422,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3393,6 +3461,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3426,6 +3498,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3461,6 +3537,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3494,6 +3574,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3525,6 +3609,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3560,6 +3648,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3595,6 +3687,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3630,6 +3726,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`9`
 
        -  r\ :sub:`8`
@@ -3661,6 +3761,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`11`
 
        -  b\ :sub:`10`
@@ -3696,6 +3800,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3731,6 +3839,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3766,6 +3878,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`11`
 
        -  r\ :sub:`10`
@@ -3797,6 +3913,10 @@ organization is given as an example for the first pixel only.
        -  0x3019
 
        -
+       -  -
+
+       -  -
+
        -  b\ :sub:`13`
 
        -  b\ :sub:`12`
@@ -3832,6 +3952,10 @@ organization is given as an example for the first pixel only.
        -  0x301a
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`13`
 
        -  g\ :sub:`12`
@@ -3867,6 +3991,10 @@ organization is given as an example for the first pixel only.
        -  0x301b
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`13`
 
        -  g\ :sub:`12`
@@ -3902,6 +4030,166 @@ organization is given as an example for the first pixel only.
        -  0x301c
 
        -
+       -  -
+
+       -  -
+
+       -  r\ :sub:`13`
+
+       -  r\ :sub:`12`
+
+       -  r\ :sub:`11`
+
+       -  r\ :sub:`10`
+
+       -  r\ :sub:`9`
+
+       -  r\ :sub:`8`
+
+       -  r\ :sub:`7`
+
+       -  r\ :sub:`6`
+
+       -  r\ :sub:`5`
+
+       -  r\ :sub:`4`
+
+       -  r\ :sub:`3`
+
+       -  r\ :sub:`2`
+
+       -  r\ :sub:`1`
+
+       -  r\ :sub:`0`
+
+    -  .. _MEDIA-BUS-FMT-SBGGR16-1X16:
+
+       -  MEDIA_BUS_FMT_SBGGR16_1X16
+
+       -  0x301d
+
+       -
+       -  b\ :sub:`15`
+
+       -  b\ :sub:`14`
+
+       -  b\ :sub:`13`
+
+       -  b\ :sub:`12`
+
+       -  b\ :sub:`11`
+
+       -  b\ :sub:`10`
+
+       -  b\ :sub:`9`
+
+       -  b\ :sub:`8`
+
+       -  b\ :sub:`7`
+
+       -  b\ :sub:`6`
+
+       -  b\ :sub:`5`
+
+       -  b\ :sub:`4`
+
+       -  b\ :sub:`3`
+
+       -  b\ :sub:`2`
+
+       -  b\ :sub:`1`
+
+       -  b\ :sub:`0`
+
+    -  .. _MEDIA-BUS-FMT-SGBRG16-1X16:
+
+       -  MEDIA_BUS_FMT_SGBRG16_1X16
+
+       -  0x301e
+
+       -
+       -  g\ :sub:`15`
+
+       -  g\ :sub:`14`
+
+       -  g\ :sub:`13`
+
+       -  g\ :sub:`12`
+
+       -  g\ :sub:`11`
+
+       -  g\ :sub:`10`
+
+       -  g\ :sub:`9`
+
+       -  g\ :sub:`8`
+
+       -  g\ :sub:`7`
+
+       -  g\ :sub:`6`
+
+       -  g\ :sub:`5`
+
+       -  g\ :sub:`4`
+
+       -  g\ :sub:`3`
+
+       -  g\ :sub:`2`
+
+       -  g\ :sub:`1`
+
+       -  g\ :sub:`0`
+
+    -  .. _MEDIA-BUS-FMT-SGRBG16-1X16:
+
+       -  MEDIA_BUS_FMT_SGRBG16_1X16
+
+       -  0x301f
+
+       -
+       -  g\ :sub:`15`
+
+       -  g\ :sub:`14`
+
+       -  g\ :sub:`13`
+
+       -  g\ :sub:`12`
+
+       -  g\ :sub:`11`
+
+       -  g\ :sub:`10`
+
+       -  g\ :sub:`9`
+
+       -  g\ :sub:`8`
+
+       -  g\ :sub:`7`
+
+       -  g\ :sub:`6`
+
+       -  g\ :sub:`5`
+
+       -  g\ :sub:`4`
+
+       -  g\ :sub:`3`
+
+       -  g\ :sub:`2`
+
+       -  g\ :sub:`1`
+
+       -  g\ :sub:`0`
+
+    -  .. _MEDIA-BUS-FMT-SRGGB16-1X16:
+
+       -  MEDIA_BUS_FMT_SRGGB16_1X16
+
+       -  0x3020
+
+       -
+       -  r\ :sub:`15`
+
+       -  r\ :sub:`14`
+
        -  r\ :sub:`13`
 
        -  r\ :sub:`12`
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 1dff459..2168759 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -97,7 +97,7 @@
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
 
-/* Bayer - next is	0x301d */
+/* Bayer - next is	0x3021 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
 #define MEDIA_BUS_FMT_SGBRG8_1X8		0x3013
 #define MEDIA_BUS_FMT_SGRBG8_1X8		0x3002
@@ -126,6 +126,10 @@
 #define MEDIA_BUS_FMT_SGBRG14_1X14		0x301a
 #define MEDIA_BUS_FMT_SGRBG14_1X14		0x301b
 #define MEDIA_BUS_FMT_SRGGB14_1X14		0x301c
+#define MEDIA_BUS_FMT_SBGGR16_1X16		0x301d
+#define MEDIA_BUS_FMT_SGBRG16_1X16		0x301e
+#define MEDIA_BUS_FMT_SGRBG16_1X16		0x301f
+#define MEDIA_BUS_FMT_SRGGB16_1X16		0x3020
 
 /* JPEG compressed formats - next is	0x4002 */
 #define MEDIA_BUS_FMT_JPEG_1X8			0x4001
-- 
2.7.4

