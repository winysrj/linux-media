Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbbCIVYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:24:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/18] marvell-ccic: drop V4L2_PIX_FMT_JPEG dead code
Date: Mon,  9 Mar 2015 22:22:20 +0100
Message-Id: <1425936143-5658-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver appeared to support the JPEG format when in reality
that was just dead code. Remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 2495ab6..1a32610 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -755,11 +755,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 		widthy = fmt->width * 2;
 		widthuv = 0;
 		break;
-	case V4L2_PIX_FMT_JPEG:
-		imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
-		widthy = fmt->bytesperline;
-		widthuv = 0;
-		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
@@ -797,10 +792,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
 		break;
-	case V4L2_PIX_FMT_JPEG:
-		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
-		break;
 	case V4L2_PIX_FMT_RGB444:
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
-- 
2.1.4

