Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51781 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704Ab2EWP10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 11:27:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 4/8] ov772x: Don't access the device in the g_mbus_fmt operation
Date: Wed, 23 May 2012 17:27:31 +0200
Message-Id: <1337786855-28759-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_mbus_fmt operation only needs to return the current mbus frame
format and doesn't need to configure the hardware to do so. Fix it to
avoid requiring the chip to be powered on when calling the operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 74e77d3..6d79b89 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -880,15 +880,11 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 static int ov772x_g_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 
 	if (!priv->win || !priv->cfmt) {
-		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
-		int ret = ov772x_set_params(client, &width, &height,
-					    V4L2_MBUS_FMT_YUYV8_2X8);
-		if (ret < 0)
-			return ret;
+		priv->cfmt = &ov772x_cfmts[0];
+		priv->win = ov772x_select_win(VGA_WIDTH, VGA_HEIGHT);
 	}
 
 	mf->width	= priv->win->width;
-- 
1.7.3.4

