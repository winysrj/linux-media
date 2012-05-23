Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51782 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933706Ab2EWP10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 11:27:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 5/8] tw9910: Don't access the device in the g_mbus_fmt operation
Date: Wed, 23 May 2012 17:27:32 +0200
Message-Id: <1337786855-28759-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_mbus_fmt operation only needs to return the current mbus frame
format and doesn't need to configure the hardware to do so. Fix it to
avoid requiring the chip to be powered on when calling the operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/tw9910.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 8768efb..9f53eac 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -699,11 +699,9 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd,
 	struct tw9910_priv *priv = to_tw9910(client);
 
 	if (!priv->scale) {
-		int ret;
-		u32 width = 640, height = 480;
-		ret = tw9910_set_frame(sd, &width, &height);
-		if (ret < 0)
-			return ret;
+		priv->scale = tw9910_select_norm(priv->norm, 640, 480);
+		if (!priv->scale)
+			return -EINVAL;
 	}
 
 	mf->width	= priv->scale->width;
-- 
1.7.3.4

