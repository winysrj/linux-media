Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43836 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbbIMTQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 15:16:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] vivid-tpg: add support for SMPTE 2084 transfer function
Date: Sun, 13 Sep 2015 21:15:19 +0200
Message-Id: <1442171721-13058-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
References: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the new SMPTE 2084 transfer function in the test pattern generator.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg-colors.c | 96 ++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-tpg-colors.h |  2 +-
 2 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg-colors.c b/drivers/media/platform/vivid/vivid-tpg-colors.c
index dee7b14..2299f0c 100644
--- a/drivers/media/platform/vivid/vivid-tpg-colors.c
+++ b/drivers/media/platform/vivid/vivid-tpg-colors.c
@@ -598,7 +598,7 @@ const unsigned short tpg_linear_to_rec709[255 * 16 + 1] = {
 };
 
 /* Generated table */
-const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_DCI_P3 + 1][TPG_COLOR_CSC_BLACK + 1] = {
+const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_SMPTE2084 + 1][TPG_COLOR_CSC_BLACK + 1] = {
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][1] = { 2953, 2963, 586 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][2] = { 0, 2967, 2937 },
@@ -647,6 +647,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][5] = { 3248, 944, 1094 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][6] = { 1017, 967, 3168 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][1] = { 3802, 3805, 2602 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][2] = { 0, 3806, 3797 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][3] = { 1780, 3812, 2592 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][4] = { 3820, 2215, 3796 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][5] = { 3824, 2409, 2574 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][6] = { 2491, 2435, 3795 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][1] = { 2953, 2963, 586 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][2] = { 0, 2967, 2937 },
@@ -695,6 +703,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][5] = { 3248, 944, 1094 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][6] = { 1017, 967, 3168 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][1] = { 3802, 3805, 2602 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][2] = { 0, 3806, 3797 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][3] = { 1780, 3812, 2592 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][4] = { 3820, 2215, 3796 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][5] = { 3824, 2409, 2574 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][6] = { 2491, 2435, 3795 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 547 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][2] = { 547, 2939, 2939 },
@@ -743,6 +759,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][5] = { 3175, 1084, 1084 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3175 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2563 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][2] = { 2563, 3798, 3798 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][3] = { 2563, 3798, 2563 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][4] = { 3798, 2563, 3798 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][5] = { 3798, 2563, 2563 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3798 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][1] = { 2892, 3034, 910 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][2] = { 1715, 2916, 2914 },
@@ -791,6 +815,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][5] = { 2765, 1182, 1190 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][6] = { 1270, 0, 3094 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][1] = { 3784, 3825, 2879 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][2] = { 3351, 3791, 3790 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][3] = { 3311, 3819, 2815 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][4] = { 3659, 1900, 3777 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][5] = { 3640, 2662, 2669 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][6] = { 2743, 0, 3769 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 464 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][2] = { 786, 2939, 2939 },
@@ -839,6 +871,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][5] = { 3126, 1084, 1084 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3188 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2476 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][2] = { 2782, 3798, 3798 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][3] = { 2782, 3798, 2476 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][4] = { 3780, 2563, 3803 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][5] = { 3780, 2563, 2563 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3803 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 547 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][2] = { 547, 2939, 2939 },
@@ -887,6 +927,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][5] = { 3175, 1084, 1084 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3175 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2563 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][2] = { 2563, 3798, 3798 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][3] = { 2563, 3798, 2563 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][4] = { 3798, 2563, 3798 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][5] = { 3798, 2563, 2563 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3798 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 781 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][2] = { 1622, 2939, 2939 },
@@ -935,6 +983,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][5] = { 2816, 1084, 1084 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3127 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][1] = { 3798, 3798, 2778 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][2] = { 3306, 3798, 3798 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][3] = { 3306, 3798, 2778 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][4] = { 3661, 2563, 3781 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][5] = { 3661, 2563, 2563 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][6] = { 2563, 2563, 3781 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][1] = { 2877, 2923, 1058 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][2] = { 1837, 2840, 2916 },
@@ -983,6 +1039,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][5] = { 2690, 1431, 1182 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][6] = { 1318, 1153, 3051 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][1] = { 3780, 3793, 2984 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][2] = { 3406, 3768, 3791 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][3] = { 3359, 3763, 2939 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][4] = { 3636, 2916, 3760 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][5] = { 3609, 2880, 2661 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][6] = { 2786, 2633, 3753 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][1] = { 2936, 2934, 992 },
 	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][2] = { 1159, 2890, 2916 },
@@ -1031,6 +1095,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_D
 	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][5] = { 3018, 1276, 1184 },
 	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][6] = { 1100, 1107, 3071 },
 	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][0] = { 3798, 3798, 3798 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][1] = { 3797, 3796, 2938 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][2] = { 3049, 3783, 3791 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][3] = { 3044, 3782, 2887 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][4] = { 3741, 2765, 3768 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][5] = { 3740, 2749, 2663 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][6] = { 2580, 2587, 3760 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE2084][7] = { 2563, 2563, 2563 },
 };
 
 #else
@@ -1146,6 +1218,18 @@ static double transfer_rgb_to_dcip3(double v)
 	return pow(v, 1.0 / 2.6);
 }
 
+static double transfer_rgb_to_smpte2084(double v)
+{
+	const double m1 = (2610.0 / 4096.0) / 4.0;
+	const double m2 = 128.0 * 2523.0 / 4096.0;
+	const double c1 = 3424.0 / 4096.0;
+	const double c2 = 32.0 * 2413.0 / 4096.0;
+	const double c3 = 32.0 * 2392.0 / 4096.0;
+
+	v = pow(v, m1);
+	return pow((c1 + c2 * v) / (1 + c3 * v), m2);
+}
+
 static double transfer_srgb_to_rec709(double v)
 {
 	return transfer_rgb_to_rec709(transfer_srgb_to_rgb(v));
@@ -1217,6 +1301,11 @@ static void csc(enum v4l2_colorspace colorspace, enum v4l2_xfer_func xfer_func,
 		*g = transfer_rgb_to_dcip3(*g);
 		*b = transfer_rgb_to_dcip3(*b);
 		break;
+	case V4L2_XFER_FUNC_SMPTE2084:
+		*r = transfer_rgb_to_smpte2084(*r);
+		*g = transfer_rgb_to_smpte2084(*g);
+		*b = transfer_rgb_to_smpte2084(*b);
+		break;
 	case V4L2_XFER_FUNC_SMPTE240M:
 		*r = transfer_rgb_to_smpte240m(*r);
 		*g = transfer_rgb_to_smpte240m(*g);
@@ -1267,6 +1356,7 @@ int main(int argc, char **argv)
 		"V4L2_XFER_FUNC_SMPTE240M",
 		"V4L2_XFER_FUNC_NONE",
 		"V4L2_XFER_FUNC_DCI_P3",
+		"V4L2_XFER_FUNC_SMPTE2084",
 	};
 	int i;
 	int x;
@@ -1297,9 +1387,9 @@ int main(int argc, char **argv)
 	printf("\n};\n\n");
 
 	printf("/* Generated table */\n");
-	printf("const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_DCI_P3 + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
+	printf("const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_SMPTE2084 + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
 	for (c = 0; c <= V4L2_COLORSPACE_DCI_P3; c++) {
-		for (x = 1; x <= V4L2_XFER_FUNC_DCI_P3; x++) {
+		for (x = 1; x <= V4L2_XFER_FUNC_SMPTE2084; x++) {
 			for (i = 0; i <= TPG_COLOR_CSC_BLACK; i++) {
 				double r, g, b;
 
diff --git a/drivers/media/platform/vivid/vivid-tpg-colors.h b/drivers/media/platform/vivid/vivid-tpg-colors.h
index ada0cd1..4e5a76a 100644
--- a/drivers/media/platform/vivid/vivid-tpg-colors.h
+++ b/drivers/media/platform/vivid/vivid-tpg-colors.h
@@ -62,7 +62,7 @@ extern const struct color tpg_colors[TPG_COLOR_MAX];
 extern const unsigned short tpg_rec709_to_linear[255 * 16 + 1];
 extern const unsigned short tpg_linear_to_rec709[255 * 16 + 1];
 extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1]
-					  [V4L2_XFER_FUNC_DCI_P3 + 1]
+					  [V4L2_XFER_FUNC_SMPTE2084 + 1]
 					  [TPG_COLOR_CSC_BLACK + 1];
 
 #endif
-- 
2.1.4

