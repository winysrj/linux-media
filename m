Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43014 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbbCNLrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 07:47:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 21/22] marvell-ccic: replace RGB444 by XBGR444
Date: Sat, 14 Mar 2015 12:47:00 +0100
Message-Id: <1426333621-21474-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
References: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The RGB444 pixel format as implemented in this driver really implements
the variant where R and B are swapped, XBGR444. So replace RGB444 by XBGR444.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 5b60da1..55b3563 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -138,8 +138,8 @@ static struct mcam_format_struct {
 		.planar		= true,
 	},
 	{
-		.desc		= "RGB 444",
-		.pixelformat	= V4L2_PIX_FMT_RGB444,
+		.desc		= "BGR 444",
+		.pixelformat	= V4L2_PIX_FMT_XBGR444,
 		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
 		.bpp		= 2,
 		.planar		= false,
@@ -777,10 +777,9 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_SWAP24, C0_DF_MASK);
 		break;
-	case V4L2_PIX_FMT_RGB444:
+	case V4L2_PIX_FMT_XBGR444:
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
-		/* Alpha value? */
 		break;
 	case V4L2_PIX_FMT_RGB565:
 		mcam_reg_write_mask(cam, REG_CTRL0,
-- 
2.1.4

