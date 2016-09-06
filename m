Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:4195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755750AbcIFL5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:57:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Jouni Ukkonen <jouni.ukkonen@intel.com>
Subject: [PATCH v4 6/8] media: Add 1X14 14-bit raw bayer media bus code definitions
Date: Tue,  6 Sep 2016 14:55:38 +0300
Message-Id: <1473162940-31486-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jouni Ukkonen <jouni.ukkonen@intel.com>

The codes will be called:

	MEDIA_BUS_FMT_SBGGR14_1X14
	MEDIA_BUS_FMT_SGBRG14_1X14
	MEDIA_BUS_FMT_SGRBG14_1X14
	MEDIA_BUS_FMT_SRGGB14_1X14

Signed-off-by: Jouni Ukkonen <jouni.ukkonen@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 258 +++++++++++++++++++++++-
 include/uapi/linux/media-bus-format.h           |   6 +-
 2 files changed, 262 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 52013b5..07e7cf98 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -2812,7 +2812,7 @@ organization is given as an example for the first pixel only.
        -  Code
 
        -
-       -  :cspan:`11` Data organization
+       -  :cspan:`13` Data organization
 
     -  .. row 2
 
@@ -2820,6 +2820,10 @@ organization is given as an example for the first pixel only.
        -
        -  Bit
 
+       -  13
+
+       -  12
+
        -  11
 
        -  10
@@ -2859,6 +2863,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -2890,6 +2898,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2921,6 +2933,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2952,6 +2968,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -2983,6 +3003,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3014,6 +3038,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3045,6 +3073,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3076,6 +3108,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3107,6 +3143,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3138,6 +3178,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3169,6 +3213,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3200,6 +3248,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3231,6 +3283,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3260,6 +3316,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3291,6 +3351,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3320,6 +3384,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3351,6 +3419,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3380,6 +3452,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3411,6 +3487,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3440,6 +3520,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3467,6 +3551,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3498,6 +3586,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3529,6 +3621,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3560,6 +3656,10 @@ organization is given as an example for the first pixel only.
 
        -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`9`
 
        -  r\ :sub:`8`
@@ -3587,6 +3687,10 @@ organization is given as an example for the first pixel only.
        -  0x3008
 
        -
+       -  -
+
+       -  -
+
        -  b\ :sub:`11`
 
        -  b\ :sub:`10`
@@ -3618,6 +3722,10 @@ organization is given as an example for the first pixel only.
        -  0x3010
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3649,6 +3757,10 @@ organization is given as an example for the first pixel only.
        -  0x3011
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3680,6 +3792,150 @@ organization is given as an example for the first pixel only.
        -  0x3012
 
        -
+       -  -
+
+       -  -
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
+    -  .. _MEDIA-BUS-FMT-SBGGR14-1X14:
+
+       -  MEDIA_BUS_FMT_SBGGR14_1X14
+
+       -  0x3019
+
+       -
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
+    -  .. _MEDIA-BUS-FMT-SGBRG14-1X14:
+
+       -  MEDIA_BUS_FMT_SGBRG14_1X14
+
+       -  0x301a
+
+       -
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
+    -  .. _MEDIA-BUS-FMT-SGRBG14-1X14:
+
+       -  MEDIA_BUS_FMT_SGRBG14_1X14
+
+       -  0x301b
+
+       -
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
+    -  .. _MEDIA-BUS-FMT-SRGGB14-1X14:
+
+       -  MEDIA_BUS_FMT_SRGGB14_1X14
+
+       -  0x301c
+
+       -
+       -  r\ :sub:`13`
+
+       -  r\ :sub:`12`
+
        -  r\ :sub:`11`
 
        -  r\ :sub:`10`
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 190d491..1dff459 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -97,7 +97,7 @@
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
 
-/* Bayer - next is	0x3019 */
+/* Bayer - next is	0x301d */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
 #define MEDIA_BUS_FMT_SGBRG8_1X8		0x3013
 #define MEDIA_BUS_FMT_SGRBG8_1X8		0x3002
@@ -122,6 +122,10 @@
 #define MEDIA_BUS_FMT_SGBRG12_1X12		0x3010
 #define MEDIA_BUS_FMT_SGRBG12_1X12		0x3011
 #define MEDIA_BUS_FMT_SRGGB12_1X12		0x3012
+#define MEDIA_BUS_FMT_SBGGR14_1X14		0x3019
+#define MEDIA_BUS_FMT_SGBRG14_1X14		0x301a
+#define MEDIA_BUS_FMT_SGRBG14_1X14		0x301b
+#define MEDIA_BUS_FMT_SRGGB14_1X14		0x301c
 
 /* JPEG compressed formats - next is	0x4002 */
 #define MEDIA_BUS_FMT_JPEG_1X8			0x4001
-- 
2.7.4

