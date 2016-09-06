Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:62675 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755616AbcIFL4t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:56:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v4 7/8] media: Add 1X16 16-bit raw bayer media bus code definitions
Date: Tue,  6 Sep 2016 14:55:39 +0300
Message-Id: <1473162940-31486-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 07e7cf98..06d8981 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -2812,7 +2812,7 @@ organization is given as an example for the first pixel only.
        -  Code
 
        -
-       -  :cspan:`13` Data organization
+       -  :cspan:`15` Data organization
 
     -  .. row 2
 
@@ -2820,6 +2820,10 @@ organization is given as an example for the first pixel only.
        -
        -  Bit
 
+       -  15
+
+       -  14
+
        -  13
 
        -  12
@@ -2867,6 +2871,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -2902,6 +2910,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2937,6 +2949,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2972,6 +2988,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3007,6 +3027,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3042,6 +3066,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3077,6 +3105,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3112,6 +3144,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3147,6 +3183,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3182,6 +3222,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3217,6 +3261,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3252,6 +3300,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3287,6 +3339,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3320,6 +3376,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3355,6 +3415,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3388,6 +3452,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3423,6 +3491,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3456,6 +3528,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3491,6 +3567,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3524,6 +3604,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3555,6 +3639,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3590,6 +3678,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3625,6 +3717,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3660,6 +3756,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`9`
 
        -  r\ :sub:`8`
@@ -3691,6 +3791,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`11`
 
        -  b\ :sub:`10`
@@ -3726,6 +3830,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3761,6 +3869,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3796,6 +3908,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`11`
 
        -  r\ :sub:`10`
@@ -3827,6 +3943,10 @@ organization is given as an example for the first pixel only.
        -  0x3019
 
        -
+       -  -
+
+       -  -
+
        -  b\ :sub:`13`
 
        -  b\ :sub:`12`
@@ -3862,6 +3982,10 @@ organization is given as an example for the first pixel only.
        -  0x301a
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`13`
 
        -  g\ :sub:`12`
@@ -3897,6 +4021,10 @@ organization is given as an example for the first pixel only.
        -  0x301b
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`13`
 
        -  g\ :sub:`12`
@@ -3932,6 +4060,166 @@ organization is given as an example for the first pixel only.
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

