Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46623 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbbCKIKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 04:10:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 19/21] marvell-ccic: add XRGB444 and fix (X)RGB444 colors
Date: Wed, 11 Mar 2015 09:10:26 +0100
Message-Id: <1426061428-47019-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
References: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

After testing I discovered that the color ordering for the RGB444 format
was wrong. This is now fixed.

In addition support is added for the XRGB444 format, which is identical
to RGB444, but makes it explicit that there is no alpha, as is the
case here.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 3f016fb..17f5931 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -145,6 +145,13 @@ static struct mcam_format_struct {
 		.planar		= true,
 	},
 	{
+		.desc		= "XRGB 444",
+		.pixelformat	= V4L2_PIX_FMT_XRGB444,
+		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
+		.bpp		= 2,
+		.planar		= false,
+	},
+	{
 		.desc		= "RGB 444",
 		.pixelformat	= V4L2_PIX_FMT_RGB444,
 		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
@@ -794,8 +801,9 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_SWAP24, C0_DF_MASK);
 		break;
 	case V4L2_PIX_FMT_RGB444:
+	case V4L2_PIX_FMT_XRGB444:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
+			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XBGR, C0_DF_MASK);
 		/* Alpha value? */
 		break;
 	case V4L2_PIX_FMT_RGB565:
-- 
2.1.4

