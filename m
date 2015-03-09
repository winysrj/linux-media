Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:42531 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbbCIVbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:31:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/18] marvell-ccic: fix Y'CbCr ordering
Date: Mon,  9 Mar 2015 22:22:23 +0100
Message-Id: <1425936143-5658-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various formats had their byte ordering implemented incorrectly, and
the V4L2_PIX_FMT_UYVY is actually impossible to create, instead you
get V4L2_PIX_FMT_YVYU.

This was working before commit ad6ac452227b7cb93ac79beec092850d178740b1
("add new formats support for marvell-ccic driver"). That commit broke
the original format support and the OLPC XO-1 laptop showed wrong
colors ever since (if you are crazy enough to attempt to run the latest
kernel on it, like I did).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 16 ++++++++--------
 drivers/media/platform/marvell-ccic/mcam-core.h |  8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 9343051..4e3ef68 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -117,8 +117,8 @@ static struct mcam_format_struct {
 		.planar		= false,
 	},
 	{
-		.desc		= "UYVY 4:2:2",
-		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.desc		= "YVYU 4:2:2",
+		.pixelformat	= V4L2_PIX_FMT_YVYU,
 		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 		.planar		= false,
@@ -751,7 +751,7 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 
 	switch (fmt->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
 		widthy = fmt->width * 2;
 		widthuv = 0;
 		break;
@@ -778,20 +778,20 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	switch (fmt->pixelformat) {
 	case V4L2_PIX_FMT_YUV422P:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU, C0_DF_MASK);
+			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_UYVY, C0_DF_MASK);
 		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_420PL | C0_YUVE_YVYU, C0_DF_MASK);
+			C0_DF_YUV | C0_YUV_420PL | C0_YUVE_VYUY, C0_DF_MASK);
 		break;
 	case V4L2_PIX_FMT_YUYV:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_UYVY, C0_DF_MASK);
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_NOSWAP, C0_DF_MASK);
 		break;
-	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_SWAP24, C0_DF_MASK);
 		break;
 	case V4L2_PIX_FMT_RGB444:
 		mcam_reg_write_mask(cam, REG_CTRL0,
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 2847e06..97167f6 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -331,10 +331,10 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C0_YUVE_YVYU	  0x00010000	/* Y1CrY0Cb		*/
 #define	  C0_YUVE_VYUY	  0x00020000	/* CrY1CbY0		*/
 #define	  C0_YUVE_UYVY	  0x00030000	/* CbY1CrY0		*/
-#define	  C0_YUVE_XYUV	  0x00000000	/* 420: .YUV		*/
-#define	  C0_YUVE_XYVU	  0x00010000	/* 420: .YVU		*/
-#define	  C0_YUVE_XUVY	  0x00020000	/* 420: .UVY		*/
-#define	  C0_YUVE_XVUY	  0x00030000	/* 420: .VUY		*/
+#define	  C0_YUVE_NOSWAP  0x00000000	/* no bytes swapping	*/
+#define	  C0_YUVE_SWAP13  0x00010000	/* swap byte 1 and 3	*/
+#define	  C0_YUVE_SWAP24  0x00020000	/* swap byte 2 and 4	*/
+#define	  C0_YUVE_SWAP1324 0x00030000	/* swap bytes 1&3 and 2&4 */
 /* Bayer bits 18,19 if needed */
 #define	  C0_EOF_VSYNC	  0x00400000	/* Generate EOF by VSYNC */
 #define	  C0_VEDGE_CTRL   0x00800000	/* Detect falling edge of VSYNC */
-- 
2.1.4

