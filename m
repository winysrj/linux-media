Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56889 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbbDXJxR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 05:53:17 -0400
Message-ID: <553A126F.7040102@xs4all.nl>
Date: Fri, 24 Apr 2015 11:52:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] marvell-ccic: fix RGB444 format
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RGB444 format swapped the red and blue components, fix this.

Rather than making a new BGR444 format (as I proposed initially), Jon prefers
to just fix this and return the colors in the right order. I think that makes
sense in this case.

Since the RGB444 pixel format is deprecated due to the ambiguous specification
of the alpha component we use the XRGB444 pixel format instead (specified as having
no alpha channel).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 3c12065..cc92ba5 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -138,8 +138,8 @@ static struct mcam_format_struct {
 		.planar		= true,
 	},
 	{
-		.desc		= "RGB 444",
-		.pixelformat	= V4L2_PIX_FMT_RGB444,
+		.desc		= "XRGB 444",
+		.pixelformat	= V4L2_PIX_FMT_XRGB444,
 		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
 		.bpp		= 2,
 		.planar		= false,
@@ -777,10 +777,9 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_SWAP24, C0_DF_MASK);
 		break;
-	case V4L2_PIX_FMT_RGB444:
+	case V4L2_PIX_FMT_XRGB444:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
-		/* Alpha value? */
+			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XBGR, C0_DF_MASK);
 		break;
 	case V4L2_PIX_FMT_RGB565:
 		mcam_reg_write_mask(cam, REG_CTRL0,
