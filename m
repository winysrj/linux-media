Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59146 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2GRN6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:58:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 1/9] ov772x: Fix memory leak in probe error path
Date: Wed, 18 Jul 2012 15:58:18 +0200
Message-Id: <1342619906-5820-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The control handler isn't freed if its initialization fails. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 641f6f4..0fede50d 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -1098,18 +1098,17 @@ static int ov772x_probe(struct i2c_client *client,
 			V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
-		int err = priv->hdl.error;
-
-		kfree(priv);
-		return err;
+		ret = priv->hdl.error;
+		goto done;
 	}
 
 	ret = ov772x_video_probe(client);
+
+done:
 	if (ret) {
 		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	}
-
 	return ret;
 }
 
-- 
1.7.8.6

