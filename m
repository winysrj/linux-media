Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42200 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbbIMQnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 12:43:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/6] vivid-tpg: support the DCI-P3 colorspace
Date: Sun, 13 Sep 2015 18:41:31 +0200
Message-Id: <1442162492-46238-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
References: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support to the test pattern generator for the DCI-P3 colorspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg-colors.c | 148 +++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-tpg-colors.h |   4 +-
 2 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg-colors.c b/drivers/media/platform/vivid/vivid-tpg-colors.c
index 650d9c7..dee7b14 100644
--- a/drivers/media/platform/vivid/vivid-tpg-colors.c
+++ b/drivers/media/platform/vivid/vivid-tpg-colors.c
@@ -598,7 +598,7 @@ const unsigned short tpg_linear_to_rec709[255 * 16 + 1] = {
 };
 
 /* Generated table */
-const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_NONE + 1][TPG_COLOR_CSC_BLACK + 1] = {
+const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_DCI_P3 + 1][TPG_COLOR_CSC_BLACK + 1] = {
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][1] = { 2953, 2963, 586 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][2] = { 0, 2967, 2937 },
@@ -639,6 +639,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_NONE][5] = { 2256, 90, 133 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_NONE][6] = { 110, 96, 2113 },
 	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][1] = { 3186, 3194, 1121 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][2] = { 0, 3197, 3173 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][3] = { 523, 3216, 1112 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][4] = { 3237, 792, 3169 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][5] = { 3248, 944, 1094 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][6] = { 1017, 967, 3168 },
+	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][1] = { 2953, 2963, 586 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_709][2] = { 0, 2967, 2937 },
@@ -679,6 +687,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_NONE][5] = { 2256, 90, 133 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_NONE][6] = { 110, 96, 2113 },
 	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][1] = { 3186, 3194, 1121 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][2] = { 0, 3197, 3173 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][3] = { 523, 3216, 1112 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][4] = { 3237, 792, 3169 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][5] = { 3248, 944, 1094 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][6] = { 1017, 967, 3168 },
+	[V4L2_COLORSPACE_SMPTE240M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 547 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_709][2] = { 547, 2939, 2939 },
@@ -719,6 +735,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_NONE][5] = { 2125, 130, 130 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_NONE][6] = { 130, 130, 2125 },
 	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][1] = { 3175, 3175, 1084 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][2] = { 1084, 3175, 3175 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][3] = { 1084, 3175, 1084 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][4] = { 3175, 1084, 3175 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][5] = { 3175, 1084, 1084 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3175 },
+	[V4L2_COLORSPACE_REC709][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][1] = { 2892, 3034, 910 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_709][2] = { 1715, 2916, 2914 },
@@ -759,6 +783,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_NONE][5] = { 1484, 163, 165 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_NONE][6] = { 196, 0, 1988 },
 	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][1] = { 3136, 3251, 1429 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][2] = { 2150, 3156, 3154 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][3] = { 2077, 3233, 1352 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][4] = { 2812, 589, 3116 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][5] = { 2765, 1182, 1190 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][6] = { 1270, 0, 3094 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 464 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_709][2] = { 786, 2939, 2939 },
@@ -799,6 +831,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_NONE][5] = { 2041, 130, 130 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_NONE][6] = { 130, 130, 2149 },
 	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][1] = { 3175, 3175, 1003 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][2] = { 1313, 3175, 3175 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][3] = { 1313, 3175, 1003 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][4] = { 3126, 1084, 3188 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][5] = { 3126, 1084, 1084 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3188 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 547 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_709][2] = { 547, 2939, 2939 },
@@ -839,6 +879,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_NONE][5] = { 2125, 130, 130 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_NONE][6] = { 130, 130, 2125 },
 	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][1] = { 3175, 3175, 1084 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][2] = { 1084, 3175, 3175 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][3] = { 1084, 3175, 1084 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][4] = { 3175, 1084, 3175 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][5] = { 3175, 1084, 1084 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3175 },
+	[V4L2_COLORSPACE_SRGB][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][1] = { 2939, 2939, 781 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_709][2] = { 1622, 2939, 2939 },
@@ -879,6 +927,14 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_NONE][5] = { 1557, 130, 130 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_NONE][6] = { 130, 130, 2043 },
 	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][1] = { 3175, 3175, 1308 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][2] = { 2069, 3175, 3175 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][3] = { 2069, 3175, 1308 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][4] = { 2816, 1084, 3127 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][5] = { 2816, 1084, 1084 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][6] = { 1084, 1084, 3127 },
+	[V4L2_COLORSPACE_ADOBERGB][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][1] = { 2877, 2923, 1058 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_709][2] = { 1837, 2840, 2916 },
@@ -919,6 +975,62 @@ const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_N
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_NONE][5] = { 1382, 268, 162 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_NONE][6] = { 216, 152, 1917 },
 	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][1] = { 3124, 3161, 1566 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][2] = { 2255, 3094, 3156 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][3] = { 2166, 3080, 1506 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][4] = { 2754, 1477, 3071 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][5] = { 2690, 1431, 1182 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][6] = { 1318, 1153, 3051 },
+	[V4L2_COLORSPACE_BT2020][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][1] = { 2936, 2934, 992 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][2] = { 1159, 2890, 2916 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][3] = { 1150, 2885, 921 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][4] = { 2751, 766, 2837 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][5] = { 2747, 747, 650 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][6] = { 563, 570, 2812 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_709][7] = { 547, 547, 547 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][0] = { 3056, 3056, 3055 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][1] = { 3052, 3051, 1237 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][2] = { 1397, 3011, 3034 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][3] = { 1389, 3006, 1168 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][4] = { 2884, 1016, 2962 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][5] = { 2880, 998, 902 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][6] = { 816, 823, 2940 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SRGB][7] = { 800, 800, 799 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][0] = { 3033, 3033, 3033 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][1] = { 3029, 3028, 1255 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][2] = { 1406, 2988, 3011 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][3] = { 1398, 2983, 1190 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][4] = { 2860, 1050, 2939 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][5] = { 2857, 1033, 945 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][6] = { 866, 873, 2916 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_ADOBERGB][7] = { 851, 851, 851 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][0] = { 2926, 2926, 2926 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][1] = { 2923, 2921, 957 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][2] = { 1125, 2877, 2902 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][3] = { 1116, 2871, 885 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][4] = { 2736, 729, 2823 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][5] = { 2732, 710, 611 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][6] = { 523, 531, 2798 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_SMPTE240M][7] = { 507, 507, 507 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][0] = { 2125, 2125, 2125 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][1] = { 2120, 2118, 305 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][2] = { 392, 2056, 2092 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][3] = { 387, 2049, 271 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][4] = { 1868, 206, 1983 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][5] = { 1863, 199, 163 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][6] = { 135, 137, 1950 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_NONE][7] = { 130, 130, 130 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][0] = { 3175, 3175, 3175 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][1] = { 3172, 3170, 1505 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][2] = { 1657, 3135, 3155 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][3] = { 1649, 3130, 1439 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][4] = { 3021, 1294, 3091 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][5] = { 3018, 1276, 1184 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][6] = { 1100, 1107, 3071 },
+	[V4L2_COLORSPACE_DCI_P3][V4L2_XFER_FUNC_DCI_P3][7] = { 1084, 1084, 1084 },
 };
 
 #else
@@ -969,6 +1081,16 @@ static const double rec709_to_bt2020[3][3] = {
 	{ 0.0163976, 0.0880301, 0.8955723 },
 };
 
+static const double rec709_to_dcip3[3][3] = {
+	/*
+	 * This transform uses the Bradford method to compensate for
+	 * the different whitepoints.
+	 */
+	{ 0.8686648, 0.1288456, 0.0024896 },
+	{ 0.0345479, 0.9618084, 0.0036437 },
+	{ 0.0167785, 0.0710559, 0.9121655 }
+};
+
 static void mult_matrix(double *r, double *g, double *b, const double m[3][3])
 {
 	double ir, ig, ib;
@@ -1019,6 +1141,11 @@ static double transfer_rgb_to_adobergb(double v)
 	return pow(v, 1.0 / 2.19921875);
 }
 
+static double transfer_rgb_to_dcip3(double v)
+{
+	return pow(v, 1.0 / 2.6);
+}
+
 static double transfer_srgb_to_rec709(double v)
 {
 	return transfer_rgb_to_rec709(transfer_srgb_to_rgb(v));
@@ -1053,6 +1180,9 @@ static void csc(enum v4l2_colorspace colorspace, enum v4l2_xfer_func xfer_func,
 	case V4L2_COLORSPACE_BT2020:
 		mult_matrix(r, g, b, rec709_to_bt2020);
 		break;
+	case V4L2_COLORSPACE_DCI_P3:
+		mult_matrix(r, g, b, rec709_to_dcip3);
+		break;
 	case V4L2_COLORSPACE_SRGB:
 	case V4L2_COLORSPACE_REC709:
 		break;
@@ -1082,6 +1212,11 @@ static void csc(enum v4l2_colorspace colorspace, enum v4l2_xfer_func xfer_func,
 		*g = transfer_rgb_to_adobergb(*g);
 		*b = transfer_rgb_to_adobergb(*b);
 		break;
+	case V4L2_XFER_FUNC_DCI_P3:
+		*r = transfer_rgb_to_dcip3(*r);
+		*g = transfer_rgb_to_dcip3(*g);
+		*b = transfer_rgb_to_dcip3(*b);
+		break;
 	case V4L2_XFER_FUNC_SMPTE240M:
 		*r = transfer_rgb_to_smpte240m(*r);
 		*g = transfer_rgb_to_smpte240m(*g);
@@ -1106,6 +1241,8 @@ int main(int argc, char **argv)
 		V4L2_COLORSPACE_SRGB,
 		V4L2_COLORSPACE_ADOBERGB,
 		V4L2_COLORSPACE_BT2020,
+		0,
+		V4L2_COLORSPACE_DCI_P3,
 	};
 	static const char * const colorspace_names[] = {
 		"",
@@ -1119,6 +1256,8 @@ int main(int argc, char **argv)
 		"V4L2_COLORSPACE_SRGB",
 		"V4L2_COLORSPACE_ADOBERGB",
 		"V4L2_COLORSPACE_BT2020",
+		"",
+		"V4L2_COLORSPACE_DCI_P3",
 	};
 	static const char * const xfer_func_names[] = {
 		"",
@@ -1127,6 +1266,7 @@ int main(int argc, char **argv)
 		"V4L2_XFER_FUNC_ADOBERGB",
 		"V4L2_XFER_FUNC_SMPTE240M",
 		"V4L2_XFER_FUNC_NONE",
+		"V4L2_XFER_FUNC_DCI_P3",
 	};
 	int i;
 	int x;
@@ -1157,9 +1297,9 @@ int main(int argc, char **argv)
 	printf("\n};\n\n");
 
 	printf("/* Generated table */\n");
-	printf("const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1][V4L2_XFER_FUNC_NONE + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
-	for (c = 0; c <= V4L2_COLORSPACE_BT2020; c++) {
-		for (x = 1; x <= V4L2_XFER_FUNC_NONE; x++) {
+	printf("const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_DCI_P3 + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
+	for (c = 0; c <= V4L2_COLORSPACE_DCI_P3; c++) {
+		for (x = 1; x <= V4L2_XFER_FUNC_DCI_P3; x++) {
 			for (i = 0; i <= TPG_COLOR_CSC_BLACK; i++) {
 				double r, g, b;
 
diff --git a/drivers/media/platform/vivid/vivid-tpg-colors.h b/drivers/media/platform/vivid/vivid-tpg-colors.h
index 86b8bf3..ada0cd1 100644
--- a/drivers/media/platform/vivid/vivid-tpg-colors.h
+++ b/drivers/media/platform/vivid/vivid-tpg-colors.h
@@ -61,8 +61,8 @@ enum tpg_color {
 extern const struct color tpg_colors[TPG_COLOR_MAX];
 extern const unsigned short tpg_rec709_to_linear[255 * 16 + 1];
 extern const unsigned short tpg_linear_to_rec709[255 * 16 + 1];
-extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_BT2020 + 1]
-					  [V4L2_XFER_FUNC_NONE + 1]
+extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1]
+					  [V4L2_XFER_FUNC_DCI_P3 + 1]
 					  [TPG_COLOR_CSC_BLACK + 1];
 
 #endif
-- 
2.1.4

