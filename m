Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52875 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab2GRNyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:54:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 3/9] ov2640: Don't access the device in the g_mbus_fmt operation
Date: Wed, 18 Jul 2012 15:53:58 +0200
Message-Id: <1342619644-5712-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342619644-5712-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342619644-5712-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_mbus_fmt operation only needs to return the current mbus frame
format and doesn't need to configure the hardware to do so. Fix it to
avoid requiring the chip to be powered on when calling the operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov2640.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 3c2c5d3..7c44d1f 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -837,10 +837,8 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
 
 	if (!priv->win) {
 		u32 width = W_SVGA, height = H_SVGA;
-		int ret = ov2640_set_params(client, &width, &height,
-					    V4L2_MBUS_FMT_UYVY8_2X8);
-		if (ret < 0)
-			return ret;
+		priv->win = ov2640_select_win(&width, &height);
+		priv->cfmt_code = V4L2_MBUS_FMT_UYVY8_2X8;
 	}
 
 	mf->width	= priv->win->width;
-- 
1.7.8.6

