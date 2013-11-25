Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56475 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KYJ6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:39 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00AOCD1PVC20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:37 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 01/16] s5p-jpeg: Reorder quantization tables
Date: Mon, 25 Nov 2013 10:58:08 +0100
Message-id: <1385373503-1657-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorder quantization tables so that their elements
are arranged in the manner reflecting compression
quality level that is in accordance with V4L2 documentation,
i.e. the larger value of the V4L2_CID_JPEG_COMPRESSION_QUALITY
control the better image quality, and thus lower compression
quality. The modification allows also to get rid of
reverse logic in the s_ctrl callback while assigning
user space value to the ctx->compr_quality variable.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |  116 +++++++++++++--------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 47934db..2234944 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -84,15 +84,25 @@ static struct s5p_jpeg_fmt formats_dec[] = {
 #define NUM_FORMATS_DEC ARRAY_SIZE(formats_dec)
 
 static const unsigned char qtbl_luminance[4][64] = {
-	{/* level 1 - high quality */
-		 8,  6,  6,  8, 12, 14, 16, 17,
-		 6,  6,  6,  8, 10, 13, 12, 15,
-		 6,  6,  7,  8, 13, 14, 18, 24,
-		 8,  8,  8, 14, 13, 19, 24, 35,
-		12, 10, 13, 13, 20, 26, 34, 39,
-		14, 13, 14, 19, 26, 34, 39, 39,
-		16, 12, 18, 24, 34, 39, 39, 39,
-		17, 15, 24, 35, 39, 39, 39, 39
+	{/*level 0 - high compression quality */
+		20, 16, 25, 39, 50, 46, 62, 68,
+		16, 18, 23, 38, 38, 53, 65, 68,
+		25, 23, 31, 38, 53, 65, 68, 68,
+		39, 38, 38, 53, 65, 68, 68, 68,
+		50, 38, 53, 65, 68, 68, 68, 68,
+		46, 53, 65, 68, 68, 68, 68, 68,
+		62, 65, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68
+	},
+	{/* level 1 */
+		16, 11, 11, 16, 23, 27, 31, 30,
+		11, 12, 12, 15, 20, 23, 23, 30,
+		11, 12, 13, 16, 23, 26, 35, 47,
+		16, 15, 16, 23, 26, 37, 47, 64,
+		23, 20, 23, 26, 39, 51, 64, 64,
+		27, 23, 26, 37, 51, 64, 64, 64,
+		31, 23, 35, 47, 64, 64, 64, 64,
+		30, 30, 47, 64, 64, 64, 64, 64
 	},
 	{/* level 2 */
 		12,  8,  8, 12, 17, 21, 24, 23,
@@ -104,38 +114,38 @@ static const unsigned char qtbl_luminance[4][64] = {
 		24, 18, 27, 36, 51, 59, 59, 59,
 		23, 23, 36, 53, 59, 59, 59, 59
 	},
-	{/* level 3 */
-		16, 11, 11, 16, 23, 27, 31, 30,
-		11, 12, 12, 15, 20, 23, 23, 30,
-		11, 12, 13, 16, 23, 26, 35, 47,
-		16, 15, 16, 23, 26, 37, 47, 64,
-		23, 20, 23, 26, 39, 51, 64, 64,
-		27, 23, 26, 37, 51, 64, 64, 64,
-		31, 23, 35, 47, 64, 64, 64, 64,
-		30, 30, 47, 64, 64, 64, 64, 64
-	},
-	{/*level 4 - low quality */
-		20, 16, 25, 39, 50, 46, 62, 68,
-		16, 18, 23, 38, 38, 53, 65, 68,
-		25, 23, 31, 38, 53, 65, 68, 68,
-		39, 38, 38, 53, 65, 68, 68, 68,
-		50, 38, 53, 65, 68, 68, 68, 68,
-		46, 53, 65, 68, 68, 68, 68, 68,
-		62, 65, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68
+	{/* level 3 - low compression quality */
+		 8,  6,  6,  8, 12, 14, 16, 17,
+		 6,  6,  6,  8, 10, 13, 12, 15,
+		 6,  6,  7,  8, 13, 14, 18, 24,
+		 8,  8,  8, 14, 13, 19, 24, 35,
+		12, 10, 13, 13, 20, 26, 34, 39,
+		14, 13, 14, 19, 26, 34, 39, 39,
+		16, 12, 18, 24, 34, 39, 39, 39,
+		17, 15, 24, 35, 39, 39, 39, 39
 	}
 };
 
 static const unsigned char qtbl_chrominance[4][64] = {
-	{/* level 1 - high quality */
-		 9,  8,  9, 11, 14, 17, 19, 24,
-		 8, 10,  9, 11, 14, 13, 17, 22,
-		 9,  9, 13, 14, 13, 15, 23, 26,
-		11, 11, 14, 14, 15, 20, 26, 33,
-		14, 14, 13, 15, 20, 24, 33, 39,
-		17, 13, 15, 20, 24, 32, 39, 39,
-		19, 17, 23, 26, 33, 39, 39, 39,
-		24, 22, 26, 33, 39, 39, 39, 39
+	{/*level 0 - high compression quality */
+		21, 25, 32, 38, 54, 68, 68, 68,
+		25, 28, 24, 38, 54, 68, 68, 68,
+		32, 24, 32, 43, 66, 68, 68, 68,
+		38, 38, 43, 53, 68, 68, 68, 68,
+		54, 54, 66, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68
+	},
+	{/* level 1 */
+		17, 15, 17, 21, 20, 26, 38, 48,
+		15, 19, 18, 17, 20, 26, 35, 43,
+		17, 18, 20, 22, 26, 30, 46, 53,
+		21, 17, 22, 28, 30, 39, 53, 64,
+		20, 20, 26, 30, 39, 48, 64, 64,
+		26, 26, 30, 39, 48, 63, 64, 64,
+		38, 35, 46, 53, 64, 64, 64, 64,
+		48, 43, 53, 64, 64, 64, 64, 64
 	},
 	{/* level 2 */
 		13, 11, 13, 16, 20, 20, 29, 37,
@@ -147,25 +157,15 @@ static const unsigned char qtbl_chrominance[4][64] = {
 		29, 26, 35, 40, 50, 59, 59, 59,
 		37, 32, 40, 50, 59, 59, 59, 59
 	},
-	{/* level 3 */
-		17, 15, 17, 21, 20, 26, 38, 48,
-		15, 19, 18, 17, 20, 26, 35, 43,
-		17, 18, 20, 22, 26, 30, 46, 53,
-		21, 17, 22, 28, 30, 39, 53, 64,
-		20, 20, 26, 30, 39, 48, 64, 64,
-		26, 26, 30, 39, 48, 63, 64, 64,
-		38, 35, 46, 53, 64, 64, 64, 64,
-		48, 43, 53, 64, 64, 64, 64, 64
-	},
-	{/*level 4 - low quality */
-		21, 25, 32, 38, 54, 68, 68, 68,
-		25, 28, 24, 38, 54, 68, 68, 68,
-		32, 24, 32, 43, 66, 68, 68, 68,
-		38, 38, 43, 53, 68, 68, 68, 68,
-		54, 54, 66, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68
+	{/* level 3 - low compression quality */
+		 9,  8,  9, 11, 14, 17, 19, 24,
+		 8, 10,  9, 11, 14, 13, 17, 22,
+		 9,  9, 13, 14, 13, 15, 23, 26,
+		11, 11, 14, 14, 15, 20, 26, 33,
+		14, 14, 13, 15, 20, 24, 33, 39,
+		17, 13, 15, 20, 24, 32, 39, 39,
+		19, 17, 23, 26, 33, 39, 39, 39,
+		24, 22, 26, 33, 39, 39, 39, 39
 	}
 };
 
@@ -834,7 +834,7 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
-		ctx->compr_quality = S5P_JPEG_COMPR_QUAL_WORST - ctrl->val;
+		ctx->compr_quality = ctrl->val;
 		break;
 	case V4L2_CID_JPEG_RESTART_INTERVAL:
 		ctx->restart_interval = ctrl->val;
@@ -863,7 +863,7 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 	if (ctx->mode == S5P_JPEG_ENCODE) {
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_COMPRESSION_QUALITY,
-				  0, 3, 1, 3);
+				  0, 3, 1, S5P_JPEG_COMPR_QUAL_WORST);
 
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_RESTART_INTERVAL,
-- 
1.7.9.5

