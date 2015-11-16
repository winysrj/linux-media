Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54909 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbbKPEql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 23:46:41 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/4] v4l: vsp1: Fix LUT format setting
Date: Mon, 16 Nov 2015 06:46:42 +0200
Message-Id: <1447649205-1560-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LUT set format handler overrides the requested format by mistake.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lut.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 656ec272a414..e2c352a7dfd5 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -176,6 +176,7 @@ static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 		return 0;
 	}
 
+	format->code = fmt->format.code;
 	format->width = clamp_t(unsigned int, fmt->format.width,
 				LUT_MIN_SIZE, LUT_MAX_SIZE);
 	format->height = clamp_t(unsigned int, fmt->format.height,
-- 
2.4.10

