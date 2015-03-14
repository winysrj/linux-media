Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43014 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbbCNLr4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 07:47:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 22/22] Fix V4L2_PIX_FMT_SBGGR8 support
Date: Sat, 14 Mar 2015 12:47:01 +0100
Message-Id: <1426333621-21474-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
References: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The REG_CTRL0 register was never written if this format was selected,
instead an error was logged and whatever was last set in that register
was used.

Surprisingly, that seems to work if YUYV was selected, but we should
program this register explicitly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 55b3563..6b62be1 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -785,6 +785,10 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 		mcam_reg_write_mask(cam, REG_CTRL0,
 			C0_DF_RGB | C0_RGBF_565 | C0_RGB5_BGGR, C0_DF_MASK);
 		break;
+	case V4L2_PIX_FMT_SBGGR8:
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_RGB | C0_RGB5_GRBG, C0_DF_MASK);
+		break;
 	default:
 		cam_err(cam, "camera: unknown format: %#x\n", fmt->pixelformat);
 		break;
-- 
2.1.4

