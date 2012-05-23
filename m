Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51782 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699Ab2EWP1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 11:27:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/8] ov2640: Don't access the device in the g_mbus_fmt operation
Date: Wed, 23 May 2012 17:27:30 +0200
Message-Id: <1337786855-28759-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_mbus_fmt operation only needs to return the current mbus frame
format and doesn't need to configure the hardware to do so. Fix it to
avoid requiring the chip to be powered on when calling the operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov2640.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 3c2c5d3..d9a427c 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -837,10 +837,7 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
 
 	if (!priv->win) {
 		u32 width = W_SVGA, height = H_SVGA;
-		int ret = ov2640_set_params(client, &width, &height,
-					    V4L2_MBUS_FMT_UYVY8_2X8);
-		if (ret < 0)
-			return ret;
+		priv->win = ov2640_select_win(&width, &height);
 	}
 
 	mf->width	= priv->win->width;
-- 
1.7.3.4

