Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:29585 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbcHEKqi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Jouni Ukkonen <jouni.ukkonen@intel.com>
Subject: [PATCH v3 06/11] media: Add 1X14 14-bit raw bayer media bus code definitions
Date: Fri,  5 Aug 2016 13:45:36 +0300
Message-Id: <1470393941-26959-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 6dbb27b..238ecfc 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -2782,7 +2782,7 @@ organization is given as an example for the first pixel only.
        -  Code
 
        -
-       -  :cspan:`11` Data organization
+       -  :cspan:`13` Data organization
 
     -  .. row 2
 
@@ -2790,6 +2790,10 @@ organization is given as an example for the first pixel only.
        -
        -  Bit
 
+       -  13
+
+       -  12
+
        -  11
 
        -  10
@@ -2829,6 +2833,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -2860,6 +2868,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2891,6 +2903,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -2922,6 +2938,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -2953,6 +2973,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -2984,6 +3008,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3015,6 +3043,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3046,6 +3078,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3077,6 +3113,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3108,6 +3148,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3139,6 +3183,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`7`
 
        -  g\ :sub:`6`
@@ -3170,6 +3218,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`7`
 
        -  r\ :sub:`6`
@@ -3201,6 +3253,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3230,6 +3286,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3261,6 +3321,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`7`
 
        -  b\ :sub:`6`
@@ -3290,6 +3354,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  0
 
        -  0
@@ -3321,6 +3389,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3350,6 +3422,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3381,6 +3457,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`1`
 
        -  b\ :sub:`0`
@@ -3410,6 +3490,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3437,6 +3521,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  b\ :sub:`9`
 
        -  b\ :sub:`8`
@@ -3468,6 +3556,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3499,6 +3591,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  g\ :sub:`9`
 
        -  g\ :sub:`8`
@@ -3530,6 +3626,10 @@ organization is given as an example for the first pixel only.
 
        -  -
 
+       -  -
+
+       -  -
+
        -  r\ :sub:`9`
 
        -  r\ :sub:`8`
@@ -3557,6 +3657,10 @@ organization is given as an example for the first pixel only.
        -  0x3008
 
        -
+       -  -
+
+       -  -
+
        -  b\ :sub:`11`
 
        -  b\ :sub:`10`
@@ -3588,6 +3692,10 @@ organization is given as an example for the first pixel only.
        -  0x3010
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3619,6 +3727,10 @@ organization is given as an example for the first pixel only.
        -  0x3011
 
        -
+       -  -
+
+       -  -
+
        -  g\ :sub:`11`
 
        -  g\ :sub:`10`
@@ -3650,6 +3762,150 @@ organization is given as an example for the first pixel only.
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

