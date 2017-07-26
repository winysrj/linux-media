Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58241 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751040AbdGZSqA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 14:46:00 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-tpg: fix the SMPTE-2084 transfer function
Message-ID: <0b1447e4-edaf-05a6-0cac-b969ff3ccb28@xs4all.nl>
Date: Wed, 26 Jul 2017 20:45:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SMPTE-2084 transfer functions maps to the luminance range of 0-10000 cd/m^2.
Other transfer functions use the traditional range of 0-100 cd/m^2.

I didn't take this into account so the luminance was off by a factor of 100.

Since qv4l2 made the same mistake in reverse I never noticed this until I tested with
actual SMPTE-2084 video.

This patch also includes the v4l2-tpg-colors.h relative to this directory when
building the gen-colors utility, otherwise it would fail. This was needed to regenerate
the tables.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
index 9bcbd318489b..ac86cbe08440 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
@@ -36,7 +36,11 @@
   */

  #include <linux/videodev2.h>
+#ifdef COMPILE_APP
+#include "../../../../include/media/v4l2-tpg-colors.h"
+#else
  #include <media/v4l2-tpg-colors.h>
+#endif

  /* sRGB colors with range [0-255] */
  const struct color tpg_colors[TPG_COLOR_MAX] = {
@@ -646,14 +650,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][5] = { 3248, 944, 1094 },
  	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][6] = { 1017, 967, 3168 },
  	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][1] = { 3802, 3805, 2602 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][2] = { 0, 3806, 3797 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][3] = { 1780, 3812, 2592 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][4] = { 3820, 2215, 3796 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][5] = { 3824, 2409, 2574 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][6] = { 2491, 2435, 3795 },
-	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][1] = { 1815, 1818, 910 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][2] = { 0, 1819, 1811 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][3] = { 472, 1825, 904 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][4] = { 1832, 686, 1810 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][5] = { 1835, 794, 893 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][6] = { 843, 809, 1810 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][1] = { 2953, 2963, 586 },
  	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][2] = { 0, 2967, 2937 },
@@ -702,14 +706,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][5] = { 3248, 944, 1094 },
  	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][6] = { 1017, 967, 3168 },
  	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][1] = { 3802, 3805, 2602 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][2] = { 0, 3806, 3797 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][3] = { 1780, 3812, 2592 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][4] = { 3820, 2215, 3796 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][5] = { 3824, 2409, 2574 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][6] = { 2491, 2435, 3795 },
-	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][1] = { 1815, 1818, 910 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][2] = { 0, 1819, 1811 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][3] = { 472, 1825, 904 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][4] = { 1832, 686, 1810 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][5] = { 1835, 794, 893 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][6] = { 843, 809, 1810 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 547 },
  	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][2] = { 547, 2939, 2939 },
@@ -758,14 +762,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][5] = { 3175, 1084, 1084 },
  	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3175 },
  	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2563 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][2] = { 2563, 3798, 3798 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][3] = { 2563, 3798, 2563 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][4] = { 3798, 2563, 3798 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][5] = { 3798, 2563, 2563 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3798 },
-	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][1] = { 1812, 1812, 886 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][2] = { 886, 1812, 1812 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][3] = { 886, 1812, 886 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][4] = { 1812, 886, 1812 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][5] = { 1812, 886, 886 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][6] = { 886, 886, 1812 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][1] = { 2892, 3034, 910 },
  	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][2] = { 1715, 2916, 2914 },
@@ -814,14 +818,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][5] = { 2765, 1182, 1190 },
  	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][6] = { 1270, 0, 3094 },
  	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][1] = { 3784, 3825, 2879 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][2] = { 3351, 3791, 3790 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][3] = { 3311, 3819, 2815 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][4] = { 3659, 1900, 3777 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][5] = { 3640, 2662, 2669 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][6] = { 2743, 0, 3769 },
-	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][1] = { 1800, 1836, 1090 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][2] = { 1436, 1806, 1805 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][3] = { 1405, 1830, 1047 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][4] = { 1691, 527, 1793 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][5] = { 1674, 947, 952 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][6] = { 1000, 0, 1786 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 464 },
  	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][2] = { 786, 2939, 2939 },
@@ -870,14 +874,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][5] = { 3126, 1084, 1084 },
  	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3188 },
  	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2476 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][2] = { 2782, 3798, 3798 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][3] = { 2782, 3798, 2476 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][4] = { 3780, 2563, 3803 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][5] = { 3780, 2563, 2563 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3803 },
-	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][1] = { 1812, 1812, 833 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][2] = { 1025, 1812, 1812 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][3] = { 1025, 1812, 833 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][4] = { 1796, 886, 1816 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][5] = { 1796, 886, 886 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][6] = { 886, 886, 1816 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 547 },
  	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][2] = { 547, 2939, 2939 },
@@ -926,14 +930,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][5] = { 3175, 1084, 1084 },
  	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3175 },
  	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2563 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][2] = { 2563, 3798, 3798 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][3] = { 2563, 3798, 2563 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][4] = { 3798, 2563, 3798 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][5] = { 3798, 2563, 2563 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3798 },
-	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][1] = { 1812, 1812, 886 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][2] = { 886, 1812, 1812 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][3] = { 886, 1812, 886 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][4] = { 1812, 886, 1812 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][5] = { 1812, 886, 886 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][6] = { 886, 886, 1812 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 781 },
  	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][2] = { 1622, 2939, 2939 },
@@ -982,14 +986,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][5] = { 2816, 1084, 1084 },
  	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3127 },
  	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2778 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][2] = { 3306, 3798, 3798 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][3] = { 3306, 3798, 2778 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][4] = { 3661, 2563, 3781 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][5] = { 3661, 2563, 2563 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3781 },
-	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][1] = { 1812, 1812, 1022 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][2] = { 1402, 1812, 1812 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][3] = { 1402, 1812, 1022 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][4] = { 1692, 886, 1797 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][5] = { 1692, 886, 886 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][6] = { 886, 886, 1797 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][1] = { 2877, 2923, 1058 },
  	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][2] = { 1837, 2840, 2916 },
@@ -1038,14 +1042,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][5] = { 2690, 1431, 1182 },
  	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][6] = { 1318, 1153, 3051 },
  	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][1] = { 3780, 3793, 2984 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][2] = { 3406, 3768, 3791 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][3] = { 3359, 3763, 2939 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][4] = { 3636, 2916, 3760 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][5] = { 3609, 2880, 2661 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][6] = { 2786, 2633, 3753 },
-	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][1] = { 1796, 1808, 1163 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][2] = { 1480, 1786, 1806 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][3] = { 1443, 1781, 1131 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][4] = { 1670, 1116, 1778 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][5] = { 1648, 1091, 947 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][6] = { 1028, 929, 1772 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
  	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][1] = { 2936, 2934, 992 },
  	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][2] = { 1159, 2890, 2916 },
@@ -1094,14 +1098,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_S
  	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][5] = { 3018, 1276, 1184 },
  	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][6] = { 1100, 1107, 3071 },
  	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][1] = { 3797, 3796, 2938 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][2] = { 3049, 3783, 3791 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][3] = { 3044, 3782, 2887 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][4] = { 3741, 2765, 3768 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][5] = { 3740, 2749, 2663 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][6] = { 2580, 2587, 3760 },
-	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][0] = { 1812, 1812, 1812 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][1] = { 1811, 1810, 1131 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][2] = { 1210, 1799, 1806 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][3] = { 1206, 1798, 1096 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][4] = { 1762, 1014, 1785 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][5] = { 1761, 1004, 948 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][6] = { 896, 901, 1778 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][7] = { 886, 886, 886 },
  };

  #else
@@ -1225,6 +1229,12 @@ static double transfer_rgb_to_smpte2084(double v)
  	const double c2 = 32.0 * 2413.0 / 4096.0;
  	const double c3 = 32.0 * 2392.0 / 4096.0;

+	/*
+	 * The RGB input maps to the luminance range 0-100 cd/m^2, while
+	 * SMPTE-2084 maps values to the luminance range of 0-10000 cd/m^2.
+	 * Hence the factor 100.
+	 */
+	v /= 100.0;
  	v = pow(v, m1);
  	return pow((c1 + c2 * v) / (1 + c3 * v), m2);
  }
